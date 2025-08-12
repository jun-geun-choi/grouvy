package com.example.grouvy.chat.dto;

import java.util.List;
import lombok.Getter;

@Getter
public class DeptAndUserDto {
  private String departmentName;      // 자식 부서 이름 : 본부 아래 팀 이름
  // 유저 정보만 담는 DTO
  private List<UserDto> members;      // 그 부서의 직원 or 직원들

  public DeptAndUserDto(String departmentName, List<UserDto> members) {
    this.departmentName = departmentName;
    this.members = members;
  }
}
