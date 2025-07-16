<%-- src/main/webapp/WEB-INF/views/message/sentbox.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>보낸 쪽지함</title>
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

        /* 메시지 목록 페이지에 특화된 스타일 */
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #f2f2f2; color: #555; font-weight: bold; white-space: nowrap; }
        tr:hover { background-color: #f9f9f9; }
        .message-title a { text-decoration: none; color: #333; font-weight: normal; }
        .message-title a:hover { text-decoration: underline; }
        .message-status b { color: #d9534f; }
        .message-status .recalled { color: gray; text-decoration: line-through; }

        .action-button { background-color: #d9534f; color: white; border: none; padding: 8px 12px; border-radius: 4px; cursor: pointer; font-size: 0.9em; transition: background-color 0.2s ease; white-space: nowrap; }
        .action-button:hover { background-color: #c9302c; }
        .action-form { display: inline-block; margin: 0; padding: 0; }
        .recall-button { background-color: #f0ad4e; color: white; border: none; padding: 8px 12px; border-radius: 4px; cursor: pointer; font-size: 0.9em; transition: background-color 0.2s ease; white-space: nowrap; }
        .recall-button:hover { background-color: #ec971f; }

        /* 푸터 스타일 */
        footer { text-align: center; padding: 10px; font-size: 12px; color: #999; margin-top: 20px; }
    </style>
</head>
<body>
<%-- top.jsp include --%>
<c:import url="/WEB-INF/views/common/top.jsp" />

<%-- currentPage 변수를 설정하여 사이드바에서 현재 페이지를 활성화 --%>
<c:set var="currentPage" value="sentbox" scope="request"/>

<div class="container">
    <div class="sidebar">
        <h3>쪽지함</h3>
        <ul>
            <li><a href="/message/inbox" class="${currentPage == 'inbox' ? 'active' : ''}">받은 쪽지함</a></li>
            <li><a href="/message/sentbox" class="${currentPage == 'sentbox' ? 'active' : ''}">보낸 쪽지함</a></li>
            <li><a href="/message/important" class="${currentPage == 'important' ? 'active' : ''}">중요 쪽지함</a></li>
            <li><a href="/message/send" class="${currentPage == 'send' ? 'active' : ''}">쪽지 쓰기</a></li>
        </ul>
    </div>

    <div class="main-content">
        <h1>보낸 쪽지함</h1>

        <div id="serverMessageArea">
            <c:if test="${not empty message}">
                <p class="alert alert-info text-center">${message}</p>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <p class="alert alert-danger text-center">${errorMessage}</p>
            </c:if>
        </div>

        <div id="messageListArea" class="table-responsive">
            <p>쪽지 목록을 불러오는 중...</p>
        </div>

        <div id="paginationControlArea">
            <c:import url="/WEB-INF/views/common/_pagination.jsp" />
        </div>
    </div>
</div>

<footer>
    <p>© 2025 그룹웨어 Corp.</p>
</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const messageListArea = document.getElementById('messageListArea');
        const paginationContainer = document.getElementById('paginationContainer');
        const serverMessageArea = document.getElementById('serverMessageArea');

        let currentPage = 1;
        let pageSize = 10;

        async function fetchAndRenderMessages(page = 1, size = 10) {
            currentPage = page;
            pageSize = size;

            messageListArea.innerHTML = '<p>쪽지 목록을 불러오는 중...</p>';
            try {
                // MessageRestController의 /api/v1/messages/sentbox API 호출
                const response = await fetch(`/api/v1/messages/sentbox?page=\${page}&size=\${size}`);
                if (!response.ok) {
                    if (response.status === 401) {
                        displayClientMessage('세션이 만료되었거나 발신자가 선택되지 않았습니다. 조직도에서 발신자를 다시 선택해주세요.', 'danger');
                        messageListArea.innerHTML = '';
                        paginationContainer.innerHTML = '';
                        return;
                    }
                    throw new Error(`HTTP error! status: \${response.status}`);
                }
                const paginationResponse = await response.json();
                console.log('보낸 쪽지 목록 데이터:', paginationResponse);

                renderMessageTable(paginationResponse.content);
                renderPagination(paginationResponse);

            } catch (error) {
                console.error('보낸 쪽지 목록을 불러오는 중 오류 발생:', error);
                messageListArea.innerHTML = `<p class="alert alert-danger">쪽지 목록을 불러올 수 없습니다. 오류: \${error.message}</p>`;
                paginationContainer.innerHTML = '';
            }
        }

        function renderMessageTable(messages) {
            if (!messages || messages.length === 0) {
                messageListArea.innerHTML = '<p class="text-center text-muted">보낸 쪽지가 없습니다.</p>';
                return;
            }

            let tableHtml = `
                <table class="table table-bordered table-hover">
                    <thead>
                        <tr>
                            <th>제목</th>
                            <th>발송 일시</th>
                            <th>회수 가능 여부</th>
                            <th>액션</th>
                        </tr>
                    </thead>
                    <tbody>
            `;

            messages.forEach(msg => {
                const subjectLinkHtml = `<a href="/message/detail?messageId=\${msg.messageId}">\${msg.subject}</a>`;
                const formattedDate = new Date(msg.sendDate).toLocaleString('ko-KR', {
                    year: 'numeric', month: '2-digit', day: '2-digit',
                    hour: '2-digit', minute: '2-digit', hour12: false
                });

                let recallStatusHtml;
                if (msg.recallAble === 'Y') {
                    if (msg.currentlyRecallable) {
                        recallStatusHtml = '<span style="color: green;">가능 (수신자 미열람)</span>';
                    } else {
                        recallStatusHtml = '<span style="color: gray;">불가능 (수신자 열람)</span>';
                    }
                } else {
                    recallStatusHtml = '<span style="color: gray;">원천 불가</span>';
                }

                const recallButtonHtml = (msg.recallAble === 'Y' && msg.currentlyRecallable) ?
                    `<form class="action-form recall-form me-1" data-message-id="\${msg.messageId}">
                                            <button type="button" class="recall-button btn btn-warning btn-sm">회수</button>
                                          </form>` : '';

                tableHtml += `
                    <tr>
                        <td class="message-title">\${subjectLinkHtml}</td>
                        <td>\${formattedDate}</td>
                        <td>\${recallStatusHtml}</td>
                        <td>
                            \${recallButtonHtml}
                            <form class="action-form delete-sent-form" data-send-id="\${msg.sendId}">
                                <button type="button" class="action-button btn btn-danger btn-sm">삭제</button>
                            </form>
                        </td>
                    </tr>
                `;
            });

            tableHtml += `</tbody></table>`;
            messageListArea.innerHTML = tableHtml;

            attachTableEventListeners();
        }

        function renderPagination(pagination) {
            let paginationHtml = `<nav aria-label="Page navigation"><ul class="pagination justify-content-center">`;
            paginationHtml += `<li class="page-item \${pagination.hasPrevious ? '' : 'disabled'}">
                                <a class="page-link" href="#" data-page="\${pagination.pageNumber}">이전</a>
                            </li>`;
            let startPage = Math.max(0, pagination.pageNumber - 2);
            let endPage = Math.min(pagination.totalPages - 1, startPage + 4);
            if (endPage - startPage < 4) {
                startPage = Math.max(0, endPage - 4);
            }
            for (let i = startPage; i <= endPage; i++) {
                paginationHtml += `<li class="page-item \${i === pagination.pageNumber ? 'active' : ''}">
                                    <a class="page-link" href="#" data-page="\${i + 1}">\${i + 1}</a>
                                </li>`;
            }
            paginationHtml += `<li class="page-item \${pagination.hasNext ? '' : 'disabled'}">
                                <a class="page-link" href="#" data-page="\${pagination.pageNumber + 2}">다음</a>
                            </li>`;
            paginationHtml += `</ul></nav>`;
            paginationContainer.innerHTML = paginationHtml;

            paginationContainer.querySelectorAll('.page-link').forEach(link => {
                link.addEventListener('click', function(e) {
                    e.preventDefault();
                    if (!this.closest('.page-item').classList.contains('disabled')) {
                        const targetPage = parseInt(this.dataset.page);
                        fetchAndRenderMessages(targetPage, pageSize);
                    }
                });
            });
        }

        function attachTableEventListeners() {
            // 회수 버튼
            document.querySelectorAll('.recall-form button').forEach(button => {
                button.addEventListener('click', async function() {
                    if (!confirm('정말 이 쪽지를 회수하시겠습니까? 읽지 않은 수신자에게서만 회수되며, 알림은 사라집니다.')) {
                        return;
                    }
                    const form = this.closest('.recall-form');
                    const messageId = form.dataset.messageId;

                    try {
                        const response = await fetch(`/api/v1/messages/recall/\${messageId}`, {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' }
                        });
                        const result = await response.json();
                        if (response.ok) {
                            displayClientMessage(result.message, 'info');
                            fetchAndRenderMessages(currentPage, pageSize);
                        } else {
                            displayClientMessage(result.message || '쪽지 회수 실패!', 'danger');
                        }
                    } catch (error) {
                        console.error('쪽지 회수 중 오류:', error);
                        displayClientMessage('쪽지 회수 중 네트워크 오류.', 'danger');
                    }
                });
            });

            // 삭제 버튼
            document.querySelectorAll('.delete-sent-form button').forEach(button => {
                button.addEventListener('click', async function() {
                    if (!confirm('정말 이 쪽지를 삭제하시겠습니까?')) {
                        return;
                    }
                    const form = this.closest('.delete-sent-form');
                    const sendId = form.dataset.sendId;

                    try {
                        const response = await fetch(`/api/v1/messages/sentbox/delete/\${sendId}`, {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' }
                        });
                        const result = await response.json();
                        if (response.ok) {
                            displayClientMessage(result.message, 'info');
                            fetchAndRenderMessages(currentPage, pageSize);
                        } else {
                            displayClientMessage(result.message || '쪽지 삭제 실패!', 'danger');
                        }
                    } catch (error) {
                        console.error('쪽지 삭제 중 오류:', error);
                        displayClientMessage('쪽지 삭제 중 네트워크 오류.', 'danger');
                    }
                });
            });
        }

        function displayClientMessage(message, type) {
            const tempMessageDiv = document.createElement('div');
            tempMessageDiv.innerHTML = `<p class="alert alert-\${type} text-center">\${message}</p>`;
            serverMessageArea.prepend(tempMessageDiv);

            setTimeout(() => {
                tempMessageDiv.remove();
            }, 5000);
        }

        fetchAndRenderMessages(currentPage, pageSize);
    });
</script>
</body>
</html>