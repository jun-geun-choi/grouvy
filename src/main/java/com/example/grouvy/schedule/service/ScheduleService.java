package com.example.grouvy.schedule.service;


import com.example.grouvy.file.vo.Category;
import com.example.grouvy.schedule.form.*;
import com.example.grouvy.schedule.mapper.ScheduleMapper;
import com.example.grouvy.schedule.vo.*;
import com.google.gson.Gson;
import org.apache.ibatis.annotations.Delete;
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

    public String getSimpleSchedule(int userId, Long  departmentId){
        List<SimpleSchedule> simpleschedule = scheduleMapper.getSimpleSchedule(userId, departmentId);

        Gson gson = new Gson();
        String scheduleJson = gson.toJson(simpleschedule);



        System.out.println(scheduleJson);
        return scheduleJson;
    }

    public String getConferenceRoomReservation(){
        List<SimpleReservation> simpleReservations = scheduleMapper.getConferenceRoomReservation();

        Gson gson2 = new Gson();
        String reservationJson = gson2.toJson(simpleReservations);

        System.out.println(reservationJson);
        return reservationJson;
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

    public void deleteMeetingroom(int conferenceRoomId){

        scheduleMapper.deleteMeetingroomById(conferenceRoomId);
    }

    public void insertConferenceRoom(ConferenceRoomRegisterForm form) {

        ConferenceRoom conferenceRoom = modelMapper.map(form, ConferenceRoom.class);

        scheduleMapper.insertConferenceRoom(conferenceRoom);
    }

    public void deleteScheduleAllResigned(){

        scheduleMapper.deleteScheduleAllResigned();
    }

    public List<DeleteHistory> getDeleteHistoryList(){
        List<DeleteHistory> deleteHistory = scheduleMapper.getHistory();
        return deleteHistory;
    }

    public void insertDeleteHistory(){

        DeleteHistory deleteHistory = new DeleteHistory();
        scheduleMapper.insertHistory(deleteHistory);
    }

    public void insertReservation(MeetingReservateForm form){

        ConferenceRoomReservation conferenceRoomReservation = modelMapper.map(form, ConferenceRoomReservation.class);

        scheduleMapper.insertReservation(conferenceRoomReservation);
    }


}
