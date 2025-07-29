package com.example.grouvy.schedule.vo;

import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

@Getter
@Setter
@Alias("scheduleCategory")
public class ScheduleCategory {

    private int categoryId;
    private String categoryTitle;
    private String categoryColor;
}
