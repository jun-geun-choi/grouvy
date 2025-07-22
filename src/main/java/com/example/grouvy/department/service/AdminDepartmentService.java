package com.example.grouvy.department.service;

import com.example.grouvy.department.mapper.DepartmentMapper;
import com.example.grouvy.department.vo.Department;
import com.example.grouvy.user.mapper.UserMapper;
import com.example.grouvy.user.vo.User;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AdminDepartmentService {

    private final DepartmentMapper departmentMapper;
    private final UserMapper userMapper;

    @Transactional(readOnly = true)
    public List<Department> getAllDepartments() {
        return departmentMapper.findAllDepts();
    }

    /**
     * 특정 ID의 부서 정보를 조회합니다.
     * @param departmentId 조회할 부서의 ID
     * @return 해당 부서 객체, 없으면 null
     */
    @Transactional(readOnly = true)
    public Department getDepartmentById(Long departmentId) {
        return departmentMapper.findDepartmentById(departmentId);
    }

    /**
     * 새로운 부서를 생성합니다.
     * @param department 생성할 부서 정보 (ID는 보통 자동 생성)
     */
    @Transactional
    public void createDepartment(Department department) {
        // 부서 생성 전 필요한 비즈니스 로직 (예: 유효성 검사, 기본값 설정)
        // department.setCreatedDate(new Date()); // SYSDATE는 DB에서 처리하지만, 필요하면 여기서도 가능
        // department.setIsDeleted("N"); // 기본값 설정
        departmentMapper.insertDepartment(department);
    }

    /**
     * 기존 부서 정보를 수정합니다.
     * @param department 수정할 부서 정보 (ID 포함)
     * @return 업데이트된 행의 수 (1이면 성공, 0이면 실패)
     */
    @Transactional
    public int updateDepartment(Department department) {
        // 부서 수정 전 필요한 비즈니스 로직 (예: 유효성 검사, 권한 확인)
        return departmentMapper.updateDepartment(department);
    }

    /**
     * 특정 ID의 부서를 삭제합니다.
     * @param departmentId 삭제할 부서의 ID
     * @return 삭제된 행의 수 (1이면 성공, 0이면 실패)
     */
    @Transactional
    public int deleteDepartment(Long departmentId) {
        // 1. 소속된 직원이 있는지 확인 (유저 목록 조회 후 size로 판단)
        List<User> usersInDepartment = userMapper.findUsersByDeptId(departmentId);
        if (usersInDepartment != null && usersInDepartment.size() > 0) {
            // 이 예외는 Controller나 RestController에서 잡아서 적절한 메시지를 반환해야 합니다.
            throw new IllegalStateException("해당 부서에 소속된 직원이 " + usersInDepartment.size() + "명 있어 삭제할 수 없습니다.");
        }
        int childDeptCount = departmentMapper.countChildDepartments(departmentId);
        if (childDeptCount > 0) {
            throw new IllegalStateException("하위 부서가 존재하여 삭제할 수 없습니다. 하위 부서를 먼저 삭제해주세요.");
        }
        // 모든 검증 통과 후 삭제
        return departmentMapper.deleteDepartment(departmentId);
    }
}
