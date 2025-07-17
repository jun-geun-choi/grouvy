// src/main/java/com/example/grouvy/notification/vo/Notification.java
package com.example.grouvy.notification.vo; // 새 패키지 경로

import lombok.Getter; // Lombok의 Getter 어노테이션 사용
import lombok.Setter; // Lombok의 Setter 어노테이션 사용
import lombok.NoArgsConstructor; // Lombok의 NoArgsConstructor 어노테이션 사용
import lombok.AllArgsConstructor; // Lombok의 AllArgsConstructor 어노테이션 사용
import lombok.Builder; // Lombok의 Builder 어노테이션 사용 (객체 생성 시 편의)

import java.util.Date; // java.util.Date 임포트

@Getter // 필드에 대한 getter 메서드를 자동으로 생성합니다.
@Setter // 필드에 대한 setter 메서드를 자동으로 생성합니다.
@NoArgsConstructor // 인자 없는 기본 생성자를 Lombok이 자동으로 생성합니다.
@AllArgsConstructor // 모든 필드를 인자로 받는 생성자를 Lombok이 자동으로 생성합니다.
@Builder // Builder 패턴을 사용하여 객체를 생성할 수 있도록 합니다. (예: Notification.builder()...build())
public class Notification {
    private Long notificationId; // NOTIFICATION_ID (NUMBER(10,0) -> Long) - 알림 고유 ID
    private Long userId; // USER_ID (NUMBER(6) -> Long) - 알림을 받을 사용자 ID
    private String notificationType; // NOTIFICATION_TYPE (VARCHAR2(20) -> String) - 알림 타입 코드 (예: MSG_RECV, MSG_RECV_CC)
    private String notificationContent; // NOTIFICATION_CONTENT (VARCHAR2(500) -> String) - 알림 내용 (사용자에게 표시될 텍스트)
    private String targetUrl; // TARGET_URL (VARCHAR2(200) -> String) - 알림 클릭 시 이동할 URL (예: /message/detail?messageId=123)
    private Date createDate; // CREATE_DATE (DATE -> java.util.Date) - 알림 생성 일시
    private String isRead; // IS_READ (CHAR(1) -> String) - 알림 읽음 여부 ('N' or 'Y')
    // GROUVY_NOTIFICATION 테이블에 IS_DELETED 컬럼이 명시되어 있지 않지만,
    // 논리적 삭제 기능을 고려하여 추가할 수 있습니다. (현재 DB 스키마에는 없음)
    // private String isDeleted; // 논리적 삭제 여부 (알림 목록에서 제외)
}