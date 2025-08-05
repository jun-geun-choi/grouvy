package com.example.grouvy.schedule.form;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;
import java.util.Date;

@Getter
@Setter
@ToString
public class ScheduleRegisterForm {

    private String scheduleTitle;
    private Date scheduleDate;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
    private LocalDateTime scheduleStarttime;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
    private LocalDateTime scheduleEndtime;
    private String scheduleContent;
    private String scheduleLocation;
    private int categoryId;
    private int departmentId;






}


