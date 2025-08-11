package com.example.grouvy.approval.dto;

import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

@Getter
@Setter
@Alias("ApprovalEmp")
public class ApprovalEmp {

    private int empNo;
    private int departmentId;
    private String name;
    private String positionName;
}
