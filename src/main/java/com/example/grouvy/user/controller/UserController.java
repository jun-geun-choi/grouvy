package com.example.grouvy.user.controller;

import com.example.grouvy.approval.dto.ApprovalWait;
import com.example.grouvy.approval.dto.MyRequestApproval;
import com.example.grouvy.approval.service.ApprovalService;
import com.example.grouvy.security.SecurityUser;
import com.example.grouvy.user.dto.ProfileRequest;
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

    @GetMapping("/")
    public String home(@AuthenticationPrincipal SecurityUser securityUser, Model model) {
        List<ApprovalWait> approvalsWait = approvalService.getWaitingApprovalsByEmployeeNo(securityUser.getUser().getEmployeeNo());
        List<MyRequestApproval> myRequestApprovals = approvalService.getMyRequestedApprovals(securityUser.getUser().getEmployeeNo());
        model.addAttribute("approvalsWait", approvalsWait);
        model.addAttribute("myRequestApprovals", myRequestApprovals);
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
//            adminUserService.registerUser();
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
//        System.out.println("confirmcode : " + code);
        return code;
    }

    @GetMapping("/mypage/profile")
    public String userMypageProfile(Model model) {
        User user = ((SecurityUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal()).getUser();
        model.addAttribute("joinDate", user.getCreatedDate());
        return "user/mypage_profile";
    }

    @PostMapping("/mypage/update/profile/info")
    public String updateProfileInfo(){

//        SecurityUser updatedSecurityUser = new SecurityUser(updatedUser);
//        Authentication newAuth = new UsernamePasswordAuthenticationToken(updatedSecurityUser, updatedSecurityUser.getPassword(), updatedSecurityUser.getAuthorities());
//        SecurityContextHolder.getContext().setAuthentication(newAuth);
        return "redirect:/mypage/profile";
    }

    @GetMapping("/mypage/attendance")
    public String userMypageAttendance(){
        return "user/mypage_profile2";
    }

    @GetMapping("/mypage/login-history")
    public String userMypageLoginHistory(){
        return "user/mypage_profile2";
    }

    @GetMapping("/mypage/setting")
    public String userMypageSetting(){
        return "user/mypage_profile2";
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
}
