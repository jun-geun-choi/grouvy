package com.example.grouvy.task.controller;

import com.example.grouvy.file.view.FileDownloadView;
import com.example.grouvy.security.SecurityUser;
import com.example.grouvy.task.dto.request.Feedback;
import com.example.grouvy.task.dto.request.TaskForm;
import com.example.grouvy.task.dto.response.ReceiveUserFeedback;
import com.example.grouvy.task.dto.response.TaskDetail;
import com.example.grouvy.task.dto.response.TaskListItem;
import com.example.grouvy.task.dto.response.Todo;
import com.example.grouvy.task.service.TaskService;
import com.example.grouvy.task.vo.TaskFile;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.io.File;
import java.util.List;

@Controller
@RequestMapping("/task")
public class TaskController {

    @Autowired
    private final TaskService taskService;

    @Autowired
    private FileDownloadView fileDownloadView;

    public TaskController(TaskService taskService) {
        this.taskService = taskService;
    }

    @ModelAttribute
    public void always(Model model) {
        model.addAttribute("now", new java.util.Date());
    }

    @GetMapping("/todo")
    public String todo(HttpServletRequest request, Model model, @AuthenticationPrincipal SecurityUser securityUser) {
        String uri   = request.getRequestURI();        // e.g. "/task/todo"
        String query = request.getQueryString();       // e.g. "page=2&size=10", 없으면 null

        // 쿼리 포함 여부에 따라 URL 완성
        String redirectUrl = uri + (query != null ? "?" + query : "");
        model.addAttribute("redirectUrl", redirectUrl);

        List<Todo> todos = taskService.getTodos(securityUser.getUser().getUserId());
        model.addAttribute("todos", todos);

        return "task/task_todo_list";
    }

    @GetMapping("/request/writer")
    public String requestSent(HttpServletRequest request,Model model, @AuthenticationPrincipal SecurityUser securityUser) {
        String uri   = request.getRequestURI();        // e.g. "/task/todo"
        String query = request.getQueryString();       // e.g. "page=2&size=10", 없으면 null

        // 쿼리 포함 여부에 따라 URL 완성
        String redirectUrl = uri + (query != null ? "?" + query : "");
        model.addAttribute("redirectUrl", redirectUrl);

        List<TaskListItem> taskList = taskService.getRequestAndReport(securityUser.getUser().getUserId(), "request", "writer");

        model.addAttribute("taskList", taskList);
        model.addAttribute("type",   "request");
        model.addAttribute("role",   "writer");

        return "task/task_list";
    }

    @GetMapping("/request/receive")
    public String requestReceived(Model model, @AuthenticationPrincipal SecurityUser securityUser) {
        List<TaskListItem> taskList = taskService.getRequestAndReport(securityUser.getUser().getUserId(), "request", "receive");

        model.addAttribute("taskList", taskList);
        model.addAttribute("type",   "request");
        model.addAttribute("role",   "receive");

        return "task/task_list";
    }

    @GetMapping("/request/cc")
    public String requestCc(Model model, @AuthenticationPrincipal SecurityUser securityUser) {
        List<TaskListItem> taskList = taskService.getRequestAndReport(securityUser.getUser().getUserId(), "request", "cc");

        model.addAttribute("taskList", taskList);
        model.addAttribute("type",   "request");
        model.addAttribute("role",   "cc");

        return "task/task_list";
    }

    @GetMapping("/report/writer")
    public String reportSent(HttpServletRequest request,Model model, @AuthenticationPrincipal SecurityUser securityUser) {
        String uri   = request.getRequestURI();        // e.g. "/task/todo"
        String query = request.getQueryString();       // e.g. "page=2&size=10", 없으면 null

        // 쿼리 포함 여부에 따라 URL 완성
        String redirectUrl = uri + (query != null ? "?" + query : "");
        model.addAttribute("redirectUrl", redirectUrl);

        List<TaskListItem> taskList = taskService.getRequestAndReport(securityUser.getUser().getUserId(), "report", "writer");

        model.addAttribute("taskList", taskList);
        model.addAttribute("type",   "report");
        model.addAttribute("role",   "writer");

        return "task/task_list";
    }

