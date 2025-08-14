package com.example.grouvy.chat.dto;

import java.util.Date;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

@Getter
@Setter
@Alias("ChatRoomDto2")
@NoArgsConstructor
public class ChatRoomDto2 {
  private int roomId;
  private String lastMessage;
  private Date lastMessageDate;
  private String isGroup;
  private int unreadCnt;         // 채팅방에서 얼마큼 안 읽었는지
  private String roomName;
}
