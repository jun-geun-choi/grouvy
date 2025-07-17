<%-- src/main/webapp/WEB-INF/views/notification/notification_list.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>내 알림 목록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* 제공해주신 공통 스타일 */
        body { background-color: #f7f7f7; font-family: Arial, sans-serif; margin: 0; }
        .container { display: flex; padding: 20px; max-width: 1200px; margin: 20px auto; }
        .sidebar { width: 200px; background-color: white; border-radius: 8px; padding: 15px; margin-right: 20px; box-shadow: 0 0 5px rgba(0,0,0,0.1); }
        .sidebar h3 { margin-top: 0; font-size: 16px; border-bottom: 1px solid #ddd; padding-bottom: 10px; }
        .sidebar ul { list-style: none; padding: 0; }
        .sidebar ul li { margin: 10px 0; }
        .sidebar ul li a { color: #333; text-decoration: none; }
        .sidebar ul li a.active, .sidebar ul li a:hover { color: #1abc9c; font-weight: bold; }
        .main-content { flex: 1; background-color: white; border-radius: 8px; padding: 20px; box-shadow: 0 0 5px rgba(0,0,0,0.1); }

        /* 알림 목록 페이지에 특화된 스타일 */
        .notification-status b { color: #d9534f; } /* 읽지 않은 알림 강조 */

        .read-action-button { background-color: #007bff; color: white; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer; font-size: 0.8em; transition: background-color 0.2s ease; margin-left: 5px; text-decoration: none; display: inline-block; }
        .read-action-button:hover { background-color: #0056b3; }

        .notification-link a { text-decoration: none; color: #007bff; font-weight: normal; }
        .notification-link a:hover { text-decoration: underline; }

        .action-buttons-top { margin-bottom: 15px; text-align: right; }
        .action-buttons-top .btn { margin-left: 10px; }
        .delete-individual-button { background-color: #f44336; color: white; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer; font-size: 0.8em; transition: background-color 0.2s ease; margin-left: 5px; text-decoration: none; display: inline-block; white-space: nowrap; }
        .delete-individual-button:hover { background-color: #d32f2f; }

        /* 푸터 스타일 */
        footer { text-align: center; padding: 10px; font-size: 12px; color: #999; margin-top: 20px; }
    </style>
</head>
<body>
<%-- top.jsp include --%>
<c:import url="/WEB-INF/views/common/top.jsp" />

<%-- currentPage 변수를 설정하여 사이드바에서 현재 페이지를 활성화 --%>
<c:set var="currentPage" value="notificationList" scope="request" />

<div class="container">
    <div class="sidebar">
        <h3>알림</h3>
        <ul>
            <li><a href="/notification/list" class="${currentPage == 'notificationList' ? 'active' : ''}">알림 목록</a></li>
            <%-- 향후 다른 알림 관련 메뉴 추가 시 여기에 배치 --%>
        </ul>
    </div>

    <div class="main-content">
        <h1>내 알림 목록 (<span id="unreadNotificationCountDisplay">0</span>건의 안 읽은 알림)</h1>

        <%-- 서버에서 전달된 메시지/에러 메시지 표시 영역 --%>
        <div id="serverMessageArea">
            <c:if test="${not empty message}">
                <p class="alert alert-info text-center">${message}</p>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <p class="alert alert-danger text-center">${errorMessage}</p>
            </c:if>
        </div>

        <div class="action-buttons-top">
            <button type="button" class="btn btn-secondary btn-sm" id="deleteAllNotificationsBtn">모든 알림 삭제</button>
            <button type="button" class="btn btn-danger btn-sm" id="deleteSelectedNotificationsBtn">선택된 알림 삭제</button>
        </div>

        <%-- 알림 목록이 로드될 영역 --%>
        <div id="notificationListArea" class="table-responsive">
            <p>알림 목록을 불러오는 중...</p>
        </div>

        <%-- 페이징 컨트롤이 로드될 영역 --%>
        <div id="paginationControlArea">
            <%-- _pagination.jsp는 JavaScript에서 동적으로 렌더링할 예정 --%>
        </div>
    </div>
</div>

<footer>
    <p>© 2025 그룹웨어 Corp.</p>
</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const notificationListArea = document.getElementById('notificationListArea');
        const paginationControlArea = document.getElementById('paginationControlArea');
        const serverMessageArea = document.getElementById('serverMessageArea');
        const unreadNotificationCountDisplay = document.getElementById('unreadNotificationCountDisplay');

        let currentPage = 1;
        let pageSize = 10;

        // 1. 알림 목록 데이터를 가져와서 렌더링하는 함수
        async function fetchAndRenderNotifications(page = 1, size = 10) {
            currentPage = page;
            pageSize = size;

            notificationListArea.innerHTML = '<p>알림 목록을 불러오는 중...</p>';
            try {
                const response = await fetch(`/api/v1/notifications/list?page=\${page}&size=\${size}`);
                if (!response.ok) {
                    if (response.status === 401) {
                        displayClientMessage('세션이 만료되었거나 발신자가 선택되지 않았습니다. 조직도에서 발신자를 다시 선택해주세요.', 'danger');
                        notificationListArea.innerHTML = '';
                        paginationControlArea.innerHTML = '';
                        unreadNotificationCountDisplay.textContent = '0';
                        return;
                    }
                    throw new Error(`HTTP error! status: \${response.status}`);
                }
                const paginationResponse = await response.json();
                console.log('알림 목록 데이터:', paginationResponse);

                renderNotificationTable(paginationResponse.content); // 알림 테이블 렌더링
                renderPagination(paginationResponse); // 페이징 컨트롤 렌더링

            } catch (error) {
                console.error('알림 목록을 불러오는 중 오류 발생:', error);
                notificationListArea.innerHTML = `<p class="alert alert-danger">알림 목록을 불러올 수 없습니다. 오류: \${error.message}</p>`;
                paginationControlArea.innerHTML = '';
            }
        }

        // 2. 알림 목록을 HTML 테이블로 렌더링하는 함수
        function renderNotificationTable(notifications) {
            if (!notifications || notifications.length === 0) {
                notificationListArea.innerHTML = '<p class="text-center text-muted">새로운 알림이 없습니다.</p>';
                return;
            }

            let tableHtml = `
                <table class="table table-bordered table-hover">
                    <thead>
                        <tr>
                            <th><input type="checkbox" id="selectAllCheckbox"></th>
                            <th>상태</th>
                            <th>타입</th>
                            <th>내용</th>
                            <th>발생 일시</th>
                            <th>링크</th>
                            <th>액션</th>
                        </tr>
                    </thead>
                    <tbody>
            `;

            notifications.forEach(noti => {
                const statusHtml = noti.isRead === 'N' ? '<b>읽지않음</b>' : '읽음';
                const readActionButtonHtml = noti.isRead === 'N' ?
                    `<button type="button" class="read-action-button btn btn-primary btn-sm" data-noti-id="\${noti.notificationId}">읽음처리</button>` : '';
                const targetLinkHtml = noti.targetUrl ?
                    `<a href="\${noti.targetUrl}">바로가기</a>` : '-';
                const formattedDate = new Date(noti.createDate).toLocaleString('ko-KR', {
                    year: 'numeric', month: '2-digit', day: '2-digit',
                    hour: '2-digit', minute: '2-digit', hour12: false
                });

                tableHtml += `
                    <tr>
                        <td><input type="checkbox" class="noti-checkbox" value="\${noti.notificationId}"></td>
                        <td class="notification-status">\${statusHtml} \${readActionButtonHtml}</td>
                        <td>\${noti.notificationType || '-'}</td>
                        <td>\${noti.notificationContent || '내용 없음'}</td>
                        <td>\${formattedDate}</td>
                        <td class="notification-link">\${targetLinkHtml}</td>
                        <td>
                            <button type="button" class="delete-individual-button btn btn-danger btn-sm" data-noti-id="\${noti.notificationId}">삭제</button>
                        </td>
                    </tr>
                `;
            });

            tableHtml += `</tbody></table>`;
            notificationListArea.innerHTML = tableHtml;

            // 이벤트 리스너 다시 연결
            attachTableEventListeners();
        }

        // 3. 페이징 컨트롤을 렌더링하는 함수 (PaginationResponse DTO 사용)
        function renderPagination(pagination) {
            let paginationHtml = `<nav aria-label="Page navigation"><ul class="pagination justify-content-center">`;

            // 이전 페이지 버튼
            paginationHtml += `
                <li class="page-item \${pagination.hasPrevious ? '' : 'disabled'}">
                    <a class="page-link" href="#" data-page="\${pagination.pageNumber}">이전</a>
                </li>
            `;

            // 페이지 번호 버튼 (현재 페이지를 중심으로 앞뒤 2개씩, 총 5개)
            let startPage = Math.max(0, pagination.pageNumber - 2);
            let endPage = Math.min(pagination.totalPages - 1, startPage + 4);

            if (endPage - startPage < 4) {
                startPage = Math.max(0, endPage - 4);
            }

            for (let i = startPage; i <= endPage; i++) {
                paginationHtml += `
                    <li class="page-item \${i === pagination.pageNumber ? 'active' : ''}">
                        <a class="page-link" href="#" data-page="\${i + 1}">\${i + 1}</a>
                    </li>
                `;
            }

            // 다음 페이지 버튼
            paginationHtml += `
                <li class="page-item \${pagination.hasNext ? '' : 'disabled'}">
                    <a class="page-link" href="#" data-page="\${pagination.pageNumber + 2}">다음</a>
                </li>
            `;

            paginationHtml += `</ul></nav>`;
            paginationControlArea.innerHTML = paginationHtml;

            // 페이징 버튼 클릭 이벤트 리스너 연결
            paginationControlArea.querySelectorAll('.page-link').forEach(link => {
                link.addEventListener('click', function(e) {
                    e.preventDefault();
                    if (!this.closest('.page-item').classList.contains('disabled')) {
                        const targetPage = parseInt(this.dataset.page);
                        fetchAndRenderNotifications(targetPage, pageSize); // 새로운 페이지 데이터 로드
                    }
                });
            });
        }

        // 4. 테이블 내 액션 버튼 (읽음 처리, 삭제) 이벤트 리스너 연결 함수
        function attachTableEventListeners() {
            // 전체 선택/해제 체크박스
            const selectAllCheckbox = document.getElementById('selectAllCheckbox');
            const notiCheckboxes = document.querySelectorAll('.noti-checkbox');

            if (selectAllCheckbox) { // selectAllCheckbox가 존재할 때만 이벤트 등록
                selectAllCheckbox.removeEventListener('change', handleSelectAllChange); // 중복 방지
                selectAllCheckbox.addEventListener('change', handleSelectAllChange);
            }

            // 읽음처리 버튼
            document.querySelectorAll('.read-action-button').forEach(button => {
                button.removeEventListener('click', handleMarkAsReadClick); // 중복 방지
                button.addEventListener('click', handleMarkAsReadClick);
            });

            // 개별 삭제 버튼
            document.querySelectorAll('.delete-individual-button').forEach(button => {
                button.removeEventListener('click', handleDeleteIndividualClick); // 중복 방지
                button.addEventListener('click', handleDeleteIndividualClick);
            });
        }

        // 전체 선택/해제 핸들러
        function handleSelectAllChange() {
            const notiCheckboxes = document.querySelectorAll('.noti-checkbox');
            notiCheckboxes.forEach(checkbox => {
                checkbox.checked = this.checked;
            });
        }

        // 읽음 처리 핸들러
        async function handleMarkAsReadClick() {
            const notiId = this.dataset.notiId;
            try {
                const response = await fetch(`/api/v1/notifications/markAsRead/\${notiId}`, { method: 'POST' });
                const result = await response.json();
                if (response.ok) {
                    displayClientMessage(result.message, 'info');
                    fetchAndRenderNotifications(currentPage, pageSize); // 목록 새로고침
                } else {
                    displayClientMessage(result.message || '알림 읽음 처리 실패!', 'danger');
                }
            } catch (error) {
                console.error('알림 읽음 처리 중 오류:', error);
                displayClientMessage('알림 읽음 처리 중 네트워크 오류.', 'danger');
            }
        }

        // 개별 삭제 핸들러
        async function handleDeleteIndividualClick() {
            if (!confirm('정말 이 알림을 삭제하시겠습니까?')) return;
            const notiId = this.dataset.notiId;
            try {
                const response = await fetch(`/api/v1/notifications/delete/\${notiId}`, { method: 'POST' });
                const result = await response.json();
                if (response.ok) {
                    displayClientMessage(result.message, 'info');
                    fetchAndRenderNotifications(currentPage, pageSize); // 목록 새로고침
                } else {
                    displayClientMessage(result.message || '알림 삭제 실패!', 'danger');
                }
            } catch (error) {
                console.error('알림 삭제 중 오류:', error);
                displayClientMessage('알림 삭제 중 네트워크 오류.', 'danger');
            }
        }

        // 상단 버튼: 모든 알림 삭제
        document.getElementById('deleteAllNotificationsBtn').addEventListener('click', async function() {
            if (!confirm('정말 모든 알림을 삭제하시겠습니까?')) return;
            try {
                const response = await fetch('/api/v1/notifications/deleteAll', { method: 'POST' });
                const result = await response.json();
                if (response.ok) {
                    displayClientMessage(result.message, 'info');
                    fetchAndRenderNotifications(currentPage, pageSize); // 목록 새로고침
                } else {
                    displayClientMessage(result.message || '모든 알림 삭제 실패!', 'danger');
                }
            } catch (error) {
                console.error('모든 알림 삭제 중 오류:', error);
                displayClientMessage('모든 알림 삭제 중 네트워크 오류.', 'danger');
            }
        });

        // 상단 버튼: 선택된 알림 삭제
        document.getElementById('deleteSelectedNotificationsBtn').addEventListener('click', async function() {
            const selectedNotiIds = Array.from(document.querySelectorAll('.noti-checkbox:checked'))
                .map(checkbox => parseInt(checkbox.value));
            if (selectedNotiIds.length === 0) {
                displayClientMessage('삭제할 알림을 한 개 이상 선택해주세요.', 'warning');
                return;
            }
            if (!confirm(`선택된 알림 ${selectedNotiIds.length}개를 정말 삭제하시겠습니까?`)) return;

            try {
                const response = await fetch('/api/v1/notifications/deleteSelected', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(selectedNotiIds) // 선택된 ID 목록을 JSON 배열로 전송
                });
                const result = await response.json();
                if (response.ok) {
                    displayClientMessage(result.message, 'info');
                    fetchAndRenderNotifications(currentPage, pageSize); // 목록 새로고침
                } else {
                    displayClientMessage(result.message || '선택된 알림 삭제 실패!', 'danger');
                }
            } catch (error) {
                console.error('선택된 알림 삭제 중 오류:', error);
                displayClientMessage('선택된 알림 삭제 중 네트워크 오류.', 'danger');
            }
        });

        // 클라이언트 측 메시지 표시 함수
        function displayClientMessage(message, type) {
            const tempMessageDiv = document.createElement('div');
            tempMessageDiv.innerHTML = `<p class="alert alert-\${type} text-center">\${message}</p>`;
            serverMessageArea.prepend(tempMessageDiv);

            setTimeout(() => {
                tempMessageDiv.remove();
            }, 5000);
        }

        // 초기 로드: 알림 목록 데이터 가져오기
        fetchAndRenderNotifications(currentPage, pageSize);
    });
</script>
</body>
</html>