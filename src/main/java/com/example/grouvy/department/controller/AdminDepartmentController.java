package com.example.grouvy.department.controller;

import com.example.grouvy.department.service.AdminDepartmentService;
import com.example.grouvy.department.vo.Department; // Department VO/Entity 필요
import com.example.grouvy.user.vo.User;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model; // 뷰에 데이터 전달용
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/dept")
public class AdminDepartmentController {

    private final AdminDepartmentService adminDepartmentService;

    //조직도 crud
    @GetMapping("/list")
    public String getAllDepartmentsPage(Model model) {
        model.addAttribute("currentPage", "departmentList");
        return "admin/department/admin_department_list";
    }


    @GetMapping("/form")
    public String showCreateDepartmentForm(Model model) {
        model.addAttribute("department", new Department());
        model.addAttribute("formMode", "create");
        model.addAttribute("currentPage", "departmentList");
        return "admin/department/admin_department_update";
    }


    @GetMapping("/update/{id}")
    public String showUpdateDepartmentForm(@PathVariable("id") Long departmentId, Model model) {
        Department department = adminDepartmentService.getDepartmentById(departmentId);

        if (department == null) {
            model.addAttribute("errorMessage", "요청하신 부서를 찾을 수 없습니다.");
            return "error/404";
        }

        model.addAttribute("department", department);
        model.addAttribute("formMode", "update");
        model.addAttribute("currentPage", "departmentList");
        return "admin/department/admin_department_update";
    }

    //조직도 히스토리
    @GetMapping({"/history", "/history/{departmentId}"})
    public String departmentHistory(
            @PathVariable(value = "departmentId", required = false) Long departmentId,
            Model model) {
        model.addAttribute("selectedDepartmentId", departmentId);
        model.addAttribute("currentPage", "departmentHistory");
        return "admin/department/admin_department_history";
    }

}