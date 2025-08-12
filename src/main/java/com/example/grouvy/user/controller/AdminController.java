package com.example.grouvy.user.controller;

import com.example.grouvy.security.SecurityUser;
import com.example.grouvy.user.dto.UserApprovalRequest;
import com.example.grouvy.user.dto.UserUpdateRequest;
import com.example.grouvy.user.service.AdminUserService;
import com.example.grouvy.user.vo.User;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

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
    public String userList(Model model,  @AuthenticationPrincipal SecurityUser loginUser) {
        model.addAttribute("users", adminUserService.getAllUsers());
        model.addAttribute("positions", adminUserService.getAllPositions());
        model.addAttribute("departments", adminUserService.getAllDepartments());

        int managerId = loginUser.getUser().getUserId();
        model.addAttribute("managerId", managerId);

        return "admin/user/admin_user_list";
    }

    @PostMapping("/admin/user/update")
    public String updateUser(@ModelAttribute UserUpdateRequest userUpdateRequest) {
        adminUserService.updateUserInfo(userUpdateRequest);

        return "redirect:/admin/user/list";
    }

    @GetMapping("/admin/user/login-history")
    public String userLoginHistory(Model model) {
        model.addAttribute("loginHistories", adminUserService.getLoginHistories());

        return "admin/user/admin_login_history";
    }

    @GetMapping("/admin/user/attendance-history")
    public String userAttendanceHistory(Model model) {
        model.addAttribute("attendanceHistories", adminUserService.getAttendanceHistories());

        return "admin/user/admin_attendance_history";
    }

    @GetMapping("/admin/user/approval")
    public String userApproval(Model model) {
        model.addAttribute("pendingUsers", adminUserService.getAllPendingUsers());
        model.addAttribute("departments", adminUserService.getAllDepartments());
        model.addAttribute("positions", adminUserService.getAllPositions());

        model.addAttribute("approvedUsers", adminUserService.getAllApprovedUsers());

        return "admin/user/admin_user_approval";
    }

    @PostMapping("/admin/handle-user-approval")
    public String approveUser(@ModelAttribute UserApprovalRequest request) {
        if (request.getAction().equals("approve")) {
            adminUserService.approveUser(request);
        } else if (request.getAction().equals("reject")) {
            adminUserService.rejectUser(request);
        }

        return "redirect:/admin/user/approval";
    }

}
