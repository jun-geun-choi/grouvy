<%-- src/main/webapp/WEB-INF/views/notification/notification_list.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>내 알림 목록</title>
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
            rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <c:url var="homeCss" value="/resources/css/user/home.css" />
    <link href="${homeCss}" rel="stylesheet" />
    <%-- Bootstrap 및 공통 CSS 링크 --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* 제공해주신 공통 스타일 */
        body { background-color: #f7f7f7; font-family: 'Noto Sans KR', sans-serif; }
        .container { max-width: 1200px; margin: 20px auto; }
        .main-content { background-color: white; border-radius: 8px; padding: 20px; box-shadow: 0 0 10px rgba(0,0,0,0.05); }
        .action-buttons-top { margin-bottom: 20px; text-align: right; }

        /* 알림 테이블 스타일 */
        .notification-table tbody tr { cursor: pointer; }
        .notification-table tbody tr:hover { background-color: #f8f9fa; }

        /* 페이징 스타일 */
        .pagination { margin-top: 20px; }
    </style>
</head>
<body>
<div class="container">
    <%@include file="../common/nav.jsp" %>
</div>
<div class="container mt-4">
    <div class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="h3 mb-0">내 알림 목록 (<span id="unreadNotificationCountDisplay">0</span>)</h1>
            <div class="action-buttons-top">
                <button type="button" class="btn btn-secondary btn-sm" id="readAllBtn">모두 읽음 처리</button>
            </div>
        </div>

        <%-- 서버에서 전달된 메시지 표시 영역 (페이지 최초 로드 시) --%>
        <c:if test="${not empty errorMessage}">
            <p class="alert alert-danger text-center">${errorMessage}</p>
        </c:if>

        <%-- AJAX로 알림 목록이 로드될 영역 --%>
        <div id="notificationListArea">
            <p class="text-center p-5">알림 목록을 불러오는 중...</p>
        </div>

        <%-- 페이징 컨트롤이 로드될 영역 --%>
        <div id="paginationControlArea" class="d-flex justify-content-center">
            <%-- 이 영역은 JavaScript가 동적으로 채웁니다. --%>
        </div>
    </div>
</div>
<%@include file="../common/footer.jsp" %>
<%-- Bootstrap JS 및 커스텀 스크립트 --%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const notificationListArea = document.getElementById('notificationListArea');
        const paginationControlArea = document.getElementById('paginationControlArea');
        const unreadNotificationCountDisplay = document.getElementById('unreadNotificationCountDisplay');
        const readAllBtn = document.getElementById('readAllBtn');

        let currentPage = 1;
        const pageSize = 10; // 한 페이지에 10개씩

        // 1. 알림 목록 데이터를 가져와서 렌더링하는 함수
        async function fetchAndRenderNotifications(page = 1) {
            currentPage = page;

            notificationListArea.innerHTML = '<p class="text-center p-5">알림 목록을 불러오는 중...</p>';
            try {
                const response = await fetch(`/api/v1/notifications/list?page=\${page}&size=\${pageSize}`);

                if (!response.ok) {
                    if (response.status === 401) {
                        notificationListArea.innerHTML = '<p class="alert alert-danger text-center">로그인 세션이 만료되었습니다. 다시 로그인해주세요.</p>';
                    } else {
                        notificationListArea.innerHTML = '<p class="alert alert-danger text-center">알림 목록을 불러오는 데 실패했습니다.</p>';
                    }
                    paginationControlArea.innerHTML = '';
                    unreadNotificationCountDisplay.textContent = '0';
                    readAllBtn.disabled = true; // 버튼 비활성화
                    return;
                }

                const paginationResponse = await response.json();

                renderNotificationTable(paginationResponse.content);
                renderPagination(paginationResponse);
                unreadNotificationCountDisplay.textContent = paginationResponse.totalElements;

            } catch (error) {
                console.error('알림 목록을 불러오는 중 오류 발생:', error);
                notificationListArea.innerHTML = `<p class="alert alert-danger text-center">알림 목록을 불러올 수 없습니다.</p>`;
                paginationControlArea.innerHTML = '';
            }
        }

        // 2. 알림 목록을 HTML 테이블로 렌더링하는 함수
        function renderNotificationTable(notifications) {
            if (!notifications || notifications.length === 0) {
                notificationListArea.innerHTML = '<p class="text-center text-muted p-5">표시할 알림이 없습니다.</p>';
                readAllBtn.disabled = true; // 알림이 없으면 버튼 비활성화
                return;
            }
            readAllBtn.disabled = false; // 알림이 있으면 버튼 활성화

            let tableHtml = `
                <table class="table table-hover notification-table">
                    <thead class="table-light">
                        <tr>
                            <th scope="col" style="width: 15%;">타입</th>
                            <th scope="col">내용</th>
                            <th scope="col" style="width: 20%;">발생 일시</th>
                        </tr>
                    </thead>
                    <tbody>
            `;

            notifications.forEach(noti => {
                const formattedDate = new Date(noti.createDate).toLocaleString('ko-KR');
                const finalUrl = noti.targetUrl ? `\${noti.targetUrl}&currentPage=inbox` : '#';

                tableHtml += `
                    <tr onclick="location.href='\${finalUrl}'">
                        <td>\${noti.notificationType || '-'}</td>
                        <td>\${noti.notificationContent}</td>
                        <td>\${formattedDate}</td>
                    </tr>
                `;
            });

            tableHtml += `</tbody></table>`;
            notificationListArea.innerHTML = tableHtml;
        }

        // 3. 페이징 컨트롤을 렌더링하는 함수
        function renderPagination(pagination) {
            if (pagination.totalPages <= 1) {
                paginationControlArea.innerHTML = '';
                return;
            }

            let paginationHtml = '<ul class="pagination">';

            paginationHtml += `<li class="page-item \${pagination.first ? 'disabled' : ''}"><a class="page-link" href="#" data-page="1">처음</a></li>`;
            paginationHtml += `<li class="page-item \${pagination.hasPrevious ? '' : 'disabled'}"><a class="page-link" href="#" data-page="\${pagination.pageNumber}">이전</a></li>`;

            let startPage = Math.max(0, pagination.pageNumber - 2);
            let endPage = Math.min(pagination.totalPages - 1, startPage + 4);
            if (endPage - startPage < 4) {
                startPage = Math.max(0, endPage - 4);
            }

            for (let i = startPage; i <= endPage; i++) {
                paginationHtml += `<li class="page-item \${i === pagination.pageNumber ? 'active' : ''}"><a class="page-link" href="#" data-page="\${i + 1}">\${i + 1}</a></li>`;
            }

            paginationHtml += `<li class="page-item \${pagination.hasNext ? '' : 'disabled'}"><a class="page-link" href="#" data-page="\${pagination.pageNumber + 2}">다음</a></li>`;
            paginationHtml += `<li class="page-item \${pagination.last ? 'disabled' : ''}"><a class="page-link" href="#" data-page="\${pagination.totalPages}">마지막</a></li>`;

            paginationHtml += '</ul>';
            paginationControlArea.innerHTML = paginationHtml;
        }

        // 4. '모두 읽음 처리' 버튼 이벤트 리스너
        readAllBtn.addEventListener('click', async function() {
            if (!confirm('모든 알림을 읽음 처리하시겠습니까? 목록에서 사라집니다.')) return;

            try {
                // [수정] 우리 API 경로에 맞게 fetch URL 수정
                const response = await fetch('/api/v1/notifications/readAll', {
                    method: 'POST'
                });

                const result = await response.json();

                if (response.ok) {
                    alert(result.message);
                    fetchAndRenderNotifications(1);
                } else {
                    alert(result.message || '모든 알림 읽음 처리에 실패했습니다.');
                }
            } catch (error) {
                console.error('모든 알림 읽음 처리 중 오류 발생:', error);
                alert('작업 중 오류가 발생했습니다.');
            }
        });

        // 5. 페이징 링크 클릭 이벤트 위임 (이벤트 버블링 활용)
        paginationControlArea.addEventListener('click', function(e) {
            e.preventDefault();
            const link = e.target.closest('.page-link');
            if (link && !link.closest('.page-item').classList.contains('disabled')) {
                const targetPage = parseInt(link.dataset.page, 10);
                fetchAndRenderNotifications(targetPage);
            }
        });

        // 페이지가 로드되면 최초로 알림 목록을 가져옵니다.
        fetchAndRenderNotifications(1);
    });
</script>
</body>
</html>