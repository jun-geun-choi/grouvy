package com.example.grouvy.user.form;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
public class UserProfileUpdateForm {

//    private String password;
    private String phoneNumber;
    private String address;
    private Date birthDate;

}
