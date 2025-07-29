package com.example.grouvy.schedule.mapper;

import com.example.grouvy.schedule.vo.Holiday;
import com.example.grouvy.schedule.vo.Schedule;
import com.example.grouvy.schedule.vo.SimpleSchedule;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ScheduleMapper {

    Holiday getHolidayById(int holidayId);

    Schedule getScheduleByUserNo(int no);

    List<SimpleSchedule> getSimpleSchedule();

    void insertSchedule(Schedule schedule);
}
