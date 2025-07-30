package com.example.grouvy.notification.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
public class NotificationDto {
    private Long notificationId;
    private int userId;
    private String notificationType;
    private String notificationContent;
    private String targetUrl;
    private Date createDate;
    private String isRead;
}
