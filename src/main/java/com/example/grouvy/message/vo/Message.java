package com.example.grouvy.message.vo;

import lombok.Getter;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
public class Message {
    private Long messageId;
    private int senderId;
    private String subject;
    private String messageContent;
    private Date sendDate;
    private String recallAble;

    //message_send 테이블과 조인
    private Long sendId;
}
