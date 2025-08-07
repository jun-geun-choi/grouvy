package com.example.grouvy.task.dto.request;

import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Getter
@Setter
@Alias("Feedback")
public class Feedback {
    private int taskId;
    private int receiveUserId;
    private int progressPercent;
    private String comment;
    private List<MultipartFile> localFeedbackFiles;
    private List<Integer> existingFeedbackFileIds;
}
