package com.example.grouvy.task.vo;

import com.example.grouvy.user.vo.User;
import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

@Getter
@Setter
@Alias("TaskFile")
public class TaskFile {
    private int fileId;
    private int taskId;
    private String originalName;
    private String storedName;
    private String extension;
    private int size;
    private User uploadeUser;
    private int uploadUserId;
    private String isDeleted;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createdDate;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date updatedDate;
}
