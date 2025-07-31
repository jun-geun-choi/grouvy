package com.example.grouvy.chat.dto;

import com.example.grouvy.user.vo.User;
import lombok.Getter;

@Getter
public class UserDto {
  private int id; //userId
  private String userName; // name
  private String positionName;
  private String imgPath; // profileImgPath

  public UserDto(User user) {
    this.id = user.getUserId();
    this.userName = user.getName();
    this.positionName = user.getPosition().getPositionName();
    this.imgPath = user.getProfileImgPath();
  }
}
