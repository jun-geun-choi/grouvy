package com.example.grouvy.approval.controller;

import com.example.grouvy.approval.dto.*;
import com.example.grouvy.approval.mapper.ApprovalMapper;
import com.example.grouvy.approval.service.ApprovalService;
import com.example.grouvy.approval.vo.Approval;
import com.example.grouvy.approval.vo.Delegation;
import com.example.grouvy.security.SecurityUser;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Controller
@RequestMapping("/approval")
public class ApprovalController {

    @Autowired
    private ApprovalService approvalService;
    @Autowired
    private ModelMapper modelMapper;
    @Autowired
    private ApprovalMapper approvalMapper;

    @PostMapping("/create")
    public String create(ApprovalRequest approvalRequest) {
        approvalService.createApproval(approvalRequest);
        return "redirect:/approval/main/wait";
    }

    @PostMapping("/createDelegatee")
    public String createDelegatee(Delegation delegation) {
        approvalService.createDelegation(delegation);
        return "redirect:/approval/main/delegatee";
    }

    @GetMapping("/main/draft")
    public String approvalDraft() {
        return "approval/main/draft";
    }

    @GetMapping("/main/wait")
    public String approvalWait(@AuthenticationPrincipal SecurityUser securityUser, Model model) {
        List<ApprovalWait> approvalsWait = approvalService.getWaitingApprovalsByEmployeeNo(securityUser.getUser().getEmployeeNo());
        model.addAttribute("approvalsWait", approvalsWait);
        return "approval/main/wait";
    }

    @GetMapping("/approvalForm/buybookform")
    public String buybookform(Model model) {
        String today = LocalDate.now()
                .format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        model.addAttribute("today", today);
        return "approval/approvalForm/buybookform";
    }

    @GetMapping("/receiver_requestdept_popup")
    public String receiverAndRequestdeptPopup() {
        return "approval/receiver_requestdept_popup";
    }

    @GetMapping("/approverPopup")
    public String approverPopup(Model model) {
        return "approval/popup/approverPopup";
    }

    @GetMapping("/delegateePopup")
    public String delegateePopup() {
        return "approval/popup/delegateePopup";
    }

    @GetMapping("/delegatee")
    @ResponseBody
    public List<ApproverPreview> approverPreview(@RequestParam("approversNo") List<Integer> approversNo) {
        List<ApproverPreview> approverPreviews = approvalService.isDelegating(approversNo);
        return approverPreviews;
    }

    @GetMapping("/depts")
    @ResponseBody
    public List<ApprovalDept> getDepartments() {
        List<ApprovalDept> depts = approvalService.getAlldepts();
        return depts;
    }

    @GetMapping("/emps")
    @ResponseBody
    public List<ApprovalEmp> getAllEmployees() {
        List<ApprovalEmp> emps = approvalService.getAllEmps();
        return emps;
    }

    @GetMapping("/teams")
    @ResponseBody
    public List<ApprovalDept> getTeams() {
        List<ApprovalDept> teams = approvalService.getAllTeams();
        return teams;
    }

    @GetMapping("/waitDetail")
    public String waitDetail(@RequestParam("no") int approvalNo, Model model) {
        Approval approval = approvalService.getBookApprovalByApprovalNo(approvalNo);
        List<DetailApprover> approvers = approvalService.getBookApproversByApprovalNo(approvalNo);
        ApprovalWriter approvalWriter = approvalService.getBookWriterByApprovalNo(approvalNo);
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            BookFormData formData = objectMapper.readValue(approval.getFormData(), BookFormData.class);
            model.addAttribute("formData", formData);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
            // 예외 처리: 에러 페이지로 보내거나, 기본값 넣거나, 로그만 출력하거나
        }
        model.addAttribute("approvalWriter", approvalWriter);
        model.addAttribute("approval", approval);
        model.addAttribute("approvers", approvers);
        return "approval/formDetail/bookFormDetail";
    }

    @GetMapping("/approval_approve_popup")
    public String approvePopup(@RequestParam("no") int approvalNo, Model model) {
        model.addAttribute("approvalNo", approvalNo);
        return "approval/popup/approval_approve_popup";
    }

    @ResponseBody
    @PostMapping("/approve")
    public ResponseEntity<Void> approvePopup(
            @RequestParam("decision") String decision
            , @RequestParam("opinion") String opinion
            , @RequestParam("approvalNo") int approvalNo
            ,@AuthenticationPrincipal SecurityUser securityUser)  {
        ApprovalDecisionRequest approvalDecisionRequest =
                new ApprovalDecisionRequest(
                        approvalNo,
                        securityUser.getUser().getEmployeeNo(),
                        decision,
                        opinion);
        approvalService.processApprovalDecision(approvalDecisionRequest);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/main/delegatee")
    public String delegatee(@AuthenticationPrincipal SecurityUser securityUser, Model model) {
        Delegatee delegatee = approvalService.getDelegationByUserId(securityUser.getUser().getEmployeeNo());
        model.addAttribute("delegatee", delegatee);
        return "approval/main/delegatee";
    }

    @PostMapping("/delegation/cancel")
    public ResponseEntity<?> cancelDelegation(@AuthenticationPrincipal SecurityUser securityUser,
            @RequestParam int delegationNo){
        approvalService.deleteDelegation(delegationNo, securityUser.getUser().getEmployeeNo());
        return ResponseEntity.ok().build();
    }


}
