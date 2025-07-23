package com.example.grouvy.department.service;

import com.example.grouvy.department.mapper.DepartmentMapper;
import com.example.grouvy.department.vo.DepartmentHistory;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class DepartmentHistoryService {

    private final DepartmentMapper departmentMapper;
    // [삭제] ObjectMapper는 더 이상 필요 없습니다.
    // private final ObjectMapper objectMapper;

    @Transactional
    public void recordDepartmentHistory(Long departmentId, String changeType, String oldValue, String newValue, int changerUserId) {
        DepartmentHistory history = new DepartmentHistory();
        history.setDepartmentId(departmentId);
        history.setChangeType(changeType);
        history.setOldValue(oldValue); // 받은 문자열 그대로 저장
        history.setNewValue(newValue); // 받은 문자열 그대로 저장
        history.setChangerUserId(changerUserId);
        departmentMapper.insertDepartmentHistory(history);
    }

    // [수정] 조회 메서드를 원래의 단순한 형태로 되돌립니다.
    @Transactional(readOnly = true)
    public List<DepartmentHistory> getDepartmentHistoriesByDeptId(Long departmentId) {
        // DB에서 조회한 결과를 그대로 반환합니다.
        return departmentMapper.findDepartmentHistoryByDeptId(departmentId);
    }

    // [수정] 조회 메서드를 원래의 단순한 형태로 되돌립니다.
    @Transactional(readOnly = true)
    public List<DepartmentHistory> getAllDepartmentHistories() {
        // DB에서 조회한 결과를 그대로 반환합니다.
        return departmentMapper.findAllDepartmentHistories();
    }

    // [삭제] parseAndFormatJson 헬퍼 메서드와 스트림 처리 로직은 모두 제거합니다.
}