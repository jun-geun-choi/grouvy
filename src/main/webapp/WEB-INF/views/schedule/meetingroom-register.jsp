<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>회의실 관리</title>
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
    /* 회의실 관리 전용 스타일 */
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
    .meetingroom-list .register-btn {
      margin-top: 10px;
      width: 100%;
      background: #22304a;
      color: #fff;
      border-radius: 7px;
      border: none;
      font-weight: bold;
      font-size: 1.05em;
      padding: 8px 0;
      transition: background 0.18s;
    }
    .meetingroom-list .register-btn:hover {
      background: #e6002d;
    }
    .meetingroom-table-wrap {
      flex: 1;
      background: #fff;
      border-radius: 8px;
      border: 1.5px solid #e3e5e8;
      padding: 18px 18px 12px 18px;
      display: flex;
      flex-direction: column;
    }
    .meetingroom-table-info {
      color: #888;
      font-size: 0.98em;
      margin-bottom: 8px;
    }
    .meetingroom-table {
      width: 100%;
      border-collapse: collapse;
      background: #fff;
      font-size: 1.04em;
    }
    .meetingroom-table th, .meetingroom-table td {
      border: 1px solid #e3e5e8;
      padding: 8px 10px;
      text-align: center;
      vertical-align: middle;
    }
    .meetingroom-table th {
      background: #f7f8fa;
      color: #222b3a;
      font-weight: bold;
    }
    .meetingroom-table .sort-arrows {
      color: #e6002d;
      font-size: 1.1em;
      font-weight: bold;
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 2px;
    }
    .meetingroom-table .sort-arrows span {
      cursor: pointer;
      user-select: none;
      display: block;
      line-height: 1;
    }
    .meetingroom-table input[type="radio"] {
      accent-color: #e6002d;
    }
    .meetingroom-table tfoot td {
      border: none;
      background: none;
      padding-top: 16px;
    }
    .meetingroom-table-btns {
      display: flex;
      justify-content: flex-end;
      gap: 10px;
      margin-top: 10px;
    }
    .meetingroom-table-btns button {
      background: #f1f1f1;
      color: #222b3a;
      border: none;
      border-radius: 7px;
      padding: 8px 24px;
      font-size: 1.05em;
      font-weight: bold;
      transition: background 0.18s;
    }
    .meetingroom-table-btns button:hover {
      background: #e6002d;
      color: #fff;
    }
    /* 회의실 정보 표시 스타일 */
    .meetingroom-info-container {
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
    .status-active {
      background: linear-gradient(90deg, #e6002d 0%, #ff5a36 100%);
      color: #fff;
    }
    .status-inactive {
      background: #f1f1f1;
      color: #666;
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
    .meetingroom-image-container {
      position: relative;
      width: 100%;
      max-width: 400px;
      border-radius: 8px;
      overflow: hidden;
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    }
    .meetingroom-image {
      width: 100%;
      height: 200px;
      object-fit: cover;
      display: block;
    }
    .image-overlay {
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: rgba(0,0,0,0.3);
      display: flex;
      align-items: center;
      justify-content: center;
      opacity: 0;
      transition: opacity 0.3s ease;
    }
    .meetingroom-image-container:hover .image-overlay {
      opacity: 1;
    }
    .meetingroom-info-footer {
      padding: 20px 28px;
      background: #f7f8fa;
      border-top: 1.5px solid #e3e5e8;
    }
    .meetingroom-actions {
      display: flex;
      gap: 12px;
      justify-content: flex-end;
    }
    .meetingroom-actions .btn {
      padding: 8px 16px;
      font-size: 0.95em;
      font-weight: bold;
      border-radius: 6px;
      transition: all 0.2s ease;
    }
    .meetingroom-actions .btn-primary {
      background: linear-gradient(90deg, #e6002d 0%, #ff5a36 100%);
      border: none;
    }
    .meetingroom-actions .btn-primary:hover {
      background: linear-gradient(90deg, #ff5a36 0%, #e6002d 100%);
      transform: translateY(-1px);
    }
    .meetingroom-actions .btn-outline-danger {
      border-color: #e6002d;
      color: #e6002d;
    }
    .meetingroom-actions .btn-outline-danger:hover {
      background: #e6002d;
      color: #fff;
    }
    .meetingroom-actions .btn-outline-secondary {
      border-color: #6c757d;
      color: #6c757d;
    }
    .meetingroom-actions .btn-outline-secondary:hover {
      background: #6c757d;
      color: #fff;
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
      .meetingroom-info-footer {
        padding: 16px 20px;
      }
      .meetingroom-actions {
        flex-direction: column;
        gap: 8px;
      }
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
      <div class="meetingroom-title">회의실관리</div>
      <div class="meetingroom-wrap">
        <!-- 회의실 목록 -->
        <div class="meetingroom-list">
          <div class="meetingroom-list-title">회의실 목록</div>
          <ul>
            <li class="selected">▶ 회의실 1</li>
              <c:forEach var="conferenceRoom" items="${conferenceRoomList }" varStatus="loop">
                  <li>${conferenceRoom.conferenceRoomTitle}</li>
              </c:forEach>

          </ul>
          <button class="register-btn" id="openModalBtn">등록</button>
        </div>
        <!-- 회의실 테이블 -->
        <div class="meetingroom-table-wrap">
          <div class="meetingroom-table-info">※ 회의실을 선택하면 상세 정보를 확인할 수 있습니다.</div>
          <div class="meetingroom-info-container">
            <div class="meetingroom-info-header">
              <h4 class="meetingroom-info-title">${conferenceRoomList[0].conferenceRoomTitle}</h4>
              <div class="meetingroom-status">
                <span class="status-badge status-active">사용중</span>
              </div>
            </div>
            <div class="meetingroom-info-content">
              <div class="meetingroom-info-section">
                <div class="info-item">
                  <div class="info-label">📍 위치</div>
                  <div class="info-value">${conferenceRoomList[0].conferenceRoomLocation}</div>
                </div>
                <div class="info-item">
                  <div class="info-label">📝 설명</div>
                  <div class="info-value">일반 회의 및 프레젠테이션용 회의실입니다. 프로젝터와 화이트보드가 구비되어 있습니다.</div>
                </div>
                <div class="info-item">
                  <div class="info-label">👥 수용인원</div>
                  <div class="info-value">최대 12명</div>
                </div>
                <div class="info-item">
                  <div class="info-label">🖥️ 설치기자재</div>
                  <div class="info-value">프로젝터, 화이트보드, 음향시스템, TV모니터</div>
                </div>
                <div class="info-item">
                  <div class="info-label">⏰ 이용시간</div>
                  <div class="info-value">09:00 ~ 18:00 (평일)</div>
                </div>
                <div class="info-item">
                  <div class="info-label">📅 예약가능기간</div>
                  <div class="info-value">6개월</div>
                </div>
                <div class="info-item">
                  <div class="info-label">🔄 반복허용</div>
                  <div class="info-value">허용</div>
                </div>
              </div>
              <div class="meetingroom-info-section">
                <div class="info-item">
                  <div class="info-label">🖼️ 이미지</div>
                  <div class="info-value">
                    <div class="meetingroom-image-container">
                      <img src="https://images.unsplash.com/photo-1497366216548-37526070297c?w=400&h=300&fit=crop"
                           alt="회의실 이미지" class="meetingroom-image">
                      <div class="image-overlay">
                        <button class="btn btn-sm btn-light">이미지 보기</button>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="meetingroom-info-footer">
              <div class="meetingroom-actions">
                <button type="button" class="btn btn-primary btn-sm">수정</button>
                <button type="button" class="btn btn-outline-danger btn-sm">삭제</button>
                <button type="button" class="btn btn-outline-secondary btn-sm">예약현황</button>
              </div>
            </div>

          </div>
        </div>
      </div>
    </div>
    <!-- 회의실 등록 모달 -->
    <div class="modal fade" id="meetingRoomModal" tabindex="-1" aria-hidden="true" style="display:none;">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius:12px;overflow:hidden;min-width:520px;">
          <div class="modal-body" style="padding:32px 32px 24px 32px;background:#f7f8fa;">
            <form:form action="/meetingroom-register" method="post" modelAttribute="ConferenceRoomRegisterForm">
              <div class="mb-3 row align-items-center">
                <label class="col-3 col-form-label fw-bold text-danger">* 회의실명</label>
                <div class="col-9"><form:input path="conferenceRoomTitle" type="text" class="form-control" /></div>
              </div>
              <div class="mb-3 row align-items-center">
                <label class="col-3 col-form-label">위치</label>
                <div class="col-9"><form:input path="conferenceRoomLocation" type="text" class="form-control" /></div>
              </div>
              <div class="mb-3 row align-items-center">
                <label class="col-3 col-form-label">수용인원</label>
                <div class="col-9 d-flex align-items-center"><input type="number" class="form-control" style="width:100px;">&nbsp;명</div>
              </div>
              <div class="mb-3 row align-items-center">
                <label class="col-3 col-form-label">설치기자재</label>
                <div class="col-9"><input type="text" class="form-control"></div>
              </div>
              <div class="mb-3 row align-items-center">
                <label class="col-3 col-form-label">이미지</label>
                <div class="col-9 d-flex gap-2">
                  <input type="file" class="form-control" style="max-width:180px;">
                  <button type="button" class="btn btn-secondary btn-sm">이미지 업로드</button>
                  <button type="button" class="btn btn-outline-secondary btn-sm">초기화</button>
                </div>
              </div>
              <div class="mb-3 row align-items-center">
                <label class="col-3 col-form-label">사용 여부</label>
                <div class="col-9 d-flex gap-3">
                  <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="useYn" id="useY" checked>
                    <label class="form-check-label" for="useY">사용</label>
                  </div>
                  <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="useYn" id="useN">
                    <label class="form-check-label" for="useN">미사용</label>
                  </div>
                </div>
              </div>
              <div class="mb-3 row align-items-center">
                <label class="col-3 col-form-label">반복허용 여부</label>
                <div class="col-9 d-flex gap-3">
                  <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="repeatYn" id="repeatY" checked>
                    <label class="form-check-label" for="repeatY">허용</label>
                  </div>
                  <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="repeatYn" id="repeatN">
                    <label class="form-check-label" for="repeatN">불가</label>
                  </div>
                </div>
              </div>
              <div class="mb-3 row align-items-center">
                <label class="col-3 col-form-label">예약 가능한 기간</label>
                <div class="col-9">
                  <select class="form-select" style="max-width:160px;display:inline-block;">
                    <option>6개월</option>
                    <option>3개월</option>
                    <option>1개월</option>
                    <option>2주</option>
                    <option>1주</option>
                  </select>
                </div>
              </div>
              <div class="mb-3 row align-items-center">
                <label class="col-3 col-form-label">예약 가능한 최대 시간</label>
                <div class="col-9">
                  <select class="form-select" style="max-width:160px;display:inline-block;">
                    <option>- 제한없음 -</option>
                    <option>1시간</option>
                    <option>2시간</option>
                    <option>3시간</option>
                    <option>4시간</option>
                  </select>
                </div>
              </div>
              <div class="mb-3 row align-items-center">
                <label class="col-3 col-form-label">이용 가능 시간</label>
                <div class="col-9 d-flex align-items-center gap-2">
                  <select class="form-select" style="width:80px;">
                    <option>0시</option><option>1시</option><option>2시</option><option>3시</option><option>4시</option><option>5시</option><option>6시</option><option>7시</option><option>8시</option><option>9시</option><option>10시</option><option>11시</option><option>12시</option><option>13시</option><option>14시</option><option>15시</option><option>16시</option><option>17시</option><option>18시</option><option>19시</option><option>20시</option><option>21시</option><option>22시</option><option>23시</option>
                  </select>
                  ~
                  <select class="form-select" style="width:80px;">
                    <option>24시</option><option>23시</option><option>22시</option><option>21시</option><option>20시</option><option>19시</option><option>18시</option><option>17시</option><option>16시</option><option>15시</option><option>14시</option><option>13시</option><option>12시</option><option>11시</option><option>10시</option><option>9시</option><option>8시</option><option>7시</option><option>6시</option><option>5시</option><option>4시</option><option>3시</option><option>2시</option><option>1시</option><option>0시</option>
                  </select>
                  <div class="form-check ms-2">
                    <input class="form-check-input" type="checkbox" id="noLimitTime">
                    <label class="form-check-label" for="noLimitTime">제한없음</label>
                  </div>
                </div>
              </div>
              <div class="mb-3 row align-items-center">
                <label class="col-3 col-form-label">사용제한</label>
                <div class="col-9 d-flex gap-3">
                  <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="limitYn" id="limitN" checked>
                    <label class="form-check-label" for="limitN">제한없음</label>
                  </div>
                  <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="limitYn" id="limitY">
                    <label class="form-check-label" for="limitY">제한</label>
                  </div>
                </div>
              </div>
              <div class="mb-3 row align-items-center">
                <label class="col-3 col-form-label">사용제한 사유</label>
                <div class="col-9"><input type="text" class="form-control"></div>
              </div>
              <div class="d-flex justify-content-end gap-3 mt-4">
                <button type="submit" class="btn btn-primary" id="modalSaveBtn" style="min-width:90px;">저장</button>
                <button type="button" class="btn btn-secondary" id="modalCancelBtn" style="min-width:90px;">취소</button>
              </div>
            </form:form>
          </div>
        </div>
      </div>
    </div>
  </div>
<script>
  // 모달 열기/닫기 동작
  const openModalBtn = document.getElementById('openModalBtn');
  const modal = document.getElementById('meetingRoomModal');
  const modalCancelBtn = document.getElementById('modalCancelBtn');
  const modalSaveBtn = document.getElementById('modalSaveBtn');

  openModalBtn.addEventListener('click', function() {
    modal.style.display = 'block';
    modal.classList.add('show');
    document.body.style.overflow = 'hidden';
  });
  function closeModal() {
    modal.style.display = 'none';
    modal.classList.remove('show');
    document.body.style.overflow = '';
  }
  modalCancelBtn.addEventListener('click', closeModal);
  modalSaveBtn.addEventListener('click', closeModal);
  // 바깥 클릭 시 닫기
  modal.addEventListener('mousedown', function(e) {
    if (e.target === modal) closeModal();
  });
</script>
</body>
</html> 