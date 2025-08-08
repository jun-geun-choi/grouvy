package com.example.grouvy.schedule.form;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

@Getter
@Setter
@ToString
public class HolidayRegisterForm {

    private String holidayTitle;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date holidayDate;
}
