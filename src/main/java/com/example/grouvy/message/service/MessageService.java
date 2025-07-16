// src/main/java/com/example/grouvy/message/service/MessageService.java
package com.example.grouvy.message.service;

import com.example.grouvy.message.mapper.MessageMapper;
import com.example.grouvy.user.mapper.UserMapper;
import com.example.grouvy.message.dto.MessageSendRequestDto;
import com.example.grouvy.message.dto.MessageDetailResponseDto; // 추가
import com.example.grouvy.message.dto.MessageSentResponseDto; // 추가
import com.example.grouvy.message.dto.PaginationResponse; // 추가 (페이징 DTO)
import com.example.grouvy.message.vo.Message;
import com.example.grouvy.message.vo.MessageReceiver;
import com.example.grouvy.message.vo.MessageSender;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.SimpleDateFormat; // 날짜 포맷팅을 위해 추가 (답장/전달 시)
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors; // List to String 변환 시 사용

@Service
@RequiredArgsConstructor
public class MessageService {

    private final MessageMapper messageMapper;
    private final UserMapper userMapper;

    // 알림 서비스 (향후 구현 시 주석 해제)
    // private final NotificationService notificationService;
    // 읽지 않은 카운트 서비스 (향후 구현 시 주석 해제)
    // private final UnreadCountService unreadCountService;

    // 쪽지 발송 메서드 (기존)
    @Transactional
    public Long sendMessage(MessageSendRequestDto messageDto, Long senderId) {
        if (messageDto.getReceiverIds() == null || messageDto.getReceiverIds().isEmpty()) {
            throw new IllegalArgumentException("수신 (TO) 사용자는 반드시 1명 이상 지정해야 합니다.");
        }

        Set<Long> allReceiverIds = new HashSet<>();
        if (messageDto.getReceiverIds() != null) allReceiverIds.addAll(messageDto.getReceiverIds());
        if (messageDto.getCcIds() != null) allReceiverIds.addAll(messageDto.getCcIds());
        if (messageDto.getBccIds() != null) allReceiverIds.addAll(messageDto.getBccIds());

        allReceiverIds.remove(senderId); // 발신자는 수신자 목록에서 제외

        if (!allReceiverIds.isEmpty()) {
            for (Long receiverId : allReceiverIds) {
                if (userMapper.findByUserId(receiverId) == null) {
                    throw new IllegalArgumentException("존재하지 않는 사용자 ID가 수신자 목록에 포함되어 있습니다: " + receiverId);
                }
            }
        }

        Message message = new Message();
        message.setSenderId(senderId);
        message.setSubject(messageDto.getSubject());
        message.setMessageContent(messageDto.getMessageContent());
        message.setRecallAble("Y");

        messageMapper.insertMessage(message);
        Long msgId = message.getMessageId();

        MessageSender senderRecord = new MessageSender();
        senderRecord.setMessageId(msgId);
        senderRecord.setSenderId(senderId);
        senderRecord.setIsDeleted("N");
        messageMapper.insertMessageSender(senderRecord);

        Set<Long> processedReceivers = new HashSet<>(); // 중복 수신자 방지

        // TO 수신자 처리
        if (messageDto.getReceiverIds() != null) {
            for (Long receiverId : messageDto.getReceiverIds()) {
                if (receiverId.equals(senderId) || processedReceivers.contains(receiverId)) continue;
                saveMessageReceiver(msgId, receiverId, "TO");
                processedReceivers.add(receiverId);
                // 알림 생성 및 읽지 않은 카운트 업데이트 (향후 구현 시 주석 해제)
                // notificationService.createNotification(...);
                // unreadCountService.updateAndSendUnreadCounts(receiverId);
            }
        }

        // CC 수신자 처리
        if (messageDto.getCcIds() != null) {
            for (Long ccId : messageDto.getCcIds()) {
                if (ccId.equals(senderId) || processedReceivers.contains(ccId)) continue;
                saveMessageReceiver(msgId, ccId, "CC");
                processedReceivers.add(ccId);
                // notificationService.createNotification(...);
                // unreadCountService.updateAndSendUnreadCounts(ccId);
            }
        }

        // BCC 수신자 처리
        if (messageDto.getBccIds() != null) {
            for (Long bccId : messageDto.getBccIds()) {
                if (bccId.equals(senderId) || processedReceivers.contains(bccId)) continue;
                saveMessageReceiver(msgId, bccId, "BCC");
                processedReceivers.add(bccId);
            }
        }
        return msgId;
    }

