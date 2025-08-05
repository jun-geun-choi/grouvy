package com.example.grouvy.user.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.apache.ibatis.type.Alias;

import java.util.Date;

@Getter
@Alias("LoginHistory")
public class LoginHistory {

    private Long loginHistoryId;
    private Integer userId;
    private String ipAddress;
    private Date loginTime;
    private String loginStatus;

    User user;
}
