<%-- /src/main/webapp/WEB-INF/views/common/top.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- Spring Security 태그 라이브러리는 현재 사용하지 않으므로, 추후에 다시 추가할 것. --%>
<%-- <%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %> --%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>그룹웨어 상단 메뉴</title>
    <link rel="icon" href="/img/favicon.png" type="image/png">
    <link rel="icon" href="/favicon.ico" type="image/x-icon">
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
            rel="stylesheet">
    <style>
        /* 이 스타일은 각 JSP 파일의 <head> 안에 포함되어야 합니다. */
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #f7f7f7; /* body 배경색 일관성 유지 */
            color: #333;
        }

        /* 로고 이미지 및 테두리 */
        .logo-img {
            width: 160px;
            height: 50px;
            object-fit: contain; /* 이미지 비율 유지 */
            object-position: center;
        }

        .logo-crop { /* 현재 top.jsp에서 사용되지 않음 */
            border: 1px solid #e6002d;
            padding: 2px 5px;
            display: inline-block;
            line-height: 1;
        }

        .navbar .container-fluid {
            padding-right: 2rem;
            padding-left: 2rem; /* 좌우 여백 */
        }

        /* 메인 내비게이션 링크 스타일 */
        .navbar-nav .nav-link {
            color: #333; /* 기본 글씨색 */
            text-decoration: none;
            padding: 0.5rem 1rem; /* 링크 간 간격 */
            transition: color 0.2s ease-in-out;
        }

        /* 활성 링크 하이라이트 */
        .navbar-nav .nav-link.highlight {
            font-weight: bold;
            color: #e6002d !important; /* 빨간색 */
        }

        /* top.jsp에서는 sidebar와 main-content를 직접 사용하지 않지만,
           이 CSS 블록은 다른 JSP 파일에 복사될 것이므로 포함합니다. */
        .container {
            display: flex;
            padding: 20px;
            max-width: 1200px; /* 전체 컨테이너 너비 제한 (일관성 유지) */
            margin: 20px auto; /* 중앙 정렬 */
        }

        .sidebar {
            width: 200px;
            background-color: white;
            border-radius: 8px; /* 통일된 border-radius */
            padding: 15px;
            margin-right: 20px;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
        }

        .sidebar h3 {
            margin-top: 0;
            font-size: 16px;
            border-bottom: 1px solid #ddd;
            padding-bottom: 10px;
        }

        .sidebar ul {
            list-style: none;
            padding: 0;
        }

        .sidebar ul li {
            margin: 10px 0;
        }

        .sidebar ul li a {
            color: #333;
            text-decoration: none;
        }

        .sidebar ul li a.active, .sidebar ul li a:hover {
            color: #1abc9c;
            font-weight: bold;
        }

        .main-content {
            flex: 1;
            background-color: white;
            border-radius: 8px; /* 통일된 border-radius */
            padding: 20px; /* 통일된 padding */
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
            /* text-align: center; 등은 각 페이지에서 필요시 추가 */
            /* img, input[type="password"], div, button 관련 스타일은 top.jsp에서는 제거 */
        }

        /* 알림 깜빡임 애니메이션을 위한 CSS */
        @keyframes colorBlink {
            0%, 100% { background-color: transparent; }
            50% { background-color: rgba(255, 0, 0, 0.2); }
        }
        .blink-animation {
            animation: colorBlink 0.8s ease-in-out;
        }
    </style>
</head>
<body>
<%--
    이 파일은 다른 JSP 페이지에 <nav> 태그부터 하단 <script> 태그까지의 내용이
    직접 복사/붙여넣기되어 사용될 예정입니다.
    각 JSP 파일의 <body> 바로 뒤에 <c:set var="currentPage" ... /> 를 정의하여
    현재 페이지에 맞는 메뉴가 하이라이트되도록 합니다.
    예시: <c:set var="currentPage" value="home" scope="request"/>
--%>

