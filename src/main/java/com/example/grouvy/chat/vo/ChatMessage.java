package com.example.grouvy.chat.vo;

import com.example.grouvy.user.vo.User;
import java.util.Date;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

@Getter
@Setter
@NoArgsConstructor
@Alias("ChatMessage")
public class ChatMessage {
  private long chatMessageId;
  private long roomId;
  private int senderId;
  private String content;
  private Date createdDate;
  private String messageType;

  private ChatRoom  chatRoom;
  private User user;
}
