<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=320, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>채팅방 리스트</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
          rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/resources/css/chat/style.css' />"/>
</head>
<body>
<div class="sidebar">
    <%@include file="common/header.jsp" %>

<%--    <div class="p-3 pb-2">
        <input type="text" class="form-control" placeholder="채팅방 검색">
    </div>--%>
    <div class="chat_list" id="chats-list">
        <!-- JS로 동적 생성 -->
    </div>
</div>

<!-- 컨텍스트 메뉴 -->
<div id="context-menu" class="custom_context_menu"></div>

<!-- 나가기 확인 모달 -->
<div class="modal fade" id="leaveRoomModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-sm modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-body text-center">
                <p class="mb-3">채팅방을 나가시겠습니까?</p>
                <div class="d-flex justify-content-center gap-2">
                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">취소</button>
                    <button type="button" class="btn btn-danger btn-sm" id="confirmLeaveRoom">나가기</button>
                </div>
            </div>
        </div>
    </div>
</div>

<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
<script>
  let userId;
  <sec:authorize access="isAuthenticated()">
  <sec:authentication property="principal.user" var="user"/>
  userId = ${user.userId};
  </sec:authorize>

  function renderChatList() {
    $.getJSON(`/api/chat/chattingRoom`, function (data) {
      const list = data.data || [];
      console.log(list);
      const $list = $('#chats-list').empty();

      list.forEach(i => {
        let profileHtml;
        if (i.isGroup === "N") {
          const src = i.profileImgPath
              ? `https://storage.googleapis.com/grouvy-bucket/\${i.profileImgPath}`
              : `https://storage.googleapis.com/grouvy-bucket/default-profile.jpeg`;
          profileHtml = `<img src="\${src}" alt="프로필" class="rounded-circle profile-photo" style="width:40px;height:40px;object-fit:cover;">`;
        } else {
          // 그룹용 아바타(원하면 이미지로 대체)
          profileHtml = `<div class="rounded-circle bg-secondary d-flex align-items-center justify-content-center" style="width:40px;height:40px;">G</div>`;
        }

        const unreadHtml = i.unreadCnt
            ? `<span class="badge bg-primary ms-auto">\${i.unreadCnt}</span>`
            : '';

        const $item = $(`
        <div class="chat_list_item d-flex align-items-center gap-2"
             data-room-id ="\${i.roomId}">
          <div class="chat_avatar">\${profileHtml}</div>
          <div class="chat_info flex-grow-1">
            <div class="chat_name">\${i.roomName ?? ''}</div>
            <div class="chat_last"></div>
          </div>
          \${unreadHtml}
        </div>
      `);

        // lastMessage는 텍스트로 (간단 이스케이프)
        $item.find('.chat_last').text(i.lastMessage ?? '');

        // 더블클릭 이벤트는 생성한 엘리먼트에 바인드
        $item.on('dblclick', function () {
          openChatPopup(i.roomId);
        });
        $list.append($item);
      });

      setupChatListContextMenu();
    });
  }
  function openChatPopup(roomId) {
    window.open(
        `/chat/chatting?roomId=\${roomId}`, // 라우트 확인
        '_blank',
        'width=420,height=650,resizable=no,scrollbars=no'
    );
  }
  // 컨텍스트 메뉴
  const contextMenu = document.getElementById('context-menu');
  let contextMenuTarget = null;

  // 컨텍스트 메뉴 닫기
  function closeContextMenu() {
    $('#context-menu').hide();
    contextMenuTarget = null;
  }

  $(document).on('click', closeContextMenu);
  $(window).on('scroll resize', closeContextMenu);

  let currentRoomId;
  // 채팅방 리스트 우클릭 메뉴 (채팅방 나가기)
  function setupChatListContextMenu() {
    $('#chats-list .chat_list_item').off('contextmenu').on('contextmenu',
        function (e) {
          e.preventDefault();
          closeContextMenu();
          contextMenuTarget = this;
          const $item = $(this);
          currentRoomId = $item.data('room-id');
          console.log('currentRoomId', currentRoomId);

          const name = $item.find('.chat_name').text().trim();
          let menuHtml = `<button id='leave-chatroom-btn' class='text-danger'>채팅방 나가기</button>`;
          $('#context-menu').html(menuHtml).css({
            top: e.clientY + 'px',
            left: e.clientX + 'px'
          }).show();

          $('#leave-chatroom-btn').off('click').on('click', function () {
            closeContextMenu();
            pendingLeaveData = { userId: userId, roomId: currentRoomId };

            const modal = new bootstrap.Modal(document.getElementById('leaveRoomModal'));
            modal.show();


          });
        });
  }
  $('#confirmLeaveRoom').on('click', function () {
    if (!pendingLeaveData) return;

    $.ajax({
      type: "POST",
      url: "/api/chat/leftRoom",
      data: JSON.stringify(pendingLeaveData),
      dataType: "json",
      contentType: "application/json",
      success: function () {
        // 모달 닫고, 해당 방 DOM 제거
        bootstrap.Modal.getInstance(document.getElementById('leaveRoomModal')).hide();
        $(`#chats-list .chat_list_item[data-room-id="\${pendingLeaveData.roomId}"]`).remove();
        pendingLeaveData = null;
      },
      error: function () {
        // 실패 시 모달만 닫고 전체 새로고침
        bootstrap.Modal.getInstance(document.getElementById('leaveRoomModal')).hide();
        renderChatList();
        pendingLeaveData = null;
      }
    });
  });

  $(document).ready(function () {
    renderChatList();
  });

</script>

</body>
</html> 