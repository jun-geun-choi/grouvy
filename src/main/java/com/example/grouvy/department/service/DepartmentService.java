package com.example.grouvy.department.service;

import com.example.grouvy.department.dto.DepartmentTreeDto;
import com.example.grouvy.department.mapper.DepartmentMapper;
import com.example.grouvy.department.vo.Department;
import com.example.grouvy.user.mapper.UserMapper;
import com.example.grouvy.user.vo.User;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

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

    public List<DepartmentTreeDto> getDepartmentTree() {
        List<Department> allDepts = departmentMapper.findAllDeptsTree();

        Map<Long, DepartmentTreeDto> deptTreeMap = allDepts.stream()
                .map(dept -> {
                    DepartmentTreeDto deptDto = new DepartmentTreeDto(
                            dept.getDepartmentId(),
                            dept.getDepartmentName(),
                            dept.getParentDepartmentId(),
                            dept.getDepartmentOrder(),
                            dept.getLevel()
                    );
                    List<User> userInDept = userMapper.findUsersByDeptId(dept.getDepartmentId());
                    deptDto.setUsers(userInDept);
                    return deptDto;
                })
                .collect(Collectors.toMap(DepartmentTreeDto::getDepartmentId, deptDto -> deptDto));

        List<DepartmentTreeDto> rootDepts = new ArrayList<>();

        deptTreeMap.values().forEach(deptTreeDto -> {
           if (deptTreeDto.getParentDepartmentId() == null) {
               rootDepts.add(deptTreeDto);
           } else {
               DepartmentTreeDto parentDept = deptTreeMap.get(deptTreeDto.getParentDepartmentId());
               if (parentDept != null) {
                   parentDept.getChildren().add(deptTreeDto);
                   parentDept.getChildren().sort(Comparator.comparing(DepartmentTreeDto::getDepartmentOrder));
               }
           }
        });
        rootDepts.sort(Comparator.comparing(DepartmentTreeDto::getDepartmentOrder));
        return rootDepts;
    }
}
