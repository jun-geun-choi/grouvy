package com.example.grouvy.file.vo;

import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

@Getter
@Setter
@Alias("Category")
public class Category {
    private int categoryId;
    private String categoryName;
}
