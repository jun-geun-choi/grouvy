package com.example.grouvy.user.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.apache.ibatis.type.Alias;

@Getter
@Setter
@ToString
@Alias("UserRole")
public class UserRole {
    String roleName;
    String userId;

}
