// src/main/java/com/example/grouvy/user/mapper/UserMapper.java
package com.example.grouvy.user.mapper; // 새 패키지 경로

import com.example.grouvy.user.vo.User; // User VO의 새 경로
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param; // @Param 어노테이션을 사용하기 위해 임포트

import java.util.List;

@Mapper // 이 인터페이스가 MyBatis의 Mapper임을 Spring에게 알립니다.
public interface UserMapper {

    // 1. 특정 사용자 ID로 사용자 정보를 조회하는 메서드
    // 로그인 기능은 현재 사용하지 않지만, 다른 기능(예: 쪽지 발신자 정보 표시)에서
    // USER_ID를 통해 사용자 정보를 가져올 수 있도록 유지합니다.
    // 파라미터 타입이 Long으로 변경되었음을 주의합니다.
    User findByUserId(@Param("userId") Long userId);

    // 2. 특정 부서 ID에 소속된 사용자 목록을 조회하는 메서드 (조직도 표시용)
    // 파라미터 이름을 새로운 스키마 컬럼명에 맞춰 departmentId로 변경합니다.
    List<User> findUsersByDeptId(@Param("departmentId") Long departmentId);

    // 3. 특정 사용자 ID로 사용자 이름(NAME)만 조회하는 메서드
    // 메시지나 알림 등에서 발신자의 이름만 필요한 경우 사용됩니다.
    // 파라미터 타입이 Long으로 변경되었음을 주의합니다.
    String findUserNmByUserId(@Param("userId") Long userId);

    // 4. 특정 사용자 ID로 해당 사용자의 역할(ROLE_NAME) 목록을 조회하는 메서드
    // GROUVY_USER_ROLES 테이블과 연동됩니다. (나중에 Security 활성화 시 사용될 수 있습니다.)
    List<String> findRolesByUserId(@Param("userId") Long userId);


    List<User> searchUsers(@Param("keyword") String keyword);
}