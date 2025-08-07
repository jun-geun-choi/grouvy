package com.example.grouvy.file.dto.response;

import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

@Getter
@Setter
@Alias("ModalUser")
public class ModalUser {
    private int userId;
    private int employeeNo;
    private String name;
    private String profileImgPath;

    private int departmentId;
    private String departmentName;

    private int positionNo;
    private String positionName;
}
