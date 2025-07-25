<%-- **파일 경로:** src/main/resources/META-INF/resources/WEB-INF/views/message/important_inbox.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>중요 쪽지함</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        .unread {
            font-weight: bold;
            color: #007bff; /* 파란색으로 미확인 쪽지 강조 */
        }
        .pagination-container {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }
        .table-hover tbody tr:hover {
            cursor: pointer;
            background-color: #f5f5f5;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <h2><i class="fas fa-star mr-2"></i> 중요 쪽지함</h2>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-warning mt-3">${errorMessage}</div>
    </c:if>

    <div class="table-responsive mt-4">
        <table class="table table-hover table-sm">
            <thead class="thead-light">
            <tr>
                <th>보낸 사람</th>
                <th>제목</th>
                <th>받은 날짜</th>
                <th>상태</th>
                <th>중요</th>
            </tr>
            </thead>
            <tbody id="importantInboxTableBody">
            <!-- 쪽지 목록이 여기에 동적으로 로드됩니다. -->
            <tr><td colspan="5" class="text-center">쪽지를 불러오는 중...</td></tr>
            </tbody>
        </table>
    </div>

    <!-- Pagination -->
    <nav aria-label="Page navigation" class="pagination-container">
        <ul class="pagination" id="pagination">
            <!-- 페이지네이션 버튼이 여기에 동적으로 로드됩니다. -->
        </ul>
    </nav>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let currentPage = 1;
    const pageSize = 10; // 한 페이지에 보여줄 쪽지 수

    document.addEventListener('DOMContentLoaded', function() {
        fetchImportantInboxMessages(currentPage);
    });

    // 중요 쪽지함 목록을 가져오는 함수 (API 엔드포인트가 다름)
    function fetchImportantInboxMessages(page) {
        const importantInboxTableBody = document.getElementById('importantInboxTableBody');
        importantInboxTableBody.innerHTML = '<tr><td colspan="5" class="text-center">쪽지를 불러오는 중...</td></tr>'; // 로딩 메시지

        // **API 엔드포인트만 변경**: /api/v1/messages/important
        fetch(`/api/v1/messages/important?page=\${page}&size=\${pageSize}`)
            .then(response => {
                if (response.status === 401) { // Unauthorized 처리
                    importantInboxTableBody.innerHTML = '<tr><td colspan="5" class="text-center text-danger">로그인이 필요합니다.</td></tr>';
                    return Promise.reject('Unauthorized');
                }
                if (!response.ok) { // 기타 HTTP 오류 처리
                    return response.json().then(errorData => {
                        throw new Error(errorData.message || '중요 쪽지 목록 불러오기 실패');
                    });
                }
                return response.json(); // 성공 응답 파싱
            })
            .then(data => {
                importantInboxTableBody.innerHTML = ''; // 기존 내용 초기화
                if (data.content && data.content.length > 0) {
                    data.content.forEach(message => {
                        const row = `
                                <tr data-message-id="\${message.messageId}" data-receive-id="\${message.receiveId}">
                                    <td>\${message.senderName}</td>
                                    <td class="\${message.inboxStatus === 'UNREAD' ? 'unread' : ''}">\${message.subject}</td>
                                    <td>\${formatDate(message.sendDate)}</td>
                                    <td>\${message.inboxStatus === 'UNREAD' ? '읽지 않음' : '읽음'}</td>
                                    <td>\${message.importantYn === 'Y' ? '<i class="fas fa-star text-warning"></i>' : '<i class="far fa-star text-muted"></i>'}</td>
                                </tr>
                            `;
                        importantInboxTableBody.insertAdjacentHTML('beforeend', row);
                    });
                    setupRowClickListeners(); // 각 행에 클릭 이벤트 리스너 추가
                    renderPagination(data); // 페이지네이션 렌더링
                } else {
                    importantInboxTableBody.innerHTML = '<tr><td colspan="5" class="text-center">중요 표시된 쪽지가 없습니다.</td></tr>';
                    renderPagination(data); // 빈 목록일 때도 페이지네이션 초기화
                }
            })
            .catch(error => {
                console.error('Error fetching important inbox messages:', error);
                if (error !== 'Unauthorized') {
                    importantInboxTableBody.innerHTML = `<tr><td colspan="5" class="text-center text-danger">쪽지 목록을 불러오는 중 오류 발생: \${error.message}</td></tr>`;
                }
                document.getElementById('pagination').innerHTML = ''; // 에러 발생 시 페이지네이션 제거
            });
    }

    // 행 클릭 이벤트 리스너 설정 (쪽지 상세로 이동)
    function setupRowClickListeners() {
        document.querySelectorAll('#importantInboxTableBody tr').forEach(row => {
            row.addEventListener('click', function() {
                const messageId = this.dataset.messageId;
                if (messageId) {
                    window.location.href = `/message/detail?messageId=\${messageId}`;
                }
            });
        });
    }

    // 날짜 포맷 함수 (inbox.jsp와 동일)
    function formatDate(dateString) {
        if (!dateString) return '';
        const date = new Date(dateString);
        const options = { year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit' };
        return date.toLocaleDateString('ko-KR', options);
    }

    // 페이지네이션 렌더링 함수 (inbox.jsp와 동일, fetch 함수만 변경)
    function renderPagination(paginationData) {
        const paginationUl = document.getElementById('pagination');
        paginationUl.innerHTML = '';

        const totalPages = paginationData.totalPages;
        const currentPageNumber = paginationData.pageNumber + 1;

        const prevClass = paginationData.hasPrevious ? '' : 'disabled';
        paginationUl.insertAdjacentHTML('beforeend', `
                <li class="page-item \${prevClass}">
                    <a class="page-link" href="#" onclick="if(!this.parentNode.classList.contains('disabled')) fetchImportantInboxMessages(\${currentPageNumber - 1}); return false;">이전</a>
                </li>
            `);

        let startPage = Math.max(1, currentPageNumber - 4);
        let endPage = Math.min(totalPages, currentPageNumber + 5);

        if (endPage - startPage < 9) {
            startPage = Math.max(1, endPage - 9);
        }
        if (startPage > 1) {
            paginationUl.insertAdjacentHTML('beforeend', `<li class="page-item"><a class="page-link" href="#" onclick="fetchImportantInboxMessages(1); return false;">1</a></li>`);
            if (startPage > 2) paginationUl.insertAdjacentHTML('beforeend', `<li class="page-item disabled"><a class="page-link" href="#">...</a></li>`);
        }

        for (let i = startPage; i <= endPage; i++) {
            const activeClass = (i === currentPageNumber) ? 'active' : '';
            paginationUl.insertAdjacentHTML('beforeend', `
                    <li class="page-item \${activeClass}">
                        <a class="page-link" href="#" onclick="fetchImportantInboxMessages(\${i}); return false;">\${i}</a>
                    </li>
                `);
        }

        if (endPage < totalPages) {
            if (endPage < totalPages - 1) paginationUl.insertAdjacentHTML('beforeend', `<li class="page-item disabled"><a class="page-link" href="#">...</a></li>`);
            paginationUl.insertAdjacentHTML('beforeend', `<li class="page-item"><a class="page-link" href="#" onclick="fetchImportantInboxMessages(\${totalPages}); return false;">\${totalPages}</a></li>`);
        }

        const nextClass = paginationData.hasNext ? '' : 'disabled';
        paginationUl.insertAdjacentHTML('beforeend', `
                <li class="page-item \${nextClass}">
                    <a class="page-link" href="#" onclick="if(!this.parentNode.classList.contains('disabled')) fetchImportantInboxMessages(\${currentPageNumber + 1}); return false;">다음</a>
                </li>
            `);
    }
</script>
</body>
</html>