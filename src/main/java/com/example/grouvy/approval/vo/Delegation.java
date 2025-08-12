package com.example.grouvy.approval.vo;

import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

@Getter
@Setter
@Alias("Delegation")
public class Delegation {
    private int delegationNo;
    private int delegatorNo;
    private int delegateeNo;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date startDate;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date endDate;
    private String reason;
    private Date createdDate;
    private String canceled;
}
