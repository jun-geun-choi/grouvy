package com.example.grouvy.schedule.vo;

import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;
import java.util.Date;

@Getter
@Setter
@Alias("ConferenceRoomReservation")
public class ConferenceRoomReservation {

    private int reservationId;
    private String reservationDate;
    private LocalDateTime reservationStarttime;
    private LocalDateTime reservationEndtime;
    private Date updatedDate;
    private Date createdDate;
    private int conferenceRoomId;
    private int userId;


}
