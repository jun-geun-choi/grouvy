// src/main/java/com/example/grouvy/message/mapper/MessageMapper.java
package com.example.grouvy.message.mapper;

import com.example.grouvy.message.vo.Message;
import com.example.grouvy.message.vo.MessageReceiver;
import com.example.grouvy.message.vo.MessageSender;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface MessageMapper {

    //쪽지 발송.
    void insertMessage(Message message);
    void insertMessageSender(MessageSender sender);
    void insertMessageReceiver(MessageReceiver receiver);

    //페이지네이션
    List<MessageReceiver> findReceivedMessagesByReceiverIdPaginated(
            @Param("receiverId") int receiverId, // 현재 로그인한 사용자 ID
            @Param("offset") int offset,        // 건너뛸 레코드 수
            @Param("limit") int limit);         // 가져올 레코드 수
    List<Message> findSentMessagesBySenderIdPaginated(
            @Param("senderId") int senderId,
            @Param("offset") int offset,
            @Param("limit") int limit);
    List<MessageReceiver> findImportantMessagesByReceiverIdPaginated(
            @Param("receiverId") int receiverId,
            @Param("offset") int offset,
            @Param("limit") int limit);

    //쪽지 수신자이름 목록조회.
    List<String> findReceiverUserNamesByMessageIdAndType(
            @Param("messageId") Long messageId,
            @Param("receiverType") String receiverType);

    //받은쪽지
    int countTotalReceivedMessages(@Param("receiverId") int receiverId);

    //보낸쪽지
    int countTotalSentMessages(@Param("senderId") int senderId);
    int countUnreadReceiversByMessageId(@Param("messageId") Long messageId);
    int countTotalReceiversByMessageId(@Param("messageId") Long messageId);

    // **새롭게 추가:** 중요 쪽지 전체 개수 (페이지네이션을 위함)
    int countImportantMessages(@Param("receiverId") int receiverId);

    //메세지 회수
    Message findMessageDetailById(@Param("messageId") Long messageId);
    int updateInboxStatusToRecalled(@Param("messageId") Long messageId);
    List<MessageReceiver> findAllReceiversByMessageId(@Param("messageId") Long messageId);
    int updateMessageRecallAbleToN(@Param("messageId") Long messageId);

    //쪽지 crud
    int updateMessageReceiverReadDate(@Param("receiveId") Long receiveId);
    int updateMessageReceiverIsDeleted(@Param("receiveId") Long receiveId, @Param("isDeleted") String isDeleted);
    int updateMessageSenderIsDeleted(@Param("sendId") Long sendId, @Param("isDeleted") String isDeleted);
    int updateMessageReceiverImportantYn(@Param("receiveId") Long receiveId, @Param("importantYn") String importantYn);
    int countUnreadReceivedMessages(@Param("receiverId") int receiverId);

    //사용자조회
    MessageReceiver findReceiverById(@Param("receiveId") Long receiveId);
    MessageSender findSenderById(@Param("sendId") Long sendId);

}