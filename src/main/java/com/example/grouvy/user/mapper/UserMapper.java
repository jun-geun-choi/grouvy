package com.example.grouvy.user.mapper;

import com.example.grouvy.user.vo.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;



import java.util.List;

@Mapper
public interface UserMapper {

    void insertUser(User user);
    User getUserByEmail(String email);
    User getUserByUsernameWithRoleNames(String username);
    List<String> getRoleNamesByUserId(int userId);

    User findByUserId(@Param("userId") int userId);
    List<User> findUsersByDeptId(@Param("departmentId") Long departmentId);

}
