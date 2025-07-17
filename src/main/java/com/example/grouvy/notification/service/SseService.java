// src/main/java/com/example/grouvy/notification/service/SseService.java
package com.example.grouvy.notification.service; // notification 도메인 서비스 패키지

import com.example.grouvy.notification.vo.Notification; // Notification VO 임포트 (새 알림 전송용)
import com.fasterxml.jackson.core.JsonProcessingException; // JSON 변환 오류 처리를 위해 임포트
import com.fasterxml.jackson.databind.ObjectMapper; // Java 객체를 JSON으로 변환하기 위해 임포트
import lombok.RequiredArgsConstructor; // Lombok의 RequiredArgsConstructor 임포트
import org.springframework.stereotype.Service; // @Service 어노테이션 임포트
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter; // SSEEmitter 임포트

import java.io.IOException; // IOException 처리를 위해 임포트
import java.util.List; // List 타입을 위해 임포트
import java.util.Map; // Map 타입을 위해 임포트
import java.util.concurrent.ConcurrentHashMap; // 동시성 문제를 고려한 HashMap 구현체
import java.util.concurrent.CopyOnWriteArrayList; // 동시성 문제를 고려한 ArrayList 구현체

@Service // 이 클래스가 스프링의 서비스 컴포넌트임을 나타냅니다.
@RequiredArgsConstructor // final 필드들을 주입받는 생성자를 Lombok이 자동으로 생성합니다.
public class SseService {

    // 각 USER_ID에 대한 SseEmitter 리스트를 저장하는 Map
    // ConcurrentHashMap: 멀티쓰레드 환경에서 안전하게 Map을 사용하기 위함.
    // CopyOnWriteArrayList: Emitter 리스트에 대한 쓰기 작업 시 복사본을 만들어 처리하여 읽기 시 동시성 이슈를 줄임.
    private final Map<Long, List<SseEmitter>> emitters = new ConcurrentHashMap<>();
    private final ObjectMapper objectMapper; // Java 객체를 JSON으로 변환해주는 객체 (Spring Boot가 자동 주입)

    private static final Long DEFAULT_TIMEOUT = 60L * 1000 * 60; // SSE 연결 타임아웃 (1시간)

    // UnreadCountService는 이 서비스에서 호출하지 않음 (순환 참조 방지)
    // private final UnreadCountService unreadCountService;

    /**
     * 새로운 SSE Emitter를 등록하고 초기 연결 이벤트를 전송합니다.
     * @param userId 연결을 요청하는 사용자의 USER_ID
     * @return 새로 생성된 SseEmitter 객체
     */
    public SseEmitter addEmitter(Long userId) {
        // SSE 연결 타임아웃 설정
        SseEmitter emitter = new SseEmitter(DEFAULT_TIMEOUT);

        // 기존에 해당 userId에 대한 Emitter가 있다면 모두 완료 처리하고 제거 (중복 연결 방지 및 기존 연결 정리)
        List<SseEmitter> existingEmitters = emitters.computeIfAbsent(userId, k -> new CopyOnWriteArrayList<>());
        // computeIfAbsent: userId가 없으면 새로운 CopyOnWriteArrayList를 생성하고, 있으면 기존 리스트를 반환.
        // CopyOnWriteArrayList를 사용하는 이유는, Emitter가 여러 개 있을 수 있고,
        // 이 리스트에 대한 반복 중 remove가 발생할 수 있기 때문에 ConcurrentModificationException 방지.

        // 기존 에미터 완료 처리 (기존 연결이 끊어지도록 강제)
        for (SseEmitter e : existingEmitters) {
            try {
                e.complete(); // 기존 연결 완료
            } catch (Exception ignored) {
                // 이미 완료되었거나 에러가 발생한 에미터는 무시
                System.err.println("Failed to complete existing emitter for user: " + userId + ": " + ignored.getMessage());
            }
        }
        existingEmitters.clear(); // 기존 목록 비우기
        existingEmitters.add(emitter); // 새로운 에미터 추가

        // Emitter 완료(Completion) 시 호출될 콜백 설정
        emitter.onCompletion(() -> {
            removeEmitter(userId, emitter); // 완료되면 맵에서 제거
            System.out.println("SSE Emitter completed for user: " + userId);
        });

        // Emitter 타임아웃(Timeout) 시 호출될 콜백 설정
        emitter.onTimeout(() -> {
            System.out.println("SSE Emitter timed out for user: " + userId);
            emitter.complete(); // 타임아웃 발생 시 연결 종료
        });

        // Emitter 에러(Error) 시 호출될 콜백 설정
        emitter.onError(e -> {
            System.err.println("SSE Emitter error for user: " + userId + ": " + e.getMessage());
            removeEmitter(userId, emitter); // 에러 발생 시 맵에서 제거
        });

        try {
            // 초기 연결 성공 메시지 전송
            emitter.send(SseEmitter.event()
                    .name("connect") // 이벤트 이름
                    .data("Connected to SSE! User: " + userId)); // 전송할 데이터
            System.out.println("Initial SSE connect event sent to user: " + userId);

            // 초기 읽지 않은 카운트 전송은 UnreadCountService에서 담당 (여기서 직접 호출하지 않음)
            // unreadCountService.updateAndSendUnreadCounts(userId); // 순환 참조 발생 우려

        } catch (IOException e) {
            System.err.println("Failed to send initial SSE event to user: " + userId + ", Error: " + e.getMessage());
            removeEmitter(userId, emitter); // 전송 실패 시 제거
        }

        System.out.println("New SSE Emitter added for user: " + userId + ", Total emitters for " + userId + ": " + emitters.get(userId).size());
        return emitter;
    }

