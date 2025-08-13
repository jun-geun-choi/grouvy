<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>전자결재 - 결재요청함</title>
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
      <!-- 결재요청함 -->
      <div id="requestContent">
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
                <c:forEach var="myRequestApproval" items="${myRequestApprovals }" varStatus="loop">
                  <tr><td>${loop.count}</td><td>공통</td>
                      <td><a href="/approval/requestDetail?no=${myRequestApproval.approvalNo}">${myRequestApproval.title}</a></td>
                      <td><fmt:formatDate value="${myRequestApproval.createdDate}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                      <td><fmt:formatDate value="${myRequestApproval.approvedDate}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                      <c:choose>
                          <c:when test="${myRequestApproval.status eq '결재완료'}">
                              <td><span class="status-icon status-complete">✔</span></td>
                          </c:when>
                          <c:when test="${myRequestApproval.status eq '반려'}">
                              <td><span class="status-icon status-cancel">✖</span></td>
                          </c:when>
                          <c:when test="${myRequestApproval.status eq '진행중'}">
                              <td><span class="status-icon status-progress">↻</span></td>
                          </c:when>
                          <c:otherwise>
                              <!-- 상태값이 지정되지 않은 경우 -->
                              <td><span>-</span></td>
                          </c:otherwise>
                      </c:choose>
                  </tr>
                </c:forEach>
            </tbody>
          </table>
<%--          <div class="pagination">--%>
<%--            <button class="btn btn-outline-secondary" disabled>&lt;&lt;</button>--%>
<%--            <button class="btn btn-outline-secondary" disabled>&lt;</button>--%>
<%--            <button class="btn btn-primary">1</button>--%>
<%--            <button class="btn btn-outline-secondary">2</button>--%>
<%--            <button class="btn btn-outline-secondary">3</button>--%>
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