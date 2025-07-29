package com.example.grouvy.schedule.service;


import com.example.grouvy.schedule.form.ScheduleRegisterForm;
import com.example.grouvy.schedule.mapper.ScheduleMapper;
import com.example.grouvy.schedule.vo.Holiday;
import com.example.grouvy.schedule.vo.Schedule;
import com.example.grouvy.schedule.vo.SimpleSchedule;
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

    public Holiday getHolidayByUserID(int holidayId){
        Holiday holiday = scheduleMapper.getHolidayById(holidayId);
        return holiday;
    }

    public void insertSchedule(ScheduleRegisterForm form) {

        Schedule schedule = modelMapper.map(form, Schedule.class);

        scheduleMapper.insertSchedule(schedule);
    }


}
