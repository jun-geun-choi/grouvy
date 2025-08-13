package com.example.grouvy.schedule.vo;

import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

import java.util.Date;

@Getter
@Setter
@Alias("DeleteHistory")
public class DeleteHistory {

    private int deleteId;
    private int userId;
    private Date createdDate;
    private Date updatedDate;

}
