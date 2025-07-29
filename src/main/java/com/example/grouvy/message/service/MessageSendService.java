// src/main/java/com/example/grouvy/message/service/MessageSendService.java
package com.example.grouvy.message.service;

import com.example.grouvy.message.dto.MessageSendRequestDto;
import com.example.grouvy.message.mapper.MessageMapper;
import com.example.grouvy.message.vo.Message;
import com.example.grouvy.message.vo.MessageReceiver;
import com.example.grouvy.message.vo.MessageSender;
import com.example.grouvy.user.mapper.UserMapper;
import com.example.grouvy.user.vo.User;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class MessageSendService {

    private final MessageMapper messageMapper;
    private final UserMapper userMapper;

    //메세지작성
    private void saveMessageReceiver(Long messageId, int receiverId, String receiverType) {
        MessageReceiver receiverRecord = new MessageReceiver();
        receiverRecord.setMessageId(messageId);
        receiverRecord.setReceiverId(receiverId);
        receiverRecord.setReceiverType(receiverType);
        receiverRecord.setInboxStatus("UNREAD");
        receiverRecord.setIsDeleted("N");
        receiverRecord.setImportantYn("N");
        receiverRecord.setReadDate(null);
        messageMapper.insertMessageReceiver(receiverRecord);
    }

    @Transactional
    public Long sendMessage(MessageSendRequestDto messageSendRequestDto, int senderId) {
        if (messageSendRequestDto.getReceiverIds() == null || messageSendRequestDto.getReceiverIds().isEmpty()) {
            throw new IllegalArgumentException("수신 (TO) 사용자는 반드시 1명 이상 지정해야 합니다.");
        }

        Set<Integer> allReceiverIdsForValidation = new HashSet<>();
        if (messageSendRequestDto.getReceiverIds() != null) {
            allReceiverIdsForValidation.addAll(messageSendRequestDto.getReceiverIds());
        }
        if (messageSendRequestDto.getCcIds() != null) {
            allReceiverIdsForValidation.addAll(messageSendRequestDto.getCcIds());
        }
        if (messageSendRequestDto.getBccIds() != null) {
            allReceiverIdsForValidation.addAll(messageSendRequestDto.getBccIds());
        }

        allReceiverIdsForValidation.remove(Integer.valueOf(senderId));

        if (!allReceiverIdsForValidation.isEmpty()) {
            for (Integer receiverId : allReceiverIdsForValidation) {
                if (userMapper.findByUserId(receiverId) == null) {
                    throw new IllegalArgumentException("존재하지 않는 사용자 ID가 수신자 목록에 포함되어 있습니다: " + receiverId);
                }
            }
        }

        Message message = new Message();
        message.setSenderId(senderId);
        message.setSubject(messageSendRequestDto.getSubject());
        message.setMessageContent(messageSendRequestDto.getMessageContent());
        message.setRecallAble("Y");

        messageMapper.insertMessage(message);
        Long msgId = message.getMessageId();

        MessageSender senderRecord = new MessageSender();
        senderRecord.setMessageId(msgId);
        senderRecord.setSenderId(senderId);
        senderRecord.setIsDeleted("N");
        messageMapper.insertMessageSender(senderRecord);

        Set<Integer> processedReceivers = new HashSet<>();

        if (messageSendRequestDto.getReceiverIds() != null) {
            for (int receiverId : messageSendRequestDto.getReceiverIds()) {
                if (receiverId == senderId || processedReceivers.contains(receiverId)) continue;
                saveMessageReceiver(msgId, receiverId, "TO");
                processedReceivers.add(receiverId);
            }
        }

        if (messageSendRequestDto.getCcIds() != null) {
            for (int ccId : messageSendRequestDto.getCcIds()) {
                if (ccId == senderId || processedReceivers.contains(ccId)) continue;
                saveMessageReceiver(msgId, ccId, "CC");
                processedReceivers.add(ccId);
            }
        }

        if (messageSendRequestDto.getBccIds() != null) {
            for (int bccId : messageSendRequestDto.getBccIds()) {
                if (bccId == senderId || processedReceivers.contains(bccId)) continue;
                saveMessageReceiver(msgId, bccId, "BCC");
                processedReceivers.add(bccId);
            }
        }
        return msgId;
    }

    //메세지 회수
    @Transactional
    public boolean recallMessage(Long messageId, int currentUserId) {
        Message message = messageMapper.findMessageDetailById(messageId);
        if (message == null || currentUserId != message.getSenderId() || !"Y".equals(message.getRecallAble())) {
            return false;
        }

        int unreadCount = messageMapper.countUnreadReceiversByMessageId(messageId);
        int totalReceiversCount = messageMapper.countTotalReceiversByMessageId(messageId);

        if (totalReceiversCount == 0 || unreadCount != totalReceiversCount) {
            return false;
        }

        int updatedRows = messageMapper.updateInboxStatusToRecalled(messageId);
        int updatedMessageRows = messageMapper.updateMessageRecallAbleToN(messageId);

        if (updatedRows == totalReceiversCount && updatedMessageRows > 0) {
            List<MessageReceiver> receivers = messageMapper.findAllReceiversByMessageId(messageId);
            User senderUser = userMapper.findByUserId(currentUserId);
            String senderName = (senderUser != null) ? senderUser.getName() : "알 수 없는 사용자";
            String recalledMessageContent = "[" + senderName + "님이 쪽지를 회수했습니다.]";

            for (MessageReceiver receiver : receivers) {
                // 알림 기능 제외
            }
            return true;
        }
        return false;
    }

    //메세지 삭제
    @Transactional
    public boolean deleteReceivedMessage(Long receiveId, int currentUserId) {
        MessageReceiver receiverRecord = messageMapper.findReceiverById(receiveId);
        if (receiverRecord == null || receiverRecord.getReceiverId() != currentUserId) {
            return false;
        }
        int updated = messageMapper.updateMessageReceiverIsDeleted(receiveId, "Y");
        return updated > 0;
    }

    @Transactional
    public boolean deleteSentMessage(Long sendId, int currentUserId) {
        MessageSender senderRecord = messageMapper.findSenderById(sendId);
        if (senderRecord == null || senderRecord.getSenderId() != currentUserId) {
            return false;
        }
        int updated = messageMapper.updateMessageSenderIsDeleted(sendId, "Y");
        return updated > 0;
    }

    //메세지즐겨찾기
    @Transactional
    public boolean toggleImportantReceivedMessage(Long receiveId, int currentUserId, String importantYn) {
        MessageReceiver receiverRecord = messageMapper.findReceiverById(receiveId); // receiveId로 MessageReceiver 조회
        if (receiverRecord == null || receiverRecord.getReceiverId() != currentUserId) {
            return false;
        }
        int updated = messageMapper.updateMessageReceiverImportantYn(receiveId, importantYn);
        return updated > 0;
    }
}