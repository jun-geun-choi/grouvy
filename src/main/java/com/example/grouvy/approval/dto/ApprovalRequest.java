package com.example.grouvy.approval.dto;

import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;
import java.util.List;

@Getter
@Setter
@Alias("ApprovalRequest")
public class ApprovalRequest {

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date createdDate;
    private int formNo;
    private String writerId;
    private String writerName;
    private String approvalDepartmentName;
    private String receiverDepartmentName;
    private String title;
    private String formData;
    private List<Integer> approversNo;

}