    private void saveMessageReceiver(Long msgId, Long receiverId, String receiverType) {
        MessageReceiver receiverRecord = new MessageReceiver();
        receiverRecord.setMessageId(msgId);
        receiverRecord.setReceiverId(receiverId);
        receiverRecord.setReceiverType(receiverType);
        receiverRecord.setReadDate(null);
        receiverRecord.setInboxStatus("UNREAD");
        receiverRecord.setIsDeleted("N");
        receiverRecord.setImportantYn("N");
        messageMapper.insertMessageReceiver(receiverRecord);
    }

    // **새로 추가될 쪽지함 목록 조회 및 상세 보기 관련 메서드**

    /**
     * 받은 쪽지함 목록을 페이징 처리하여 조회합니다.
     * @param userId 현재 사용자 ID (수신자)
     * @param page 조회할 페이지 번호 (1부터 시작)
     * @param size 한 페이지당 항목 수
     * @return 페이징된 MessageReceiver 목록이 포함된 PaginationResponse
     */
    public PaginationResponse<MessageReceiver> getReceivedMessages(Long userId, int page, int size) {
        int offset = (page - 1) * size; // OFFSET 계산
        List<MessageReceiver> messages = messageMapper.findReceivedMessagesByReceiverIdPaginated(userId, offset, size);
        int totalElements = messageMapper.countTotalReceivedMessages(userId);
        return new PaginationResponse<>(messages, page - 1, size, totalElements); // pageNumber는 0부터 시작
    }

    /**
     * 중요 쪽지함 목록을 페이징 처리하여 조회합니다.
     * @param userId 현재 사용자 ID (수신자)
     * @param page 조회할 페이지 번호 (1부터 시작)
     * @param size 한 페이지당 항목 수
     * @return 페이징된 MessageReceiver 목록이 포함된 PaginationResponse
     */
    public PaginationResponse<MessageReceiver> getImportantMessages(Long userId, int page, int size) {
        int offset = (page - 1) * size;
        List<MessageReceiver> messages = messageMapper.findImportantMessagesByReceiverIdPaginated(userId, offset, size);
        int totalElements = messageMapper.countImportantMessages(userId);
        return new PaginationResponse<>(messages, page - 1, size, totalElements);
    }

    /**
     * 보낸 쪽지함 목록을 페이징 처리하여 조회합니다.
     * @param userId 현재 사용자 ID (발신자)
     * @param page 조회할 페이지 번호 (1부터 시작)
     * @param size 한 페이지당 항목 수
     * @return 페이징된 MessageSentResponseDto 목록이 포함된 PaginationResponse
     */
    public PaginationResponse<MessageSentResponseDto> getSentMessages(Long userId, int page, int size) {
        int offset = (page - 1) * size;
        List<Message> sentMessages = messageMapper.findSentMessagesBySenderIdPaginated(userId, offset, size);
        int totalElements = messageMapper.countTotalSentMessages(userId);

        // Message VO를 MessageSentResponseDto로 변환하고, 회수 가능 여부 계산
        List<MessageSentResponseDto> dtos = sentMessages.stream()
                .map(msg -> {
                    MessageSentResponseDto dto = new MessageSentResponseDto();
                    dto.setMessageId(msg.getMessageId());
                    dto.setSenderId(msg.getSenderId());
                    dto.setSubject(msg.getSubject());
                    dto.setMessageContent(msg.getMessageContent());
                    dto.setSendDate(msg.getSendDate());
                    dto.setRecallAble(msg.getRecallAble());
                    dto.setSendId(msg.getSendId()); // Message VO의 sendId 필드에서 가져옴

                    // 회수 가능 여부 계산 로직: 'Y'로 설정되어 있고, 읽지 않은 수신자가 전체 수신자와 같을 때만 회수 가능
                    if ("Y".equals(msg.getRecallAble())) {
                        int unreadCount = messageMapper.countUnreadReceiversByMessageId(msg.getMessageId());
                        int totalReceiversCount = messageMapper.countTotalReceiversByMessageId(msg.getMessageId());
                        dto.setCurrentlyRecallable(unreadCount > 0 && unreadCount == totalReceiversCount);
                    } else {
                        dto.setCurrentlyRecallable(false); // 회수 불가로 설정된 경우
                    }
                    return dto;
                })
                .collect(Collectors.toList());

        return new PaginationResponse<>(dtos, page - 1, size, totalElements);
    }

