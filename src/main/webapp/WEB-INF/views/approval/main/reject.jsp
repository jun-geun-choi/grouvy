<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>전자결재 - 반려문서함</title>
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
    <jsp:include page="/WEB-INF/views/common/nav.jsp" />
  <main>
    <div class="container">
        <jsp:include page="/WEB-INF/views/approval/common/sidebar.jsp" />
    <main class="main-content" id="mainContent">
      <!-- 반려문서함 -->
      <div id="rejectContent">
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
          <!-- 3줄: 기안부서, 검색버튼 -->
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
                <c:forEach var="approvalReject" items="${approvalRejectList}" varStatus="loop">
                  <tr>
                    <td><input type="checkbox" class="form-check-input"></td>
                    <td>${loop.count}</td>
                    <td>공통</td>
                    <td>품의</td>
                      <td><a href="/approval/rejectDetail?no=${approvalReject.approvalNo}">${approvalReject.title}</a></td>
                    <td>${approvalReject.writerName}</td>
                    <td>${approvalReject.requestDepartmentName}</td>
                      <td><fmt:formatDate value="${approvalReject.completedDate}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                    <td><span class="status-icon status-reject">✖</span></td>
                  </tr>
                </c:forEach>
            </tbody>
          </table>
<%--          <div class="pagination">--%>
<%--            <button class="btn btn-outline-secondary" disabled>&lt;&lt;</button>--%>
<%--            <button class="btn btn-outline-secondary" disabled>&lt;</button>--%>
<%--            <button class="btn btn-primary">1</button>--%>
<%--            <button class="btn btn-outline-secondary">&gt;</button>--%>
<%--            <button class="btn btn-outline-secondary">&gt;&gt;</button>--%>
<%--          </div>--%>
        </div>
      </div>
    </main>
  </div>
  <footer>© 2025 그룹웨어 Corp.</footer>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 