package com.example.grouvy.schedule.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

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
    private Category category;

    public void setCategoryColor(int categoryId) {
        Category category = new Category();
        category.setCategoryId(categoryId);
        this.category = category;
    }

    public String getCategoryColor() {
        return category.getCategoryColor();
    }
}
