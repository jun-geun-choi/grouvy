package com.example.grouvy.user.mapper;

import com.example.grouvy.user.dto.AttendanceStatusDto;
import com.example.grouvy.user.dto.ProfileRequest;
import com.example.grouvy.user.dto.UserAttendanceRequest;
import com.example.grouvy.user.vo.AttendanceHistory;
import com.example.grouvy.user.vo.LoginHistory;
import com.example.grouvy.user.vo.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface UserMapper {

    void insertUser(User user);
    List<String> getRoleNamesByUserId(int userId);
    User findUserByEmail(String email);
    User findUserByEmailWithRoleNames(String email);

    User findByUserId(@Param("userId") int userId);
    List<User> findUsersByDeptId(@Param("departmentId") Long departmentId);
    List<User> findAllUsersByDeptIds(List<Long> departmentIds);
    String findUserNameByUserId(@Param("userId") int userId);
    int countUsersInDepartment(long departmentId);
    List<User> searchUsers(@Param("keyword") String keyword);

    void updateUserProfile(@Param("userId") int userId, @Param("imageUrl")  String imageUrl);
    void deleteProfileImage(int userId);
    void updateProfileInfo(@Param("userId") int userId, @Param("address") String address);

    // login/logout log
    void insertLoginLog(@Param("userId") int userId, @Param("ip") String ip);
    void insertLogoutLog(@Param("userId") int userId, @Param("ip") String ip);

    void insertAttendanceLog(UserAttendanceRequest userAttendanceRequest);

    List<LoginHistory> getLoginHistories(int userId);
    List<AttendanceHistory> getAttendanceHistories(int userId);

    AttendanceStatusDto selectTodayStatus(int userId);

    int findUserIdWithEmployNo(int employeeNo);
}
