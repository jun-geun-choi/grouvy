package com.example.grouvy.security;

import com.example.grouvy.user.mapper.UserMapper;
import com.example.grouvy.user.vo.User;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserDetailsServiceImpl implements UserDetailsService {

    private final UserMapper userMapper;

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        User user = userMapper.getUserByEmailWithRoleNames(email);
        if (user == null) {
            throw new UsernameNotFoundException("사용자를 찾을 수 없습니다.");
        }

        // TODO : USER 권한이 있는 사람만 접속 가능하도록 설정

        return new SecurityUser(user);
    }

}
