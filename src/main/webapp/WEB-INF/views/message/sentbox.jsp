<%-- src/main/resources/templates/message/sentbox.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>보낸 쪽지함</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        body {
            background-color: #f7f7f7;
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            color: #333;
        }

        .container {
            display: flex;
            padding: 20px;
            max-width: 1400px;
            margin: 20px auto;
        }

        /* 사이드바 통일 스타일 */
        .sidebar {
            width: 200px;
            background-color: white;
            border-radius: 8px;
            padding: 15px;
            margin-right: 20px;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
        }

        .sidebar h3 {
            margin-top: 0;
            font-size: 16px;
            border-bottom: 1px solid #ddd;
            padding-bottom: 10px;
        }

        .sidebar ul {
            list-style: none;
            padding: 0;
        }

        .sidebar ul li {
            margin: 10px 0;
        }

        .sidebar ul li a {
            color: #333;
            text-decoration: none;
        }

        .sidebar ul li a.active,
        .sidebar ul li a:hover {
            color: #1abc9c;
            font-weight: bold;
        }

        /* 메인 콘텐츠 영역 */
        .main-content {
            flex: 1;
            background-color: white;
            border-radius: 8px;
            padding: 25px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .main-content h2 {
            margin-top: 0;
            margin-bottom: 30px;
            color: #34495e;
            font-size: 1.6em;
            border-bottom: 1px solid #eee;
            padding-bottom: 18px;
        }

        /* 쪽지 작성 폼 스타일 */
        form {
            width: 100%;
            overflow-x: hidden;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
        }

        .form-control {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ced4da;
            border-radius: 0.25rem;
            box-sizing: border-box;
            font-size: 1rem;
        }

        textarea.form-control {
            resize: vertical;
        }

        /* 발신자 정보 박스 */
        .sender-info {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        /* 수신자 리스트 */
        .recipient-list {
            list-style: none;
            display: flex;
            flex-wrap: wrap;
            gap: 5px;
            min-height: 38px;
            border: 1px solid #ced4da;
            border-radius: 0.25rem;
            padding: 0.375rem 0.75rem;
            align-items: center;
            background-color: white;
        }

        .recipient-item {
            background-color: #e9ecef;
            border-radius: 5px;
            display: flex;
            align-items: center;
            max-width: 150px;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
            font-size: 0.9em;
            padding: 3px 7px;
        }

        .recipient-item .remove-btn {
            margin-left: 5px;
            background: none;
            border: none;
            color: #dc3545;
            cursor: pointer;
            font-size: 0.8em;
            flex-shrink: 0;
        }

        /* 버튼 스타일 통일 */
        .btn {
            display: inline-block;
            font-weight: 400;
            text-align: center;
            vertical-align: middle;
            user-select: none;
            background-color: transparent;
            border: 1px solid transparent;
            padding: 0.375rem 0.75rem;
            font-size: 1rem;
            border-radius: 0.25rem;
            cursor: pointer;
            transition: all 0.15s ease-in-out;
        }

        .btn-primary {
            color: #fff;
            background-color: #0d6efd;
            border-color: #0d6efd;
        }

        .btn-primary:hover {
            background-color: #0b5ed7;
            border-color: #0a58ca;
        }

        .btn-secondary {
            color: #fff;
            background-color: #6c757d;
            border-color: #6c757d;
        }

        .btn-secondary:hover {
            background-color: #5c636a;
            border-color: #565e64;
        }

        .btn-outline-secondary {
            color: #6c757d;
            border: 1px solid #ced4da;
            background-color: #fff;
        }

        .btn-outline-secondary:hover {
            background-color: #e9ecef;
            border-color: #adb5bd;
        }

        /* 반응형 */
        @media (max-width: 768px) {
            .container {
                flex-direction: column;
                padding: 15px;
            }

            .sidebar {
                width: 100%;
                margin-right: 0;
                margin-bottom: 20px;
                padding: 15px;
            }

            .main-content {
                padding: 20px;
            }

            .btn {
                width: 100%;
            }
        }

        @media (max-width: 576px) {
            .main-content h2 {
                font-size: 1.2em;
                margin-bottom: 15px;
                padding-bottom: 10px;
            }

            .form-control {
                font-size: 0.9em;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <!-- 사이드바 -->
    <div class="sidebar">
        <h3>쪽지 메뉴</h3>
        <ul>
            <li><a href="/message/send" class="${currentPage == 'send' ? 'active' : ''}">쪽지 쓰기</a></li>
            <li><a href="/message/inbox" class="${currentPage == 'inbox' ? 'active' : ''}">받은 쪽지함</a></li>
            <li><a href="/message/sentbox" class="${currentPage == 'sentbox' ? 'active' : ''}">보낸 쪽지함</a></li>
            <li><a href="/message/important" class="${currentPage == 'important' ? 'active' : ''}">중요 쪽지함</a></li>
        </ul>
    </div>

    <!-- 본문 -->
    <div class="main-content">
        <h2><i class="fas fa-paper-plane mr-2"></i>보낸 쪽지함</h2>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-warning mt-3">${errorMessage}</div>
        </c:if>

        <div class="table-responsive mt-4">
            <table class="table table-hover table-sm">
                <thead class="thead-light">
                <tr>
                    <th>제목</th>
                    <th>내용 미리보기</th>
                    <th>발송 날짜</th>
                    <th>회수 가능 여부</th>
                </tr>
                </thead>
                <tbody id="sentboxTableBody">
                <tr><td colspan="4" class="text-center">쪽지를 불러오는 중...</td></tr>
                </tbody>
            </table>
        </div>

        <nav aria-label="Page navigation" class="pagination-container mt-4">
            <ul class="pagination justify-content-center" id="pagination"></ul>
        </nav>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let currentPage = 1;
    const pageSize = 10;

    document.addEventListener('DOMContentLoaded', function() {
        fetchSentboxMessages(currentPage);
    });

    function fetchSentboxMessages(page) {
        const sentboxTableBody = document.getElementById('sentboxTableBody');
        sentboxTableBody.innerHTML = '<tr><td colspan="4" class="text-center">쪽지를 불러오는 중...</td></tr>';

        fetch(`/api/v1/messages/sentbox?page=\${page}&size=\${pageSize}`)
            .then(response => {
                if (response.status === 401) {
                    sentboxTableBody.innerHTML = '<tr><td colspan="4" class="text-center text-danger">로그인이 필요합니다.</td></tr>';
                    return Promise.reject('Unauthorized');
                }
                if (!response.ok) {
                    return response.json().then(errorData => {
                        throw new Error(errorData.message || '쪽지 목록 불러오기 실패');
                    });
                }
                return response.json();
            })
            .then(data => {
                sentboxTableBody.innerHTML = '';
                if (data.content && data.content.length > 0) {
                    data.content.forEach(message => {
                        const isRecallable = message.currentlyRecallable;
                        const isRecalled = message.recallAble === 'RECALLED';

                        let recallStatusHtml = '';
                        if (isRecalled) {
                            recallStatusHtml = '<span class="text-danger"><i class="fas fa-history mr-1"></i>회수됨</span>';
                        } else if (message.recallAble === 'Y') {
                            if (isRecallable) {
                                recallStatusHtml = '<span class="text-success"><i class="fas fa-check-circle mr-1"></i>회수 가능</span>';
                            } else {
                                recallStatusHtml = '<span class="text-muted"><i class="fas fa-times-circle mr-1"></i>읽음 확인됨</span>';
                            }
                            if (isRecallable) {
                                recallStatusHtml += ` <a href="#" class="recall-action-link ml-2" data-message-id="\${message.messageId}">[회수]</a>`;
                            }
                        } else {
                            recallStatusHtml = '<span class="text-danger"><i class="fas fa-ban mr-1"></i>회수 불가</span>';
                        }

                        const row = `
                                <tr data-message-id="\${message.messageId}" data-send-id="\${message.sendId}">
                                    <td class="\${isRecalled ? 'recalled-message' : ''}">\${message.subject}</td>
                                    <td class="\${isRecalled ? 'recalled-message' : ''}">\${truncateContent(message.messageContent, 50)}</td>
                                    <td>\${formatDate(message.sendDate)}</td>
                                    <td>\${recallStatusHtml}</td>
                                </tr>
                            `;
                        sentboxTableBody.insertAdjacentHTML('beforeend', row);
                    });
                    setupRowClickListeners();
                    setupRecallActionListeners();
                    renderPagination(data);
                } else {
                    sentboxTableBody.innerHTML = '<tr><td colspan="4" class="text-center">보낸 쪽지가 없습니다.</td></tr>';
                    renderPagination(data);
                }
            })
            .catch(error => {
                console.error('Error fetching sentbox messages:', error);
                if (error !== 'Unauthorized') {
                    sentboxTableBody.innerHTML = `<tr><td colspan="4" class="text-center text-danger">쪽지 목록을 불러오는 중 오류 발생: \${error.message}</td></tr>`;
                }
                document.getElementById('pagination').innerHTML = '';
            });
    }

    function truncateContent(content, maxLength) {
        if (!content) return '';
        if (content.length <= maxLength) {
            return content;
        }
        return content.substring(0, maxLength) + '...';
    }

    function setupRowClickListeners() {
        document.querySelectorAll('#sentboxTableBody tr').forEach(row => {
            row.addEventListener('click', function(event) {
                if (event.target.classList.contains('recall-action-link')) {
                    event.stopPropagation();
                    return;
                }
                const messageId = this.dataset.messageId;
                if (messageId) {
                    window.location.href = `/message/detail?messageId=\${messageId}&currentPage=sentbox`;
                }
            });
        });
    }

    function setupRecallActionListeners() {
        document.querySelectorAll('.recall-action-link').forEach(link => {
            link.addEventListener('click', function(event) {
                event.preventDefault();
                const messageId = this.dataset.messageId;
                if (confirm('정말로 쪽지를 회수하시겠습니까? (수신자가 읽지 않았을 경우에만 가능합니다)')) {
                    recallMessage(messageId);
                }
            });
        });
    }

    function recallMessage(messageId) {
        fetch(`/api/v1/messages/recall/\${messageId}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        })
            .then(response => {
                if (response.status === 401) {
                    alert('로그인이 필요합니다.');
                    return Promise.reject('Unauthorized');
                }
                if (!response.ok) {
                    return response.json().then(errorData => {
                        throw new Error(errorData.message || '쪽지 회수 실패');
                    });
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    alert(data.message);
                    fetchSentboxMessages(currentPage);
                } else {
                    alert('쪽지 회수 실패: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error recalling message:', error);
                if (error !== 'Unauthorized') {
                    alert('쪽지 회수 중 오류가 발생했습니다: ' + error.message);
                }
            });
    }

    function formatDate(dateString) {
        if (!dateString) return '';
        const date = new Date(dateString);
        const options = { year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit' };
        return date.toLocaleDateString('ko-KR', options);
    }

    function renderPagination(paginationData) {
        const paginationUl = document.getElementById('pagination');
        paginationUl.innerHTML = '';

        const totalPages = paginationData.totalPages;
        const currentPageNumber = paginationData.pageNumber + 1;

        const prevClass = paginationData.hasPrevious ? '' : 'disabled';
        paginationUl.insertAdjacentHTML('beforeend', `
                <li class="page-item \${prevClass}">
                    <a class="page-link" href="#" onclick="if(!this.parentNode.classList.contains('disabled')) fetchSentboxMessages(\${currentPageNumber - 1}); return false;">이전</a>
                </li>
            `);

        let startPage = Math.max(1, currentPageNumber - 4);
        let endPage = Math.min(totalPages, currentPageNumber + 5);

        if (endPage - startPage < 9) {
            startPage = Math.max(1, endPage - 9);
        }
        if (startPage > 1) {
            paginationUl.insertAdjacentHTML('beforeend', `<li class="page-item"><a class="page-link" href="#" onclick="fetchSentboxMessages(1); return false;">1</a></li>`);
            if (startPage > 2) paginationUl.insertAdjacentHTML('beforeend', `<li class="page-item disabled"><a class="page-link" href="#">...</a></li>`);
        }

        for (let i = startPage; i <= endPage; i++) {
            const activeClass = (i === currentPageNumber) ? 'active' : '';
            paginationUl.insertAdjacentHTML('beforeend', `
                    <li class="page-item \${activeClass}">
                        <a class="page-link" href="#" onclick="fetchSentboxMessages(\${i}); return false;">\${i}</a>
                    </li>
                `);
        }

        if (endPage < totalPages) {
            if (endPage < totalPages - 1) paginationUl.insertAdjacentHTML('beforeend', `<li class="page-item disabled"><a class="page-link" href="#">...</a></li>`);
            paginationUl.insertAdjacentHTML('beforeend', `<li class="page-item"><a class="page-link" href="#" onclick="fetchSentboxMessages(\${totalPages}); return false;">\${totalPages}</a></li>`);
        }

        const nextClass = paginationData.hasNext ? '' : 'disabled';
        paginationUl.insertAdjacentHTML('beforeend', `
                <li class="page-item \${nextClass}">
                    <a class="page-link" href="#" onclick="if(!this.parentNode.classList.contains('disabled')) fetchSentboxMessages(\${currentPageNumber + 1}); return false;">다음</a>
                </li>
            `);
    }
</script>
</body>
</html>