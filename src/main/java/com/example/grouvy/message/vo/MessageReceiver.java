package com.example.grouvy.message.vo;

import lombok.Getter;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
public class MessageReceiver {
    private Long receiveId;
    private Long messageId;
    private int receiverId;
    private String receiverType;
    private Date readDate;
    private String inboxStatus;
    private String isDeleted;
    private String importantYn;

    //join필드
    private String senderName;
    private String subject;
    private Date sendDate;
}
