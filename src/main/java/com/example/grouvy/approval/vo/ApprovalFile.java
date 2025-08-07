package com.example.grouvy.approval.vo;

import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

import java.util.Date;

@Getter
@Setter
@Alias("ApprovalFile")
public class ApprovalFile {
    private int fileNo;
    private String fileName;
    private String filePath;
    private int fileSize;
    private String fileType;
    private Date uploadedDate;
    private int approvalNo;
}
