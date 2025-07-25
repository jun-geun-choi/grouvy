// src/main/java/com/example/grouvy/message/controller/MessageController.java
package com.example.grouvy.message.controller;

import com.example.grouvy.message.dto.MessageSendRequestDto;
import com.example.grouvy.message.service.MessageQueryService;
import com.example.grouvy.message.service.MessageSendService;
import com.example.grouvy.security.SecurityUser;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
@RequestMapping("/message")
public class MessageController {

    private final MessageSendService messageSendService;
    private final MessageQueryService messageQueryService;

    @GetMapping("/send")
    public String sendMessageForm(@RequestParam(value = "receiverId", required = false) Integer receiverId, Model model,
                                  @AuthenticationPrincipal SecurityUser securityUser) {

        if (securityUser != null) {
            model.addAttribute("currentSender", securityUser.getUser());
        } else {
            model.addAttribute("currentSender", null);
            model.addAttribute("errorMessage", "발신자 정보가 없습니다.");
        }

        if (receiverId != null) {
            model.addAttribute("initialReceiverId", receiverId);
        }

        model.addAttribute("formTitle", "쪽지 보내기");
        return "message/message_send";
    }

    @GetMapping("/inbox")
    public String inbox(Model model, @AuthenticationPrincipal SecurityUser securityUser) {
        if (securityUser == null || securityUser.getUser().getUserId() == 0) {
            model.addAttribute("errorMessage", "로그인이 필요합니다.");
            return "redirect:/login";
        }
        model.addAttribute("currentPage", "inbox");
        return "message/inbox";
    }

    @GetMapping("/sentbox")
    public String sentbox(Model model, @AuthenticationPrincipal SecurityUser securityUser) {
        if (securityUser == null || securityUser.getUser().getUserId() == 0) {
            model.addAttribute("errorMessage", "로그인이 필요합니다.");
            return "redirect:/login";
        }
        model.addAttribute("currentPage", "sentbox");
        return "message/sentbox";
    }

    @GetMapping("/detail")
    public String messageDetail(@RequestParam("messageId") Long messageId, Model model, @AuthenticationPrincipal SecurityUser securityUser) {
        if (securityUser == null || securityUser.getUser().getUserId() == 0) {
            model.addAttribute("errorMessage", "로그인이 필요합니다.");
            return "redirect:/login";
        }
        model.addAttribute("messageId", messageId);
        model.addAttribute("currentPage", "messageDetail");
        return "message/message_detail";
    }

    @GetMapping("/send-prepared")
    public String sendPreparedMessageForm(
            @RequestParam("originalMessageId") Long originalMessageId,
            @RequestParam("type") String type,
            Model model, @AuthenticationPrincipal SecurityUser securityUser) {

        if (securityUser == null || securityUser.getUser().getUserId() == 0) {
            model.addAttribute("errorMessage", "쪽지 작성을 위해 로그인 정보가 필요합니다.");
            return "redirect:/login";
        }

        model.addAttribute("currentSender", securityUser.getUser());

        MessageSendRequestDto preparedDto = null;
        String formTitle = "";

        if ("reply".equalsIgnoreCase(type)) {
            preparedDto = messageQueryService.prepareReplyMessage(originalMessageId);
            formTitle = "쪽지 답장";
        } else if ("forward".equalsIgnoreCase(type)) {
            preparedDto = messageQueryService.prepareForwardMessage(originalMessageId);
            formTitle = "쪽지 전달";
        } else {
            model.addAttribute("errorMessage", "잘못된 쪽지 준비 요청입니다.");
        }

        if (preparedDto == null && model.getAttribute("errorMessage") == null) {
            model.addAttribute("errorMessage", "원본 쪽지를 찾을 수 없거나 접근 권한이 없습니다.");
        }

        model.addAttribute("preparedMessage", preparedDto);

        if (preparedDto != null) {
            if (preparedDto.getReceiverIds() != null && !preparedDto.getReceiverIds().isEmpty()) {
                model.addAttribute("preparedReceiverIdsStr",
                        preparedDto.getReceiverIds().stream()
                                .map(String::valueOf)
                                .collect(Collectors.joining(",")));
            } else {
                model.addAttribute("preparedReceiverIdsStr", "");
            }
            if (preparedDto.getCcIds() != null && !preparedDto.getCcIds().isEmpty()) {
                model.addAttribute("preparedCcIdsStr",
                        preparedDto.getCcIds().stream()
                                .map(String::valueOf)
                                .collect(Collectors.joining(",")));
            } else {
                model.addAttribute("preparedCcIdsStr", "");
            }
            if (preparedDto.getBccIds() != null && !preparedDto.getBccIds().isEmpty()) {
                model.addAttribute("preparedBccIdsStr",
                        preparedDto.getBccIds().stream()
                                .map(String::valueOf)
                                .collect(Collectors.joining(",")));
            } else {
                model.addAttribute("preparedBccIdsStr", "");
            }
        } else {
            model.addAttribute("preparedReceiverIdsStr", "");
            model.addAttribute("preparedCcIdsStr", "");
            model.addAttribute("preparedBccIdsStr", "");
        }


        model.addAttribute("formTitle", formTitle);
        model.addAttribute("originalMessageId", originalMessageId);
        model.addAttribute("messageType", type);

        model.addAttribute("currentPage", "send");
        return "message/message_send_prepared";
    }

    // **새롭게 추가:** 중요 쪽지함 페이지
    @GetMapping("/important")
    public String importantInbox(Model model, @AuthenticationPrincipal SecurityUser securityUser) {
        if (securityUser == null || securityUser.getUser().getUserId() == 0) {
            model.addAttribute("errorMessage", "로그인이 필요합니다.");
            return "redirect:/login";
        }
        model.addAttribute("currentPage", "important");
        return "message/important_inbox";
    }
}