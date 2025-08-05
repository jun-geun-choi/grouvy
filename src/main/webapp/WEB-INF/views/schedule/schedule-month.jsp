<%@ page import="com.example.grouvy.schedule.mapper.ScheduleMapper" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>일정 관리 - 캘린더</title>
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
    .calendar-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 22px;
    }
    .calendar-header .nav-btns {
      display: flex;
      gap: 10px;
    }
    .calendar-header .nav-btns button {
      background: linear-gradient(90deg, #e6002d 60%, #ff5a36 100%);
      color: #fff;
      border: none;
      border-radius: 7px;
      padding: 7px 20px;
      font-size: 1em;
      font-weight: bold;
      cursor: pointer;
      margin-right: 2px;
      box-shadow: 0 2px 8px 0 rgba(230,0,45,0.08);
      transition: background 0.2s;
    }
    .calendar-header .nav-btns button:hover {
      background: linear-gradient(90deg, #ff5a36 0%, #e6002d 100%);
    }
    .calendar-header .calendar-title {
      font-size: 1.5em;
      font-weight: bold;
      color: #222b3a;
      letter-spacing: 0.5px;
    }
    .calendar-header .view-btns {
      display: flex;
      gap: 10px;
    }
    .calendar-header .view-btns button {
      background: #f7f8fa;
      color: #222b3a;
      border: none;
      border-radius: 7px;
      padding: 7px 16px;
      font-size: 1em;
      font-weight: 500;
      cursor: pointer;
      transition: background 0.18s, color 0.18s;
    }
    .calendar-header .view-btns button.active, .calendar-header .view-btns button:hover {
      background: #e6002d;
      color: #fff;
    }
    .calendar-table {
      width: 100%;
      border-collapse: separate;
      border-spacing: 0 2px;
      background: #fff;
      border-radius: 12px;
      overflow: hidden;
      box-shadow: 0 2px 8px rgba(0,0,0,0.04);
    }
    .calendar-table th, .calendar-table td {
      width: 14.28%;
      height: 90px;
      text-align: left;
      vertical-align: top;
      border: 1.5px solid #f0f1f3;
      padding: 8px 10px;
      position: relative;
      font-size: 1.04em;
      background: #fff;
    }
    .calendar-table th {
      background: #f7f8fa;
      color: #e6002d;
      font-weight: bold;
      text-align: center;
      height: 38px;
      font-size: 1.08em;
      letter-spacing: 0.5px;
    }
    .calendar-table td.sat {
      background: #f3f6fd;
      color: #4e6bb3;
    }
    .calendar-table td.sun {
      background: #fdf3f3;
      color: #e57373;
    }
    .calendar-table td.today {
      background: #fffde7;
      border: 2px solid #ffe082;
    }
    .calendar-table .event {
      display: block;
      margin-top: 10px;
      padding: 4px 12px;
      border-radius: 6px;
      font-size: 1em;
      color: #fff;
      background: linear-gradient(90deg, #b39ddb 60%, #9575cd 100%);
      width: fit-content;
      font-weight: 500;
      box-shadow: 0 1px 4px 0 rgba(179,157,219,0.08);
    }
    .calendar-table .event2 {
      background: linear-gradient(90deg, #80cbc4 60%, #4db6ac 100%);
      color: #222b3a;
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
        <li class="nav-item"><a class="nav-link" href="#">조직도 ${holiday.holidayTitle }</a></li>
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
      <!-- 달력 헤더 -->

      <!-- 달력 테이블 -->
      <div id='calendar'></div>
    </div>
  </div>

</body>
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.18/index.global.min.js'></script>
<script>

  // const data = [{
  //   allDay:false,
  //   color:"skyblue",
  //   display:"block",
  //   start:"2025-07-02",
  //   description:"refresh test1",
  //   end:"2025-07-04",
  //   title:"테스트"
  // }];

  const data = ${scheduleJson};
  console.log(data);
  // var jsonData = JSON.stringify(data);
  // var word1 = str.substring(0, str.indexOf(','));



  document.addEventListener('DOMContentLoaded', function() {
    var calendarEl = document.getElementById('calendar');
    var calendar = new FullCalendar.Calendar(calendarEl, {
      initialView: 'dayGridMonth',
      events:data,
      eventClick: function(info){
        alert('제목' + info.event.title);
      },
      headerToolbar: {
        start: 'dayGridMonth,timeGridWeek', // headerToolbar에 버튼 추가
        center: 'title',
        end: 'today prev,next'  // 스페이스-버튼띄움 ,-붙여서 생성
      }


  });

    calendar.render();
  });




</script>
</html> 