package com.example.grouvy.user.controller;


import com.example.grouvy.approval.dto.ApprovalWait;
import com.example.grouvy.approval.dto.MyRequestApproval;
import com.example.grouvy.approval.service.ApprovalService;
import com.example.grouvy.message.mapper.MessageMapper;
import com.example.grouvy.message.service.MessageQueryService;
import com.example.grouvy.message.vo.MessageReceiver;
import com.example.grouvy.notification.mapper.NotificationMapper;
import com.example.grouvy.file.service.FileService;

import com.example.grouvy.security.SecurityUser;
import com.example.grouvy.user.dto.AttendanceStatusDto;
import com.example.grouvy.task.dto.response.TaskListItem;
import com.example.grouvy.task.service.TaskService;
import com.example.grouvy.user.dto.ProfileRequest;
import com.example.grouvy.user.dto.UserAttendanceRequest;
import com.example.grouvy.user.exception.UserRegisterException;
import com.example.grouvy.user.form.UserRegisterForm;
import com.example.grouvy.user.mapper.UserMapper;
import com.example.grouvy.user.service.AdminUserService;
import com.example.grouvy.user.service.MailService;
import com.example.grouvy.user.service.UserService;
import com.example.grouvy.user.vo.User;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;

@Controller
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;
    private final UserMapper userMapper;
    private final MailService mailService;
    private final AdminUserService adminUserService;
    private final ApprovalService approvalService;


  
    // 업무관련 의존성입주입
    private final TaskService taskService;

    // 쪽지 및 알림 관련 서비스/매퍼 주입 추가
    private final MessageMapper messageMapper;
    private final NotificationMapper notificationMapper;
    private final MessageQueryService messageQueryService;

    @GetMapping("/")
    public String home(Model model, @AuthenticationPrincipal SecurityUser securityUser) {
        int currentUserId = securityUser.getUser().getUserId();
      
        //
        List<ApprovalWait> approvalsWait = approvalService.getWaitingApprovalsByEmployeeNo(securityUser.getUser().getEmployeeNo());
        List<MyRequestApproval> myRequestApprovals = approvalService.getMyRequestedApprovals(securityUser.getUser().getEmployeeNo());
        model.addAttribute("approvalsWait", approvalsWait);
        model.addAttribute("myRequestApprovals", myRequestApprovals);

        //쪽지,o
        int unreadMessageCount = messageMapper.countUnreadReceivedMessages(currentUserId);
        int unreadNotificationCount = notificationMapper.countTotalNotifications(currentUserId);
        List<MessageReceiver> unreadMessages = messageQueryService.getUnreadMessagesForDashboard(currentUserId, 5);

        model.addAttribute("unreadMessageCount", unreadMessageCount);
        model.addAttribute("unreadNotificationCount", unreadNotificationCount);
        model.addAttribute("unreadMessages", unreadMessages);

        //업무로직
        List<TaskListItem> receiveRequestList = taskService.getRequestAndReport(securityUser.getUser().getUserId(), "request", "receive");
        List<TaskListItem> receiveReportList = taskService.getRequestAndReport(securityUser.getUser().getUserId(), "report", "receive");

        model.addAttribute("receiveRequestList", receiveRequestList);
        model.addAttribute("receiveReportList", receiveReportList);

        return "home";
    }

    @GetMapping("/login")
    public String loginform() {
        return "user/login";
    }

    @GetMapping("/register")
    public String registerform(Model model){
        UserRegisterForm userRegisterForm = new UserRegisterForm();
        model.addAttribute("userRegisterForm", userRegisterForm);

        return "user/register";
    }
    @PostMapping("/register")
    public String register(@Valid UserRegisterForm userRegisterForm, BindingResult errors){
        if(errors.hasErrors()){
            return "user/register";
        }

        try {

            int userId = userService.registerUser(userRegisterForm);
            adminUserService.registerPendingUser(userId);
        } catch (UserRegisterException e) {
            String field = e.getField();
            String message = e.getMessage();
            errors.rejectValue(field, null, message);
            return "user/register";
        }

        return "redirect:/";
    }
    @PostMapping("/register/check-mail")
    @ResponseBody
    public boolean checkEmail(@RequestParam("email") String email) {
        User foundUser = userMapper.findUserByEmail(email);
        return (foundUser == null);
    }
    @PostMapping("/register/mailConfirm")
    @ResponseBody
    String mailConfirm(@RequestParam("email") String email, HttpSession session) {
        String code = mailService.sendConfirmMail(email);
        session.setAttribute("confirmcode", code); // 세션에 저장
        return code;
    }



    @GetMapping("/mypage/profile")
    public String userMypageProfile(Model model) {
        User user = ((SecurityUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal()).getUser();
        model.addAttribute("joinDate", user.getCreatedDate());
        return "user/mypage_profile";
    }

    @GetMapping("/popup/jusoPopup")
    public String jusoGet() {
        return "user/addressPopup";
    }
    //팝업에서 돌아올 때 정부 API가 GET이 아니라 POST로 네 서버를 호출했기 때문
    @PostMapping("/popup/jusoPopup")
    public String jusoPost() {
        return "user/addressPopup";
    }
    @PostMapping("/mypage/update/profile/info")
    public String updateProfileInfo(@RequestParam String address, @AuthenticationPrincipal SecurityUser loginUser){
        User foundUser = userService.findByUserId(loginUser.getUser().getUserId());
        foundUser.setAddress(address);

        userService.updateProfileInfo(foundUser);

        User updatedUser = userService.findByUserId(loginUser.getUser().getUserId());
        SecurityUser updatedSecurityUser = new SecurityUser(updatedUser);
        Authentication newAuth = new UsernamePasswordAuthenticationToken(updatedSecurityUser, updatedSecurityUser.getPassword(), updatedSecurityUser.getAuthorities());
        SecurityContextHolder.getContext().setAuthentication(newAuth);
        return "redirect:/mypage/profile";
    }

    @PostMapping("/mypage/update/profile/image")
    public String updateProfile(@ModelAttribute ProfileRequest dto) throws IOException {
        userService.updateProfileImg(dto);
        User updatedUser = userMapper.findByUserId(dto.getUserId());

        SecurityUser updatedSecurityUser = new SecurityUser(updatedUser);
        Authentication newAuth = new UsernamePasswordAuthenticationToken(updatedSecurityUser, updatedSecurityUser.getPassword(), updatedSecurityUser.getAuthorities());
        SecurityContextHolder.getContext().setAuthentication(newAuth);
        return "redirect:/mypage/profile";

    }
    @DeleteMapping("/user/delete/profile-image")
    public ResponseEntity<Void> deleteProfileImage(@AuthenticationPrincipal SecurityUser loginUser) {
        userService.clearProfileImage(loginUser.getUser().getUserId());

        User updatedUser = userService.findByUserId(loginUser.getUser().getUserId());
        Authentication currentAuth = SecurityContextHolder.getContext().getAuthentication();
        SecurityUser updatedSecurityUser = new SecurityUser(updatedUser);

        UsernamePasswordAuthenticationToken newAuth =
                new UsernamePasswordAuthenticationToken(
                        updatedSecurityUser,
                        currentAuth.getCredentials(),     // 기존 크리덴셜 유지
                        currentAuth.getAuthorities()      // 권한 유지
                );
        newAuth.setDetails(currentAuth.getDetails()); // details 유지(세션·IP 등)
        SecurityContextHolder.getContext().setAuthentication(newAuth);

        return ResponseEntity.noContent().build();
    }



    @GetMapping("/mypage/attendance")
    public String userMypageAttendance(Model model, @AuthenticationPrincipal SecurityUser loginUser) {
        model.addAttribute("attendanceHistories", userService.getAttendanceHistories(loginUser.getUser().getUserId()));
        return "user/mypage_attendance_history";
    }

    @GetMapping("/mypage/login-history")
    public String userMypageLoginHistory(Model model, @AuthenticationPrincipal SecurityUser loginUser) {
        model.addAttribute("loginHistories", userService.getLoginHistories(loginUser.getUser().getUserId()));

        return "user/mypage_login_history";
    }

    @PostMapping("/attendance/checkin")
    public ResponseEntity<String> checkin(@RequestBody UserAttendanceRequest request, @AuthenticationPrincipal SecurityUser loginUser) {
        request.setUserId(loginUser.getUser().getUserId());

        userService.recordAttendance(request);
        return ResponseEntity.ok("출근 성공");

    }
    @PostMapping("/attendance/checkout")
    public ResponseEntity<String> checkout(@RequestBody UserAttendanceRequest request, @AuthenticationPrincipal SecurityUser loginUser) {
        request.setUserId(loginUser.getUser().getUserId());

        userService.recordAttendance(request);
        return ResponseEntity.ok("퇴근 성공");

    }

    @ResponseBody
    @GetMapping("/attendance/today-status")
    public AttendanceStatusDto todayStatus(@AuthenticationPrincipal SecurityUser loginUser) {
        AttendanceStatusDto dto = userService.getTodayStatus(loginUser.getUser().getUserId());
        if (dto == null) {
            dto = new AttendanceStatusDto(null, null);
        }
        return dto;
    }

}
