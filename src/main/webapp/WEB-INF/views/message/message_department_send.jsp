<%-- src/main/webapp/WEB-INF/views/message/message_department_send.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>부서 쪽지 작성</title>
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
            rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <c:url var="homeCss" value="/resources/css/user/home.css"/>
    <link href="${homeCss}" rel="stylesheet"/>
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
            <li><a href="/message/department-send" class="${currentPage == 'department-send' ? 'active' : ''}">부서 쪽지 쓰기</a></li>
            <li><a href="/message/inbox" class="${currentPage == 'inbox' ? 'active' : ''}">받은 쪽지함</a></li>
            <li><a href="/message/sentbox" class="${currentPage == 'sentbox' ? 'active' : ''}">보낸 쪽지함</a></li>
            <li><a href="/message/important" class="${currentPage == 'important' ? 'active' : ''}">중요 쪽지함</a></li>
        </ul>
    </div>

    <!-- 본문 영역 -->
    <div class="main-content">
        <h2><i class="fas fa-users mr-2"></i> 부서 쪽지 작성</h2>

        <!-- 발신자 정보 -->
        <div class="sender-info mb-4">
            <h5 class="mb-2"><i class="fas fa-user-circle mr-2"></i>보낸 사람</h5>
            <div id="senderDisplay">
                <sec:authentication property="principal.user" var="currentUser"/>
                <c:if test="${not empty currentUser}">
                    <p class="mb-0"><strong>${currentUser.name}</strong> (${currentUser.email})</p>
                </c:if>
                <c:if test="${empty currentUser}">
                    <p class="text-danger">발신자 정보가 없습니다. (로그인 필요)</p>
                </c:if>
            </div>
        </div>

        <!-- 쪽지 전송 폼 -->
        <form id="sendMessageForm">
            <div class="form-group">
                <label for="toDepartments">받는 부서 (TO):</label>
                <div class="input-group">
                    <ul id="toDepartments" class="form-control recipient-list"></ul>
                    <div class="input-group-append">
                        <button type="button" class="btn btn-outline-secondary" id="openDepartmentModalBtn">
                            <i class="fas fa-plus"></i>
                        </button>
                    </div>
                </div>
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
<%@include file="../common/footer.jsp" %>

<!-- 부서 선택 모달 -->
<div class="modal fade" id="departmentSelectModal" tabindex="-1" role="dialog" aria-labelledby="departmentSelectModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="departmentSelectModalLabel">부서 선택</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span>
                </button>
            </div>
            <div class="modal-body">
                <ul id="departmentListForModal" class="list-group">
                </ul>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const openDepartmentModalBtn = document.getElementById('openDepartmentModalBtn');
        const departmentListForModal = document.getElementById('departmentListForModal');
        const toDepartmentsUI = document.getElementById('toDepartments');
        const sendMessageForm = document.getElementById('sendMessageForm');

        const selectedDepartments = new Map();

        // 1. "부서 추가" 버튼 클릭 시 모달 열고 부서 목록 로드
        openDepartmentModalBtn.addEventListener('click', async function () {
            departmentListForModal.innerHTML = '<li class="list-group-item">로딩 중...</li>';
            $('#departmentSelectModal').modal('show');

            try {
                // 단순 부서 목록 API 호출
                const response = await fetch('/api/v1/dept/list');
                if (!response.ok) throw new Error('부서 목록 로드 실패');
                const departments = await response.json();

                departmentListForModal.innerHTML = '';
                departments.forEach(dept => {
                    const li = document.createElement('li');
                    li.className = 'list-group-item list-group-item-action';
                    li.style.cursor = 'pointer';
                    li.textContent = dept.departmentName;
                    li.setAttribute('data-dept-id', dept.departmentId);
                    li.setAttribute('data-dept-name', dept.departmentName);
                    departmentListForModal.appendChild(li);
                });
            } catch (error) {
                departmentListForModal.innerHTML = '<li class="list-group-item text-danger">부서 목록을 불러오는 데 실패했습니다.</li>';
                console.error('부서 목록 로드 실패:', error);
            }
        });

        // 2. 모달 내에서 부서 클릭 시 선택 처리
        departmentListForModal.addEventListener('click', function(e) {
            if (e.target && e.target.matches('li.list-group-item-action')) {
                const deptId = parseInt(e.target.dataset.deptId, 10);
                const deptName = e.target.dataset.deptName;

                if (selectedDepartments.has(deptId)) {
                    alert('이미 추가된 부서입니다.');
                    return;
                }

                selectedDepartments.set(deptId, deptName);
                updateToDepartmentsUI();
                $('#departmentSelectModal').modal('hide');
            }
        });

        // 3. 선택된 부서 UI 업데이트
        function updateToDepartmentsUI() {
            toDepartmentsUI.innerHTML = '';
            selectedDepartments.forEach((deptName, deptId) => {
                const li = document.createElement('li');
                li.className = 'recipient-item';
                li.textContent = deptName;
                li.innerHTML += `<button type="button" class="remove-btn" data-dept-id="\${deptId}">×</button>`;
                toDepartmentsUI.appendChild(li);
            });
        }

        // 4. 부서 제거 버튼 클릭 이벤트
        toDepartmentsUI.addEventListener('click', function(e) {
            if (e.target && e.target.matches('button.remove-btn')) {
                const deptId = parseInt(e.target.dataset.deptId, 10);
                selectedDepartments.delete(deptId);
                updateToDepartmentsUI();
            }
        });

        // 5. 폼 제출 시 최종 수신자 ID 목록을 만들어 API 호출
        sendMessageForm.addEventListener('submit', async function(event) {
            event.preventDefault();

            if (selectedDepartments.size === 0) {
                alert('받는 부서를 1개 이상 선택해야 합니다.');
                return;
            }

            const allReceiverIds = new Set();
            for (const deptId of selectedDepartments.keys()) {
                try {
                    const response = await fetch(`/api/v1/dept/\${deptId}/members/ids`);
                    if (!response.ok) throw new Error(`부서원 조회 실패 (ID: \${deptId})`);
                    const memberIds = await response.json();
                    memberIds.forEach(id => allReceiverIds.add(id));
                } catch (error) {
                    console.error(`부서원 ID 조회 실패 (부서 ID: \${deptId}):`, error);
                    alert('수신자 목록을 구성하는 데 실패했습니다. 다시 시도해주세요.');
                    return;
                }
            }

            <sec:authentication property="principal.user" var="currentUserForJs"/>
            const currentUserId = ${currentUserForJs != null ? currentUserForJs.userId : 'null'};
            if (currentUserId !== null) {
                allReceiverIds.delete(currentUserId);
            }

            if (allReceiverIds.size === 0) {
                alert('자기 자신을 제외한 수신자가 없습니다. 다른 부서를 선택해주세요.');
                return;
            }

            const payload = {
                receiverIds: Array.from(allReceiverIds),
                ccIds: [],
                bccIds: [],
                subject: document.getElementById('subject').value,
                messageContent: document.getElementById('messageContent').value
            };

            try {
                const response = await fetch('/api/v1/messages/send', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify(payload)
                });
                const data = await response.json();
                if (response.ok && data.success) {
                    alert('부서 쪽지가 성공적으로 발송되었습니다.');
                    window.location.href = '/message/sentbox';
                } else {
                    alert('발송 실패: ' + (data.message || '알 수 없는 오류'));
                }
            } catch (error) {
                alert('발송 중 오류가 발생했습니다.');
                console.error('쪽지 발송 오류:', error);
            }
        });
    });
</script>
</body>
</html>