package com.example.grouvy.user.service;

import com.example.grouvy.user.exception.UserRegisterException;
import com.example.grouvy.user.form.UserRegisterForm;
import com.example.grouvy.user.mapper.UserMapper;
import com.example.grouvy.user.vo.User;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@RequiredArgsConstructor
@Service
@Transactional // 전부 성공 or 실패
public class UserService {

    private final ModelMapper modelMapper;
    private final PasswordEncoder passwordEncoder;
    private final UserMapper userMapper;

    public void registerUser(UserRegisterForm form) {

        User foundUser = userMapper.getUserByEmail(form.getEmail());
        if (foundUser != null) {
            throw new UserRegisterException("email", "이미 사용 중인 이메일입니다.");
        }

        if (!form.getPassword().equals(form.getConfirmPassword())) {
            throw new UserRegisterException("confirmPassword", "비밀번호가 일치하지 않습니다.");
        }

        User user = modelMapper.map(form, User.class);
        user.setPassword(passwordEncoder.encode(form.getPassword()));

        userMapper.insertUser(user);

    }
}
