package com.example.grouvy.notification.controller;

import com.example.grouvy.security.SecurityUser;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequiredArgsConstructor
@RequestMapping("/notification")
public class NotificationController {

    @GetMapping("/list")
    public String getNotificationListPage(Model model, @AuthenticationPrincipal SecurityUser securityUser) {
        if (securityUser == null) {
            model.addAttribute("errorMessage", "로그인 정보가 없습니다.");
        } else {
            model.addAttribute("currentUser", securityUser.getUser());
        }
        model.addAttribute("currentPage", "notificationList");
        return "notification/notification_list";
    }
}
