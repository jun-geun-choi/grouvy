package com.example.grouvy.user.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class SocialUserDto {
    private String email;
    private String name;
    private ProviderInfo providerInfo;
    private String identifier;
}
