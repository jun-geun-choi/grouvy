package com.example.grouvy.notification.controller;

import com.example.grouvy.message.dto.PaginationResponse;
import com.example.grouvy.notification.service.NotificationService;
import com.example.grouvy.notification.service.SseService;
import com.example.grouvy.notification.service.UnreadCountService;
import com.example.grouvy.notification.vo.Notification;
import com.example.grouvy.security.SecurityUser;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/notifications")
public class NotificationRestController {

    private final NotificationService notificationService;
    private final SseService sseService;
    private final UnreadCountService unreadCountService;

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

    /**
     * 클라이언트가 실시간 알림을 받기 위해 SSE 연결을 요청하는 엔드포인트입니다.
     * @param securityUser 현재 인증된 사용자 정보
     * @return SseEmitter 객체. 이 객체를 통해 서버는 클라이언트로 이벤트를 보낼 수 있습니다.
     */
    @GetMapping(value = "/connect", produces = "text/event-stream")
    public SseEmitter connect(@AuthenticationPrincipal SecurityUser securityUser) {
        if (securityUser == null) {
            // 이 경우 예외를 발생시켜 클라이언트의 EventSource가 재연결을 시도하지 않도록 할 수 있습니다.
            // 혹은 null을 반환하여 연결이 실패했음을 알릴 수 있습니다.
            throw new IllegalArgumentException("인증된 사용자가 아닙니다.");
        }
        int userId = securityUser.getUser().getUserId();

        //SseEmitter를 생성하고 등록
        SseEmitter emitter = sseService.addEmitter(userId);
        //연결직후 현재의 읽지않은 카운트를 즉시 전송.
        unreadCountService.updateAndSendUnreadCount(userId);
        return emitter;
    }
}
