package com.example.grouvy.user.service;

import com.example.grouvy.user.dto.ProfileRequest;
import com.example.grouvy.user.exception.UserRegisterException;
import com.example.grouvy.user.form.UserRegisterForm;
import com.example.grouvy.user.mapper.UserMapper;
import com.example.grouvy.user.vo.User;
import com.google.cloud.storage.BlobInfo;
import com.google.cloud.storage.Storage;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.io.IOException;
import java.util.UUID;

@RequiredArgsConstructor
@Service
@Transactional // 전부 성공 or 실패
public class UserService {

    private final ModelMapper modelMapper;
    private final PasswordEncoder passwordEncoder;
    private final UserMapper userMapper;
    private final HttpSession session;
    private final Storage storage;

    public void registerUser(UserRegisterForm form) {

//        User foundUser = userMapper.getUserByEmail(form.getEmail());
//        if (foundUser != null) {
//            throw new UserRegisterException("email", "이미 사용 중인 이메일입니다.");
//        }


        if (!form.getPassword().equals(form.getConfirmPassword())) {
            throw new UserRegisterException("confirmPassword", "비밀번호가 일치하지 않습니다.");
        }

        String sessionCode = (String) session.getAttribute("confirmcode");
        if (sessionCode == null || !sessionCode.equals(form.getConfirmCode())) {
            throw new UserRegisterException("confirmCode", "이메일 인증이 완료되지 않았습니다.");
        }


        User user = modelMapper.map(form, User.class);
        user.setPassword(passwordEncoder.encode(form.getPassword()));

        userMapper.insertUser(user);

    }

    @Value("${spring.cloud.gcp.storage.bucket}")
    private String bucketName;

    public void updateProfileImg(ProfileRequest dto) throws IOException {
        User foundUser = userMapper.findByUserId(dto.getUserId());
        String oldProfilePath = foundUser.getProfileImgPath();
//        System.out.println(oldProfilePath);
        if (oldProfilePath != null) {
            storage.delete(bucketName, oldProfilePath);
        }
        String uuid = UUID.randomUUID().toString();
        String type = dto.getImage().getContentType();

        BlobInfo blobInfo = storage.create(
                BlobInfo.newBuilder(bucketName, uuid)
                        .setContentType(type)
                        .build(),
                dto.getImage().getInputStream()
        );

        userMapper.updateUserProfile(foundUser.getUserId(), uuid);
    }

}
