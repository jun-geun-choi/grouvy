package com.example.grouvy.chat.vo;

import com.example.grouvy.user.vo.User;
import java.time.LocalDateTime;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

@Getter
@NoArgsConstructor
@Setter
@Alias("ChatRoomUser")
public class ChatRoomUser {
  private long roomId;
  private int userId;
  private String isActive;
  private LocalDateTime joinDate;
  private LocalDateTime leftDate;

  private ChatRoom chatRoom;
  private User user;
}
