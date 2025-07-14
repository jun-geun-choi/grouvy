package com.example.grouvy.department.controller;

import com.example.grouvy.department.service.DepartmentService;
import com.example.grouvy.department.dto.DeptTreeDto;
import com.example.grouvy.user.service.UserService;
import com.example.grouvy.user.vo.User;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping
public class DepartmentController {

    private final DepartmentService departmentService;
    private final UserService userService;

    @GetMapping("/")
    public String main() {
        return "index";
    }

    @GetMapping("/dept/chart")
    public String getOrganizationChart(Model model) {
        List<DeptTreeDto> departmentTree = departmentService.getDepartmentTree();
        model.addAttribute("departmentTree", departmentTree);
        return "department/organization_chart";
    }

    //임시 로그인기능
    @GetMapping("/dept/selectUser")
    public String selectUserFromChart(@RequestParam("userId") Long userId, HttpSession session) {
        User selectedUser = userService.getUserByUserId(userId);
        if (selectedUser != null) {
            session.setAttribute("selectedUser", selectedUser);
            System.out.println("세션에" + userId + "의 사용자 정보가 저장되었습니다.");
        } else {
            System.out.println( userId + "정보를 찾을 수 없습니다.");
        }
        return "redirect:/dept/chart-test";
    }

    @GetMapping("/dept/chart-test")
    public String getDynamicOrganizationChartTest() {
        return "department/organization_chart_dynamic_test";
    }

    @GetMapping("/dept/ajax-chart")
    public String getAjaxOrganizationChart() {
        return "department/organization_chart_ajax";
    }

}
