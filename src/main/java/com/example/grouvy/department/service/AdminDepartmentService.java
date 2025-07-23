package com.example.grouvy.department.service;

import com.example.grouvy.department.mapper.DepartmentMapper;
import com.example.grouvy.department.vo.Department;
import com.example.grouvy.security.SecurityUser;
import com.example.grouvy.user.mapper.UserMapper;
import com.example.grouvy.user.vo.User;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Service
@RequiredArgsConstructor
public class AdminDepartmentService {

    private final DepartmentMapper departmentMapper;
    private final UserMapper userMapper;
    private final DepartmentHistoryService departmentHistoryService; // 이력 서비스 주입
    private final ObjectMapper objectMapper;

    // 현재 로그인한 사용자 ID를 가져오는 private 헬퍼 메서드
    private int getCurrentUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated() || "anonymousUser".equals(authentication.getPrincipal())) {
            throw new IllegalStateException("인증된 사용자 정보를 찾을 수 없습니다.");
        }
        Object principal = authentication.getPrincipal();
        if (principal instanceof SecurityUser) {
            return ((SecurityUser) principal).getUser().getUserId();
        } else {
            throw new IllegalStateException("Principal의 타입이 SecurityUser가 아닙니다. 현재 타입: " + principal.getClass().getName());
        }
    }

    //조직리스트
    @Transactional(readOnly = true)
    public List<Department> getAllDepartments() {
        return departmentMapper.findAllDepts();
    }

    @Transactional(readOnly = true)
    public Department getDepartmentById(Long departmentId) {
        return departmentMapper.findDepartmentById(departmentId);
    }

    //조직 crud
    @Transactional
    public void createDepartment(Department department) {
        departmentMapper.insertDepartment(department);

        try {
            int changerUserId = getCurrentUserId();
            // [수정] Department 객체 전체를 직렬화하여 원본 JSON 저장
            String newValueJson = objectMapper.writeValueAsString(department);
            departmentHistoryService.recordDepartmentHistory(
                    department.getDepartmentId(), "CREATE", null, newValueJson, changerUserId
            );
        } catch (JsonProcessingException e) {
            throw new RuntimeException("부서 생성 이력 기록 중 JSON 직렬화 실패", e);
        }
    }

    @Transactional
    public int updateDepartment(Department department) {
        Department oldDepartment = departmentMapper.findDepartmentById(department.getDepartmentId());
        if (oldDepartment == null) {
            throw new IllegalStateException("수정할 부서를 찾을 수 없습니다.");
        }

        int updatedRows = departmentMapper.updateDepartment(department);

        if (updatedRows > 0) {
            try {
                int changerUserId = getCurrentUserId();
                // [수정] Department 객체 전체를 직렬화하여 원본 JSON 저장
                String oldValueJson = objectMapper.writeValueAsString(oldDepartment);
                // 업데이트 후의 객체를 DB에서 다시 조회하여 정확한 스냅샷을 만듭니다.
                Department newDepartment = departmentMapper.findDepartmentById(department.getDepartmentId());
                String newValueJson = objectMapper.writeValueAsString(newDepartment);

                if (!Objects.equals(oldValueJson, newValueJson)) {
                    departmentHistoryService.recordDepartmentHistory(
                            department.getDepartmentId(), "UPDATE", oldValueJson, newValueJson, changerUserId
                    );
                }
            } catch (JsonProcessingException e) {
                throw new RuntimeException("부서 수정 이력 기록 중 JSON 직렬화 실패", e);
            }
        }
        return updatedRows;
    }

    @Transactional
    public int deleteDepartment(Long departmentId) {
        List<User> usersInDepartment = userMapper.findUsersByDeptId(departmentId);
        if (usersInDepartment != null && !usersInDepartment.isEmpty()) {
            throw new IllegalStateException("해당 부서에 소속된 직원이 " + usersInDepartment.size() + "명 있어 삭제할 수 없습니다.");
        }
        int childDeptCount = departmentMapper.countChildDepartments(departmentId);
        if (childDeptCount > 0) {
            throw new IllegalStateException("하위 부서가 존재하여 삭제할 수 없습니다. 하위 부서를 먼저 삭제해주세요.");
        }

        Department departmentToDelete = departmentMapper.findDepartmentById(departmentId);
        if (departmentToDelete == null) {
            return 0; // 이미 삭제되었거나 없는 부서
        }

        int deletedRows = departmentMapper.deleteDepartment(departmentId);

        if (deletedRows > 0) {
            try {
                int changerUserId = getCurrentUserId();
                // [수정] Department 객체 전체를 직렬화하여 원본 JSON 저장
                String deletedValueJson = objectMapper.writeValueAsString(departmentToDelete);
                departmentHistoryService.recordDepartmentHistory(
                        departmentId, "DELETE", deletedValueJson, null, changerUserId
                );
            } catch (JsonProcessingException e) {
                throw new RuntimeException("부서 삭제 이력 기록 중 JSON 직렬화 실패", e);
            }
        }
        return deletedRows;
    }

}