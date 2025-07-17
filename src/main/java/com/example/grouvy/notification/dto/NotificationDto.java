// src/main/java/com/example/grouvy/notification/dto/NotificationDto.java
package com.example.grouvy.notification.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;

import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class NotificationDto { // Notification VO와 유사하지만 DTO의 역할에 맞게 사용
    private Long notificationId;
    private Long userId;
    private String notificationType;
    private String notificationContent;
    private String targetUrl;
    private Date createDate;
    private String isRead;
    // 향후 필요하다면 알림을 보낸 사용자 이름 등 추가 필드 포함 가능
    // private String senderName;
}