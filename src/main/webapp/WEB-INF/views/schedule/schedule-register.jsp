<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>일정 등록</title>
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
      border-bottom: 2.5px solid #e6002d;
      background: rgba(230,0,45,0.07);
      border-radius: 0 0 8px 8px;
      transition: background 0.2s;
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
    .form-title {
      font-size: 1.5em;
      font-weight: bold;
      color: #222b3a;
      margin-bottom: 28px;
      letter-spacing: 0.5px;
    }
    .form-label {
      font-weight: bold;
      color: #e6002d;
      margin-bottom: 6px;
    }
    .form-section {
      margin-bottom: 18px;
    }
    .form-control, .form-select {
      border-radius: 8px;
      border: 1.5px solid #e3e5e8;
      font-size: 1.08em;
      padding: 10px 14px;
      background: #f7f8fa;
      color: #222b3a;
      margin-bottom: 0;
    }
    .form-check-input:checked {
      background-color: #e6002d;
      border-color: #e6002d;
    }
    .form-check-label {
      margin-right: 18px;
      font-weight: 500;
      color: #222b3a;
    }
    .btn-room {
      background: #fff;
      color: #e6002d;
      border: 1.5px solid #e6002d;
      border-radius: 7px;
      padding: 6px 18px;
      font-size: 1em;
      font-weight: 500;
      margin-left: 8px;
      transition: background 0.18s, color 0.18s;
    }
    .btn-room:hover {
      background: #fbeaec;
      color: #e6002d;
    }
    .btn-search {
      background: #fff;
      color: #e6002d;
      border: 1.5px solid #e6002d;
      border-radius: 7px;
      padding: 6px 10px;
      font-size: 1.1em;
      margin-left: 8px;
      transition: background 0.18s, color 0.18s;
    }
    .btn-search:hover {
      background: #fbeaec;
      color: #e6002d;
    }
    .form-actions {
      display: flex;
      justify-content: flex-end;
      gap: 16px;
      margin-top: 24px;
    }
    .btn-save {
      background: #22304a;
      color: #fff;
      border: none;
      border-radius: 8px;
      padding: 10px 36px;
      font-size: 1.1em;
      font-weight: bold;
      transition: background 0.18s;
    }
    .btn-save:hover {
      background: #e6002d;
    }
    .btn-cancel {
      background: #f1f1f1;
      color: #222b3a;
      border: none;
      border-radius: 8px;
      padding: 10px 28px;
      font-size: 1.1em;
      font-weight: bold;
      transition: background 0.18s;
    }
    .btn-cancel:hover {
      background: #e0e0e0;
    }
    @media (max-width: 900px) {
      .container { flex-direction: column; gap: 0; padding: 12px; }
      .sidebar { width: 100%; height: auto; margin-bottom: 18px; }
      .main-content { margin-left: 0; padding: 18px 8px 18px 8px; }
    }
  </style>
