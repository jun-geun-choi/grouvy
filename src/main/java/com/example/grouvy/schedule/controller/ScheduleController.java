package com.example.grouvy.schedule.controller;

import com.example.grouvy.schedule.form.ScheduleRegisterForm;
import com.example.grouvy.schedule.service.ScheduleService;
import com.example.grouvy.schedule.vo.Holiday;
import com.example.grouvy.schedule.vo.Schedule;
import com.example.grouvy.schedule.vo.SimpleSchedule;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

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

        Holiday holiday = scheduleService.getHolidayByUserID(1);
        model.addAttribute("holiday",holiday);
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


