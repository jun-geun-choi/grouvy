package com.example.grouvy.department.controller;

import com.example.grouvy.department.dto.DepartmentTreeDto;
import com.example.grouvy.department.service.AdminDepartmentService;
import com.example.grouvy.department.service.DepartmentService;
import com.example.grouvy.department.service.DepartmentHistoryService; // DepartmentHistoryService 추가
import com.example.grouvy.department.vo.Department;
import com.example.grouvy.department.vo.DepartmentHistory; // DepartmentHistory VO/Entity 추가
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
    private final DepartmentHistoryService departmentHistoryService; // DepartmentHistoryService 주입

    // 1. 일반 사용자용 부서 트리 조회 (기존 그대로)
    @GetMapping("/tree")
    public List<DepartmentTreeDto> getDepartmentTree() {
        return departmentService.getDepartmentTree();
    }

    // 2. 관리자용 부서 전체 목록 조회
    // URL: /api/v1/dept/list
    @GetMapping("/list")
    public List<Department> getDepartmentsForAdmin() {
        return adminDepartmentService.getAllDepartments();
    }

    // 3. 특정 부서 상세 조회
    // URL: /api/v1/dept/{id}
    @GetMapping("/{id}")
    public ResponseEntity<Department> getDepartmentById(@PathVariable("id") Long departmentId) {
        Department department = adminDepartmentService.getDepartmentById(departmentId);
        if (department == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(department);
    }

    // 4. 부서 생성
    // URL: /api/v1/dept (POST 요청)
    @PostMapping
    public ResponseEntity<Map<String, String>> createDepartment(@RequestBody Department department) {
        // 실제 부서 생성 로직
        adminDepartmentService.createDepartment(department);

        // 부서 생성 이력 기록 (departmentId는 createDepartment 내부에서 할당될 수 있으므로, 해당 메서드에서 반환하거나 다른 방식으로 가져와야 함)
        // 여기서는 예시로 department.getDepartmentId()를 사용하지만, 실제로는 createDepartment 후 ID를 얻어와야 함
        // (예: adminDepartmentService.createDepartment(department)가 생성된 ID를 반환하도록 수정)
        // departmentHistoryService.recordDepartmentHistory(
        //     department.getDepartmentId(), "CREATE", null, department.getDepartmentName(), currentUserId); // currentUserId는 Spring Security에서 가져와야 함

        return ResponseEntity.status(HttpStatus.CREATED).body(Map.of("message", "부서가 성공적으로 생성되었습니다."));
    }

    // 5. 부서 수정
    // URL: /api/v1/dept/{id} (PUT 요청)
    @PutMapping("/{id}")
    public ResponseEntity<Map<String, String>> updateDepartment(@PathVariable("id") Long departmentId, @RequestBody Department department) {
        department.setDepartmentId(departmentId); // URL의 ID를 객체에 설정

        // 업데이트 전의 Department 정보 (oldValue 기록을 위해 필요)
        Department oldDepartment = adminDepartmentService.getDepartmentById(departmentId);
        if (oldDepartment == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("message", "해당 부서를 찾을 수 없거나 업데이트할 내용이 없습니다."));
        }

        int updatedRows = adminDepartmentService.updateDepartment(department);
        if (updatedRows == 0) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of("message", "부서 수정에 실패했습니다.")); // NOT_FOUND가 아니라면 BAD_REQUEST
        }

        // 부서 수정 이력 기록 (변경 필드별로 다르게 기록할 수 있음)
        // 예: departmentHistoryService.recordDepartmentHistory(
        //     departmentId, "NAME_CHANGE", oldDepartment.getDepartmentName(), department.getDepartmentName(), currentUserId);

        return ResponseEntity.ok(Map.of("message", "부서가 성공적으로 수정되었습니다."));
    }

    // 6. 부서 삭제
    // URL: /api/v1/dept/{id} (DELETE 요청)
    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, String>> deleteDepartment(@PathVariable("id") Long departmentId) {
        try {
            adminDepartmentService.deleteDepartment(departmentId);
            return ResponseEntity.ok(Map.of("message", "부서가 성공적으로 삭제되었습니다."));
        } catch (IllegalStateException e) {
            // 비즈니스 규칙 위반 (하위 부서나 소속 직원이 있는 경우)
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of("message", e.getMessage()));
        } catch (Exception e) {
            // 그 외 예상치 못한 오류
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("message", "부서 삭제 중 알 수 없는 오류가 발생했습니다."));
        }
    }

    // 7. 특정 부서의 이력 조회 (JSON 응답)
    // URL: /api/v1/dept/history/{departmentId}
    @GetMapping("/history/{departmentId}")
    public ResponseEntity<List<DepartmentHistory>> getDepartmentHistoryById(@PathVariable("departmentId") Long departmentId) {
        List<DepartmentHistory> histories = departmentHistoryService.getDepartmentHistoriesByDeptId(departmentId);
        if (histories.isEmpty()) {
            return ResponseEntity.notFound().build(); // 404 (이력이 없는 경우)
            // 또는 return ResponseEntity.ok(Collections.emptyList()); // 빈 리스트 반환
        }
        return ResponseEntity.ok(histories);
    }

    // 8. 모든 부서 이력 조회 (JSON 응답)
    // URL: /api/v1/dept/history
    @GetMapping("/history")
    public ResponseEntity<List<DepartmentHistory>> getAllDepartmentHistories() {
        List<DepartmentHistory> allHistories = departmentHistoryService.getAllDepartmentHistories();
        if (allHistories.isEmpty()) {
            return ResponseEntity.ok().body(java.util.Collections.emptyList()); // 빈 리스트 반환
        }
        return ResponseEntity.ok(allHistories);
    }
}