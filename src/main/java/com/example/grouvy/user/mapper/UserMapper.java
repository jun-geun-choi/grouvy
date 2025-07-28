package com.example.grouvy.user.mapper;

import com.example.grouvy.user.dto.ProfileRequest;
import com.example.grouvy.user.vo.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface UserMapper {

    void insertUser(User user);
    List<String> getRoleNamesByUserId(int userId);
    User getUserByEmail(String email);
    User getUserByEmailWithRoleNames(String email);

    User findByUserId(@Param("userId") int userId);
    List<User> findUsersByDeptId(@Param("departmentId") Long departmentId);
    String findUserNameByUserId(@Param("userId") int userId);
    int countUsersInDepartment(long departmentId);

    void updateUserProfile(@Param("userId") int userId, @Param("imageUrl")  String imageUrl);

}
