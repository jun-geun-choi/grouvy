package com.example.grouvy.notification.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Service
@RequiredArgsConstructor
public class SseService {

    private static final Long DEFAULT_TIMEOUT = 60L * 60 * 1000;
    private final Map<Integer, SseEmitter> emitters = new ConcurrentHashMap<>();
    private final ObjectMapper objectMapper;

    /**
     * 특정 사용자에 대한 SseEmitter를 생성하고 등록합니다.
     * @param userId 연결을 요청하는 사용자의 ID
     * @return 생성된 SseEmitter 객체
     */
    public SseEmitter addEmitter(int userId) {
        SseEmitter emitter = new SseEmitter(DEFAULT_TIMEOUT);

        //emitters 맵에 사용자 ID와 emitter를 저장
        this.emitters.put(userId, emitter);
        log.info("New emitter added for user: {}, total emitters: {}", userId, emitters.size());

        //emitter가 완료되거나, 타임아웃 되거나, 에러 발생 시 맵에서 제거
        emitter.onCompletion(() -> removeEmitter(userId,"completed"));
        emitter.onTimeout(() -> removeEmitter(userId, "timed out"));
        emitter.onError(e -> {
            log.error("SSE error for user {}: {}", userId, e.getMessage());
            removeEmitter(userId, "errored");
        });

        //연결 확인을 위한 초기 더미데이터 전송
        sendToClient(userId, "connect", "SSE connection established");
        return emitter;
    }

    /**
     * 특정 사용자에게 데이터를 전송합니다.
     * @param userId 데이터를 받을 사용자의 ID
     * @param eventName 이벤트 이름 (클라이언트에서 addEventListener로 수신할 이름)
     * @param data 전송할 데이터 (객체)
     */
    public void sendToClient(int userId, String eventName, Object data) {
        SseEmitter emitter = emitters.get(userId);
        if (emitter != null) {
            try {
                //데이터를 JSON문자열로 변환
                String jsonData = objectMapper.writeValueAsString(data);

                //event() 빌더를 사용하여 이벤트이름과 데이터를 전송
                emitter.send(SseEmitter.event()
                        .name(eventName)
                        .data(jsonData));
                log.info("Sent event '{}' to user {}: {}", eventName, userId, jsonData);
            } catch (IOException e) {
                log.error("Failed to send SSE event to user {}: {}", userId, e.getMessage());
                //전송 실패시 연결이 끊어진 것으로 간주하고 맵에서 제거
                removeEmitter(userId, "send-failed");
            }
        } else {
            log.warn("No emitter found for user {} to send event '{}'", userId, eventName);
        }
    }

    /**
     * 특정 사용자의 SseEmitter를 맵에서 제거합니다.
     * @param userId 제거할 사용자의 ID
     * @param reason 제거 사유 (로그 출력용)
     */
    private void removeEmitter(int userId, String reason) {
        if (this.emitters.remove(userId) != null) {
            log.info("Emitter for user {} removed. Reason: {}. Total emitters: {}", userId, reason, emitters.size());
        }
    }
}
