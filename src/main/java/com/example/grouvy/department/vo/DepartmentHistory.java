// src/main/java/com/example/grouvy/department/vo/DepartmentHistory.java
package com.example.grouvy.department.vo; // 새 패키지 경로

import lombok.Getter;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
public class DepartmentHistory {
    private Long historyId; // HISTORY_ID (NUMBER(6) -> Long) - 이력 고유 ID
    private Long departmentId; // DEPARTMENT_ID (NUMBER(6) -> Long) - 변경된 부서의 ID
    private String changeType; // CHANGE_TYPE (VARCHAR2(20) -> String) - 변경 타입 (CREATE, UPDATE, DELETE)
    private String oldValue; // OLD_VALUE (CLOB -> String) - 변경 전 데이터 (JSON 형태)
    private String newValue; // NEW_VALUE (CLOB -> String) - 변경 후 데이터 (JSON 형태)
    private Long changerUserId; // CHANGER_USER_ID (NUMBER(6) -> Long) - 변경을 수행한 사용자 ID
    private Date changeDate; // CHANGE_DATE (DATE -> java.util.Date) - 변경 일시

    // 조인해서 가져올 추가 정보 (이력 조회 시 유저 이름, 부서 이름 표시용)
    private String departmentName; // 부서 이름 (GROUVY_DEPARTMENTS.DEPARTMENT_NAME)
    private String changerUserName; // 변경을 수행한 사용자 이름 (GROUVY_USERS.NAME)
}