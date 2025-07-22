package com.example.grouvy.department.vo;

import lombok.Getter;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
public class Department {
  private Long departmentId;
  private String departmentName;
  private Long parentDepartmentId;
  private Integer departmentOrder;
  private Date createdDate;
  private Date updatedDate;
  private String isDeleted;

  //DB에 1대1 매핑되는 컬럼은 아니지만 계층을 나타내기 위해 의사로 넣음.
  private Integer level;
}