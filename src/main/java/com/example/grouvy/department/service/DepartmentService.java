package com.example.grouvy.department.service;

import com.example.grouvy.department.mapper.DepartmentMapper;
import com.example.grouvy.department.vo.Department;
import com.example.grouvy.department.vo.DeptTreeDto;
import com.example.grouvy.user.mapper.UserMapper;
import com.example.grouvy.user.service.UserService;
import com.example.grouvy.user.vo.User;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class DepartmentService {

    private final DepartmentMapper departmentMapper;
    private final UserService userService;
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

                  List<User> usersInDept = userMapper.findUsersByDeptId(dept.getDepartmentId());
                  deptDto.setUsers(usersInDept);
                  return deptDto;
                        }).collect(Collectors.toMap(DeptTreeDto::getDepartmentId, deptDto -> deptDto));
        return null;
    }



}
