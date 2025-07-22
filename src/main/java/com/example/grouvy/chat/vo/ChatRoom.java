package com.example.grouvy.chat.vo;

import java.util.Date;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

@Getter
@Setter
@NoArgsConstructor
@Alias("ChatRoom")
public class ChatRoom {

  private long roomId;
  private String roomName;
  private String isGroup;
  private Date createDate;
  private Date updatedDate;
  private String isDeletd;
}
