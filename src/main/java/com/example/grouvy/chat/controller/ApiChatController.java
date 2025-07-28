package com.example.grouvy.chat.controller;

import com.example.grouvy.chat.dto.ApiResponse;
import com.example.grouvy.chat.dto.ChatMyList;
import com.example.grouvy.chat.dto.ChatUserInfo;
import com.example.grouvy.chat.dto.ResponseEntityUtils;
import com.example.grouvy.chat.service.ChatService;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
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

  //같은 부서 사람들의 리스트를 비동기 통신으로 반환
  @GetMapping("/friends")
  public ResponseEntity<ApiResponse<List<ChatMyList>>> getFriendListByDeptNo(
      @RequestParam("deptNo") int departmentNo, @RequestParam("userId") int userId) {
    List<ChatMyList> data = chatService.getMyListByDeptNo(departmentNo, userId);
    return ResponseEntityUtils.ok(data);
  }

  //User의 개인정보를 비동기 통신으로 반환
  @GetMapping("/userInfo")
  public ResponseEntity<ApiResponse<ChatUserInfo>> getUserInfoByUserId(@RequestParam("userId") int userId) {
    ChatUserInfo chatUserInfo = chatService.getUserInfoByUserId(userId);
    return ResponseEntityUtils.ok(chatUserInfo);
  }

  // roomId를 비동기 통신으로 반환
  @PostMapping
  public ResponseEntity<ApiResponse<Integer>> getRoomId(@RequestBody Map<String, Object> userData) {
    int myUserId = Integer.parseInt(userData.get("userId").toString());
    int selectUserid =  Integer.parseInt(userData.get("selectUserId").toString());
    int roomId = chatService.getRoomIdByUserId(myUserId,selectUserid);

    return ResponseEntityUtils.ok(roomId);
  }
}
