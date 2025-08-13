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
  <title>회의실 예약</title>
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
    
    /* 회의실 예약 전용 스타일 */
    .meetingroom-title {
      font-size: 1.25em;
      font-weight: bold;
      color: #222b3a;
      margin-bottom: 18px;
      letter-spacing: 0.5px;
    }
    .meetingroom-wrap {
      background: #f7f8fa;
      border-radius: 10px;
      border: 1.5px solid #e3e5e8;
      padding: 24px 18px 18px 18px;
      display: flex;
      gap: 18px;
      min-height: 540px;
    }
    .meetingroom-list {
      width: 260px;
      min-width: 180px;
      background: #fff;
      border-radius: 8px;
      border: 1.5px solid #e3e5e8;
      padding: 18px 10px 18px 10px;
      display: flex;
      flex-direction: column;
      gap: 8px;
    }
    .meetingroom-list-title {
      font-weight: bold;
      color: #e6002d;
      margin-bottom: 10px;
      font-size: 1.08em;
    }
    .meetingroom-list ul {
      list-style: none;
      padding: 0;
      margin: 0 0 12px 0;
    }
    .meetingroom-list li {
      padding: 6px 0 6px 8px;
      border-left: 3px solid #e6002d;
      margin-bottom: 2px;
      background: none;
      color: #222b3a;
      font-size: 1em;
      cursor: pointer;
      transition: background 0.15s;
    }
    .meetingroom-list li.selected {
      background: #fbeaec;
      color: #e6002d;
    }
    .meetingroom-list li:hover {
      background: #fbeaec;
      color: #e6002d;
    }
    
    .meetingroom-info-container {
      flex: 1;
      background: #fff;
      border-radius: 12px;
      border: 1.5px solid #e3e5e8;
      overflow: hidden;
      height: 100%;
      display: flex;
      flex-direction: column;
    }
    .meetingroom-info-header {
      background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
      padding: 24px 28px 20px 28px;
      border-bottom: 1.5px solid #e3e5e8;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .meetingroom-info-title {
      font-size: 1.4em;
      font-weight: bold;
      color: #222b3a;
      margin: 0;
      letter-spacing: 0.5px;
    }
    .meetingroom-status {
      display: flex;
      gap: 8px;
    }
    .status-badge {
      padding: 6px 12px;
      border-radius: 20px;
      font-size: 0.9em;
      font-weight: bold;
      letter-spacing: 0.3px;
    }
    .status-available {
      background: linear-gradient(90deg, #28a745 0%, #20c997 100%);
      color: #fff;
    }
    .status-occupied {
      background: linear-gradient(90deg, #e6002d 0%, #ff5a36 100%);
      color: #fff;
    }
    .status-maintenance {
      background: #ffc107;
      color: #222b3a;
    }
    
    .meetingroom-info-content {
      flex: 1;
      padding: 28px;
      display: flex;
      flex-direction: column;
      gap: 24px;
    }
    .meetingroom-info-section {
      display: flex;
      flex-direction: column;
      gap: 16px;
    }
    .info-item {
      display: flex;
      align-items: flex-start;
      gap: 16px;
      padding: 12px 0;
      border-bottom: 1px solid #f0f1f3;
    }
    .info-item:last-child {
      border-bottom: none;
    }
    .info-label {
      min-width: 120px;
      font-weight: bold;
      color: #e6002d;
      font-size: 1.02em;
      letter-spacing: 0.3px;
    }
    .info-value {
      flex: 1;
      color: #222b3a;
      font-size: 1.02em;
      line-height: 1.5;
    }
    
    /* 예약 관련 스타일 */
    .reservation-section {
      background: #f7f8fa;
      border-radius: 8px;
      padding: 20px;
      margin-top: 20px;
    }
    .reservation-title {
      font-size: 1.1em;
      font-weight: bold;
      color: #222b3a;
      margin-bottom: 16px;
    }
    .date-picker {
      margin-bottom: 20px;
    }
    .date-picker input {
      padding: 8px 12px;
      border: 1px solid #ddd;
      border-radius: 6px;
      font-size: 1em;
    }
    .time-slots {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
      gap: 8px;
      margin-bottom: 20px;
    }
    .time-slot {
      padding: 8px 12px;
      border: 1px solid #ddd;
      border-radius: 6px;
      text-align: center;
      cursor: pointer;
      transition: all 0.2s;
      font-size: 0.9em;
    }
    .time-slot.available {
      background: #fff;
      color: #28a745;
      border-color: #28a745;
    }
    .time-slot.available:hover {
      background: #28a745;
      color: #fff;
    }
    .time-slot.occupied {
      background: #f8f9fa;
      color: #6c757d;
      border-color: #dee2e6;
      cursor: not-allowed;
    }
    .time-slot.selected {
      background: #e6002d;
      color: #fff;
      border-color: #e6002d;
    }
    .reserve-btn {
      background: linear-gradient(90deg, #e6002d 0%, #ff5a36 100%);
      color: #fff;
      border: none;
      border-radius: 8px;
      padding: 12px 24px;
      font-size: 1.1em;
      font-weight: bold;
      cursor: pointer;
      transition: all 0.2s;
      width: 100%;
    }
    .reserve-btn:hover {
      background: linear-gradient(90deg, #ff5a36 0%, #e6002d 100%);
      transform: translateY(-1px);
    }
    .reserve-btn:disabled {
      background: #6c757d;
      cursor: not-allowed;
      transform: none;
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
      max-width: 500px;
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
    .form-group {
      margin-bottom: 20px;
    }
    .form-label {
      display: block;
      margin-bottom: 8px;
      font-weight: bold;
      color: #222b3a;
    }
    .form-control {
      width: 100%;
      padding: 10px 12px;
      border: 1px solid #ddd;
      border-radius: 6px;
      font-size: 1em;
      transition: border-color 0.2s;
    }
    .form-control:focus {
      outline: none;
      border-color: #e6002d;
      box-shadow: 0 0 0 2px rgba(230, 0, 45, 0.1);
    }
    .form-row {
      display: flex;
      gap: 12px;
    }
    .form-row .form-group {
      flex: 1;
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
    .btn-primary {
      background: linear-gradient(90deg, #e6002d 0%, #ff5a36 100%);
      color: #fff;
    }
    .btn-primary:hover {
      background: linear-gradient(90deg, #ff5a36 0%, #e6002d 100%);
      transform: translateY(-1px);
    }
    .btn-secondary {
      background: #f7f8fa;
      color: #666;
      border: 1px solid #ddd;
    }
    .btn-secondary:hover {
      background: #e0e0e0;
      color: #222b3a;
    }
    
    @media (max-width: 900px) {
      .container { flex-direction: column; gap: 0; padding: 12px; }
      .sidebar { width: 100%; height: auto; margin-bottom: 18px; }
      .main-content { margin-left: 0; padding: 18px 8px 18px 8px; }
      .meetingroom-wrap { flex-direction: column; gap: 12px; }
      .meetingroom-list { width: 100%; min-width: 0; }
      .meetingroom-info-header {
        padding: 18px 20px 16px 20px;
        flex-direction: column;
        align-items: flex-start;
        gap: 12px;
      }
      .meetingroom-info-content {
        padding: 20px;
      }
      .info-item {
        flex-direction: column;
        gap: 8px;
      }
      .info-label {
        min-width: auto;
      }
      .time-slots {
        grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
      }
      .form-row {
        flex-direction: column;
      }
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
      <div class="meetingroom-title">회의실 예약</div>
      <div class="meetingroom-wrap">
        <!-- 회의실 목록 -->
        <div class="meetingroom-list">
          <div class="meetingroom-list-title">회의실 목록</div>
          <ul>
            <c:forEach var="conferenceRoom" items="${conferenceRoomList }" varStatus="loop">
                  <li onclick="change('${conferenceRoom.conferenceRoomTitle}', '${conferenceRoom.conferenceRoomLocation}', '${conferenceRoom.conferenceRoomExplanation}', '${conferenceRoom.conferenceRoomLimit}', '${conferenceRoom.conferenceRoomEquipment}', '${conferenceRoom.conferenceRoomId}')">${conferenceRoom.conferenceRoomTitle}</li>
              </c:forEach>
          </ul>
        </div>
        <!-- 회의실 정보 및 예약 -->
        <div class="meetingroom-info-container">
          <div class="meetingroom-info-header">
            <input type="text" class="form-control" id="box1" value="회의실을 선택하세요!" style="border: none; background: transparent;" disabled>
            <div class="meetingroom-status">
              <span class="status-badge status-available" id="roomStatus">사용가능</span>
            </div>
          </div>
          <div class="meetingroom-info-content">
              <div class="meetingroom-info-section">
                  <div class="info-item">
                      <div class="info-label">📍 위치</div>
                      <%--<div class="info-value">${conferenceRoomList[0].conferenceRoomLocation}</div>--%>
                      <input type="text" class="form-control" id="box2" value="회의실을 선택하세요!" style="border: none; background: transparent;" disabled>
                  </div>
                  <div class="info-item">
                      <div class="info-label">📝 설명</div>
                      <input type="text" class="form-control" id="box3" value="회의실을 선택하세요!" style="border: none; background: transparent;" disabled>
                  </div>
                  <div class="info-item">
                      <div class="info-label">👥 수용인원</div>
                      <input type="text" class="form-control" id="box4" value="회의실을 선택하세요!" style="border: none; background: transparent;" disabled>
                  </div>
                  <div class="info-item">
                      <div class="info-label">🖥️ 설치기자재</div>
                      <input type="text" class="form-control" id="box5" value="회의실을 선택하세요!" style="border: none; background: transparent;" disabled>
                  </div>
              </div>
            
            <!-- 예약 섹션 -->
            <div class="reservation-section">
              <div class="reservation-title">📅 예약일정 조회</div>
              <input type="text" class="form-control" id="xb" value="-" style="border: none; background: transparent;" disabled>
              <div class="date-picker">
                <label class="form-label">날짜 선택</label>
                <input type="date" id="reservationDate" onchange="loadReservation(this.value, document.getElementById('box6').value)">
              </div>
              <div class="time-slots" id="timeSlots">
                <!-- 시간대가 여기에 동적으로 로드됩니다 -->
              </div>
              <button class="reserve-btn" id="reserveBtn" onclick="openReservationModal()">예약하기</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- 예약 모달 -->
  <div class="modal-overlay" id="reservationModal">
    <div class="modal-content">
      <div class="modal-header">
        <h3 class="modal-title">회의실 예약</h3>
        <button class="close-btn" onclick="closeReservationModal()">&times;</button>
      </div>
      <sec:authentication property="principal.user.userId" var="userId"  />
      <form:form action="/meetingroom-reservate" method="post" modelAttribute="MeetingReservateForm">
        <div class="form-group">
          <label class="form-label">회의실명</label>
          <input type="text" class="form-control" id="box7" readonly>
        </div>
        <div class="form-row">
          <div class="form-group">
            <label class="form-label">예약 시작시간</label>
            <form:input path="reservationStarttime" type="datetime-local" class="form-control" />
          </div>
          <div class="form-group">
            <label class="form-label">예약 마감시간</label>
            <form:input path="reservationEndtime" type="datetime-local" class="form-control" />
          </div>
        </div>
        <div class="form-group">
          <label class="form-label">예약날짜</label>
          <form:input path="userId" type="hidden" id="userId" class="form-control" value="${userId}" />
          <form:input path="reservationDate" type="date" class="form-control" />
        </div>
        <div class="form-group">
          <%--<label class="form-label">회의실 아이디</label>--%>
          <form:input path="conferenceRoomId" type="hidden" id="box6" class="form-control" />
        </div>
        <%--<div class="form-group">
          <label class="form-label">회의 제목</label>
          <input type="text" class="form-control" id="meetingTitle" placeholder="회의 제목을 입력하세요" required>
        </div>
        <div class="form-group">
          <label class="form-label">참가자</label>
          <input type="text" class="form-control" id="participants" placeholder="참가자명을 입력하세요 (쉼표로 구분)">
        </div>
        <div class="form-group">
          <label class="form-label">회의 내용</label>
          <textarea class="form-control" id="meetingContent" rows="3" placeholder="회의 내용을 입력하세요"></textarea>
        </div>--%>
        <div class="modal-actions">
          <button type="button" class="action-btn btn-secondary" onclick="closeReservationModal()">취소</button>
          <button type="submit" class="action-btn btn-primary">예약하기</button>
        </div>
      </form:form>
    </div>
  </div>

  <script>


    // 예약 모달 열기
    function openReservationModal() {
      
      document.getElementById('reservationModal').style.display = 'flex';
    }

    // 예약 모달 닫기
    function closeReservationModal() {
      document.getElementById('reservationModal').style.display = 'none';
      document.getElementById('reservationForm').reset();
    }


    // 모달 외부 클릭 시 닫기
    document.getElementById('reservationModal').addEventListener('click', function(e) {
      if (e.target === this) {
        closeReservationModal();
      }
    });

    // ESC 키로 모달 닫기
    document.addEventListener('keydown', function(e) {
      if (e.key === 'Escape') {
        closeReservationModal();
      }
    });

    // 페이지 로드 시 초기화
    document.addEventListener('DOMContentLoaded', function() {
      // 오늘 날짜를 기본값으로 설정
      const today = new Date().toISOString().split('T')[0];
      document.getElementById('reservationDate').value = today;
      
      // 초기 시간대 로드
      loadTimeSlots();
    });
  </script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script type="text/javascript">

    function change(a, b, c, d, e, f){
        $("#box1").val(a);
        $("#box2").val(b);
        $("#box3").val(c);
        $("#box4").val(d);
        $("#box5").val(e);
        $("#box6").val(f);
        $("#box7").val(a);
        $(this).addClass("selected");
    };

  function select(){
    $('.color-sample').addClass("selected");
  };

  function loadReservation(date, a) {

    const data = [{
      start: "2025-07-02",
      title: "테스트"
    },
      {
        start: "2025-07-10",
        title: "fdd"
      },
      {
        start: "2025-07-02",
        title: "fddsfef"
      }];
    console.log(date);

    const real = ${reservationJson};

    const datee = date;

    const aa = a;

    console.log(aa);

    const filterdata = real.filter(start => start.reservationDate === datee);

    const finalfilterdata = filterdata.filter(start => start.conferenceRoomId === aa);

    console.log(finalfilterdata);

    if(finalfilterdata.length == 0 ){
      alert('예약내역이 없습니다.')
    } else{
      let wnd = window.open("", "new window", "width=500,height=700");
      for(let index in finalfilterdata){
        wnd.document.write(finalfilterdata[index].reservationStarttime + '&nbsp;' + finalfilterdata[index].reservationEndtime + '<br>');
        // document.write(filterdata[index].title + '<br');
        //console.log(filterdata[index].title + filterdata[index].start);
      }
    }


    $("#xb").val(filterdata[0].title);


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