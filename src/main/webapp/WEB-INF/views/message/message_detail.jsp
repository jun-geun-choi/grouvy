<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
<c:url var="homeCss" value="/resources/css/user/home.css" />
<link href="${homeCss}" rel="stylesheet" />
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/message/message.css">
</head>
<body>
<div class="container">
    <%@include file="../common/nav.jsp" %>
</div>
<div class="container">
    <div class="sidebar">
        <h3>쪽지 메뉴</h3>
        <ul>
            <li><a href="/message/send" class="${currentPage == 'send' ? 'active' : ''}">쪽지 쓰기</a></li>
            <li><a href="/message/inbox" class="${currentPage == 'inbox' ? 'active' : ''}">받은 쪽지함</a></li>
            <li><a href="/message/sentbox" class="${currentPage == 'sentbox' ? 'active' : ''}">보낸 쪽지함</a></li>
            <li><a href="/message/important" class="${currentPage == 'important' ? 'active' : ''}">중요 쪽지함</a></li>
        </ul>
    </div>

    <div class="main-content">
        <h2 id="messageSubjectDisplay"><i class="fas fa-envelope-open-text mr-2"></i> 쪽지 상세</h2>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-warning mt-3">${errorMessage}</div>
        </c:if>

        <div class="message-header">
            <div class="d-flex justify-content-between align-items-center mb-2">
                <div>
                    <strong>보낸 사람:</strong> <span id="senderNameDisplay" class="sender-box"></span>
                </div>
                <div>
                    <strong>발송일:</strong> <span id="sendDateDisplay"></span>
                </div>
            </div>
            <div class="mb-2">
                <strong>받는 사람 (TO):</strong> <span id="toRecipientsDisplay"></span>
            </div>
            <div id="ccRow" class="mb-2" style="display: none;">
                <strong>참조 (CC):</strong> <span id="ccRecipientsDisplay"></span>
            </div>
            <div id="bccRow" class="mb-2" style="display: none;">
                <strong>숨은 참조 (BCC):</strong> <span id="bccRecipientsDisplay"></span>
            </div>
        </div>

        <div class="message-body">
            <p id="messageContentDisplay" class="message-content"></p>
        </div>

        <div class="d-flex justify-content-between align-items-center mt-3">
            <div>
                <button type="button" class="btn btn-info btn-sm mr-2" id="replyBtn" style="display: none;">
                    <i class="fas fa-reply mr-1"></i> 답장
                </button>
                <button type="button" class="btn btn-info btn-sm" id="forwardBtn" style="display: none;">
                    <i class="fas fa-share mr-1"></i> 전달
                </button>
            </div>
            <div>
                <button type="button" class="btn btn-info btn-sm mr-2" id="importantToggleBtn" style="display: none;">
                    <i class="far fa-star mr-1"></i> 중요 표시
                </button>
                <button type="button" class="btn btn-danger btn-sm mr-2" id="recallBtn" style="display: none;">
                    <i class="fas fa-undo mr-1"></i> 회수
                </button>
                <button type="button" class="btn btn-danger btn-sm" id="deleteBtn" style="display: none;">
                    <i class="fas fa-trash-alt mr-1"></i> 삭제
                </button>
            </div>
        </div>
        <a href="javascript:history.back()" class="btn btn-secondary mt-3"><i class="fas fa-arrow-left mr-1"></i> 목록으로</a>
    </div>
