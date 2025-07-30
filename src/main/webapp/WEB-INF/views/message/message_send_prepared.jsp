<%--src/main/resources/META-INF/resources/WEB-INF/views/message/message_send_prepared.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${formTitle}</title>
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
            rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <c:url var="homeCss" value="/resources/css/user/home.css"/>
    <link href="${homeCss}" rel="stylesheet"/>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/message/message.css">
</head>
<body>
<div class="container">
    <%@include file="../common/nav.jsp" %>
</div>
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

    <!-- 본문 영역 -->
    <div class="main-content">
        <h2 class="mb-4"><i class="fas fa-paper-plane mr-2"></i>${formTitle}</h2>

        <!-- 발신자 정보 -->
        <div class="sender-info mb-4">
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

        <!-- 쪽지 작성 폼 -->
        <form id="sendMessageForm">
            <!-- TO -->
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

            <!-- CC -->
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

            <!-- BCC -->
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

            <!-- 제목 -->
            <div class="form-group">
                <label for="subject">제목:</label>
                <input type="text" class="form-control" id="subject" name="subject" value="${preparedMessage.subject}"
                       required>
            </div>

            <!-- 내용 -->
            <div class="form-group">
                <label for="messageContent">내용:</label>
                <textarea class="form-control" id="messageContent" name="messageContent" rows="10"
                          required>${preparedMessage.messageContent}</textarea>
            </div>

            <!-- 버튼 -->
            <div class="form-group d-flex flex-wrap gap-2">
                <button type="submit" class="btn btn-primary mr-2">쪽지 발송</button>
                <button type="button" class="btn btn-secondary" onclick="history.back()">취소</button>
            </div>
        </form>
    </div>
</div>

<%@include file="../common/footer.jsp" %>
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

    document.addEventListener('DOMContentLoaded', function () {
        loadPreparedMessage(
            '${preparedReceiverIdsStr}',
            '${preparedCcIdsStr}',
            '${preparedBccIdsStr}'
        );

        document.getElementById('sendMessageForm').addEventListener('submit', function (event) {
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

    window.addSelectedUser = function (type, userId, userName) {
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
        listItem.querySelector('.remove-btn').addEventListener('click', function () {
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
</body>
</html>