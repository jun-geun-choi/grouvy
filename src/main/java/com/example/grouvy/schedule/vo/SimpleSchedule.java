package com.example.grouvy.schedule.vo;

import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

@Getter
@Setter
@Alias("SimpleSchedule")
public class SimpleSchedule {
    private String title;
//    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
    private String start;
//    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
    private String end;
//    private int categoryId;
    private String color;
    private ScheduleCategory category;

    public void setCategoryColor(int categoryId) {
        ScheduleCategory category = new ScheduleCategory();
        category.setCategoryId(categoryId);
        this.category = category;
    }

    public String getCategoryColor() {
        return category.getCategoryColor();
    }
}
