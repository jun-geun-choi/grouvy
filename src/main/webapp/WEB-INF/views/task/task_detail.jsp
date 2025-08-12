<%@ page language="java" contentType="text/html;charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ include file="../common/taglib.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>업무 요청 상세</title>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<style>
	/* 테이블 전체에 테두리 & 라운드 적용 */
	.detail-table {
		border: 1px solid #e2e8f0;
		border-collapse: separate;
		border-spacing: 0;
		border-radius: 8px;
		overflow: hidden; /* 라운드 살리기 */
	}

	/* th: 짙은 배경 + 우측 경계로 구분 */
	.detail-table th {
		background-color: #f0f4f8;  /* 연한 회색 배경 */
		color: #333;
		border-right: 1px solid #e2e8f0;
		padding: 12px 16px;
	}

	/* td: 흰 배경 + 좌우 패딩 */
	.detail-table td {
		background-color: #ffffff;
		padding: 12px 16px;
		border-right: 1px solid #e2e8f0;
	}

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



.main-content {
	flex: 1;
	background-color: white;
	padding: 50px 20px;
	text-align: center;
	border-radius: 12px;
	padding: 20px;
	box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
}

.main-content h2 {
	text-align: left;
	margin-bottom: 20px;
	color: #e6002d;
}

.task-detail-box {
	background: #fff;
	border-radius: 8px;
	box-shadow: 0 2px 8px rgba(0,0,0,0.1);
	padding: 20px;
	margin-bottom: 20px;
}

.detail-table {
	width: 100%;
	border-collapse: collapse;
	margin-bottom: 20px;
	background: #fff;
}

.detail-table th, .detail-table td {
	border-bottom: 1px solid #e2e8f0;
	padding: 12px 8px;
	text-align: left;
	font-size: 14px;
	background: #fff;
}

.detail-table th {
	background: #f7c873;
	color: #333;
	font-weight: 600;
	width: 120px;
}

.detail-table tr:last-child th, .detail-table tr:last-child td {
	border-bottom: none;
}

.status {
	display: inline-block;
	padding: 4px 12px;
	border-radius: 8px;
	font-size: 12px;
	font-weight: 500;
}

.status-todo {
	background: #ff6b6b;
	color: #fff;
}

.feedback-section {
	background: #f8fafc;
	border-radius: 8px;
	border: 1px solid #e2e8f0;
	padding: 15px;
	margin-top: 20px;
}

.-header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	font-size: 16px;
	font-weight: 600;
	margin-bottom: 15px;
	color: #333;
}

.feedback-table-wrap {
	overflow-x: auto;
}

.feedback-table {
	width: 100%;
	border-collapse: collapse;
	background: #f8fafc;
	margin-bottom: 15px;
}

.feedback-table th, .feedback-table td {
	border-bottom: 1px solid #e2e8f0;
	padding: 10px 8px;
	text-align: left;
	font-size: 14px;
	background: #f8fafc;
}

.feedback-table th {
	background: #f7c873;
	color: #333;
	font-weight: 600;
	width: 120px;
}

.feedback-table tr:last-child th, .feedback-table tr:last-child td {
	border-bottom: none;
}

.progress-bar {
	display: flex;
	flex-direction: row;
	flex-wrap: wrap;
	gap: 8px;
	margin-bottom: 10px;
	align-items: center;
}

.progress-btn {
	background: #e2e8f0;
	color: #333;
	border: none;
	border-radius: 4px;
	padding: 4px 8px;
	font-size: 12px;
	cursor: pointer;
	font-weight: 500;
	transition: background 0.15s;
	min-width: 40px;
	text-align: center;
}

.progress-btn:hover {
	background: #a5b4fc;
	color: #fff;
}

.progress-info {
	font-size: 12px;
	color: #e6002d;
	margin-bottom: 10px;
}

.task-memo {
	width: 100%;
	min-height: 80px;
	border-radius: 4px;
	border: 1px solid #ccc;
	font-size: 14px;
	padding: 8px;
	resize: vertical;
}

.related-btn {
	background-color: #4CAF50;
	color: #fff;
	border: none;
	padding: 6px 16px;
	border-radius: 4px;
	font-size: 14px;
	cursor: pointer;
}

.related-btn:hover {
	background-color: #45a049;
}

