package com.example.grouvy.department.controller;

import com.example.grouvy.department.service.DepartmentService;
import com.example.grouvy.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequiredArgsConstructor
@RequestMapping
public class DepartmentController {

    private final DepartmentService departmentService;
    private final UserService userService;

    @GetMapping("/dept/list")
    public String getDepartmentList() {
        return "department/department_list";
    }

}
