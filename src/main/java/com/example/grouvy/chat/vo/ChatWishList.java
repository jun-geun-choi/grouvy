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
@Alias("ChatWishList")
public class ChatWishList {
  private int userId;
  private int selectedUserId;
  private String memo;
  private Date createdDate;
  private Date updatedDate;

  private User user;
  private User selectedUser;

}
