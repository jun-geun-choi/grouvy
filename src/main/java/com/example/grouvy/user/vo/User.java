package com.example.grouvy.user.vo;

import com.example.grouvy.department.vo.Department;
import lombok.*;
import org.apache.ibatis.type.Alias;

import java.util.Date;
import java.util.List;

@Getter
@Setter
@ToString
@NoArgsConstructor
@Builder
@AllArgsConstructor
@Alias("User")
public class User {
    private int userId;
    private int employeeNo;
    private String name;
    private String loginProvider;
    private String email;
    private String password;
    private String socialEmail;
    private String emailVerified;
    private String phoneNumber;
    private String address;
    private String profileImgPath;
    private Date createdDate;
    private Date updatedDate;
    private Date resignDate;
    private String isDeleted;

    private Long departmentId;
    private Department department;

    private int positionNo;
    private Position position;

    private List<String> roleNames;



}
