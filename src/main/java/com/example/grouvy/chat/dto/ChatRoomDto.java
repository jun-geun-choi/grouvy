package com.example.grouvy.chat.dto;

import java.util.Date;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

@Getter
@Setter
@Alias("ChatRoomDto")
@NoArgsConstructor
public class ChatRoomDto {
  private int roomId;
  private String lastMessage;
  private Date lastMessageDate;
  private String isGroup;
  private String roomName;
  private int unreadCnt;         // 채팅방에서 얼마큼 안 읽었는지
  private String profileImgPath;


}

