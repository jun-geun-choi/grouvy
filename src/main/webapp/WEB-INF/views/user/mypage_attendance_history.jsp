<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>출근/퇴근 기록</title>
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
        <h2>출근/퇴근 기록</h2>
        <table class="table table-bordered align-middle">
            <thead class="table-light">
            <tr>
                <th>시각</th>
                <th>출근/퇴근</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="attendanceHistory" items="${attendanceHistories }" varStatus="loop">
                <tr>
                    <td><fmt:formatDate value="${attendanceHistory.attendanceDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                    <td>${attendanceHistory.status}</td>
                </tr>
            </c:forEach>
            <!-- 추가 행 -->
            </tbody>
        </table>
    </div>
</div>
<%@include file="../common/footer.jsp" %>
</body>
</html>