package com.example.grouvy.approval.vo;

import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

import java.util.Date;

@Getter
@Setter
@Alias("Approval")
public class Approval {
    private int approvalNo;
    private String writerName;
    private String title;
    private String status;
    private int writerId;
    private Date createdDate;
    private int formNo;
    private String approvalDepartmentName;
    private String receiverDepartmentName;
    private String formData;
    private Date completedDate;
}
