package com.example.grouvy.approval.dto;

import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

import java.util.Date;

@Getter
@Setter
@Alias("DetailApprover")
public class DetailApprover {
    private int no;
    private int approverId;
    private String approverName;
    private int approvalNo;
    private int step;
    private String status;
    private Date approvedDate;
    private Date assignedDate;
    private String positionName;
    private String Isdelegatee;
    private String opinion;
}
