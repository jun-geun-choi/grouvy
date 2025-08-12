package com.example.grouvy.user.dto;

import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

@Getter
@Setter
@Alias("UserApprovalRequest")
public class UserApprovalRequest {
    private int approvalId;
    private int userId;
    private Integer employeeNo;
    private Long departmentId;
    private Integer positionNo;
    private String action;
}
