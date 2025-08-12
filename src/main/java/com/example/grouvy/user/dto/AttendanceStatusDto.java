package com.example.grouvy.user.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Alias("AttendanceStatusDto")
public class AttendanceStatusDto {
    private String checkInTime;
    private String checkOutTime;
}
