package com.example.grouvy.chat.dto;

import java.util.List;
import lombok.Getter;

@Getter
public class DeptAndUserDto {
  private String departmentName;
  private List<UserDto> members;

  public DeptAndUserDto(String departmentName, List<UserDto> members) {
    this.departmentName = departmentName;
    this.members = members;
  }
}
