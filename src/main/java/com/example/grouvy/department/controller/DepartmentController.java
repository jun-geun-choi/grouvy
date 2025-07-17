package com.example.grouvy.department.controller;

import com.example.grouvy.department.service.DepartmentService;
import com.example.grouvy.user.service.UserService;
import com.example.grouvy.user.vo.User;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;


@Controller
@RequiredArgsConstructor
@RequestMapping
public class DepartmentController {

    private final DepartmentService departmentService;
    private final UserService userService;

    @GetMapping("/")
    public String mainPage() {
        return "index";
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


    @GetMapping("/dept/chart")
    public String getOrganizationChart() {
        return "department/organization_chart";
    }

    @GetMapping("/admin")
    public String adminHome(Model model) {
        model.addAttribute("title", "관리자 대시보드");
        return "admin/index";
    }

    @GetMapping("/admin/departments/list") // GET /admin/departments/list
    public String getDepartmentListAdmin(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("selectedUser");
        if (currentUser == null || currentUser.getUserId() == null) {
            model.addAttribute("errorMessage", "관리자 페이지에 접근하려면 발신자를 먼저 선택해주세요. (조직도에서 사용자 클릭)");
        }
        model.addAttribute("currentPage", "departmentList"); // 사이드바 활성화를 위한 값
        return "admin/department/department_list";
    }

    @GetMapping({"/admin/departments/form", "/admin/departments/form/{departmentId}"}) // GET /admin/departments/form 또는 /form/{id}
    public String departmentForm(
            @PathVariable(value = "departmentId", required = false) Long departmentId,
            Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("selectedUser");
        if (currentUser == null || currentUser.getUserId() == null) {
            model.addAttribute("errorMessage", "관리자 페이지에 접근하려면 발신자를 먼저 선택해주세요. (조직도에서 사용자 클릭)");
            return "admin/department/department_list"; // 발신자 없으면 목록으로 리다이렉트
        }

        // 폼 모드 설정 (생성 또는 수정)
        model.addAttribute("formMode", departmentId != null ? "update" : "create");
        if (departmentId != null) {
            model.addAttribute("departmentId", departmentId); // 수정 모드일 때 ID 전달
            model.addAttribute("formTitle", "부서 수정");
        } else {
            model.addAttribute("formTitle", "부서 생성");
        }
        model.addAttribute("currentPage", "departmentList"); // 사이드바 활성화를 위한 값
        return "admin/department/department_form";
    }


    @GetMapping({"/admin/departments/history", "/admin/departments/history/{departmentId}"}) // GET /admin/departments/history 또는 /history/{id}
    public String departmentHistory(
            @PathVariable(value = "departmentId", required = false) Long departmentId,
            Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("selectedUser");
        if (currentUser == null || currentUser.getUserId() == null) {
            model.addAttribute("errorMessage", "관리자 페이지에 접근하려면 발신자를 먼저 선택해주세요. (조직도에서 사용자 클릭)");
            return "admin/department/department_list"; // 발신자 없으면 목록으로 리다이렉트
        }

        model.addAttribute("selectedDepartmentId", departmentId); // JS에서 사용
        model.addAttribute("currentPage", "departmentHistory"); // 사이드바 활성화를 위한 값
        return "admin/department/department_history";
    }

}
