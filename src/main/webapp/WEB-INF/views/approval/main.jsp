<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>전자결재 - 기안문작성</title>
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
            <li class="active">기안문작성</li>
            <li>결재요청함</li>
            <li>임시저장함</li>
          </ul>
        </div>
        <div class="sidebar-section">
          <div class="sidebar-section-title red">결재</div>
          <ul class="sidebar-list">
            <li>결재대기함 <span class="badge">0</span></li>
            <li>결재진행함 <span class="badge orange">3</span></li>
            <li>완료문서함</li>
            <li>반려문서함 <span class="badge">0</span></li>
            <li>참조/열람문서함 <span class="badge gray">0</span></li>
          </ul>
        </div>
        <div class="sidebar-section">
          <div class="sidebar-section-title">발신/수신</div>
          <ul class="sidebar-list">
            <li>부서수신함 <span class="badge">0</span></li>
          </ul>
        </div>
        <div class="sidebar-section">
          <div class="sidebar-section-title">개인보관함</div>
        </div>
        <div class="sidebar-section">
          <div class="sidebar-section-title">환경설정</div>
          <ul class="sidebar-list">
            <li>위임관리</li>
            <li>개인보관함관리</li>
          </ul>
        </div>
      </div>
    <main class="main-content" id="mainContent">
      <!-- 기안서 양식 -->
      <div id="draftContent">
        <h2>기안서 양식</h2>
        <div class="search-header">
          <div class="row g-3 align-items-center flex-wrap">
            <div class="col-12 col-md-3 mb-2 mb-md-0">
              <select class="form-select" style="min-width:120px;">
                <option>양식명</option>
              </select>
            </div>
            <div class="col-12 col-md-6 mb-2 mb-md-0">
              <input type="text" class="form-control" placeholder="검색어를 입력하세요" style="min-width:180px;">
            </div>
            <div class="col-12 col-md-3 mb-2 mb-md-0">
              <button class="btn btn-primary w-100" style="min-width:120px;">검색</button>
            </div>
          </div>
        </div>
        <div class="table-container">
          <table class="table table-hover">
            <thead>
              <tr>
                <th>NO</th>
                <th>시스템</th>
                <th>서식함</th>
                <th>즐겨찾기</th>
                <th>양식명</th>
                <th>양식설명</th>
                <th>담당부서</th>
                <th>담당자</th>
              </tr>
            </thead>
            <tbody>
              <tr><td>28</td><td>문서결재</td><td>공통</td><td><span class="star">☆</span></td><td><a href="#">기안용지</a></td><td>기안용지</td><td></td><td></td></tr>
              <tr><td>27</td><td>문서결재</td><td>공통</td><td><span class="star">☆</span></td><td><a href="#">협조문</a></td><td>협조문</td><td></td><td></td></tr>
              <tr><td>26</td><td>문서결재</td><td>공통</td><td><span class="star">☆</span></td><td><a href="/approval/buybookform">도서구입 신청서</a></td><td>도서구입 신청서</td><td></td><td></td></tr>
              <tr><td>25</td><td>문서결재</td><td>공통</td><td><span class="star">☆</span></td><td><a href="#">비품신청서</a></td><td>비품신청서</td><td></td><td></td></tr>
              <tr><td>24</td><td>문서결재</td><td>공통</td><td><span class="star">☆</span></td><td><a href="#">명함 신청서</a></td><td>명함 신청서</td><td></td><td></td></tr>
              <tr><td>23</td><td>인사</td><td>공통</td><td><span class="star">☆</span></td><td><a href="#">경조비 신청서</a></td><td>경조비 신청서</td><td></td><td></td></tr>
              <tr><td>22</td><td>문서결재</td><td>공통</td><td><span class="star">☆</span></td><td><a href="#">경조화환 신청서</a></td><td>경조화환 신청서</td><td></td><td></td></tr>
              <tr><td>21</td><td>인사</td><td>공통</td><td><span class="star">☆</span></td><td><a href="#">근태조정신청</a></td><td>근태조정신청</td><td></td><td></td></tr>
              <tr><td>20</td><td>문서결재</td><td>공통</td><td><span class="star">☆</span></td><td><a href="#">도서구입 신청서</a></td><td>도서구입 신청서</td><td></td><td></td></tr>
              <tr><td>19</td><td>신규회계</td><td>공통</td><td><span class="star">☆</span></td><td><a href="#">매입 계산서 신청</a></td><td>매입 계산서 신청</td><td></td><td></td></tr>
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
        </div>
      </div>
      <!-- 결재요청함 -->
      <div id="requestContent" style="display:none;">
        <h2>결재요청함</h2>
        <div class="search-header">
          <div class="d-flex flex-wrap gap-0 mb-2 align-items-center">
            <span style="font-size:18px; font-weight:500; min-width:60px; margin-right:0;">양식명</span>
            <input type="text" class="form-control" style="min-width:180px; max-width:220px;">
            <span style="font-size:18px; font-weight:500; min-width:80px;">문서상태</span>
            <select class="form-select" style="min-width:120px; max-width:160px;">
              <option>전체</option>
              <option>진행중</option>
              <option>완료</option>
              <option>반려</option>
              <option>취소</option>
            </select>
          </div>
          <div class="d-flex flex-wrap gap-2 align-items-center">
            <select class="form-select" style="min-width:120px; max-width:160px;">
              <option>문서제목</option>
              <option>문서내용</option>
            </select>
            <input type="text" class="form-control" style="min-width:120px; max-width:160px;">
            <input type="date" class="form-control" style="min-width:120px; max-width:160px;">
            <span>~</span>
            <input type="date" class="form-control" style="min-width:120px; max-width:160px;">
            <button class="btn btn-primary" style="min-width:80px;">검색</button>
          </div>
        </div>
        <div class="table-container">
          <table class="table table-hover">
            <thead>
              <tr>
                <th>NO</th>
                <th>서식함</th>
                <th>문서제목</th>
                <th>기안일</th>
                <th>완료일</th>
                <th>문서상태</th>
              </tr>
            </thead>
            <tbody>
              <tr><td>25</td><td>공통</td><td>이런건</td><td>2025.07.07 14:48</td><td></td><td><span class="status-icon status-progress">●</span></td></tr>
              <tr><td>24</td><td>공통</td><td>문서제목</td><td>2025.06.30 17:16</td><td>2025.06.30 17:16</td><td><span class="status-icon status-complete">✔</span></td></tr>
              <tr><td>23</td><td>공통</td><td>문서제목</td><td>2025.06.30 17:13</td><td></td><td><span class="status-icon status-progress">●</span></td></tr>
              <tr><td>22</td><td>공통</td><td>휴가신청 취소</td><td>2025.06.12 15:49</td><td>2025.06.12 15:49</td><td><span class="status-icon status-cancel">↺</span></td></tr>
              <tr><td>21</td><td>공통</td><td>휴가신청</td><td>2025.06.12 14:54</td><td>2025.06.12 14:54</td><td><span class="status-icon status-complete">✔</span></td></tr>
              <tr><td>20</td><td>공통</td><td>오후반차 결재 테스트</td><td>2025.05.30 13:45</td><td>2025.05.30 13:45</td><td><span class="status-icon status-complete">✔</span></td></tr>
              <tr><td>19</td><td>공통</td><td>ㅠㅠ ㅣㅣㅣㅣ</td><td>2025.05.30 13:35</td><td>2025.05.30 13:35</td><td><span class="status-icon status-complete">✔</span></td></tr>
              <tr><td>18</td><td>공통</td><td>기획안 입니다</td><td>2025.05.13 14:24</td><td>2025.05.13 14:24</td><td><span class="status-icon status-complete">✔</span></td></tr>
              <tr><td>17</td><td>공통</td><td>기획안</td><td>2025.05.13 14:21</td><td>2025.05.13 14:21</td><td><span class="status-icon status-complete">✔</span></td></tr>
              <tr><td>16</td><td>공통</td><td>기획안</td><td>2025.05.13 14:21</td><td>2025.05.13 14:21</td><td><span class="status-icon status-complete">✔</span></td></tr>
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
          <div class="d-flex justify-content-end mt-3">
            <button class="btn btn-primary">등록</button>
          </div>
        </div>
        <div class="info-text">
          결재요청 문서는 첫번째 결재(협의)자가 결재처리 전에 결재문서를 상세조회 화면에서 [결재취소] 기능을 이용하여 취소 > 가능함을 안내합니다.
        </div>
      </div>
      <!-- 임시저장함 -->
      <div id="tempContent" style="display:none;">
        <h2>임시저장함</h2>
        <div class="search-header">
          <div class="row g-3 align-items-center">
            <div class="col-auto">
              <select class="form-select" style="width:50px; min-width:140px; padding-right:2.5rem;">
                <option>문서제목</option>
                <option>문서내용</option>
              </select>
            </div>
            <div class="col-auto">
              <input type="text" class="form-control" style="width: 180px;">
            </div>
          </div>
          <div class="row g-3 align-items-center mt-1">
            <div class="d-flex align-items-center flex-grow-1" style="gap:8px; width:100%;">
              <span>등록일</span>
              <input type="date" class="form-control" style="width: 120px;">
              <span>~</span>
              <input type="date" class="form-control" style="width: 120px;">
              <div style="flex:1 1 auto;"></div>
              <button class="btn btn-primary" style="min-width:80px;">검색</button>
            </div>
          </div>
        </div>
        <div class="table-container">
          <table class="table table-hover">
            <thead>
              <tr>
                <th><input type="checkbox" class="form-check-input"></th>
                <th>NO</th>
                <th>서식함</th>
                <th>문서제목</th>
                <th>기안부서</th>
                <th>등록일</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><input type="checkbox" class="form-check-input"></td>
                <td>1</td>
                <td>공통</td>
                <td>숲체험·교육 지원사업 참여인력 전체 회의 실시</td>
                <td>영업팀</td>
                <td>2025.03.01 20:10</td>
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
          <div class="d-flex justify-content-end mt-3">
            <button class="btn btn-primary">삭제</button>
          </div>
        </div>
      </div>
      <!-- 결재대기함 -->
      <div id="waitContent" style="display:none;">
        <h2>결재대기함</h2>
        <div class="search-header">
          <!-- 1줄: 기안자, 양식명 -->
          <div class="d-flex align-items-center mb-2" style="gap:16px;">
            <label class="form-label mb-0" style="min-width:56px;">기안자</label>
            <input type="text" class="form-control" style="width: 120px; margin-right:24px;">
            <label class="form-label mb-0" style="min-width:56px;">양식명</label>
            <input type="text" class="form-control" style="width: 120px;">
          </div>
          <!-- 2줄: 문서제목, 배정일(기간) -->
          <div class="d-flex align-items-center mb-2" style="gap:16px;">
            <label class="form-label mb-0" style="min-width:56px;">문서제목</label>
            <input type="text" class="form-control" style="width: 180px; margin-right:24px;">
            <label class="form-label mb-0" style="min-width:56px;">배정일</label>
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
        <div class="table-container">
          <table class="table table-hover">
            <thead>
              <tr>
                <th><input type="checkbox" class="form-check-input"></th>
                <th>NO</th>
                <th>서식함</th>
                <th>문서번호</th>
                <th>유형</th>
                <th>문서제목</th>
                <th>기안자</th>
                <th>기안부서</th>
                <th>기안일</th>
                <th>배정일</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><input type="checkbox" class="form-check-input"></td>
                <td>1</td>
                <td>공통</td>
                <td>20250708-0001</td>
                <td>수신</td>
                <td>파이널 프로젝트 파이팅입니다ㅎㅎ</td>
                <td>김업무</td>
                <td>영업팀</td>
                <td>2025.07.08 10:01</td>
                <td>2025.07.08 10:01</td>
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
          <div class="d-flex justify-content-end mt-3 gap-2">
            <button class="btn btn-primary">일괄합의</button>
            <button class="btn btn-primary">일괄결재</button>
          </div>
        </div>
      </div>
      <!-- 결재진행함 -->
      <div id="progressContent" style="display:none;">
        <h2>결재진행함</h2>
        <div class="search-header">
          <!-- 1줄: 기안자, 양식명 -->
          <div class="d-flex align-items-center mb-2" style="gap:16px;">
            <label class="form-label mb-0" style="min-width:56px;">기안자</label>
            <input type="text" class="form-control" style="width: 120px; margin-right:24px;">
            <label class="form-label mb-0" style="min-width:56px;">양식명</label>
            <input type="text" class="form-control" style="width: 120px;">
          </div>
          <!-- 2줄: 문서제목, 기안일(기간) -->
          <div class="d-flex align-items-center mb-2" style="gap:16px;">
            <label class="form-label mb-0" style="min-width:56px;">문서제목</label>
            <input type="text" class="form-control" style="width: 180px; margin-right:24px;">
            <label class="form-label mb-0" style="min-width:56px;">결재일</label>
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
        <div class="table-container">
          <table class="table table-hover">
            <thead>
              <tr>
                <th>NO</th>
                <th>서식함</th>
                <th>문서번호</th>
                <th>문서제목</th>
                <th>기안자</th>
                <th>기안부서</th>
                <th>기안일</th>
                <th>결재일</th>
                <th>진행자</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>3</td>
                <td>공통</td>
                <td></td>
                <td>이런건</td>
                <td>김업무</td>
                <td>영업팀</td>
                <td>2025.07.07 14:48</td>
                <td>2025.07.07 14:48</td>
                <td>박메카</td>
              </tr>
              <tr>
                <td>2</td>
                <td>공통</td>
                <td></td>
                <td>갑니다.</td>
                <td>김울레</td>
                <td>영업팀</td>
                <td>2025.05.13 08:57</td>
                <td>2025.05.13 08:57</td>
                <td>이비즈</td>
              </tr>
              <tr>
                <td>1</td>
                <td>공통</td>
                <td></td>
                <td>adfasdfasd</td>
                <td>김울레</td>
                <td>영업팀</td>
                <td>2025.05.09 18:09</td>
                <td>2025.05.09 18:09</td>
                <td>이비즈</td>
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
      <!-- 완료문서함 -->
      <div id="completeContent" style="display:none;">
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
      <!-- 반려문서함 -->
      <div id="rejectContent" style="display:none;">
        <h2>반려문서함</h2>
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
          <span class="fw-bold">전체 <b>2</b></span>
          <span class="ms-auto text-danger d-flex align-items-center"><span class="status-icon status-reject me-1">✖</span>반려</span>
        </div>
        <div class="table-container">
          <table class="table table-hover">
            <thead>
              <tr>
                <th><input type="checkbox" class="form-check-input"></th>
                <th>NO</th>
                <th>서식함</th>
                <th>유형</th>
                <th>문서제목</th>
                <th>기안자</th>
                <th>기안부서</th>
                <th>완료일</th>
                <th>문서상태</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><input type="checkbox" class="form-check-input"></td>
                <td>2</td>
                <td>공통</td>
                <td>품의</td>
                <td>휴가신청</td>
                <td>김울레</td>
                <td>영업팀</td>
                <td>2025.06.26 08:28</td>
                <td><span class="status-icon status-reject">✖</span></td>
              </tr>
              <tr>
                <td><input type="checkbox" class="form-check-input"></td>
                <td>1</td>
                <td>공통</td>
                <td>품의</td>
                <td>경조비신청</td>
                <td>김울레</td>
                <td>영업팀</td>
                <td>2025.04.19 03:28</td>
                <td><span class="status-icon status-reject">✖</span></td>
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
          <div class="d-flex justify-content-end mt-3">
            <button class="btn btn-primary">삭제</button>
          </div>
        </div>
      </div>
      <!-- 부서수신함 -->
      <div id="receiveContent" style="display:none;">
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
      <!-- 위임관리 -->
      <div id="delegateContent" style="display:none;">
        <h2>위임관리</h2>
        <div class="search-header p-3" style="background:#f8f9fa; border-radius:8px; margin-bottom:20px;">
  <form>
    <div class="d-flex align-items-end flex-wrap gap-3 mb-3">
      <div class="d-flex flex-column align-items-start" style="min-width: 160px;">
        <label class="form-label text-danger fw-bold mb-1" style="font-size:14px;">* 위임할 대상부서</label>
        <input type="text" class="form-control" value="영업팀" style="width: 160px; height: 36px;">
      </div>
      <div class="d-flex flex-column align-items-start" style="min-width: 220px;">
        <label class="form-label text-danger fw-bold mb-1" style="font-size:14px;">* 위임기간</label>
        <div class="d-flex align-items-center" style="gap: 6px;">
          <input type="date" class="form-control" style="width: 120px; height: 36px;">
          <span style="font-size:16px;">~</span>
          <input type="date" class="form-control" style="width: 120px; height: 36px;">
        </div>
      </div>
      <div class="d-flex flex-column align-items-start" style="min-width: 220px;">
        <label class="form-label text-danger fw-bold mb-1" style="font-size:14px;">* 수임자</label>
        <div class="input-group" style="width: 180px;">
          <input type="text" class="form-control" style="height: 36px; border-top-right-radius: 0; border-bottom-right-radius: 0;">
          <button type="button" class="btn btn-primary" style="height: 36px; border-top-left-radius: 0; border-bottom-left-radius: 0; border-left: 0;" onclick="openApproverPopup();">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16"><path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z"/></svg>
          </button>
        </div>
      </div>
    </div>
    <div class="d-flex flex-column flex-grow-1" style="min-width: 260px; width: 100%;">
      <label class="form-label text-danger fw-bold mb-1" style="font-size:14px;">* 위임 사유</label>
      <input type="text" class="form-control" style="height: 36px;">
      <div class="d-flex justify-content-end mt-2">
        <button type="submit" class="btn btn-primary" style="height: 36px; min-width: 80px; font-size: 1rem; padding: 0 18px;">저장</button>
      </div>
    </div>
  </form>
