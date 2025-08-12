<%@ page language="java" contentType="text/html;charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ include file="../common/taglib.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>업무 등록</title>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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

.task-form {
	background: #fff;
	border-radius: 8px;
	box-shadow: 0 2px 8px rgba(0,0,0,0.1);
	padding: 20px;
	margin-bottom: 20px;
}

.form-row {
	display: flex;
	align-items: center;
	margin-bottom: 16px;
	border-bottom: 1px solid #e0e0e0;
	padding-bottom: 12px;
}
.form-row:last-child {
	border-bottom: none;
}
.form-label {
	width: 120px;
	min-width: 100px;
	font-weight: bold;
	margin-right: 16px;
	text-align: left;
}
.form-input, .form-row > *:not(.form-label) {
	flex: 1;
	display: flex;
	align-items: center;
	justify-content: flex-start;
	gap: 0;
}
.form-input label {
	margin-right: 18px;
}

.form-group {
	margin-bottom: 15px;
	text-align: left;
}

.form-group label {
	display: block;
	margin-bottom: 5px;
	font-weight: 600;
	color: #333;
}

.form-group input, .form-group select, .form-group textarea {
	width: 100%;
	padding: 8px 12px;
	border: 1px solid #ccc;
	border-radius: 4px;
	font-size: 14px;
}

.form-group textarea {
	resize: vertical;
	min-height: 100px;
}

.form-actions {
	display: flex;
	gap: 10px;
	justify-content: flex-end;
	margin-top: 20px;
}

.btn-primary {
	background-color: #4CAF50;
	color: #fff;
	border: none;
	padding: 8px 18px;
	border-radius: 4px;
	font-size: 14px;
	cursor: pointer;
}

.btn-primary:hover {
	background-color: #45a049;
}

.btn-secondary {
	background-color: #ccc;
	color: #333;
	border: none;
	padding: 8px 18px;
	border-radius: 4px;
	font-size: 14px;
	cursor: pointer;
}

