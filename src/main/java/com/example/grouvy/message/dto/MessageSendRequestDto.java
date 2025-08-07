package com.example.grouvy.message.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
public class MessageSendRequestDto {
    private List<Integer> receiverIds = new ArrayList<>();
    private List<Integer> ccIds = new ArrayList<>();
    private List<Integer> bccIds = new ArrayList<>();
    private String subject;
    private String messageContent;

}
