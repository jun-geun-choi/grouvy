package com.example.grouvy.user.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
@RequiredArgsConstructor
public class AdminController {

    @GetMapping("/admin")
    public String admin() {
        return "admin/admin_main";
    }

    @GetMapping("/userList")
    public String userList() {
        return "admin/user/admin_user_list";
    }

    @GetMapping("/userApproval")
    public String userApproval() {
        return "admin/user/admin_user_approval";
    }

    @GetMapping("/userLoginHistory")
    public String userLoginHistory() {
        return "admin/user/admin_login_history";
    }

    @GetMapping("/userAttendanceHistory")
    public String userAttendanceHistory() {
        return "admin/user/admin_attendance_history";
    }





}