</div>
<%@include file="../common/footer.jsp" %>
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const messageId = ${messageId};
    const currentPage = new URLSearchParams(window.location.search).get('currentPage');

    document.addEventListener('DOMContentLoaded', function() {
        if (messageId) {
            fetchMessageDetail(messageId);
        } else {
            alert('쪽지 ID가 유효하지 않습니다.');
            document.getElementById('messageSubjectDisplay').textContent = '쪽지를 찾을 수 없습니다.';
        }
    });

    function fetchMessageDetail(msgId) {
        fetch(`/api/v1/messages/detail/\${msgId}`)
            .then(response => {
                if (response.status === 401) {
                    alert('로그인이 필요합니다.');
                    window.location.href = '/login';
                    return Promise.reject('Unauthorized');
                }
                if (!response.ok) {
                    return response.json().then(errorData => {
                        throw new Error(errorData.message || '쪽지 상세 불러오기 실패');
                    });
                }
                return response.json();
            })
            .then(data => {
                if (data) {
                    renderMessageDetail(data);
                    setupActionButtons(data);
                } else {
                    alert('쪽지를 찾을 수 없거나 접근 권한이 없습니다.');
                    document.getElementById('messageSubjectDisplay').textContent = '쪽지를 찾을 수 없습니다.';
                }
            })
            .catch(error => {
                console.error('Error fetching message detail:', error);
                if (error !== 'Unauthorized') {
                    alert('쪽지 상세 정보를 불러오는 중 오류 발생: ' + error.message);
                    document.getElementById('messageSubjectDisplay').textContent = '쪽지를 불러오는 중 오류가 발생했습니다.';
                }
            });
    }

    function renderMessageDetail(data) {
        document.getElementById('messageSubjectDisplay').innerHTML = `<i class="fas fa-envelope-open-text mr-2"></i> \${data.subject}`;
        document.getElementById('senderNameDisplay').textContent = data.senderName;
        document.getElementById('sendDateDisplay').textContent = formatDate(data.sendDate);

        document.getElementById('toRecipientsDisplay').innerHTML = (data.toUserNames || []).map(name => `<span class="recipient-box">\${name}</span>`).join('');

        if (data.ccUserNames && data.ccUserNames.length > 0) {
            document.getElementById('ccRow').style.display = 'block';
            document.getElementById('ccRecipientsDisplay').innerHTML = (data.ccUserNames || []).map(name => `<span class="recipient-box">\${name}</span>`).join('');
        } else {
            document.getElementById('ccRow').style.display = 'none';
        }

        if (data.bccUserNames && data.bccUserNames.length > 0) {
            document.getElementById('bccRow').style.display = 'block';
            document.getElementById('bccRecipientsDisplay').innerHTML = (data.bccUserNames || []).map(name => `<span class="recipient-box">\${name}</span>`).join('');
        } else {
            document.getElementById('bccRow').style.display = 'none';
        }

        const messageContentDisplay = document.getElementById('messageContentDisplay');
        if (data.inboxStatus === 'RECALLED') {
            messageContentDisplay.textContent = '[발신자가 쪽지를 회수했습니다.]';
            messageContentDisplay.classList.add('recalled-content');
        } else {
            messageContentDisplay.textContent = data.messageContent;
            messageContentDisplay.classList.remove('recalled-content');
        }

        const importantToggleBtn = document.getElementById('importantToggleBtn');
        if (data.importantYn === 'Y') {
            importantToggleBtn.innerHTML = '<i class="fas fa-star mr-1"></i> 중요 해제';
            importantToggleBtn.classList.remove('btn-info');
            importantToggleBtn.classList.add('btn-warning');
        } else {
            importantToggleBtn.innerHTML = '<i class="far fa-star mr-1"></i> 중요 표시';
            importantToggleBtn.classList.remove('btn-warning');
            importantToggleBtn.classList.add('btn-info');
        }
    }

    async function setupActionButtons(messageDetailData) {
        let currentUserId = null;
        try {
            const response = await fetch('/api/v1/messages/users/current/id');
            if (response.ok) {
                currentUserId = await response.json();
            }
        } catch (error) {
            console.error('Error fetching current user ID:', error);
        }

        const recallBtn = document.getElementById('recallBtn');
        const deleteBtn = document.getElementById('deleteBtn');
        const importantToggleBtn = document.getElementById('importantToggleBtn');
        const replyBtn = document.getElementById('replyBtn');
        const forwardBtn = document.getElementById('forwardBtn');

        // 받은 편지함, 중요 편지함에서 들어왔을 경우
        if (currentPage === 'inbox' || currentPage === 'important') {
            replyBtn.style.display = 'inline-block';
            forwardBtn.style.display = 'inline-block';
            importantToggleBtn.style.display = 'inline-block';
            deleteBtn.style.display = 'inline-block';

            deleteBtn.onclick = () => {
                if (confirm('받은 쪽지함에서 이 쪽지를 삭제하시겠습니까?')) {
                    deleteReceivedMessage(messageDetailData.receiveId);
                }
            };
            importantToggleBtn.onclick = () => {
                toggleImportant(messageDetailData.receiveId, messageDetailData.importantYn === 'Y' ? 'N' : 'Y');
            };
        }
        // 보낸 편지함에서 들어왔을 경우
        else if (currentPage === 'sentbox') {
            replyBtn.style.display = 'none';
            forwardBtn.style.display = 'none';
            deleteBtn.style.display = 'inline-block';

            if (messageDetailData.sendId && messageDetailData.senderId === currentUserId) {
                deleteBtn.style.display = 'inline-block';
                deleteBtn.onclick = () => {
                    if (confirm('보낸 쪽지함에서 이 쪽지를 삭제하시겠습니까? (상대방의 받은 편지함에서는 삭제되지 않습니다.)')) {
                        deleteSentMessage(messageDetailData.sendId);
                    }
                };
            }
        }

        if (messageDetailData.senderId === currentUserId && messageDetailData.currentlyRecallable) {
            recallBtn.style.display = 'inline-block';
        } else {
            recallBtn.style.display = 'none';
        }

        replyBtn.onclick = () => {
            window.location.href = `/message/send-prepared?originalMessageId=\${messageId}&type=reply`;
        };
        forwardBtn.onclick = () => {
            window.location.href = `/message/send-prepared?originalMessageId=\${messageId}&type=forward`;
        };

        recallBtn.addEventListener('click', () => {
            if (confirm('정말로 쪽지를 회수하시겠습니까? (수신자가 읽지 않았을 경우에만 가능합니다)')) {
                recallMessage(messageId);
            }
        });
    }

    function recallMessage(messageId) {
        fetch(`/api/v1/messages/recall/\${messageId}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' }
        })
            .then(response => {
                if (!response.ok) {
                    return response.json().then(errorData => {
                        throw new Error(errorData.message || '쪽지 회수 실패');
                    });
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    alert(data.message);
                    fetchMessageDetail(messageId);
                } else {
                    alert('쪽지 회수 실패: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('쪽지 회수 중 오류 발생: ' + error.message);
            });
    }

    function deleteReceivedMessage(receiveId) {
        fetch(`/api/v1/messages/inbox/delete/\${receiveId}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' }
        })
            .then(response => {
                if (!response.ok) {
                    return response.json().then(errorData => {
                        throw new Error(errorData.message || '쪽지 삭제 실패');
                    });
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    alert(data.message);
                    window.location.href = '/message/inbox';
                } else {
                    alert('쪽지 삭제 실패: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('쪽지 삭제 중 오류 발생: ' + error.message);
            });
    }

    function deleteSentMessage(sendId) {
        fetch(`/api/v1/messages/sentbox/delete/\${sendId}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' }
        })
            .then(response => {
                if (!response.ok) {
                    return response.json().then(errorData => {
                        throw new Error(errorData.message || '쪽지 삭제 실패');
                    });
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    alert(data.message);
                    window.location.href = '/message/sentbox';
                } else {
                    alert('쪽지 삭제 실패: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('쪽지 삭제 중 오류 발생: ' + error.message);
            });
    }

    function toggleImportant(receiveId, newImportantYn) {
        fetch(`/api/v1/messages/inbox/toggleImportant/\${receiveId}?importantYn=\${newImportantYn}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' }
        })
            .then(response => {
                if (!response.ok) {
                    return response.json().then(errorData => {
                        throw new Error(errorData.message || '중요 표시 변경 실패');
                    });
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    alert(data.message);
                    fetchMessageDetail(messageId);
                } else {
                    alert('중요 표시 변경 실패: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('중요 표시 변경 중 오류 발생: ' + error.message);
            });
    }

    function formatDate(dateString) {
        if (!dateString) return '';
        const date = new Date(dateString);
        const options = { year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit' };
        return date.toLocaleDateString('ko-KR', options);
    }
</script>
</body>
</html>