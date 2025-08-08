package com.example.grouvy.schedule.service;


import com.example.grouvy.file.vo.Category;
import com.example.grouvy.schedule.form.CategoryUpdateForm;
import com.example.grouvy.schedule.form.ConferenceRoomRegisterForm;
import com.example.grouvy.schedule.form.HolidayRegisterForm;
import com.example.grouvy.schedule.form.ScheduleRegisterForm;
import com.example.grouvy.schedule.mapper.ScheduleMapper;
import com.example.grouvy.schedule.vo.*;
import com.google.gson.Gson;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ScheduleService {

    @Autowired(required = false)
    private ScheduleMapper scheduleMapper;

    @Autowired
    private ModelMapper modelMapper;

    public Schedule getScheduleByUserID(int scheduleID){
        Schedule schedule = scheduleMapper.getScheduleByUserNo(scheduleID);
        return schedule;
    }

    public String getSimpleSchedule(){
        List<SimpleSchedule> simpleschedule = scheduleMapper.getSimpleSchedule();

        Gson gson = new Gson();
        String scheduleJson = gson.toJson(simpleschedule);



        System.out.println(scheduleJson);
        return scheduleJson;
    }

//    public Holiday getHoliday(int holidayId){
//        Holiday holiday = scheduleMapper.getHoliday();
//
//        Gson gson = new Gson();
//        return holiday;
//    }

    public List<ScheduleCategory> getScheduleCategory(){
        List<ScheduleCategory> scheduleCategory = scheduleMapper.getScheduleCategory();
        return scheduleCategory;
    };

    public List<Holiday> getHolidayList(){
        List<Holiday> holiday = scheduleMapper.getHoliday();
        return  holiday;
    }

    public List<ConferenceRoom> getConferenceRoomList(){
        List<ConferenceRoom> conferenceRoom = scheduleMapper.getConferenceRoom();
        return conferenceRoom;
    }

    public void insertSchedule(ScheduleRegisterForm form) {

        Schedule schedule = modelMapper.map(form, Schedule.class);

        scheduleMapper.insertSchedule(schedule);
    }

    public void insertHoliday(HolidayRegisterForm form) {

        Holiday holiday = modelMapper.map(form, Holiday.class);

        scheduleMapper.insertHoliday(holiday);
    }

    public void updateCategory(CategoryUpdateForm form) {

        ScheduleCategory category = modelMapper.map(form, ScheduleCategory.class);

        scheduleMapper.updateCategory(category);

    }

    public void deleteHoliday(int holidayId){

        scheduleMapper.deleteHolidayById(holidayId);
    }

    public void insertConferenceRoom(ConferenceRoomRegisterForm form) {

        ConferenceRoom conferenceRoom = modelMapper.map(form, ConferenceRoom.class);

        scheduleMapper.insertConferenceRoom(conferenceRoom);
    }


}
