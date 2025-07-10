package com.example.grouvy.department.vo;

import com.example.grouvy.user.vo.User;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
public class DeptTreeDto {
    private Long departmentId;
    private String departmentName;
    private Long parentDepartmentId;
    private Integer departmentOrder;

    private Integer level;

    private List<User> users;
    private List<DeptTreeDto> children;

    public DeptTreeDto(Long departmentId, String departmentName, Long parentDepartmentId, Integer departmentOrder, Integer level) {
        this.departmentId = departmentId;
        this.departmentName = departmentName;
        this.parentDepartmentId = parentDepartmentId;
        this.departmentOrder = departmentOrder;
        this.level = level;
        this.children = new ArrayList<>();
        this.users = new ArrayList<>();
    }
}