.file-upload {
	background: #fff;
	border: 1px dashed #ccc;
	border-radius: 4px;
	padding: 15px;
	text-align: center;
	color: #999;
	font-size: 14px;
	margin-top: 10px;
}

.feedback-actions {
	display: flex;
	gap: 10px;
	justify-content: flex-end;
	margin-top: 20px;
}

.feedback-btn-main {
	background-color: #4CAF50;
	color: #fff;
	border: none;
	padding: 8px 18px;
	border-radius: 4px;
	font-size: 14px;
	cursor: pointer;
}

.feedback-btn-main:hover {
	background-color: #45a049;
}

.feedback-actions button {
	padding: 8px 16px;
	border: none;
	border-radius: 4px;
	cursor: pointer;
	font-size: 14px;
	background-color: #ccc;
	color: #333;
}

.feedback-actions button:hover {
	background-color: #bbb;
}

footer {
	text-align: center;
	padding: 15px;
	font-size: 12px;
	color: #999;
	border-top: 1px solid #eee;
	margin-top: 40px;
}
/* 사이드바 활성화(현재 페이지) 민트색 */
.sidebar-list li.active {
  background-color: #e0f7f4 !important;
  color: #1abc9c !important;
  font-weight: bold;
}

/* 작은 버튼 민트색 */
button,
.related-btn,
.feedback-btn-main {
  background: #1abc9c !important;
  color: #fff !important;
  border: none !important;
}
button:hover,
.related-btn:hover,
.feedback-btn-main:hover,
.progress-btn:hover {
  background: #159c86 !important;
  color: #fff !important;
}

/* 테이블 헤더 흰색 */
th, thead, .table thead th, .file-table th, .detail-table th, .feedback-table th {
  background: #fff !important;
  color: #333 !important;
}
/* 사이드바 컨테이너 */
.sidebar {
	width: 220px;
	background-color: white;
	border-radius: 12px;
	padding: 15px;
	margin-right: 20px;
	box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
	height: fit-content;
}

/* 사이드바 제목 */
.sidebar h3 {
	margin-top: 0;
	font-size: 16px;
	border-bottom: 1px solid #ddd;
	padding-bottom: 10px;
	color: #e6002d;
	font-weight: bold;
}

/* 사이드바 섹션 구분 */
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

/* 리스트 스타일 초기화 */
.sidebar-list {
	list-style: none;
	padding: 0;
	margin: 0;
}

/* 리스트 아이템 */
.sidebar-list li {
	margin: 5px 0;
	padding: 8px 12px;
	border-radius: 6px;
	cursor: pointer;
	transition: background-color 0.2s;
	font-size: 16px;
}

/* 활성화/호버 시 */
.sidebar-list li.active,
.sidebar-list li:hover {
	background-color: #f8f9fa;
	color: #1abc9c;
	font-weight: bold;
}

/* 뱃지 스타일 */
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

/* 링크 스타일 */
.sidebar-link {
	display: block;
	width: 100%;
	height: 100%;
	color: inherit;
	text-decoration: none;
}
.sidebar-link:visited,
.sidebar-link:active {
	color: inherit;
}

/* 리스트 아이템 내부 링크 활성/호버 시 */
.sidebar-list li.active .sidebar-link,
.sidebar-list li:hover .sidebar-link {
	color: #1abc9c !important;
	font-weight: bold;
	background-color: #e0f7f4 !important;
	border-radius: 6px;
}
/* 작은 버튼(예: .file-list-actions button, .search-btn 등)에 민트색 적용 */
.file-list-actions button,
.search-btn,
.tree-btn,
.file-item .remove-btn,
.add-assignee-btn,
.assignee-tag .remove-assignee-btn {
	background: #1abc9c !important;
	color: #fff !important;
	border: none !important;
}
.file-list-actions button:hover,
.search-btn:hover,
.tree-btn:hover,
.file-item .remove-btn:hover,
.add-assignee-btn:hover,
.assignee-tag .remove-assignee-btn:hover {
	background: #159c86 !important;
	color: #fff !important;
}
/* 모달 스타일 */
.modal-overlay {
	display: none;
	position: fixed;
	z-index: 1000;
	left: 0;
	top: 0;
	width: 100%;
	height: 100%;
	background-color: rgba(0,0,0,0.5);
}

