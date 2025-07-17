<%-- src/main/webapp/WEB-INF/views/common/admin_top.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
    이 파일은 관리자 페이지 전용 상단 내비게이션입니다.
    사용자 인증/권한 체크는 각 페이지/API의 Controller/RestController에서 수행됩니다.
--%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>관리자 공통 상단</title>
  <link rel="icon" href="/img/favicon.png" type="image/png">
  <link rel="icon" href="/favicon.ico" type="image/x-icon">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    /* 관리자 페이지 공통 스타일 (body, container, sidebar, main-content 등) */
    body {
      background-color: #f7f7f7;
      font-family: Arial, sans-serif;
      margin: 0;
    }

    /* 관리자 페이지 자체 상단 내비게이션 (.navbarr) */
    .navbarr {
      display: flex;
      justify-content: flex-end; /* 우측 정렬 */
      background-color: #34495e; /* 어두운 배경 */
    }

    .navbarr a {
      padding: 10px 20px;
      color: white;
      text-decoration: none;
      display: inline-block;
    }

    .navbarr a:hover, .navbarr a.active {
      background-color: #1abc9c; /* 호버/활성 시 배경색 변경 */
    }

    /* 일반적인 navbar 스타일 (상단 로고/마이페이지 부분) */
    .navbar-brand {
      color: #e6002d !important; /* 로고 브랜드 색상 */
      font-size: 1.5rem;
    }

    .navbar h4 {
      margin: 0 auto; /* 중앙 정렬 */
    }

    .logo-img {
      width: 160px;
      height: 50px;
      object-fit: contain; /* 이미지 비율 유지 */
      object-position: center;
    }

    .navbar .container-fluid {
      padding-right: 2rem;
      padding-left: 2rem; /* 좌우 여백 */
    }

    /* 컨테이너, 사이드바, 메인 콘텐츠 (다른 페이지와 동일) */
    .container {
      display: flex;
      padding: 20px;
      max-width: 1200px;
      margin: 20px auto;
    }

    .sidebar {
      width: 200px;
      background-color: white;
      border-radius: 8px;
      padding: 15px;
      margin-right: 20px;
      box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
    }

    .sidebar h3 {
      margin-top: 0;
      font-size: 16px;
      border-bottom: 1px solid #ddd;
      padding-bottom: 10px;
    }

    .sidebar ul {
      list-style: none;
      padding: 0;
    }

    .sidebar ul li {
      margin: 10px 0;
    }

    .sidebar ul li a {
      color: #333;
      text-decoration: none;
    }

    .sidebar ul li a.active, .sidebar ul li a:hover {
      color: #1abc9c;
      font-weight: bold;
    }

    .main-content {
      flex: 1;
      background-color: white;
      border-radius: 8px;
      padding: 20px;
      box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
    }

    /* 푸터 스타일 (다른 페이지와 동일) */
    footer {
      text-align: center;
      padding: 10px;
      font-size: 12px;
      color: #999;
      margin-top: 20px;
    }

    /* 관리자 대시보드 카드 스타일 (admin/index.jsp에서만 사용되지만, 여기 두면 공통관리 가능) */
    .card {
      background-color: #ecf0f1;
      padding: 15px;
      border-radius: 6px;
      margin-bottom: 15px;
      text-align: left;
    }

    .card h4 {
      margin-top: 0;
      font-size: 15px;
    }

    /* 부서 목록 테이블 스타일 (department_list.jsp에서만 사용되지만, 여기 두면 공통관리 가능) */
    table { margin-top: 15px; }
    th, td { vertical-align: middle; }

    /* 부서 폼 스타일 (department_form.jsp에서만 사용되지만, 여기 두면 공통관리 가능) */
    .department-form-container { max-width: 600px; margin: 0 auto; padding-top: 20px; }
    .department-form-container label { font-weight: bold; margin-bottom: 5px; }
    .department-form-container .form-control { margin-bottom: 15px; }
    .department-form-container .btn-group { justify-content: center; display: flex; }

    /* 이력 테이블 스타일 (department_history.jsp에서만 사용되지만, 여기 두면 공통관리 가능) */
    .json-pre {
      white-space: pre-wrap;
      word-break: break-all;
      font-family: monospace;
      background-color: #f8f9fa;
      border: 1px solid #dee2e6;
      padding: 10px;
      max-height: 150px;
      overflow-y: auto;
      font-size: 0.85em;
      margin-top: 5px;
      border-radius: 4px;
    }
    .history-filter-form {
      margin-bottom: 20px;
    }
  </style>
</head>
<body>
<%--
    이 파일은 관리자 페이지의 공통 상단 내비게이션을 정의합니다.
    관리자 페이지 JSP 파일들은 <body> 바로 뒤에 이 파일을 <c:import>합니다.
    각 JSP 파일에서 <c:set var="currentPage" ... /> 를 정의하여
    현재 페이지에 맞는 메뉴가 하이라이트되도록 합니다.
