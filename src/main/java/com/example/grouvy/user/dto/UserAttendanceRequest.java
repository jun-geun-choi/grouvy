package com.example.grouvy.user.dto;

import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

import java.util.Date;

@Getter
@Setter
@Alias("UserAttendanceRequest")
public class UserAttendanceRequest {
    private int attendanceId;
    private int userId;
    private String status;
    private Date attendanceTime;
    private Double latitude;
    private Double longitude;
    private Double distance;
}