<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
    <div class="container-fluid">
        <%-- 로고 --%>
        <a class="navbar-brand d-flex align-items-center p-0" href="/">
            <img src="/img/grouvy_logo.png" alt="GROUVY 로고" class="logo-img"> <%-- 이미지 경로 수정 --%>
        </a>

        <%-- 메인 내비게이션 메뉴 (중앙 정렬) --%>
        <div class="d-flex flex-grow-1 justify-content-center">
            <ul class="navbar-nav mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link" href="#">전자결재</a></li>
                <li class="nav-item"><a class="nav-link" href="#">업무문서함</a></li>
                <li class="nav-item"><a class="nav-link" href="#">업무 관리</a></li>
                <li class="nav-item">
                    <%-- 'message' 도메인 내의 모든 쪽지 페이지는 'message'로 묶어 highlight --%>
                    <a class="nav-link ${currentPage == 'message' || currentPage == 'inbox' || currentPage == 'sentbox' || currentPage == 'important' || currentPage == 'send' || currentPage == 'messageDetail' ? 'highlight' : ''}" href="/message/inbox">쪽지
                        <%-- Spring Security 비활성화 상태이므로, 'selectedUser'가 세션에 있으면 카운트 표시 --%>
                        <c:if test="${not empty sessionScope.selectedUser}">
                            (<span id="unreadMsgCount">0</span>) <%-- 초기값은 JS가 로드 후 업데이트 --%>
                        </c:if>
                    </a>
                </li>
                <li class="nav-item"><a class="nav-link" href="#">메신저</a></li>
                <li class="nav-item">
                    <%-- 'dept' 도메인 내의 모든 조직도 페이지는 'deptChart'로 묶어 highlight --%>
                    <a class="nav-link ${currentPage == 'deptChart' ? 'highlight' : ''}" href="/dept/chart">조직도</a>
                </li>
                <li class="nav-item"><a class="nav-link" href="#">일정</a></li>
                <li class="nav-item">
                    <%-- 'notification' 도메인 내의 알림 페이지는 'notificationList'로 묶어 highlight --%>
                    <a class="nav-link ${currentPage == 'notificationList' ? 'highlight' : ''}" href="/notification/list" id="notificationLink">알림
                        <%-- Spring Security 비활성화 상태이므로, 'selectedUser'가 세션에 있으면 카운트 표시 --%>
                        <c:if test="${not empty sessionScope.selectedUser}">
                            (<span id="unreadNotiCount">0</span>) <%-- 초기값은 JS가 로드 후 업데이트 --%>
                        </c:if>
                    </a>
                </li>
                <%-- 관리자 메뉴: Spring Security 비활성화 상태이므로 항상 표시 --%>
                <li class="nav-item">
                    <a class="nav-link ${currentPage == 'adminHome' || currentPage == 'departmentList' || currentPage == 'departmentHistory' ? 'highlight' : ''}" href="/admin">관리자</a>
                </li>
            </ul>
        </div>

        <%-- 사용자 정보 및 로그인/로그아웃 (우측 정렬) --%>
        <div class="d-flex align-items-center ms-auto">
            <a href="#" class="me-2"> <%-- 마이페이지 프로필 이미지 --%>
                <img src="https://search.pstatic.net/sunny/?src=https%3A%2F%2Fs3.orbi.kr%2Fdata%2Ffile%2Funited2%2F6cc64e06aa404ac3a176745b9c1d5bfa.jpeg&type=sc960_832"
                     alt="프로필" class="rounded-circle" width="36" height="36">
            </a>
            <a href="#" class="ms-2 text-decoration-none text-dark me-3">마이페이지</a>

            <%-- 사용자 이름 및 로그인/로그아웃: selectedUser 여부로 판단 --%>
            <div class="d-flex align-items-center">
                <c:if test="${not empty sessionScope.selectedUser}">
                    <span class="text-dark me-2">${sessionScope.selectedUser.name} (${sessionScope.selectedUser.userId})님</span>
                    <a href="#" class="btn btn-sm btn-outline-secondary" id="logoutBtn">로그아웃</a> <%-- JS로 로그아웃 처리 --%>
                </c:if>
                <c:if test="${empty sessionScope.selectedUser}">
                    <a href="/login" class="btn btn-sm btn-outline-primary">로그인</a>
                </c:if>
            </div>
        </div>
    </div>
</nav>

