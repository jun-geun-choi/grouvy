package com.example.grouvy.notification.service;

import com.example.grouvy.message.mapper.MessageMapper;
import com.example.grouvy.notification.mapper.NotificationMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class UnreadCountService {

    private final MessageMapper messageMapper;
    private final NotificationMapper notificationMapper;
    private final SseService sseService;

    public void updateAndSendUnreadCount(int userId) {
        int unreadMessages = messageMapper.countUnreadReceivedMessages(userId);
        int unreadNotifications = notificationMapper.countTotalNotifications(userId);
        log.info("Updating unread counts for user {}: Messages={}, Notifications={}", userId, unreadMessages, unreadNotifications);

        Map<String, Integer> counts = new HashMap<>();
        counts.put("unreadMessages", unreadMessages);
        counts.put("unreadNotifications", unreadNotifications);

        sseService.sendToClient(userId, "unreadCounts", counts);
    }
}
