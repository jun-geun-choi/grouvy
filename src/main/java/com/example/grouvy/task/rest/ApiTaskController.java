package com.example.grouvy.task.rest;

import com.example.grouvy.file.dto.response.ApiResponse;
import com.example.grouvy.file.dto.response.ModalUser;
import com.example.grouvy.file.dto.response.ResponseEntityUtils;
import com.example.grouvy.file.service.FileService;
import com.example.grouvy.security.SecurityUser;
import com.example.grouvy.task.dto.response.ModalFile;
import com.example.grouvy.task.service.TaskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/task")
public class ApiTaskController {
    @Autowired
    private TaskService taskService;

    @GetMapping("/api/file")
    public ResponseEntity<ApiResponse<List<ModalFile>>> fileList(@AuthenticationPrincipal SecurityUser securityUser) {

        List<ModalFile> modalFiles = taskService.getFiles(securityUser.getUser().getUserId());
        return ResponseEntityUtils.ok(modalFiles);
    }
}
