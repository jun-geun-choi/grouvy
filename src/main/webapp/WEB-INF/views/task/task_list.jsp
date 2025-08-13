	<%@ page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ include file="../common/taglib.jsp" %>

	<!DOCTYPE html>
	<html lang="ko">
	<head>
	<meta charset="UTF-8">
	<title>업무 관리</title>
	<link
		href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
		rel="stylesheet">
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

	.filters {
		display: flex;
		align-items: center;
		gap: 10px;
		margin-bottom: 20px;
		flex-wrap: wrap;
		justify-content: flex-start;
	}

	.filters label {
		font-size: 14px;
		color: #333;
		margin-right: 4px;
	}

	.filters input[type="date"], .filters select, .filters input[type="text"] {
		padding: 6px 10px;
		border-radius: 4px;
		border: 1px solid #ccc;
		font-size: 14px;
		margin-right: 4px;
	}



	.task-table {
		width: 100%;
		border-collapse: collapse;
		background: #fff;
		border-radius: 8px;
		overflow: hidden;
		box-shadow: 0 2px 8px rgba(0,0,0,0.1);
		margin-bottom: 20px;
	}

	.task-table th, .task-table td {
		padding: 12px 8px;
		text-align: center;
		border-bottom: 1px solid #e2e8f0;
		font-size: 14px;
	}

	.task-table th {
		background: #f7c873;
		color: #333;
		font-weight: 600;
	}

	.task-table tr:last-child td {
		border-bottom: none;
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

	.pagination button {
		background: #fff;
		border: 1px solid #ccc;
		color: #333;
		border-radius: 4px;
		padding: 6px 12px;
		font-size: 14px;
		cursor: pointer;
		transition: background 0.15s;
	}

	.pagination button:disabled {
		color: #ccc;
		border-color: #e2e8f0;
		background: #f5f5f5;
		cursor: default;
	}

	.pagination .current {
		background: #e6002d;
		color: #fff;
		border-radius: 50%;
		padding: 6px 14px;
		font-weight: bold;
		font-size: 14px;
	}

	.action-buttons {
		display: flex;
		gap: 10px;
		justify-content: flex-end;
	}

	.register-btn:hover {
		background-color: #45a049;
	}

	.delete-btn {
		background-color: #f44336;
		color: #fff;
		border: none;
		padding: 8px 18px;
		border-radius: 4px;
		font-size: 14px;
		cursor: pointer;
	}

	.delete-btn:hover {
		background-color: #da190b;
	}

	.action-buttons button {
		padding: 8px 16px;
		border: none;
		border-radius: 4px;
		cursor: pointer;
		font-size: 14px;
		background-color: #ccc;
		color: #333;
	}

	.action-buttons button:hover {
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
	.process-btn-main,
	.progress-btn {
	  background: #1abc9c !important;
	  color: #fff !important;
	  border: none !important;
	}
	button:hover,
	.related-btn:hover,
	.process-btn-main:hover,
	.progress-btn:hover {
	  background: #159c86 !important;
	  color: #fff !important;
	}

	/* 테이블 헤더 흰색 */
	th, thead, .table thead th, .file-table th, .detail-table th, .process-table th {
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
	</style>
	</head>
	<body>

	<%@ include file="../common/nav.jsp" %>
		<main>
			<div class="container">
				<div class="sidebar">
					<h3>업무관리</h3>
					<div class="sidebar-section">
						<div class="sidebar-section-title">나의 할 일</div>
						<ul class="sidebar-list">
							<li class="${type=='todo' ? 'active' : ''}"><a href="/task/todo" class="sidebar-link">할 일 목록</a></li>
						</ul>
					</div>
					<div class="sidebar-section">
						<div class="sidebar-section-title">업무 요청</div>
						<ul class="sidebar-list">
							<li class="${type=='request' && role=='writer' ? 'active' : ''}"><a href="/task/request/writer" class="sidebar-link">내가 한 업무 요청</a></li>
							<li class="${type=='request' && role=='receive' ? 'active' : ''}"><a href="/task/request/receive" class="sidebar-link">수신 업무 요청</a></li>
							<li class="${type=='request' && role=='cc' ? 'active' : ''}"><a href="/task/request/cc" class="sidebar-link">참조 업무 요청</a></li>
						</ul>
					</div>
					<div class="sidebar-section">
						<div class="sidebar-section-title">업무 보고</div>
						<ul class="sidebar-list">
							<li class="${type=='report' && role=='writer' ? 'active' : ''}"><a href="/task/report/writer" class="sidebar-link">내가 한 업무 보고</a></li>
							<li class="${type=='report' && role=='receive' ? 'active' : ''}"><a href="/task/report/receive" class="sidebar-link">수신 업무 보고</a></li>
							<li class="${type=='report' && role=='cc' ? 'active' : ''}"><a href="/task/report/cc" class="sidebar-link">참조 업무 보고</a></li>
						</ul>
					</div>
				</div>

				<!-- 기능 페이지 -->
				<div class="main-content">
					<h2>
						<c:choose>
							<c:when test="${role=='writer'}">내가 한 </c:when>
							<c:when test="${role=='receive'}">수신</c:when>
							<c:otherwise>참조</c:otherwise>
						</c:choose>
						<c:choose>
							<c:when test="${type=='request'}">업무 요청</c:when>
							<c:otherwise>업무 보고</c:otherwise>
						</c:choose>
					</h2>
					
<%--					<div class="filters">--%>

<%--						<label><input type="checkbox" checked> 등록됨</label>--%>
<%--						<label><input type="checkbox" checked> 처리중</label>--%>
<%--						<label><input type="checkbox" checked> 처리완료</label>--%>
<%--						<label><input type="checkbox" checked> 반려</label>--%>
<%--						<select>--%>
<%--							<option>등록일</option>--%>
<%--							<option>마감일</option>--%>
<%--						</select>--%>
<%--						<input type="date" value="2025-04-08"> ~--%>
<%--						<input type="date" value="2025-07-07">--%>
<%--						<input type="text" placeholder="제목">--%>
<%--						<button class="search-btn">검색</button>--%>
<%--					</div>--%>
					<form method="post" action="/task/delete">
						<input type="hidden" name="redirectUrl" value="${redirectUrl}" />
					<table class="task-table">
						<colgroup>
							<col style="width: 5%;">
							<col style="width: 20%;">
							<col style="width: 15%;">
							<col style="width: 15%;">
							<col style="width: 15%;">
							<col style="width: 15%;">
							<col style="width: 10%;">
						</colgroup>
						<thead>
							<tr>
								<th><input type="checkbox"></th>
								<th>제목</th>
								<th>등록자</th>
								<th>수신자</th>
								<th>등록일</th>
								<th>마감일</th>
								<th>상태</th>
							</tr>
						</thead>
						<tbody>
						<fmt:formatDate
								value="${now}"
								pattern="yyyyMMdd"
								timeZone="Asia/Seoul"
								var="today" />
						<c:forEach var="task" items="${taskList}">
							<tr>
								<td><input type="checkbox" name="taskIds" value="${task.taskId}"></td>
								<td>
									<a href="<c:url value='/task/detail/${task.taskId}'/>"
									   class="text-decoration-none text-dark">
											${task.title}
									</a>
								</td>
								<td>${task.writerName} ${task.writerPositionName}</td>
								<td>${task.receiveUserName} ${task.receiveUserPositionName}</td>
								<td>
									<fmt:formatDate
											value="${task.createdDate}"
											pattern="yyyyMMdd"
											timeZone="Asia/Seoul"
											var="taskDate" />

									<c:choose>
										<c:when test="${taskDate == today}">
											<fmt:formatDate
													value="${task.createdDate}"
													pattern="HH:mm"
													timeZone="Asia/Seoul" />
										</c:when>
										<c:otherwise>
											<fmt:formatDate
													value="${task.createdDate}"
													pattern="yyyy-MM-dd"
													timeZone="Asia/Seoul" />
										</c:otherwise>
									</c:choose>
								</td>
								<td>${task.dueDate}</td>
								<td><span class="status" data-status="${task.status}">${task.status}</span></td>
							</tr>
						</c:forEach>

						</tbody>
					</table>


					<div class="action-buttons">
						<a href="/task/form" class="btn search-btn">업무 등록</a>
						<c:if test="${role=='writer'}">
							<button class="search-btn" >삭제</button>
						</c:if>

					</div>
					</form>
				</div> 
			</div>

		</main>

	<%@ include file="../common/footer.jsp" %>
	<script>
		// DOMContentLoaded 로 감싸서 페이지 로딩 뒤 실행
		document.addEventListener('DOMContentLoaded', function() {
			const table = document.querySelector('.task-table');
			if (!table) return;

			// 1) thead 체크박스
			const theadCheckbox = table.querySelector('thead input[type="checkbox"]');
			const tbody = table.querySelector('tbody');

			// 전체 선택 / 해제
			if (theadCheckbox) {
				theadCheckbox.addEventListener('change', () => {
					const rowCbs = tbody.querySelectorAll('input[type="checkbox"]');
					rowCbs.forEach(cb => {
						cb.checked = theadCheckbox.checked;
						const tr = cb.closest('tr');
						if (tr) {
							tr.classList.toggle('selected-row', cb.checked);
						}
					});
				});
			}

			// 2) tbody 체크박스: 개별 선택 시 highlight, 그리고 전체 체크박스 동기화
			tbody.addEventListener('change', function(e) {
				if (e.target.matches('input[type="checkbox"]')) {
					const tr = e.target.closest('tr');
					if (tr) {
						tr.classList.toggle('selected-row', e.target.checked);
					}
					// 하나라도 해제되면 thead 해제
					if (!e.target.checked && theadCheckbox && theadCheckbox.checked) {
						theadCheckbox.checked = false;
					}
					// 모두 선택되면 thead 체크
					const allCbs = tbody.querySelectorAll('input[type="checkbox"]');
					if (theadCheckbox && allCbs.length > 0) {
						const allChecked = Array.from(allCbs).every(cb => cb.checked);
						theadCheckbox.checked = allChecked;
					}
				}
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
