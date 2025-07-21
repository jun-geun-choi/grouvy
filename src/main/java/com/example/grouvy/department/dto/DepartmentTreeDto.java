package com.example.grouvy.department.dto;

import com.example.grouvy.department.vo.Department;
import com.example.grouvy.user.vo.User;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
public class DepartmentTreeDto {
    private Long departmentId;
    private String departmentName;
    private Long parentDepartmentId;
    private Integer departmentOrder;

    //의사컬럼.
    private Integer level;

    //트리구조.
    private List<User> users;
    private List<DepartmentTreeDto> children;

    public DepartmentTreeDto(Long departmentId, String departmentName, Long parentDepartmentId, Integer departmentOrder, Integer level) {
        this.departmentId = departmentId;
        this.departmentName = departmentName;
        this.parentDepartmentId = parentDepartmentId;
        this.departmentOrder = departmentOrder;
        this.level = level;
        this.children = new ArrayList<>();
        this.users = new ArrayList<>();
    }
}