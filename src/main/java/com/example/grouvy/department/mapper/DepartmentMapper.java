package com.example.grouvy.department.mapper;

import com.example.grouvy.department.vo.Department;
import com.example.grouvy.department.vo.DepartmentHistory;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface DepartmentMapper {

    //조직도전체 조회.
    List<Department> findAllDeptsTree();
    List<Department> findAllDepts();

    //조직도 crud.
    Department findDepartmentById(@Param("departmentId") Long departmentId);
    void insertDepartment(Department department);
    int updateDepartment(Department department);
    int deleteDepartment(@Param("departmentId") Long departmentId);
    int countChildDepartments(@Param("parentDepartmentId") Long parentDepartmentId);

    //조직 히스토리.
    void insertDepartmentHistory(DepartmentHistory history);
    List<DepartmentHistory> findDepartmentHistoryByDeptId(@Param("departmentId")Long departmentId);
    List<DepartmentHistory> findAllDepartmentHistories();

}
