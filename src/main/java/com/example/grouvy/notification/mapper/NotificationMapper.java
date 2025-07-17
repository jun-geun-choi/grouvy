// src/main/java/com/example/grouvy/notification/mapper/NotificationMapper.java
package com.example.grouvy.notification.mapper; // 새 패키지 경로

import com.example.grouvy.notification.vo.Notification; // Notification VO 임포트
import org.apache.ibatis.annotations.Mapper; // @Mapper 어노테이션 임포트
import org.apache.ibatis.annotations.Param; // @Param 어노테이션 임포트

import java.util.List;

@Mapper // 이 인터페이스가 MyBatis 매퍼임을 Spring에게 알려줍니다.
public interface NotificationMapper {

    /**
     * 새로운 알림을 GROUVY_NOTIFICATION 테이블에 삽입합니다.
     * notificationId는 시퀀스를 통해 자동 생성됩니다.
     *
     * @param notification 삽입할 Notification VO 객체 (notificationId가 AFTER 삽입됨)
     */
    void insertNotification(Notification notification);

    /**
     * 특정 사용자(userId)의 알림 목록을 페이징하여 조회합니다.
     *
     * @param userId 알림을 조회할 사용자의 USER_ID
     * @param offset 조회를 시작할 OFFSET (페이징)
     * @param limit 가져올 항목의 수 (페이징)
     * @return Notification VO 객체들의 리스트
     */
    List<Notification> findNotificationsByUserIdPaginated(
            @Param("userId") Long userId,
            @Param("offset") int offset,
            @Param("limit") int limit);

    /**
     * 특정 사용자(userId)의 전체 알림 수를 조회합니다. (페이징을 위해)
     *
     * @param userId 알림을 조회할 사용자의 USER_ID
     * @return 총 알림 수
     */
    int countTotalNotifications(@Param("userId") Long userId);

    /**
     * 특정 사용자(userId)의 읽지 않은 알림 수를 조회합니다. (SSE 알림 등에서 사용)
     *
     * @param userId 알림을 조회할 사용자의 USER_ID
     * @return 읽지 않은 알림 수
     */
    int countUnreadNotifications(@Param("userId") Long userId);

    /**
     * 특정 알림(notificationId)의 읽음 상태를 'Y'로 변경합니다.
     *
     * @param notificationId 읽음 처리할 알림의 NOTIFICATION_ID
     * @return 업데이트된 행의 수
     */
    int markAsRead(@Param("notificationId") Long notificationId);

    /**
     * 특정 알림(notificationId)을 논리적으로 삭제 처리합니다. (실제 DB 삭제 아님, IS_READ=Y로 변경)
     * GROUVY_NOTIFICATION 테이블에 IS_DELETED 컬럼이 없으므로, READ_YN을 'Y'로 변경하는 방식으로 삭제를 흉내냅니다.
     * 또는 이 쿼리를 아예 사용하지 않고, IS_READ 상태만으로 필터링할 수도 있습니다.
     * 실제로는 DELETE_YN 컬럼이 있어야 합니다. 여기서는 isRead를 'Y'로만 처리합니다.
     *
     * @param notificationId 삭제할 알림의 NOTIFICATION_ID
     * @param userId 알림을 삭제할 사용자의 USER_ID (본인인지 확인용)
     * @return 업데이트된 행의 수
     */
    int deleteNotification(@Param("notificationId") Long notificationId, @Param("userId") Long userId);

    /**
     * 특정 사용자(userId)의 모든 알림을 삭제 처리합니다. (IS_READ='Y'로 변경)
     *
     * @param userId 모든 알림을 삭제할 사용자의 USER_ID
     * @return 업데이트된 행의 수
     */
    int deleteAllNotificationsByUserId(@Param("userId") Long userId);

    /**
     * 선택된 여러 알림(notificationIds)을 삭제 처리합니다. (IS_READ='Y'로 변경)
     *
     * @param notificationIds 삭제할 알림 ID 목록
     * @param userId 알림을 삭제할 사용자의 USER_ID
     * @return 업데이트된 행의 수
     */
    int deleteSelectedNotifications(
            @Param("notificationIds") List<Long> notificationIds,
            @Param("userId") Long userId);

    /**
     * 특정 알림(notificationId)을 조회합니다.
     * @param notificationId 조회할 알림 ID
     * @return Notification 객체
     */
    Notification findNotificationById(@Param("notificationId") Long notificationId);

    /**
     * 대상 URL과 사용자 ID로 알림 내용을 업데이트하고 읽음 상태로 변경합니다. (쪽지 회수 시 사용)
     * GROUVY_NOTIFICATION 테이블에 IS_DELETED 컬럼이 없으므로, isRead를 'Y'로 변경하는 방식으로 처리합니다.
     *
     * @param targetUrl 대상 URL
     * @param userId 사용자 ID
     * @param newContent 새로운 알림 내용
     * @return 업데이트된 행의 수
     */
    int updateNotificationContent(
            @Param("targetUrl") String targetUrl,
            @Param("userId") Long userId,
            @Param("newContent") String newContent);

    /**
     * 대상 URL과 사용자 ID로 알림의 읽음 상태를 변경합니다. (메시지 읽음 처리 시 사용)
     *
     * @param targetUrl 대상 URL (예: /message/inbox?messageId=...)
     * @param userId 사용자 ID
     * @return 업데이트된 행의 수
     */
    int markNotificationsAsReadByTargetUrlAndUser(
            @Param("targetUrl") String targetUrl,
            @Param("userId") Long userId);
}