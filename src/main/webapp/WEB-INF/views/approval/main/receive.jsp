<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>전자결재 - 부서수신함</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      margin: 0;
      font-family: Arial, sans-serif;
      background-color: #f5f5f5;
      color: #333;
      padding-top: 80px;
    }
    /* ... (동일한 스타일 생략) ... */
  </style>
</head>
<body>
  <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm fixed-top">
    <div class="container-fluid">
      <a class="navbar-brand d-flex align-items-center" href="/">
        <span class="logo-crop"> 
          <img src="${pageContext.request.contextPath}/resources/image/grouvy_logo.png" alt="GROUVY 로고" class="logo-img">
        </span>
      </a>
      <ul class="navbar-nav mb-2 mb-lg-0">
        <li class="nav-item"><a class="nav-link active" href="#">전자결재</a></li>
        <li class="nav-item"><a class="nav-link" href="#">업무문서함</a></li>
        <li class="nav-item"><a class="nav-link" href="#">업무 관리</a></li>
        <li class="nav-item"><a class="nav-link" href="#">쪽지</a></li>
        <li class="nav-item"><a class="nav-link" href="#">메신저</a></li>
        <li class="nav-item"><a class="nav-link" href="#">조직도</a></li>
        <li class="nav-item"><a class="nav-link" href="#">일정</a></li>
        <li class="nav-item"><a class="nav-link" href="admin_dashboard.html">관리자</a></li>
      </ul>
      <div class="d-flex align-items-center">
        <a href="mypage.html" >
          <img src="https://search.pstatic.net/sunny/?src=https%3A%2F%2Fs3.orbi.kr%2Fdata%2Ffile%2Funited2%2F6cc64e06aa404ac3a176745b9c1d5bfa.jpeg&type=sc960_832"
              alt="프로필" class="rounded-circle" width="36" height="36">
        </a>
        <a href="mypage.html" class="ms-2 text-decoration-none text-dark"><sec:authentication property="principal.user.name"/></a>
      </div>
    </div>
  </nav>
  <main>
    <div class="container">
        <div class="sidebar">
        <h3>전자결재</h3>
        <div class="sidebar-section">
          <div class="sidebar-section-title">기안</div>
          <ul class="sidebar-list">
            <li><a href="draft.jsp" style="text-decoration: none; color: inherit;">기안문작성</a></li>
            <li><a href="request.jsp" style="text-decoration: none; color: inherit;">결재요청함</a></li>
            <li><a href="temp.jsp" style="text-decoration: none; color: inherit;">임시저장함</a></li>
          </ul>
        </div>
        <div class="sidebar-section">
          <div class="sidebar-section-title red">결재</div>
          <ul class="sidebar-list">
            <li><a href="wait.jsp" style="text-decoration: none; color: inherit;">결재대기함 <span class="badge">0</span></a></li>
            <li><a href="progress.jsp" style="text-decoration: none; color: inherit;">결재진행함 <span class="badge orange">3</span></a></li>
            <li><a href="complete.jsp" style="text-decoration: none; color: inherit;">완료문서함</a></li>
            <li><a href="reject.jsp" style="text-decoration: none; color: inherit;">반려문서함 <span class="badge">0</span></a></li>
            <li class="active"><a href="receive.jsp" style="text-decoration: none; color: inherit;">참조/열람문서함 <span class="badge gray">0</span></a></li>
          </ul>
        </div>
        <div class="sidebar-section">
          <div class="sidebar-section-title">발신/수신</div>
          <ul class="sidebar-list">
            <li class="active"><a href="receive.jsp" style="text-decoration: none; color: inherit;">부서수신함 <span class="badge">0</span></a></li>
          </ul>
        </div>
        <div class="sidebar-section">
          <div class="sidebar-section-title">개인보관함</div>
        </div>
        <div class="sidebar-section">
          <div class="sidebar-section-title">환경설정</div>
          <ul class="sidebar-list">
            <li><a href="delegatee.jsp" style="text-decoration: none; color: inherit;">위임관리</a></li>
            <li>개인보관함관리</li>
          </ul>
        </div>
      </div>
    <main class="main-content" id="mainContent">
      <!-- 부서수신함 -->
      <div id="receiveContent">
        <h2>부서수신함</h2>
        <div class="search-header">
          <!-- 1줄: 기안자, 양식명 -->
          <div class="d-flex align-items-center mb-2" style="gap:16px;">
            <label class="form-label mb-0" style="min-width:56px;">기안자</label>
            <input type="text" class="form-control" style="width: 120px; margin-right:24px;">
            <label class="form-label mb-0" style="min-width:56px;">양식명</label>
            <input type="text" class="form-control" style="width: 120px;">
          </div>
          <!-- 2줄: 문서제목, 수신일(기간) -->
          <div class="d-flex align-items-center mb-2" style="gap:16px;">
            <label class="form-label mb-0" style="min-width:56px;">문서제목</label>
            <input type="text" class="form-control" style="width: 180px; margin-right:24px;">
            <label class="form-label mb-0" style="min-width:56px;">수신일</label>
            <input type="date" class="form-control" style="width: 120px;">
            <span class="mx-1">~</span>
            <input type="date" class="form-control" style="width: 120px;">
          </div>
          <!-- 3줄: 유형, 문서상태, 검색버튼 -->
          <div class="d-flex align-items-center" style="gap:16px;">
            <label class="form-label mb-0" style="min-width:56px;">유형</label>
            <select class="form-select" style="width: 120px; margin-right:24px;">
              <option>전체</option>
              <option>수신</option>
            </select>
            <label class="form-label mb-0" style="min-width:56px;">문서상태</label>
            <select class="form-select" style="width: 120px;">
              <option>전체</option>
              <option>대기</option>
              <option>진행중</option>
              <option>반려</option>
            </select>
            <div style="flex:1 1 auto;"></div>
            <button class="btn btn-primary" style="min-width:80px;">검색</button>
          </div>
        </div>
        <div class="table-container">
          <table class="table table-hover">
            <thead>
              <tr>
                <th>NO</th>
                <th>서식함</th>
                <th>유형</th>
                <th>문서제목</th>
                <th>기안자</th>
                <th>기안부서</th>
                <th>수신일</th>
                <th>문서상태</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>1</td>
                <td>공통</td>
                <td>수신</td>
                <td>ddddd</td>
                <td>김업무</td>
                <td>영업팀</td>
                <td>2025.07.08 10:51</td>
                <td>
                  <span class="status-icon status-progress">●</span>
                </td>
              </tr>
            </tbody>
          </table>
          <div class="pagination">
            <button class="btn btn-outline-secondary" disabled>&lt;&lt;</button>
            <button class="btn btn-outline-secondary" disabled>&lt;</button>
            <button class="btn btn-primary">1</button>
            <button class="btn btn-outline-secondary">&gt;</button>
            <button class="btn btn-outline-secondary">&gt;&gt;</button>
          </div>
        </div>
      </div>
    </main>
  </div>
  <footer>© 2025 그룹웨어 Corp.</footer>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 