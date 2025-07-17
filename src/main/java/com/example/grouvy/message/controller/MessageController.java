// src/main/java/com/example/grouvy/message/controller/MessageController.java
package com.example.grouvy.message.controller;

import com.example.grouvy.message.dto.MessageSendRequestDto; // MessageSendRequestDto 임포트 (답장/전달용)
import com.example.grouvy.message.service.MessageService; // MessageService 임포트 (답장/전달용)
import com.example.grouvy.user.vo.User;
import jakarta.servlet.http.HttpSession;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequiredArgsConstructor
@RequestMapping("/message") // 쪽지 관련 뷰의 기본 경로
public class MessageController {

    private final MessageService messageService; // 답장/전달 기능 준비를 위해 MessageService 주입

    // --- 쪽지 발송 폼 반환 (기존) ---
    @GetMapping("/send")
    public String sendMessageForm(@RequestParam(value = "receiverId", required = false) Long receiverId, Model model, HttpSession session) {
        User senderUser = (User) session.getAttribute("selectedUser");
        if (senderUser != null && senderUser.getUserId() != null) {
            model.addAttribute("currentSender", senderUser);
        } else {
            model.addAttribute("currentSender", null);
            model.addAttribute("errorMessage", "쪽지 발송을 위해 발신자 정보를 선택해주세요. (조직도에서 사용자 클릭)");
        }

        if (receiverId != null) {
            model.addAttribute("initialReceiverId", receiverId);
        }

        model.addAttribute("formTitle", "쪽지 보내기");
        return "message/message_send";
    }

    // --- **새로 추가될 쪽지함 JSP 반환 메서드** ---

    /**
     * 받은 쪽지함 페이지를 반환합니다. 데이터는 JavaScript를 통해 REST API에서 로드됩니다.
     * @param model JSP로 데이터를 전달하기 위한 Model 객체 (현재는 비어있음)
     * @param session 현재 HTTP 세션 (사용자 ID 확인용)
     * @return "message/inbox" JSP 뷰의 이름을 반환합니다.
     */
    @GetMapping("/inbox")
    public String inbox(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("selectedUser");
        if (currentUser == null || currentUser.getUserId() == null) {
            model.addAttribute("errorMessage", "받은 쪽지함을 보려면 발신자를 먼저 선택해주세요. (조직도에서 사용자 클릭)");
        }
        model.addAttribute("currentPage", "inbox"); // 사이드바 활성화를 위한 값
        return "message/inbox";
    }

    /**
     * 중요 쪽지함 페이지를 반환합니다. 데이터는 JavaScript를 통해 REST API에서 로드됩니다.
     * @param model JSP로 데이터를 전달하기 위한 Model 객체
     * @param session 현재 HTTP 세션
     * @return "message/important_inbox" JSP 뷰의 이름을 반환합니다.
     */
    @GetMapping("/important")
    public String importantInbox(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("selectedUser");
        if (currentUser == null || currentUser.getUserId() == null) {
            model.addAttribute("errorMessage", "중요 쪽지함을 보려면 발신자를 먼저 선택해주세요.");
        }
        model.addAttribute("currentPage", "important"); // 사이드바 활성화를 위한 값
        return "message/important_inbox";
    }

    /**
     * 보낸 쪽지함 페이지를 반환합니다. 데이터는 JavaScript를 통해 REST API에서 로드됩니다.
     * @param model JSP로 데이터를 전달하기 위한 Model 객체
     * @param session 현재 HTTP 세션
     * @return "message/sentbox" JSP 뷰의 이름을 반환합니다.
     */
    @GetMapping("/sentbox")
    public String sentbox(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("selectedUser");
        if (currentUser == null || currentUser.getUserId() == null) {
            model.addAttribute("errorMessage", "보낸 쪽지함을 보려면 발신자를 먼저 선택해주세요.");
        }
        model.addAttribute("currentPage", "sentbox"); // 사이드바 활성화를 위한 값
        return "message/sentbox";
    }

