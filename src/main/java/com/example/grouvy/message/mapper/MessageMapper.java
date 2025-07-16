// src/main/java/com/example/grouvy/message/mapper/MessageMapper.java
package com.example.grouvy.message.mapper;

import com.example.grouvy.message.vo.Message;
import com.example.grouvy.message.vo.MessageReceiver;
import com.example.grouvy.message.vo.MessageSender;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param; // @Param 어노테이션 임포트

import java.util.List;

@Mapper
public interface MessageMapper {

    // 쪽지 발송 관련 메서드 (기존)
    void insertMessage(Message message);
    void insertMessageSender(MessageSender sender);
    void insertMessageReceiver(MessageReceiver receiver);

    // **새로 추가될 쪽지 목록 조회 및 상세 보기 관련 메서드**

    /**
     * 특정 수신자(receiverId)의 받은 쪽지 목록을 페이징하여 조회합니다.
     * 삭제되지 않았고, 회수되지 않은 쪽지만 포함합니다.
     *
     * @param receiverId 쪽지 수신자의 USER_ID
     * @param offset     조회를 시작할 OFFSET (페이징)
     * @param limit      가져올 항목의 수 (페이징)
     * @return MessageReceiver VO 객체들의 리스트 (발신자 이름, 제목, 발송일시 포함)
     */
    List<MessageReceiver> findReceivedMessagesByReceiverIdPaginated(
            @Param("receiverId") Long receiverId,
            @Param("offset") int offset,
            @Param("limit") int limit);

    /**
     * 특정 수신자(receiverId)의 받은 쪽지 중 총 항목 수를 조회합니다. (페이징을 위해)
     *
     * @param receiverId 쪽지 수신자의 USER_ID
     * @return 총 받은 쪽지 수
     */
    int countTotalReceivedMessages(@Param("receiverId") Long receiverId);

    /**
     * 특정 수신자(receiverId)의 중요 표시된 받은 쪽지 목록을 페이징하여 조회합니다.
     *
     * @param receiverId 쪽지 수신자의 USER_ID
     * @param offset     조회를 시작할 OFFSET (페이징)
     * @param limit      가져올 항목의 수 (페이징)
     * @return MessageReceiver VO 객체들의 리스트
     */
    List<MessageReceiver> findImportantMessagesByReceiverIdPaginated(
            @Param("receiverId") Long receiverId,
            @Param("offset") int offset,
            @Param("limit") int limit);

    /**
     * 특정 수신자(receiverId)의 중요 표시된 받은 쪽지 중 총 항목 수를 조회합니다. (페이징을 위해)
     *
     * @param receiverId 쪽지 수신자의 USER_ID
     * @return 총 중요 쪽지 수
     */
    int countImportantMessages(@Param("receiverId") Long receiverId);

    /**
     * 특정 발신자(senderId)의 보낸 쪽지 목록을 페이징하여 조회합니다.
     * 삭제되지 않은 쪽지만 포함합니다.
     *
     * @param senderId 쪽지 발신자의 USER_ID
     * @param offset   조회를 시작할 OFFSET (페이징)
     * @param limit    가져올 항목의 수 (페이징)
     * @return Message VO 객체들의 리스트 (보낸 쪽지함 상세 정보 포함)
     */
    List<Message> findSentMessagesBySenderIdPaginated(
            @Param("senderId") Long senderId,
            @Param("offset") int offset,
            @Param("limit") int limit);

    /**
     * 특정 발신자(senderId)의 보낸 쪽지 중 총 항목 수를 조회합니다. (페이징을 위해)
     *
     * @param senderId 쪽지 발신자의 USER_ID
     * @return 총 보낸 쪽지 수
     */
    int countTotalSentMessages(@Param("senderId") Long senderId);

    /**
     * 특정 MSG_ID로 쪽지 본문 상세 정보를 조회합니다.
     * 이 쿼리는 MessageSender의 sendId까지 함께 가져올 수 있도록 조인될 수 있습니다.
     *
     * @param messageId 조회할 쪽지의 MESSAGE_ID
     * @return Message VO 객체 (senderId, subject, messageContent 등)
     */
    Message findMessageDetailById(@Param("messageId") Long messageId);

