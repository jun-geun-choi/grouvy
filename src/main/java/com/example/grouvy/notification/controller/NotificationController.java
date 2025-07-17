// src/main/java/com/example/grouvy/notification/controller/NotificationController.java
package com.example.grouvy.notification.controller;

import com.example.grouvy.user.vo.User; // User VO 임포트
import jakarta.servlet.http.HttpSession; // HttpSession 임포트
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequiredArgsConstructor
@RequestMapping("/notification") // 알림 관련 뷰의 기본 경로
public class NotificationController {

    // NotificationService나 다른 서비스는 직접 주입받지 않습니다.
    // 이 컨트롤러는 단순히 JSP 뷰를 반환하는 역할만 합니다.
    // 데이터 로딩은 JSP 내부의 JavaScript가 REST API를 통해 수행합니다.

    /**
     * 알림 목록 페이지를 반환합니다.
     * @param model JSP로 데이터를 전달하기 위한 Model 객체
     * @param session 현재 HTTP 세션 (사용자 ID 확인용)
     * @return "notification/notification_list" JSP 뷰의 이름을 반환합니다.
     */
    @GetMapping("/list")
    public String getNotifications(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("selectedUser");
        if (currentUser == null || currentUser.getUserId() == null) {
            model.addAttribute("errorMessage", "알림 목록을 보려면 발신자를 먼저 선택해주세요. (조직도에서 사용자 클릭)");
        }
        model.addAttribute("currentPage", "notificationList"); // 사이드바 활성화를 위한 값 (향후 사이드바에 알림 메뉴 추가 시)
        return "notification/notification_list";
    }
}