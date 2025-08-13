<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>로그인 기록 관리</title>
  <%@include file="../../common/head.jsp" %>
  <c:url var="adminCss" value="/resources/css/user/admin_main.css"/>
  <link href="${adminCss}" rel="stylesheet"/>
  <style>
  .login-badge {
  padding: 6px 12px;
  font-size: 13px;
  border-radius: 30px;
  font-weight: 500;
  display: inline-block;
  text-align: center;
  min-width: 70px;
  box-shadow: 0 0 4px rgba(0, 0, 0, 0.05);
  transition: all 0.2s ease-in-out;
}

.login-badge.login {
  background-color: #e8f5e9;
  color: #2e7d32;
  border: 1px solid #c8e6c9;
}

.login-badge.logout {
  background-color: #ffebee;
  color: #c62828;
  border: 1px solid #ffcdd2;
}
.table th, .table td {
  padding-left: 15px;
}
.status-cell {
  text-align: center;
  vertical-align: middle;
}

</style>
</head>
<body>
<%@include file="../../common/nav.jsp" %>
<%@include file="../admin_nav.jsp" %>
<div class="container">
  <%@include file="admin_user_sidebar.jsp" %>
  <div class="main-content">
    <h2>접속/로그인 기록 관리</h2>
    <table class="table table-bordered align-middle">
      <thead class="table-light">
      <tr>
        <th>사원명</th>
        <th>사원번호</th>
        <th>이메일</th>
        <th>최근 로그인 시각</th>
        <th>IP</th>
        <th>로그인 상태</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach var="loginHistory" items="${loginHistories }" varStatus="loop">
        <tr>
          <td>${loginHistory.user.name}</td>
          <td>${loginHistory.user.employeeNo}</td>
          <td>${loginHistory.user.email}</td>
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
