package com.example.grouvy.user.vo;

import lombok.*;
import org.apache.ibatis.type.Alias;

import java.util.Date;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Alias("UserApproval")
@Builder
public class UserApproval {
    private int approvalId;
    private Date createdDate;
    private Date updatedDate;
    private String status;

    private int userId;
    private User user;
}
