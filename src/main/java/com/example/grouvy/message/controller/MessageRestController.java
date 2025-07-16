// src/main/java/com/example/grouvy/message/controller/MessageRestController.java
package com.example.grouvy.message.controller;

import com.example.grouvy.message.dto.MessageSendRequestDto;
import com.example.grouvy.message.dto.MessageDetailResponseDto;
import com.example.grouvy.message.dto.MessageSentResponseDto;
import com.example.grouvy.message.dto.PaginationResponse; // PaginationResponse 임포트
import com.example.grouvy.message.service.MessageService;
import com.example.grouvy.message.vo.MessageReceiver;
import com.example.grouvy.user.vo.User;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*; // @RequestMapping, @PostMapping, @GetMapping 등 임포트

import java.util.HashMap;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/messages") // 메시지 관련 API의 기본 경로
public class MessageRestController {

    private final MessageService messageService;

    // --- 쪽지 발송 API (기존) ---
    @PostMapping("/send")
    public ResponseEntity<Map<String, Object>> sendMessage(@RequestBody MessageSendRequestDto messageDto, HttpSession session) {
        User senderUser = (User) session.getAttribute("selectedUser");
        if (senderUser == null || senderUser.getUserId() == null) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "발신자 정보가 세션에 없습니다. 조직도에서 발신자를 먼저 선택해주세요.");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorResponse); // 401 Unauthorized
        }
        Long senderId = senderUser.getUserId();

        try {
            Long msgId = messageService.sendMessage(messageDto, senderId);
            Map<String, Object> successResponse = new HashMap<>();
            successResponse.put("success", true);
            successResponse.put("message", "쪽지가 성공적으로 발송되었습니다.");
            successResponse.put("msgId", msgId);
            return ResponseEntity.ok(successResponse);
        } catch (IllegalArgumentException e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", e.getMessage() != null ? e.getMessage() : "유효하지 않은 수신자 정보 또는 필수 필드 누락.");
            return ResponseEntity.badRequest().body(errorResponse);
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "쪽지 발송 중 알 수 없는 오류가 발생했습니다. 관리자에게 문의하세요.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    // --- **새로 추가될 쪽지함 목록 조회 및 상세 보기, 액션 API** ---

    /**
     * 받은 쪽지함 목록을 페이징하여 JSON 형태로 반환하는 API입니다.
     *
     * @param session 현재 세션 (수신자 ID를 가져오기 위함)
     * @param page    요청 페이지 번호 (1부터 시작, 기본값 1)
     * @param size    한 페이지당 항목 수 (기본값 10)
     * @return 페이징 처리된 MessageReceiver 목록이 포함된 PaginationResponse
     */
    @GetMapping("/inbox")
    public ResponseEntity<PaginationResponse<MessageReceiver>> getInboxMessages(
            HttpSession session,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size) {
        User currentUser = (User) session.getAttribute("selectedUser");
        if (currentUser == null || currentUser.getUserId() == null) {
            // 발신자 정보 없음을 401 Unauthorized로 처리
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }
        Long receiverId = currentUser.getUserId();
        PaginationResponse<MessageReceiver> messages = messageService.getReceivedMessages(receiverId, page, size);
        return ResponseEntity.ok(messages);
    }

    /**
     * 중요 쪽지함 목록을 페이징하여 JSON 형태로 반환하는 API입니다.
     *
     * @param session 현재 세션
     * @param page    요청 페이지 번호
     * @param size    한 페이지당 항목 수
     * @return 페이징 처리된 MessageReceiver 목록
     */
    @GetMapping("/important")
    public ResponseEntity<PaginationResponse<MessageReceiver>> getImportantMessages(
            HttpSession session,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size) {
        User currentUser = (User) session.getAttribute("selectedUser");
        if (currentUser == null || currentUser.getUserId() == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }
        Long receiverId = currentUser.getUserId();
        PaginationResponse<MessageReceiver> messages = messageService.getImportantMessages(receiverId, page, size);
        return ResponseEntity.ok(messages);
    }

    /**
     * 보낸 쪽지함 목록을 페이징하여 JSON 형태로 반환하는 API입니다.
     *
     * @param session 현재 세션
     * @param page    요청 페이지 번호
     * @param size    한 페이지당 항목 수
     * @return 페이징 처리된 MessageSentResponseDto 목록
     */
    @GetMapping("/sentbox")
    public ResponseEntity<PaginationResponse<MessageSentResponseDto>> getSentboxMessages(
            HttpSession session,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size) {
        User currentUser = (User) session.getAttribute("selectedUser");
        if (currentUser == null || currentUser.getUserId() == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }
        Long senderId = currentUser.getUserId();
        PaginationResponse<MessageSentResponseDto> messages = messageService.getSentMessages(senderId, page, size);
        return ResponseEntity.ok(messages);
    }

    /**
     * 특정 쪽지의 상세 정보를 JSON 형태로 반환하는 API입니다.
     *
     * @param messageId 조회할 쪽지의 MESSAGE_ID
     * @param session 현재 세션 (조회 권한 확인 및 읽음 처리 위함)
     * @return MessageDetailResponseDto, 또는 권한 없음/쪽지 없음 시 404/403 응답
     */
    @GetMapping("/detail/{messageId}") // PathVariable 사용
    public ResponseEntity<MessageDetailResponseDto> getMessageDetail(
            @PathVariable("messageId") Long messageId,
            HttpSession session) {
        User currentUser = (User) session.getAttribute("selectedUser");
        if (currentUser == null || currentUser.getUserId() == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null); // 401 Unauthorized
        }
        Long currentUserId = currentUser.getUserId();

        MessageDetailResponseDto messageDetail = messageService.getMessageDetail(messageId, currentUserId);

        if (messageDetail == null) {
            // 쪽지를 찾을 수 없거나, 조회 권한이 없는 경우 (Service에서 null 반환)
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null); // 404 Not Found
        }
        return ResponseEntity.ok(messageDetail); // 200 OK
    }

    /**
     * 보낸 쪽지를 회수하는 API입니다.
     *
     * @param messageId 회수할 쪽지의 MESSAGE_ID
     * @param session 현재 세션 (발신자 확인)
     * @return 성공 여부 메시지
     */
    @PostMapping("/recall/{messageId}") // POST 요청으로 변경
    public ResponseEntity<Map<String, Object>> recallMessage(
            @PathVariable("messageId") Long messageId,
            HttpSession session) {
        User currentUser = (User) session.getAttribute("selectedUser");
        if (currentUser == null || currentUser.getUserId() == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }
        Long currentUserId = currentUser.getUserId();

        try {
            boolean success = messageService.recallMessage(messageId, currentUserId);
            Map<String, Object> response = new HashMap<>();
            if (success) {
                response.put("success", true);
                response.put("message", "쪽지가 성공적으로 회수되었습니다.");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "쪽지 회수에 실패했습니다. (이미 모든 수신자가 읽었거나, 회수 불가능한 쪽지입니다)");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response); // 400 Bad Request
            }
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "쪽지 회수 중 오류 발생: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    /**
     * 받은 쪽지함에서 쪽지를 삭제 처리하는 API입니다.
     *
     * @param receiveId 삭제할 수신 기록의 RECEIVE_ID
     * @param session 현재 세션
     * @return 성공 여부 메시지
     */
    @PostMapping("/inbox/delete/{receiveId}") // POST 요청으로 변경, PathVariable 사용
    public ResponseEntity<Map<String, Object>> deleteInboxMessage(
            @PathVariable("receiveId") Long receiveId,
            HttpSession session) {
        User currentUser = (User) session.getAttribute("selectedUser");
        if (currentUser == null || currentUser.getUserId() == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }
        Long currentUserId = currentUser.getUserId(); // 삭제 요청 사용자 ID

        try {
            boolean success = messageService.deleteReceivedMessage(receiveId, currentUserId);
            Map<String, Object> response = new HashMap<>();
            if (success) {
                response.put("success", true);
                response.put("message", "쪽지를 받은 쪽지함에서 삭제했습니다.");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "쪽지 삭제에 실패했습니다. (권한 없거나 이미 삭제됨)");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "쪽지 삭제 중 오류 발생: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    /**
     * 보낸 쪽지함에서 쪽지를 삭제 처리하는 API입니다.
     *
     * @param sendId 삭제할 발신 기록의 SEND_ID
     * @param session 현재 세션
     * @return 성공 여부 메시지
     */
    @PostMapping("/sentbox/delete/{sendId}") // POST 요청으로 변경, PathVariable 사용
    public ResponseEntity<Map<String, Object>> deleteSentMessage(
            @PathVariable("sendId") Long sendId,
            HttpSession session) {
        User currentUser = (User) session.getAttribute("selectedUser");
        if (currentUser == null || currentUser.getUserId() == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }
        Long currentUserId = currentUser.getUserId(); // 삭제 요청 사용자 ID

        try {
            boolean success = messageService.deleteSentMessage(sendId, currentUserId);
            Map<String, Object> response = new HashMap<>();
            if (success) {
                response.put("success", true);
                response.put("message", "쪽지를 보낸 쪽지함에서 삭제했습니다.");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "쪽지 삭제에 실패했습니다. (권한 없거나 이미 삭제됨)");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "쪽지 삭제 중 오류 발생: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    /**
     * 받은 쪽지함의 쪽지를 중요 표시/해제하는 API입니다.
     *
     * @param receiveId 변경할 수신 기록의 RECEIVE_ID
     * @param importantYn 변경할 중요 표시 상태 ('Y' 또는 'N')
     * @param session 현재 세션
     * @return 성공 여부 메시지
     */
    @PostMapping("/inbox/toggleImportant/{receiveId}") // POST 요청으로 변경, PathVariable 사용
    public ResponseEntity<Map<String, Object>> toggleImportant(
            @PathVariable("receiveId") Long receiveId,
            @RequestParam("importantYn") String importantYn,
            HttpSession session) {
        User currentUser = (User) session.getAttribute("selectedUser");
        if (currentUser == null || currentUser.getUserId() == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }
        Long currentUserId = currentUser.getUserId();

        try {
            boolean success = messageService.toggleImportantReceivedMessage(receiveId, currentUserId, importantYn);
            Map<String, Object> response = new HashMap<>();
            if (success) {
                response.put("success", true);
                response.put("message", "쪽지 중요 표시를 변경했습니다.");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "쪽지 중요 표시 변경에 실패했습니다. (권한 없거나 기록 없음)");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "쪽지 중요 표시 변경 중 오류 발생: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }
}