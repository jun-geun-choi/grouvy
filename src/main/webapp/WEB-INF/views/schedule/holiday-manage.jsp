<%@ page import="com.example.grouvy.schedule.mapper.ScheduleMapper" %>
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
  <title>휴일 관리</title>
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
    /* 휴일 관리 테이블 스타일 */
    .holiday-box {
      background: #fff;
      border: 1.5px solid #e3e5e8;
      border-radius: 10px;
      padding: 24px 24px 18px 24px;
      margin-bottom: 32px;
      min-width: 420px;
      max-width: 700px;
      box-shadow: 0 2px 8px 0 rgba(30,34,90,0.04);
    }
    .holiday-title {
      font-size: 1.18em;
      font-weight: bold;
      margin-bottom: 12px;
      color: #222b3a;
    }
    .holiday-table {
      width: 100%;
      border-collapse: collapse;
      background: #fff;
      margin-bottom: 12px;
    }
    .holiday-table th, .holiday-table td {
      border: none;
      text-align: left;
      padding: 8px 10px;
      font-size: 1.05em;
    }
    .holiday-table th {
      color: #e6002d;
      font-weight: bold;
      background: #fff;
      text-align: center;
    }
    .holiday-table td {
      color: #222b3a;
      background: #fff;
      text-align: center;
    }
    .holiday-table tr:nth-child(even) td {
      background: #f7f8fa;
    }
    .holiday-table input[type="checkbox"] {
      accent-color: #e6002d;
      width: 18px;
      height: 18px;
    }
    .holiday-btns {
      display: flex;
      justify-content: flex-end;
      gap: 10px;
      margin-top: 8px;
    }
    .holiday-btns button {
      background: #f1f1f1;
      color: #222b3a;
      border: none;
      border-radius: 7px;
      padding: 8px 24px;
      font-size: 1.05em;
      font-weight: bold;
      transition: background 0.18s;
    }
    .holiday-btns button:hover {
      background: #e6002d;
      color: #fff;
    }
    /* 휴일 등록/수정 모달 */
    .modal-content {
      border-radius: 12px;
      overflow: hidden;
      min-width: 420px;
      background: #f7f8fa;
    }
    .modal-body {
      padding: 32px 32px 24px 32px;
    }
    .holiday-modal-form-table {
      width: 100%;
      border-collapse: separate;
      border-spacing: 0 8px;
      margin-bottom: 0;
    }
    .holiday-modal-form-table th {
      width: 120px;
      text-align: left;
      color: #e6002d;
      font-weight: bold;
      vertical-align: middle;
      background: none;
      font-size: 1.05em;
      padding: 8px 0 8px 0;
    }
    .holiday-modal-form-table td {
      background: none;
      padding: 8px 0 8px 0;
    }
    .holiday-modal-form-table input[type="text"],
    .holiday-modal-form-table input[type="date"] {
      border-radius: 7px;
      border: 1.5px solid #e3e5e8;
      font-size: 1.05em;
      padding: 8px 12px;
      background: #fff;
      color: #222b3a;
      width: 100%;
    }
    .holiday-modal-form-table input[type="date"] {
      min-width: 140px;
      max-width: 180px;
    }
    .holiday-modal-form-table .form-check {
      margin-right: 18px;
      display: inline-block;
    }
    .holiday-modal-form-table .form-check-input:checked {
      background-color: #e6002d;
      border-color: #e6002d;
    }
    .holiday-modal-form-table .form-check-label {
      font-weight: 500;
      color: #222b3a;
      margin-right: 8px;
    }
    .modal-footer {
      display: flex;
      justify-content: flex-end;
      gap: 12px;
      margin-top: 24px;
      background: none;
      border: none;
      padding: 0;
    }
    .modal-footer button {
      min-width: 90px;
      font-weight: bold;
      font-size: 1.05em;
    }
    @media (max-width: 900px) {
      .container { flex-direction: column; gap: 0; padding: 12px; }
      .sidebar { width: 100%; height: auto; margin-bottom: 18px; }
      .main-content { margin-left: 0; padding: 18px 8px 18px 8px; }
      .holiday-box { padding: 12px 4px 8px 4px; }
      .modal-content { min-width: 0; }
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
      <div class="holiday-box">
        <div class="holiday-title">휴일 관리</div>
        <table class="holiday-table">
          <thead>
            <tr>
              <th style="width:40px;"><input type="checkbox"></th>
              <th>휴일명</th>
              <th>휴일</th>
              <th>매년반복여부</th>
            </tr>
          </thead>
          <tbody>
          <c:forEach var="holiday" items="${holidayList }" varStatus="loop">
            <tr>
              <td><input type="checkbox" id="${holiday.holidayId}" name="check" value="${holiday.holidayId}"></td>
               <%--<td><form:checkbox path="holidayId" class="form-check-input" value="${holiday.holidayId}" name="type"/></td>--%>
              <td>${holiday.holidayTitle}</td>
              <td>${holiday.holidayDate.getMonth() + 1}.${holiday.holidayDate.getDate()}</td>
              <td>매년 반복</td>
            </tr>

          </c:forEach>

          </tbody>
        </table>
        <div class="holiday-btns">
          <button type="button" id="openHolidayModalBtn">등록</button>
          <button type="button" onclick="HolidayDelete()">삭제</button>
        </div>
      </div>
      <!-- 휴일 등록/수정 모달 -->
      <div class="modal fade" id="holidayModal" tabindex="-1" aria-hidden="true" style="display:none;">
        <div class="modal-dialog modal-dialog-centered">
          <div class="modal-content">
            <div class="modal-body">
              <div class="holiday-title mb-3">휴일 관리</div>
              <form:form action="/holiday-manage" method="post" modelAttribute="HolidayRegisterForm">
                <sec:csrfInput/>
                <table class="holiday-modal-form-table">
                  <tr>
                    <th>매년반복여부</th>
                    <td>
                      <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="repeatType" id="repeatY" checked>
                        <label class="form-check-label" for="repeatY">매년 반복</label>
                      </div>
                      <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="repeatType" id="repeatN">
                        <label class="form-check-label" for="repeatN">반복 없음</label>
                      </div>
                    </td>
                  </tr>
                  <tr>
                    <th class="text-danger">* 휴일명</th>
                    <td><form:input path="holidayTitle" type="text" class="form-control" value="크리스마스"/></td>
                  </tr>
                  <tr>
                    <th class="text-danger">* 휴일</th>
                    <td><form:input path="holidayDate" type="date" class="form-control" value="2015-12-25"/></td>
                  </tr>
                </table>
                <div class="modal-footer">
                  <button type="submit" class="btn btn-primary" id="holidayModalSaveBtn">저장</button>
                  <button type="button" class="btn btn-secondary" id="holidayModalCancelBtn">목록</button>
                </div>
              </form:form>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <%@include file="../common/footer.jsp" %>
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <script type="text/javascript">
    // 휴일 등록 모달 열기/닫기
    const openHolidayModalBtn = document.getElementById('openHolidayModalBtn');
    const holidayModal = document.getElementById('holidayModal');
    const holidayModalCancelBtn = document.getElementById('holidayModalCancelBtn');
    const holidayModalSaveBtn = document.getElementById('holidayModalSaveBtn');

    openHolidayModalBtn.addEventListener('click', function() {
      holidayModal.style.display = 'block';
      holidayModal.classList.add('show');
      document.body.style.overflow = 'hidden';
    });
    function closeHolidayModal() {
      holidayModal.style.display = 'none';
      holidayModal.classList.remove('show');
      document.body.style.overflow = '';
    }
    holidayModalCancelBtn.addEventListener('click', closeHolidayModal);
    holidayModalSaveBtn.addEventListener('click', closeHolidayModal);
    // 바깥 클릭 시 닫기
    holidayModal.addEventListener('mousedown', function(e) {
      if (e.target === holidayModal) closeHolidayModal();
    });

    function HolidayDelete(){
      $('input:checkbox[name=check]').each(function (index) {
        if($(this).is(":checked")==true){
          let value = ($(this).val());
          console.log(value)
          location.href = `/holiday-delete?no=`+value;
        }
      })

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