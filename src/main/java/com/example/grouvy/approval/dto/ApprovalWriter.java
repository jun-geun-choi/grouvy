package com.example.grouvy.approval.dto;

import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

import java.util.Date;

@Getter
@Setter
@Alias("ApprovalWriter")
public class ApprovalWriter {
    private String writerName;
    private int writerId;
    private Date createdDate;
    private String positionName;
}
