<%--src/main/resources/META-INF/resources/WEB-INF/views/message/message_send.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${formTitle}</title>

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
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
                    </ul>
                    <div class="input-group-append">
                        <button type="button" class="btn btn-outline-secondary" onclick="openRecipientModal('bcc')"><i class="fas fa-plus"></i></button>
                    </div>
                </div>
                <input type="hidden" id="bccRecipientIds" name="bccIds">
            </div>

            <div class="form-group">
                <label for="subject">제목:</label>
                <input type="text" class="form-control" id="subject" name="subject" required>
            </div>

            <div class="form-group">
                <label for="messageContent">내용:</label>
                <textarea class="form-control" id="messageContent" name="messageContent" rows="10" required></textarea>
            </div>

            <button type="submit" class="btn btn-primary">쪽지 발송</button>
            <button type="button" class="btn btn-secondary" onclick="history.back()">취소</button>
        </form>
    </div>

    <%@ include file="/WEB-INF/views/department/department_list_modal.jsp" %>

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        window.currentRecipientType = ''; // 'to', 'cc', 'bcc' 중 현재 선택된 수신자 타입

        const selectedUsers = {
            to: new Map(), // Map<userId, userName>
            cc: new Map(),
            bcc: new Map()
        };

        // 모든 수신자 타입에 걸쳐 중복 체크를 위한 Set (userId만 저장)
        const allSelectedUserIds = new Set();

        document.addEventListener('DOMContentLoaded', function() {
            updateRecipientInputs();

            // 초기 수신자 ID가 있을 경우 (예: 조직도에서 바로 쪽지 보내기 클릭 시)
            const initialReceiverId = ${initialReceiverId != null ? initialReceiverId : 'null'};
            if (initialReceiverId !== null) {
                // fetch 경로를 MessageRestController에 추가된 임시 User API로 변경
                fetch(`/api/v1/messages/users/\${initialReceiverId}/name`)
                    .then(response => {
                        if (!response.ok) {
                            return response.text().then(text => { throw new Error(text || '사용자를 찾을 수 없습니다.'); });
                        }
                        return response.text();
                    })
                    .then(userName => {
                        addSelectedUser('to', initialReceiverId, userName);
                    })
                    .catch(error => {
                        console.error('Error fetching initial receiver name:', error);
                        alert('초기 수신자 정보를 불러오는 데 실패했습니다: ' + error.message);
                    });
            }

            // 쪽지 발송 폼 제출 이벤트
            document.getElementById('sendMessageForm').addEventListener('submit', function(event) {
                event.preventDefault(); // 기본 폼 제출 방지

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

                // CSRF 토큰 관련 로직 제거 (SecurityConfig에서 csrf.disable() 했으므로 불필요)
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
                        document.getElementById('sendMessageForm').reset();
                        selectedUsers.to.clear();
                        selectedUsers.cc.clear();
                        selectedUsers.bcc.clear();
                        allSelectedUserIds.clear();
                        updateRecipientInputs();
                        document.getElementById('toRecipients').innerHTML = '';
                        document.getElementById('ccRecipients').innerHTML = '';
                        document.getElementById('bccRecipients').innerHTML = '';
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

        // 쉼표로 구분된 ID 문자열을 Integer 배열로 변환하는 헬퍼 함수
        function parseIds(idString) {
            if (!idString) return [];
            return idString.split(',').map(id => {
                const trimmedId = String(id).trim();
                if (trimmedId === '') return null;
                const parsedId = parseInt(trimmedId, 10);
                return isNaN(parsedId) ? null : parsedId;
            }).filter(id => id !== null);
        }

        // 조직도 모달 열기 함수
        function openRecipientModal(type) {
            window.currentRecipientType = type;
            $('#departmentListModal').modal('show');
        }

        // 선택된 사용자 추가 함수 (department_list_modal.jsp에서 호출됨)
        window.addSelectedUser = function(type, userId, userName) {
            const recipientList = document.getElementById(`\${type}Recipients`);

            if (allSelectedUserIds.has(userId)) {
                let existingType = '';
                if (selectedUsers.to.has(userId)) existingType = 'TO';
                else if (selectedUsers.cc.has(userId)) existingType = 'CC';
                else if (selectedUsers.bcc.has(userId)) existingType = 'BCC';

                alert(`\${userName}님은 이미 \${existingType} 목록에 추가되어 있습니다.`);
                return;
            }

            selectedUsers[type].set(userId, userName);
            allSelectedUserIds.add(userId);

            const listItem = document.createElement('li');
            listItem.className = 'recipient-item';
            listItem.setAttribute('data-user-id', userId);
            listItem.innerHTML = `\
                \${userName}\
                <button type="button" class="remove-btn" data-user-id="\${userId}">×</button>\
            `;
            listItem.querySelector('.remove-btn').addEventListener('click', function() {
                removeSelectedUser(type, userId);
            });
            recipientList.appendChild(listItem);
            updateRecipientInputs();
        };

        // 선택된 사용자 제거 함수
        function removeSelectedUser(type, userId) {
            if (selectedUsers[type].delete(userId)) {
                allSelectedUserIds.delete(userId);

                const recipientList = document.getElementById(`\${type}Recipients`);
                const itemToRemove = recipientList.querySelector(`li[data-user-id="\${userId}"]`);
                if (itemToRemove) {
                    recipientList.removeChild(itemToRemove);
                }
                updateRecipientInputs();
            }
        }

        // hidden input 필드의 value를 업데이트 (쉼표로 구분된 ID 문자열)
        function updateRecipientInputs() {
            document.getElementById('toRecipientIds').value = Array.from(selectedUsers.to.keys()).join(',');
            document.getElementById('ccRecipientIds').value = Array.from(selectedUsers.cc.keys()).join(',');
            document.getElementById('bccRecipientIds').value = Array.from(selectedUsers.bcc.keys()).join(',');
        }
    </script>
</body>
</html>