package com.example.grouvy.file.vo;

import com.example.grouvy.user.vo.User;
import lombok.Getter;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
public class FileShare {
    private int shareId;
    private Date createdDate;
    private Date updatedDate;

    // 나중에 객체로 바꿀수도
    private int fileOwnerId;
    private int targetUserId;
    private int fileId;
}
