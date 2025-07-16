<%-- src/main/webapp/WEB-INF/views/message/message_send_prepared.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title><c:out value="${formTitle}"/></title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    /* message_send.jsp의 스타일과 동일하게 복사 */
    body { background-color: #f7f7f7; font-family: Arial, sans-serif; margin: 0; }
    .container { display: flex; padding: 20px; max-width: 1200px; margin: 20px auto; }
    .sidebar { width: 200px; background-color: white; border-radius: 8px; padding: 15px; margin-right: 20px; box-shadow: 0 0 5px rgba(0,0,0,0.1); }
    .sidebar h3 { margin-top: 0; font-size: 16px; border-bottom: 1px solid #ddd; padding-bottom: 10px; }
    .sidebar ul { list-style: none; padding: 0; }
    .sidebar ul li { margin: 10px 0; }
    .sidebar ul li a { color: #333; text-decoration: none; }
    .sidebar ul li a.active, .sidebar ul li a:hover { color: #1abc9c; font-weight: bold; }
    .main-content { flex: 1; background-color: white; border-radius: 8px; padding: 20px; box-shadow: 0 0 5px rgba(0,0,0,0.1); }

    .message-form-container { max-width: 700px; margin: 0 auto; padding: 10px 0; }
    .message-form-container div.mb-3 { display: block; margin-bottom: 15px; }
    .message-form-container label { display: block; margin-bottom: 5px; font-weight: bold; text-align: left; padding-right: 0; width: auto; }
    .message-form-container input[type="text"],
    .message-form-container textarea { padding: 10px; border: 1px solid #ddd; border-radius: 4px; font-size: 1em; width: 100%; }
    .message-form-container textarea { min-height: 200px; resize: vertical; }
    .message-form-container button[type="submit"] { background-color: #007bff; color: white; border: none; padding: 8px 18px; border-radius: 4px; cursor: pointer; font-size: 0.95em; transition: background-color 0.2s ease; display: block; margin: 20px auto 0; width: auto; min-width: 100px; max-width: 180px; }
    .message-form-container button[type="submit"]:hover { background-color: #0056b3; }
    .message-form-container .alert { margin-bottom: 1rem; padding: .75rem 1.25rem; border-radius: .25rem; }

    .main-content h1 { text-align: center; margin-bottom: 30px; }

    .sender-info-box { background-color: #e9f7ef; border: 1px solid #c8e6c9; padding: 10px 15px; border-radius: 5px; margin-bottom: 20px; font-size: 0.9em; color: #2e7d32; }
    .sender-info-box strong { display: block; margin-bottom: 5px; }

    /* 푸터 스타일 */
    footer { text-align: center; padding: 10px; font-size: 12px; color: #999; margin-top: 20px; }
  </style>
</head>
<body>
<%-- top.jsp include --%>
<c:import url="/WEB-INF/views/common/top.jsp" />

<%-- currentPage 변수를 설정하여 사이드바에서 현재 페이지를 활성화 --%>
<c:set var="currentPage" value="send" scope="request"/>

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
    <h1><c:out value="${formTitle}"/></h1>

    <%-- 발신자 정보 표시 --%>
    <c:if test="${not empty currentSender}">
      <div class="sender-info-box text-center">
        <strong>발신자:</strong> ${currentSender.name} (${currentSender.userId}) - ${currentSender.positionName}
      </div>
    </c:if>
    <c:if test="${empty currentSender}">
      <div class="alert alert-danger text-center">
        <strong>발신자 정보 없음:</strong> 쪽지를 발송하려면 발신자를 지정해야 합니다. <a href="/dept/chart-dynamic" class="alert-link">조직도에서 발신자 선택</a>
      </div>
    </c:if>

    <%-- 메시지/에러 메시지 표시 영역 --%>
    <div id="messageArea">
      <c:if test="${not empty message}">
        <p class="alert alert-info text-center">${message}</p>
      </c:if>
      <c:if test="${not empty errorMessage}">
        <p class="alert alert-danger text-center">${errorMessage}</p>
      </c:if>
    </div>

    <form id="sendMessageForm" class="message-form-container">
      <div class="mb-3">
        <label for="receiverIds" class="form-label">수신 (TO):</label>
        <%-- preparedMessage에서 첫 번째 TO 수신자 ID를 가져옴 --%>
        <input type="text" id="receiverIds" name="receiverIds"
               value="<c:out value="${not empty preparedMessage.receiverIds ? preparedMessage.receiverIds[0] : ''}"/>"
               class="form-control" placeholder="쉼표(,)로 구분된 사용자 ID" required>
      </div>
      <div class="mb-3">
        <label for="ccIds" class="form-label">참조 (CC):</label>
        <%-- preparedMessage에서 첫 번째 CC 수신자 ID를 가져옴 --%>
        <input type="text" id="ccIds" name="ccIds"
               value="<c:out value="${not empty preparedMessage.ccIds ? preparedMessage.ccIds[0] : ''}"/>"
               class="form-control" placeholder="쉼표(,)로 구분된 사용자 ID (선택 사항)">
      </div>
      <div class="mb-3">
        <label for="bccIds" class="form-label">숨은 참조 (BCC):</label>
        <%-- preparedMessage에서 첫 번째 BCC 수신자 ID를 가져옴 --%>
        <input type="text" id="bccIds" name="bccIds"
               value="<c:out value="${not empty preparedMessage.bccIds ? preparedMessage.bccIds[0] : ''}"/>"
               class="form-control" placeholder="쉼표(,)로 구분된 사용자 ID (선택 사항)">
      </div>
      <div class="mb-3">
        <label for="subject" class="form-label">제목:</label>
        <input type="text" id="subject" name="subject"
               value="<c:out value="${preparedMessage.subject}"/>"
               class="form-control" required <c:if test="${messageType eq 'reply'}">readonly</c:if>>
      </div>
      <div class="mb-3">
        <label for="messageContent" class="form-label">내용:</label>
        <textarea id="messageContent" name="messageContent" class="form-control" placeholder="쪽지 내용을 입력하세요." required rows="15"><c:out value="${preparedMessage.messageContent}"/></textarea>
      </div>
      <button type="submit" class="btn btn-primary">쪽지 발송</button>
    </form>
  </div>
</div>

<footer>
  <p>© 2025 그룹웨어 Corp.</p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
  document.addEventListener('DOMContentLoaded', function() {
    const sendMessageForm = document.getElementById('sendMessageForm');
    const messageArea = document.getElementById('messageArea');

    // 폼 제출 이벤트 핸들러 (message_send.jsp와 동일한 로직)
    sendMessageForm.addEventListener('submit', async function(event) {
      event.preventDefault();

      const receiverIdsRaw = document.getElementById('receiverIds').value.trim();
      const ccIdsRaw = document.getElementById('ccIds').value.trim();
      const bccIdsRaw = document.getElementById('bccIds').value.trim();
      const subject = document.getElementById('subject').value.trim();
      const messageContent = document.getElementById('messageContent').value.trim();

      function parseIds(idString) {
        if (!idString) return [];
        return idString.split(',').map(id => {
          const trimmedId = String(id).trim();
          if (trimmedId === '') return null;
          const parsedId = Number(trimmedId);
          return isNaN(parsedId) ? null : parsedId;
        }).filter(id => id !== null);
      }

      const receiverIds = parseIds(receiverIdsRaw);
      const ccIds = parseIds(ccIdsRaw);
      const bccIds = parseIds(bccIdsRaw);

      if (receiverIds.length === 0) {
        displayMessage('수신 (TO) 사용자를 한 명 이상 입력해주세요.', 'danger');
        return;
      }
      if (!subject) {
        displayMessage('쪽지 제목을 입력해주세요.', 'danger');
        return;
      }
      if (!messageContent) {
        displayMessage('쪽지 내용을 입력해주세요.', 'danger');
        return;
      }

      const currentSenderBox = document.querySelector('.sender-info-box');
      if (!currentSenderBox || currentSenderBox.textContent.includes('발신자 정보 없음')) {
        displayMessage('쪽지 발송을 위해 먼저 조직도에서 발신자를 선택해주세요.', 'danger');
        return;
      }

      const messageData = {
        receiverIds: receiverIds,
        ccIds: ccIds,
        bccIds: bccIds,
        subject: subject,
        messageContent: messageContent
      };

      try {
        const response = await fetch('/api/v1/messages/send', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(messageData)
        });
        const result = await response.json();

        if (response.ok) {
          displayMessage(result.message || '쪽지가 성공적으로 발송되었습니다.', 'info');
          // 답장/전달 폼에서는 보통 폼을 초기화하지 않고, 발송 완료 메시지 후 닫거나 다른 페이지로 이동
          // 예: 발송 성공 후 받은 쪽지함으로 이동
          // setTimeout(() => window.location.href = '/message/inbox', 1500);
        } else {
          displayMessage(result.message || '쪽지 발송에 실패했습니다.', 'danger');
        }
      } catch (error) {
        console.error('쪽지 발송 중 오류 발생:', error);
        displayMessage('네트워크 오류 또는 서버 응답 처리 실패: ' + error.message, 'danger');
      }
    });

    // 메시지를 표시하는 헬퍼 함수
    function displayMessage(message, type) {
      messageArea.innerHTML = `<p class="alert alert-\${type} text-center">\${message}</p>`;
    }
  });
</script>
</body>
</html>