package com.example.grouvy.approval.service;

import com.example.grouvy.approval.dto.*;
import com.example.grouvy.approval.mapper.ApprovalMapper;
import com.example.grouvy.approval.vo.Approval;
import com.example.grouvy.approval.vo.Approver;
import com.example.grouvy.approval.vo.Delegation;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Service
public class ApprovalService {

    @Autowired
    private ModelMapper modelMapper;

    @Autowired
    private ApprovalMapper approvalMapper;


    public List<ApprovalDept> getAlldepts() {
        List<ApprovalDept> depts = approvalMapper.getAllDepts();
        return depts;
    }

    public List<ApprovalEmp> getAllEmps() {
        List<ApprovalEmp> emps = approvalMapper.getAllEmps();
        return emps;
    }

    public List<ApprovalDept> getAllTeams() {
        List<ApprovalDept> teams = approvalMapper.getAllTeams();
        return teams;
    }

    public void createApproval(ApprovalRequest approvalRequest) {
        approvalRequest.setCreatedDate(new Date());
        Approval approval = modelMapper.map(approvalRequest, Approval.class);
        approvalMapper.insertApproval(approval);
        int approvalNo = approval.getApprovalNo();
        for(int i = 1; i<= approvalRequest.getApproversNo().size(); i++) {
            Approver approver = new Approver();
            if (i == 1) {
                approver.setStatus("진행중");
                approver.setAssignedDate(new Date());
            } else {
                approver.setStatus("대기중");
            }
            Integer delegateeNo = approvalMapper.getIsDelegating(approvalRequest.getApproversNo().get(i-1));
            if(delegateeNo != null) {
                approver.setDelegateeNo(delegateeNo);
            }
            approver.setApproverId(approvalRequest.getApproversNo().get(i-1));
            approver.setApprovalNo(approvalNo);
            approver.setStep(i);
            approvalMapper.insertApprover(approver);
        }
    }

    public List<ApprovalWait> getWaitingApprovalsByEmployeeNo(int employeeNo) {
        List<ApprovalWait> approvalDelegatedWaits = approvalMapper.getDelegatedWaitingApprovals(employeeNo); // 수임 문서
        List<ApprovalWait> approvalWaits = approvalMapper.getApprovalsWait(employeeNo);
        approvalWaits.addAll(approvalDelegatedWaits);

        return approvalWaits;
    }

    public Approval getBookApprovalByApprovalNo(int approvalNo) {
        return approvalMapper.getApprovalByapprovalNo(approvalNo);
    }

    public List<DetailApprover> getBookApproversByApprovalNo(int approvalNo) {
        List<DetailApprover> detailApprovers = approvalMapper.getApproversByApprovalNo(approvalNo);
        for(DetailApprover detailApprover : detailApprovers) {
            Integer delegateeId = approvalMapper.getIsDelegatee(detailApprover);
            if(delegateeId != null) {
                detailApprover.setIsdelegatee("(위임중)");
            }
        }
        return detailApprovers;
    }

    public ApprovalWriter getBookWriterByApprovalNo(int approvalNo) {
        return approvalMapper.getWriterByApprovalNo(approvalNo);
    }

