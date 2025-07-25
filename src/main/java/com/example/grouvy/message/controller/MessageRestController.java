// src/main/java/com/example/grouvy/message/controller/MessageRestController.java
package com.example.grouvy.message.controller;

import com.example.grouvy.message.dto.MessageDetailResponseDto;
import com.example.grouvy.message.dto.MessageSendRequestDto;
import com.example.grouvy.message.dto.MessageSentResponseDto;
import com.example.grouvy.message.dto.PaginationResponse;
import com.example.grouvy.message.service.MessageQueryService;
import com.example.grouvy.message.service.MessageSendService;
import com.example.grouvy.message.vo.MessageReceiver;
import com.example.grouvy.security.SecurityUser;
import com.example.grouvy.user.mapper.UserMapper;
import com.example.grouvy.user.vo.User;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/messages")
public class MessageRestController {

    private final MessageSendService messageSendService;
    private final MessageQueryService messageQueryService;
    private final UserMapper userMapper;

    @PostMapping("/send")
    public ResponseEntity<Map<String, Object>> sendMessage(@RequestBody MessageSendRequestDto messageDto,
                                                           @AuthenticationPrincipal SecurityUser securityUser) {

        if(securityUser == null || securityUser.getUser().getUserId() == 0) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "로그인이 필요합니다");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorResponse);
        }
        int senderId = securityUser.getUser().getUserId();

        try {
            Long messageId = messageSendService.sendMessage(messageDto, senderId);
            Map<String, Object> successResponse = new HashMap<>();
            successResponse.put("success", true);
            successResponse.put("message","쪽지가 성공적으로 발송되었습니다.");
            successResponse.put("messageId",messageId);
            return ResponseEntity.ok(successResponse);
        } catch (IllegalArgumentException e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", e.getMessage() != null ? e.getMessage() : "유효하지 않은 수신자 정보");
            return ResponseEntity.badRequest().body(errorResponse);
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "쪽지 발송중 알수 없는 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @GetMapping("/inbox")
    public ResponseEntity<PaginationResponse<MessageReceiver>> getInboxMessages(
            @AuthenticationPrincipal SecurityUser securityUser,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size) {

        if (securityUser == null || securityUser.getUser().getUserId() == 0) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }
        int receiverId = securityUser.getUser().getUserId();

        PaginationResponse<MessageReceiver> messages = messageQueryService.getReceivedMessages(receiverId, page, size);
        return ResponseEntity.ok(messages);
    }

    // **새롭게 추가:** 중요 쪽지함 목록 조회 API
    @GetMapping("/important")
    public ResponseEntity<PaginationResponse<MessageReceiver>> getImportantMessages(
            @AuthenticationPrincipal SecurityUser securityUser,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size) {

        if (securityUser == null || securityUser.getUser().getUserId() == 0) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }
        int receiverId = securityUser.getUser().getUserId();

        PaginationResponse<MessageReceiver> messages = messageQueryService.getImportantMessages(receiverId, page, size);
        return ResponseEntity.ok(messages);
    }

    @GetMapping("/sentbox")
    public ResponseEntity<PaginationResponse<MessageSentResponseDto>> getSentboxMessages(
            @AuthenticationPrincipal SecurityUser securityUser,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size) {

        if (securityUser == null || securityUser.getUser().getUserId() == 0) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }
        int senderId = securityUser.getUser().getUserId();

        PaginationResponse<MessageSentResponseDto> messages = messageQueryService.getSentMessages(senderId, page, size);
        return ResponseEntity.ok(messages);
    }

    @PostMapping("/recall/{messageId}")
    public ResponseEntity<Map<String, Object>> recallMessage(
            @PathVariable("messageId") Long messageId,
            @AuthenticationPrincipal SecurityUser securityUser) {

        if (securityUser == null || securityUser.getUser().getUserId() == 0) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "로그인이 필요합니다.");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorResponse);
        }
        int currentUserId = securityUser.getUser().getUserId();

        try {
            boolean success = messageSendService.recallMessage(messageId, currentUserId);
            Map<String, Object> response = new HashMap<>();
            if (success) {
                response.put("success", true);
                response.put("message", "쪽지가 성공적으로 회수되었습니다.");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "쪽지 회수에 실패했습니다. (이미 모든 수신자가 읽었거나, 회수 불가능한 쪽지입니다)");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "쪽지 회수 중 오류 발생: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @GetMapping("/detail/{messageId}")
    public ResponseEntity<MessageDetailResponseDto> getMessageDetail(
            @PathVariable("messageId") Long messageId,
            @AuthenticationPrincipal SecurityUser securityUser) {

        if (securityUser == null || securityUser.getUser().getUserId() == 0) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }
        int currentUserId = securityUser.getUser().getUserId();

        MessageDetailResponseDto messageDetail = messageQueryService.getMessageDetail(messageId, currentUserId);
        if (messageDetail == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
        return ResponseEntity.ok(messageDetail);
    }

    @GetMapping("/prepare-message")
    public ResponseEntity<MessageSendRequestDto> prepareMessage(
            @RequestParam("originalMessageId") Long originalMessageId,
            @RequestParam("type") String type) {

        MessageSendRequestDto preparedDto = null;
        if ("reply".equalsIgnoreCase(type)) {
            preparedDto = messageQueryService.prepareReplyMessage(originalMessageId);
        } else if ("forward".equalsIgnoreCase(type)) {
            preparedDto = messageQueryService.prepareForwardMessage(originalMessageId);
        }

        if (preparedDto == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
        return ResponseEntity.ok(preparedDto);
    }

    // 임시 User API (사용자 파트 API 부재로 인한 임시 조치) - /api/v1/messages/users/{userId}/name
    @GetMapping("/users/{userId}/name")
    public ResponseEntity<String> getUserNameForMessage(@PathVariable("userId") int userId) {
        User user = userMapper.findByUserId(userId);
        if (user == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
        return ResponseEntity.ok(user.getName());
    }

    // 현재 로그인 사용자 ID를 반환하는 임시 API
    @GetMapping("/users/current/id")
    public ResponseEntity<Integer> getCurrentUserId(@AuthenticationPrincipal SecurityUser securityUser) {
        if (securityUser == null || securityUser.getUser().getUserId() == 0) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }
        return ResponseEntity.ok(securityUser.getUser().getUserId());
    }

    @PostMapping("/inbox/delete/{receiveId}")
    public ResponseEntity<Map<String, Object>> deleteInboxMessage(
            @PathVariable("receiveId") Long receiveId,
            @AuthenticationPrincipal SecurityUser securityUser) {
        if (securityUser == null || securityUser.getUser().getUserId() == 0) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "로그인이 필요합니다.");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorResponse);
        }
        int currentUserId = securityUser.getUser().getUserId();

        try {
            boolean success = messageSendService.deleteReceivedMessage(receiveId, currentUserId);
            Map<String, Object> response = new HashMap<>();
            if (success) {
                response.put("success", true);
                response.put("message", "쪽지가 받은 쪽지함에서 삭제되었습니다.");
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

    @PostMapping("/sentbox/delete/{sendId}")
    public ResponseEntity<Map<String, Object>> deleteSentMessage(
            @PathVariable("sendId") Long sendId,
            @AuthenticationPrincipal SecurityUser securityUser) {
        if (securityUser == null || securityUser.getUser().getUserId() == 0) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "로그인이 필요합니다.");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorResponse);
        }
        int currentUserId = securityUser.getUser().getUserId();

        try {
            boolean success = messageSendService.deleteSentMessage(sendId, currentUserId);
            Map<String, Object> response = new HashMap<>();
            if (success) {
                response.put("success", true);
                response.put("message", "쪽지가 보낸 쪽지함에서 삭제되었습니다.");
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

    @PostMapping("/inbox/toggleImportant/{receiveId}")
    public ResponseEntity<Map<String, Object>> toggleImportant(
            @PathVariable("receiveId") Long receiveId,
            @RequestParam("importantYn") String importantYn,
            @AuthenticationPrincipal SecurityUser securityUser) {
        if (securityUser == null || securityUser.getUser().getUserId() == 0) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "로그인이 필요합니다.");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorResponse);
        }
        int currentUserId = securityUser.getUser().getUserId();

        try {
            boolean success = messageSendService.toggleImportantReceivedMessage(receiveId, currentUserId, importantYn);
            Map<String, Object> response = new HashMap<>();
            if (success) {
                response.put("success", true);
                response.put("message", "쪽지 중요 표시가 변경되었습니다.");
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