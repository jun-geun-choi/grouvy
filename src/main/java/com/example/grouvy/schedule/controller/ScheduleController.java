package com.example.grouvy.schedule.controller;

import com.example.grouvy.schedule.form.CategoryUpdateForm;
import com.example.grouvy.schedule.form.ConferenceRoomRegisterForm;
import com.example.grouvy.schedule.form.HolidayRegisterForm;
import com.example.grouvy.schedule.form.ScheduleRegisterForm;
import com.example.grouvy.schedule.service.ScheduleService;
import com.example.grouvy.schedule.vo.*;
import org.springframework.beans.factory.annotation.Autowired;
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
    public String ttt(Model model){

        //Schedule schedule = scheduleService.getScheduleByUserID(1);
        //model.addAttribute("schedule",schedule);

        List<Holiday> holiday = scheduleService.getHolidayList();
        model.addAttribute("holidayList",holiday);
        String scheduleJson = scheduleService.getSimpleSchedule();
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
        return "redirect:/";
    }

    @PostMapping("/meetingroom-register")
    public String conferenceRoomInsert(ConferenceRoomRegisterForm form){
        scheduleService.insertConferenceRoom(form);
        return "redirect:/";
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
        return "redirect:/";
    }



    @GetMapping("/category-manage")
    public String categoryManage(Model model){
        List<ScheduleCategory> scheduleCategory = scheduleService.getScheduleCategory();
        model.addAttribute("categories", scheduleCategory);
        model.addAttribute("CategoryUpdateForm", new CategoryUpdateForm());
        return "schedule/category-manage";
    }

    @GetMapping("/schedule-delete")
    public String scheduleDelete(){

        return "schedule/schedule-delete";
    }

    /*@GetMapping("/meetingroom-register")
    public String meetingroomRegister(){

        return "schedule/meetingroom-register";
    }*/

    @GetMapping("/holiday-delete")
    public String holidayDelete(@RequestParam("no") int no){
        scheduleService.deleteHoliday(no);

        return "redirect:/";
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