    /**
     * 특정 쪽지의 상세 정보를 조회합니다.
     * 쪽지를 조회하는 사용자가 발신자이거나 수신자인 경우에만 조회 권한을 부여합니다.
     * 받은 쪽지인 경우, 읽음 상태로 업데이트합니다.
     *
     * @param messageId 조회할 쪽지의 MESSAGE_ID
     * @param currentUserId 현재 쪽지를 조회하는 사용자의 USER_ID
     * @return MessageDetailResponseDto 객체, 조회 권한이 없거나 회수된 쪽지인 경우 null
     */
    @Transactional
    public MessageDetailResponseDto getMessageDetail(Long messageId, Long currentUserId) {
        Message message = messageMapper.findMessageDetailById(messageId);

        if (message == null) {
            return null; // 쪽지를 찾을 수 없음
        }

        boolean isSender = message.getSenderId().equals(currentUserId);

        // 현재 사용자가 이 쪽지의 수신자인지 확인
        MessageReceiver currentUserReceiver = messageMapper.findAllReceiversByMessageId(messageId).stream()
                .filter(r -> r.getReceiverId().equals(currentUserId) && "N".equals(r.getIsDeleted())) // 삭제되지 않은 기록만
                .findFirst()
                .orElse(null);

        // 조회 권한 확인: 발신자이거나 유효한 수신자 기록이 있을 경우에만 조회 허용
        if (!isSender && currentUserReceiver == null) {
            return null; // 조회 권한 없음
        }

        // 수신자가 회수된 쪽지를 조회하려고 할 경우 (발신자는 회수된 쪽지도 볼 수 있음)
        if (!isSender && currentUserReceiver != null && "RECALLED_BY_SENDER".equals(currentUserReceiver.getInboxStatus())) {
            return null; // 수신자에게는 회수된 쪽지처럼 보이도록 (실제로는 내용이 "회수된 쪽지"로 바뀔 수 있음)
        }

        MessageDetailResponseDto detailDto = new MessageDetailResponseDto();
        detailDto.setMessageId(message.getMessageId());
        detailDto.setSenderId(message.getSenderId());
        detailDto.setSenderName(userMapper.findUserNmByUserId(message.getSenderId())); // 발신자 이름 조회
        detailDto.setSubject(message.getSubject());
        detailDto.setMessageContent(message.getMessageContent());
        detailDto.setSendDate(message.getSendDate());
        detailDto.setRecallAble(message.getRecallAble());
        detailDto.setReceiveId(currentUserReceiver != null ? currentUserReceiver.getReceiveId() : null); // 수신 기록 ID
        detailDto.setInboxStatus(currentUserReceiver != null ? currentUserReceiver.getInboxStatus() : null); // 받은 쪽지함 상태
        detailDto.setImportantYn(currentUserReceiver != null ? currentUserReceiver.getImportantYn() : null); // 중요 표시 여부


        // TO, CC 수신자 이름 목록 (BCC는 발신자에게만 보임)
        detailDto.setToUserNames(messageMapper.findReceiverUserNamesByMessageIdAndType(messageId, "TO"));
        detailDto.setCcUserNames(messageMapper.findReceiverUserNamesByMessageIdAndType(messageId, "CC"));

        // BCC 수신자 이름 목록은 발신자에게만 보이도록 처리
        if (isSender) {
            detailDto.setBccUserNames(messageMapper.findReceiverUserNamesByMessageIdAndType(messageId, "BCC"));
        } else {
            // 현재 조회하는 사용자가 BCC 수신자인 경우, 자신의 이름만 BCC 목록에 추가 (다른 BCC는 보이지 않음)
            if (currentUserReceiver != null && "BCC".equals(currentUserReceiver.getReceiverType())) {
                detailDto.getBccUserNames().add(userMapper.findUserNmByUserId(currentUserId));
            }
        }

        // 수신자이고, 아직 읽지 않은 쪽지라면 읽음 처리
        if (currentUserReceiver != null && "UNREAD".equals(currentUserReceiver.getInboxStatus())) {
            messageMapper.updateMessageReceiverReadDate(currentUserReceiver.getReceiveId());
            // 알림 읽음 처리 및 읽지 않은 카운트 업데이트 (향후 구현 시 주석 해제)
            // notificationService.markNotificationsAsReadByTargetUrlAndUser("/message/inbox?messageId=" + messageId, currentUserId);
            // unreadCountService.updateAndSendUnreadCounts(currentUserId);
        }

        // 회수 가능 여부 계산 (현재 시점에서 회수 가능한지)
        if ("Y".equals(message.getRecallAble()) && isSender) { // 발신자이고 회수 가능 설정일 때만
            int unreadCount = messageMapper.countUnreadReceiversByMessageId(messageId);
            int totalReceiversCount = messageMapper.countTotalReceiversByMessageId(messageId);
            // 모든 수신자가 읽지 않았고, 삭제되지 않은 상태일 때만 '현재 회수 가능'
            detailDto.setCurrentlyRecallable(unreadCount > 0 && unreadCount == totalReceiversCount);
        } else {
            detailDto.setCurrentlyRecallable(false);
        }

        return detailDto;
    }


