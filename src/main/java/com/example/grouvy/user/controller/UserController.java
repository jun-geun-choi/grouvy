package com.example.grouvy.user.controller;

import com.example.grouvy.user.exception.UserRegisterException;
import com.example.grouvy.user.form.UserRegisterForm;
import com.example.grouvy.user.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

@RequiredArgsConstructor
@Controller
public class UserController {

    private final UserService userService;

    @GetMapping("/")
    public String home() {
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
            userService.registerUser(userRegisterForm);
        } catch (UserRegisterException e) {
            String field = e.getField();
            String message = e.getMessage();
            errors.rejectValue(field, null, message);
            return "user/register";
        }


        return "redirect:/";
    }
}
