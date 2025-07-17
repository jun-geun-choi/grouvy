// src/main/java/com.example/grouvy/notification/service/NotificationService.java
package com.example.grouvy.notification.service;

import com.example.grouvy.message.dto.PaginationResponse;
import com.example.grouvy.notification.mapper.NotificationMapper; // NotificationMapper 임포트
import com.example.grouvy.notification.vo.Notification; // Notification VO 임포트

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service // 이 클래스가 스프링의 서비스 컴포넌트임을 나타냅니다.
@RequiredArgsConstructor // final 필드들을 주입받는 생성자를 Lombok이 자동으로 생성합니다.
public class NotificationService {

    private final NotificationMapper notificationMapper; // NotificationMapper 의존성 주입
    private final SseService sseService; // SseService 의존성 주입
    private final UnreadCountService unreadCountService; // UnreadCountService 의존성 주입

    /**
     * 새로운 알림을 생성하고, SSE를 통해 해당 사용자에게 실시간으로 알림을 전송합니다.
     * 또한, 읽지 않은 알림/쪽지 카운트를 업데이트하여 SSE로 전송합니다.
     *
     * @param notification 생성할 Notification VO 객체
     */
    @Transactional // 알림 삽입은 트랜잭션으로 관리
    public void createNotification(Notification notification) {
        notificationMapper.insertNotification(notification); // 알림 DB에 삽입

        // 알림 생성 후, 해당 사용자에게 SSE를 통해 실시간 알림 전송
        sseService.sendNotification(notification.getUserId(), notification);

        // 알림 생성으로 읽지 않은 알림 수가 변경될 수 있으므로, 카운트 업데이트 및 SSE 전송
        unreadCountService.updateAndSendUnreadCounts(notification.getUserId());
    }

    /**
     * 특정 사용자(userId)의 알림 목록을 페이징 처리하여 조회합니다.
     *
     * @param userId 알림을 조회할 사용자의 USER_ID
     * @param page 조회할 페이지 번호 (1부터 시작)
     * @param size 한 페이지당 항목 수
     * @return 페이징된 Notification 목록이 포함된 PaginationResponse
     */
    public PaginationResponse<Notification> getNotificationsByUserId(Long userId, int page, int size) {
        int offset = (page - 1) * size; // OFFSET 계산
        List<Notification> notifications = notificationMapper.findNotificationsByUserIdPaginated(userId, offset, size);
        int totalElements = notificationMapper.countTotalNotifications(userId);
        return new PaginationResponse<>(notifications, page - 1, size, totalElements); // pageNumber는 0부터 시작
    }

    /**
     * 특정 알림(notificationId)의 읽음 상태를 'Y'로 변경합니다.
     * 이 메서드는 알림 클릭 시 호출됩니다.
     *
     * @param notificationId 읽음 처리할 알림의 NOTIFICATION_ID
     */
    @Transactional
    public void markNotificationAsRead(Long notificationId) {
        Notification notification = notificationMapper.findNotificationById(notificationId);
        if (notification != null && "N".equals(notification.getIsRead())) { // 아직 읽지 않은 알림만 처리
            notificationMapper.markAsRead(notificationId); // DB 업데이트
            unreadCountService.updateAndSendUnreadCounts(notification.getUserId()); // 카운트 업데이트 및 SSE 전송
        }
    }

    /**
     * 특정 targetUrl과 사용자 ID에 해당하는 알림의 내용을 업데이트하고 읽음 상태로 변경합니다.
     * (주로 쪽지 회수 시 사용: "쪽지가 회수되었습니다" 등으로 내용 변경)
     *
     * @param targetUrl 업데이트할 알림의 대상 URL (알림을 식별하는 기준)
     * @param userId 알림을 받은 사용자 ID
     * @param newContent 새로운 알림 내용
     */
    @Transactional
    public void updateNotificationContent(String targetUrl, Long userId, String newContent) {
        int updatedCount = notificationMapper.updateNotificationContent(targetUrl, userId, newContent);
        if (updatedCount > 0) {
            // 알림 내용 변경으로 카운트가 변경되지는 않지만, 읽음 상태로 변경되었으므로 카운트 업데이트
            unreadCountService.updateAndSendUnreadCounts(userId);
        }
    }

