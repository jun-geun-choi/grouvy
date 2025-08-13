<%@ page import="com.example.grouvy.schedule.mapper.ScheduleMapper" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@include file="../common/taglib.jsp" %>
<%--<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>--%>
<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>--%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>범주관리</title>
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
    /* 범주관리 전용 스타일 */
    .category-box {
      background: #fff;
      border: 1.5px solid #e3e5e8;
      border-radius: 10px;
      padding: 24px 24px 18px 24px;
      min-width: 420px;
      max-width: 900px;
      box-shadow: 0 2px 8px 0 rgba(30,34,90,0.04);
      display: flex;
      gap: 24px;
    }
    .category-title {
      font-size: 1.18em;
      font-weight: bold;
      margin-bottom: 12px;
      color: #222b3a;
    }
    .category-list-box {
      width: 200px;
      min-width: 120px;
      background: #f7f8fa;
      border-radius: 8px;
      border: 1.5px solid #e3e5e8;
      padding: 12px 0 12px 0;
      display: flex;
      flex-direction: column;
      gap: 0;
      height: 320px;
    }
    .category-list-title {
      font-weight: bold;
      color: #222b3a;
      background: #f1f1f1;
      padding: 8px 16px;
      border-bottom: 1.5px solid #e3e5e8;
      font-size: 1.05em;
      margin-bottom: 0;
    }
    .category-list {
      list-style: none;
      padding: 0 0 0 0;
      margin: 0;
      flex: 1;
      overflow-y: auto;
    }
    .category-list li {
      display: flex;
      align-items: center;
      gap: 8px;
      padding: 7px 16px;
      font-size: 1.05em;
      color: #222b3a;
      cursor: pointer;
      border-left: 5px solid transparent;
      margin-bottom: 2px;
      background: none;
      transition: background 0.15s, border 0.15s;
    }
    .category-list li.selected {
      background: #fbeaec;
      border-left: 5px solid #e6002d;
      color: #e6002d;
    }
    .category-color {
      display: inline-block;
      width: 18px;
      height: 18px;
      border-radius: 4px;
      border: 1.5px solid #e3e5e8;
      margin-right: 4px;
    }
    .category-list-btn {
      margin: 12px 0 0 0;
      width: 100%;
      background: #222b3a;
      color: #fff;
      border-radius: 7px;
      border: none;
      font-weight: bold;
      font-size: 1.05em;
      padding: 8px 0;
      transition: background 0.18s;
    }
    .category-list-btn:hover {
      background: #e6002d;
    }
    .category-form-box {
      flex: 1;
      display: flex;
      flex-direction: column;
      justify-content: flex-start;
      gap: 0;
    }
    .category-form-table {
      width: 100%;
      border-collapse: separate;
      border-spacing: 0 8px;
      margin-bottom: 0;
    }
    .category-form-table th {
      width: 80px;
      text-align: left;
      color: #222b3a;
      font-weight: bold;
      vertical-align: middle;
      background: none;
      font-size: 1.05em;
      padding: 8px 0 8px 0;
    }
    .category-form-table td {
      background: none;
      padding: 8px 0 8px 0;
    }
    .color-palette {
      display: flex;
      gap: 6px;
      margin-bottom: 0;
      margin-top: 2px;
    }
    .color-sample {
      width: 24px;
      height: 24px;
      border-radius: 5px;
      border: 2px solid transparent;
      cursor: pointer;
      display: inline-block;
      transition: border 0.15s;
    }
    .color-sample.selected {
      border: 2px solid #ffa800;
      box-sizing: border-box;
    }
    .category-form-table input[type="text"] {
      border-radius: 7px;
      border: 1.5px solid #e3e5e8;
      font-size: 1.05em;
      padding: 8px 12px;
      background: #fff;
      color: #222b3a;
      width: 100%;
    }
    .category-form-table .form-note {
      color: #e6002d;
      font-size: 0.98em;
      margin-left: 8px;
      font-weight: 500;
    }
    .category-form-btns {
      display: flex;
      justify-content: flex-end;
      gap: 10px;
      margin-top: 18px;
    }
    .category-form-btns button {
      background: #222b3a;
      color: #fff;
      border: none;
      border-radius: 7px;
      padding: 8px 32px;
      font-size: 1.05em;
      font-weight: bold;
      transition: background 0.18s;
    }
    .category-form-btns button.cancel {
      background: #f1f1f1;
      color: #222b3a;
      border: 1.5px solid #e3e5e8;
    }
    .category-form-btns button:hover {
      background: #e6002d;
      color: #fff;
    }
    .category-form-btns button.cancel:hover {
      background: #e0e0e0;
      color: #e6002d;
    }
    @media (max-width: 900px) {
      .container { flex-direction: column; gap: 0; padding: 12px; }
      .sidebar { width: 100%; height: auto; margin-bottom: 18px; }
      .main-content { margin-left: 0; padding: 18px 8px 18px 8px; }
      .category-box { flex-direction: column; gap: 12px; }
      .category-list-box { width: 100%; min-width: 0; }
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
      <div class="category-title mb-2">범주관리</div>
      <div class="category-box">
        <!-- 범주 목록 -->
        <div class="category-list-box">
          <div class="category-list-title">범주목록</div>
          <c:forEach var="category" items="${categories }" varStatus="loop">
          <ul class="category-list">
            <li onclick="change('${category.categoryTitle}', '${category.categoryColor}', '${category.categoryId}')"><span class="category-color" style="background:${category.categoryColor};"></span>${category.categoryTitle}</li>
          </ul>
          </c:forEach>
          <button class="category-list-btn">등록</button>
        </div>
        <!-- 범주 폼 -->
        <div class="category-form-box">
          <form:form action="/category-manage" method="post" modelAttribute="CategoryUpdateForm">

          <table class="category-form-table">
            <tr>
              <th>색상</th>
              <td>
                <%--<div class="color-palette">
                  <span onclick='select()' class="color-sample" style="background:#e9e9e9;"></span>
                  <span class="color-sample" style="background:#dbe3ea;"></span>
                  <span class="color-sample" style="background:#bfcbe3;"></span>
                  <span class="color-sample" style="background:#b6b6e2;"></span>
                  <span class="color-sample" style="background:#bdb7e6;"></span>
                  <span class="color-sample" style="background:#b7b7d6;"></span>
                  <span class="color-sample" style="background:#b7c7e6;"></span>
                  <span class="color-sample" style="background:#b7e6d6;"></span>
                  <span class="color-sample" style="background:#b7e6b7;"></span>
                  <span class="color-sample" style="background:#d6e6b7;"></span>
                  <span class="color-sample" style="background:#e6e6b7;"></span>
                  <span class="color-sample" style="background:#ffe08c;"></span>
                  <span class="color-sample" style="background:#ffc14a;"></span>
                  <span class="color-sample" style="background:#8fd3e8;"></span>
                  <span class="color-sample" style="background:#ffb7b7;"></span>
                </div>--%>
                <form:input path="categoryColor" type="color" id="myColor" value="#dbe3ea" />
                <form:input path="categoryId" type="hidden" id="CID" value="1"/>
              </td>
            </tr>

            <tr>
              <th>범주명</th>
              <td>
                <input type="text" class="form-control" id="box1" value="개인일정" style="max-width:320px;display:inline-block;" disabled>
                <span class="form-note">※ 수정 불가</span>
              </td>
            </tr>
          </table>
          <div class="category-form-btns mt-3">
            <button type="submit">저장</button>
            <button type="button" class="cancel">취소</button>
          </div>
            </form:form>
        </div>
      </div>
    </div>
  </div>
<%@include file="../common/footer.jsp" %>
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script type="text/javascript">

  function change(a, b, c){
    // alert(a);
    $("#box1").val(a);
    $("#myColor").val(b);
    $("#CID").val(c);
    /*if($(".color-sample").style == "background:#b7c7e6;"){
      $(".color-sample").addClass("selected");
    }*/
  };

  function select(){
    $('.color-sample').addClass("selected");
  };

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