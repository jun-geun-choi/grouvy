// src/main/java/com/example/grouvy/department/controller/DepartmentRestController.java
package com.example.grouvy.department.controller;

import com.example.grouvy.department.service.DepartmentService;
import com.example.grouvy.department.dto.DeptTreeDto; // DTO 패키지 변경 반영
import com.example.grouvy.department.vo.Department;
import com.example.grouvy.department.vo.DepartmentHistory;
import com.example.grouvy.user.service.UserService;
import com.example.grouvy.user.vo.User;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    private User validateAdminAccess(HttpSession session) {
        User currentUser = (User) session.getAttribute("selectedUser");
        // 향후 Spring Security 역할 기반 인증이 활성화되면, 여기에 ROLE_ADMIN 검사 로직 추가
        if (currentUser == null || currentUser.getUserId() == null /* || !currentUser.getRoles().contains("ROLE_ADMIN") */) {
            return null; // 관리자 권한 없음으로 간주
        }
        return currentUser;
    }

    @GetMapping("/admin/departments") // GET /api/v1/admin/departments
    public ResponseEntity<List<Department>> getAdminDepartmentList(HttpSession session) {
        User currentUser = validateAdminAccess(session);
        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }
        List<Department> departments = departmentService.getAllDepts(); // 삭제되지 않은 모든 부서 조회
        return ResponseEntity.ok(departments);
    }

    @PostMapping("/admin/departments") // POST /api/v1/admin/departments
    public ResponseEntity<Map<String, Object>> createDepartment(@RequestBody Department department, HttpSession session) {
        User currentUser = validateAdminAccess(session);
        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }
        try {
            departmentService.createDepartment(department, currentUser.getUserId());
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "부서가 성공적으로 생성되었습니다.");
            return ResponseEntity.status(HttpStatus.CREATED).body(response); // 201 Created
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "부서 생성 실패: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @GetMapping("/admin/departments/{departmentId}") // GET /api/v1/admin/departments/{departmentId}
    public ResponseEntity<Department> getDepartmentById(
            @PathVariable("departmentId") Long departmentId, HttpSession session) {
        User currentUser = validateAdminAccess(session);
        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }
        Department department = departmentService.getDepartmentById(departmentId);
        if (department == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null); // 404 Not Found
        }
        return ResponseEntity.ok(department);
    }

    @PutMapping("/admin/departments/{departmentId}") // PUT /api/v1/admin/departments/{departmentId}
    public ResponseEntity<Map<String, Object>> updateDepartment(
            @PathVariable("departmentId") Long departmentId,
            @RequestBody Department department,
            HttpSession session) {
        User currentUser = validateAdminAccess(session);
        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }
        // PathVariable의 ID와 요청 본문의 ID가 다를 경우를 대비하여 통일
        department.setDepartmentId(departmentId);
        try {
            departmentService.updateDepartment(department, currentUser.getUserId());
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "부서가 성공적으로 수정되었습니다.");
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "부서 수정 실패: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(errorResponse); // 400 Bad Request
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "부서 수정 중 오류 발생: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @DeleteMapping("/admin/departments/{departmentId}") // DELETE /api/v1/admin/departments/{departmentId}
    public ResponseEntity<Map<String, Object>> deleteDepartment(
            @PathVariable("departmentId") Long departmentId, HttpSession session) {
        User currentUser = validateAdminAccess(session);
        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }
        try {
            departmentService.deleteDepartment(departmentId, currentUser.getUserId());
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "부서가 성공적으로 삭제되었습니다.");
            return ResponseEntity.ok(response);
        } catch (IllegalStateException e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "부서 삭제 실패: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.CONFLICT).body(errorResponse); // 409 Conflict (비즈니스 로직 제약 위반)
        } catch (IllegalArgumentException e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "부서 삭제 실패: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(errorResponse); // 404 Not Found
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "부서 삭제 중 오류 발생: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @GetMapping({"/admin/departments/history", "/admin/departments/history/{departmentId}"}) // GET /api/v1/admin/departments/history 또는 /history/{id}
    public ResponseEntity<List<DepartmentHistory>> getDepartmentHistory(
            @PathVariable(value = "departmentId", required = false) Long departmentId,
            HttpSession session) {
        User currentUser = validateAdminAccess(session);
        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }
        List<DepartmentHistory> histories;
        if (departmentId != null) {
            histories = departmentService.getDepartmentHistoriesByDepartmentId(departmentId);
        } else {
            histories = departmentService.getAllDepartmentHistories();
        }
        return ResponseEntity.ok(histories);
    }


}