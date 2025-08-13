package com.example.grouvy.schedule.controller;

import com.example.grouvy.schedule.form.*;
import com.example.grouvy.schedule.service.ScheduleService;
import com.example.grouvy.schedule.vo.*;
import com.example.grouvy.security.SecurityUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
public class ScheduleController {

    @Autowired
    private ScheduleService scheduleService;

    @GetMapping("/test")
    public String test(){
        return "test";
    }

    @GetMapping("/schedule")
    public String ttt(Model model,@AuthenticationPrincipal SecurityUser loginUser){

        //Schedule schedule = scheduleService.getScheduleByUserID(1);
        //model.addAttribute("schedule",schedule);
        int userId = loginUser.getUser().getUserId();
        Long departmentId = loginUser.getUser().getDepartmentId();

        List<Holiday> holiday = scheduleService.getHolidayList();
        model.addAttribute("holidayList",holiday);
        String scheduleJson = scheduleService.getSimpleSchedule(userId, departmentId);
        model.addAttribute("scheduleJson",scheduleJson);
        return "schedule/schedule-month";
    }

    @GetMapping("/schedule-register")
    public String register(Model model) {

        model.addAttribute("ScheduleRegisterForm", new ScheduleRegisterForm());
        return "schedule/schedule-register";
    }

    @PostMapping("schedule-register")
    public String insert(ScheduleRegisterForm form){
        scheduleService.insertSchedule(form);
        return "redirect:/";
    }

    @PostMapping("/holiday-manage")
    public String holidayInsert(HolidayRegisterForm form){
        scheduleService.insertHoliday(form);
        return "redirect:/holiday-manage";
    }

    @PostMapping("/meetingroom-register")
    public String conferenceRoomInsert(ConferenceRoomRegisterForm form){
        scheduleService.insertConferenceRoom(form);
        return "redirect:/";
    }

    @PostMapping("/meetingroom-reservate")
    public String reservationInsert(MeetingReservateForm form){
        scheduleService.insertReservation(form);
        return "redirect:/meetingroom-reservate";
    }

    @GetMapping("/meetingroom-register")
    public String ConferenceRoomManager(Model model){
        List<ConferenceRoom> conferenceRoom = scheduleService.getConferenceRoomList();
        model.addAttribute("conferenceRoomList",conferenceRoom);
        model.addAttribute("ConferenceRoomRegisterForm", new ConferenceRoomRegisterForm());
        return "schedule/meetingroom-register";
    }

    @GetMapping("/holiday-manage")
    public String holidayManage(Model model){
        List<Holiday> holiday = scheduleService.getHolidayList();
        model.addAttribute("holidayList",holiday);
        model.addAttribute("HolidayRegisterForm", new HolidayRegisterForm());
        return "schedule/holiday-manage";
    }

    @PostMapping("/category-manage")
    public String categoryUpdate(CategoryUpdateForm form){
        scheduleService.updateCategory(form);
        return "redirect:/category-manage";
    }



    @GetMapping("/category-manage")
    public String categoryManage(Model model){
        List<ScheduleCategory> scheduleCategory = scheduleService.getScheduleCategory();
        model.addAttribute("categories", scheduleCategory);
        model.addAttribute("CategoryUpdateForm", new CategoryUpdateForm());
        return "schedule/category-manage";
    }

    @GetMapping("/schedule-delete")
    public String scheduleDelete(Model model){
        List<DeleteHistory> deleteHistory = scheduleService.getDeleteHistoryList();
        model.addAttribute("deleteHistoryList",deleteHistory);
        return "schedule/schedule-delete";
    }

    @GetMapping("/schedule-deleteaction")
    public String scheduleDeleteAll(){
        scheduleService.deleteScheduleAllResigned();
        scheduleService.insertDeleteHistory();
        return "redirect:/schedule-delete";

    }

    /*@GetMapping("/meetingroom-register")
    public String meetingroomRegister(){

        return "schedule/meetingroom-register";
    }*/

    @GetMapping("/holiday-delete")
    public String holidayDelete(@RequestParam("no") int no){
        scheduleService.deleteHoliday(no);

        return "redirect:/holiday-manage";
    }

    @GetMapping("/meetingroom-delete")
    public String meetingroomDelete(@RequestParam("no") int no){
        scheduleService.deleteMeetingroom(no);

        return "redirect:/meetingroom-register";
    }

    @GetMapping("/meetingroom-reservate")
    public String meetingroomReservate(Model model){
        List<ConferenceRoom> conferenceRoom = scheduleService.getConferenceRoomList();
        model.addAttribute("conferenceRoomList",conferenceRoom);
        model.addAttribute("MeetingReservateForm", new MeetingReservateForm());

        String reservationJson = scheduleService.getConferenceRoomReservation();
        model.addAttribute("reservationJson",reservationJson);

        return "schedule/meetingroom-reservation";
    }

    /*@GetMapping("temps")
    @ResponseBody
    public Schedule stest(){
        Schedule schedule = new Schedule();
        schedule = scheduleService.getScheduleByUserID(100001);

        return schedule;
    }

    @GetMapping("apap")
    @ResponseBody
    public Schedule apap(){
        Schedule schedule = new Schedule();
        schedule = scheduleService.getScheduleByUserID(100001);


        return schedule;
    }*/

}


