// src/main/java/com/example/grouvy/department/service/DepartmentService.java
package com.example.grouvy.department.service;

import com.example.grouvy.department.mapper.DepartmentMapper;
import com.example.grouvy.department.vo.Department;
import com.example.grouvy.department.vo.DepartmentHistory; // DepartmentHistory VO 임포트 (추가)
import com.example.grouvy.department.dto.DeptTreeDto;
import com.example.grouvy.user.mapper.UserMapper;
import com.example.grouvy.user.vo.User;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.fasterxml.jackson.databind.ObjectMapper; // JSON 직렬화를 위해 ObjectMapper 임포트 (추가)

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class DepartmentService {

    private final DepartmentMapper departmentMapper;
    private final UserMapper userMapper;
    private final ObjectMapper objectMapper; // JSON 직렬화를 위한 ObjectMapper 주입

    // --- 조직도 조회 관련 메서드 (기존) ---
    @Transactional(readOnly = true)
    public List<DeptTreeDto> getDepartmentTree() {
        List<Department> allDepts = departmentMapper.findAllDeptsHierarchy();

        Map<Long, DeptTreeDto> deptMap = allDepts.stream()
                .map(dept -> {
                    DeptTreeDto deptDto = new DeptTreeDto(
                            dept.getDepartmentId(),
                            dept.getDepartmentName(),
                            dept.getParentDepartmentId(),
                            dept.getDepartmentOrder(),
                            dept.getLevel()
                    );
                    List<User> usersInDept = userMapper.findUsersByDeptId(dept.getDepartmentId());
                    deptDto.setUsers(usersInDept);
                    return deptDto;
                })
                .collect(Collectors.toMap(DeptTreeDto::getDepartmentId, deptDto -> deptDto));

        List<DeptTreeDto> rootDepts = new ArrayList<>();

        deptMap.values().forEach(deptDto -> {
            if (deptDto.getParentDepartmentId() == null) {
                rootDepts.add(deptDto);
            } else {
                DeptTreeDto parentDept = deptMap.get(deptDto.getParentDepartmentId());
                if (parentDept != null) {
                    parentDept.getChildren().add(deptDto);
                    parentDept.getChildren().sort(Comparator.comparing(DeptTreeDto::getDepartmentOrder));
                }
            }
        });

        rootDepts.sort(Comparator.comparing(DeptTreeDto::getDepartmentOrder));

        return rootDepts;
    }

    @Transactional(readOnly = true)
    public List<Department> getAllDepts() {
        return departmentMapper.findAllDepts();
    }

    // --- **새로 추가될 부서 관리 및 이력 관련 메서드** ---

    /**
     * 새로운 부서를 생성하고 이력에 기록합니다.
     *
     * @param department 생성할 Department VO 객체
     * @param changerUserId 변경을 수행한 관리자 USER_ID
     */
    @Transactional
    public void createDepartment(Department department, Long changerUserId) {
        departmentMapper.insertDepartment(department); // 부서 DB에 삽입
        try {
            // 변경 후의 부서 데이터를 JSON 문자열로 직렬화하여 newValue로 기록
            String newValueJson = objectMapper.writeValueAsString(department);
            recordChange(department.getDepartmentId(), "CREATE", null, newValueJson, changerUserId);
        } catch (Exception e) {
            // 이력 기록 실패는 핵심 기능 실패로 간주하지 않고 로그만 남김
            System.err.println("부서 생성 이력 기록 실패: " + e.getMessage());
            // 필요한 경우 RuntimeException을 던져 트랜잭션 롤백
            // throw new RuntimeException("부서 이력 기록 중 오류 발생", e);
        }
    }

    /**
     * 특정 부서의 상세 정보를 조회합니다.
     *
     * @param departmentId 조회할 부서의 ID
     * @return 조회된 Department VO 객체, 없으면 null
     */
    @Transactional(readOnly = true)
    public Department getDepartmentById(Long departmentId) {
        return departmentMapper.findDepartmentById(departmentId);
    }

    /**
     * 부서 정보를 업데이트하고 이력에 기록합니다.
     *
     * @param department 업데이트할 Department VO 객체 (departmentId 포함)
     * @param changerUserId 변경을 수행한 관리자 USER_ID
     * @throws IllegalArgumentException 존재하지 않는 부서를 수정하려고 할 때
     */
    @Transactional
    public void updateDepartment(Department department, Long changerUserId) {
        // 기존 부서 정보를 조회하여 old_value로 사용
        Department oldDepartment = departmentMapper.findDepartmentById(department.getDepartmentId());
        if (oldDepartment == null) {
            throw new IllegalArgumentException("존재하지 않는 부서입니다.");
        }

        departmentMapper.updateDepartment(department); // 부서 DB 업데이트
        try {
            // 변경 전/후 부서 데이터를 JSON 문자열로 직렬화하여 이력 기록
            String oldValueJson = objectMapper.writeValueAsString(oldDepartment);
            String newValueJson = objectMapper.writeValueAsString(department);
            recordChange(department.getDepartmentId(), "UPDATE", oldValueJson, newValueJson, changerUserId);
        } catch (Exception e) {
            System.err.println("부서 수정 이력 기록 실패: " + e.getMessage());
        }
    }

    /**
     * 부서를 논리적으로 삭제하고 이력에 기록합니다.
     * 하위 부서나 소속 사용자가 있는 경우 삭제할 수 없습니다.
     *
     * @param departmentId 삭제할 부서의 ID
     * @param changerUserId 변경을 수행한 관리자 USER_ID
     * @throws IllegalStateException 하위 부서나 소속 사용자가 있을 경우
     * @throws IllegalArgumentException 존재하지 않는 부서를 삭제하려고 할 때
     */
    @Transactional
    public void deleteDepartment(Long departmentId, Long changerUserId) {
        // 기존 부서 정보를 조회하여 old_value로 사용
        Department departmentToDelete = departmentMapper.findDepartmentById(departmentId);
        if (departmentToDelete == null) {
            throw new IllegalArgumentException("존재하지 않는 부서입니다.");
        }

        // 하위 부서 존재 여부 검증
        if (departmentMapper.countChildDepartments(departmentId) > 0) {
            throw new IllegalStateException("하위 부서가 존재하는 부서는 삭제할 수 없습니다. 하위 부서를 먼저 삭제하거나 이동해주세요.");
        }

        // 소속 사용자 존재 여부 검증
        if (departmentMapper.countUsersInDepartment(departmentId) > 0) {
            throw new IllegalStateException("소속 사용자가 존재하는 부서는 삭제할 수 없습니다. 소속된 사용자를 먼저 이동시키거나 삭제해주세요.");
        }

        departmentMapper.deleteDepartment(departmentId); // 부서 논리적 삭제

        try {
            // 삭제되는 부서 데이터를 oldValue로 기록
            String deletedValueJson = objectMapper.writeValueAsString(departmentToDelete);
            recordChange(departmentId, "DELETE", deletedValueJson, null, changerUserId);
        } catch (Exception e) {
            System.err.println("부서 삭제 이력 기록 실패: " + e.getMessage());
        }
    }

    /**
     * 부서 변경 이력을 기록하는 헬퍼 메서드.
     *
     * @param departmentId 변경된 부서의 ID
     * @param changeType 변경 타입 (CREATE, UPDATE, DELETE)
     * @param oldValue 변경 전 데이터 (JSON), CREATE는 null
     * @param newValue 변경 후 데이터 (JSON), DELETE는 null
     * @param changerUserId 변경을 수행한 사용자 ID
     */
    private void recordChange(Long departmentId, String changeType, String oldValue, String newValue, Long changerUserId) {
        DepartmentHistory history = new DepartmentHistory();
        history.setDepartmentId(departmentId);
        history.setChangeType(changeType);
        history.setOldValue(oldValue);
        history.setNewValue(newValue);
        history.setChangerUserId(changerUserId);
        departmentMapper.insertDepartmentHistory(history);
    }

    /**
     * 특정 부서의 변경 이력 목록을 조회합니다.
     *
     * @param departmentId 이력을 조회할 부서의 ID
     * @return DepartmentHistory VO 객체들의 리스트
     */
    @Transactional(readOnly = true)
    public List<DepartmentHistory> getDepartmentHistoriesByDepartmentId(Long departmentId) {
        return departmentMapper.findDepartmentHistoriesByDepartmentId(departmentId);
    }

    /**
     * 모든 부서의 변경 이력 목록을 조회합니다.
     *
     * @return DepartmentHistory VO 객체들의 리스트
     */
    @Transactional(readOnly = true)
    public List<DepartmentHistory> getAllDepartmentHistories() {
        return departmentMapper.findAllDepartmentHistories();
    }
}