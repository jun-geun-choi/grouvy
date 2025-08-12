package com.example.grouvy.user.mapper;

import com.example.grouvy.department.vo.Department;
import com.example.grouvy.user.vo.*;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.security.core.parameters.P;

import java.util.List;

@Mapper
public interface AdminUserMapper {

    List<LoginHistory> getLoginHistories();
    List<AttendanceHistory> getAttendanceHistories();
    List<User> getAllUsers();
    List<Position> getAllPositions();
    List<Department> getAllDepartments();

    User getUserById(int userId);
    void insertPendingUser(UserApproval userRequest);
    List<UserApproval> getAllPendingUsers();
    List<UserApproval> getAllApprovedUsers();
    void updatePendingUser(@Param("userId") int userId, @Param("status") String status);
    void activateUser(User user);
    void insertUserRole(UserRole userRole);

    void inactivateUser(int userId);
    void updateUserInfo(User user);

}
