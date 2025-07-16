<%-- src/main/webapp/WEB-INF/views/message/message_detail.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>쪽지 상세</title>
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

    /* 메시지 상세 페이지에 특화된 스타일 */
    .detail-table th, .detail-table td {
      padding: 12px 15px;
      text-align: left;
      border-bottom: 1px solid #eee;
      vertical-align: top;
    }
    .detail-table th {
      width: 120px;
      background-color: #f8f8f8;
      color: #555;
      font-weight: bold;
    }
    .detail-table pre {
      white-space: pre-wrap; /* 줄 바꿈 유지 */
      word-break: break-word; /* 긴 단어 강제 줄 바꿈 */
      margin: 0;
      font-family: inherit; /* 본문 폰트 유지 */
      line-height: 1.6;
    }
    .message-title-area {
      margin-bottom: 20px;
    }
    .message-title-area h1 {
      font-size: 1.8em;
      margin-top: 0;
      margin-bottom: 10px;
    }
    .message-meta {
      font-size: 0.9em;
      color: #777;
      border-bottom: 1px solid #eee;
      padding-bottom: 10px;
      margin-bottom: 15px;
    }
    .message-content-box {
      border: 1px solid #eee;
      padding: 15px;
      min-height: 200px;
      background-color: #fcfcfc;
      line-height: 1.6;
    }
    .action-buttons-bottom {
      display: flex;
      justify-content: center;
      margin-top: 25px;
    }
    .action-buttons-bottom .btn {
      margin: 0 5px;
    }
    .message-status-badge {
      font-size: 0.8em;
      padding: .3em .6em;
      border-radius: .25rem;
      color: white;
      background-color: #6c757d; /* default */
    }
    .message-status-badge.unread { background-color: #dc3545; } /* Read Status */
    .message-status-badge.read { background-color: #28a745; }
    .message-status-badge.recalled { background-color: #ffc107; color: #343a40; } /* Recalled Status */

    /* 푸터 스타일 */
    footer { text-align: center; padding: 10px; font-size: 12px; color: #999; margin-top: 20px; }
  </style>
</head>
<body>
<%-- top.jsp include --%>
<c:import url="/WEB-INF/views/common/top.jsp" />

<%-- currentPage 변수를 설정하여 사이드바에서 현재 페이지를 활성화 --%>
<c:set var="currentPage" value="messageDetail" scope="request"/>

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
    <h1>쪽지 상세</h1>

    <div id="serverMessageArea">
      <c:if test="${not empty message}">
        <p class="alert alert-info text-center">${message}</p>
      </c:if>
      <c:if test="${not empty errorMessage}">
        <p class="alert alert-danger text-center">${errorMessage}</p>
      </c:if>
    </div>

    <%-- 쪽지 상세 내용이 로드될 영역 --%>
    <div id="messageDetailArea">
      <p>쪽지 상세 정보를 불러오는 중...</p>
    </div>
  </div>
</div>

<footer>
  <p>© 2025 그룹웨어 Corp.</p>
</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
  document.addEventListener('DOMContentLoaded', function() {
    // URL에서 messageId 파라미터 가져오기
    const urlParams = new URLSearchParams(window.location.search);
    const messageId = urlParams.get('messageId');

    const messageDetailArea = document.getElementById('messageDetailArea');
    const serverMessageArea = document.getElementById('serverMessageArea');

    if (!messageId) {
      messageDetailArea.innerHTML = '<p class="alert alert-danger text-center">조회할 쪽지 ID가 없습니다.</p>';
      return;
    }

    // 1. 쪽지 상세 데이터를 가져와서 렌더링하는 함수
    async function fetchAndRenderMessageDetail() {
      messageDetailArea.innerHTML = '<p>쪽지 상세 정보를 불러오는 중...</p>';
      try {
        const response = await fetch(`/api/v1/messages/detail/\${messageId}`);
        if (!response.ok) {
          if (response.status === 401) {
            displayClientMessage('세션이 만료되었거나 발신자가 선택되지 않았습니다. 조직도에서 발신자를 다시 선택해주세요.', 'danger');
            messageDetailArea.innerHTML = '';
            return;
          } else if (response.status === 404) {
            messageDetailArea.innerHTML = '<p class="alert alert-danger text-center">해당 쪽지를 찾을 수 없거나, 조회 권한이 없습니다. (회수되었을 수 있습니다)</p>';
            return;
          }
          throw new Error(`HTTP error! status: \${response.status}`);
        }
        const messageDetail = await response.json();
        console.log('쪽지 상세 데이터:', messageDetail);

        renderDetailContent(messageDetail); // 상세 내용 렌더링
        attachDetailEventListeners(messageDetail); // 액션 버튼 이벤트 리스너 연결

      } catch (error) {
        console.error('쪽지 상세 정보를 불러오는 중 오류 발생:', error);
        messageDetailArea.innerHTML = `<p class="alert alert-danger">쪽지 상세 정보를 불러올 수 없습니다. 오류: \${error.message}</p>`;
      }
    }

    // 2. 쪽지 상세 내용을 HTML로 렌더링하는 함수
    function renderDetailContent(detail) {
      if (!detail || !detail.messageId) {
        messageDetailArea.innerHTML = '<p class="alert alert-danger text-center">쪽지 데이터를 불러오지 못했습니다.</p>';
        return;
      }

      // 날짜 포맷팅 헬퍼
      const formatDate = (dateString) => {
        if (!dateString) return '-';
        return new Date(dateString).toLocaleString('ko-KR', {
          year: 'numeric', month: '2-digit', day: '2-digit',
          hour: '2-digit', minute: '2-digit', hour12: false
        });
      };

      // 수신자 이름 목록을 콤마로 연결하는 헬퍼
      const joinNames = (names) => names && names.length > 0 ? names.join(', ') : '-';

      // 받은 쪽지함 상태 뱃지
      let inboxStatusBadge = '';
      if (detail.inboxStatus) {
        let badgeClass = 'badge-secondary'; // 기본값
        let badgeText = detail.inboxStatus;
        if (detail.inboxStatus === 'UNREAD') { badgeClass = 'badge-danger unread'; badgeText = '읽지않음'; }
        else if (detail.inboxStatus === 'READ') { badgeClass = 'badge-success read'; badgeText = '읽음'; }
        else if (detail.inboxStatus === 'RECALLED_BY_SENDER') { badgeClass = 'badge-warning recalled'; badgeText = '회수됨'; }
        inboxStatusBadge = `<span class="message-status-badge \${badgeClass}">\${badgeText}</span>`;
      }

      // TO/CC/BCC 목록 HTML 생성
      let toHtml = `<tr><th>수신 (TO)</th><td>\${joinNames(detail.toUserNames)}</td></tr>`;
      let ccHtml = detail.ccUserNames && detail.ccUserNames.length > 0 ?
              `<tr><th>참조 (CC)</th><td>\${joinNames(detail.ccUserNames)}</td></tr>` : '';
      let bccHtml = detail.bccUserNames && detail.bccUserNames.length > 0 ?
              `<tr><th>숨은 참조 (BCC)</th><td>\${joinNames(detail.bccUserNames)}</td></tr>` : '';

      const htmlContent = `
                <div class="message-title-area">
                    <h1>\${detail.subject || '제목 없음'}</h1>
                    <div class="message-meta">
                        <p><strong>발신자:</strong> \${detail.senderName || '알 수 없음'} (\${detail.senderId || ''})</p>
                        <p><strong>발송일시:</strong> \${formatDate(detail.sendDate)}</p>
                        <p><strong>상태:</strong> \${inboxStatusBadge}</p>
                    </div>
                </div>

                <table class="table table-bordered detail-table">
                    \${toHtml}
                    \${ccHtml}
                    \${bccHtml}
                </table>

                <div class="message-content-box">
                    <pre>\${detail.messageContent || '내용 없음'}</pre>
                </div>

                <div class="action-buttons-bottom">
                    <a href="/message/send-prepared?originalMessageId=\${detail.messageId}&type=reply" class="btn btn-primary me-2">답장</a>
                    <a href="/message/send-prepared?originalMessageId=\${detail.messageId}&type=forward" class="btn btn-primary">전달</a>
                </div>

                <div class="action-buttons-bottom mt-3">
                    <button type="button" class="btn btn-warning me-2 \${detail.currentlyRecallable ? '' : 'd-none'}" id="recallMessageBtn" data-message-id="\${detail.messageId}">쪽지 회수</button>
                    <button type="button" class="btn btn-danger me-2 \${detail.receiveId ? '' : 'd-none'}" id="deleteReceivedMessageBtn" data-receive-id="\${detail.receiveId}">받은 쪽지 삭제</button>
                    <button type="button" class="btn btn-danger me-2 \${detail.sendId ? '' : 'd-none'}" id="deleteSentMessageBtn" data-send-id="\${detail.sendId}">보낸 쪽지 삭제</button>
                </div>

                <div class="action-buttons-bottom mt-3">
                    <a href="/message/inbox" class="btn btn-secondary me-2">받은 쪽지함으로</a>
                    <a href="/message/sentbox" class="btn btn-secondary me-2">보낸 쪽지함으로</a>
                    <a href="/" class="btn btn-secondary">홈으로</a>
                </div>
            `;
      messageDetailArea.innerHTML = htmlContent;
    }

    // 3. 액션 버튼 이벤트 리스너 연결 함수
    function attachDetailEventListeners(detail) {
      // 쪽지 회수 버튼
      const recallBtn = document.getElementById('recallMessageBtn');
      if (recallBtn) {
        recallBtn.addEventListener('click', async function() {
          if (!confirm('정말 이 쪽지를 회수하시겠습니까? 읽지 않은 수신자에게서만 회수되며, 알림은 사라집니다.')) return;
          try {
            const response = await fetch(`/api/v1/messages/recall/\${detail.messageId}`, { method: 'POST' });
            const result = await response.json();
            if (response.ok) {
              displayClientMessage(result.message, 'info');
              fetchAndRenderMessageDetail(); // 상세 정보 새로고침
            } else {
              displayClientMessage(result.message || '쪽지 회수 실패!', 'danger');
            }
          } catch (error) {
            console.error('쪽지 회수 중 오류:', error);
            displayClientMessage('쪽지 회수 중 네트워크 오류.', 'danger');
          }
        });
      }

      // 받은 쪽지 삭제 버튼
      const deleteInboxBtn = document.getElementById('deleteReceivedMessageBtn');
      if (deleteInboxBtn) {
        deleteInboxBtn.addEventListener('click', async function() {
          if (!confirm('정말 이 쪽지를 받은 쪽지함에서 삭제하시겠습니까?')) return;
          try {
            const response = await fetch(`/api/v1/messages/inbox/delete/\${detail.receiveId}`, { method: 'POST' });
            const result = await response.json();
            if (response.ok) {
              displayClientMessage(result.message, 'info');
              // 삭제 후 받은 쪽지함으로 이동
              setTimeout(() => window.location.href = '/message/inbox', 1000);
            } else {
              displayClientMessage(result.message || '쪽지 삭제 실패!', 'danger');
            }
          } catch (error) {
            console.error('받은 쪽지 삭제 중 오류:', error);
            displayClientMessage('받은 쪽지 삭제 중 네트워크 오류.', 'danger');
          }
        });
      }

      // 보낸 쪽지 삭제 버튼
      const deleteSentBtn = document.getElementById('deleteSentMessageBtn');
      if (deleteSentBtn) {
        deleteSentBtn.addEventListener('click', async function() {
          if (!confirm('정말 이 쪽지를 보낸 쪽지함에서 삭제하시겠습니까?')) return;
          try {
            const response = await fetch(`/api/v1/messages/sentbox/delete/\${detail.sendId}`, { method: 'POST' });
            const result = await response.json();
            if (response.ok) {
              displayClientMessage(result.message, 'info');
              // 삭제 후 보낸 쪽지함으로 이동
              setTimeout(() => window.location.href = '/message/sentbox', 1000);
            } else {
              displayClientMessage(result.message || '쪽지 삭제 실패!', 'danger');
            }
          } catch (error) {
            console.error('보낸 쪽지 삭제 중 오류:', error);
            displayClientMessage('보낸 쪽지 삭제 중 네트워크 오류.', 'danger');
          }
        });
      }
    }

    // 클라이언트 측 메시지 표시 함수
    function displayClientMessage(message, type) {
      const tempMessageDiv = document.createElement('div');
      tempMessageDiv.innerHTML = `<p class="alert alert-\${type} text-center">\${message}</p>`;
      serverMessageArea.prepend(tempMessageDiv);

      setTimeout(() => {
        tempMessageDiv.remove();
      }, 5000);
    }

    fetchAndRenderMessageDetail(); // 페이지 로드 시 상세 정보 가져오기
  });
</script>
</body>
</html>