.modal-content {
	background-color: white;
	margin: 5% auto;
	padding: 20px;
	border-radius: 8px;
	width: 80%;
	max-width: 600px;
	max-height: 80vh;
	overflow-y: auto;
	position: relative;
}

.modal-close {
	position: absolute;
	top: 10px;
	right: 15px;
	font-size: 24px;
	font-weight: bold;
	cursor: pointer;
	color: #aaa;
}

.modal-close:hover {
	color: #000;
}
	.status {
		display: inline-block;
		padding: 4px 12px;
		border-radius: 8px;
		font-size: 12px;
		font-weight: 500;
		color: #fff;

	}
	/* 등록됨 */
	.status[data-status="등록됨"] {
		background-color: #f0ad4e;
	}

	/* 처리중 & 검토중 */
	.status[data-status="처리중"],
	.status[data-status="검토중"] {
		background-color: #5bc0de;
	}

	/* 처리완료 & 검토완료 */
	.status[data-status="처리완료"],
	.status[data-status="검토완료"] {
		background-color: #5cb85c;
	}

	/* 반려 */
	.status[data-status="반려"] {
		background-color: #d9534f;
	}
</style>
</head>
<body>

<%@ include file="../common/nav.jsp" %>	<main>
	<div>
		<div class="container">
			<div class="sidebar">
				<h3>업무관리</h3>
				<div class="sidebar-section">
					<div class="sidebar-section-title">나의 할 일</div>
					<ul class="sidebar-list">
						<li class="${detail.type=='todo' ? 'active' : ''}"><a href="/task/todo" class="sidebar-link">할 일 목록</a></li>
					</ul>
				</div>
				<div class="sidebar-section">
					<div class="sidebar-section-title">업무 요청</div>
					<ul class="sidebar-list">
						<li class="${detail.type=='request' && role=='writer' ? 'active' : ''}"><a href="/task/request/writer" class="sidebar-link">내가 한 업무 요청</a></li>
						<li class="${detail.type=='request' && role=='receive' ? 'active' : ''}"><a href="/task/request/receive" class="sidebar-link">수신 업무 요청</a></li>
						<li class="${detail.type=='request' && role=='cc' ? 'active' : ''}"><a href="/task/request/cc" class="sidebar-link">참조 업무 요청</a></li>
					</ul>
				</div>
				<div class="sidebar-section">
					<div class="sidebar-section-title">업무 보고</div>
					<ul class="sidebar-list">
						<li class="${detail.type=='report' && role=='writer' ? 'active' : ''}"><a href="/task/report/writer" class="sidebar-link">내가 한 업무 보고</a></li>
						<li class="${detail.type=='report' && role=='receive' ? 'active' : ''}"><a href="/task/report/receive" class="sidebar-link">수신 업무 보고</a></li>
						<li class="${detail.type=='report' && role=='cc' ? 'active' : ''}"><a href="/task/report/cc" class="sidebar-link">참조 업무 보고</a></li>
					</ul>
				</div>
			</div>

			<!-- 기능 페이지 -->
			<div class="main-content">
				<h2 id="page-title">
					<c:choose>
						<c:when test="${detail.type == 'todo'}">
							<h2 id="page-title">나의 할 일 조회</h2>
						</c:when>
						<c:when test="${detail.type == 'request'}">
							<h2 id="page-title">업무 요청 조회</h2>
						</c:when>
						<c:when test="${detail.type == 'report'}">
							<h2 id="page-title">업무 보고 조회</h2>
						</c:when>
					</c:choose>
				</h2>

				<div class="task-detail-box">
					<table class="detail-table">
						<colgroup>
							<col style="width: 140px;">
							<col style="width: 25%;">
							<col style="width: 140px;">
							<col style="width: 25%;">
							<col style="width: 10%;">
						</colgroup>
						<tbody>
							<tr>
								<th>제목</th>
								<td colspan="2">${detail.title}</td>
								<th>상태</th>
								<td><span class="status status-todo" data-status="${detail.status}">${detail.status}</span></td>
							</tr>
							<tr id="normal-row">
								<th>등록자</th>
								<td colspan="4">${detail.writerName} ${detail.writerPositionName}</td>
							</tr>
							<tr>
								<th>등록일</th>
								<td colspan="4"><fmt:formatDate value="${detail.createdDate}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
							</tr>
							<tr>
								<th>수정일</th>
								<td colspan="4"><fmt:formatDate value="${detail.updatedDate}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
							</tr>
							<tr>
								<th>마감일</th>
								<td colspan="4">${detail.dueDate}</td>
							</tr>
							<tr id="receiver-row">
								<th>수신자</th>
								<td colspan="4">${detail.receiveUserName} ${detail.receiveUserPositionName}</td>
							</tr>
							<tr id="reference-row">
								<th>참조자</th>