.btn-secondary:hover {
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
.attachment-row {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-top: 6px;
}
.remove-attachment-btn, .add-attachment-btn {
  padding: 2px 8px;
  font-size: 16px;
  background: #eee;
  border: 1px solid #ccc;
  border-radius: 4px;
  cursor: pointer;
}
.remove-attachment-btn:hover, .add-attachment-btn:hover {
  background: #ffdddd;
  border-color: #ff8888;
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

/* 조직도 트리 스타일 */
.org-tree, .org-tree ul {
	list-style: none;
	margin: 0;
	padding-left: 18px;
	position: relative;
}

.org-tree ul {
	border-left: 1.5px solid #d0d6e1;
}

.org-tree > li {
	margin-bottom: 8px;
	padding-left: 0;
}

.org-dept {
	font-weight: 600;
	cursor: pointer;
	display: flex;
	align-items: center;
	gap: 4px;
	margin: 2px 0;
	color: #2a3a5a;
	border-radius: 4px;
	transition: background 0.15s;
	padding: 2px 0 2px 2px;
}

.org-dept .tree-toggle {
	font-size: 1.1em;
	color: #888;
	margin-right: 2px;
	user-select: none;
	width: 1em;
	display: inline-block;
	text-align: center;
}

.org-dept:hover {
	background: #f0f4fa;
}

.org-emp {
	margin: 2px 0 2px 0;
	padding-left: 8px;
	color: #333;
	cursor: pointer;
	border-radius: 4px;
	transition: background 0.15s;
	font-weight: 400;
	display: block;
}

.org-emp:hover {
	background: #e3e7f0;
}
.share-checkbox-row {
	display: flex;
	align-items: center;
	gap: 8px;
	margin-left: 18px;
	margin-top: 4px;
	justify-content: flex-start;
}
.share-check-label {
	margin: 0;
	font-weight: 400;
	font-size: 15px;
	line-height: 1.2;
}
.share-setting-group {
	text-align: left !important;
	margin-bottom: 20px;
}
.share-setting-label {
	font-weight: bold;
	display: block;
	margin-bottom: 2px;
}
.form-check-input {
	margin-top: 0;
	margin-right: 6px;
}
.custom-share-check {
	display: flex !important;
	align-items: center;
	width: auto !important;
	padding: 0 !important;
	background: none !important;
	border: none !important;
}
.custom-share-check .form-check-input {
	width: 18px !important;
	height: 18px !important;
	min-width: 0 !important;
	flex: none !important;
	margin: 0 8px 0 0 !important;
}
.custom-share-check .form-check-label {
	margin: 0 !important;
	font-weight: 400;
	font-size: 15px;
	line-height: 1.2;
}
.box-type-group {
	text-align: left !important;
	margin-bottom: 20px;
}
.box-type-label {
	font-weight: bold;
	display: block;
	margin-bottom: 2px;
}
.box-type-row {
	display: flex;
	align-items: center;
	gap: 18px;
	margin-left: 2px;
	margin-top: 4px;
	justify-content: flex-start;
}
.custom-box-type-check {
	display: flex !important;
	align-items: center;
	width: auto !important;
	padding: 0 !important;
	background: none !important;
	border: none !important;
}
.custom-box-type-check .form-check-input {
	width: 18px !important;
	height: 18px !important;
	min-width: 0 !important;
	flex: none !important;
	margin: 0 8px 0 0 !important;
}
.custom-box-type-check .form-check-label {
	margin: 0 !important;
	font-weight: 400;
	font-size: 15px;
	line-height: 1.2;
}
.add-related-btn {
  padding: 2px 8px;
  font-size: 16px;
  background: #eee;
  border: 1px solid #ccc;
  border-radius: 4px;
  cursor: pointer;
  margin-left: 6px;
}
.add-related-btn:hover {
  background: #ffdddd;
  border-color: #ff8888;
}
.due-date-row {
  display: flex;
  align-items: center;
  gap: 10px;
}
.due-date-checkbox {
  font-size: 13px;
  color: #666;
  margin-left: 6px;
  display: flex;
  align-items: center;
}
.due-date-row input[type="date"] {
  margin-bottom: 0;
}
.due-date-checkbox input[type="checkbox"] {
  width: 14px;
  height: 14px;
  margin-right: 3px;
}
#employee-list { list-style:none; padding:0; margin:0 0 16px 0; }
#employee-list li { padding:8px 0; cursor:pointer; border-bottom:1px solid #eee; }
#employee-list li:last-child { border-bottom:none; }
#employee-list li:hover { background:#f0f0f0; font-weight:bold; }
.add-receive-btn {
  padding: 2px 8px;
  font-size: 16px;
  background: #eee;
  border: 1px solid #ccc;
  border-radius: 4px;
  cursor: pointer;
  margin-left: 6px;
}
.add-receive-btn:hover {
  background: #ffdddd;
  border-color: #ff8888;
}
.receive-list {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  min-height: 32px;
}
.receive-tag {
  display: flex;
  align-items: center;
  background: #f3f3f3;
  border: 1px solid #ccc;
  border-radius: 16px;
  padding: 4px 12px 4px 10px;
  font-size: 15px;
}
.receive-tag .remove-receive-btn {
  margin-left: 6px;
  background: none;
  border: none;
  color: #d00;
  font-size: 16px;
  cursor: pointer;
  padding: 0 4px;
}
.receive-tag .remove-receive-btn:hover {
  color: #fff;
  background: #d00;
  border-radius: 50%;
}
.related-task-list {
  display: flex;
  flex-direction: column;
  gap: 6px;
  align-items: flex-start;
  width: 100%;
}
.related-task-tag {
  display: flex;
  align-items: center;
  background: #f2f2f2;
  border-radius: 4px;
  padding: 4px 8px;
  margin-bottom: 0;
  font-size: 14px;
  width: 100%;
  justify-content: flex-start;
}
.remove-related-task-btn {
  margin-left: 8px;
  background: #e57373;
  color: #fff;
  border: none;
  border-radius: 2px;
  cursor: pointer;
  font-size: 14px;
  padding: 0 6px;
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
.add-receive-btn,
.receive-tag .remove-receive-btn {
	background: #1abc9c !important;
	color: #fff !important;
	border: none !important;
}
.file-list-actions button:hover,
.search-btn:hover,
.tree-btn:hover,
.file-item .remove-btn:hover,
.add-receive-btn:hover,
.receive-tag .remove-receive-btn:hover {
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
						<li><a href="/task/todo" class="sidebar-link">할 일 목록</a></li>
					</ul>
				</div>
				<div class="sidebar-section">
					<div class="sidebar-section-title">업무 요청</div>
					<ul class="sidebar-list">
						<li class=""><a href="/task/request/writer" class="sidebar-link">내가 한 업무 요청</a></li>
						<li class=""><a href="/task/request/receive" class="sidebar-link">수신 업무 요청</a></li>
						<li class=""><a href="/task/request/cc" class="sidebar-link">참조 업무 요청</a></li>
					</ul>
				</div>
				<div class="sidebar-section">
					<div class="sidebar-section-title">업무 보고</div>
					<ul class="sidebar-list">
						<li class=""><a href="/task/report/writer" class="sidebar-link">내가 한 업무 보고</a></li>
						<li class=""><a href="/task/report/receive" class="sidebar-link">수신 업무 보고</a></li>
						<li class=""><a href="/task/report/cc" class="sidebar-link">참조 업무 보고</a></li>
					</ul>
				</div>
			</div>
			<!-- 기능 페이지 -->
			<fmt:formatDate value="${now}" pattern="yyyy-MM-dd" var="todayDate"/>
			<div class="main-content">
				<h2>업무 등록</h2>

				<form method="post" enctype="multipart/form-data" class="upload-form" action="/task/">
				<div class="task-form">
					<div class="form-row">
						<label class="form-label">업무 유형</label>
						<div class="form-input">
							<label><input type="radio" name="type" value="todo"> 나의 할 일</label>
							<label><input type="radio" name="type" value="request"> 업무 요청</label>
							<label><input type="radio" name="type" value="report"> 업무 보고</label>
						</div>
					</div>
					<div class="form-row">
						<label class="form-label" for="title">제목</label>
						<input required type="text" id="title" name="title" class="form-input" placeholder="제목을 입력하세요.">
					</div>
					<div class="form-row">
						<label class="form-label" for="due-date">업무기한</label>
						<div class="due-date-row" style="flex:1;">
							<input type="date" id="due-date" name="dueDate" min="${todayDate}">
							<label class="due-date-checkbox"><input type="checkbox" id="no-due-date">업무기한X</label>
						</div>
					</div>
					<!-- 수신자 영역 -->
					<div class="form-row" id="receive-row">
						<label class="form-label" for="receive">수신자 <button type="button" id="open-receive-modal" class="add-receive-btn">+</button></label>
						<div id="receive-list" class="receive-list"></div>
					</div>

					<!-- 참조자 영역 -->
					<div class="form-row" id="cc-row">
						<label class="form-label" for="ccs">참조자 <button type="button" id="open-cc-modal" class="add-receive-btn">+</button></label>
						<div id="cc-list" class="receive-list"></div>
					</div>

					<div class="form-group">
						<label for="description">업무 내용</label>
						<textarea required id="description" name="content" placeholder="업무 내용을 입력하세요"></textarea>
					</div>
					<!-- 첨부파일 영역 -->
					<div class="form-group">
						<label for="attachments">첨부파일  
							<button type="button" id="add-attachment-btn" class="add-attachment-btn">로컬 파일 선택+</button>
							<button type="button" id="open-file-modal" class="add-receive-btn">문서함 파일 선택+</button>
							<div id="selected-file-list" class="receive-list"></div>
						</label>
						
						<div id="attachments-group">
							<!-- 첫 번째 파일 입력 필드 -->

						</div>
					</div>
					<div class="form-actions">
						<button type="button" class="btn-primary" id="saveBtn" formaction="/task/form">등록</button>
						<a class="btn search-btn"
						   href="javascript:history.back()">
							취소
						</a>
					</div>
				</div>
				</form>
			</div>
		</div>

	</main>

	<!-- 수신 대상 선택 모달 -->
	<div id="receive-target-modal" class="modal-overlay" style="display:none;">
		<div class="modal-content">
			<span class="modal-close" id="close-receive-target-modal">&times;</span>
			<h3>직원 선택(수신 대상)</h3>
			<ul class="org-tree" id="receive-target-org-tree">
				<!-- JS로 동적으로 조직도 트리 렌더링 -->
			</ul>
		</div>
	</div>

	<!-- 참조 대상 선택 모달 -->
	<div id="cc-target-modal" class="modal-overlay" style="display:none;">
		<div class="modal-content">
			<span class="modal-close" id="close-cc-target-modal">&times;</span>
			<h3>직원 선택(참조 대상)</h3>
			<ul class="org-tree" id="cc-target-org-tree">
				<!-- JS로 동적으로 조직도 트리 렌더링 -->
			</ul>
		</div>
	</div>

	<!-- 파일 선택 모달 -->
	<div id="file-target-modal" class="modal-overlay" style="display:none;">
		<div class="modal-content">
			<span class="modal-close" id="close-file-target-modal">&times;</span>
			<h3>문서함 파일 선택</h3>
			<ul class="org-tree" id="file-target-list">
				<!-- JS로 동적으로 렌더링 -->
			</ul>
		</div>
	</div>

<%@ include file="../common/footer.jsp" %>

	<script>

		// --- 공통 헬퍼 함수들 ---
		function generateEmpHtml(user) {
			return `
      <li class="org-emp"
          data-user-id="\${user.userId}"
          data-name="\${user.name}">
        \${user.departmentName} \${user.name} \${user.positionName}
      </li>`;
		}

		function openUserModal(modalSelector, treeSelector) {
			// 1) 서버에서 딱 한 번만 직원 목록 가져오기
			$.getJSON('/file/api/user-list', function(result) {
				const html = result.data.map(generateEmpHtml).join('');
				$(treeSelector).html(html);
			});
			// 2) 모달 보이기
			$(modalSelector).fadeIn(100);
		}

		function closeUserModal(modalSelector) {
			$(modalSelector).fadeOut(100);
		}

		const writerId = '${writerId}'
		function setupEmpSelection(treeSelector, listSelector, inputName, modalSelector) {
			$(treeSelector)
					.off('click')
					.on('click', '.org-emp', function() {
						const userId = $(this).data('user-id');

						// === 본인 선택 방지 ===
						if (userId == writerId) {
							alert('등록자는 본인을 수신자나 참조자로 지정할 수 없습니다.');
							return;
						}

						// 1) 수신자는 1명만
						if (listSelector === '#receive-list'
								&& $('#receive-list .receive-tag').length >= 1) {
							alert('수신자는 한 명만 지정할 수 있습니다.');
							return;
						}

						// 2) 서로 겹치면 안 됨
						if (listSelector === '#receive-list'
								&& $("#cc-list input[value='" + userId + "']").length) {
							alert('이미 참조자로 지정된 사람은 수신자로 선택할 수 없습니다.');
							return;
						}
						if (listSelector === '#cc-list'
								&& $("#receive-list input[value='" + userId + "']").length) {
							alert('이미 수신자로 지정된 사람은 참조자로 선택할 수 없습니다.');
							return;
						}

						// (기존 태그 생성 로직)
						const info = $(this).text();
						const $tag = $(`
        <span class="receive-tag" data-user-id="\${userId}">
          \${info}
          <button type="button" class="remove-receive-btn">×</button>
          <input type="hidden" name="\${inputName}" value="\${userId}">
        </span>
      `);
						$tag.find('.remove-receive-btn').on('click', () => $tag.remove());
						$(listSelector).append($tag);
						closeUserModal(modalSelector);
					});
		}

		$('#receive-list').on('click', '.remove-receive-btn', function(){
			$(this).closest('.receive-tag').remove();
		});

		// --- DOM Ready 시 설정 ---
		$(function(){
			// 수신자 모달
			$('#open-receive-modal').on('click', () => openUserModal('#receive-target-modal','#receive-target-org-tree'));
			$('#close-receive-target-modal').on('click', () => closeUserModal('#receive-target-modal'));
			setupEmpSelection(
					'#receive-target-org-tree',
					'#receive-list',
					'receiveUserId',
					'#receive-target-modal'
			);

			// 참조자 모달
			$('#open-cc-modal').on('click', () => openUserModal('#cc-target-modal','#cc-target-org-tree'));
			$('#close-cc-target-modal').on('click', () => closeUserModal('#cc-target-modal'));
			setupEmpSelection(
					'#cc-target-org-tree',
					'#cc-list',
					'ccUserIds',
					'#cc-target-modal'
			);
			// “등록” 버튼
			$('#saveBtn').on('click', function(){
				// 4-1) 업무유형
				const type = $('input[name="type"]:checked').val();
				if (!type) {
					alert('업무 유형을 선택해주세요.');
					return;
				}

				// 4-2) 제목
				const title = $('#title').val().trim();
				if (!title) {
					alert('제목을 입력해주세요.');
					$('#title').focus();
					return;
				}

				// 4-3) 업무내용
				const content = $('#description').val().trim();
				if (!content) {
					alert('업무 내용을 입력해주세요.');
					$('#description').focus();
					return;
				}

				// 이미 있던 수신자 1명 검증 (request/report 일 때)
				const rc = $('#receive-list .receive-tag').length;
				if ((type==='request' || type==='report') && rc!==1) {
					alert('수신자를 1명 지정해야 합니다.');
					return;
				}

				// 모든 검증 통과 시 폼 action 교체 후 submit
				$('form.upload-form')
						.attr('action','/task/form')
						.submit();
			});

			// “+” 버튼: 새 파일 입력 행 추가
			$('#add-attachment-btn').on('click', function(){
				const $row = $(`
      <div class="attachment-row mt-2">
        <input type="file" name="localFiles" class="form-control" multiple>
        <button type="button" class="remove-attachment-btn">−</button>
      </div>
    `);
				$('#attachments-group').append($row);
			});

			// “−” 버튼: 해당 파일 입력 행 제거
			$('#attachments-group').on('click', '.remove-attachment-btn', function(){
				$(this).closest('.attachment-row').remove();
			});
		});

// 업무기한X 체크박스에 따라 날짜 input 활성/비활성
function toggleDueDateInput() {
	var cb = document.getElementById('no-due-date');
	var dateInput = document.getElementById('due-date');
	if (cb && dateInput) {
		dateInput.disabled = cb.checked;
	}
}
document.addEventListener('DOMContentLoaded', initFormToggles);

function initFormToggles() {
	const typeRadios        = document.querySelectorAll('input[name="type"]');
	const receiveRow       = document.getElementById('receive-row');
	const ccRow             = document.getElementById('cc-row');
	const dueDateInput      = document.getElementById('due-date');
	const noDueDateCheckbox = document.getElementById('no-due-date');

	function updateFormByType() {
		const type = document.querySelector('input[name="type"]:checked').value;

		// 1) report 선택 → 업무기한 비활성화
		if (type === 'report') {
			dueDateInput.disabled      = true;
			noDueDateCheckbox.disabled = true;
		} else {
			noDueDateCheckbox.disabled = false;
			dueDateInput.disabled      = noDueDateCheckbox.checked;
		}

		// 2) todo 선택 → 수신자/참조자 숨기기
		if (type === 'todo') {
			receiveRow.style.display = 'none';
			ccRow.style.display       = 'none';
		} else {
			receiveRow.style.display = '';
			ccRow.style.display       = '';
		}
	}

	// 이벤트 바인딩
	typeRadios.forEach(r => r.addEventListener('change',  updateFormByType));
	noDueDateCheckbox.addEventListener('change', updateFormByType);

	// 초기 상태 반영
	toggleDueDateInput();
	updateFormByType();
}
		// 1) 파일 한 건의 HTML 생성
		function generateFileHtml(file) {
		let ownerType = file.ownerType === "personal" ? "개인" : "부서";
			return `
      <li class="org-emp file-item"
          data-file-id="\${file.fileId}"
          data-original-name="\${file.originalName}">
		(\${ownerType})
        [\${file.categoryName}] \${file.originalName}
        (\${file.size} byte)
      </li>`;
		}

		function openFileModal() {
			$.getJSON('/task/api/file')
					.done(function(result) {
						// result.data 에 실제 파일 배열이 들어있으니, 여기서 map
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

		// 4) 리스트 클릭 시 선택 처리 (delegate)
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
            <input type="hidden" name="existingFileIds" value="\${fileId}">
          </span>
        `);
						// 삭제 버튼
						$tag.find('.remove-receive-btn').on('click', () => $tag.remove());
						$(listSelector).append($tag);
						closeFileModal();
					});
		}

		// 5) 초기 바인딩
		$(function(){
			// 열기/닫기
			$('#open-file-modal').on('click', openFileModal);
			$('#close-file-target-modal').on('click', closeFileModal);

			// 선택 로직
			setupFileSelection(
					'#file-target-list',    // 모달 내 리스트
					'#selected-file-list',  // 선택된 파일을 담을 곳
					'existingFileIds',  // 서버로 보낼 hidden input name
					'#file-target-modal'
			);
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
