package com.example.grouvy.department.controller;

import com.example.grouvy.department.dto.DepartmentTreeDto;
import com.example.grouvy.department.service.AdminDepartmentService;
import com.example.grouvy.department.service.DepartmentService;
import com.example.grouvy.department.vo.Department;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/dept") // API 기본 URL 유지
public class DepartmentRestController {

    private final DepartmentService departmentService;
    private final AdminDepartmentService adminDepartmentService;

    // 1. 일반 사용자용 부서 트리 조회 (기존 그대로)
    @GetMapping("/tree")
    public List<DepartmentTreeDto> getDepartmentTree() {
        return departmentService.getDepartmentTree();
    }

    // 2. 관리자용 부서 전체 목록 조회 (admin_department_list.jsp의 fetchAndRenderDepartments()에서 호출)
    // URL: /api/v1/dept/list
    @GetMapping("/list") // 기존 경로 유지
    public List<Department> getDepartmentsForAdmin() { // 메서드명 변경 (혼동 방지)
        return adminDepartmentService.getAllDepartments();
    }

    // 3. 특정 부서 상세 조회 (admin_department_update.jsp의 loadDepartmentDataForUpdate()에서 호출)
    // URL: /api/v1/dept/{id}
    @GetMapping("/{id}") // {id} 경로 변수 사용
    public ResponseEntity<Department> getDepartmentById(@PathVariable("id") Long departmentId) {
        Department department = adminDepartmentService.getDepartmentById(departmentId);
        if (department == null) {
            return ResponseEntity.notFound().build(); // 404 응답
        }
        return ResponseEntity.ok(department);
    }

    // 4. 부서 생성 (admin_department_update.jsp에서 POST로 제출)
    // URL: /api/v1/dept (POST 요청)
    @PostMapping
    public ResponseEntity<Map<String, String>> createDepartment(@RequestBody Department department) {
        adminDepartmentService.createDepartment(department);
        return ResponseEntity.status(HttpStatus.CREATED).body(Map.of("message", "부서가 성공적으로 생성되었습니다."));
    }

    // 5. 부서 수정 (admin_department_update.jsp에서 PUT으로 제출)
    // URL: /api/v1/dept/{id} (PUT 요청)
    @PutMapping("/{id}")
    public ResponseEntity<Map<String, String>> updateDepartment(@PathVariable("id") Long departmentId, @RequestBody Department department) {
        department.setDepartmentId(departmentId); // URL의 ID를 객체에 설정
        int updatedRows = adminDepartmentService.updateDepartment(department);
        if (updatedRows == 0) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("message", "해당 부서를 찾을 수 없거나 업데이트할 내용이 없습니다."));
        }
        return ResponseEntity.ok(Map.of("message", "부서가 성공적으로 수정되었습니다."));
    }

    // 6. 부서 삭제 (admin_department_list.jsp의 삭제 버튼에서 DELETE로 호출)
    // URL: /api/v1/dept/{id} (DELETE 요청)
    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, String>> deleteDepartment(@PathVariable("id") Long departmentId) {
        int deletedRows = adminDepartmentService.deleteDepartment(departmentId);
        if (deletedRows == 0) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of("message", "부서 삭제에 실패했습니다. 하위 부서나 소속 직원이 없는지 확인해주세요."));
        }
        return ResponseEntity.ok(Map.of("message", "부서가 성공적으로 삭제되었습니다."));
    }
}