<%--								<c:forEach var="cc" items="${detail.ccs}">--%>
<%--									<td colspan="4">(${cc.name} ${cc.positionName})</td>--%>
<%--								</c:forEach>--%>
								<td colspan="4">
									<c:choose>
										<c:when test="${not empty detail.ccs}">
											<c:forEach var="cc" items="${detail.ccs}" varStatus="status">
												${cc.name} ${cc.positionName}<c:if test="${!status.last}">, </c:if>
											</c:forEach>
										</c:when>
										<c:otherwise>
										</c:otherwise>
									</c:choose>
								</td>
							</tr>
							<tr>
								<th>내용</th>
								<td colspan="4">${detail.content}</td>
							</tr>
							<tr>
								<th>등록자 첨부파일</th>
								<td colspan="4">
									<c:choose>
										<c:when test="${not empty detail.writerFiles}">
											<ul class="list-unstyled mb-0">
												<c:forEach var="file" items="${detail.writerFiles}">
													<li>
														<a href="/task/download?fileId=${file.fileId}">${file.originalName}</a>
													</li>
												</c:forEach>
											</ul>
										</c:when>
										<c:otherwise>
										</c:otherwise>
									</c:choose>
								</td>

							</tr>
							<tr>
								<th>수신자 첨부파일</th>
								<td colspan="4">
									<c:choose>
										<c:when test="${not empty detail.feedbackFiles}">
											<ul class="list-unstyled mb-0">
												<c:forEach var="file" items="${detail.feedbackFiles}">
													<li>
														<a href="/task/download?fileId=${file.fileId}">${file.originalName}</a>
													</li>
												</c:forEach>
											</ul>
										</c:when>
										<c:otherwise>
										</c:otherwise>
									</c:choose>
								</td>

							</tr>
						</tbody>
					</table>
				</div>
				<div>
					<c:if test='${!detail.type.equals("todo")}'>
					<c:if test='${role.equals("receive")}'>
					<!-- 수신자만 표시되는는 업무 처리 내역	-->
					<div id="feedback-section" class="feedback-section">
						<form enctype="multipart/form-data" method="post">
						<input hidden="hidden" name="receiveUserId" value="${detail.receiveUserId}" />
						<input hidden="hidden" name="taskId" value="${detail.taskId}" />

							<div class="feedback -header">
							<span>처리내역</span>
						</div>
						<div class="feedback-table-wrap">
							<table class="feedback-table">
								<colgroup>
									<col style="width: 140px;">
									<col>
									<col style="width: 140px;">
								</colgroup>
								<tbody>
									<tr>
										<th>수신자</th>
										<td>${detail.receiveUserName} ${detail.receiveUserPositionName}</td>
										<th>수정일</th>
										<td><fmt:formatDate value="${feedback.updatedDate}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
									</tr>
										<tr>
											<th>진행률</th>
											<td colspan="3">
												<div class="btn-group gap-3" role="group" aria-label="진척률 선택">
													<input
															type="radio"
															class="btn-check"
															name="progressPercent"
															id="progress0"
															value="0"
															<c:if test="${feedback.progressPercent == 0}">checked</c:if>
													/>
													<label class="btn btn-outline-success progress-btn" for="progress0">0%</label>

													<input
															type="radio"
															class="btn-check"
															name="progressPercent"
															id="progress20"
															value="20"
															<c:if test="${feedback.progressPercent == 20}">checked</c:if>
													/>
													<label class="btn btn-outline-success progress-btn" for="progress20">20%</label>

													<input
															type="radio"
															class="btn-check"
															name="progressPercent"
															id="progress40"
															value="40"
															<c:if test="${feedback.progressPercent == 40}">checked</c:if>
													/>
													<label class="btn btn-outline-success progress-btn" for="progress40">40%</label>

													<input
															type="radio"
															class="btn-check"
															name="progressPercent"
															id="progress60"
															value="60"
															<c:if test="${feedback.progressPercent == 60}">checked</c:if>
													/>
													<label class="btn btn-outline-success progress-btn" for="progress60">60%</label>

													<input
															type="radio"
															class="btn-check"
															name="progressPercent"
															id="progress80"
															value="80"
															<c:if test="${feedback.progressPercent == 80}">checked</c:if>
													/>
													<label class="btn btn-outline-success progress-btn" for="progress80">80%</label>

													<input
															type="radio"
															class="btn-check"
															name="progressPercent"
															id="progress100"
															value="100"
															<c:if test="${feedback.progressPercent == 100}">checked</c:if>
													/>
													<label class="btn btn-outline-success progress-btn" for="progress100">100%(완료)</label>
												</div>
											</td>
										</tr>
									<tr>
										<th>업무 코멘트</th>
										<td colspan="3">
											<textarea name="comment" class="task-memo" rows="4" placeholder="업무 코멘트를 입력하세요.">${feedback.comment}</textarea>
											<button type="button"
													id="add-feedback-attachment-btn"
													class="add-attachment-btn">
												로컬 파일 선택+
											</button>

											<!-- 2) 문서함 파일 모달 열기 -->
											<button type="button"
													id="open-feedback-file-modal"
													class="add-receive-btn">
												문서함 파일 선택+
											</button>

											<!-- 입력된 로컬 파일 필드 -->
											<div id="feedback-attachments-group"></div>
											<!-- 선택된 문서함 파일 태그 -->
											<div id="feedback-selected-file-list" class="receive-list"></div>
										</td>
									</tr>
									
								</tbody>
							</table>
						</div>
						<button class="feedback-btn-main" formaction="/task/feedback/${detail.taskId}">저장</button>
						<button class="feedback-btn-main" formaction="/task/reject/${detail.taskId}">반려</button>
						</form>
					</div>
					</c:if>
					<c:if test='${!role.equals("receive")}'>
						<!-- 수신자아니면 표시되는 업무 처리 내역	-->
						<div id="feedback-section" class="feedback-section">
							<form enctype="multipart/form-data">
								<input hidden="hidden" name="receiveUserId" value="${detail.receiveUserId}" />
								<fieldset disabled>
								<div class="feedback -header">
									<span>처리내역</span>
								</div>
								<div class="feedback-table-wrap">
									<table class="feedback-table">
										<colgroup>
											<col style="width: 140px;">
											<col>
											<col style="width: 140px;">
										</colgroup>
										<tbody>
										<tr>
											<th>수신자</th>
											<td>${detail.receiveUserName} ${detail.receiveUserPositionName}</td>
											<th>수정일</th>
											<td><fmt:formatDate value="${feedback.updatedDate}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
										</tr>
										<c:if test='${detail.type.equals("request")}'>
											<tr>
												<th>진척률</th>
												<td colspan="3">
													<div class="btn-group gap-3" role="group">
														${feedback.progressPercent} %
													</div>
												</td>
											</tr>

										</c:if>
										<tr>
											<th>업무 코멘트</th>
											<td colspan="3">
												<textarea name="comment" class="task-memo" rows="4">${feedback.comment}</textarea>

												<!-- 입력된 로컬 파일 필드 -->
												<div id="feedback-attachments-group"></div>
												<!-- 선택된 문서함 파일 태그 -->
												<div id="feedback-selected-file-list" class="receive-list"></div>
											</td>
										</tr>

										</tbody>
									</table>
								</div>

								</fieldset>
							</form>
						</div>
					</c:if>
						<div id="button-section" class="feedback-actions">
							<c:if test='${role.equals("writer") && detail.status.equals("반려")}'>
								<button onclick="location.href='/task/form'">새 업무 등록</button>
							</c:if>
							</c:if>
							<c:if test='${detail.type.equals("todo")}'>
								<form method="post" action="/task/todo/complete/${detail.taskId}" style="display:inline;">
									<button class="btn search-btn" type="submit">완료</button>
								</form>
							</c:if>
							<c:choose>
								<c:when test="${detail.type == 'todo'}">
									<a class="btn search-btn"
									   href="/task/todo">
										목록
									</a>
								</c:when>

								<c:otherwise>
									<a class="btn search-btn"
									   href="/task/${detail.type}/${role}">
										목록
									</a>
								</c:otherwise>
							</c:choose>
						</div>
					</div>
				</div>
			</div>
	</div>

	</main>
	<!-- 파일 선택 모달 -->
	<div id="file-target-modal" class="modal-overlay" style="display:none;">
		<div class="modal-content">
			<span class="modal-close" id="close-file-target-modal">&times;</span>
			<h3>문서함 파일 선택</h3>
			<ul class="org-tree" id="file-target-list">
				<!-- openFileModal()이 여기로 데이터를 뿌림 -->
			</ul>
		</div>
	</div>
