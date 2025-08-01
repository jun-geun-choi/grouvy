package com.example.grouvy.notification.vo;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
@Builder
public class Notification {
    private Long notificationId;
    private int userId;
    private String notificationType;
    private String notificationContent;
    private String targetUrl;
    private Date createDate;
    private String isRead;
}
