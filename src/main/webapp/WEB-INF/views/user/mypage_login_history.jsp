<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인 기록</title>
    <%@include file="../common/head.jsp" %>
    <c:url var="mypageCss" value="/resources/css/user/mypage_profile.css"/>
    <link href="${mypageCss}" rel="stylesheet"/>

</head>
<body>
<%@include file="../common/nav.jsp" %>
<div class="container">
    <!-- 좌측 nav -->
    <div class="sidebar">
        <h3>마이페이지</h3>
        <ul>
            <li><a href="/mypage/profile">개인 정보</a></li>
            <li><a href="/mypage/attendance">근태 관리</a></li>
            <li><a href="/mypage/login-history">로그인 기록</a></li>
<%--            <li><a href="/mypage/setting">페이지 설정</a></li>--%>
        </ul>
    </div>
    <div class="main-content">
        <h2>접속/로그인 기록</h2>
        <table class="table table-bordered align-middle">
            <thead class="table-light">
            <tr>
                <th>최근 로그인 시각</th>
                <th>IP</th>
                <th>로그인 상태</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="loginHistory" items="${loginHistories }" varStatus="loop">
                <tr>
                    <td><fmt:formatDate value="${loginHistory.loginTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                    <td>${loginHistory.ipAddress}</td>
                    <td class="status-cell">
                        <c:choose>
                            <c:when test="${loginHistory.loginStatus eq 'login'}">
                                <span class="login-badge login">로그인</span>
                            </c:when>
                            <c:otherwise>
                                <span class="login-badge logout">로그아웃</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
            <!-- 추가 행 -->
            </tbody>
        </table>
    </div>
</div>
<%@include file="../common/footer.jsp" %>
<%@include file="../chat/chatNotice.jsp" %>
<script src="<c:url value="/resources/js/chat/chatNoticeSocket.js"/>"></script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
<script>
    // 최초 연결
    connectNoticeSocket();
</script>
<%-- 얘는 메신저 알림을 받기 위한, 설정 정보들 입니다. --%>
</body>
</html>
