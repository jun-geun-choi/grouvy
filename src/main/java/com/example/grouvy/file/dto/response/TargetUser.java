package com.example.grouvy.file.dto.response;

import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

@Getter
@Setter
@Alias("TargetUser")
public class TargetUser {

    private int userId;
    private String name;
    private int departmentId;
    private String departmentName;
    private int positionNo;
    private String positionName;
}
