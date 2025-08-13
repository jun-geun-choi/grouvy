package com.example.grouvy.schedule.form;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;
import java.util.Date;

@Getter
@Setter
@ToString
public class MeetingReservateForm {

    //private int userId;
    private int conferenceRoomId;
    private String reservationDate;
    private LocalDateTime reservationStarttime;
    private LocalDateTime reservationEndtime;
    private int userId;
}
