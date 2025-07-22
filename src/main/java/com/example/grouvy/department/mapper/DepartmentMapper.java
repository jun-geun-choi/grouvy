package com.example.grouvy.department.mapper;

import com.example.grouvy.department.vo.Department;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface DepartmentMapper {

    //조직도 조회.
    List<Department> findAllDeptsTree();
    List<Department> findAllDepts();
}
