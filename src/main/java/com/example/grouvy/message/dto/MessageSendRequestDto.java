package com.example.grouvy.message.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
public class MessageSendRequestDto {
    private List<Long> receiverIds = new ArrayList<>();
    private List<Long> ccIds = new ArrayList<>();
    private List<Long> bccIds = new ArrayList<>();
    private String subject;
    private String messageContent;
}
