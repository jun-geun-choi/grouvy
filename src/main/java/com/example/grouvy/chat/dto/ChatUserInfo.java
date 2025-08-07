package com.example.grouvy.chat.dto;

import com.example.grouvy.user.vo.User;
import lombok.Getter;

@Getter
public class ChatUserInfo {
  private String profileImgPath;
  private String name;
  private String positionName;
  private String deptName;
  private String phoneNumber;
  private String email;
  private int userId;

  public ChatUserInfo(User user) {
    this.profileImgPath = user.getProfileImgPath();
    this.name = user.getName();
    this.positionName = user.getPosition().getPositionName();
    this.deptName = user.getDepartment().getDepartmentName();
    this.phoneNumber = user.getPhoneNumber();
    this.email = user.getEmail();
    this.userId = user.getUserId();
  }
}
