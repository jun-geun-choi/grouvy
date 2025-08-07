package com.example.grouvy.task.vo;

import com.example.grouvy.user.vo.User;
import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.access.annotation.Secured;

import java.util.Date;

@Getter
@Setter
@Alias("TaskReceiver")
public class TaskReceiver {
    private TaskVo task;
    private int taskId;
    private User targetUser;
    private int targetUserId;
    private String role;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createdDate;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date updatedDate;
    private String status;
    private int progressPercent;
    private String comment;
}
