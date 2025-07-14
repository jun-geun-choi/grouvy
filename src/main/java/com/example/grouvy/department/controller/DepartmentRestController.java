// src/main/java/com/example/grouvy/department/controller/DepartmentRestController.java
package com.example.grouvy.department.controller;

import com.example.grouvy.department.dto.DeptTreeDto;
import com.example.grouvy.department.service.DepartmentService;
import com.example.grouvy.department.vo.Department;
import com.example.grouvy.user.service.UserService; // UserService 임포트 (추가)
import com.example.grouvy.user.vo.User; // User VO 임포트 (추가)

import jakarta.servlet.http.HttpSession; // HttpSession 임포트 (추가)
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam; // RequestParam 임포트 (추가)
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1") // API의 기본 경로를 더 넓게 "/api/v1"로 설정합니다. (departments 뿐만 아니라 users도 포함)
public class DepartmentRestController { // 클래스 이름은 DepartmentRestController로 유지합니다.

    private final DepartmentService departmentService;
    private final UserService userService; // UserService 의존성 주입 (추가)

    // 기존 조직도 트리 데이터 API
    @GetMapping("/departments/tree") // 전체 경로: /api/v1/departments/tree
    public List<DeptTreeDto> getDepartmentTreeAsJson() {
        List<DeptTreeDto> departmentTree = departmentService.getDepartmentTree();
        return departmentTree;
    }

    // 기존 모든 부서 목록 데이터 API
    @GetMapping("/departments/list") // 전체 경로: /api/v1/departments/list
    public List<Department> getAllDepartmentsAsJson() { // Department VO 임포트 필요 (수동으로 추가해주세요)
        return departmentService.getAllDepts();
    }

    // **새로 추가할 사용자 선택 및 세션 저장 REST API**
    /**
     * 조직도에서 사용자 클릭 시 해당 사용자의 ID를 세션에 저장하고,
     * 저장된 사용자 정보를 JSON 형태로 반환하는 REST API입니다.
     * 이 API는 AJAX 요청을 통해 호출됩니다.
     *
     * @param userId 사용자의 고유 ID (Long 타입)
     * @param session 현재 HTTP 세션 객체
     * @return 세션에 저장된 User 객체 (성공 시), 또는 null (사용자를 찾을 수 없을 때)
     */
    @GetMapping("/users/select") // 전체 경로: /api/v1/users/select
    public User selectUserApi(@RequestParam("userId") Long userId, HttpSession session) {
        User selectedUser = userService.getUserByUserId(userId);
        if (selectedUser != null) {
            session.setAttribute("selectedUser", selectedUser);
            System.out.println("API 호출: 세션에 USER_ID " + userId + "의 사용자 정보가 저장되었습니다.");
            return selectedUser; // 저장된 사용자 정보를 JSON으로 반환
        } else {
            System.out.println("API 호출: USER_ID " + userId + "에 해당하는 사용자를 찾을 수 없습니다.");
            return null; // 사용자를 찾지 못하면 null 반환 (클라이언트에서 null 처리 필요)
        }
    }

    // **새로 추가할 선택된 사용자 해제 REST API**
    /**
     * 세션에서 선택된 사용자 정보를 제거하는 REST API입니다.
     *
     * @param session 현재 HTTP 세션 객체
     * @return null (세션에서 정보가 제거되었음을 클라이언트에게 알림)
     */
    @GetMapping("/users/clearSelected") // 전체 경로: /api/v1/users/clearSelected
    public User clearSelectedUserApi(HttpSession session) {
        session.removeAttribute("selectedUser"); // 세션에서 "selectedUser" 속성 제거
        System.out.println("API 호출: 세션에서 선택된 사용자 정보가 제거되었습니다.");
        return null; // 클라이언트에게 "사용자 없음" 상태를 전달
    }
}