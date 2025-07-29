// src/main/java/com/example/grouvy/message/service/MessageQueryService.java
package com.example.grouvy.message.service;

import com.example.grouvy.message.dto.MessageDetailResponseDto;
import com.example.grouvy.message.dto.MessageSendRequestDto;
import com.example.grouvy.message.dto.MessageSentResponseDto;
import com.example.grouvy.message.dto.PaginationResponse;
import com.example.grouvy.message.mapper.MessageMapper;
import com.example.grouvy.message.vo.Message;
import com.example.grouvy.message.vo.MessageReceiver;
import com.example.grouvy.user.mapper.UserMapper;
import com.example.grouvy.user.vo.User;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.SimpleDateFormat;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class MessageQueryService {

    private final MessageMapper messageMapper;
    private final UserMapper userMapper;

    @Transactional(readOnly = true)
    public MessageDetailResponseDto getMessageDetail(Long messageId, int currentUserId) {
        Message message = messageMapper.findMessageDetailById(messageId);
        if (message == null) {
            return null;
        }

        boolean isSender = message.getSenderId() == currentUserId;

        List<MessageReceiver> allReceivers = messageMapper.findAllReceiversByMessageId(messageId);
        MessageReceiver currentUserReceiver = allReceivers.stream()
                .filter(r -> r.getReceiverId() == currentUserId && "N".equals(r.getIsDeleted()))
                .findFirst().orElse(null);

        if (!isSender && (currentUserReceiver == null || "RECALLED".equals(currentUserReceiver.getInboxStatus()))) {
            return null;
        }

        MessageDetailResponseDto detailDto = new MessageDetailResponseDto();
        detailDto.setMessageId(message.getMessageId());
        detailDto.setSenderId(message.getSenderId());
        User senderUser = userMapper.findByUserId(message.getSenderId());
        detailDto.setSenderName((senderUser != null) ? senderUser.getName() : "알 수 없는 사용자");
        detailDto.setSubject(message.getSubject());
        detailDto.setMessageContent(message.getMessageContent());
        detailDto.setSendDate(message.getSendDate());
        detailDto.setRecallAble(message.getRecallAble());
        detailDto.setReceiveId(currentUserReceiver != null ? currentUserReceiver.getReceiveId() : null);
        detailDto.setInboxStatus(currentUserReceiver != null ? currentUserReceiver.getInboxStatus() : null);
        detailDto.setImportantYn(currentUserReceiver != null ? currentUserReceiver.getImportantYn() : null);

        detailDto.setToUserNames(messageMapper.findReceiverUserNamesByMessageIdAndType(messageId, "TO"));
        detailDto.setCcUserNames(messageMapper.findReceiverUserNamesByMessageIdAndType(messageId, "CC"));

        if (isSender) {
            detailDto.setBccUserNames(messageMapper.findReceiverUserNamesByMessageIdAndType(messageId, "BCC"));
        } else {
            if (currentUserReceiver != null && "BCC".equals(currentUserReceiver.getReceiverType())) {
                User currentUser = userMapper.findByUserId(currentUserId);
                if (currentUser != null) {
                    detailDto.getBccUserNames().add(currentUser.getName());
                }
            }
        }

        if (currentUserReceiver != null && "UNREAD".equals(currentUserReceiver.getInboxStatus())) {
            messageMapper.updateMessageReceiverReadDate(currentUserReceiver.getReceiveId());
        }

        if ("Y".equals(message.getRecallAble()) && isSender) {
            int unreadCount = messageMapper.countUnreadReceiversByMessageId(messageId);
            int totalReceiverCount = messageMapper.countTotalReceiversByMessageId(messageId);
            detailDto.setCurrentlyRecallable(unreadCount > 0 && unreadCount == totalReceiverCount);
        } else {
            detailDto.setCurrentlyRecallable(false);
        }
        return detailDto;
    }

    @Transactional(readOnly = true)
    public PaginationResponse<MessageSentResponseDto> getSentMessages(int userId, int page, int size) {
        int offset = (page - 1) * size;
        List<Message> sentMessages = messageMapper.findSentMessagesBySenderIdPaginated(userId, offset, size);
        int totalElements = messageMapper.countTotalSentMessages(userId);

        List<MessageSentResponseDto> dtos = sentMessages.stream()
                .map(msg -> {
                    MessageSentResponseDto dto = new MessageSentResponseDto();
                    dto.setMessageId(msg.getMessageId());
                    dto.setSenderId(msg.getSenderId());
                    dto.setSubject(msg.getSubject());
                    dto.setMessageContent(msg.getMessageContent());
                    dto.setSendDate(msg.getSendDate());
                    dto.setRecallAble(msg.getRecallAble());
                    dto.setSendId(msg.getSendId());

                    if ("Y".equals(msg.getRecallAble())) {
                        int unreadCount = messageMapper.countUnreadReceiversByMessageId(msg.getMessageId());
                        int totalReceiverCount = messageMapper.countTotalReceiversByMessageId(msg.getMessageId());
                        dto.setCurrentlyRecallable(unreadCount > 0 && unreadCount == totalReceiverCount);
                    } else {
                        dto.setCurrentlyRecallable(false);
                    }
                    return dto;
                })
                .collect(Collectors.toList());
        return new PaginationResponse<>(dtos, page - 1, size, totalElements);
    }

    @Transactional(readOnly = true)
    public PaginationResponse<MessageReceiver> getReceivedMessages(int userId, int page, int size) {
        int offset = (page - 1) * size;
        List<MessageReceiver> messages = messageMapper.findReceivedMessagesByReceiverIdPaginated(userId, offset, size);
        int totalElements = messageMapper.countTotalReceivedMessages(userId);
        return new PaginationResponse<>(messages, page - 1, size, totalElements);
    }

    @Transactional(readOnly = true)
    public PaginationResponse<MessageReceiver> getImportantMessages(int userId, int page, int size) {
        int offset = (page - 1) * size;
        List<MessageReceiver> messages = messageMapper.findImportantMessagesByReceiverIdPaginated(userId, offset, size);
        int totalElements = messageMapper.countImportantMessages(userId);
        return new PaginationResponse<>(messages, page - 1, size, totalElements);
    }

    public MessageSendRequestDto prepareReplyMessage(Long originalMessageId) {
        Message originalMessage = messageMapper.findMessageDetailById(originalMessageId);
        if (originalMessage == null) {
            return null;
        }

        MessageSendRequestDto replyDto = new MessageSendRequestDto();
        replyDto.setSubject("Re: " + originalMessage.getSubject());
        replyDto.getReceiverIds().add(originalMessage.getSenderId());

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        StringBuilder contentBuilder = new StringBuilder();
        contentBuilder.append("\n\n--- 원본 쪽지 ---\n");
        User originalSenderUser = userMapper.findByUserId(originalMessage.getSenderId());
        contentBuilder.append("보낸 사람: ").append((originalSenderUser != null) ? originalSenderUser.getName() : "알 수 없는 사용자").append(" (").append(originalMessage.getSenderId()).append(")\n");
        contentBuilder.append("제목: ").append(originalMessage.getSubject()).append("\n");
        contentBuilder.append("발송일: ").append(sdf.format(originalMessage.getSendDate())).append("\n");
        contentBuilder.append("--------------------\n");
        contentBuilder.append(originalMessage.getMessageContent());
        replyDto.setMessageContent(contentBuilder.toString());

        return replyDto;
    }

    public MessageSendRequestDto prepareForwardMessage(Long originalMessageId) {
        Message originalMessage = messageMapper.findMessageDetailById(originalMessageId);
        if (originalMessage == null) {
            return null;
        }

        List<String> originalToNames = messageMapper.findReceiverUserNamesByMessageIdAndType(originalMessageId, "TO");
        List<String> originalCcNames = messageMapper.findReceiverUserNamesByMessageIdAndType(originalMessageId, "CC");

        MessageSendRequestDto forwardDto = new MessageSendRequestDto();
        forwardDto.setSubject("Fwd: " + originalMessage.getSubject());

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        StringBuilder contentBuilder = new StringBuilder();
        contentBuilder.append("\n\n--- 전달된 쪽지 ---\n");
        User originalSenderUser = userMapper.findByUserId(originalMessage.getSenderId());
        contentBuilder.append("보낸 사람: ").append((originalSenderUser != null) ? originalSenderUser.getName() : "알 수 없는 사용자").append(" (").append(originalMessage.getSenderId()).append(")\n");
        contentBuilder.append("받는 사람 (TO): ").append((originalToNames != null && !originalToNames.isEmpty()) ? String.join(", ", originalToNames) : "-").append("\n");
        if (originalCcNames != null && !originalCcNames.isEmpty()) {
            contentBuilder.append("참조 (CC): ").append(String.join(", ", originalCcNames)).append("\n");
        }
        contentBuilder.append("발송일: ").append(sdf.format(originalMessage.getSendDate())).append("\n");
        contentBuilder.append("제목: ").append(originalMessage.getSubject()).append("\n");
        contentBuilder.append("--------------------\n");
        contentBuilder.append(originalMessage.getMessageContent());
        forwardDto.setMessageContent(contentBuilder.toString());

        return forwardDto;
    }
}