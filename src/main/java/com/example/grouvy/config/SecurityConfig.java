package com.example.grouvy.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

// 보안 설정을 위한 클래스
@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {
  @Bean
  public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
    http
        .csrf(csrf -> csrf.disable())
        .authorizeHttpRequests(auth -> auth
            //.dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.INCLUDE).permitAll()
            .requestMatchers("/**").permitAll()
        )
        .formLogin(formLogin -> formLogin
            .usernameParameter("email")
            .passwordParameter("password")
            .loginPage("/login")
            .loginProcessingUrl("/login")
            .defaultSuccessUrl("/")
            .permitAll()
            .failureUrl("/login?failed")
        )
        .logout(logout -> logout
            .logoutUrl("/logout")
            .logoutSuccessUrl("/login")
        );
    return http.build();
  }

  // 비밀번호 암호화 코드
  @Bean
  public PasswordEncoder passwordEncoder() {
    return new BCryptPasswordEncoder();
  }

}
