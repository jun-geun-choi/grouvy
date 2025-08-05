package com.example.grouvy.message.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Collections;
import java.util.List;

@Getter // 필드에 대한 getter 메서드를 자동으로 생성합니다.
@Setter // 필드에 대한 setter 메서드를 자동으로 생성합니다.
@NoArgsConstructor // 인자 없는 기본 생성자를 Lombok이 자동으로 생성합니다.
public class PaginationResponse<T> { // 제네릭 타입 <T>를 사용하여 어떤 데이터 타입이든 담을 수 있습니다.
    private List<T> content; // 현재 페이지에 표시될 데이터 목록
    private int pageNumber; // 현재 페이지 번호 (0부터 시작, 0이 첫 번째 페이지)
    private int pageSize; // 한 페이지당 표시될 항목 수
    private long totalElements; // 전체 항목 수
    private int totalPages; // 전체 페이지 수
    private boolean hasPrevious; // 이전 페이지가 있는지 여부
    private boolean hasNext; // 다음 페이지가 있는지 여부
    private boolean isFirst; // 첫 번째 페이지인지 여부
    private boolean isLast; // 마지막 페이지인지 여부

    // 웹 화면 표시용 페이지 번호 (1부터 시작)
    public int getDisplayPageNumber() {
        return pageNumber + 1;
    }

    public PaginationResponse(List<T> content, int pageNumber, int pageSize, long totalElements) {
        this.content = content != null ? content : Collections.emptyList(); // null 방지
        this.pageNumber = pageNumber;
        this.pageSize = pageSize;
        this.totalElements = totalElements;
        // 전체 페이지 수 계산: (전체 항목 수 + 페이지 크기 - 1) / 페이지 크기 (올림 계산)
        this.totalPages = pageSize == 0 ? 1 : (int) Math.ceil((double) totalElements / pageSize);
        this.hasPrevious = pageNumber > 0; // 현재 페이지가 0보다 크면 이전 페이지가 있음
        this.hasNext = (pageNumber + 1) < totalPages; // 현재 페이지+1이 전체 페이지 수보다 작으면 다음 페이지가 있음
        this.isFirst = pageNumber == 0; // 현재 페이지가 0이면 첫 번째 페이지
        this.isLast = (pageNumber + 1) >= totalPages; // 현재 페이지+1이 전체 페이지 수와 같거나 크면 마지막 페이지
    }
}
