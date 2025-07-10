package com.example.grouvy.department.mapper;

import com.example.grouvy.department.vo.Department;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface DepartmentMapper {

    //모든 부서정보를 계층구조로 가져옴 (하위부서포함)
    List<Department> findAllDeptsHierarchy();

    //모든 부서정보를 단순 리스트로 가져옴
    List<Department> findAllDepts();;

}
