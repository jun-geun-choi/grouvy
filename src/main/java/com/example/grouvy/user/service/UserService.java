// src/main/java/com/example/grouvy/user/service/UserService.java
package com.example.grouvy.user.service; // 새 패키지 경로

import com.example.grouvy.user.mapper.UserMapper; // UserMapper의 새 경로
import com.example.grouvy.user.vo.User; // User VO의 새 경로
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional; // 트랜잭션 관리를 위해 임포트

import java.util.List;

@Service // 이 클래스가 스프링의 서비스 컴포넌트임을 나타냅니다.
@RequiredArgsConstructor // Lombok을 사용하여 final 필드에 대한 생성자를 자동 생성합니다 (의존성 주입)
public class UserService {

    private final UserMapper userMapper; // UserMapper에 대한 의존성 주입

    /**
     * 특정 사용자 ID로 사용자 정보를 조회합니다.
     * @param userId 조회할 사용자의 ID (Long 타입으로 변경됨)
     * @return 조회된 User 객체, 없으면 null
     */
    public User getUserByUserId(Long userId) {
        // userMapper의 findByUserId 메서드를 호출하여 사용자 정보를 DB에서 가져옵니다.
        // 이때, UserMapper에서 이미 USER_ID가 Long 타입으로 처리되도록 설정되었으므로 그대로 사용합니다.
        User user = userMapper.findByUserId(userId);
        if (user != null) {
            // 사용자의 역할 정보도 함께 로드하여 User 객체에 설정합니다.
            // 이 역할 정보는 Security가 활성화될 때 유용합니다.
            List<String> roles = userMapper.findRolesByUserId(userId);
            user.setRoles(roles);
        }
        return user;
    }

    /**
     * 특정 부서에 소속된 사용자 목록을 조회합니다.
     * 이 메서드는 조직도(Dept)에서 특정 부서의 하위 사용자들을 표시할 때 사용됩니다.
     * @param departmentId 조회할 부서의 ID (Long 타입)
     * @return 해당 부서에 소속된 User 객체 목록
     */
    public List<User> getUsersByDepartmentId(Long departmentId) {
        // userMapper의 findUsersByDeptId 메서드를 호출합니다.
        // 파라미터 departmentId는 Long 타입입니다.
        return userMapper.findUsersByDeptId(departmentId);
    }

    // --- (이전에 있던 searchUsers 등의 메서드는 현재 목표에 불필요하므로 제거) ---
    // public List<User> searchUsers(String keyword) { ... }
}