    /**
     * 특정 MSG_ID의 수신자 목록에서 USER_ID와 RECEIVER_TYPE을 기반으로 User.name을 조회합니다.
     * (TO/CC/BCC에 해당하는 사용자 이름 목록을 가져오기 위함)
     *
     * @param messageId 쪽지 ID
     * @param receiverType 수신자 타입 (TO, CC, BCC)
     * @return 해당 타입의 수신자 이름 목록
     */
    List<String> findReceiverUserNamesByMessageIdAndType(
            @Param("messageId") Long messageId,
            @Param("receiverType") String receiverType);

    /**
     * 특정 MSG_ID의 모든 수신자 기록을 조회합니다. (회수 기능 등에서 필요)
     *
     * @param messageId 쪽지 ID
     * @return MessageReceiver VO 객체들의 리스트
     */
    List<MessageReceiver> findAllReceiversByMessageId(@Param("messageId") Long messageId);

    /**
     * 특정 MSG_ID의 읽지 않은 수신자 수를 조회합니다. (회수 가능 여부 판단)
     *
     * @param messageId 쪽지 ID
     * @return 읽지 않은 수신자 수
     */
    int countUnreadReceiversByMessageId(@Param("messageId") Long messageId);

    /**
     * 특정 MSG_ID의 전체 수신자 수를 조회합니다. (회수 가능 여부 판단)
     *
     * @param messageId 쪽지 ID
     * @return 전체 수신자 수
     */
    int countTotalReceiversByMessageId(@Param("messageId") Long messageId);


    // **쪽지 상태 변경 관련 메서드**

    /**
     * 받은 쪽지함의 읽음 상태를 'READ'로 변경하고 읽은 일시를 업데이트합니다.
     *
     * @param receiveId 업데이트할 수신 기록의 RECEIVE_ID
     * @return 업데이트된 행의 수
     */
    int updateMessageReceiverReadDate(@Param("receiveId") Long receiveId);

    /**
     * 받은 쪽지함의 IS_DELETED 상태를 'Y'로 변경하여 삭제 처리합니다.
     *
     * @param receiveId 업데이트할 수신 기록의 RECEIVE_ID
     * @param isDeleted 변경할 삭제 여부 ('Y' 또는 'N')
     * @return 업데이트된 행의 수
     */
    int updateMessageReceiverIsDeleted(@Param("receiveId") Long receiveId, @Param("isDeleted") String isDeleted);

    /**
     * 보낸 쪽지함의 IS_DELETED 상태를 'Y'로 변경하여 삭제 처리합니다.
     *
     * @param sendId 업데이트할 발신 기록의 SEND_ID
     * @param isDeleted 변경할 삭제 여부 ('Y' 또는 'N')
     * @return 업데이트된 행의 수
     */
    int updateMessageSenderIsDeleted(@Param("sendId") Long sendId, @Param("isDeleted") String isDeleted);

    /**
     * 받은 쪽지함의 INBOX_STATUS를 'RECALLED_BY_SENDER'로 변경합니다. (쪽지 회수 시)
     *
     * @param messageId 회수할 쪽지의 MESSAGE_ID
     * @return 업데이트된 행의 수
     */
    int updateInboxStatusToRecalled(@Param("messageId") Long messageId);

    /**
     * 받은 쪽지함의 IMPORTANT_YN 상태를 변경합니다.
     *
     * @param receiveId 업데이트할 수신 기록의 RECEIVE_ID
     * @param importantYn 변경할 중요 표시 여부 ('Y' 또는 'N')
     * @return 업데이트된 행의 수
     */
    int updateMessageReceiverImportantYn(@Param("receiveId") Long receiveId, @Param("importantYn") String importantYn);

    /**
     * 특정 수신자의 읽지 않은 쪽지 수를 조회합니다. (SSE 알림에 사용)
     * @param receiverId 수신자 USER_ID
     * @return 읽지 않은 쪽지 수
     */
    int countUnreadReceivedMessages(@Param("receiverId") Long receiverId);
}