</div>

        <div class="table-container">
          <table class="table table-hover">
            <thead>
              <tr>
                <th><input type="checkbox" class="form-check-input"></th>
                <th>NO</th>
                <th>위임할 대상부서</th>
                <th>위임기간</th>
                <th>수임자</th>
                <th>위임 사유</th>
                <th>설정</th>
                <th>결재내역</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><input type="checkbox" class="form-check-input"></td>
                <td>1</td>
                <td>회계팀</td>
                <td>2020.08.24 ~ 2020.08.26</td>
                <td>박메카</td>
                <td>병가</td>
                <td><button class="btn btn-outline-secondary btn-sm">설정해제</button></td>
                <td><button class="btn btn-outline-secondary btn-sm" id="delegateeApprovalPopup">상세보기</button></td>
              </tr>
              <tr>
                <td><input type="checkbox" class="form-check-input"></td>
                <td>2</td>
                <td>영업팀</td>
                <td>2017.09.01 ~ 2017.09.30</td>
                <td>이비즈</td>
                <td>1111</td>
                <td><button class="btn btn-outline-secondary btn-sm">설정해제</button></td>
                <td><button class="btn btn-outline-secondary btn-sm" id="delegateeApprovalPopup">상세보기</button></td>
              </tr>
              <tr>
                <td><input type="checkbox" class="form-check-input"></td>
                <td>3</td>
                <td>영업팀</td>
                <td>2016.05.01 ~ 2016.05.31</td>
                <td>이비즈</td>
                <td>휴가</td>
                <td><button class="btn btn-outline-secondary btn-sm">설정해제</button></td>
                <td><button class="btn btn-outline-secondary btn-sm" id="delegateeApprovalPopup">상세보기</button></td>
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
          <div class="d-flex justify-content-end mt-3">
            <button class="btn btn-primary">설정해제</button>
          </div>
        </div>
      </div>
    </main>
  </div>

  <footer>© 2025 그룹웨어 Corp.</footer>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
  <script>
  document.getElementById('delegateeApprovalPopup').onclick = function(e) {
    if (e) e.preventDefault();
    var popupWidth = 900;
    var popupHeight = 550;
    var left = window.screenX + (window.outerWidth - popupWidth) / 2;
    var top = window.screenY + (window.outerHeight - popupHeight) / 2;
    window.open('approval_delegatee_approval_popup.html', 'delegateeApprovalPopup', `width=${popupWidth},height=${popupHeight},left=${left},top=${top},resizable=yes,scrollbars=yes`);
  };
  // 사이드바 메뉴 클릭 시 본문 교체
  const draftMenu = document.querySelectorAll('.sidebar-list li');
  draftMenu.forEach((li) => {
    li.addEventListener('click', function() {
      let tab = '';
      
      if (this.textContent.includes('기안문작성')) {
        tab = 'draft';
        document.getElementById('draftContent').style.display = '';
        document.getElementById('requestContent').style.display = 'none';
        document.getElementById('tempContent').style.display = 'none';
        document.getElementById('waitContent').style.display = 'none';
        document.getElementById('progressContent').style.display = 'none';
        document.getElementById('completeContent').style.display = 'none';
        document.getElementById('rejectContent').style.display = 'none';
        document.getElementById('receiveContent').style.display = 'none';
        document.getElementById('delegateContent').style.display = 'none';
      } else if (this.textContent.includes('결재요청함')) {
        tab = 'request';
        document.getElementById('draftContent').style.display = 'none';
        document.getElementById('requestContent').style.display = '';
        document.getElementById('tempContent').style.display = 'none';
        document.getElementById('waitContent').style.display = 'none';
        document.getElementById('progressContent').style.display = 'none';
        document.getElementById('completeContent').style.display = 'none';
        document.getElementById('rejectContent').style.display = 'none';
        document.getElementById('receiveContent').style.display = 'none';
        document.getElementById('delegateContent').style.display = 'none';
      } else if (this.textContent.includes('임시저장함')) {
        tab = 'temp';
        document.getElementById('draftContent').style.display = 'none';
        document.getElementById('requestContent').style.display = 'none';
        document.getElementById('tempContent').style.display = '';
        document.getElementById('waitContent').style.display = 'none';
        document.getElementById('progressContent').style.display = 'none';
        document.getElementById('completeContent').style.display = 'none';
        document.getElementById('rejectContent').style.display = 'none';
        document.getElementById('receiveContent').style.display = 'none';
        document.getElementById('delegateContent').style.display = 'none';
      } else if (this.textContent.includes('결재대기함')) {
        tab = 'wait';
        document.getElementById('draftContent').style.display = 'none';
        document.getElementById('requestContent').style.display = 'none';
        document.getElementById('tempContent').style.display = 'none';
        document.getElementById('waitContent').style.display = '';
        document.getElementById('progressContent').style.display = 'none';
        document.getElementById('completeContent').style.display = 'none';
        document.getElementById('rejectContent').style.display = 'none';
        document.getElementById('receiveContent').style.display = 'none';
        document.getElementById('delegateContent').style.display = 'none';
      } else if (this.textContent.includes('결재진행함')) {
        tab = 'progress';
        document.getElementById('draftContent').style.display = 'none';
        document.getElementById('requestContent').style.display = 'none';
        document.getElementById('tempContent').style.display = 'none';
        document.getElementById('waitContent').style.display = 'none';
        document.getElementById('progressContent').style.display = '';
        document.getElementById('completeContent').style.display = 'none';
        document.getElementById('rejectContent').style.display = 'none';
        document.getElementById('receiveContent').style.display = 'none';
        document.getElementById('delegateContent').style.display = 'none';
      } else if (this.textContent.includes('완료문서함')) {
        tab = 'complete';
        document.getElementById('draftContent').style.display = 'none';
        document.getElementById('requestContent').style.display = 'none';
        document.getElementById('tempContent').style.display = 'none';
        document.getElementById('waitContent').style.display = 'none';
        document.getElementById('progressContent').style.display = 'none';
        document.getElementById('completeContent').style.display = '';
        document.getElementById('rejectContent').style.display = 'none';
        document.getElementById('receiveContent').style.display = 'none';
        document.getElementById('delegateContent').style.display = 'none';
      } else if (this.textContent.includes('반려문서함')) {
        tab = 'reject';
        document.getElementById('draftContent').style.display = 'none';
        document.getElementById('requestContent').style.display = 'none';
        document.getElementById('tempContent').style.display = 'none';
        document.getElementById('waitContent').style.display = 'none';
        document.getElementById('progressContent').style.display = 'none';
        document.getElementById('completeContent').style.display = 'none';
        document.getElementById('rejectContent').style.display = '';
        document.getElementById('receiveContent').style.display = 'none';
        document.getElementById('delegateContent').style.display = 'none';
      } else if (this.textContent.includes('부서수신함')) {
        tab = 'receive';
        document.getElementById('draftContent').style.display = 'none';
        document.getElementById('requestContent').style.display = 'none';
        document.getElementById('tempContent').style.display = 'none';
        document.getElementById('waitContent').style.display = 'none';
        document.getElementById('progressContent').style.display = 'none';
        document.getElementById('completeContent').style.display = 'none';
        document.getElementById('rejectContent').style.display = 'none';
        document.getElementById('receiveContent').style.display = '';
        document.getElementById('delegateContent').style.display = 'none';
      } else if (this.textContent.includes('위임관리')) {
        tab = 'delegate';
        document.getElementById('draftContent').style.display = 'none';
        document.getElementById('requestContent').style.display = 'none';
        document.getElementById('tempContent').style.display = 'none';
        document.getElementById('waitContent').style.display = 'none';
        document.getElementById('progressContent').style.display = 'none';
        document.getElementById('completeContent').style.display = 'none';
        document.getElementById('rejectContent').style.display = 'none';
        document.getElementById('receiveContent').style.display = 'none';
        document.getElementById('delegateContent').style.display = '';
      }
      
      // URL에 쿼리스트링 추가
      const url = new URL(window.location);
      url.searchParams.set('tab', tab);
      window.history.pushState({}, '', url);
      
      draftMenu.forEach((el) => el.classList.remove('active'));
      this.classList.add('active');
    });
  });

  // 페이지 로드 시 URL 쿼리스트링 확인하여 해당 탭 표시
  document.addEventListener('DOMContentLoaded', function() {
    const urlParams = new URLSearchParams(window.location.search);
    const tab = urlParams.get('tab');
    
    if (tab) {
      // 모든 콘텐츠 숨기기
      document.getElementById('draftContent').style.display = 'none';
      document.getElementById('requestContent').style.display = 'none';
      document.getElementById('tempContent').style.display = 'none';
      document.getElementById('waitContent').style.display = 'none';
      document.getElementById('progressContent').style.display = 'none';
      document.getElementById('completeContent').style.display = 'none';
      document.getElementById('rejectContent').style.display = 'none';
      document.getElementById('receiveContent').style.display = 'none';
      document.getElementById('delegateContent').style.display = 'none';
      
      // 모든 메뉴 비활성화
      draftMenu.forEach((el) => el.classList.remove('active'));
      
      // 해당 탭 표시 및 메뉴 활성화
      switch(tab) {
        case 'draft':
          document.getElementById('draftContent').style.display = '';
          draftMenu[0].classList.add('active');
          break;
        case 'request':
          document.getElementById('requestContent').style.display = '';
          draftMenu[1].classList.add('active');
          break;
        case 'temp':
          document.getElementById('tempContent').style.display = '';
          draftMenu[2].classList.add('active');
          break;
        case 'wait':
          document.getElementById('waitContent').style.display = '';
          draftMenu[3].classList.add('active');
          break;
        case 'progress':
          document.getElementById('progressContent').style.display = '';
          draftMenu[4].classList.add('active');
          break;
        case 'complete':
          document.getElementById('completeContent').style.display = '';
          draftMenu[5].classList.add('active');
          break;
        case 'reject':
          document.getElementById('rejectContent').style.display = '';
          draftMenu[6].classList.add('active');
          break;
        case 'receive':
          document.getElementById('receiveContent').style.display = '';
          draftMenu[7].classList.add('active');
          break;
        case 'delegate':
          document.getElementById('delegateContent').style.display = '';
          draftMenu[8].classList.add('active');
          break;
        default:
          // 기본값: 기안문작성
          document.getElementById('draftContent').style.display = '';
          draftMenu[0].classList.add('active');
      }
    }
  });

  function openApproverPopup() {
    var popupWidth = 900;
    var popupHeight = 550;
    var left = window.screenX + (window.outerWidth - popupWidth) / 2;
    var top = window.screenY + (window.outerHeight - popupHeight) / 2;
    window.open(
      'approval_delegatee_popup.html',
      'approverPopup',
      `width=${popupWidth},height=${popupHeight},left=${left},top=${top},resizable=yes,scrollbars=yes`
    );
  }

  </script>
</body>
</html>
