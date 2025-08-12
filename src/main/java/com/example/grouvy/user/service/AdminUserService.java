package com.example.grouvy.user.service;

import com.example.grouvy.department.vo.Department;
import com.example.grouvy.user.dto.UserApprovalRequest;
import com.example.grouvy.user.dto.UserUpdateRequest;
import com.example.grouvy.user.mapper.AdminUserMapper;
import com.example.grouvy.user.mapper.UserMapper;
import com.example.grouvy.user.vo.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@RequiredArgsConstructor
@Service
@Transactional
public class AdminUserService {

    private final AdminUserMapper adminUserMapper;
    private final UserMapper userMapper;

    public List<LoginHistory> getLoginHistories() {
        return adminUserMapper.getLoginHistories();
    }
    public List<AttendanceHistory> getAttendanceHistories() {
        return adminUserMapper.getAttendanceHistories();
    }

    public List<User> getAllUsers() {
        return adminUserMapper.getAllUsers();
    }

    public List<Position> getAllPositions() {
        return adminUserMapper.getAllPositions();
    }

    public List<Department> getAllDepartments() {
        return adminUserMapper.getAllDepartments();
    }

    public void registerPendingUser(int userId) {
        UserApproval userRequest = new UserApproval();
        userRequest.setUserId(userId);
        adminUserMapper.insertPendingUser(userRequest);

    }

    public List<UserApproval> getAllPendingUsers() {
        return adminUserMapper.getAllPendingUsers();
    }

    public void approveUser(UserApprovalRequest request) {
        // 사원 정보 업데이트
        User foundUser = adminUserMapper.getUserById(request.getUserId());
        User updatedUser = foundUser.toBuilder()
                .employeeNo(request.getEmployeeNo())
                .positionNo(request.getPositionNo())
                .departmentId(request.getDepartmentId())
                .build();
        adminUserMapper.activateUser(updatedUser);

        // 사원 유저 권한 부여
        UserRole newUserRole = UserRole.builder().userId(request.getUserId()).build();
        adminUserMapper.insertUserRole(newUserRole);

        // 승인 여부 수정
        adminUserMapper.updatePendingUser(request.getUserId(), "승인");
    };

    public void rejectUser(UserApprovalRequest request) {
        adminUserMapper.inactivateUser(request.getUserId());
        adminUserMapper.updatePendingUser(request.getUserId(), "반려");

    }

    public List<UserApproval> getAllApprovedUsers() {
        return adminUserMapper.getAllApprovedUsers();
    }

    public void updateUserInfo(UserUpdateRequest request) {
        User foundUser = adminUserMapper.getUserById(request.getUserId());
        User updatedUser = foundUser.toBuilder()
                .departmentId(request.getDepartmentId())
                .positionNo(request.getPositionNo())
                .employmentStatus(request.getEmploymentStatus())
                .build();
        adminUserMapper.updateUserInfo(updatedUser);
    }

}