    // **쪽지 상태 변경 관련 메서드**

    /**
     * 보낸 쪽지를 회수하는 메서드.
     * 모든 수신자가 아직 쪽지를 읽지 않았을 경우에만 회수 가능합니다.
     *
     * @param messageId 회수할 쪽지의 MESSAGE_ID
     * @param currentUserId 회수를 요청하는 사용자의 USER_ID (발신자여야 함)
     * @return 회수 성공 여부
     */
    @Transactional
    public boolean recallMessage(Long messageId, Long currentUserId) {
        Message message = messageMapper.findMessageDetailById(messageId);

        // 1. 쪽지 존재 여부 및 발신자 확인
        if (message == null || !message.getSenderId().equals(currentUserId)) {
            return false; // 쪽지를 찾을 수 없거나 발신자가 아님
        }
        // 2. 쪽지가 회수 가능한지 설정 확인
        if (!"Y".equals(message.getRecallAble())) {
            return false; // 회수 불가능하게 설정된 쪽지
        }

        // 3. 모든 수신자가 아직 읽지 않았는지 확인
        int unreadCount = messageMapper.countUnreadReceiversByMessageId(messageId);
        int totalReceiversCount = messageMapper.countTotalReceiversByMessageId(messageId);

        // 읽지 않은 수신자가 0명이 아니면서, 동시에 전체 수신자 수와 같아야 함 (모두 읽지 않았을 때만)
        if (unreadCount == 0 || unreadCount != totalReceiversCount) {
            return false; // 이미 일부라도 읽었거나, 수신자가 없는 경우
        }

        // 4. 회수 처리: 모든 수신자의 쪽지 상태를 'RECALLED_BY_SENDER'로 변경
        int updatedRows = messageMapper.updateInboxStatusToRecalled(messageId);

        if (updatedRows > 0) {
            // 회수된 쪽지에 대한 알림 처리 (향후 구현 시 주석 해제)
            // List<MessageReceiver> receivers = messageMapper.findAllReceiversByMessageId(messageId);
            // String recalledMessageContent = "[" + userMapper.findUserNmByUserId(currentUserId) + "님이 쪽지를 회수했습니다.]";
            // for (MessageReceiver receiver : receivers) {
            //     notificationService.updateNotificationContent("/message/inbox?messageId=" + messageId, receiver.getReceiverId(), recalledMessageContent);
            //     unreadCountService.updateAndSendUnreadCounts(receiver.getReceiverId());
            // }
            // unreadCountService.updateAndSendUnreadCounts(currentUserId); // 발신자의 카운트 업데이트
            return true;
        }
        return false;
    }

