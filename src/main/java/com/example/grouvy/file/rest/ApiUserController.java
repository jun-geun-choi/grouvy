package com.example.grouvy.file.rest;

import com.example.grouvy.file.dto.response.ApiResponse;
import com.example.grouvy.file.dto.response.ModalUser;
import com.example.grouvy.file.dto.response.ResponseEntityUtils;
import com.example.grouvy.file.service.FileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/file")
public class ApiUserController {

    @Autowired
    private FileService fileService;

    @GetMapping("/api/user-list")
    public ResponseEntity<ApiResponse<List<ModalUser>>> userList() {

        List<ModalUser> targetUsers = fileService.targetList();
        return ResponseEntityUtils.ok(targetUsers);
    }
}
