package com.example.grouvy.schedule.form;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ConferenceRoomRegisterForm {

    private String conferenceRoomTitle;
    private String conferenceRoomLocation;
    private String conferenceRoomExplanation;
    private String conferenceRoomEquipment;
    private int conferenceRoomLimit;
}
