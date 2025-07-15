package com.example.grouvy.message.vo;

import lombok.Getter;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
public class Message {
    private Long messageId;
    private Long senderId;
    private String subject;
    private String messageContent;
    private Date sendDate;
    private String recallAble;
    private Long sendId;
}
