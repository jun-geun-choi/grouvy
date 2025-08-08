package com.example.grouvy.chat.dto;

import java.util.List;
import lombok.Getter;

@Getter
public class ParentDeptDto {
  private String parentDeptName;                //부모 부서 이름 : 대표 이사, 본부, null
  private List<DeptAndUserDto> deptAndUserDtos; //자식 부서 데이터

  public ParentDeptDto(String parentDeptName, List<DeptAndUserDto> deptAndUserDtos) {
    this.parentDeptName = parentDeptName;
    this.deptAndUserDtos = deptAndUserDtos;
  }

}