    @GetMapping("/report/receive")
    public String reportReceived(Model model, @AuthenticationPrincipal SecurityUser securityUser) {
        List<TaskListItem> taskList = taskService.getRequestAndReport(securityUser.getUser().getUserId(), "report", "receive");

        model.addAttribute("taskList", taskList);
        model.addAttribute("type",   "report");
        model.addAttribute("role",   "receive");

        return "task/task_list";
    }

    @GetMapping("/report/cc")
    public String reportCc(Model model, @AuthenticationPrincipal SecurityUser securityUser) {
        List<TaskListItem> taskList = taskService.getRequestAndReport(securityUser.getUser().getUserId(), "report", "cc");

        model.addAttribute("taskList", taskList);
        model.addAttribute("type",   "report");
        model.addAttribute("role",   "cc");

        return "task/task_list";
    }

    @GetMapping("/form")
    public String form(@AuthenticationPrincipal SecurityUser securityUser, Model model) {
        model.addAttribute("writerId", securityUser.getUser().getUserId());
        return "task/task_form";
    }

    @PostMapping("/form")
    public String uploadForm(@ModelAttribute TaskForm taskForm, @AuthenticationPrincipal SecurityUser securityUser) {
        taskForm.setWriterId(securityUser.getUser().getUserId());
        taskService.createTask(taskForm);

        if (taskForm.getType().equals("todo")) {
            return "redirect:/task/todo";
        } else if (taskForm.getType().equals("request")) {
            return "redirect:/task/request/writer";
        } else {
            return "redirect:/task/report/writer";
        }
    }

    @GetMapping("/detail/{taskId}")
    public String detail(@PathVariable int taskId, Model model, @AuthenticationPrincipal SecurityUser securityUser) {
        TaskDetail taskDetail = taskService.getDetail(taskId);
        ReceiveUserFeedback feedback = taskService.getFeedback(taskId);
        String role = taskService.getMyRole(taskId, securityUser.getUser().getUserId());

        // 공통 상세페이지
        model.addAttribute("detail", taskDetail);

        // 역할별 하단부
        model.addAttribute("feedback", feedback);

        // 해당 업무에 대한 내 역할
        model.addAttribute("role", role);

        return "task/task_detail";
    }

    @GetMapping("/todo/detail/{taskId}")
    public String todoDetail(@PathVariable int taskId, Model model, @AuthenticationPrincipal SecurityUser securityUser) {
        TaskDetail taskDetail = taskService.getTodoDetail(taskId);

        model.addAttribute("detail", taskDetail);
        return "task/task_detail";
    }

    @PostMapping("/feedback/{taskId}")
    public String feedback(@PathVariable int taskId, @ModelAttribute Feedback feedback) {

        taskService.saveFeedBack(feedback);

        return "redirect:/task/detail/" + taskId;
    }

    @PostMapping("/reject/{taskId}")
    public String reject(@PathVariable int taskId, @ModelAttribute Feedback feedback) {
        taskService.rejectTask(feedback);
        return "redirect:/task/detail/" + taskId;
    }

    @PostMapping("/todo/complete/{taskId}")
    public String todoComplete(@PathVariable int taskId) {
        taskService.completeTodo(taskId);
        return "redirect:/task/todo";
    }

    @PostMapping("/delete")
    public String delete(@RequestParam List<Integer> taskIds, @RequestParam String redirectUrl) {


        taskService.deleteTask(taskIds);

        return "redirect:" + redirectUrl;
    }

    @GetMapping("/download")
    public ModelAndView download(@RequestParam int fileId) {
        File file = taskService.getDownloadFile(fileId);

        ModelAndView mav = new ModelAndView();
        mav.addObject("file", file);
        mav.setView(fileDownloadView);

        return mav;
    }
}
