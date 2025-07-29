package com.example.grouvy.message.vo;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MessageSender {
    private Long sendId;
    private Long messageId;
    private int senderId;
    private String isDeleted;
}
