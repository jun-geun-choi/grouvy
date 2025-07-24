package com.example.grouvy.user.vo;

import com.example.grouvy.department.vo.Department;
import lombok.*;
import org.apache.ibatis.type.Alias;

import java.util.Date;
import java.util.List;

@Getter
@Setter
@ToString
@NoArgsConstructor // 기본 생성자
@Builder // 가독성 좋은 체인 방식 생성자
@AllArgsConstructor // 전체 필드 초기화 생성자
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

    private int departmentId;
    private Department department;

    private String positionNo;
    private Position position;

    private List<String> roleNames;



}
