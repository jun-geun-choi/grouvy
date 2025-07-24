package com.example.grouvy.chat.dto;

import com.example.grouvy.user.vo.User;
import lombok.Getter;

@Getter
public class ChatMyList {
  private int userId;
  private String name;
  private String  positionName;
  private String departmentName;
  private String profileImgpath;

  public ChatMyList(User user) {
    this.userId = user.getUserId();
    this.name = user.getName();
    this.positionName = user.getPosition().getPositionName();
    this.departmentName = user.getDepartment().getDepartmentName();
    this.profileImgpath = user.getProfileImgPath();
  }
}
