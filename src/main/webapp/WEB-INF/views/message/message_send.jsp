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
    <jsp:include page="/WEB-INF/views/common/nav.jsp"/>

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
        <h2>${formTitle}</h2>

        <!-- 발신자 정보 -->
        <div class="sender-info">
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

        <!-- 쪽지 전송 폼 -->
        <form id="sendMessageForm">
            <div class="form-group">
                <label for="toRecipients">받는 사람 (TO):</label>
                <div class="input-group">
                    <ul id="toRecipients" class="form-control recipient-list"></ul>
                    <div class="input-group-append">
                        <button type="button" class="btn btn-outline-secondary" onclick="openRecipientModal('to')">
                            <i class="fas fa-plus"></i>
                        </button>
                    </div>
                </div>
                <input type="hidden" id="toRecipientIds" name="receiverIds">
            </div>

            <div class="form-group">
                <label for="ccRecipients">참조 (CC):</label>
                <div class="input-group">
                    <ul id="ccRecipients" class="form-control recipient-list"></ul>
                    <div class="input-group-append">
                        <button type="button" class="btn btn-outline-secondary" onclick="openRecipientModal('cc')">
                            <i class="fas fa-plus"></i>
                        </button>
                    </div>
                </div>
                <input type="hidden" id="ccRecipientIds" name="ccIds">
            </div>

            <div class="form-group">
                <label for="bccRecipients">숨은 참조 (BCC):</label>
                <div class="input-group">
                    <ul id="bccRecipients" class="form-control recipient-list"></ul>
                    <div class="input-group-append">
                        <button type="button" class="btn btn-outline-secondary" onclick="openRecipientModal('bcc')">
                            <i class="fas fa-plus"></i>
                        </button>
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
</div>

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
            updateRecipientInputs();

            const initialReceiverId = ${initialReceiverId != null ? initialReceiverId : 'null'};
            if (initialReceiverId !== null) {
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

        function parseIds(idString) {
            if (!idString) return [];
            return idString.split(',').map(id => {
                const trimmedId = String(id).trim();
                if (trimmedId === '') return null;
                const parsedId = parseInt(trimmedId, 10);
                return isNaN(parsedId) ? null : parsedId;
            }).filter(id => id !== null);
        }

        function openRecipientModal(type) {
            window.currentRecipientType = type;
            $('#departmentListModal').modal('show');
        }

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

        function updateRecipientInputs() {
            document.getElementById('toRecipientIds').value = Array.from(selectedUsers.to.keys()).join(',');
            document.getElementById('ccRecipientIds').value = Array.from(selectedUsers.cc.keys()).join(',');
            document.getElementById('bccRecipientIds').value = Array.from(selectedUsers.bcc.keys()).join(',');
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>