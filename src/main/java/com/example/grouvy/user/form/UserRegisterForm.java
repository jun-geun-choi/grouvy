package com.example.grouvy.user.form;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserRegisterForm {

    @NotBlank(message = "이름은 필수 입력값입니다.")
    @Size(min = 2, message = "이름은 2글자 이상 입력해주세요.")
    private String name;

    @NotBlank(message = "전화번호는 필수 입력값입니다.")
    @Pattern(regexp = "^010-\\d{4}-\\d{4}$", message = "전화번호는 010-1234-5678 형식으로 입력해주세요.")
    private String phoneNumber;

    @NotBlank(message = "이메일은 필수 입력값입니다.")
    @Email(message = "유효한 이메일 형식이 아닙니다.")
    private String email;

//    @NotBlank(message = "비밀번호 확인은 필수 입력값입니다.")
    private String confirmCode;

    @NotBlank(message = "비밀번호는 필수 입력값입니다.")
    @Size(min = 8, message = "비밀번호는 8글자 이상 입력해주세요.")
    private String password;

    @NotBlank(message = "비밀번호 확인은 필수 입력값입니다.")
    private String confirmPassword;

}
