package com.example.grouvy.notification.mapper;

import com.example.grouvy.notification.vo.Notification;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface NotificationMapper {

    void insertNotification(Notification notification);
    List<Notification> findNotificationsByUserIdPaginated(
            @Param("userId") int userId,
            @Param("offset") int offset,
            @Param("limit") int limit);
    int countTotalNotifications(@Param("userId") int userId);

    int updateNotificationContent(
            @Param("targetUrl") String targetUrl,
            @Param("userId") int userId,
            @Param("newContent") String newContent);

    int markNotificationsAsReadByTargetUrlAndUser(
            @Param("targetUrl") String targetUrl,
            @Param("userId") int userId);

    int markAllAsReadByUserId(@Param("userId") int userId);
}
