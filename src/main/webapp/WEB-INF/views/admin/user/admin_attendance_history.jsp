<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../common/taglib.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>출근/퇴근 기록 관리</title>
    <%@include file="../../common/head.jsp" %>
    <c:url var="adminCss" value="/resources/css/user/admin_main.css"/>
    <link href="${adminCss}" rel="stylesheet"/>
</head>
<body>
<%@include file="../../common/nav.jsp" %>
<%@include file="../admin_nav.jsp" %>
<div class="container">
    <%@include file="admin_user_sidebar.jsp" %>
    <div class="main-content">
        <h2>출근/퇴근 기록 관리</h2>
        <table class="table table-bordered align-middle">
            <thead class="table-light">
            <tr>
                <th>사원명</th>
                <th>사원번호</th>
                <th>부서</th>
                <th>시각</th>
                <th>출근/퇴근</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="attendanceHistory" items="${attendanceHistories }" varStatus="loop">
                <tr>
                    <td>${attendanceHistory.user.name}</td>
                    <td>${attendanceHistory.user.employeeNo}</td>
                    <td>${attendanceHistory.user.department.departmentName}</td>
                    <td><fmt:formatDate value="${attendanceHistory.attendanceDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                    <td>${attendanceHistory.status}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
<%@include file="../../common/footer.jsp" %>
<%@include file="../../chat/chatNotice.jsp" %>
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