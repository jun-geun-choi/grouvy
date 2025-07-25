<%-- **파일 경로:** src/main/resources/META-INF/resources/WEB-INF/views/message/message_send.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${formTitle}</title>
    <!-- CSRF 토큰을 위한 메타 태그는 SecurityConfig에서 csrf.disable() 했으므로 제거합니다. -->
    <%-- <meta name="_csrf" content="${_csrf.token}"/> --%>
    <%-- <meta name="_csrf_header" content="${_csrf.headerName}"/> --%>

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

    <!-- 조직도 모달 포함 -->
    <%-- **include 경로 수정 없음:** application.properties 설정에 맞춥니다. --%>
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
                            // HTTP 오류 상태 (예: 404 Not Found)
                            return response.text().then(text => { throw new Error(text || '사용자를 찾을 수 없습니다.'); });
                        }
                        return response.text(); // 응답 본문을 텍스트로 파싱 (사용자 이름만 반환하므로)
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
                    // hidden input 필드의 value (쉼표 구분 문자열)를 파싱
                    receiverIds: parseIds(document.getElementById('toRecipientIds').value),
                    ccIds: parseIds(document.getElementById('ccRecipientIds').value),
                    bccIds: parseIds(document.getElementById('bccRecipientIds').value),
                    subject: document.getElementById('subject').value,
                    messageContent: document.getElementById('messageContent').value
                };

                // CSRF 토큰 관련 로직 제거 (SecurityConfig에서 csrf.disable() 했으므로 불필요)
                const headers = {
                    'Content-Type': 'application/json' // JSON 데이터임을 명시
                };

                fetch('/api/v1/messages/send', {
                    method: 'POST', // POST 요청
                    headers: headers,
                    body: JSON.stringify(payload) // JavaScript 객체를 JSON 문자열로 변환
                })
                .then(response => {
                    // HTTP 응답 상태가 200번대가 아니면 오류 처리
                    if (!response.ok) {
                        // 오류 응답의 JSON 본문을 파싱하여 에러 메시지 추출
                        return response.json().then(errorData => {
                            throw new Error(errorData.message || '쪽지 발송 실패'); // 서버에서 보낸 메시지 사용
                        });
                    }
                    return response.json(); // 성공 응답의 JSON 본문을 파싱
                })
                .then(data => {
                    // 서버에서 받은 성공 데이터 처리
                    if (data.success) { // 서버 응답에 success 필드가 true인 경우
                        alert(data.message + '\n쪽지 ID: ' + data.messageId);
                        // 폼 및 선택된 수신자 목록 초기화
                        document.getElementById('sendMessageForm').reset(); // 폼 필드 초기화
                        selectedUsers.to.clear();
                        selectedUsers.cc.clear();
                        selectedUsers.bcc.clear();
                        allSelectedUserIds.clear();
                        updateRecipientInputs(); // hidden input도 초기화
                        document.getElementById('toRecipients').innerHTML = ''; // 화면에 보이는 목록 초기화
                        document.getElementById('ccRecipients').innerHTML = '';
                        document.getElementById('bccRecipients').innerHTML = '';
                    } else {
                        alert('쪽지 발송 실패: ' + data.message); // 서버 응답에 success 필드가 false인 경우
                    }
                })
                .catch(error => {
                    // 네트워크 오류 또는 파싱/로직에서 발생한 오류 처리
                    console.error('Error:', error); // 콘솔에 상세 에러 출력
                    alert('쪽지 발송 중 오류가 발생했습니다: ' + error.message); // 사용자에게 알림
                });
            });
        });

        // 쉼표로 구분된 ID 문자열을 Integer 배열로 변환하는 헬퍼 함수
        function parseIds(idString) {
            if (!idString) return []; // 문자열이 없으면 빈 배열 반환
            return idString.split(',') // 쉼표로 분리
                           .map(id => {
                               const trimmedId = String(id).trim(); // 각 ID 문자열 공백 제거
                               if (trimmedId === '') return null; // 빈 문자열은 null로 처리
                               const parsedId = parseInt(trimmedId, 10); // 10진수 정수로 변환
                               return isNaN(parsedId) ? null : parsedId; // 숫자가 아니면 null
                           })
                           .filter(id => id !== null); // null 값 제거
        }

        // 조직도 모달 열기 함수
        function openRecipientModal(type) {
            window.currentRecipientType = type; // 현재 어떤 타입의 수신자를 추가하는지 전역 변수에 저장
            $('#departmentListModal').modal('show'); // Bootstrap 모달 열기
        }

        // 선택된 사용자 추가 함수 (department_list_modal.jsp에서 호출됨)
        window.addSelectedUser = function(type, userId, userName) {
            const recipientList = document.getElementById(`\${type}Recipients`); // 해당 타입의 ul 요소

            // 모든 타입(TO, CC, BCC)에 걸쳐 이미 선택된 사용자인지 중복 확인
            if (allSelectedUserIds.has(userId)) {
                let existingType = '';
                if (selectedUsers.to.has(userId)) existingType = 'TO';
                else if (selectedUsers.cc.has(userId)) existingType = 'CC';
                else if (selectedUsers.bcc.has(userId)) existingType = 'BCC';

                alert(`\${userName}님은 이미 \${existingType} 목록에 추가되어 있습니다.`);
                return; // 이미 있으면 추가하지 않고 종료
            }

            // 새로운 사용자이므로 Map과 Set에 추가
            selectedUsers[type].set(userId, userName);
            allSelectedUserIds.add(userId);

            // 화면에 보이는 목록에 항목 추가
            const listItem = document.createElement('li');
            listItem.className = 'recipient-item'; // 스타일 적용을 위한 클래스
            listItem.setAttribute('data-user-id', userId); // 삭제를 위해 userId 저장
            listItem.innerHTML = `\
                \${userName}\
                <button type="button" class="remove-btn" data-user-id="\${userId}">×</button>\
            `;
            // 삭제 버튼에 이벤트 리스너 추가
            listItem.querySelector('.remove-btn').addEventListener('click', function() {
                removeSelectedUser(type, userId);
            });
            recipientList.appendChild(listItem); // 목록에 추가
            updateRecipientInputs(); // hidden input 필드 업데이트
        };

        // 선택된 사용자 제거 함수
        function removeSelectedUser(type, userId) {
            // Map에서 해당 사용자 삭제
            if (selectedUsers[type].delete(userId)) {
                allSelectedUserIds.delete(userId); // 전체 ID Set에서도 삭제

                // 화면에서 해당 항목 제거
                const recipientList = document.getElementById(`\${type}Recipients`);
                const itemToRemove = recipientList.querySelector(`li[data-user-id="\${userId}"]`);
                if (itemToRemove) {
                    recipientList.removeChild(itemToRemove);
                }
                updateRecipientInputs(); // hidden input 필드 업데이트
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