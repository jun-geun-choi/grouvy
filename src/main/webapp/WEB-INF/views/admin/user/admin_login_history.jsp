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
</head>
<body>
<%@include file="../../common/nav.jsp" %>
<nav class="navbarr">
  <a href="#">전자결재</a>
  <a href="#">업무관리</a>
  <a href="#">업무문서함</a>
  <a href="#">조직도</a>
</nav>
<div class="container">
  <div class="sidebar">
    <h3>관리 기능</h3>
    <ul>
      <li><a href="/admin/user/approval">회원가입 승인</a> </li>
      <li><a href="/admin/user/list">사용자 계정관리</a> </li>
      <li><a href="/admin/user/login-history">로그인 기록</a> </li>
      <li><a href="/admin/user/attendance-history" class="active">출퇴근 기록</a></li>
    </ul>
  </div>
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
        <th>비정상 로그인</th>
      </tr>
      </thead>
      <tbody>
      <tr>
        <td>홍길순</td>
        <td>20250001</td>
        <td>hongsoon@email.com</td>
        <td>2025-07-07 09:12:33</td>
        <td>192.168.0.10</td>
        <td><span class="badge bg-danger">탐지</span></td>
      </tr>
      <tr>
        <td>김철수</td>
        <td>20250002</td>
        <td>kimcs@email.com</td>
        <td>2025-07-07 08:55:10</td>
        <td>192.168.0.11</td>
        <td><span class="badge bg-success">정상</span></td>
      </tr>
      <!-- 추가 행 -->
      </tbody>
    </table>
  </div>
</div>
<%@include file="../../common/footer.jsp" %>
</body>
</html>