    /**
     * 특정 targetUrl과 사용자 ID에 해당하는 알림의 읽음 상태를 'Y'로 변경합니다.
     * (주로 쪽지 상세 페이지 진입 시 해당 쪽지 관련 알림을 일괄 읽음 처리)
     *
     * @param targetUrl 대상 URL (예: /message/detail?messageId=...)
     * @param userId 알림을 받은 사용자 ID
     */
    @Transactional
    public void markNotificationsAsReadByTargetUrlAndUser(String targetUrl, Long userId) {
        int updatedCount = notificationMapper.markNotificationsAsReadByTargetUrlAndUser(targetUrl, userId);
        if (updatedCount > 0) {
            unreadCountService.updateAndSendUnreadCounts(userId); // 카운트 업데이트
        }
    }

    /**
     * 특정 알림을 삭제 처리합니다. (논리적 삭제, IS_READ='Y'로 변경)
     *
     * @param notificationId 삭제할 알림의 NOTIFICATION_ID
     * @param userId 알림을 삭제할 사용자의 USER_ID (권한 확인용)
     * @return 삭제 성공 여부
     */
    @Transactional
    public boolean deleteNotification(Long notificationId, Long userId) {
        // Mapper에서 userId로 해당 알림의 소유권까지 검증하도록 구현하는 것이 좋음
        // (현재 Mapper에는 notificationId만 받는 deleteNotification이 있으므로, userId로 검증하는 로직을 추가하거나 Mapper 수정 필요)
        // 여기서는 일단 Mapper에 userId를 넘겨서 삭제 요청자의 userId와 알림의 userId가 일치할 때만 삭제되도록 구현했다고 가정
        int updated = notificationMapper.deleteNotification(notificationId, userId);
        if (updated > 0) {
            unreadCountService.updateAndSendUnreadCounts(userId); // 카운트 업데이트
        }
        return updated > 0;
    }

    /**
     * 특정 사용자(userId)의 모든 알림을 삭제 처리합니다. (논리적 삭제)
     *
     * @param userId 모든 알림을 삭제할 사용자의 USER_ID
     * @return 삭제 성공 여부
     */
    @Transactional
    public boolean deleteAllNotifications(Long userId) {
        int updated = notificationMapper.deleteAllNotificationsByUserId(userId);
        if (updated > 0) {
            unreadCountService.updateAndSendUnreadCounts(userId); // 카운트 업데이트
        }
        return updated > 0;
    }

    /**
     * 선택된 여러 알림(notificationIds)을 삭제 처리합니다. (논리적 삭제)
     *
     * @param notificationIds 삭제할 알림 ID 목록
     * @param userId 알림을 삭제할 사용자의 USER_ID
     * @return 삭제 성공 여부
     */
    @Transactional
    public boolean deleteSelectedNotifications(List<Long> notificationIds, Long userId) {
        if (notificationIds == null || notificationIds.isEmpty()) {
            return false; // 삭제할 알림이 선택되지 않음
        }
        // Mapper에서 각 ID에 대해 userId까지 검증하여 삭제하는 것이 안전함
        int updated = notificationMapper.deleteSelectedNotifications(notificationIds, userId);
        if (updated > 0) {
            unreadCountService.updateAndSendUnreadCounts(userId); // 카운트 업데이트
        }
        return updated > 0;
    }

    /**
     * 특정 사용자의 읽지 않은 알림 수를 조회합니다. (SSE 알림에 사용)
     * @param userId 사용자 ID
     * @return 읽지 않은 알림 수
     */
    public int countUnreadNotifications(Long userId) {
        return notificationMapper.countUnreadNotifications(userId);
    }
}