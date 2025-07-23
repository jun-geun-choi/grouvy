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
@RequestMapping("/admin/dept") // 관리자 부서 페이지의 기본 URL: /admin/dept
public class AdminDepartmentController {

    private final AdminDepartmentService adminDepartmentService;

    // 1. 부서 목록 관리 페이지 (admin_department_list.jsp 렌더링)
    @GetMapping("/list")
    public String getAllDepartmentsPage(Model model) {
        model.addAttribute("currentPage", "departmentList"); // 사이드바 활성화용
        return "admin/department/admin_department_list"; // JSP 파일 경로 일치
    }

    // 2. 새 부서 생성 폼 페이지 (admin_department_update.jsp 렌더링 - 생성 모드)
    @GetMapping("/form")
    public String showCreateDepartmentForm(Model model) {
        model.addAttribute("department", new Department()); // 빈 Department 객체 (폼 바인딩용)
        model.addAttribute("formMode", "create"); // 폼 모드: 생성
        model.addAttribute("currentPage", "departmentList"); // 사이드바 활성화용
        return "admin/department/admin_department_update"; // 'admin_department_update.jsp'를 생성/수정 공용으로 사용
    }

    // 3. 부서 수정 폼 페이지 (admin_department_update.jsp 렌더링 - 수정 모드)
    @GetMapping("/update/{id}")
    public String showUpdateDepartmentForm(@PathVariable("id") Long departmentId, Model model) {
        Department department = adminDepartmentService.getDepartmentById(departmentId);

        if (department == null) {
            model.addAttribute("errorMessage", "요청하신 부서를 찾을 수 없습니다.");
            return "error/404"; // 실제 404.jsp 경로로 수정
        }

        model.addAttribute("department", department);
        model.addAttribute("formMode", "update"); // 폼 모드: 수정
        model.addAttribute("currentPage", "departmentList"); // 사이드바 활성화용
        return "admin/department/admin_department_update"; // 'admin_department_update.jsp' 사용
    }

    @GetMapping({"/history", "/history/{departmentId}"})
    public String departmentHistory(
            @PathVariable(value = "departmentId", required = false) Long departmentId,
            Model model) {
        model.addAttribute("selectedDepartmentId", departmentId); // JS에서 사용
        model.addAttribute("currentPage", "departmentHistory"); // 사이드바 활성화를 위한 값
        return "admin/department/admin_department_history";
    }

}