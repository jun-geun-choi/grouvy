package com.example.grouvy.approval.dto;

import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

@Getter
@Setter
@Alias("ApprovalWait")
public class ApprovalWait {
    private int approvalNo;
    private String title;
    private String writerName;
    private int writerId;
    private String approvalDepartmentName;

    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createdDate;
    private Date assignedDate;
}
