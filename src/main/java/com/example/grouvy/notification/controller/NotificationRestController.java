// src/main/java/com/example/grouvy/notification/controller/NotificationRestController.java
package com.example.grouvy.notification.controller;

import com.example.grouvy.message.dto.PaginationResponse;
import com.example.grouvy.notification.service.NotificationService; // NotificationService 임포트
import com.example.grouvy.notification.service.SseService; // SseService 임포트
import com.example.grouvy.notification.service.UnreadCountService; // UnreadCountService 임포트
import com.example.grouvy.notification.vo.Notification; // Notification VO 임포트 (SSE로 전송할 때 사용)
import com.example.grouvy.user.vo.User; // User VO 임포트 (세션에서 userId 가져올 때)

import jakarta.servlet.http.HttpSession; // HttpSession 임포트
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus; // HTTP 상태 코드 임포트
import org.springframework.http.ResponseEntity; // ResponseEntity 임포트
import org.springframework.web.bind.annotation.*; // 모든 HTTP 메서드 어노테이션 임포트
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter; // SseEmitter 임포트

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController // RESTful 웹 서비스를 처리하는 컨트롤러
@RequiredArgsConstructor
@RequestMapping("/api/v1/notifications") // 알림 관련 API 기본 경로
public class NotificationRestController {

    private final NotificationService notificationService;
    private final SseService sseService; // SSE 연결 및 알림 푸시 서비스
    private final UnreadCountService unreadCountService; // 읽지 않은 카운트 업데이트 서비스

    /**
     * 특정 사용자에게 SSE 연결을 설정하고 초기 알림/쪽지 카운트를 전송합니다.
     * 클라이언트(브라우저)에서 EventSource API를 통해 이 엔드포인트로 연결합니다.
     *
     * @param session 현재 HTTP 세션 (userId를 가져오기 위함)
     * @return SseEmitter 객체
     */
    @GetMapping("/sse/connect") // SSE 연결을 위한 엔드포인트
    public SseEmitter connectSse(HttpSession session) {
        User currentUser = (User) session.getAttribute("selectedUser");
        if (currentUser == null || currentUser.getUserId() == null) {
            // 발신자 정보가 없으면 연결 거부 (SSE 연결은 인증된 사용자에게만)
            throw new RuntimeException("SSE 연결을 위한 사용자 정보가 세션에 없습니다."); // 클라이언트는 500 에러를 받음
        }
        Long userId = currentUser.getUserId();

        SseEmitter emitter = sseService.addEmitter(userId); // SseService에 Emitter 등록
        // Emitter 등록 후, 즉시 현재 읽지 않은 카운트를 전송
        unreadCountService.updateAndSendUnreadCounts(userId);
        return emitter;
    }

    /**
     * 특정 사용자(userId)의 알림 목록을 페이징하여 JSON 형태로 반환하는 API입니다.
     *
     * @param session 현재 세션
     * @param page    요청 페이지 번호 (1부터 시작, 기본값 1)
     * @param size    한 페이지당 항목 수 (기본값 10)
     * @return 페이징 처리된 Notification 목록이 포함된 PaginationResponse
     */
    @GetMapping("/list")
    public ResponseEntity<PaginationResponse<Notification>> getNotifications(
            HttpSession session,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size) {
        User currentUser = (User) session.getAttribute("selectedUser");
        if (currentUser == null || currentUser.getUserId() == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }
        Long userId = currentUser.getUserId();
        PaginationResponse<Notification> notifications = notificationService.getNotificationsByUserId(userId, page, size);
        return ResponseEntity.ok(notifications);
    }

    /**
     * 특정 알림을 읽음 처리하는 API입니다.
     *
     * @param notificationId 읽음 처리할 알림의 NOTIFICATION_ID
     * @param session 현재 세션
     * @return 성공 여부 메시지
     */
    @PostMapping("/markAsRead/{notificationId}") // POST 요청, PathVariable 사용
    public ResponseEntity<Map<String, Object>> markNotificationAsRead(
            @PathVariable("notificationId") Long notificationId,
            HttpSession session) {
        User currentUser = (User) session.getAttribute("selectedUser");
        if (currentUser == null || currentUser.getUserId() == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }
        // 알림 읽음 처리 시 userId 검증은 NotificationService에서 수행
        notificationService.markNotificationAsRead(notificationId); // 서비스에서 userId 검증 및 카운트 업데이트
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "알림을 읽음 처리했습니다.");
        return ResponseEntity.ok(response);
    }

    /**
     * 특정 알림을 삭제 처리하는 API입니다.
     *
     * @param notificationId 삭제할 알림의 NOTIFICATION_ID
     * @param session 현재 세션
     * @return 성공 여부 메시지
     */
    @PostMapping("/delete/{notificationId}") // POST 요청, PathVariable 사용
    public ResponseEntity<Map<String, Object>> deleteNotification(
            @PathVariable("notificationId") Long notificationId,
            HttpSession session) {
        User currentUser = (User) session.getAttribute("selectedUser");
        if (currentUser == null || currentUser.getUserId() == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }
        Long userId = currentUser.getUserId();

        try {
            boolean success = notificationService.deleteNotification(notificationId, userId);
            Map<String, Object> response = new HashMap<>();
            if (success) {
                response.put("success", true);
                response.put("message", "알림을 삭제했습니다.");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "알림 삭제에 실패했습니다. (권한 없거나 이미 삭제됨)");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "알림 삭제 중 오류 발생: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    /**
     * 특정 사용자의 모든 알림을 삭제 처리하는 API입니다.
     *
     * @param session 현재 세션
     * @return 성공 여부 메시지
     */
    @PostMapping("/deleteAll") // POST 요청
    public ResponseEntity<Map<String, Object>> deleteAllNotifications(HttpSession session) {
        User currentUser = (User) session.getAttribute("selectedUser");
        if (currentUser == null || currentUser.getUserId() == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }
        Long userId = currentUser.getUserId();

        try {
            boolean success = notificationService.deleteAllNotifications(userId);
            Map<String, Object> response = new HashMap<>();
            if (success) {
                response.put("success", true);
                response.put("message", "모든 알림을 삭제했습니다.");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "알림 전체 삭제에 실패했습니다.");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "알림 전체 삭제 중 오류 발생: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    /**
     * 선택된 알림들을 삭제 처리하는 API입니다.
     *
     * @param notificationIds 삭제할 알림 ID 목록 (JSON Array 형태의 요청 본문)
     * @param session 현재 세션
     * @return 성공 여부 메시지
     */
    @PostMapping("/deleteSelected") // POST 요청, RequestBody로 ID 목록 받음
    public ResponseEntity<Map<String, Object>> deleteSelectedNotifications(
            @RequestBody List<Long> notificationIds,
            HttpSession session) {
        User currentUser = (User) session.getAttribute("selectedUser");
        if (currentUser == null || currentUser.getUserId() == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }
        Long userId = currentUser.getUserId();

        if (notificationIds == null || notificationIds.isEmpty()) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "삭제할 알림을 선택해주세요.");
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
        }

        try {
            boolean success = notificationService.deleteSelectedNotifications(notificationIds, userId);
            Map<String, Object> response = new HashMap<>();
            if (success) {
                response.put("success", true);
                response.put("message", "선택된 알림들을 삭제했습니다.");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "선택된 알림 삭제에 실패했습니다.");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "선택된 알림 삭제 중 오류 발생: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }
}