package com.example.grouvy.notification.controller;

import com.example.grouvy.message.dto.PaginationResponse;
import com.example.grouvy.notification.service.NotificationService;
import com.example.grouvy.notification.vo.Notification;
import com.example.grouvy.security.SecurityUser;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/notifications")
public class NotificationRestController {

    private final NotificationService notificationService;

    @GetMapping("/list")
    public ResponseEntity<PaginationResponse<Notification>> getNotifications(
            @AuthenticationPrincipal SecurityUser securityUser,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size) {
        if (securityUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        int userId = securityUser.getUser().getUserId();

        PaginationResponse<Notification> notifications = notificationService.getNotificationsByUserId(userId, page, size);
        return ResponseEntity.ok(notifications);
    }

    @PostMapping("/readAll")
    public ResponseEntity<Map<String, Object>> markAllNotificationsAsRead(
            @AuthenticationPrincipal SecurityUser securityUser) {
        if (securityUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        int userId = securityUser.getUser().getUserId();
        int count = notificationService.markAllAsRead(userId);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", count + "개의 알림을 읽음 처리했습니다.");
        response.put("count", count);
        return ResponseEntity.ok(response);
    }
}
