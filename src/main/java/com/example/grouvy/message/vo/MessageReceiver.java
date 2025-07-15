package com.example.grouvy.message.vo;

import lombok.Getter;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
public class MessageReceiver {
    private Long receiveId;
    private Long MessageId;
    private Long receiverId;
    private String receiverType;
    private Date readDate;
    private String inboxStatus;
    private String isDeleted;;
    private String impotantYn;

    //join을 위한 필드(DB컬럼은 아님)
    private String senderName;
    private String subject;
    private Date sendDate;
}
