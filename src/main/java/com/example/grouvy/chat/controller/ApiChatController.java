package com.example.grouvy.chat.controller;

import com.example.grouvy.chat.dto.ApiResponse;
import com.example.grouvy.chat.dto.ChatMessageDto;
import com.example.grouvy.chat.dto.ChatRoomDto;
import com.example.grouvy.chat.dto.ChatUserInfo;
import com.example.grouvy.chat.dto.DeptAndUserDto;
import com.example.grouvy.chat.dto.ParentDeptDto;
import com.example.grouvy.chat.dto.ResponseEntityUtils;
import com.example.grouvy.chat.service.ChatService;
import com.example.grouvy.chat.vo.ChatRoom;
import com.example.grouvy.security.SecurityUser;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/chat")
public class ApiChatController {

  @Autowired
  private ChatService chatService;
  /**
   * 같은 부서 직원 리스트 가져오기
   * @param departmentNo
   * @param securityUser
   * @return
   */
  @GetMapping("/friends")
  public ResponseEntity<ApiResponse<List<ParentDeptDto>>> getFriendListByDeptNo(
      @RequestParam("deptNo") int departmentNo,
      @AuthenticationPrincipal SecurityUser securityUser) {
    int userId = securityUser.getUser().getUserId();
    List<ParentDeptDto> data = chatService.getMyListByDeptNo(departmentNo, userId);
    return ResponseEntityUtils.ok(data);
  }

  /**
   * 내가 친구 추가한 유저 리스트를 반환한다.
   * @param securityUser
   * @return
   */
  @GetMapping("/myWishList")
  public ResponseEntity<ApiResponse<List<DeptAndUserDto>>> getMyWishListByUserId(@AuthenticationPrincipal SecurityUser securityUser) {
    int userId = securityUser.getUser().getUserId();
    List<DeptAndUserDto> data = chatService.getMyWishListByUserId(userId);
    return ResponseEntityUtils.ok(data);
  }

  //User의 개인정보를 비동기 통신으로 반환
  @GetMapping("/userInfo")
  public ResponseEntity<ApiResponse<ChatUserInfo>> getUserInfoByUserId(@RequestParam("userId") int userId) {
    ChatUserInfo chatUserInfo = chatService.getUserInfoByUserId(userId);
    return ResponseEntityUtils.ok(chatUserInfo);
  }

  //로그인한 사용자와 지정된 사용자를 이용하여, 이 둘의 채팅방을 반환한다.
  @PostMapping
  public ResponseEntity<ApiResponse<ChatRoom>> getRoomIdByUserData
  (@RequestBody Map<String, Object> userData,
   @AuthenticationPrincipal SecurityUser securityUser) {     //ajax, POST 요청을 했을 경우, @RequestBody로 받아서, Map객체에 바로 바인딩.
    List<Integer> userIds = (List<Integer>) userData.get("id");
    String roomName =  userData.get("name").toString();
    int userId = securityUser.getUser().getUserId();

    ChatRoom chatRoom = chatService.getOrCreateChatRoomByUserId(userIds,roomName,userId);
    return ResponseEntityUtils.ok(chatRoom);
  }


  // roomId로 그 채팅방의 메세지들을 조회한다.
  @GetMapping("/loadMessage")
  public ResponseEntity<ApiResponse<List<ChatMessageDto>>> loadMessage(@RequestParam("roomId") int roomId,
                                                                       @AuthenticationPrincipal SecurityUser securityUser) {
    int userId = securityUser.getUser().getUserId();
//    List<ChatMessageDto> messages = chatService.getChatMessageByRoomId(roomId,userId);
    List<ChatMessageDto> messages = chatService.getChatMessageByRoomId(roomId, userId);
    return  ResponseEntityUtils.ok(messages);
  }

  // 대표 이사 부서를 제외한, 부서별 직원 리스트를 호출한다.
  @GetMapping("/allUser")
  public ResponseEntity<ApiResponse<List<DeptAndUserDto>>> loadDeptAndUserData(@RequestParam("roomId") int roomId) {
    List<DeptAndUserDto> list = chatService.getDeptAndUser(roomId);
    return ResponseEntityUtils.ok(list);
  }


  // 사용자가 나가기 버튼을 눌렀을 경우, 그 사용자를 채팅방 참여자 테이블에서 is_active 컬럼의 상태를 N으로 변경.
  @PostMapping("/leftRoom")
  public ResponseEntity<ApiResponse<Void>> getLeftRoomByUserData(@RequestBody Map<String, Object> data) {
    int userId = Integer.parseInt(data.get("userId").toString());
    int roomId = Integer.parseInt(data.get("roomId").toString());
    chatService.deleteChatRoomUser(roomId,userId);
    return ResponseEntityUtils.ok("삭제되었습니다.");
  }

  @GetMapping("/chattingRoom")
  public ResponseEntity<ApiResponse<List<ChatRoomDto>>> getChatRoomList(@AuthenticationPrincipal SecurityUser securityUser) {
    int userId = securityUser.getUser().getUserId();
    List<ChatRoomDto> list = chatService.getChatRoomList(userId);
    return ResponseEntityUtils.ok(list);
  }

  @GetMapping("/organizations")
  public ResponseEntity<ApiResponse<List<ParentDeptDto>>> getOrganization() {
    List<ParentDeptDto> parentDeptDtos = chatService.getOrganization();
    return  ResponseEntityUtils.ok(parentDeptDtos);
  }

  @PostMapping("/wisiList")
  public ResponseEntity<ApiResponse<Void>> addWishList(@RequestBody Map<String, Object> data,
                                                       @AuthenticationPrincipal SecurityUser securityUser) {
    int userId = securityUser.getUser().getUserId();
    List<Integer> userIds = (List<Integer>) data.get("id");
    chatService.addWishList(userIds, userId);
    return ResponseEntityUtils.ok("추가 되었습니다.");
  }

}
