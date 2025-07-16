<%-- src/main/webapp/WEB-INF/views/message/inbox.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>받은 쪽지함</title>
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
    .message-status b { color: #d9534f; } /* 읽지 않은 쪽지 강조 */
    .message-status .recalled { color: gray; text-decoration: line-through; } /* 회수된 쪽지 스타일 */

    .favorite-icon { cursor: pointer; color: #ccc; font-size: 1.2em; padding: 0 5px; line-height: 1; vertical-align: middle; }
    .favorite-icon.active { color: gold; } /* 중요 표시된 쪽지 */
    .favorite-form { display: inline-block; margin: 0; padding: 0; line-height: 1; }
    .favorite-form button { background: none; border: none; padding: 0; cursor: pointer; line-height: 1; vertical-align: middle; }

    .action-button { background-color: #d9534f; color: white; border: none; padding: 8px 12px; border-radius: 4px; cursor: pointer; font-size: 0.9em; transition: background-color 0.2s ease; white-space: nowrap; }
    .action-button:hover { background-color: #c9302c; }
    .action-form { display: inline-block; margin: 0; padding: 0; }

    /* 푸터 스타일 */
    footer { text-align: center; padding: 10px; font-size: 12px; color: #999; margin-top: 20px; }
  </style>
</head>
<body>
<%-- top.jsp include --%>
<c:import url="/WEB-INF/views/common/top.jsp" />

<%-- currentPage 변수를 설정하여 사이드바에서 현재 페이지를 활성화 --%>
<c:set var="currentPage" value="inbox" scope="request" />

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
    <h1>받은 쪽지함</h1>

    <%-- 서버에서 전달된 메시지/에러 메시지 표시 영역 --%>
    <div id="serverMessageArea">
      <c:if test="${not empty message}">
        <p class="alert alert-info text-center">${message}</p>
      </c:if>
      <c:if test="${not empty errorMessage}">
        <p class="alert alert-danger text-center">${errorMessage}</p>
      </c:if>
    </div>

    <%-- 쪽지 목록이 로드될 영역 --%>
    <div id="messageListArea" class="table-responsive">
      <p>쪽지 목록을 불러오는 중...</p>
    </div>

    <%-- 페이징 컨트롤이 로드될 영역 --%>
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

    // 현재 페이지 상태 변수
    let currentPage = 1;
    let pageSize = 10; // 기본 페이지 크기

    // 1. 쪽지 목록 데이터를 가져와서 렌더링하는 함수
    async function fetchAndRenderMessages(page = 1, size = 10) {
      currentPage = page; // 현재 페이지 업데이트
      pageSize = size;

      messageListArea.innerHTML = '<p>쪽지 목록을 불러오는 중...</p>';
      try {
        // MessageRestController의 /api/v1/messages/inbox API 호출
        const response = await fetch(`/api/v1/messages/inbox?page=\${page}&size=\${size}`);
        if (!response.ok) {
          // 세션 만료 등의 오류 처리
          if (response.status === 401) {
            displayClientMessage('세션이 만료되었거나 발신자가 선택되지 않았습니다. 조직도에서 발신자를 다시 선택해주세요.', 'danger');
            messageListArea.innerHTML = ''; // 목록 비우기
            paginationContainer.innerHTML = ''; // 페이징 비우기
            return;
          }
          throw new Error(`HTTP error! status: \${response.status}`);
        }
        const paginationResponse = await response.json(); // PaginationResponse DTO를 JSON으로 받음
        console.log('받은 쪽지 목록 데이터:', paginationResponse);

        renderMessageTable(paginationResponse.content); // 쪽지 테이블 렌더링
        renderPagination(paginationResponse); // 페이징 컨트롤 렌더링

      } catch (error) {
        console.error('받은 쪽지 목록을 불러오는 중 오류 발생:', error);
        messageListArea.innerHTML = `<p class="alert alert-danger">쪽지 목록을 불러올 수 없습니다. 오류: \${error.message}</p>`;
        paginationContainer.innerHTML = '';
      }
    }

    // 2. 받은 쪽지 목록을 HTML 테이블로 렌더링하는 함수
    function renderMessageTable(messages) {
      if (!messages || messages.length === 0) {
        messageListArea.innerHTML = '<p class="text-center text-muted">받은 쪽지가 없습니다.</p>';
        return;
      }

      let tableHtml = `
                <table class="table table-bordered table-hover">
                    <thead>
                        <tr>
                            <th>상태</th>
                            <th>중요</th>
                            <th>보낸 사람</th>
                            <th>제목</th>
                            <th>받은 일시</th>
                            <th>액션</th>
                        </tr>
                    </thead>
                    <tbody>
            `;

      messages.forEach(msg => {
        const statusHtml = msg.inboxStatus === 'UNREAD' ? '<b>읽지않음</b>' :
                msg.inboxStatus === 'RECALLED_BY_SENDER' ? '<span class="recalled">회수됨</span>' : '읽음';
        const importantIconHtml = msg.importantYn === 'Y' ? '<span class="favorite-icon active">★</span>' : '<span class="favorite-icon">★</span>';
        const subjectLinkHtml = msg.inboxStatus === 'RECALLED_BY_SENDER' ?
                `<span class="recalled">\${msg.subject} (회수됨)</span>` :
                `<a href="/message/detail?messageId=\${msg.messageId}">\${msg.subject}</a>`;
        const formattedDate = new Date(msg.sendDate).toLocaleString('ko-KR', {
          year: 'numeric', month: '2-digit', day: '2-digit',
          hour: '2-digit', minute: '2-digit', hour12: false
        });

        tableHtml += `
                    <tr>
                        <td class="message-status">\${statusHtml}</td>
                        <td>
                            <form class="favorite-form" data-receive-id="\${msg.receiveId}" data-important-yn="\${msg.importantYn}">
                                <button type="button">\${importantIconHtml}</button>
                            </form>
                        </td>
                        <td>\${msg.senderName}</td>
                        <td class="message-title">\${subjectLinkHtml}</td>
                        <td>\${formattedDate}</td>
                        <td>
                            <form class="action-form delete-inbox-form" data-receive-id="\${msg.receiveId}">
                                <button type="button" class="action-button btn btn-danger btn-sm">삭제</button>
                            </form>
                        </td>
                    </tr>
                `;
      });

      tableHtml += `</tbody></table>`;
      messageListArea.innerHTML = tableHtml;

      // 이벤트 리스너 다시 연결 (동적으로 생성된 요소들)
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

      // endPage가 totalPages에 고정되면 startPage도 조정
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
      paginationContainer.innerHTML = paginationHtml;

      // 페이징 버튼 클릭 이벤트 리스너 연결
      paginationContainer.querySelectorAll('.page-link').forEach(link => {
        link.addEventListener('click', function(e) {
          e.preventDefault();
          if (!this.closest('.page-item').classList.contains('disabled')) {
            const targetPage = parseInt(this.dataset.page);
            fetchAndRenderMessages(targetPage, pageSize); // 새로운 페이지 데이터 로드
          }
        });
      });
    }

    // 4. 테이블 내 액션 버튼 (삭제, 중요 표시) 이벤트 리스너 연결 함수
    function attachTableEventListeners() {
      // 중요 표시/해제 버튼
      document.querySelectorAll('.favorite-form button').forEach(button => {
        button.addEventListener('click', async function() {
          const form = this.closest('.favorite-form');
          const receiveId = form.dataset.receiveId;
          const currentImportantYn = form.dataset.importantYn;
          const newImportantYn = currentImportantYn === 'Y' ? 'N' : 'Y'; // Y -> N, N -> Y

          try {
            const response = await fetch(`/api/v1/messages/inbox/toggleImportant/\${receiveId}?importantYn=\${newImportantYn}`, {
              method: 'POST',
              headers: { 'Content-Type': 'application/json' } // POST body가 없어도 명시
            });
            const result = await response.json();
            if (response.ok) {
              displayClientMessage(result.message, 'info');
              fetchAndRenderMessages(currentPage, pageSize); // 목록 새로고침
            } else {
              displayClientMessage(result.message || '중요 표시 변경 실패!', 'danger');
            }
          } catch (error) {
            console.error('중요 표시 변경 중 오류:', error);
            displayClientMessage('중요 표시 변경 중 네트워크 오류.', 'danger');
          }
        });
      });

      // 삭제 버튼
      document.querySelectorAll('.delete-inbox-form button').forEach(button => {
        button.addEventListener('click', async function() {
          if (!confirm('정말 이 쪽지를 삭제하시겠습니까?')) {
            return;
          }
          const form = this.closest('.delete-inbox-form');
          const receiveId = form.dataset.receiveId;

          try {
            const response = await fetch(`/api/v1/messages/inbox/delete/\${receiveId}`, {
              method: 'POST',
              headers: { 'Content-Type': 'application/json' }
            });
            const result = await response.json();
            if (response.ok) {
              displayClientMessage(result.message, 'info');
              fetchAndRenderMessages(currentPage, pageSize); // 목록 새로고침
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

    // 클라이언트 측 메시지 표시 함수 (서버 메시지 영역과 별개)
    function displayClientMessage(message, type) {
      const tempMessageDiv = document.createElement('div');
      tempMessageDiv.innerHTML = `<p class="alert alert-\${type} text-center">\${message}</p>`;
      serverMessageArea.prepend(tempMessageDiv); // 기존 메시지 위에 추가

      setTimeout(() => {
        tempMessageDiv.remove(); // 5초 후 메시지 제거
      }, 5000);
    }

    // 초기 로드: 받은 쪽지함 데이터 가져오기
    fetchAndRenderMessages(currentPage, pageSize);
  });
</script>
</body>
</html>