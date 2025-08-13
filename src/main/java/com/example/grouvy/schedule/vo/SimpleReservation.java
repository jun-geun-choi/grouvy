package com.example.grouvy.schedule.vo;

import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

import java.time.LocalDateTime;
import java.util.Date;

@Getter
@Setter
@Alias("SimpleReservation")
public class SimpleReservation {

    private int reservationId;
    private String reservationDate;
    private String reservationStarttime;
    private String reservationEndtime;
    private String conferenceRoomId;
    private int userId;
}
