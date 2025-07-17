<%-- src/main/webapp/WEB-INF/views/admin/index.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 대시보드</title>
    <%-- admin_top.jsp에서 CSS를 가져오므로 여기서는 공통 CSS 제거 --%>
</head>
<body>
<%-- currentPage 변수를 설정하여 사이드바에서 현재 페이지를 활성화 --%>
<c:set var="currentPage" value="adminHome" scope="request"/>

<%-- admin_top.jsp를 import하여 공통 상단 내비게이션 사용 --%>
<c:import url="/WEB-INF/views/common/admin_top.jsp" />

<div class="container">
    <div class="sidebar">
        <h3>관리 기능</h3>
        <ul>
            <li><a href="/admin" class="${currentPage == 'adminHome' ? 'active' : ''}">대시보드</a></li>
            <li><a href="/admin/departments/list" class="${currentPage == 'departmentList' ? 'active' : ''}">부서 관리</a></li>
            <li><a href="/admin/departments/history" class="${currentPage == 'departmentHistory' ? 'active' : ''}">부서 이력</a></li>
            <%-- 사용자 관리 (영역 외) --%>
            <%-- <li><a href="/admin/users/list" class="${currentPage == 'userList' ? 'active' : ''}">사용자 관리</a></li> --%>
        </ul>
    </div>

    <div class="main-content">
        <h1>관리자 대시보드</h1>
        <%-- 'selectedUser' 세션 유무로 환영 메시지 판단 --%>
        <c:if test="${not empty sessionScope.selectedUser}">
            <p>안녕하세요, ${sessionScope.selectedUser.name} (${sessionScope.selectedUser.userId}) 관리자님!</p>
        </c:if>
        <c:if test="${empty sessionScope.selectedUser}">
            <p>관리자 페이지입니다. 로그인해주세요.</p>
        </c:if>

        <div class="card">
            <h4>사용자 현황</h4>
            <p>관리자 페이지에 오신 것을 환영합니다. 좌측 메뉴를 통해 부서를 관리할 수 있습니다.</p>
        </div>

        <div class="card">
            <h4>최근 활동</h4>
            <p>부서 정보 변경 이력, 사용자 로그인 기록 등을 확인하세요.</p>
        </div>

        <div class="card">
            <h4>시스템 알림</h4>
            <p>정기 점검 또는 업데이트 예정 공지사항</p>
        </div>

    </div>
</div>

<footer> © 2025 그룹웨어 Corp. </footer>
<%-- admin_top.jsp에서 bootstrap.bundle.min.js가 포함되었으므로 여기서는 제거 --%>
</body>
</html>