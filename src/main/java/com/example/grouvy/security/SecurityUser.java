package com.example.grouvy.security;

import com.example.grouvy.user.vo.User;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import java.util.Collection;

public class SecurityUser implements UserDetails {
    private final User user;

    public SecurityUser(User user) {
        this.user = user;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return user.getRoleNames()
                .stream()
                .map(roleName -> new SimpleGrantedAuthority(roleName))
                .toList();
    }

    @Override
    public String getPassword() {
        return user.getPassword();
    }

    @Override
    public String getUsername() {
        return user.getEmail();
    }

    @Override
    public boolean isEnabled() {
        boolean isEnabled = "퇴사".equals(user.getEmploymentStatus());
        return !isEnabled;
    }

    public User getUser() {
        return user;
    }

    // 부서명쓸일이 있어서 - 천지훈
    public String getDepartmentName() {
        return user.getDepartment().getDepartmentName();
    }

}
