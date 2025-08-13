<%@ page import="com.example.grouvy.schedule.mapper.ScheduleMapper" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@include file="../common/taglib.jsp" %>
<%--<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>--%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>일정 관리 - 캘린더</title>
  <%@include file="../common/head.jsp" %>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css?family=Noto+Sans+KR:400,700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="/resources/css/schedule/fullcalendar.css">
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
      width: 160px;
      height: 50px;
      object-fit: cover;
      object-position: center;
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
      background: linear-gradient(90deg, #1abc8d 0%, #1abc9c 100%);
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
      background: #e0f7f4;
      color: #1abc9c;
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
      cursor: pointer;
      transition: transform 0.2s, box-shadow 0.2s;
    }
    .calendar-table .event:hover {
      transform: translateY(-1px);
      box-shadow: 0 3px 8px 0 rgba(179,157,219,0.15);
    }
    .calendar-table .event2 {
      background: linear-gradient(90deg, #80cbc4 60%, #4db6ac 100%);
      color: #222b3a;
    }


    /* 모달 스타일 */
    .modal-overlay {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(0, 0, 0, 0.5);
      display: none;
      justify-content: center;
      align-items: center;
      z-index: 1000;
    }

    .modal-content {
      background: #fff;
      border-radius: 18px;
      padding: 32px;
      width: 90%;
      max-width: 600px;
      max-height: 80vh;
      overflow-y: auto;
      box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
      position: relative;
    }

    .modal-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 24px;
      padding-bottom: 16px;
      border-bottom: 2px solid #f0f1f3;
    }

    .modal-title {
      font-size: 1.5em;
      font-weight: bold;
      color: #222b3a;
    }

    .close-btn {
      background: none;
      border: none;
      font-size: 1.5em;
      cursor: pointer;
      color: #666;
      padding: 0;
      width: 30px;
      height: 30px;
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 50%;
      transition: background 0.2s;
    }

    .close-btn:hover {
      background: #f0f1f3;
      color: #222b3a;
    }

    .schedule-info {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 20px;
      margin-bottom: 24px;
    }

    .info-item {
      display: flex;
      flex-direction: column;
    }

    .info-label {
      font-size: 0.9em;
      color: #666;
      margin-bottom: 6px;
      font-weight: 500;
    }

    .info-value {
      font-size: 1.1em;
      color: #222b3a;
      font-weight: 500;
      padding: 8px 12px;
      background: #f7f8fa;
      border-radius: 8px;
      border: 1px solid #e0e0e0;
    }

    .info-item.full-width {
      grid-column: 1 / -1;
    }

    .modal-actions {
      display: flex;
      gap: 12px;
      justify-content: flex-end;
      margin-top: 24px;
      padding-top: 20px;
      border-top: 2px solid #f0f1f3;
    }

    .action-btn {
      padding: 10px 20px;
      border: none;
      border-radius: 8px;
      font-size: 1em;
      font-weight: 500;
      cursor: pointer;
      transition: all 0.2s;
    }

    .edit-btn {
      background: linear-gradient(90deg, #e6002d 60%, #ff5a36 100%);
      color: #fff;
    }

    .edit-btn:hover {
      background: linear-gradient(90deg, #ff5a36 0%, #e6002d 100%);
      transform: translateY(-1px);
    }

    .delete-btn {
      background: #f7f8fa;
      color: #e6002d;
      border: 1px solid #e6002d;
    }

    .delete-btn:hover {
      background: #e6002d;
      color: #fff;
    }

    .cancel-btn {
      background: #f7f8fa;
      color: #666;
      border: 1px solid #ddd;
    }

    .cancel-btn:hover {
      background: #e0e0e0;
      color: #222b3a;
    }



    @media (max-width: 900px) {
      .container { flex-direction: column; gap: 0; padding: 12px; }
      .sidebar { width: 100%; height: auto; margin-bottom: 18px; }
      .main-content { margin-left: 0; padding: 18px 8px 18px 8px; }
      .schedule-info { grid-template-columns: 1fr; }
      .modal-content { width: 95%; padding: 20px; }
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
      <!-- 달력 헤더 -->

      <!-- 달력 테이블 -->
      <div id='calendar'></div>
    </div>
  </div>


<!-- 일정 상세 모달 -->
<div class="modal-overlay" id="scheduleModal" tabindex="-1" style="display:none;">
  <div class="modal-content">
    <div class="modal-header">
      <h3 class="modal-title">일정 상세</h3>
      <button class="close-btn" onclick="closeScheduleModal()">&times;</button>
    </div>
    <div class="schedule-info">
      <div class="info-item">
        <div class="info-label">스케줄명</div>
        <div class="info-value" id="scheduleName">-</div>
      </div>
      <div class="info-item">
        <div class="info-label">분류</div>
        <div class="info-value" id="scheduleCategory">-</div>
      </div>
      <div class="info-item">
        <div class="info-label">시작일</div>
        <div class="info-value" id="startDate">-</div>
      </div>
      <div class="info-item">
        <div class="info-label">종료일</div>
        <div class="info-value" id="endDate">-</div>
      </div>
      <%--<div class="info-item">
        <div class="info-label">등록일</div>
        <div class="info-value" id="registerDate">-</div>
      </div>--%>
      <div class="info-item" style="display: none">
        <div class="info-label">참가자</div>
        <div class="info-value" id="scheduleId">-</div>
      </div>
      <input type="hidden" class="form-control" id="scheduleId" value="0" style="border: none; background: transparent;" disabled>
      <input type="hidden" class="form-control" id="userId" value="0" style="border: none; background: transparent;" disabled>
      <sec:authentication property="principal.user.userId" var="userId"  />
      <div class="info-item">
        <div class="info-label">위치</div>
        <div class="info-value" id="location">-</div>
      </div>
      <div class="info-item full-width">
        <div class="info-label">내용</div>
        <div class="info-value" id="content">-</div>
      </div>
    </div>
    <div class="modal-actions">
      <button class="action-btn cancel-btn" onclick="closeScheduleModal()">닫기</button>
      <button class="action-btn delete-btn" onclick="deleteSchedule()">삭제</button>
      <%--<button class="action-btn edit-btn" onclick="editSchedule()">수정</button>--%>
    </div>
  </div>
</div>

<script>
  /*function openScheduleModal(name, startDate, endDate, registerDate, title, participants, location, content, category) {
    document.getElementById('scheduleName').textContent = name;
    document.getElementById('startDate').textContent = startDate;
    document.getElementById('endDate').textContent = endDate;
    document.getElementById('registerDate').textContent = registerDate;
    document.getElementById('participants').textContent = participants;
    document.getElementById('location').textContent = location;
    document.getElementById('content').textContent = content;
    document.getElementById('scheduleCategory').textContent = category;

    //document.getElementById('scheduleModal').style.display = 'flex';
  }*/

  function closeScheduleModal() {
    document.getElementById('scheduleModal').style.display = 'none';
  }

  function editSchedule() {
    // 수정 기능 구현
    alert('수정 기능이 구현될 예정입니다.');
  }

  function deleteSchedule() {
    // 삭제 기능 구현
    if (confirm('정말로 이 일정을 삭제하시겠습니까?')) {
      //alert('삭제 기능이 구현될 예정입니다.');
      const value1 = document.getElementById('userId');
      let id = parseInt(value1.value);
      let id2 = parseInt(${userId});
      console.log(id, id2);
      const value = document.getElementById('scheduleId');
      if (id == id2){
        let number = parseInt(value.value);
        location.href = `/scheduleId-delete?no=`+ number;
      } else{
        alert("자신이 등록한 일정만 삭제할 수 있습니다.");
      }
      closeScheduleModal();
    }
  }

  // 모달 외부 클릭 시 닫기
  document.getElementById('scheduleModal').addEventListener('click', function(e) {
    if (e.target === this) {
      closeScheduleModal();
    }
  });

  // ESC 키로 모달 닫기
  document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
      closeScheduleModal();
    }
  });
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
<%@include file="../common/footer.jsp" %>
<script src='https://cdn.jsdelivr.net/npm/rrule@2.6.4/dist/es5/rrule.min.js'></script>
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.18/index.global.min.js'></script>
<script src='https://cdn.jsdelivr.net/npm/@fullcalendar/rrule@6.1.18/index.global.min.js'></script>
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

  function dateFormat(date) {
    let dateFormat2 = date.getFullYear() +
            '-' + ( (date.getMonth()+1) < 9 ? "0" + (date.getMonth()+1) : (date.getMonth()+1) )+
            '-' + ( (date.getDate()) < 9 ? "0" + (date.getDate()) : (date.getDate()) );
    return dateFormat2;
  }


  const ttt = [
  <c:forEach var="holiday" items="${holidayList }" varStatus="loop">
    <fmt:formatDate value="${holiday.holidayDate}" pattern="yyyy-MM-dd" var="realDate"/>
    {
      "title": '${holiday.holidayTitle}',
      "rrule": {
        "freq": 'yearly',
        "interval": 1,
        // "dtstart": '2000-0${holiday.holidayDate.getMonth()+1}-0${holiday.holidayDate.getDate()}',
        "dtstart": '${realDate}',
        "until": '2085-06-01'
      }
    },
  </c:forEach>
  ];


  const realevent = [
  <c:forEach var="schedule" items="${scheduleJson }" varStatus="loop">
    {
      title: '${schedule.title}',
      start: '${schedule.start}',
      end: '${schedule.end}',
      color: '${schedule.color}',
      extendedProps: {
        categoryName: '${schedule.categoryName}',
        content: '${schedule.extendedProps}',
        location: '${schedule.location}',
        id: ${schedule.scheduleId},
        userId: ${schedule.userId}
      }
    },
    </c:forEach>
  ];

  // const tmpd =
  //   [{
  //     "title": 'my recurring event',
  //     "rrule": {
  //       "freq": 'YEARLY',
  //       "interval": 1,
  //       // byweekday: [ 'mo', 'fr' ],
  //       "dtstart": '2025-02-01', // will also accept '20120201T103000'
  //       "until": '2025-06-01' // will also accept '20120201'
  //     }
  //   }];






  //const data = ${scheduleJson};
  console.log(realevent);
  //console.log(data);
  console.log(ttt);
  // var jsonData = JSON.stringify(data);
  // var word1 = str.substring(0, str.indexOf(','));



  document.addEventListener('DOMContentLoaded', function() {
    var calendarEl = document.getElementById('calendar');
    var calendar = new FullCalendar.Calendar(calendarEl, {
      initialView: 'dayGridMonth',
      titleFormat: function (date) {
        year = date.date.year;
        month = date.date.month + 1;

        return year + "년 " + month + "월";
      },
      //eventSources: [ {events:data}, ttt],
      eventSources: [ {events:realevent}, ttt],
      // events:
      //         data,
      //eventClick: function(info){
      //  alert('제목' + info.event.title);
      //},
      eventClick: function(info){
        document.getElementById('scheduleModal').style.display = 'flex';
        document.getElementById('scheduleName').textContent = info.event.title;
        document.getElementById('startDate').textContent = info.event.start;
        document.getElementById('endDate').textContent = info.event.end;
        document.getElementById('userId').value = info.event.extendedProps.userId;
        document.getElementById('scheduleId').value = info.event.extendedProps.id;
        document.getElementById('location').textContent = info.event.extendedProps.location;
        document.getElementById('content').textContent = info.event.extendedProps.content;
        document.getElementById('scheduleCategory').textContent = info.event.extendedProps.categoryName;
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