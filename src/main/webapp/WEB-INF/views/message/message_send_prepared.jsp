<%-- src/main/resources/templates/message/message_send_prepared.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${formTitle}</title>
    <!-- CSRF 토큰을 위한 메타 태그 제거 -->
    <%-- <meta name="_csrf" content="${_csrf.token}"/> --%>
    <%-- <meta name="_csrf_header" content="${_csrf.headerName}"/> --%>

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        /* (이전과 동일한 스타일) */
        .recipient-list {
            list-style-type: none;
            padding: 0;
            margin: 0;
            display: flex;
            flex-wrap: wrap;
            gap: 5px;
            min-height: 38px;
            border: 1px solid #ced4da;
            border-radius: 0.25rem;
            padding: 0.375rem 0.75rem;
            align-items: center;
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
        .sender-info {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <h2>${formTitle}</h2>

        <div class="sender-info mb-3">
            <h5 class="mb-2"><i class="fas fa-user-circle mr-2"></i>보낸 사람</h5>
            <div id="senderDisplay">
                <c:if test="${not empty currentSender}">
                    <p class="mb-0"><strong>${currentSender.name}</strong> (${currentSender.email})</p>
                    <input type="hidden" id="senderId" value="${currentSender.userId}">
                </c:if>
                <c:if test="${empty currentSender}">
                    <p class="text-danger">발신자 정보가 없습니다. (로그인되지 않았거나 오류 발생)</p>
                </c:if>
            </div>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-warning mt-3">${errorMessage}</div>
            </c:if>
        </div>

        <form id="sendMessageForm">
            <div class="form-group">
                <label for="toRecipients">받는 사람 (TO):</label>
                <div class="input-group">
                    <ul id="toRecipients" class="form-control recipient-list">
                        <!-- 선택된 수신자가 여기에 동적으로 추가됩니다. -->
                    </ul>
                    <div class="input-group-append">
                        <button type="button" class="btn btn-outline-secondary" onclick="openRecipientModal('to')"><i class="fas fa-plus"></i></button>
                    </div>
                </div>
                <input type="hidden" id="toRecipientIds" name="receiverIds">
            </div>

            <div class="form-group">
                <label for="ccRecipients">참조 (CC):</label>
                <div class="input-group">
                    <ul id="ccRecipients" class="form-control recipient-list">
                        <!-- 선택된 수신자가 여기에 동적으로 추가됩니다. -->
                    </ul>
                    <div class="input-group-append">
                        <button type="button" class="btn btn-outline-secondary" onclick="openRecipientModal('cc')"><i class="fas fa-plus"></i></button>
                    </div>
                </div>
                <input type="hidden" id="ccRecipientIds" name="ccIds">
            </div>

            <div class="form-group">
                <label for="bccRecipients">숨은 참조 (BCC):</label>
                <div class="input-group">
                    <ul id="bccRecipients" class="form-control recipient-list">
                        <!-- 선택된 수신자가 여기에 동적으로 추가됩니다. -->
                    </ul>
                    <div class="input-group-append">
                        <button type="button" class="btn btn-outline-secondary" onclick="openRecipientModal('bcc')"><i class="fas fa-plus"></i></button>
                    </div>
                </div>
                <input type="hidden" id="bccRecipientIds" name="bccIds">
            </div>

            <div class="form-group">
                <label for="subject">제목:</label>
                <input type="text" class="form-control" id="subject" name="subject" value="${preparedMessage.subject}" required>
            </div>

            <div class="form-group">
                <label for="messageContent">내용:</label>
                <textarea class="form-control" id="messageContent" name="messageContent" rows="10" required>${preparedMessage.messageContent}</textarea>
            </div>

            <button type="submit" class="btn btn-primary">쪽지 발송</button>
            <button type="button" class="btn btn-secondary" onclick="history.back()">취소</button>
        </form>
    </div>

    <!-- 조직도 모달 포함 -->
    <%@ include file="/WEB-INF/views/department/department_list_modal.jsp" %>

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        window.currentRecipientType = '';

        const selectedUsers = {
            to: new Map(),
            cc: new Map(),
            bcc: new Map()
        };

        const allSelectedUserIds = new Set();

        document.addEventListener('DOMContentLoaded', function() {
            // **수정: Model에서 변환된 문자열로 데이터 로드**
            loadPreparedMessage(
                '${preparedReceiverIdsStr}',
                '${preparedCcIdsStr}',
                '${preparedBccIdsStr}'
            );

            document.getElementById('sendMessageForm').addEventListener('submit', function(event) {
                event.preventDefault();

                const senderId = document.getElementById('senderId').value;
                if (!senderId || parseInt(senderId, 10) === 0) {
                    alert('발신자 정보가 없습니다. (로그인 상태 확인이 필요합니다)');
                    return;
                }

                if (selectedUsers.to.size === 0) {
                    alert('받는 사람 (TO)은 반드시 1명 이상 지정해야 합니다.');
                    return;
                }

                const payload = {
                    receiverIds: parseIds(document.getElementById('toRecipientIds').value),
                    ccIds: parseIds(document.getElementById('ccRecipientIds').value),
                    bccIds: parseIds(document.getElementById('bccRecipientIds').value),
                    subject: document.getElementById('subject').value,
                    messageContent: document.getElementById('messageContent').value
                };

                // **수정: CSRF 토큰 관련 로직 제거**
                const headers = {
                    'Content-Type': 'application/json'
                };

                fetch('/api/v1/messages/send', {
                    method: 'POST',
                    headers: headers,
                    body: JSON.stringify(payload)
                })
                .then(response => {
                    if (!response.ok) {
                        return response.json().then(errorData => {
                            throw new Error(errorData.message || '쪽지 발송 실패');
                        });
                    }
                    return response.json();
                })
                .then(data => {
                    if (data.success) {
                        alert(data.message + '\n쪽지 ID: ' + data.messageId);
                        window.location.href = '/message/inbox';

                    } else {
                        alert('쪽지 발송 실패: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('쪽지 발송 중 오류가 발생했습니다: ' + error.message);
                });
            });
        });

        function loadPreparedMessage(receiverIdsStr, ccIdsStr, bccIdsStr) {
            const preparedReceiverIds = parseIds(receiverIdsStr);
            const preparedCcIds = parseIds(ccIdsStr);
            const preparedBccIds = parseIds(bccIdsStr);

            if (preparedReceiverIds && preparedReceiverIds.length > 0) {
                preparedReceiverIds.forEach(userId => {
                    fetch(`/api/v1/messages/users/\${userId}/name`)
                        .then(response => response.text())
                        .then(userName => {
                            addSelectedUser('to', userId, userName);
                        })
                        .catch(error => console.error(`Error fetching user name for ID \${userId}:`, error));
                });
            }

            if (preparedCcIds && preparedCcIds.length > 0) {
                 preparedCcIds.forEach(userId => {
                    fetch(`/api/v1/messages/users/\${userId}/name`)
                        .then(response => response.text())
                        .then(userName => {
                            addSelectedUser('cc', userId, userName);
                        })
                        .catch(error => console.error(`Error fetching user name for ID \${userId}:`, error));
                });
            }

            if (preparedBccIds && preparedBccIds.length > 0) {
                 preparedBccIds.forEach(userId => {
                    fetch(`/api/v1/messages/users/\${userId}/name`)
                        .then(response => response.text())
                        .then(userName => {
                            addSelectedUser('bcc', userId, userName);
                        })
                        .catch(error => console.error(`Error fetching user name for ID \${userId}:`, error));
                });
            }
        }

        function parseIds(idString) { /* ... */ return []; }
        function openRecipientModal(type) { /* ... */ }
        window.addSelectedUser = function(type, userId, userName) { /* ... */ };
        function removeSelectedUser(type, userId) { /* ... */ }
        function updateRecipientInputs() { /* ... */ }
    </script>
</body>
</html>