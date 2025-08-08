package com.example.grouvy.user.vo;
import lombok.*;
import org.apache.ibatis.type.Alias;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Alias("UserRole")
@Builder
public class UserRole {
    String roleName;
    Integer userId;

}