<%-- SSE 연결 로직 (body 끝에 위치하는 것이 좋습니다. 각 JSP 파일의 </body> 직전에 이 스크립트를 포함해야 합니다.) --%>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        // SSE 연결은 'selectedUser'가 세션에 있는 경우에만 시도
        const selectedUserId = '<c:out value="${sessionScope.selectedUser.userId}"/>'; // String 타입으로 가져옴
        const unreadMessageCountElement = document.getElementById('unreadMsgCount');
        const unreadNotificationCountElement = document.getElementById('unreadNotiCount');
        const notificationLinkElement = document.getElementById("notificationLink");
        const logoutBtn = document.getElementById('logoutBtn');

        let blinkTimeoutId;
        let currentBlinks = 0;
        const MAX_BLINKS = 6; // 깜빡임 횟수
        const BLINK_DURATION = 500; // 0.5초마다 깜빡임

        function applyBlinkAnimation() {
            if (currentBlinks < MAX_BLINKS) {
                notificationLinkElement.classList.toggle('blink-animation');
                void notificationLinkElement.offsetWidth; // 강제로 리플로우 발생시켜 애니메이션 다시 시작
                currentBlinks++;
                blinkTimeoutId = setTimeout(applyBlinkAnimation, BLINK_DURATION);
            } else {
                notificationLinkElement.classList.remove('blink-animation');
                currentBlinks = 0;
            }
        }

        function startBlinkEffect() {
            clearTimeout(blinkTimeoutId);
            notificationLinkElement.classList.remove('blink-animation');
            currentBlinks = 0;
            applyBlinkAnimation();
        }

        // SSE 연결
        if (selectedUserId && selectedUserId !== 'null' && typeof EventSource !== 'undefined' && !window.sseSource) {
            console.log('SSE 연결을 시도합니다. User ID:', selectedUserId);
            const sseSource = new EventSource('/api/v1/notifications/sse/connect');
            window.sseSource = sseSource;

            sseSource.onopen = function (event) {
                console.log('✅ SSE 연결 성공!');
            };

            sseSource.addEventListener("unreadCounts", function (event) {
                const data = JSON.parse(event.data);
                console.log("📊 읽지 않은 카운트 업데이트:", data);
                if (unreadMessageCountElement) {
                    unreadMessageCountElement.textContent = data.unreadMessages || 0;
                }
                if (unreadNotificationCountElement) {
                    unreadNotificationCountElement.textContent = data.unreadNotifications || 0;
                }
            });

            sseSource.addEventListener("notification", function (event) {
                const data = JSON.parse(event.data);
                console.log("🔔 새로운 알림 도착:", data);
                startBlinkEffect();
                // 브라우저 알림 권한 요청 (최초 1회) 및 알림 표시
                if (Notification.permission === 'granted') {
                    new Notification('새로운 알림', {
                        body: data.notificationContent,
                        icon: '/img/notification_icon.png' // 알림 아이콘 경로 (프로젝트에 맞게 수정 필요)
                    }).onclick = function() {
                        window.focus();
                        if (data.targetUrl) {
                            window.location.href = data.targetUrl;
                        }
                        this.close();
                    };
                } else if (Notification.permission !== 'denied') {
                    Notification.requestPermission();
                }
            });

            sseSource.onerror = function (error) {
                console.error('❌ SSE 오류 발생:', error);
                sseSource.close();
                delete window.sseSource;
                // SSE 연결 끊김 메시지 표시 (선택 사항)
                // displayClientMessage('실시간 알림 연결이 끊겼습니다. 페이지 새로고침 시 재연결됩니다.', 'warning');
            };

            sseSource.onmessage = function(event) {
                // 이름 없는 이벤트 (예: 'connect' 메시지)는 여기에 수신됨
                // console.log("SSE 일반 메시지:", event.data);
            };

            // 페이지를 떠날 때 SSE 연결 종료
            window.addEventListener('beforeunload', function() {
                if (window.sseSource) {
                    window.sseSource.close();
                    delete window.sseSource;
                    console.log('SSE 연결 종료');
                }
            });
        } else {
            console.log('SSE 연결 조건 불충족: selectedUser 없음, EventSource 미지원, 또는 이미 연결됨.');
        }

        // 로그아웃 버튼 클릭 이벤트 (세션에서 selectedUser 제거)
        if (logoutBtn) {
            logoutBtn.addEventListener('click', async function(event) {
                event.preventDefault(); // 기본 링크 동작 방지
                if (confirm('로그아웃 하시겠습니까?')) {
                    try {
                        // 세션에서 selectedUser 정보를 제거하는 API 호출
                        const response = await fetch('/api/v1/users/clearSelected', {
                            method: 'GET' // 또는 'POST'
                        });
                        if (response.ok) {
                            console.log('세션 사용자 정보 제거 성공, 로그아웃 처리.');
                            // SSE 연결이 있다면 종료
                            if (window.sseSource) {
                                window.sseSource.close();
                                delete window.sseSource;
                            }
                            window.location.href = '/login'; // 로그인 페이지로 리다이렉트
                        } else {
                            alert('로그아웃 처리 중 오류가 발생했습니다.');
                        }
                    } catch (error) {
                        console.error('로그아웃 중 오류:', error);
                        alert('네트워크 오류로 로그아웃에 실패했습니다.');
                    }
                }
            });
        }
    });
</script>
<%-- 이 파일 자체는<footer>를 포함하지 않습니다. 다른 JSP 파일에서 이 위에 <main>과 푸터를 포함해야 합니다. --%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>