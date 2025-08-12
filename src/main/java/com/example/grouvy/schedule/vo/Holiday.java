package com.example.grouvy.schedule.vo;

import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

@Getter
@Setter
@Alias("Holiday")
public class Holiday {

    private int holidayId;
    private String holidayTitle;
    @DateTimeFormat(pattern = "MM-dd")
    private Date holidayDate;
    private Date createdDate;
    private Date updatedDate;
}
