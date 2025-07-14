package com.example.grouvy.department.service;

import com.example.grouvy.department.mapper.DepartmentMapper;
import com.example.grouvy.department.vo.Department;
import com.example.grouvy.department.dto.DeptTreeDto;
import com.example.grouvy.user.mapper.UserMapper;
import com.example.grouvy.user.vo.User;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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

    @Transactional(readOnly = true)
    public List<DeptTreeDto> getDepartmentTree() {
        List<Department> allDepts = departmentMapper.findAllDeptsHierarchy();

        Map<Long, DeptTreeDto> deptMap = allDepts.stream()
                .map(dept -> {
                    //VO를 DTO로 변경
                  DeptTreeDto deptDto = new DeptTreeDto(
                          dept.getDepartmentId(),
                          dept.getDepartmentName(),
                          dept.getParentDepartmentId(),
                          dept.getDepartmentOrder(),
                          dept.getLevel()
                  );

                  //유저정보도 포함
                  List<User> usersInDept = userMapper.findUsersByDeptId(dept.getDepartmentId());
                  deptDto.setUsers(usersInDept);
                  return deptDto;
                        }).collect(Collectors.toMap(DeptTreeDto::getDepartmentId, deptDto -> deptDto));

        //계층구조만들기.
        List<DeptTreeDto> rootDepts = new ArrayList<>();
        deptMap.values().forEach(deptDto -> {
            if (deptDto.getParentDepartmentId() == null ) {
                rootDepts.add(deptDto);
            } else {
                DeptTreeDto parentDept = deptMap.get(deptDto.getParentDepartmentId());
                //혹시모를 db값 누락방지
                if (parentDept != null) {
                    parentDept.getChildren().add(deptDto);
                    parentDept.getChildren().sort(Comparator.comparing(DeptTreeDto::getDepartmentOrder));
                }
            }
        });

        rootDepts.sort(Comparator.comparing(DeptTreeDto::getDepartmentOrder));
        return rootDepts;
    }

    public List<Department> getAllDepts() {
        return departmentMapper.findAllDepts();
    }



}
