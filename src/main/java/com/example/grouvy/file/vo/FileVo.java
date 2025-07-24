package com.example.grouvy.file.vo;

import com.example.grouvy.department.vo.Department;
import com.example.grouvy.user.vo.User;
import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

import java.util.Date;

@Getter
@Setter
@Alias("FileVo")
public class FileVo {
    private int fileId;
    private String ownerType;
    private String originalName;
    private String storedName;
    private String extension;
    private int size;
    private String isDeleted;
    private Date createdDate;
    private Date updatedDate;
    private String shareStatus;

    private int fileCategoryId;
    private String fileCategoryName;

    private User uploader;
    private Department uploaderDepartment;

}