    /**
     * 받은 쪽지함에서 쪽지를 삭제 처리합니다. (실제 데이터 삭제 아님, IS_DELETED = 'Y')
     * @param receiveId 삭제할 수신 기록의 RECEIVE_ID
     * @param userId 삭제를 요청하는 사용자의 USER_ID (해당 쪽지의 수신자여야 함)
     * @return 삭제 성공 여부
     */
    @Transactional
    public boolean deleteReceivedMessage(Long receiveId, Long userId) {
        // 실제로는 receiveId에 해당하는 쪽지의 receiverId가 userId와 일치하는지 검증 로직이 필요
        // (현재 Mapper 쿼리에서 userId를 받지 않으므로, 이 부분은 서비스 레벨에서 DTO에 userId를 추가하여 처리하거나,
        // Mapper에서 recvId와 userId를 함께 검증하도록 변경해야 함.)
        int updated = messageMapper.updateMessageReceiverIsDeleted(receiveId, "Y");
        if (updated > 0) {
            // 읽지 않은 카운트 업데이트 (향후 구현 시 주석 해제)
            // unreadCountService.updateAndSendUnreadCounts(userId);
        }
        return updated > 0;
    }

    /**
     * 보낸 쪽지함에서 쪽지를 삭제 처리합니다. (실제 데이터 삭제 아님, IS_DELETED = 'Y')
     * @param sendId 삭제할 발신 기록의 SEND_ID
     * @param userId 삭제를 요청하는 사용자의 USER_ID (해당 쪽지의 발신자여야 함)
     * @return 삭제 성공 여부
     */
    @Transactional
    public boolean deleteSentMessage(Long sendId, Long userId) {
        // 실제로는 sendId에 해당하는 쪽지의 senderId가 userId와 일치하는지 검증 로직이 필요
        int updated = messageMapper.updateMessageSenderIsDeleted(sendId, "Y");
        return updated > 0;
    }

    /**
     * 받은 쪽지함의 쪽지를 중요 표시하거나 해제합니다.
     * @param receiveId 변경할 수신 기록의 RECEIVE_ID
     * @param userId 요청하는 사용자의 USER_ID
     * @param importantYn 변경할 중요 표시 상태 ('Y' 또는 'N')
     * @return 변경 성공 여부
     */
    @Transactional
    public boolean toggleImportantReceivedMessage(Long receiveId, Long userId, String importantYn) {
        // 실제로는 receiveId에 해당하는 쪽지의 receiverId가 userId와 일치하는지 검증 로직이 필요
        int updated = messageMapper.updateMessageReceiverImportantYn(receiveId, importantYn);
        return updated > 0;
    }

    /**
     * 특정 수신자의 읽지 않은 쪽지 수를 조회합니다. (SSE 알림에 사용)
     * @param userId 수신자 USER_ID
     * @return 읽지 않은 쪽지 수
     */
    public int countUnreadReceivedMessages(Long userId) {
        return messageMapper.countUnreadReceivedMessages(userId);
    }


