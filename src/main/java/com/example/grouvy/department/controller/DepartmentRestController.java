package com.example.grouvy.department.controller;

import com.example.grouvy.department.dto.DepartmentTreeDto;
import com.example.grouvy.department.service.AdminDepartmentService;
import com.example.grouvy.department.service.DepartmentService;
import com.example.grouvy.department.service.DepartmentHistoryService;
import com.example.grouvy.department.vo.Department;
import com.example.grouvy.department.vo.DepartmentHistory;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/dept")
public class DepartmentRestController {

    private final DepartmentService departmentService;
    private final AdminDepartmentService adminDepartmentService;
    private final DepartmentHistoryService departmentHistoryService;

    //조직도리스트
    @GetMapping("/tree")
    public List<DepartmentTreeDto> getDepartmentTree() {
        return departmentService.getDepartmentTree();
    }

    //admin 조직도 crud
    @GetMapping("/list")
    public List<Department> getDepartmentsForAdmin() {
        return adminDepartmentService.getAllDepartments();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Department> getDepartmentById(@PathVariable("id") Long departmentId) {
        Department department = adminDepartmentService.getDepartmentById(departmentId);
        if (department == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(department);
    }

    @PostMapping
    public ResponseEntity<Map<String, String>> createDepartment(@RequestBody Department department) {
        adminDepartmentService.createDepartment(department);
        return ResponseEntity.status(HttpStatus.CREATED).body(Map.of("message", "부서가 성공적으로 생성되었습니다."));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Map<String, String>> updateDepartment(@PathVariable("id") Long departmentId, @RequestBody Department department) {
        department.setDepartmentId(departmentId);

        Department oldDepartment = adminDepartmentService.getDepartmentById(departmentId);
        if (oldDepartment == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("message", "해당 부서를 찾을 수 없거나 업데이트할 내용이 없습니다."));
        }

        int updatedRows = adminDepartmentService.updateDepartment(department);
        if (updatedRows == 0) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of("message", "부서 수정에 실패했습니다."));
        }
        return ResponseEntity.ok(Map.of("message", "부서가 성공적으로 수정되었습니다."));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, String>> deleteDepartment(@PathVariable("id") Long departmentId) {
        try {
            adminDepartmentService.deleteDepartment(departmentId);
            return ResponseEntity.ok(Map.of("message", "부서가 성공적으로 삭제되었습니다."));
        } catch (IllegalStateException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of("message", e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("message", "부서 삭제 중 알 수 없는 오류가 발생했습니다."));
        }
    }

    //조직도 히스토리.
    @GetMapping("/history/{departmentId}")
    public ResponseEntity<List<DepartmentHistory>> getDepartmentHistoryById(@PathVariable("departmentId") Long departmentId) {
        List<DepartmentHistory> histories = departmentHistoryService.getDepartmentHistoriesByDeptId(departmentId);
        if (histories.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(histories);
    }

    @GetMapping("/history")
    public ResponseEntity<List<DepartmentHistory>> getAllDepartmentHistories() {
        List<DepartmentHistory> allHistories = departmentHistoryService.getAllDepartmentHistories();
        if (allHistories.isEmpty()) {
            return ResponseEntity.ok().body(java.util.Collections.emptyList());
        }
        return ResponseEntity.ok(allHistories);
    }
}