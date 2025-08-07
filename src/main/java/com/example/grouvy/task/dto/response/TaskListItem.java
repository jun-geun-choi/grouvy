package com.example.grouvy.task.dto.response;

import com.example.grouvy.user.vo.User;
import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Date;

@Getter
@Setter
@Alias("TaskListItem")
public class TaskListItem {
    private int taskId;
    private String title;
    private int writerId;
    private String writerName;
    private String writerPositionName;
    private int receiveUserId;
    private String receiveUserName;
    private String receiveUserPositionName;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate dueDate;
    private String status;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createdDate;

}
