package com.example.grouvy.chat.controller;

import com.example.grouvy.chat.dto.ChatMessageDto;
import com.example.grouvy.chat.service.ChatService;
import com.example.grouvy.chat.vo.ChatMessage;
import com.example.grouvy.security.SecurityUser;
import com.example.grouvy.user.vo.User;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

//화면을 표시하기 위한 컨트롤러이다.
@Controller
public class ChatController {

  @Autowired
  private ChatService chatService;

  @Autowired
  private SimpMessagingTemplate simpMessagingTemplate;

  @GetMapping("/chat/friends")
  public String chatSideBarFriends() {
    return "chat/friends";
  }

  @GetMapping("/chat/organization")
  public String chatSideBarOrganization() {
    return "chat/organization";
  }

  @GetMapping("/chat/chatrooms")
  public String chatSideBarChatrooms() {
    return "chat/chatrooms";
  }

  // 채팅방으로 이동!
  @GetMapping("/chat/chatting")
  public String chattingRoom(@RequestParam("roomId") int roomId,Model model, Authentication  authentication) {

    //roomId로 이 채팅방의 사용자 정보를 조회 하여, 내가 아닌 다른 사람의 채팅방의 이름으로 하기 위한 설계(1:1 채팅에만 적용)
    SecurityUser securityUser = (SecurityUser) authentication.getPrincipal();
    int myUserId = securityUser.getUser().getUserId();
    List<User> users = chatService.getChatRoomUserByRoomId(roomId);
    User otherUser = null;

    for (User user : users) {
      if(user.getUserId() != myUserId) {
        otherUser = user;
        break;
      }
    }
    if(otherUser != null) {
      model.addAttribute("roomName", otherUser.getName());
    }
    model.addAttribute("roomId", roomId);
    return "chat/chatting";
  }

  /* STOMP 프로토콜 메세지
     헤더
      {}
     본문
      content : "메세지 샘플입니다.",
      messageType: "대화",
      roomId: 7
   */
  @MessageMapping("/chatSend")
  public void sendChattingMessage(@Payload ChatMessage message
                                  ,Authentication authentication) {
    /*Authentication authentication
       => 나의 로그인 정보가 담긴 객체이고, (현재 로그인한 사용자 정보) - 비밀번호, 권한, 인증이 되었는가, 찐 사용자 정보(UserDetail 구현체)
       => 여기서, getPrincipal을 해야 사용자 정보를 가져올 수 있고..
     */

    // 인증 여부 확인
    if(authentication == null ||  !authentication.isAuthenticated()) {
      return;
    }

    // 사용자 정보 확인
    SecurityUser securityUser = (SecurityUser) authentication.getPrincipal();
    if(securityUser == null) {
      System.out.println("사용자 정보가 없습니다., 에러 처리");
      return ;
    }

    // 메세지 DB에 등록. - roomId,content, messageType은 이 메소드 호출하면서 자동 바인딩.
    int userId = securityUser.getUser().getUserId();
    User user = chatService.getUserByUserId(userId);
    message.setSenderId(userId);
    message.setUser(user);
    chatService.insertChatMessage(message);
    long messageId = message.getChatMessageId();
    ChatMessageDto chatMessage = chatService.getChatMessage(messageId);

    simpMessagingTemplate.convertAndSend("/topic/chatting?roomId="+message.getRoomId(), chatMessage);       // 브로드 캐스트
    simpMessagingTemplate.convertAndSendToUser(Integer.toString(userId),"/queue/messages",chatMessage );    // 특정 유저에게만 이 메세지를 할당한다.
  }
}
