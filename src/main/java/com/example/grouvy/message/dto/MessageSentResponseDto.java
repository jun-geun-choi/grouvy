package com.example.grouvy.message.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
public class MessageSentResponseDto {
    private Long messageId;
    private int senderId;
    private String subject;
    private String messageContent;
    private Date sendDate;
    private String recallAble;
    private Long sendId;
    private boolean currentlyRecallable;
}
