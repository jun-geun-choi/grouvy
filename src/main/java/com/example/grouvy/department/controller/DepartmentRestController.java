// src/main/java/com/example/grouvy/department/controller/DepartmentRestController.java
package com.example.grouvy.department.controller;

import com.example.grouvy.department.service.DepartmentService;
import com.example.grouvy.department.dto.DeptTreeDto; // DTO 패키지 변경 반영
import com.example.grouvy.department.vo.Department;
import com.example.grouvy.user.service.UserService;
import com.example.grouvy.user.vo.User;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1")
public class DepartmentRestController {

    private final DepartmentService departmentService;
    private final UserService userService;

    @GetMapping("/departments/tree")
    public List<DeptTreeDto> getDepartmentTreeAsJson() {
        List<DeptTreeDto> departmentTree = departmentService.getDepartmentTree();
        return departmentTree;
    }

    @GetMapping("/departments/list")
    public List<Department> getAllDepartmentsAsJson() { // Department VO 임포트 (수동으로 추가)
        return departmentService.getAllDepts();
    }

    // **사용자 선택 및 세션 저장 REST API (수정)**
    @GetMapping("/users/select")
    public User selectUserApi(@RequestParam("userId") Long userId, HttpSession session) {
        User selectedUser = userService.getUserByUserId(userId);
        if (selectedUser != null) {
            session.setAttribute("selectedUser", selectedUser); // **이 줄을 추가합니다!**
            System.out.println("API 호출: 세션에 USER_ID " + userId + "의 사용자 정보가 저장되었습니다.");
            return selectedUser;
        } else {
            System.out.println("API 호출: USER_ID " + userId + "에 해당하는 사용자를 찾을 수 없습니다.");
            return null;
        }
    }

    // 선택된 사용자 해제 REST API
    @GetMapping("/users/clearSelected")
    public User clearSelectedUserApi(HttpSession session) {
        session.removeAttribute("selectedUser");
        System.out.println("API 호출: 세션에서 선택된 사용자 정보가 제거되었습니다.");
        return null;
    }
}