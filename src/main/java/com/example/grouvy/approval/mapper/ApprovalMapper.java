package com.example.grouvy.approval.mapper;
import com.example.grouvy.approval.dto.*;
import com.example.grouvy.approval.vo.Approval;
import com.example.grouvy.approval.vo.Approver;
import com.example.grouvy.approval.vo.Delegation;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface ApprovalMapper {
    List<ApprovalDept> getAllDepts();
    List<ApprovalEmp> getAllEmps();
    List<ApprovalDept> getAllTeams();
    List<ApprovalWait> getApprovalsWait(int employeeNo);
    List<ApprovalWait> getDelegatedWaitingApprovals(int employeeNo);
    List<DetailApprover> getApproversByApprovalNo(int approvalNo);
    Approval getApprovalByapprovalNo(int approvalNo);
    ApprovalWriter getWriterByApprovalNo(int approvalNo);
    void insertApproval(Approval approval);
    void insertApprover(Approver approver);
    void updateStatusAndApprovedDate(ApprovalDecisionRequest approvalDecisionRequest);
    int getApproverStep(ApprovalDecisionRequest approvalDecisionRequest);
    Integer getNextStepApprover(int nextStep, int approvalNo);
    void updateNextStepStatusAndAssignedDate(int nextStep, int approvalNo);
    void updateApprovalApproveStatus(int approvalNo);
    void updateRejectStatusAndDecisionDate(ApprovalDecisionRequest approvalDecisionRequest);
    void updateApprovalRejectStatus(int approvalNo);
    void insertDelegation(Delegation delegation);
    void updateDelegateeNo(Delegation delegation);
    Integer getIsDelegating(int approverNo);
    ApproverPreview getApproverPreviewByApproverNo(int approverNo);
    Integer getIsDelegatingByDelegationNo(int delegationNo);
    Integer getIsDelegatee(DetailApprover detailApprover);
    Integer getDelegateeIdByApprovalNo(int approvalNo);
    void updateDelegateeStatusAndDecisionDate(ApprovalDecisionRequest approvalDecisionRequest);
    int getApproverIdByapprovalDecisionRequest(ApprovalDecisionRequest approvalDecisionRequest);
    Delegatee getDelegationByEmpNo(int empNo);
    void deleteDelegation(int delegationNo);
    void updateApprovalDelegatee(int empNo);
    String getUserStatus(int delegateeNo);
    Boolean getIsUserAlreadyDelegateeByEmpNo(int delegatorNo);
    List<MyRequestApproval> getMyRequestApprovals(int empNo);
    void updateApproveCompletedDate(int step,int approvalNo);
    List<ApprovalProgress> getApprovalProgresses(int empNo);
    List<ApprovalProgress> getApprovalCompletes(int empNo);
    List<ApprovalProgress> getApprovalRejects(int empNo);
}
