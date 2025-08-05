package com.example.grouvy.message.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Getter
@Setter
public class MessageDetailResponseDto {
    private Long messageId;
    private int senderId;
    private String senderName;
    private String subject;
    private String messageContent;
    private Date sendDate;
    private String recallAble;
    private boolean currentlyRecallable;

    //TO CC BCC 수신자 이름목록
    private List<String> toUserNames = new ArrayList<>();
    private List<String> ccUserNames = new ArrayList<>();
    private List<String> bccUserNames = new ArrayList<>();

    //기타 필요정보
    private Long receiveId;
    private String inboxStatus;
    private String importantYn;
}
