// src/main/java/com/example/grouvy/department/mapper/DepartmentMapper.java
package com.example.grouvy.department.mapper;

import com.example.grouvy.department.vo.Department;
import com.example.grouvy.department.vo.DepartmentHistory; // DepartmentHistory VO 임포트 (추가)
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface DepartmentMapper {

    // --- 조직도 조회 관련 메서드 (기존) ---
    List<Department> findAllDeptsHierarchy();
    List<Department> findAllDepts();

    // --- **새로 추가될 부서 관리 및 이력 관련 메서드** ---

    /**
     * 새로운 부서 정보를 GROUVY_DEPARTMENTS 테이블에 삽입합니다.
     * departmentId는 시퀀스를 통해 자동 생성됩니다.
     *
     * @param department 삽입할 Department VO 객체 (departmentId가 AFTER 삽입됨)
     */
    void insertDepartment(Department department);

    /**
     * 특정 DEPARTMENT_ID로 부서 상세 정보를 조회합니다.
     *
     * @param departmentId 조회할 부서의 ID
     * @return Department VO 객체, 없으면 null
     */
    Department findDepartmentById(@Param("departmentId") Long departmentId);

    /**
     * 부서 정보를 업데이트합니다.
     *
     * @param department 업데이트할 Department VO 객체
     * @return 업데이트된 행의 수
     */
    int updateDepartment(Department department);

    /**
     * 부서를 논리적으로 삭제 처리합니다 (IS_DELETED = 'Y').
     *
     * @param departmentId 삭제할 부서의 ID
     * @return 업데이트된 행의 수
     */
    int deleteDepartment(@Param("departmentId") Long departmentId);

    /**
     * 특정 부서의 하위 부서 수를 조회합니다. (부서 삭제 전 검증용)
     *
     * @param departmentId 부모 부서 ID
     * @return 하위 부서의 수
     */
    int countChildDepartments(@Param("departmentId") Long departmentId);

    /**
     * 특정 부서에 소속된 사용자 수를 조회합니다. (부서 삭제 전 검증용)
     *
     * @param departmentId 부서 ID
     * @return 소속 사용자의 수
     */
    int countUsersInDepartment(@Param("departmentId") Long departmentId);

    /**
     * 부서 변경 이력을 GROUVY_DEPARTMENTS_HISTORIES 테이블에 삽입합니다.
     * historyId는 시퀀스를 통해 자동 생성됩니다.
     *
     * @param history 삽입할 DepartmentHistory VO 객체
     */
    void insertDepartmentHistory(DepartmentHistory history);

    /**
     * 특정 부서(departmentId)의 변경 이력 목록을 조회합니다.
     *
     * @param departmentId 이력을 조회할 부서의 ID
     * @return DepartmentHistory VO 객체들의 리스트
     */
    List<DepartmentHistory> findDepartmentHistoriesByDepartmentId(@Param("departmentId") Long departmentId);

    /**
     * 모든 부서의 변경 이력 목록을 조회합니다.
     *
     * @return DepartmentHistory VO 객체들의 리스트
     */
    List<DepartmentHistory> findAllDepartmentHistories();
}