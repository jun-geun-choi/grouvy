package com.example.grouvy.task.dto.response;

import com.example.grouvy.task.vo.TaskFile;
import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Alias("TaskDetail")
public class TaskDetail {
    private int taskId;
    private String title;
    private String type;
    private String status;
    private int writerId;
    private String writerName;
    private String writerPositionName;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createdDate;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date updatedDate;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate dueDate;
    private int receiveUserId;
    private String receiveUserName;
    private String receiveUserPositionName;
    private List<Cc> ccs;
    private String content;
    private List<TaskFile> writerFiles;
    private List<TaskFile> feedbackFiles;

    @Getter
    @Setter
    public static class Cc {
        private int userId;
        private String name;
        private String positionName;
    }
}
