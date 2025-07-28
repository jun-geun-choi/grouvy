package com.example.grouvy.file.dto.response;

import com.example.grouvy.user.vo.User;
import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

import java.util.Date;

@Getter
@Setter
@Alias("ShareInFile")
public class ShareInFile {
    private int fileId;
    private int shareId;
    private String originalName;
    private String extension;
    private int size;
    private User uploader;
    private int categoryId;
    private String categoryName;
    private Date shareCreatedDate;
}
