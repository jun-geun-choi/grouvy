package com.example.grouvy.schedule.mapper;

import com.example.grouvy.schedule.vo.*;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ScheduleMapper {

    Holiday getHolidayById(int holidayId);

    Schedule getScheduleByUserNo(int no);

    List<SimpleSchedule> getSimpleSchedule(int no, long departmentId);

    List<SimpleReservation> getConferenceRoomReservation();

    List<Holiday> getHoliday();

    List<ScheduleCategory> getScheduleCategory();

    List<ConferenceRoom> getMeetingRoom();

    List<ConferenceRoom> getConferenceRoom();

    String getUserDepartmentName(int no);

    void updateCategory(ScheduleCategory scheduleCategory);

    void insertSchedule(Schedule schedule);

    void insertHoliday(Holiday holiday);

    void deleteScheduleByUserNo(int no);

    void deleteHolidayById(int no);

    void deleteMeetingroomById(int no);

    void insertConferenceRoom(ConferenceRoom conferenceRoom);

    void deleteScheduleAllResigned();

    void insertHistory(DeleteHistory deleteHistory);

    void insertReservation(ConferenceRoomReservation conferenceRoomReservation);

    List<DeleteHistory> getHistory();

}
