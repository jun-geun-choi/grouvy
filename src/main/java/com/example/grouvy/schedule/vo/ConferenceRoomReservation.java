package com.example.grouvy.schedule.vo;

import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

import java.time.LocalDateTime;
import java.util.Date;

@Getter
@Setter
@Alias("ConferenceRoomReservation")
public class ConferenceRoomReservation {

    private int reservationId;
    private Date reservationDate;
    private LocalDateTime reservationStarttime;
    private LocalDateTime reservationEndtime;
    private Date updatedDate;
    private Date createdDate;


}
