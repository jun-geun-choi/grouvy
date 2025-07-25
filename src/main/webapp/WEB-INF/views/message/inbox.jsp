<%-- **파일 경로:** src/main/resources/META-INF/resources/WEB-INF/views/message/inbox.jsp --%>
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
  <!-- CSRF 토큰 관련 메타 태그는 SecurityConfig에서 csrf.disable() 했으므로 제거합니다. -->
  <%-- <meta name="_csrf" content="${_csrf.token}"/> --%>
  <%-- <meta name="_csrf_header" content="${_csrf.headerName}"/> --%>

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
    fetchInboxMessages(currentPage);
  });

  // 받은 쪽지 목록을 Fetch하는 함수
  function fetchInboxMessages(page) {
    const inboxTableBody = document.getElementById('inboxTableBody');
    inboxTableBody.innerHTML = '<tr><td colspan="5" class="text-center">쪽지를 불러오는 중...</td></tr>'; // 로딩 메시지

    fetch(`/api/v1/messages/inbox?page=\${page}&size=\${pageSize}`)
            .then(response => {
              // HTTP 401 Unauthorized 처리
              if (response.status === 401) {
                inboxTableBody.innerHTML = '<tr><td colspan="5" class="text-center text-danger">로그인이 필요합니다.</td></tr>';
                return Promise.reject('Unauthorized'); // 다음 then 블록 실행 방지
              }
              // HTTP 응답이 성공적이지 않으면 (예: 404, 500)
              if (!response.ok) {
                return response.json().then(errorData => {
                  // 서버에서 보낸 에러 메시지가 있다면 사용, 없으면 일반 메시지
                  throw new Error(errorData.message || '쪽지 목록 불러오기 실패');
                });
              }
              return response.json(); // 성공 응답의 JSON 본문을 파싱
            })
            .then(data => {
              inboxTableBody.innerHTML = ''; // 기존 내용 초기화
              // data.content가 유효한 배열인지 확인
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
                  inboxTableBody.insertAdjacentHTML('beforeend', row); // 행 추가
                });
                setupRowClickListeners(); // 각 행에 클릭 이벤트 리스너 추가
                renderPagination(data); // 페이지네이션 렌더링
              } else {
                inboxTableBody.innerHTML = '<tr><td colspan="5" class="text-center">받은 쪽지가 없습니다.</td></tr>';
                renderPagination(data); // 빈 목록일 때도 페이지네이션 초기화 (버튼은 보임)
              }
            })
            .catch(error => {
              console.error('Error fetching inbox messages:', error); // 콘솔에 에러 출력
              if (error !== 'Unauthorized') { // 'Unauthorized' 오류는 이미 처리했으므로 중복 알림 방지
                inboxTableBody.innerHTML = `<tr><td colspan="5" class="text-center text-danger">쪽지 목록을 불러오는 중 오류 발생: \${error.message}</td></tr>`;
              }
              document.getElementById('pagination').innerHTML = ''; // 에러 발생 시 페이지네이션 제거
            });
  }

  // 테이블 행 클릭 시 쪽지 상세 페이지로 이동하는 이벤트 리스너 설정
  function setupRowClickListeners() {
    document.querySelectorAll('#inboxTableBody tr').forEach(row => {
      row.addEventListener('click', function() {
        const messageId = this.dataset.messageId; // data-message-id 속성 값 가져오기
        if (messageId) {
          window.location.href = `/message/detail?messageId=\${messageId}`; // 상세 페이지로 이동
        }
      });
    });
  }

  // 날짜 포맷 함수 (YYYY-MM-DD HH:MM)
  function formatDate(dateString) {
    if (!dateString) return '';
    const date = new Date(dateString);
    const options = { year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit' };
    return date.toLocaleDateString('ko-KR', options);
  }

  // 페이지네이션 UI 렌더링 함수
  function renderPagination(paginationData) {
    const paginationUl = document.getElementById('pagination');
    paginationUl.innerHTML = ''; // 기존 페이지네이션 초기화

    const totalPages = paginationData.totalPages;
    const currentPageNumber = paginationData.pageNumber + 1; // API는 0-based, UI는 1-based

    // '이전' 버튼
    const prevClass = paginationData.hasPrevious ? '' : 'disabled'; // 이전 페이지 없으면 비활성화
    paginationUl.insertAdjacentHTML('beforeend', `
                <li class="page-item \${prevClass}">
                    <a class="page-link" href="#" onclick="if(!this.parentNode.classList.contains('disabled')) fetchInboxMessages(\${currentPageNumber - 1}); return false;">이전</a>
                </li>
            `);

    // 페이지 번호들 (예: 현재 페이지 주변으로 10개 표시)
    let startPage = Math.max(1, currentPageNumber - 4);
    let endPage = Math.min(totalPages, currentPageNumber + 5);

    // 총 10개 페이지 버튼을 유지하기 위한 조정
    if (endPage - startPage < 9) {
      startPage = Math.max(1, endPage - 9);
    }
    // 첫 페이지가 1보다 크면 '1' 버튼 및 '...' 추가
    if (startPage > 1) {
      paginationUl.insertAdjacentHTML('beforeend', `<li class="page-item"><a class="page-link" href="#" onclick="fetchInboxMessages(1); return false;">1</a></li>`);
      if (startPage > 2) paginationUl.insertAdjacentHTML('beforeend', `<li class="page-item disabled"><a class="page-link" href="#">...</a></li>`);
    }

    // 실제 페이지 번호 버튼들
    for (let i = startPage; i <= endPage; i++) {
      const activeClass = (i === currentPageNumber) ? 'active' : ''; // 현재 페이지는 active 클래스 추가
      paginationUl.insertAdjacentHTML('beforeend', `
                    <li class="page-item \${activeClass}">
                        <a class="page-link" href="#" onclick="fetchInboxMessages(\${i}); return false;">\${i}</a>
                    </li>
                `);
    }

    // 마지막 페이지가 totalPages보다 작으면 '...' 및 마지막 페이지 버튼 추가
    if (endPage < totalPages) {
      if (endPage < totalPages - 1) paginationUl.insertAdjacentHTML('beforeend', `<li class="page-item disabled"><a class="page-link" href="#">...</a></li>`);
      paginationUl.insertAdjacentHTML('beforeend', `<li class="page-item"><a class="page-link" href="#" onclick="fetchInboxMessages(\${totalPages}); return false;">\${totalPages}</a></li>`);
    }

    // '다음' 버튼
    const nextClass = paginationData.hasNext ? '' : 'disabled'; // 다음 페이지 없으면 비활성화
    paginationUl.insertAdjacentHTML('beforeend', `
                <li class="page-item \${nextClass}">
                    <a class="page-link" href="#" onclick="if(!this.parentNode.classList.contains('disabled')) fetchInboxMessages(\${currentPageNumber + 1}); return false;">다음</a>
                </li>
            `);
  }
</script>
</body>
</html>