package com.example.grouvy.user.vo;

import lombok.Getter;
import org.apache.ibatis.type.Alias;

import java.util.Date;

@Getter
@Alias("AttendanceHistory")
public class AttendanceHistory {

    private Long attendanceHistoryId;
    private Integer userId;
    private String status;
    private Date attendanceDate;
    private Double latitude;
    private Double longitude;
    private Double distance;

    User user;
}
