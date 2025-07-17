// src/main/java/com/example/grouvy/notification/service/UnreadCountService.java
package com.example.grouvy.notification.service; // notification 도메인 서비스 패키지

import com.example.grouvy.message.mapper.MessageMapper; // MessageMapper 임포트
import com.example.grouvy.notification.mapper.NotificationMapper; // NotificationMapper 임포트
import lombok.RequiredArgsConstructor; // Lombok의 RequiredArgsConstructor 임포트
import org.springframework.stereotype.Service; // @Service 어노테이션 임포트
// org.springframework.context.annotation.Lazy; // 순환 참조 발생 시 @Lazy 사용 가능

@Service // 이 클래스가 스프링의 서비스 컴포넌트임을 나타냅니다.
@RequiredArgsConstructor // final 필드들을 주입받는 생성자를 Lombok이 자동으로 생성합니다.
public class UnreadCountService {

    private final MessageMapper messageMapper; // MessageMapper 의존성 주입
    private final NotificationMapper notificationMapper; // NotificationMapper 의존성 주입
    private final SseService sseService; // SseService 의존성 주입 (SseService에서 이 서비스를 호출할 경우 순환 참조 주의)

    /**
     * 특정 사용자의 읽지 않은 쪽지와 알림 개수를 조회하고, SSE를 통해 클라이언트에게 전송합니다.
     * 이 메서드는 쪽지/알림 상태 변경 시 (새 쪽지 도착, 쪽지 읽음, 알림 읽음 등) 호출됩니다.
     *
     * @param userId 카운트를 업데이트할 사용자의 USER_ID
     */
    public void updateAndSendUnreadCounts(Long userId) {
        int unreadMessages = messageMapper.countUnreadReceivedMessages(userId); // 읽지 않은 쪽지 수
        int unreadNotifications = notificationMapper.countUnreadNotifications(userId); // 읽지 않은 알림 수

        // SseService를 통해 클라이언트에 실시간으로 카운트 정보 전송
        sseService.sendUnreadCounts(userId, unreadMessages, unreadNotifications);
        System.out.println("User " + userId + " - Unread Message Count: " + unreadMessages + ", Unread Notification Count: " + unreadNotifications + " (via SSE)");
    }

    /**
     * 특정 사용자의 읽지 않은 쪽지 개수만 조회합니다. (SSE 전송 없이 단독 조회)
     * @param userId 사용자 ID
     * @return 읽지 않은 쪽지 개수
     */
    public int getUnreadMessageCount(Long userId) {
        return messageMapper.countUnreadReceivedMessages(userId);
    }

    /**
     * 특정 사용자의 읽지 않은 알림 개수만 조회합니다. (SSE 전송 없이 단독 조회)
     * @param userId 사용자 ID
     * @return 읽지 않은 알림 개수
     */
    public int getUnreadNotificationCount(Long userId) {
        return notificationMapper.countUnreadNotifications(userId);
    }
}