package com.example.grouvy.chat.dto;

import com.example.grouvy.chat.vo.ChatMessage;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import lombok.Getter;

@Getter
public class ChatMessageDto {

  private long chatMessageId;
  private int roomId;
  private int senderId;
  private String content;
  private Date createdDate;
  private String messgaeType;
  private int unreadCnt;


  private String isGroup;

  //User 정보
  private String name;
  private String profileImgPath;


  // 날짜 및 시간 데이터
  private String formattedDate;
  private String formattedTime;

  public ChatMessageDto(ChatMessage chatMessage) {
    this.chatMessageId = chatMessage.getChatMessageId();
    this.roomId = chatMessage.getRoomId();
    this.content = chatMessage.getContent();
    this.createdDate = chatMessage.getCreatedDate();
    this.senderId = chatMessage.getSenderId();
    this.messgaeType = chatMessage.getMessageType();
    this.name = chatMessage.getUser().getName();
    this.profileImgPath = chatMessage.getUser().getProfileImgPath();
    this.unreadCnt = chatMessage.getUnreadCnt();
    this.isGroup = chatMessage.getChatRoom().getIsGroup();

    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy년 MM월 dd일");
    SimpleDateFormat timeFormat = new SimpleDateFormat("a h시 mm분", Locale.KOREAN);
    this.formattedDate = dateFormat.format(createdDate);
    this.formattedTime = timeFormat.format(createdDate);
  }
}
