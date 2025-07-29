<%--src/main/resources/META-INF/resources/WEB-INF/views/message/inbox.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>받은 쪽지함</title>

  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
  <style>
    .unread {
      font-weight: bold;
      color: #007bff;
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
  <h2><i class="fas fa-inbox mr-2"></i>받은 쪽지함</h2>

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
      <tbody id="inboxTableBody">
      <tr><td colspan="5" class="text-center">쪽지를 불러오는 중...</td></tr>
      </tbody>
    </table>
  </div>

  <!-- Pagination -->
  <nav aria-label="Page navigation" class="pagination-container">
    <ul class="pagination" id="pagination">
    </ul>
  </nav>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
  let currentPage = 1;
  const pageSize = 10;

  document.addEventListener('DOMContentLoaded', function() {
    fetchInboxMessages(currentPage);
  });

  function fetchInboxMessages(page) {
    const inboxTableBody = document.getElementById('inboxTableBody');
    inboxTableBody.innerHTML = '<tr><td colspan="5" class="text-center">쪽지를 불러오는 중...</td></tr>';

    fetch(`/api/v1/messages/inbox?page=\${page}&size=\${pageSize}`)
            .then(response => {
              if (response.status === 401) {
                inboxTableBody.innerHTML = '<tr><td colspan="5" class="text-center text-danger">로그인이 필요합니다.</td></tr>';
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
              inboxTableBody.innerHTML = '';
              if (data.content && data.content.length > 0) {
                data.content.forEach(message => {
                  const row = `
                                <tr data-message-id="\${message.messageId}" data-receive-id="\${message.receiveId}">
                                    <td>\${message.senderName || '알 수 없는 발신자'}</td>
                                    <td class="\${message.inboxStatus === 'UNREAD' ? 'unread' : ''}">\${message.subject || '(제목 없음)'}</td>
                                    <td>\${formatDate(message.sendDate)}</td>
                                    <td>\${message.inboxStatus === 'UNREAD' ? '읽지 않음' : (message.inboxStatus === 'RECALLED_BY_SENDER' ? '회수됨' : '읽음')}</td>
                                    <td>\${message.importantYn === 'Y' ? '<i class="fas fa-star text-warning"></i>' : '<i class="far fa-star text-muted"></i>'}</td>
                                </tr>
                            `;
                  inboxTableBody.insertAdjacentHTML('beforeend', row);
                });
                setupRowClickListeners();
                renderPagination(data);
              } else {
                inboxTableBody.innerHTML = '<tr><td colspan="5" class="text-center">받은 쪽지가 없습니다.</td></tr>';
                renderPagination(data);
              }
            })
            .catch(error => {
              console.error('Error fetching inbox messages:', error);
              if (error !== 'Unauthorized') {
                inboxTableBody.innerHTML = `<tr><td colspan="5" class="text-center text-danger">쪽지 목록을 불러오는 중 오류 발생: \${error.message}</td></tr>`;
              }
              document.getElementById('pagination').innerHTML = '';
            });
  }

  function setupRowClickListeners() {
    document.querySelectorAll('#inboxTableBody tr').forEach(row => {
      row.addEventListener('click', function() {
        const messageId = this.dataset.messageId;
        if (messageId) {
          window.location.href = `/message/detail?messageId=\${messageId}`;
        }
      });
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
                    <a class="page-link" href="#" onclick="if(!this.parentNode.classList.contains('disabled')) fetchInboxMessages(\${currentPageNumber - 1}); return false;">이전</a>
                </li>
            `);

    let startPage = Math.max(1, currentPageNumber - 4);
    let endPage = Math.min(totalPages, currentPageNumber + 5);

    if (endPage - startPage < 9) {
      startPage = Math.max(1, endPage - 9);
    }
    if (startPage > 1) {
      paginationUl.insertAdjacentHTML('beforeend', `<li class="page-item"><a class="page-link" href="#" onclick="fetchInboxMessages(1); return false;">1</a></li>`);
      if (startPage > 2) paginationUl.insertAdjacentHTML('beforeend', `<li class="page-item disabled"><a class="page-link" href="#">...</a></li>`);
    }

    for (let i = startPage; i <= endPage; i++) {
      const activeClass = (i === currentPageNumber) ? 'active' : '';
      paginationUl.insertAdjacentHTML('beforeend', `
                    <li class="page-item \${activeClass}">
                        <a class="page-link" href="#" onclick="fetchInboxMessages(\${i}); return false;">\${i}</a>
                    </li>
                `);
    }

    if (endPage < totalPages) {
      if (endPage < totalPages - 1) paginationUl.insertAdjacentHTML('beforeend', `<li class="page-item disabled"><a class="page-link" href="#">...</a></li>`);
      paginationUl.insertAdjacentHTML('beforeend', `<li class="page-item"><a class="page-link" href="#" onclick="fetchInboxMessages(\${totalPages}); return false;">\${totalPages}</a></li>`);
    }

    const nextClass = paginationData.hasNext ? '' : 'disabled';
    paginationUl.insertAdjacentHTML('beforeend', `
                <li class="page-item \${nextClass}">
                    <a class="page-link" href="#" onclick="if(!this.parentNode.classList.contains('disabled')) fetchInboxMessages(\${currentPageNumber + 1}); return false;">다음</a>
                </li>
            `);
  }
</script>
</body>
</html>