</head>
<body>
  <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm fixed-top">
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
  </nav>
  <div class="container" style="margin-top:0;">
    <!-- 사이드바 -->
    <nav class="sidebar">
      <button class="register-btn">일정등록</button>
      <div class="sidebar-section">
        <div class="sidebar-section-title">My Team</div>
        <ul class="sidebar-list">
          <li><span class="icon">👥</span>영업팀</li>
        </ul>
        <hr style="margin: 16px 0; border: none; border-top: 1px solid #eee;">
        <div class="sidebar-section-title mt-4">세부메뉴</div>
        <ul class="sidebar-list">
          <li><span class="icon">📅</span>일정등록</li>
          <li><span class="icon">🏢</span>회의실 예약</li>
          <li><span class="icon">⚙️</span>관리자</li>
        </ul>
        <ul class="sidebar-list" style="background:#f7f8fa;border-left:3px solid #e6002d;margin-left:12px;padding-left:12px;margin-top:2px;">
          <li><span class="icon">🗂️</span>회의실 관리</li>
          <li><span class="icon">🎌</span>휴일관리</li>
          <li><span class="icon">🏷️</span>범주관리</li>
          <li><span class="icon">🗑️</span>일괄삭제</li>
        </ul>
      </div>
    </nav>
    <!-- 메인 컨텐츠 -->
    <div class="main-content">
      <div class="form-title">일정등록</div>
      <form:form action="/schedule-register" method="post"
        modelAttribute="ScheduleRegisterForm">
        <sec:csrfInput/>
        <div class="form-section row align-items-center mb-3">
          <label class="form-label col-2">기간</label>
          <div class="col-10 d-flex flex-wrap align-items-center gap-2">
            <form:input path="scheduleStarttime" type="datetime-local" class="form-control" style="width: 160px;"/>
            <span style="margin: 0 8px;">~</span>
            <form:input path="scheduleEndtime" type="datetime-local" class="form-control" style="width: 160px;"/>
            <div class="form-check ms-3">
              <input class="form-check-input" type="checkbox" id="allDay">
              <label class="form-check-label" for="allDay">종일</label>
            </div>
            <div class="form-check ms-3">
              <input class="form-check-input" type="checkbox" id="repeat">
              <label class="form-check-label" for="repeat">반복</label>
            </div>
          </div>
        </div>
        <div class="form-section row align-items-center mb-3">
          <label class="form-label col-2">유형</label>
          <div class="col-10 d-flex align-items-center gap-3">
            <div class="form-check">
              <form:radiobutton path="categoryId" class="form-check-input" value="1" name="type" id="type1" checked="checked"/>
              <label class="form-check-label" for="type1">개인일정</label>
            </div>
            <div class="form-check">
              <form:radiobutton path="categoryId" class="form-check-input" value="2" name="type" id="type2"/>
              <label class="form-check-label" for="type2">부서일정</label>
            </div>
            <div class="form-check">
              <form:radiobutton path="categoryId" class="form-check-input" value="3" name="type" id="type3"/>
              <label class="form-check-label" for="type3">회사일정</label>
            </div>
          </div>
        </div>
        <div class="form-section row align-items-center mb-3">
          <label class="form-label col-2">제목</label>
          <div class="col-10">
            <form:input path="scheduleTitle" type="text" class="form-control" placeholder="제목" />
            <form:errors path="scheduleTitle" cssClass="text-danger"/>
          </div>
        </div>
        <div class="form-section row align-items-center mb-3">
          <label class="form-label col-2">장소</label>
          <div class="col-10">
            <form:input path="scheduleLocation" type="text" class="form-control" placeholder="장소"/>
          </div>
        </div>
        <div class="form-section row align-items-center mb-3">
          <label class="form-label col-2">회의실</label>
          <div class="col-10 d-flex align-items-center">
            <button type="button" class="btn-room">회의실 예약</button>
          </div>
        </div>
        <div class="form-section row align-items-center mb-3">
          <label class="form-label col-2">참여자</label>
          <div class="col-10 d-flex align-items-center">
            <input type="text" class="form-control" placeholder="사용자" style="max-width: 200px;">
            <button type="button" class="btn-search"><span style="font-size:1.1em;">🔍</span></button>
          </div>
        </div>
        <div class="form-section row mb-3">
          <label class="form-label col-2">내용</label>
          <div class="col-10">
             <%--<textarea class="form-control" rows="5" placeholder="내용"></textarea>--%>
               <form:textarea path="scheduleContent" type="text" class="form-control" rows="5" placeholder="내용"/>
          </div>
        </div>
        <div class="form-section row align-items-center mb-3">
          <label class="form-label col-2">파일 업로드</label>
          <div class="col-10 d-flex align-items-center gap-2">
            <input type="file" class="form-control" style="max-width: 200px;">
            <span style="color:#888;">선택된 파일 없음</span>
          </div>
        </div>
        <div class="form-actions">
          <button type="submit" class="btn-save">저장</button>
          <button type="button" class="btn-cancel">취소</button>
        </div>
      </form:form>
    </div>
  </div>
</body>
</html> 