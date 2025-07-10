// src/main/java/com/example/grouvy/user/vo/User.java
package com.example.grouvy.user.vo;

import lombok.Getter; // Getter 어노테이션 사용
import lombok.Setter; // Setter 어노테이션 사용
import java.util.Date;
import java.util.List;

@Getter // 필드에 대한 getter 메서드를 자동으로 생성합니다.
@Setter // 필드에 대한 setter 메서드를 자동으로 생성합니다.
public class User {
    private Long userId;
    private Long departmentId;
    private Long employeeNo;
    private String name;
    private String email;
    private String password;
    private String loginProvider;
    private String socialEmail;
    private String phoneNum;
    private String address;
    private String profileImgPath;
    private String isDeleted;
    private Date createdDate;
    private Date updatedDate;
    private String emailVerified;
    private String positionName;
    private Date resignDate;

    private String departmentName;
    private List<String> roles;
}