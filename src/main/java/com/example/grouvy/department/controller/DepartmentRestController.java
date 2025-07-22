package com.example.grouvy.department.controller;

import com.example.grouvy.department.dto.DepartmentTreeDto;
import com.example.grouvy.department.service.DepartmentService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/dept")
public class DepartmentRestController {

    private final DepartmentService departmentService;

    @GetMapping("/tree")
    public List<DepartmentTreeDto> getDepartmentTree() {
        return departmentService.getDepartmentTree();
    }

}
