package com.example.grouvy.approval.dto;

import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

@Getter
@Setter
@Alias("Delegatee")
public class Delegatee {
    private String name;
    private Date startDate;
    private Date endDate;
    private String reason;
    private int delegationNo;
}