    /**
     * 쪽지 상세 보기 페이지를 반환합니다. 데이터는 JavaScript를 통해 REST API에서 로드됩니다.
     * @param messageId 조회할 쪽지의 ID
     * @param model JSP로 데이터를 전달하기 위한 Model 객체
     * @param session 현재 HTTP 세션
     * @return "message/message_detail" JSP 뷰의 이름을 반환합니다.
     */
    @GetMapping("/detail")
    public String messageDetail(@RequestParam("messageId") Long messageId, Model model, HttpSession session) {
        // messageId를 JavaScript로 전달하기 위해 Model에 추가
        model.addAttribute("messageId", messageId);
        model.addAttribute("currentPage", "messageDetail"); // 사이드바 활성화를 위한 값

        User currentUser = (User) session.getAttribute("selectedUser");
        if (currentUser == null || currentUser.getUserId() == null) {
            model.addAttribute("errorMessage", "쪽지 상세를 보려면 발신자를 먼저 선택해주세요.");
        }
        return "message/message_detail";
    }

    /**
     * 답장/전달 기능을 위한 쪽지 발송 폼을 준비합니다.
     * 원본 쪽지 ID와 타입(reply/forward)을 받아, MessageService를 통해 DTO를 준비하고 폼에 미리 채웁니다.
     * 이 페이지도 최종적으로는 AJAX 제출 방식을 사용합니다.
     * @param originalMessageId 원본 쪽지 ID
     * @param type "reply" 또는 "forward"
     * @param model JSP로 데이터를 전달하기 위한 Model 객체
     * @param session 현재 HTTP 세션
     * @return "message/message_send_prepared" JSP 뷰 (새로 생성할 뷰)의 이름을 반환합니다.
     */
    @GetMapping("/send-prepared")
    public String sendPreparedMessageForm(
            @RequestParam("originalMessageId") Long originalMessageId,
            @RequestParam("type") String type,
            Model model, HttpSession session) {

        // **발신자 정보 세션에서 가져와 Model에 추가 (누락되었을 가능성 있는 부분)**
        User senderUser = (User) session.getAttribute("selectedUser");
        if (senderUser != null && senderUser.getUserId() != null) {
            model.addAttribute("currentSender", senderUser);
        } else {
            // 발신자 정보가 없으면 에러 메시지를 Model에 추가하고 페이지는 유지
            model.addAttribute("errorMessage", "쪽지 작성을 위해 발신자 정보가 필요합니다. 조직도에서 발신자를 먼저 선택해주세요.");
            // preparedDto는 null로 두어 폼 필드를 채우지 않도록 합니다.
        }

        MessageSendRequestDto preparedDto = null;
        String formTitle = "";

        if ("reply".equalsIgnoreCase(type)) {
            preparedDto = messageService.prepareReplyMessage(originalMessageId);
            formTitle = "쪽지 답장";
        } else if ("forward".equalsIgnoreCase(type)) {
            preparedDto = messageService.prepareForwardMessage(originalMessageId);
            formTitle = "쪽지 전달";
        } else {
            model.addAttribute("errorMessage", "잘못된 쪽지 준비 요청입니다.");
        }

        // preparedDto가 null이거나 (원본 쪽지 없음/권한 없음)
        // 또는 senderUser가 null인 경우에도 에러 메시지를 설정 (중복 체크)
        if (preparedDto == null && model.getAttribute("errorMessage") == null) {
            model.addAttribute("errorMessage", "원본 쪽지를 찾을 수 없거나 접근 권한이 없습니다.");
        }

        model.addAttribute("preparedMessage", preparedDto);
        model.addAttribute("formTitle", formTitle);
        model.addAttribute("originalMessageId", originalMessageId);
        model.addAttribute("messageType", type);

        model.addAttribute("currentPage", "send");
        return "message/message_send_prepared"; // 답장/전달 전용 뷰 반환
    }
}