<%@ include file="../common/footer.jsp" %>

	<script>
		// 1) 파일 한 건을 li 엘리먼트로 만들어 주는 헬퍼
		function generateFileHtml(file) {
			const ownerType = file.ownerType === "personal" ? "개인" : "부서";
			return `
      <li class="org-emp file-item"
          data-file-id="\${file.fileId}"
          data-original-name="\${file.originalName}">
        (\${ownerType}) [\${file.categoryName}] \${file.originalName} (\${file.size} byte)
      </li>`;
		}

		// 2) 모달 열기: /task/api/file 에서 리스트를 불러와 #file-target-list 에 뿌리고 보여준다
		function openFileModal() {
			$.getJSON('/task/api/file')
					.done(function(result) {
						const files = Array.isArray(result.data) ? result.data : [];
						const html  = files.map(generateFileHtml).join('');
						$('#file-target-list').html(html);
						$('#file-target-modal').fadeIn(100);
					})
					.fail(function() {
						alert('파일 목록을 불러오는 중 오류가 발생했습니다.');
					});
		}

		// 3) 모달 닫기
		function closeFileModal() {
			$('#file-target-modal').fadeOut(100);
		}

		// 4) 모달 내 파일 클릭 시 선택 태그를 listSelector 컨테이너에 추가
		function setupFileSelection(treeSelector, listSelector, inputName, modalSelector) {
			$(treeSelector)
					.off('click')
					.on('click', '.file-item', function() {
						const fileId   = $(this).data('file-id');
						const filename = $(this).data('original-name');
						// 중복 방지
						if ($(listSelector + " input[value='" + fileId + "']").length) {
							closeFileModal();
							return;
						}
						const $tag = $(`
          <span class="receive-tag" data-file-id="\${fileId}">
            \${filename}
            <button type="button" class="remove-receive-btn">×</button>
            <input type="hidden" name="existingFeedbackFileIds" value="\${fileId}">
          </span>`);
						$tag.find('.remove-receive-btn').on('click', () => $tag.remove());
						$(listSelector).append($tag);
						closeFileModal();
					});
		}

		// 5) DOM Ready 시 실제 버튼들에 바인딩
		$(function(){
			// 로컬 파일 추가
			$('#add-feedback-attachment-btn').on('click', function(){
				const $row = $(`
        <div class="attachment-row mt-2 input-group">
          <input type="file" name="localFeedbackFiles" class="form-control" multiple>
          <button class="btn btn-outline-danger remove-attachment-btn" type="button">−</button>
        </div>`);
				$('#feedback-attachments-group').append($row);
			});

			// 문서함 모달 열기
			$('#open-feedback-file-modal').on('click', openFileModal);

			// 모달 닫기 (× 버튼에도 id="close-file-target-modal" 부여하세요)
			$('#close-file-target-modal').on('click', closeFileModal);

			// 모달 내 파일 선택 로직
			setupFileSelection(
					'#file-target-list',             // 모달 안 ul 리스트
					'#feedback-selected-file-list',  // 선택된 파일을 붙일 컨테이너
					'existingFeedbackFileIds',       // 서버로 넘길 파라미터 이름
					'#file-target-modal'             // 모달 자체 셀렉터
			);

			// 삭제 버튼 (로컬 입력 + 문서함 둘 다)
			$('#feedback-attachments-group, #feedback-selected-file-list')
					.on('click', '.remove-attachment-btn, .remove-receive-btn', function(){
						$(this).closest('.attachment-row, .receive-tag').remove();
					});
		});
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
