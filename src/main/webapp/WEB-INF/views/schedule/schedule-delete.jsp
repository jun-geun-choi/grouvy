<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@include file="../common/taglib.jsp" %>
<%--<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>--%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>일정 일괄 삭제</title>
  <%@include file="../common/head.jsp" %>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css?family=Noto+Sans+KR:400,700&display=swap" rel="stylesheet">
  <style>
    body {
      margin: 0;
      font-family: 'Noto Sans KR', Arial, sans-serif;
      background: linear-gradient(120deg, #f8fafc 0%, #f1f5f9 100%);
      color: #222b3a;
      padding-top: 80px;
    }
    .navbar-brand {
      color: #e6002d !important;
      font-size: 1.6rem;
      letter-spacing: 1px;
    }
    .nav-item {
      padding-right: 1.2rem;
    }
    .navbar-nav .nav-link.active {
      font-weight: bold;
      color: #e6002d !important;
      /*border-bottom: 2.5px solid #e6002d;
      background: rgba(230,0,45,0.07);
      border-radius: 0 0 8px 8px;
      transition: background 0.2s;*/
    }
    .navbar-nav .nav-link {
      transition: background 0.2s, color 0.2s;
      border-radius: 0 0 8px 8px;
    }
    .navbar-nav .nav-link:hover {
      background: #fbeaec;
      color: #e6002d !important;
    }
    .logo-img {
      width: 150px;
      height: 44px;
      object-fit: contain;
      object-position: left center;
    }
    .navbar .container-fluid {
      padding-right: 2rem;
    }
    .container {
      display: flex;
      padding: 32px 32px 24px 32px;
      gap: 32px;
    }
    .sidebar {
      width: 250px;
      background: #fff;
      border-radius: 18px;
      padding: 22px 18px 18px 18px;
      margin-right: 0;
      box-shadow: 0 4px 24px 0 rgba(30,34,90,0.07), 0 1.5px 6px 0 rgba(30,34,90,0.04);
      color: #222;
      min-width: 220px;
    }
    .sidebar .register-btn {
      margin: 0 0 18px 0;
      padding: 10px 0;
      background: linear-gradient(90deg, #e6002d 60%, #ff5a36 100%);
      color: #fff;
      border: none;
      border-radius: 8px;
      font-size: 1.08em;
      font-weight: bold;
      cursor: pointer;
      width: 100%;
      box-shadow: 0 2px 8px 0 rgba(230,0,45,0.08);
      transition: background 0.2s;
    }
    .sidebar .register-btn:hover {
      background: linear-gradient(90deg, #ff5a36 0%, #e6002d 100%);
    }
    .sidebar-section-title {
      font-size: 1.08em;
      margin-bottom: 10px;
      color: #e6002d;
      font-weight: bold;
      letter-spacing: 0.5px;
    }
    .sidebar-list {
      list-style: none;
      padding: 0;
      margin: 0;
    }
    .sidebar-list li {
      background: #f7f8fa;
      margin-bottom: 8px;
      padding: 10px 12px;
      border-radius: 7px;
      font-size: 1.01em;
      display: flex;
      align-items: center;
      cursor: pointer;
      transition: background 0.18s, color 0.18s;
      color: #222b3a;
      font-weight: 500;
      border: 1.5px solid transparent;
    }
    .sidebar-list li:hover {
      background: #fbeaec;
      color: #e6002d;
      border: 1.5px solid #ffe5ea;
    }
    .sidebar-list li .icon {
      margin-right: 10px;
      font-size: 1.18em;
    }
    hr {
      margin: 20px 0 18px 0;
      border: none;
      border-top: 1.5px solid #f0f1f3;
    }
    .main-content {
      flex: 1;
      background: #fff;
      border-radius: 18px;
      box-shadow: 0 4px 24px 0 rgba(30,34,90,0.07), 0 1.5px 6px 0 rgba(30,34,90,0.04);
      padding: 36px 40px 32px 40px;
      min-height: 700px;
      display: flex;
      flex-direction: column;
    }
    /* 일정 일괄삭제 전용 스타일 */
    .bulkdel-box {
      background: #fff;
      border: 1.5px solid #e3e5e8;
      border-radius: 10px;
      padding: 24px 24px 18px 24px;
      min-width: 420px;
      max-width: 900px;
      box-shadow: 0 2px 8px 0 rgba(30,34,90,0.04);
    }
    .bulkdel-title {
      font-size: 1.18em;
      font-weight: bold;
      margin-bottom: 12px;
      color: #222b3a;
    }
    .bulkdel-desc {
      font-size: 1.01em;
      color: #444;
      margin-bottom: 2px;
    }
    .bulkdel-desc .text-danger {
      color: #e6002d;
      font-weight: bold;
    }
    .bulkdel-form-row {
      display: flex;
      align-items: center;
      gap: 18px;
      margin-bottom: 10px;
    }
    .bulkdel-form-row label {
      font-weight: bold;
      color: #222b3a;
      margin-right: 8px;
      min-width: 80px;
    }
    .bulkdel-form-row .form-check-label {
      font-weight: 500;
      margin-right: 18px;
      color: #222b3a;
    }
    .bulkdel-form-row .form-check-input:checked {
      background-color: #e6002d;
      border-color: #e6002d;
    }
    .bulkdel-form-row input[type="date"] {
      border-radius: 7px;
      border: 1.5px solid #e3e5e8;
      font-size: 1.05em;
      padding: 8px 12px;
      background: #fff;
      color: #222b3a;
      min-width: 140px;
      max-width: 180px;
    }
    .bulkdel-form-row input[type="text"] {
      border-radius: 7px;
      border: 1.5px solid #e3e5e8;
      font-size: 1.05em;
      padding: 8px 12px;
      background: #fff;
      color: #222b3a;
      min-width: 180px;
      max-width: 240px;
    }
    .bulkdel-form-row .search-btn {
      background: #fff;
      color: #e6002d;
      border: 1.5px solid #e6002d;
      border-radius: 7px;
      padding: 6px 10px;
      font-size: 1.1em;
      margin-left: 8px;
      transition: background 0.18s, color 0.18s;
    }
    .bulkdel-form-row .search-btn:hover {
      background: #fbeaec;
      color: #e6002d;
    }
    .bulkdel-form-row .bulkdel-btn {
      background: #22304a;
      color: #fff;
      border: none;
      border-radius: 8px;
      padding: 8px 24px;
      font-size: 1.05em;
      font-weight: bold;
      margin-left: 8px;
      transition: background 0.18s;
    }
    .bulkdel-form-row .bulkdel-btn:hover {
      background: #e6002d;
    }
    .bulkdel-table {
      width: 100%;
      border-collapse: collapse;
      background: #fff;
      margin-top: 18px;
    }
    .bulkdel-table th, .bulkdel-table td {
      border: none;
      text-align: center;
      padding: 8px 10px;
      font-size: 1.05em;
    }
    .bulkdel-table th {
      color: #222b3a;
      font-weight: bold;
      background: #f7f8fa;
    }
    .bulkdel-table td {
      color: #222b3a;
      background: #fff;
    }
    .bulkdel-table tr:nth-child(even) td {
      background: #f7f8fa;
    }
    .bulkdel-table .status {
      color: #888;
      font-weight: 500;
    }
    .bulkdel-table .status.done {
      color: #1a9c3c;
      font-weight: bold;
    }
    .bulkdel-table .cancel {
      color: #e6002d;
      cursor: pointer;
      text-decoration: underline;
    }
    .bulkdel-table .cancel:hover {
      color: #b3001b;
    }
    .bulkdel-table-select {
      border-radius: 7px;
      border: 1.5px solid #e3e5e8;
      font-size: 1.05em;
      padding: 4px 8px;
      background: #fff;
      color: #222b3a;
      min-width: 60px;
      max-width: 80px;
    }
    .bulkdel-pagination {
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 4px;
      margin: 12px 0 0 0;
    }
    .bulkdel-pagination button {
      background: #fff;
      border: 1.5px solid #e3e5e8;
      border-radius: 5px;
      color: #222b3a;
      font-size: 1.05em;
      padding: 2px 10px;
      margin: 0 2px;
      transition: background 0.15s;
    }
    .bulkdel-pagination button.active, .bulkdel-pagination button:hover {
      background: #e6002d;
      color: #fff;
      border-color: #e6002d;
    }
    @media (max-width: 900px) {
      .container { flex-direction: column; gap: 0; padding: 12px; }
      .sidebar { width: 100%; height: auto; margin-bottom: 18px; }
      .main-content { margin-left: 0; padding: 18px 8px 18px 8px; }
      .bulkdel-box { padding: 12px 4px 8px 4px; }
    }
  </style>
</head>
<body>
<%@include file="../common/nav.jsp" %>
  <%--<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm fixed-top">
    <div class="container-fluid">
      <a class="navbar-brand d-flex align-items-center" href="index.html">
        <span class="logo-crop">
          <img src="grouvy_logo.jpg" alt="GROUVY 로고" class="logo-img">
        </span>
      </a>
      <ul class="navbar-nav mb-2 mb-lg-0">
        <li class="nav-item"><a class="nav-link" href="#">전자결재</a></li>
        <li class="nav-item"><a class="nav-link" href="#">업무문서함</a></li>
        <li class="nav-item"><a class="nav-link" href="#">업무 관리</a></li>
        <li class="nav-item"><a class="nav-link" href="#">쪽지</a></li>
        <li class="nav-item"><a class="nav-link" href="#">메신저</a></li>
        <li class="nav-item"><a class="nav-link" href="#">조직도</a></li>
        <li class="nav-item"><a class="nav-link active" href="#">일정</a></li>
        <li class="nav-item"><a class="nav-link" href="admin_dashboard.html">관리자</a></li>
      </ul>
      <div class="d-flex align-items-center">
        <a href="mypage.html" >
          <img src="https://search.pstatic.net/sunny/?src=https%3A%2F%2Fs3.orbi.kr%2Fdata%2Ffile%2Funited2%2F6cc64e06aa404ac3a176745b9c1d5bfa.jpeg&type=sc960_832"
              alt="프로필" class="rounded-circle" width="36" height="36">
        </a>
        <a href="mypage.html" class="ms-2 text-decoration-none text-dark">마이페이지</a>
      </div>
    </div>
  </nav>--%>
  <div class="container" style="margin-top:0;">
    <!-- 사이드바 -->
    <nav class="sidebar">
      <button class="register-btn" onclick="location.href='/schedule'">나의 일정</button>
      <div class="sidebar-section">
        <div class="sidebar-section-title">My Team</div>
        <ul class="sidebar-list">
          <li><span class="icon">👥</span><sec:authentication property="principal.user.department.departmentName"  /></li>
        </ul>
        <hr style="margin: 16px 0; border: none; border-top: 1px solid #eee;">
        <div class="sidebar-section-title mt-4">세부메뉴</div>
        <ul class="sidebar-list">
          <li><a href="/schedule-register" style="text-decoration: none;color: inherit;display: block"><span class="icon">📅</span>일정등록</a></li>
          <li><a href="/meetingroom-reservate" style="text-decoration: none;color: inherit"><span class="icon">🏢</span>회의실 예약</a></li>
          <sec:authorize access="hasAnyRole('ROLE_ADMIN')">
          <li><span class="icon">⚙️</span>관리자</li>
          </sec:authorize>
        </ul>
        <sec:authorize access="hasAnyRole('ROLE_ADMIN')">
        <ul class="sidebar-list" style="background:#f7f8fa;border-left:3px solid #e6002d;margin-left:12px;padding-left:12px;margin-top:2px;">
          <li><a href="/meetingroom-register" style="text-decoration: none;color: inherit;display: block"><span class="icon">🗂️</span>회의실 관리</a></li>
          <li><a href="/holiday-manage" style="text-decoration: none;color: inherit;display: block"><span class="icon">🎌</span>휴일관리</a></li>
          <li><a href="/category-manage" style="text-decoration: none;color: inherit;display: block"><span class="icon">🏷️</span>범주관리</a></li>
          <li><a href="/schedule-delete" style="text-decoration: none;color: inherit;display: block"><span class="icon">🗑️</span>일괄삭제</a></li>
        </ul>
        </sec:authorize>
      </div>
    </nav>
    <!-- 메인 컨텐츠 -->
    <div class="main-content">
      <div class="bulkdel-box">
        <div class="bulkdel-title"> 퇴사자 일정 일괄 삭제</div>
        <div class="bulkdel-desc"><span class="text-danger">※ 삭제된 데이터는 복구할 수 없습니다.</span></div>
        <form>

          <div class="bulkdel-form-row">

            <button type="button" onclick="Delete()" class="bulkdel-btn">일괄삭제</button>
          </div>
        </form>
        <table class="bulkdel-table mt-3">
          <thead>
            <tr>
              <th style="width:40px;">번호</th>
              <th style="width:60px;">삭제자</th>
              <th style="width:80px;">삭제 대상</th>
              <th style="width:100px;">삭제일</th>
              <th style="width:80px;">상태</th>
            </tr>
          </thead>
          <tbody>
          <c:forEach var="history" items="${deleteHistoryList }" varStatus="loop">
            <tr>
              <td>${history.deleteId}</td>
              <td>관리자</td>
              <td>전체</td>
              <td>${history.createdDate}</td>
              <td class="status done">삭제 완료</td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
        <div class="bulkdel-pagination">
          <button class="active">&lt;&lt;</button>
          <button class="active">&lt;</button>
          <span>1</span>
          <button class="active">&gt;</button>
          <button class="active">&gt;&gt;</button>
        </div>
      </div>
    </div>
  </div>
  <%@include file="../common/footer.jsp" %>

  <script type="text/javascript">
    function Delete(){
      location.href = `/schedule-deleteaction`;
    }
  </script>
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