    /**
     * 답장 쪽지 발송을 위한 MessageSendRequestDto를 준비합니다.
     * 원본 쪽지의 발신자를 수신자로 설정하고, 제목을 'Re:'로 시작하게 변경합니다.
     *
     * @param originalMessageId 원본 쪽지의 MESSAGE_ID
     * @return 준비된 MessageSendRequestDto 또는 null (원본 쪽지를 찾을 수 없을 경우)
     */
    public MessageSendRequestDto prepareReplyMessage(Long originalMessageId) {
        Message originalMessage = messageMapper.findMessageDetailById(originalMessageId);
        if (originalMessage == null) {
            return null;
        }

        MessageSendRequestDto replyDto = new MessageSendRequestDto();
        replyDto.setSubject("Re: " + originalMessage.getSubject()); // 제목에 'Re:' 추가
        replyDto.getReceiverIds().add(originalMessage.getSenderId()); // 원본 발신자를 TO 수신자로 설정

        // 원본 내용 포함 (HTML 태그 처리 및 들여쓰기 등 필요 시 클라이언트에서 처리)
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        StringBuilder contentBuilder = new StringBuilder();
        contentBuilder.append("\n\n--- 원본 쪽지 ---\n");
        contentBuilder.append("보낸 사람: ").append(userMapper.findUserNmByUserId(originalMessage.getSenderId())).append(" (").append(originalMessage.getSenderId()).append(")\n");
        contentBuilder.append("제목: ").append(originalMessage.getSubject()).append("\n");
        contentBuilder.append("발송일: ").append(sdf.format(originalMessage.getSendDate())).append("\n");
        contentBuilder.append("--------------------\n");
        contentBuilder.append(originalMessage.getMessageContent()); // 컬럼명 변경 반영
        replyDto.setMessageContent(contentBuilder.toString()); // 컬럼명 변경 반영

        // CC, BCC는 답장 시 기본적으로 비워둠
        return replyDto;
    }

    /**
     * 전달 쪽지 발송을 위한 MessageSendRequestDto를 준비합니다.
     * 원본 쪽지의 제목을 'Fwd:'로 시작하게 변경하고, 내용을 인용하여 포함합니다.
     *
     * @param originalMessageId 원본 쪽지의 MESSAGE_ID
     * @return 준비된 MessageSendRequestDto 또는 null (원본 쪽지를 찾을 수 없을 경우)
     */
    public MessageSendRequestDto prepareForwardMessage(Long originalMessageId) {
        Message originalMessage = messageMapper.findMessageDetailById(originalMessageId);
        if (originalMessage == null) {
            return null;
        }

        List<String> originalToNames = messageMapper.findReceiverUserNamesByMessageIdAndType(originalMessageId, "TO");
        List<String> originalCcNames = messageMapper.findReceiverUserNamesByMessageIdAndType(originalMessageId, "CC");

        MessageSendRequestDto forwardDto = new MessageSendRequestDto();
        forwardDto.setSubject("Fwd: " + originalMessage.getSubject()); // 제목에 'Fwd:' 추가

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        StringBuilder contentBuilder = new StringBuilder();
        contentBuilder.append("\n\n--- 전달된 쪽지 ---\n");
        contentBuilder.append("보낸 사람: ").append(userMapper.findUserNmByUserId(originalMessage.getSenderId())).append(" (").append(originalMessage.getSenderId()).append(")\n");
        contentBuilder.append("받는 사람 (TO): ").append(originalToNames.isEmpty() ? "-" : String.join(", ", originalToNames)).append("\n");
        if (!originalCcNames.isEmpty()) {
            contentBuilder.append("참조 (CC): ").append(String.join(", ", originalCcNames)).append("\n");
        }
        contentBuilder.append("발송일: ").append(sdf.format(originalMessage.getSendDate())).append("\n");
        contentBuilder.append("제목: ").append(originalMessage.getSubject()).append("\n");
        contentBuilder.append("--------------------\n");
        contentBuilder.append(originalMessage.getMessageContent()); // 컬럼명 변경 반영
        forwardDto.setMessageContent(contentBuilder.toString()); // 컬럼명 변경 반영

        // 전달 시 수신자는 비워둠 (사용자가 직접 입력하도록)
        return forwardDto;
    }
}