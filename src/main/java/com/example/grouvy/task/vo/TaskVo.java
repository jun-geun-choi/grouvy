package com.example.grouvy.task.vo;

import com.example.grouvy.user.vo.User;
import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;
import java.util.Date;

@Getter
@Setter
@Alias("TaskVo")
public class TaskVo {

    private int taskId;
    private User writer;
    private int writerId;
    private String title;
    private String content;
    private String status;
    private String type;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate dueDate;
    private String isDeleted;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createdDate;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date updatedDate;
}
