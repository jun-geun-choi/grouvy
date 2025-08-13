<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>전자결재 - 위임관리</title>
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
<sec:authentication property="principal.user" var="user"/>
  <jsp:include page="/WEB-INF/views/common/nav.jsp" />
  <main>
    <div class="container">
        <jsp:include page="/WEB-INF/views/approval/common/sidebar.jsp" />
    <main class="main-content" id="mainContent">
      <!-- 위임관리 -->
      <div id="delegateContent">
        <h2>위임관리</h2>
        <div class="search-header p-3" style="background:#f8f9fa; border-radius:8px; margin-bottom:20px;">
  <form method="post"
        id="delegateeForm"
        action="/approval/createDelegatee"
        enctype="multipart/form-data">
    <div class="d-flex align-items-end flex-wrap gap-3 mb-3">
      <div class="d-flex flex-column align-items-start" style="min-width: 220px;">
        <label class="form-label text-danger fw-bold mb-1" style="font-size:14px;">* 위임기간</label>
        <div class="d-flex align-items-center" style="gap: 6px;">
          <input name="startDate" type="date" id="startDate" class="form-control" style="width: 120px; height: 36px;" onchange="updateEndDateMin()">
          <span style="font-size:16px;">~</span>
          <input name="endDate" type="date" id="endDate" class="form-control" style="width: 120px; height: 36px;">
        </div>
      </div>
      <div class="d-flex flex-column align-items-start" style="min-width: 220px;">
        <label class="form-label text-danger fw-bold mb-1" style="font-size:14px;">* 수임자</label>
        <div class="input-group" style="width: 180px;">
          <input name="delegatorNo" id="delegatorNo" type="hidden" value="${user.employeeNo}">
          <input name="delegateeNo" id="delegateeNo" type="hidden">
          <input id="delegatee" type="text" class="form-control" style="height: 36px; border-top-right-radius: 0; border-bottom-right-radius: 0;" readonly>
          <button type="button" class="btn btn-primary" style="height: 36px; border-top-left-radius: 0; border-bottom-left-radius: 0; border-left: 0;" onclick="opendelegateePopup()">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16"><path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z"/></svg>
          </button>
        </div>
      </div>
    </div>
    <div class="d-flex flex-column flex-grow-1" style="min-width: 260px; width: 100%;">
      <label class="form-label text-danger fw-bold mb-1" style="font-size:14px;">* 위임 사유</label>
      <input name="reason" type="text" class="form-control" style="height: 36px;">
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
                <th>위임기간</th>
                <th>수임자</th>
                <th>위임 사유</th>
                <th>설정</th>
                <th>결재내역</th>
              </tr>
            </thead>
              <c:if test="${not empty alertMessage}">
                  <script>
                      alert("${alertMessage}");
                  </script>
              </c:if>
            <tbody>
              <c:if test="${not empty delegatee}">
                <tr id="delegatee-${delegatee.delegationNo}">
                  <td><input type="checkbox" class="form-check-input"></td>
                  <td>1</td>
                  <td>
                    <fmt:formatDate value="${delegatee.startDate}" pattern="yyyy-MM-dd" />
                    ~ <fmt:formatDate value="${delegatee.endDate}" pattern="yyyy-MM-dd" />
                  </td>
                  <td>${delegatee.name}</td>
                  <td>${delegatee.reason}</td>
                  <td><button onclick="cancelDelegation(${delegatee.delegationNo})" class="btn btn-outline-secondary btn-sm">설정해제</button></td>
                  <td><button class="btn btn-outline-secondary btn-sm">상세보기</button></td>
                </tr>
              </c:if>
            </tbody>
          </table>
        </div>
      </div>
    </main>
  </div>
  <footer>© 2025 그룹웨어 Corp.</footer>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
  <script>
    // 페이지 로드 시 날짜 제한 설정
    document.addEventListener('DOMContentLoaded', function() {
      setDateRestrictions();
    });

    // 날짜 제한 설정 함수
    function setDateRestrictions() {
      const startDateInput = document.getElementById('startDate');
      const endDateInput = document.getElementById('endDate');
      
      // 오늘 날짜를 YYYY-MM-DD 형식으로 가져오기
      const today = new Date().toISOString().split('T')[0];
      
      // 시작일은 오늘 이후만 선택 가능
      startDateInput.min = today;
      
      // 종료일은 시작일 이후만 선택 가능 (시작일이 선택되지 않았으면 오늘 이후)
      endDateInput.min = today;
    }

    // 시작일이 변경될 때 종료일의 최소값 업데이트
    function updateEndDateMin() {
      const startDateInput = document.getElementById('startDate');
      const endDateInput = document.getElementById('endDate');
      
      if (startDateInput.value) {
        // 시작일이 선택되면 종료일의 최소값을 시작일로 설정
        endDateInput.min = startDateInput.value;
        
        // 종료일이 시작일보다 이전이면 종료일 초기화
        if (endDateInput.value && endDateInput.value < startDateInput.value) {
          endDateInput.value = '';
        }
      } else {
        // 시작일이 선택되지 않으면 종료일의 최소값을 오늘로 설정
        const today = new Date().toISOString().split('T')[0];
        endDateInput.min = today;
      }
    }

    function opendelegateePopup() {
      // 팝업 창의 크기와 위치 설정 (bookFormDetail.jsp와 동일한 방식)
      var popupWidth = 900;
      var popupHeight = 550;
      var left = window.screenX + (window.outerWidth - popupWidth) / 2;
      var top = window.screenY + (window.outerHeight - popupHeight) / 2;
      
      // 팝업 창 열기 (bookFormDetail.jsp와 동일한 방식)
      const popup = window.open(
        '/approval/delegateePopup',
        'delegateePopup',
        `width=\${popupWidth},height=\${popupHeight},left=\${left},top=\${top},resizable=yes,scrollbars=yes`
      );
      
      // 팝업이 차단되었을 경우 처리
      if (!popup || popup.closed || typeof popup.closed === 'undefined') {
        alert('팝업이 차단되었습니다. 팝업 차단을 해제해주세요.');
      }
    }
    
    window.setApproversInForm = function(approvers) {
      console.log('부모에서 받은 결재선:', approvers);
      const delegatee = approvers[0];
      const name = delegatee.name;
      const no = delegatee.no;
      document.getElementById('delegatee').value = name;
      document.getElementById('delegateeNo').value = no;
    };

    function cancelDelegation(delegationNo) {
      if (!confirm("위임 설정을 해제하시겠습니까?")) return;

      fetch('/approval/delegation/cancel', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: `delegationNo=\${delegationNo}`
      })
              .then(() => {
                document.getElementById(`delegatee-${delegatee.delegationNo}`).remove();
              });
    }

    // 폼 제출 전 검증 함수
    function validateForm() {
      const startDate = document.getElementById('startDate').value;
      const endDate = document.getElementById('endDate').value;
      const delegateeNo = document.getElementById('delegateeNo').value;
      const reason = document.querySelector('input[name="reason"]').value;

      // 위임기간 검증
      if (!startDate || !endDate) {
        alert('위임기간을 입력해주세요.');
        return false;
      }

      // 수임자 검증
      if (!delegateeNo) {
        alert('수임자를 선택해주세요.');
        return false;
      }

      // 위임사유 검증
      if (!reason.trim()) {
        alert('위임사유를 입력해주세요.');
        return false;
      }

      return true;
    }

    // 폼 제출 이벤트 리스너 추가
    document.addEventListener('DOMContentLoaded', function() {
      const form = document.getElementById('delegateeForm');
      form.addEventListener('submit', function(e) {
        if (!validateForm()) {
          e.preventDefault();
          return false;
        }
      });
    });
  </script>
</body>
</html> 