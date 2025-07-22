package com.example.grouvy.chat.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

//화면을 표시하기 위한 컨트롤러이다.
@Controller
public class ChatController {

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

  @GetMapping("/chat/chatting")
  public String chattingRoom(@RequestParam("roomId")int roomId, Model model) {
    model.addAttribute("roomId", roomId);
    return "chat/chatting";
  }

}
