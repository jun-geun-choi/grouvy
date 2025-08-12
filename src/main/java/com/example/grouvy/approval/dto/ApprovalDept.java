package com.example.grouvy.approval.dto;

import com.example.grouvy.department.vo.Department;
import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

@Getter
@Setter
@Alias("ApprovalDept")
public class ApprovalDept {
    private int departmentId;
    private String departmentName;
    private int parentDepartmentId;
}
