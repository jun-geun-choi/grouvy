package com.example.grouvy.notification.service;

import com.example.grouvy.message.dto.PaginationResponse;
import com.example.grouvy.notification.mapper.NotificationMapper;
import com.example.grouvy.notification.vo.Notification;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class NotificationService {

    private final NotificationMapper notificationMapper;

    public void createNotification(Notification notification) {
        notificationMapper.insertNotification(notification);
    }

    public PaginationResponse<Notification> getNotificationsByUserId(int userId, int page, int size) {
        int offset = (page - 1) * size;
        List<Notification> notifications = notificationMapper.findNotificationsByUserIdPaginated(userId, offset, size);
        int totalElements = notificationMapper.countTotalNotifications(userId);
        return new PaginationResponse<>(notifications, page-1, size, totalElements);
    }

    @Transactional
    public void updateNotificationContent(String targetUrl, int userId, String newContent) {
        int updatedCount = notificationMapper.updateNotificationContent(targetUrl, userId, newContent);
        if (updatedCount > 0) {
            System.out.println("알림 내용 읽음처리완료:" +userId + targetUrl);
        }
    }

    @Transactional
    public void markNotificationsAsReadByTargetUrlAndUser(String targetUrl, int userId) {
        int updatedCount = notificationMapper.markNotificationsAsReadByTargetUrlAndUser(targetUrl, userId);
        if (updatedCount > 0) {
            System.out.println("url기반 알림내용 읽음처리완료"+userId + targetUrl);
        }
    }

    @Transactional
    public int markAllAsRead(int userId) {
        int updatedCount = notificationMapper.markAllAsReadByUserId(userId);

        if (updatedCount > 0) {
            System.out.println(userId + " 사용자의 모든 알림 " + updatedCount + "건 읽음 처리 완료");
        }
        return updatedCount;
    }
}
