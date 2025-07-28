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

    @Transactional
    public void recordDepartmentHistory(Long departmentId, String changeType, String oldValue, String newValue, int changerUserId) {
        DepartmentHistory history = new DepartmentHistory();
        history.setDepartmentId(departmentId);
        history.setChangeType(changeType);
        history.setOldValue(oldValue);
        history.setNewValue(newValue);
        history.setChangerUserId(changerUserId);
        departmentMapper.insertDepartmentHistory(history);
    }

    @Transactional(readOnly = true)
    public List<DepartmentHistory> getDepartmentHistoriesByDeptId(Long departmentId) {
        return departmentMapper.findDepartmentHistoryByDeptId(departmentId);
    }

    @Transactional(readOnly = true)
    public List<DepartmentHistory> getAllDepartmentHistories() {
        return departmentMapper.findAllDepartmentHistories();
    }
}