    public void processApprovalDecision(ApprovalDecisionRequest approvalDecisionRequest) {
        // 해당 결재자의 결재순서를 DB에서 가져온다.
        int step = approvalMapper.getApproverStep(approvalDecisionRequest);
        // 위임자 아이디를 받아온다.
        Integer delegateeId = approvalMapper.getDelegateeIdByApprovalNo(approvalDecisionRequest.getApprovalNo());
        // 넘어온 결재자의 아이디와 위임자의 아이디가 같다면 결재자는 위임자이다.
        if(delegateeId != null) {
            int approverId = approvalMapper.getApproverIdByapprovalDecisionRequest(approvalDecisionRequest);
            approvalDecisionRequest.setApproverId(approverId);
        }

        // 결재가 승인이면..
        if("approve".equals(approvalDecisionRequest.getDecision())) {
            // 해당 결재자의 상태(진행중 -> 결재완료)와 승인날짜를 업데이트
            approvalMapper.updateStatusAndApprovedDate(approvalDecisionRequest);
            int nextStep = step + 1;
            // 다음 결재자가 존재한다면..
            if(approvalMapper.getNextStepApprover(nextStep, approvalDecisionRequest.getApprovalNo()) != null) {
                // 다음 결재자의 상태(대기중 -> 진행중)와 배정날짜를 업데이트
                approvalMapper.updateNextStepStatusAndAssignedDate(nextStep, approvalDecisionRequest.getApprovalNo());
            } else {
                // 해당 문서의 상태를(진행중 -> 결재완료), approval의 completedDate 업데이트
                approvalMapper.updateApprovalApproveStatus(approvalDecisionRequest.getApprovalNo());
                approvalMapper.updateApproveCompletedDate(step,approvalDecisionRequest.getApprovalNo());
            }
          // 결재가 반려라면..
        } else {
            // 결재자의 상태(진행중 -> 반려), decisionDate를 업데이트
            approvalMapper.updateRejectStatusAndDecisionDate(approvalDecisionRequest);
            approvalMapper.updateApprovalRejectStatus(approvalDecisionRequest.getApprovalNo());
        }
    }

    public void createDelegation(Delegation delegation) {
        Delegatee delegatee = approvalMapper.getDelegationByEmpNo(delegation.getDelegatorNo());
        if(delegatee != null) {
            throw new IllegalStateException("이미 위임한 직원이 있습니다. 위임은 한 명에게만 가능합니다.");
        }
        String status = approvalMapper.getUserStatus(delegation.getDelegateeNo());
        if("휴직".equals(status) || "퇴사".equals(status)) {
            throw new IllegalStateException("휴직, 퇴사한 직원에게는 위임을 할 수 없습니다.");
        }
        if(approvalMapper.getIsUserAlreadyDelegateeByEmpNo(delegation.getDelegatorNo())){
            throw new IllegalStateException("위임받은 사람은 다시 위임할 수 없습니다.");
        }

        // 위임테이블에 위임정보 추가
        approvalMapper.insertDelegation(delegation);
        int delegationNo = delegation.getDelegationNo();
        Integer result = approvalMapper.getIsDelegatingByDelegationNo(delegationNo);
        // 결재선 테이블에 위임자 사원번호 업데이트
        if(result != null){
            approvalMapper.updateDelegateeNo(delegation);
        }
    }

    public List<ApproverPreview> isDelegating(List<Integer> approversNo) {
        List<ApproverPreview> approverPreviews = new ArrayList<>();
        for(int approverNo : approversNo) {
            ApproverPreview approverPreview = new ApproverPreview();
            Integer result = approvalMapper.getIsDelegating(approverNo);
            if(result != null) {
                approverPreview = approvalMapper.getApproverPreviewByApproverNo(approverNo);
                approverPreview.setName(approverPreview.getName() + "(위임 중)");
            } else {
                approverPreview = approvalMapper.getApproverPreviewByApproverNo(approverNo);
            }
            approverPreviews.add(approverPreview);
        }
        return approverPreviews;
    }

    public Delegatee getDelegationByUserId(int empNo) {
        return approvalMapper.getDelegationByEmpNo(empNo);
    }

    public void deleteDelegation(int delegationNo, int empNo) {
        approvalMapper.deleteDelegation(delegationNo);
        approvalMapper.updateApprovalDelegatee(empNo);
    }

    public List<MyRequestApproval> getMyRequestedApprovals(int empNo) {
        return approvalMapper.getMyRequestApprovals(empNo);
    }

    public List<ApprovalProgress> getApprovalProgress(int empNo) {
        return approvalMapper.getApprovalProgresses(empNo);
    }

    public List<ApprovalProgress> getApprovalCompletes(int empNo) {
        return approvalMapper.getApprovalCompletes(empNo);
    }

    public List<ApprovalProgress> getApprovalRejects(int empNo) {
        return approvalMapper.getApprovalRejects(empNo);
    }
}
