// src/main/java/com/example/grouvy/message/dto/MessageSentResponseDto.java
package com.example.grouvy.message.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
public class MessageSentResponseDto {
    private Long messageId; // 쪽지 고유 ID
    private Long senderId; // 발신자 USER_ID
    private String subject; // 쪽지 제목
    private String messageContent; // 쪽지 내용
    private Date sendDate; // 발송 일시
    private String recallAble; // 회수 가능 여부 (Y/N)
    private Long sendId; // GROUVY_MESSAGE_SEND 테이블의 SEND_ID (보낸 쪽지 기록의 고유 ID)
    private boolean currentlyRecallable; // 현재 시점에서 회수가 가능한지 여부
}