--%>

<%-- 관리자 대시보드 자체 상단 내비게이션 --%>
<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
  <div class="container-fluid">
    <a class="navbar-brand d-flex align-items-center p-0" href="/"> <%-- 메인 페이지로 연결 --%>
      <span class="logo-crop">
            <img src="/img/grouvy_logo.png" alt="GROUVY 로고" class="logo-img">
        </span>
    </a>
    <h4>
      <a class="mb-2 mb-lg-0 text-decoration-none text-dark" href="/admin">관리자 페이지</a>
    </h4>
    <div class="d-flex align-items-center">
      <a href="#" class="me-2"> <%-- 마이페이지 프로필 이미지 --%>
        <img src="https://search.pstatic.net/sunny/?src=https%3A%2F%2Fs3.orbi.kr%2Fdata%2Ffile%2Funited2%2F6cc64e06aa404ac3a176745b9c1d5bfa.jpeg&type=sc960_832"
             alt="프로필" class="rounded-circle" width="36" height="36">
      </a>
      <a href="#" class="ms-2 text-decoration-none text-dark me-3">마이페이지</a>

      <%-- 사용자 이름 및 로그인/로그아웃: selectedUser 여부로 판단 --%>
      <div class="d-flex align-items-center">
        <c:if test="${not empty sessionScope.selectedUser}">
          <span class="text-dark me-2">${sessionScope.selectedUser.name} (${sessionScope.selectedUser.userId})님</span>
          <a href="#" class="btn btn-sm btn-outline-secondary" id="logoutBtn">로그아웃</a> <%-- JS로 로그아웃 처리 --%>
        </c:if>
        <c:if test="${empty sessionScope.selectedUser}">
          <a href="/login" class="btn btn-sm btn-outline-primary">로그인</a>
        </c:if>
      </div>
    </div>
  </div>
</nav>
<%-- 추가된 자체 내비게이션 바 --%>
<nav class="navbarr">
  <a href="#" class="${currentPage == 'adminHome' ? 'active' : ''}">관리자 홈</a> <%-- 관리자 홈 링크 추가 --%>
  <a href="#">전자결재</a>
  <a href="#">업무관리</a>
  <a href="#">업무문서함</a>
  <a href="/dept/chart" class="${currentPage == 'deptChart' ? 'active' : ''}">조직도</a>
  <a href="/message/inbox" class="${currentPage == 'message' || currentPage == 'inbox' || currentPage == 'sentbox' || currentPage == 'important' || currentPage == 'send' || currentPage == 'messageDetail' ? 'active' : ''}">쪽지</a>
  <a href="/notification/list" class="${currentPage == 'notificationList' ? 'active' : ''}">알림</a>
  <%-- 기타 관리자 페이지 상단 메뉴 --%>
</nav>

<%-- 푸터는 각 JSP 파일에서 직접 포함합니다. --%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
  document.addEventListener('DOMContentLoaded', function () {
    const logoutBtn = document.getElementById('logoutBtn');

    // 로그아웃 버튼 클릭 이벤트
    if (logoutBtn) {
      logoutBtn.addEventListener('click', async function(event) {
        event.preventDefault();
        if (confirm('로그아웃 하시겠습니까?')) {
          try {
            const response = await fetch('/api/v1/users/clearSelected', { method: 'GET' });
            if (response.ok) {
              console.log('세션 사용자 정보 제거 성공, 로그아웃 처리.');
              // 관리자 페이지는 자체 nav이므로 SSE 로직은 여기에 없음.
              window.location.href = '/login';
            } else {
              alert('로그아웃 처리 중 오류가 발생했습니다.');
            }
          } catch (error) {
            console.error('로그아웃 중 오류:', error);
            alert('네트워크 오류로 로그아웃에 실패했습니다.');
          }
        }
      });
    }

    // 현재 페이지에 따라 navbarr 링크 활성화
    const navbarrLinks = document.querySelectorAll('.navbarr a');
    navbarrLinks.forEach(link => {
      const path = window.location.pathname; // 현재 페이지의 경로
      // 경로 기반으로 active 클래스 추가 (간단한 매칭)
      if (link.getAttribute('href') === path) {
        link.classList.add('active');
      }
      // 혹은 currentPage 변수 기반 (JSTL이 렌더링한 클래스는 이미 있음)
      // 여기서는 JSTL이 이미 클래스를 넣어주므로 별도 JS 처리는 필요 없음.
      // 단, JSTL의 currentPage 변수 값을 기준으로 active 클래스를 동적으로 적용.
    });
  });
</script>
</body>
</html>