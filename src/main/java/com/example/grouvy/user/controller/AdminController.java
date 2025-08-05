package com.example.grouvy.user.controller;

import com.example.grouvy.user.dto.UserApprovalRequest;
import com.example.grouvy.user.service.AdminUserService;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequiredArgsConstructor
public class AdminController {

    private final ModelMapper modelMapper;
    private final AdminUserService adminUserService;

    @GetMapping("/admin")
    public String admin() {
        return "admin/admin_main";
    }

    @GetMapping("/admin/user/list")
    public String userList(Model model) {
        model.addAttribute("users", adminUserService.getAllUsers());
        model.addAttribute("positions", adminUserService.getAllPositions());
        model.addAttribute("departments", adminUserService.getAllDepartments());
//        model.addAttribute("employmentStatus", adminUserService.getAllEmploymentStatus());
        return "admin/user/admin_user_list";
    }

    @GetMapping("/admin/user/login-history")
    public String userLoginHistory(Model model) {
        model.addAttribute("loginHistorys", adminUserService.getLoginHistories());

        return "admin/user/admin_login_history";
    }

    @GetMapping("/admin/user/attendance-history")
    public String userAttendanceHistory() {

        return "admin/user/admin_attendance_history";
    }

    @GetMapping("/admin/user/approval")
    public String userApproval(Model model) {
        model.addAttribute("pendingUsers", adminUserService.getAllPendingUsers());
        model.addAttribute("departments", adminUserService.getAllDepartments());
        model.addAttribute("positions", adminUserService.getAllPositions());

//        model.addAttribute("approvedUsers", adminUserService.getAllApprovedUsers());

        return "admin/user/admin_user_approval";
    }

    @PostMapping("/admin/handle-user-approval")
    public String approveUser(@ModelAttribute UserApprovalRequest request) {
        System.out.println("approveUser");
        System.out.println(request.getApprovalId());
        System.out.println(request.getAction());
        if (request.getAction().equals("approve")) {
            System.out.println("승인");
            adminUserService.approveUser(request);
        } else if (request.getAction().equals("reject")) {
            System.out.println("거절");
            adminUserService.rejectUser(request);
        }


        return "redirect:/admin/user/approval";
    }

}
