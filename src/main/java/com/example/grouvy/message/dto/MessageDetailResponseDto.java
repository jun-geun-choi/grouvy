// src/main/java/com/example/grouvy/message/dto/MessageDetailResponseDto.java
package com.example.grouvy.message.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.Date;
import java.util.List;
import java.util.ArrayList; // List 초기화를 위해 임포트

@Getter
@Setter
public class MessageDetailResponseDto {
    private Long messageId; // 쪽지 고유 ID
    private Long senderId; // 발신자 USER_ID
    private String senderName; // 발신자 이름 (User 테이블에서 조회)
    private String subject; // 쪽지 제목
    private String messageContent; // 쪽지 내용
    private Date sendDate; // 발송 일시
    private String recallAble; // 회수 가능 여부 (Y/N)
    private boolean currentlyRecallable; // 현재 시점에서 회수가 가능한지 여부 (읽지 않은 수신자가 있는지 여부)

    // TO, CC, BCC 수신자들의 이름 목록 (콤마로 연결되지 않은 개별 이름 리스트)
    private List<String> toUserNames = new ArrayList<>();
    private List<String> ccUserNames = new ArrayList<>();
    private List<String> bccUserNames = new ArrayList<>();

    // 기타 필요 정보
    private Long receiveId; // 받은 쪽지함에서 조회 시, 해당 수신 기록의 ID (삭제, 중요표시 등 액션에 사용)
    private String inboxStatus; // 받은 쪽지함에서의 상태 (UNREAD, READ, RECALLED_BY_SENDER)
    private String importantYn; // 중요 표시 여부
}