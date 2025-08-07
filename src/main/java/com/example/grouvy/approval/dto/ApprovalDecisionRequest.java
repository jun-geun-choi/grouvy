package com.example.grouvy.approval.dto;

import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

@Getter
@Setter
@Alias("ApprovalDecisionRequest")
public class ApprovalDecisionRequest {
    private int approvalNo;
    private int approverId;
    private String decision;
    private String opinion;

    public ApprovalDecisionRequest(int approvalNo, int approverId, String decision, String opinion) {
        this.approvalNo = approvalNo;
        this.approverId = approverId;
        this.decision   = decision;
        this.opinion    = opinion;
    }

}
