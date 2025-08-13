package com.example.grouvy.chat.controller;

import com.example.grouvy.chat.dto.ChatMessageDto;
import com.example.grouvy.chat.service.ChatService;
import com.example.grouvy.chat.vo.ChatMessage;
import com.example.grouvy.chat.vo.ChatRoom;
import com.example.grouvy.chat.vo.ChatRoomUser;
import com.example.grouvy.security.SecurityUser;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
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


  /**
   * 채팅방으로 이동을 하는 메소드.
   * 1:1 채팅방인 경우, Model 객체에 상대방 사용자 이름으로한 roomName, roomId, userIds
   * 그룹채팅방의 경우, Model 객체에 DB에서 가져온 roomName, roomId, userIds
   * @param roomId
   * @param model
   * @param securityUser
   * @return
   * @throws Exception
   */
  @GetMapping("/chat/chatting")
  public String chattingRoom(@RequestParam("roomId") int roomId,
      Model model, @AuthenticationPrincipal SecurityUser securityUser) throws Exception{

    int myUserId = securityUser.getUser().getUserId();
    ChatRoomUser otherUser = null;                         // 1:1 채팅일 시, 다른 사용자 정보를 넣기 위함.

    ChatRoom chatRoom = chatService.getChatRoomByRoomId(roomId);
    List<ChatRoomUser> users = chatService.getChatRoomUserByRoomId(roomId);

    //1:1인 경우
    if(chatRoom.getIsGroup().equals("N")) {
      for (ChatRoomUser user : users) {
        if (user.getUserId() != myUserId) {
          otherUser = user;
          break;
        }
      }
        model.addAttribute("roomName", otherUser.getUser().getName());
    } else { // 그룹인 경우
        model.addAttribute("roomName", chatRoom.getRoomName());
    }

    //이 유저 리스트를 userId만 뽑아서, model에 담아서 보내기
    List<Integer> userIds = new ArrayList<>();
    for(ChatRoomUser  user : users) {
      userIds.add(user.getUserId());
    }
    ObjectMapper mapper = new ObjectMapper();
    String json = mapper.writeValueAsString(userIds);
    model.addAttribute("userIds",json);
    model.addAttribute("roomId", roomId);
    model.addAttribute("isGroup", chatRoom.getIsGroup());
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
      , Authentication authentication) {
    /*Authentication authentication
       => 나의 로그인 정보가 담긴 객체이고, (현재 로그인한 사용자 정보) - 비밀번호, 권한, 인증이 되었는가, 찐 사용자 정보(UserDetail 구현체)
       => 여기서, getPrincipal을 해야 사용자 정보를 가져올 수 있고..
     */

    // 인증 여부 확인
    if (authentication == null || !authentication.isAuthenticated()) {
      return;
    }

    // 사용자 정보 확인
    SecurityUser securityUser = (SecurityUser) authentication.getPrincipal();
    if (securityUser == null) {
      System.out.println("사용자 정보가 없습니다., 에러 처리");
      return;
    }

    //이 채팅방이 1:1 채팅방인지 확인하는 서비스 메소드 호출
    int currentRoomId = message.getRoomId();
    chatService.checkOneToOneChatRoom(currentRoomId);

    // 메세지 DB에 등록. - roomId,content, messageType은 이 메소드 호출하면서 자동 바인딩.
    int userId = securityUser.getUser().getUserId();
    message.setSenderId(userId);

    // 메세지를 DB에 등록 -> 마지막 메세지도 채팅방 테이블에 등록 -> 메세지 DTO 객체에 바인딩 시켜 반환.
    //이 메세지에는, 메세지 내용, roomId, 메세지 타입, userId이 들어 있다.
    ChatMessageDto dto = chatService.addMessageService(message);

    simpMessagingTemplate.convertAndSend("/topic/chatting?roomId=" + dto.getRoomId(),
        dto);       // 브로드 캐스트

    String userName = null;
    List<ChatRoomUser> users = chatService.getChatRoomUserByRoomId(dto.getRoomId());

    for(ChatRoomUser user1: users) {
      System.out.println(user1.getUser().getName());
      if(user1.getUserId() != userId) {
        userName = user1.getUser().getEmail();
        simpMessagingTemplate.convertAndSendToUser(userName, "/queue/messages",
            dto);
        //여기서 userName 스프링 시큐리티에서 username을 집어 넣어야 한다.
      }
    }
  }

  // 채팅방의 메세지를 읽기 위한 메소드
  @MessageMapping("/chatRead")
  public void chatRead(@Payload Map<String, Object> payload, Authentication authentication) {
    if (authentication == null || !authentication.isAuthenticated()) return;
    SecurityUser securityUser = (SecurityUser) authentication.getPrincipal();
    if (securityUser == null) return;

    // payload: { roomId: number, readUpTo: number }
    int roomId = ((Number) payload.get("roomId")).intValue();
    long readUpTo = ((Number) payload.get("readUpTo")).longValue();
    int userId = securityUser.getUser().getUserId();

    // DB 갱신 (Service에 방금 추가한 메서드 호출)
    chatService.markRead(roomId, readUpTo, userId);

    // 같은 방에 브로드캐스트 (네 JSP가 이미 구독 중인 경로)
    Map<String, Object> out = new java.util.HashMap<>();
    out.put("roomId", roomId);
    out.put("readerId", userId);
    out.put("readUpTo", readUpTo);
    simpMessagingTemplate.convertAndSend("/topic/chat.read?roomId=" + roomId, out);
  }



}
