package com.example.grouvy.user.dto;

import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

@Getter
@Setter
@Alias("UserUpdateRequest")
public class UserUpdateRequest {
    private int userId;
    private int managerId;
    private Long departmentId;
    private Integer positionNo;
    private String employmentStatus;
}