    /**
     * 특정 사용자에게 할당된 SSE Emitter를 Map에서 제거합니다.
     * @param userId 제거할 Emitter의 사용자 ID
     * @param emitter 제거할 SseEmitter 객체
     */
    private void removeEmitter(Long userId, SseEmitter emitter) {
        if (this.emitters.containsKey(userId)) {
            // 해당 userId의 Emitter 리스트에서 특정 Emitter 제거
            this.emitters.get(userId).remove(emitter);
            // 만약 해당 userId의 Emitter 리스트가 비었다면, Map에서 userId 엔트리 자체를 제거
            if (this.emitters.get(userId).isEmpty()) {
                this.emitters.remove(userId);
            }
            System.out.println("SSE Emitter removed for user: " + userId);
        }
    }

    /**
     * 특정 사용자에게 새로운 알림 데이터를 SSE를 통해 전송합니다.
     * @param userId 알림을 받을 사용자의 USER_ID
     * @param notification 전송할 Notification VO 객체
     */
    public void sendNotification(Long userId, Notification notification) {
        String jsonData;
        try {
            // Notification 객체를 Map으로 변환하여 JSON 직렬화 시 불필요한 필드를 제어하거나,
            // 특정 형식으로 데이터를 가공하여 전송할 수 있습니다.
            // 여기서는 Notification VO를 직접 JSON으로 변환합니다.
            // (Lombok의 @Builder, @Getter 등으로 인해 기본 직렬화가 잘 됩니다.)
            jsonData = objectMapper.writeValueAsString(notification);
        } catch (JsonProcessingException e) {
            System.err.println("Failed to convert notification to JSON: " + e.getMessage());
            return;
        }

        // 해당 userId에 대한 모든 활성 Emitter에 알림 전송
        List<SseEmitter> userEmitters = emitters.get(userId);
        if (userEmitters != null) {
            // CopyOnWriteArrayList를 사용하므로, 반복 중 remove 호출이 안전합니다.
            for (SseEmitter emitter : userEmitters) {
                try {
                    emitter.send(SseEmitter.event()
                            .name("notification") // 이벤트 이름 (클라이언트에서 addEventListener("notification", ...)으로 받음)
                            .data(jsonData)); // JSON 문자열 데이터 전송
                    System.out.println("Notification sent to user " + userId + ": " + notification.getNotificationContent());
                } catch (IOException | IllegalStateException e) {
                    System.err.println("Error sending notification to user " + userId + ", removing emitter. Error: " + e.getMessage());
                    removeEmitter(userId, emitter); // 전송 실패 시 해당 Emitter 제거
                }
            }
        } else {
            System.out.println("No active SSE emitters for user: " + userId + " to send notification.");
        }
    }

    /**
     * 특정 사용자에게 읽지 않은 쪽지와 알림 카운트 데이터를 SSE를 통해 전송합니다.
     * @param userId 카운트를 전송할 사용자의 USER_ID
     * @param unreadMessageCount 읽지 않은 쪽지 수
     * @param unreadNotificationCount 읽지 않은 알림 수
     */
    public void sendUnreadCounts(Long userId, int unreadMessageCount, int unreadNotificationCount) {
        List<SseEmitter> userEmitters = emitters.get(userId);
        if (userEmitters == null || userEmitters.isEmpty()) {
            System.out.println("No active SSE emitters for user: " + userId + " to send counts.");
            return;
        }

        try {
            Map<String, Integer> countData = new ConcurrentHashMap<>();
            countData.put("unreadMessages", unreadMessageCount);
            countData.put("unreadNotifications", unreadNotificationCount);

            String jsonData = objectMapper.writeValueAsString(countData);

            for (SseEmitter emitter : userEmitters) {
                try {
                    emitter.send(SseEmitter.event()
                            .name("unreadCounts") // 이벤트 이름 (클라이언트에서 addEventListener("unreadCounts", ...)로 받음)
                            .data(jsonData)); // JSON 문자열 데이터 전송
                    System.out.println("Unread counts sent to user " + userId + ": Msg=" + unreadMessageCount + ", Noti=" + unreadNotificationCount);
                } catch (IOException | IllegalStateException e) {
                    System.err.println("Error sending unread counts to user: " + userId + ", removing emitter. Error: " + e.getMessage());
                    removeEmitter(userId, emitter); // 전송 실패 시 해당 Emitter 제거
                }
            }
        } catch (JsonProcessingException e) {
            System.err.println("Failed to convert count data to JSON: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("Unexpected error while sending unread counts: " + e.getMessage());
        }
    }
}