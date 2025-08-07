<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>전자결재 - 완료문서함</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      margin: 0;
      font-family: Arial, sans-serif;
      background-color: #f5f5f5;
      color: #333;
      padding-top: 80px;
    }

    .navbar-brand {	
      color: #e6002d !important;
      font-size: 1.5rem;
    }

    .nav-item {
      padding-right: 1rem;
    }

    .navbar-nav .nav-link.active {
      font-weight: bold;
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
      padding: 20px;
    }

    .sidebar {
      width: 220px;
      background-color: white;
      border-radius: 12px;
      padding: 15px;
      margin-right: 20px;
      box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
      height: fit-content;
    }

    .sidebar h3 {
      margin-top: 0;
      font-size: 16px;
      border-bottom: 1px solid #ddd;
      padding-bottom: 10px;
      color: #e6002d;
      font-weight: bold;
    }

    .sidebar-section {
      margin-bottom: 20px;
    }

    .sidebar-section-title {
      font-size: 14px;
      font-weight: bold;
      color: #333;
      margin-bottom: 8px;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: space-between;
    }

    .sidebar-section-title.red {
      color: #e6002d;
    }

    .sidebar-list {
      list-style: none;
      padding: 0;
      margin: 0;
    }

    .sidebar-list li {
      margin: 5px 0;
      padding: 8px 12px;
      border-radius: 6px;
      cursor: pointer;
      transition: background-color 0.2s;
      font-size: 16px;
    }

    .sidebar-list li.active,
    .sidebar-list li:hover {
      background-color: #f8f9fa;
      color: #1abc9c;
      font-weight: bold;
    }

    .sidebar-list li .badge {
      background-color: #e6002d;
      color: white;
      border-radius: 12px;
      padding: 2px 6px;
      font-size: 11px;
      margin-left: 5px;
    }

    .sidebar-list li .badge.orange {
      background-color: #ff9800;
    }

    .sidebar-list li .badge.gray {
      background-color: #6c757d;
    }

    .main-content {
      flex: 1;
      background-color: white;
      padding: 30px;
      border-radius: 12px;
      box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
    }

    .main-content h2 {
      font-size: 20px;
      font-weight: bold;
      margin-bottom: 20px;
      color: #333;
    }

    .search-header {
      background-color: #f8f9fa;
      padding: 20px;
      border-radius: 8px;
      margin-bottom: 20px;
    }

    .search-header input,
    .search-header select {
      padding: 8px 12px;
      border: 1px solid #ddd;
      border-radius: 6px;
      font-size: 14px;
      margin-right: 10px;
    }

    .search-header button {
      padding: 8px 16px;
      background-color: #1abc9c;
      color: white;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      font-size: 14px;
    }

    .table-container {
      background-color: white;
      border-radius: 8px;
      overflow: hidden;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }

    .table {
      margin-bottom: 0;
    }

    .table thead th {
      background-color: #f8f9fa;
      border-bottom: 2px solid #dee2e6;
      font-weight: bold;
      color: #333;
      font-size: 14px;
      padding: 12px 8px;
    }

    .table tbody td {
      padding: 12px 8px;
      font-size: 14px;
      border-bottom: 1px solid #dee2e6;
    }

    .table tbody tr:hover {
      background-color: #f8f9fa;
    }

    .table a {
      color: #1abc9c;
      text-decoration: none;
    }

    .table a:hover {
      color: #16a085;
      font-weight: bold;
    }

    .pagination {
      display: flex;
      justify-content: center;
      align-items: center;
      margin-top: 20px;
      gap: 5px;
    }

    .pagination button,
    .pagination span {
      padding: 8px 12px;
      border: 1px solid #ddd;
      background-color: white;
      color: #333;
      cursor: pointer;
      border-radius: 4px;
      font-size: 14px;
    }

    .pagination .active {
      background-color: #1abc9c;
      color: white;
      border-color: #1abc9c;
    }

    .pagination button:disabled {
      background-color: #f8f9fa;
      color: #6c757d;
      cursor: not-allowed;
    }

    .btn-primary {
      background-color: #1abc9c;
      border-color: #1abc9c;
      color: white;
      padding: 10px 20px;
      border-radius: 6px;
      font-size: 14px;
      cursor: pointer;
    }

    .btn-primary:hover {
      background-color: #16a085;
      border-color: #16a085;
    }

    .btn-success {
      background-color: #4CAF50;
      border-color: #4CAF50;
      color: white;
    }

    .btn-success:hover {
      background-color: #45a049;
      border-color: #45a049;
    }

    .status-icon {
      font-size: 16px;
      margin-right: 5px;
    }

    .status-complete {
      color: #4CAF50;
    }

    .status-progress {
      color: #2196F3;
    }

    .status-reject {
      color: #f44336;
    }

    .status-cancel {
      color: #ff9800;
    }

    .info-text {
      color: #666;
      font-size: 13px;
      line-height: 1.5;
      margin-top: 15px;
    }

    footer {
      text-align: center;
      padding: 15px;
      font-size: 12px;
      color: #999;
      border-top: 1px solid #eee;
      margin-top: 40px;
    }
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
            <li class="active"><a href="complete.jsp" style="text-decoration: none; color: inherit;">완료문서함</a></li>
            <li><a href="reject.jsp" style="text-decoration: none; color: inherit;">반려문서함 <span class="badge">0</span></a></li>
            <li><a href="receive.jsp" style="text-decoration: none; color: inherit;">참조/열람문서함 <span class="badge gray">0</span></a></li>
          </ul>
        </div>
        <div class="sidebar-section">
          <div class="sidebar-section-title">발신/수신</div>
          <ul class="sidebar-list">
            <li><a href="receive.jsp" style="text-decoration: none; color: inherit;">부서수신함 <span class="badge">0</span></a></li>
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
      <!-- 완료문서함 -->
      <div id="completeContent">
        <h2>완료문서함</h2>
        <div class="search-header">
          <!-- 1줄: 기안자, 양식명 -->
          <div class="d-flex align-items-center mb-2" style="gap:16px;">
            <label class="form-label mb-0" style="min-width:56px;">기안자</label>
            <input type="text" class="form-control" style="width: 120px; margin-right:24px;">
            <label class="form-label mb-0" style="min-width:56px;">양식명</label>
            <input type="text" class="form-control" style="width: 120px;">
          </div>
          <!-- 2줄: 문서제목, 완료일(기간) -->
          <div class="d-flex align-items-center mb-2" style="gap:16px;">
            <label class="form-label mb-0" style="min-width:56px;">문서제목</label>
            <input type="text" class="form-control" style="width: 180px; margin-right:24px;">
            <label class="form-label mb-0" style="min-width:56px;">완료일</label>
            <input type="date" class="form-control" style="width: 120px;">
            <span class="mx-1">~</span>
            <input type="date" class="form-control" style="width: 120px;">
          </div>
          <!-- 3줄: 문서번호, 기안부서, 검색버튼 -->
          <div class="d-flex align-items-center" style="gap:16px;">
            <label class="form-label mb-0" style="min-width:56px;">문서번호</label>
            <input type="text" class="form-control" style="width: 120px; margin-right:24px;">
            <label class="form-label mb-0" style="min-width:56px;">기안부서</label>
            <select class="form-select" style="width: 120px;">
              <option>전체</option>
              <option>영업팀</option>
            </select>
            <div style="flex:1 1 auto;"></div>
            <button class="btn btn-primary" style="min-width:80px;">검색</button>
          </div>
        </div>
        <div class="d-flex align-items-center gap-3 mb-3">
          <select class="form-select" style="width: 60px;">
            <option>10</option>
            <option>20</option>
            <option>50</option>
          </select>
          <span class="fw-bold">전체 <b>24</b></span>
          <button class="btn btn-success">엑셀다운로드</button>
          <span class="text-success d-flex align-items-center"><span class="status-icon status-complete me-1">✔</span>완료</span>
        </div>
        <div class="table-container">
          <table class="table table-hover">
            <thead>
              <tr>
                <th><input type="checkbox" class="form-check-input"></th>
                <th>서식함</th>
                <th>양식명</th>
                <th>문서번호</th>
                <th>유형</th>
                <th>문서제목</th>
                <th>기안자</th>
                <th>기안부서</th>
                <th>완료일</th>
                <th>최종결재자</th>
                <th>문서상태</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><input type="checkbox" class="form-check-input"></td>
                <td>공통</td>
                <td>기안용지</td>
                <td>20250708-0001</td>
                <td>발신</td>
                <td>파이널 프로젝트 파이팅입니다ㅎㅎ</td>
                <td>김업무</td>
                <td>영업팀</td>
                <td>2025.07.08 10:01</td>
                <td>김업무</td>
                <td><span class="status-icon status-complete">✔</span></td>
              </tr>
              <tr>
                <td><input type="checkbox" class="form-check-input"></td>
                <td>공통</td>
                <td>협조문</td>
                <td>20250630-0001</td>
                <td>품의</td>
                <td>문서제목</td>
                <td>김울레</td>
                <td>영업팀</td>
                <td>2025.06.30 17:16</td>
                <td>김울레</td>
                <td><span class="status-icon status-complete">✔</span></td>
              </tr>
              <tr>
                <td><input type="checkbox" class="form-check-input"></td>
                <td>공통</td>
                <td>휴가신청서</td>
                <td>20250612-0002</td>
                <td>품의</td>
                <td>휴가신청 취소</td>
                <td>김울레</td>
                <td>영업팀</td>
                <td>2025.06.12 15:49</td>
                <td>김울레</td>
                <td><span class="status-icon status-complete">✔</span></td>
              </tr>
              <tr>
                <td><input type="checkbox" class="form-check-input"></td>
                <td>공통</td>
                <td>휴가신청서</td>
                <td>20250612-0001</td>
                <td>품의</td>
                <td>휴가신청</td>
                <td>김울레</td>
                <td>영업팀</td>
                <td>2025.06.12 14:54</td>
                <td>김울레</td>
                <td><span class="status-icon status-complete">✔</span></td>
              </tr>
              <tr>
                <td><input type="checkbox" class="form-check-input"></td>
                <td>공통</td>
                <td>휴가신청서</td>
                <td>20250530-0002</td>
                <td>품의</td>
                <td>ㅣㅣㅣㅣ</td>
                <td>김울레</td>
                <td>영업팀</td>
                <td>2025.05.30 13:45</td>
                <td>김울레</td>
                <td><span class="status-icon status-complete">✔</span></td>
              </tr>
              <tr>
                <td><input type="checkbox" class="form-check-input"></td>
                <td>공통</td>
                <td>휴가신청서</td>
                <td>20250530-0001</td>
                <td>품의</td>
                <td>오후반차 결재 테스트</td>
                <td>김울레</td>
                <td>영업팀</td>
                <td>2025.05.30 13:45</td>
                <td>김울레</td>
                <td><span class="status-icon status-complete">✔</span></td>
              </tr>
              <tr>
                <td><input type="checkbox" class="form-check-input"></td>
                <td>공통</td>
                <td>기안문</td>
                <td>20250513-0002</td>
                <td>품의</td>
                <td>ㅠㅠ ㅣㅣㅣㅣ</td>
                <td>김울레</td>
                <td>영업팀</td>
                <td>2025.05.13 14:24</td>
                <td>김울레</td>
                <td><span class="status-icon status-complete">✔</span></td>
              </tr>
              <tr>
                <td><input type="checkbox" class="form-check-input"></td>
                <td>공통</td>
                <td>기안문</td>
                <td>20250513-0001</td>
                <td>품의</td>
                <td>기획안 입니다</td>
                <td>김울레</td>
                <td>영업팀</td>
                <td>2025.05.13 14:21</td>
                <td>김울레</td>
                <td><span class="status-icon status-complete">✔</span></td>
              </tr>
              <tr>
                <td><input type="checkbox" class="form-check-input"></td>
                <td>공통</td>
                <td>기안문</td>
                <td>20250513-0000</td>
                <td>품의</td>
                <td>기획안</td>
                <td>김울레</td>
                <td>영업팀</td>
                <td>2025.05.13 14:21</td>
                <td>김울레</td>
                <td><span class="status-icon status-complete">✔</span></td>
              </tr>
              <tr>
                <td><input type="checkbox" class="form-check-input"></td>
                <td>공통</td>
                <td>기안문</td>
                <td>20250513-0000</td>
                <td>품의</td>
                <td>휴가계</td>
                <td>김울레</td>
                <td>영업팀</td>
                <td>2025.05.13 14:20</td>
                <td>김울레</td>
                <td><span class="status-icon status-complete">✔</span></td>
              </tr>
            </tbody>
          </table>
          <div class="pagination">
            <button class="btn btn-outline-secondary" disabled>&lt;&lt;</button>
            <button class="btn btn-outline-secondary" disabled>&lt;</button>
            <button class="btn btn-primary">1</button>
            <button class="btn btn-outline-secondary">2</button>
            <button class="btn btn-outline-secondary">3</button>
            <button class="btn btn-outline-secondary">&gt;</button>
            <button class="btn btn-outline-secondary">&gt;&gt;</button>
          </div>
          <div class="d-flex justify-content-end mt-3 gap-2">
            <button class="btn btn-primary">삭제</button>
            <button class="btn btn-primary">열람권한</button>
            <button class="btn btn-primary">개인보관</button>
          </div>
        </div>
        <div class="info-text">
          <div>결재 완료된 결재문서를 상세조회하여 결재선 외 참조자에게 [열람권한]을 부여할 수 있습니다. 열람권한을 부여받은 사용자는 '참조/열람문서함'에서 해당 결재문서를 조회할 수 있습니다.</div>
          <div>개인별 완료문서함, 반려문서함 등에서 결재선을 삭제/변경할 경우 회사관리자에게 결재선관리 권한이 부여되어야 하며, 결재문서를 삭제할 경우 회사관리자 > 사용관리의 '목록삭제' 기능을 사용으로 변경하도록 요청하시기 바랍니다.</div>
          <div>결재문서를 DB에서 완전히 삭제하고자 할 경우 회사관리자 > 사용관리에서 해당 결재문서를 조회하여 삭제를 요청하시기 바랍니다.</div>
        </div>
      </div>
    </main>
  </div>

  <footer>© 2025 그룹웨어 Corp.</footer>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 