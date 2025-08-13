package com.example.grouvy.department.service;

import com.example.grouvy.department.dto.DepartmentTreeDto;
import com.example.grouvy.department.mapper.DepartmentMapper;
import com.example.grouvy.department.vo.Department;
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

    //조직도 트리가공
    @Transactional(readOnly = true)
    public List<DepartmentTreeDto> getDepartmentTree() {
        List<Department> allDepts = departmentMapper.findAllDeptsTree();

        if (allDepts.isEmpty()) {
            return new ArrayList<>();
        }

        List<Long> deptIds = allDepts.stream()
                .map(Department::getDepartmentId)
                .collect(Collectors.toList());

        List<User> allUsers = userMapper.findAllUsersByDeptIds(deptIds);
        Map<Long, List<User>> usersByDeptIdMap = allUsers.stream()
                .collect(Collectors.groupingBy(User::getDepartmentId));

        Map<Long, DepartmentTreeDto> deptTreeMap = allDepts.stream()
                .map(dept -> {
                    DepartmentTreeDto deptDto = new DepartmentTreeDto(
                            dept.getDepartmentId(),
                            dept.getDepartmentName(),
                            dept.getParentDepartmentId(),
                            dept.getDepartmentOrder(),
                            dept.getLevel()
                    );
                    List<User> usersForThisDept = usersByDeptIdMap.getOrDefault(dept.getDepartmentId(), new ArrayList<>());
                    deptDto.setUsers(usersForThisDept);
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

    //조직도 기능 내에서 특정 사용자 정보 조회를 위한 메서드
    @Transactional(readOnly = true)
    public User findUserForOrgChart(int userId) {
        return userMapper.findByUserId(userId);
    }

    //조직도 기능 내에서 사용자 검색을 위한 메서드
    @Transactional(readOnly = true)
    public List<User> searchUsersForOrgChart(String keyword) {
        return userMapper.searchUsers(keyword);
    }
}
