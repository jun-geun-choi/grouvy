<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=420, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>채팅창</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
          rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/resources/css/chat/style.css' />"/>
</head>

<body>
<div class="main_panel">
    <%--채팅방 상단 헤더--%>
    <div class="main_header">
        <div class="chat_title"
             id="chat-title"
             data-room-id="${roomId}">${roomName}</div>
        <div class="dropdown">
            <%--채팅방 옵션 메뉴--%>
            <button class="btn btn-link p-0 ms-2" id="chat-menu-btn" data-bs-toggle="dropdown"
                    aria-expanded="false" style="font-size:1.5rem;"><i
                    class="bi bi-three-dots-vertical"></i></button>
            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="chat-menu-btn">
                <li><a class="dropdown-item" href="#" id="add-participant">대화 상대 추가</a></li>
                <%--<li><a class="dropdown-item" href="#" id="rename-room">채팅방 이름 설정</a></li>--%>
                <li>
                    <hr class="dropdown-divider">
                </li>
                <li><a class="dropdown-item text-danger" href="#" id="leave-room">채팅방 나가기</a></li>
            </ul>
        </div>
    </div>

        <%--채팅 메세지가 랜더링되는 영역--%>
    <div class="chat_body" id="chat-body">
        <%-- 메시지들은 JS에서 동적으로 이 안에 append됨 --%>
    </div>

        <%--메세지 입력 영역--%>
    <form class="chat_input_area" id="chat-input-form" autocomplete="off">
        <%--파일 첨부 버튼--%>
        <label for="chat-file-input" class="btn btn-light p-0 me-2"
               style="width:44px;height:44px;display:flex;align-items:center;justify-content:center;cursor:pointer;">
            <i class="bi bi-paperclip" style="font-size:1.3rem;"></i>
        </label>
        <input type="file" id="chat-file-input" style="display:none" multiple>
            <%--텍스트 입력창--%>
        <input type="text" id="chat-input" placeholder="대화내용을 입력해 주세요" autocomplete="off">
            <%--전송 버튼--%>
        <button type="submit"><i class="bi bi-arrow-up"></i></button>
    </form>
</div>
<!-- 대화 상대 추가 모달 -->
<div class="modal fade" id="add-participant-modal" tabindex="-1">
    <div class="modal-dialog modal-dialog-scrollable modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">대화 상대 선택</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
            </div>

            <div class="modal-body">
                <!-- 채팅방 이름 입력 -->
                <div class="mb-4">
                    <label for="group-room-name" class="form-label fw-semibold">채팅방 이름</label>
                    <input type="text" id="group-room-name" class="form-control" placeholder="채팅방 이름을 입력하세요">
                </div>

                <!-- 부서별 직원 리스트 렌더링 영역 -->
                <div id="user-list-container">
                    <!-- JS로 채워짐 -->
                </div>
            </div>

            <div class="modal-footer">
                <button id="submit-group-room" class="btn btn-primary">채팅방 만들기</button>
                <button class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>


<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
<script>
  // 전역 변수 설정
  let stompClient = null;                                  //STOMP 연결에 사용할 변수
  const $chatTitle = $('#chat-title');                     // 제목 요소
  const $chatBody = $('#chat-body');                       // 채팅 메시지 영역
  const $chatInput = $('#chat-input');                     // 입력 필드
  const $chatForm = $('#chat-input-form');                 // 폼
  const $fileInput = $('#chat-file-input');                // 파일 첨부 input
  const currentRoomId = $chatTitle.data('room-id');        // data-room-id 추출
  console.log('currentRoomId', currentRoomId);
  const isGroup ="${isGroup}" == "Y";
  console.log('isGroup', isGroup);

  // 인증된 사용자 정보 가져오기
  let userId;
  <sec:authorize access="isAuthenticated()">
  <sec:authentication property="principal.user" var="user"/>
  userId = ${user.userId};
  </sec:authorize>

  // -------------------- 읽음 처리: 클라이언트 상태/유틸 --------------------
  let lastSentReadUpTo = 0; // 서버로 보낸 마지막 readUpTo(중복 전송 방지)


  /* "현재 채팅창이 바닥에 위치하는 확인하는 함수."

   */
  function isAtBottom() {
    const nearBottom = 20; // 허용 오차
    return $chatBody.scrollTop() + $chatBody.innerHeight() >= $chatBody[0].scrollHeight - nearBottom;
  }

  /* "지금 보고 있는 메세지의 아이디를 가장 최신 아이디로 설정."

   */
  function getLastMessageIdInDom() {
    // unread 배지의 data-message-id 기준으로 가장 큰 ID를 읽음 경계로 사용
    let maxId = 0;
    $('#chat-body .chat_unread_count').each(function () {
      const id = parseInt($(this).data('message-id'));
      if (!isNaN(id) && id > maxId) maxId = id;
    });
    return maxId;
  }

  /** 현재 DOM 기준 혹은 명시 id 기준으로 읽음 통지(증가분만 전송) */
  function sendReadIfNeeded(explicitId) {
    if (!stompClient) return;
    const readUpTo = explicitId || getLastMessageIdInDom();
    if (!readUpTo || readUpTo <= lastSentReadUpTo) return;

    stompClient.send("/app/chatRead", {}, JSON.stringify({
      roomId: currentRoomId,
      readUpTo: readUpTo
    }));
    lastSentReadUpTo = readUpTo;
  }

  //  웹소켓 연결 및 구독처리
  function connectWebSocket() {
    const socket = new SockJS('/ws');
    stompClient = Stomp.over(socket);

    stompClient.connect({}, function (frame) {
      console.log('STOMP 연결 성공:', frame);

      // 이 채널의 채팅방으로 메세지를 수신 받음.
      stompClient.subscribe(`/topic/chatting?roomId=\${currentRoomId}`, function (message) {
        const chatMessage = JSON.parse(message.body);
        console.log("chatMessage: ",chatMessage);
        renderIncomingMessage(chatMessage);
      });

      // "누가 이 채팅방에 들어와서 메세지를 읽었다!" 정보를 이 채널로 받음. -> 이걸로 안 읽음 숫자를 실시간으로 반영.
      stompClient.subscribe(`/topic/chat.read?roomId=\${currentRoomId}`, function (message) {
        const { readerId, readUpTo } = JSON.parse(message.body);
        if (readerId === userId) return; // 내가 보낸 읽음이면 패스

        // 안 읽음 숫자 요소들을 반복하여, 그 요소의 메세지id가 readUpTo보다 작으면 숫자를 -1 하거나 0으로 변경한다. 그리고 0이면 안보이게 한다.
        $('#chat-body .chat_unread_count').each(function () {
          const $badge = $(this);
          const msgId = parseInt($badge.data('message-id'));
          if (msgId <= readUpTo) {
            const n = parseInt($badge.text() || '0');
            const next = Math.max(0, n - 1);
            $badge.text(next);
            if (next === 0) $badge.hide();
          }
        });
      });

      // 신경 x
      stompClient.subscribe('/user/queue/messages', function (message) {
        const personalMessage = JSON.parse(message.body);
      });
    });
  } // end

/*  //화면의 안 읽은 카운트를 실시간으로 업데이트 하는 함수 (네 기존 코드 그대로 유지)
  function updateUnreadCountOnScreen() {
    $('.chat-unread-count').each(function() {
      const $this = $(this);
      let currentCount = parseInt($this.text());
      if (currentCount > 0) {
        currentCount--;
        $this.text(currentCount);
        if (currentCount === 0) {
          $this.hide();
        }
      }
    });
  }*/

  //과거 메세지 이력 가져오기 - 과거 메세지를 모두 불러오면 스크롤을 맨 아래로 내리고, 읽었다는 신호를 보낸다.
  function loadMessageThisRoom() {
    $.getJSON(`/api/chat/loadMessage?roomId=\${currentRoomId}`, function (messages) {
      let messageInfo = messages.data;
      console.log("과거 메시지:", messageInfo);

      if (!messageInfo || messageInfo.length === 0) {
        const htmlContent = `<div id="no-message" class="text-center text-muted">"새로운 채팅을 시작하세요."</div>`;
        $chatBody.html(htmlContent);
        return;
      }

      $chatBody.empty(); // 기존 메시지 지우기 (최초 로딩 시만)

      for (let message of messageInfo) {
        const isMe = message.senderId === userId;
        const $wrapper = $('<div class="chat_message_wrapper"></div>');

        if (isMe) {
          $wrapper.addClass('me');
        }
        // 본인이 아니라면, 프로필 이미지와 이름을 HTML 요소에 추가한다.
        if (!isMe) {
          let $profile = null;

          const $senderInfo = $('<div class="chat_sender_info"></div>');
          if(message.profileImgPath == null) {
            $profile = $(`<div class="chat_avatar">
                               <img src="https://storage.googleapis.com/grouvy-bucket/default-profile.jpeg"
                                    alt="기본 프로필"
                                    class="rounded-circle profile-photo"
                                    style="width: 40px; height: 40px; object-fit: cover;">
                        </div>`);
          }
          else {
            $profile = $(`<div class="chat_avatar">
                               <img src=""https://storage.googleapis.com/grouvy-bucket/\${friend.profileImgPath}""
                                    alt="사용자 프로필 이미지"
                                    class="rounded-circle profile-photo"
                                    style="width: 40px; height: 40px; object-fit: cover;">
                        </div>`);
          }
          const $name = $('<span class="chat_name"></span>').text(message.name);
          $senderInfo.append($profile).append($name);
          $wrapper.append($senderInfo);
        }
        if(message.unreadCnt > 0 && (isGroup || isMe)){
          const $unreaderCnt = $(`<div class="chat_unread_count" data-message-id="\${message.chatMessageId}"></div>`).text(message.unreadCnt);
          $wrapper.append($unreaderCnt);
        }

        //메세지 내용을 이 메세지 div 요소에 넣고, 자기 아이디의 메세지이면 me 클래스를 추가한다.
        const $message = $('<div class="chat_message"></div>').text(message.content);
        if (isMe) $message.addClass('me');

        const $timestamp = $('<div class="chat_timestamp"></div>').text(message.formattedTime);
        $wrapper.append($message).append($timestamp);

        $chatBody.append($wrapper);
      }

      // 메시지 모두 append 후 스크롤 맨 아래로
      $chatBody.scrollTop($chatBody.prop('scrollHeight'));

      // 방 입장 직후: 현재 화면 기준으로 읽음 통지
      sendReadIfNeeded();
    });
  }

  // 실시간으로 등록된 메세지를 화면에 뿌리는 함수
  function renderIncomingMessage(chatMessage) {
    $("#no-message").addClass('d-none');
    const isMe = chatMessage.senderId === userId;
    const $wrapper = $('<div class="chat_message_wrapper"></div>');

    if (isMe) {
      $wrapper.addClass('me');
    }

    if (!isMe) {
      let $profile = null;

      const $senderInfo = $('<div class="chat_sender_info"></div>');
      if(chatMessage.profileImgPath == null) {
        $profile = $(`<div class="chat_avatar">
                               <img src="https://storage.googleapis.com/grouvy-bucket/default-profile.jpeg"
                                    alt="기본 프로필"
                                    class="rounded-circle profile-photo"
                                    style="width: 40px; height: 40px; object-fit: cover;">
                        </div>`);
      }
      else {
        $profile = $(`<div class="chat_avatar">
                               <img src="https://storage.googleapis.com/grouvy-bucket/\${friend.profileImgPath}"
                                    alt="사용자 프로필 이미지"
                                    class="rounded-circle profile-photo"
                                    style="width: 40px; height: 40px; object-fit: cover;">
                        </div>`);
      }
      const $name = $(`<span class="chat_name"></span>`).text(chatMessage.name);
      $senderInfo.append($profile).append($name);
      $wrapper.append($senderInfo);
    }

    if(chatMessage.unreadCnt > 0 && (isGroup || isMe)) {
      const $unreaderCnt = $(`<div class="chat_unread_count" data-message-id="\${chatMessage.chatMessageId}"></div>`).text(chatMessage.unreadCnt);
      $wrapper.append($unreaderCnt);
    }

    const $message = $('<div class="chat_message"></div>').text(chatMessage.content);
    if (isMe) $message.addClass('me');

    const $timestamp = $('<div class="chat_timestamp"></div>').text((chatMessage.formattedTime));

    // 메시지 렌더링 완료 후 append
    $wrapper.append($message).append($timestamp);
    $chatBody.append($wrapper);
    $chatBody.scrollTop($chatBody.prop('scrollHeight'));

    //내가 지금 바닥에 있으면 새 메시지도 즉시 읽음 처리
    if (isAtBottom()) {
      // 서버가 chatMessageId를 넣어주고 있으니 그걸 경계로 보냄
      sendReadIfNeeded(chatMessage.chatMessageId);
    }
  }

  // -------------------- 스크롤/포커스 시점에 읽음 통지 --------------------
  let readDebounce;
  $chatBody.on('scroll', function () {
    if (readDebounce) clearTimeout(readDebounce);
    readDebounce = setTimeout(() => {
      if (isAtBottom()) sendReadIfNeeded();
    }, 120);
  });

  document.addEventListener('visibilitychange', () => {
    if (document.visibilityState === 'visible' && isAtBottom()) {
      sendReadIfNeeded();
    }
  });

  window.addEventListener('focus', () => {
    if (isAtBottom()) sendReadIfNeeded();
  });

  //  메시지 전송 이벤트 설정
  $chatForm.on('submit', function (e) {
    e.preventDefault();

    const content = $chatInput.val().trim();
    if (!content || !stompClient) return;

    const chatMessage = {
      content: content,
      messageType: '대화',
      roomId : currentRoomId
    };

    stompClient.send("/app/chatSend", {}, JSON.stringify(chatMessage));
    console.log(JSON.stringify(chatMessage));
    $chatInput.val('');
  });

  // 팝업 오픈 함수
  function openChatPopup(groupChatRoomId,groupChatRoomName) {
    window.open(
        `/chat/chatting?roomId=\${groupChatRoomId}`,
        '_blank',
        'width=420,height=650,resizable=no,scrollbars=no'
    );
  }

  let groupUserId = ${userIds}; // 그룹 채팅을 하기 위한 직원들의 아이디를 저장하는 배열변수

  // "대화 상대 추가" 버튼 클릭 시, 전체 조직도가 띄워진다.
  $("#add-participant").click(function (e) {
    console.log(groupUserId);
    e.preventDefault();
    let htmlContent = "";

    $("#user-list-container").empty();

    $.getJSON(`/api/chat/allUser?roomId=\${currentRoomId}`, function (data) {
      let allDeptAndUsers = data.data;
      console.log("allDeptAndUsers:",allDeptAndUsers);

      for(let deptAndUser of allDeptAndUsers){
        htmlContent += `
        <div class="accordion_item card mb-3">
          <div class="card-header accordion-header fw-bold">
            \${deptAndUser.departmentName}
          </div>
          <ul class="list-group list-group-flush">
          `;

        for(let userInfo of deptAndUser.members){
          htmlContent += `
          <li class="list-group-item d-flex align-items-center">
            <input type="checkbox"
                   class="form-check-input user-checkbox me-2"
                   name="userId"
                  value="\${userInfo.id}">
            <span>\${userInfo.userName} <small class="text-muted">(\${userInfo.positionName})</small></span>
          </li>
          `;
        }
        htmlContent += `</ul></div>`;
        $("#user-list-container").html(htmlContent);
      }

      $("#add-participant-modal").modal('show');
    });
  });

  // 채팅방 이름 입력 및 직원 선택 후 제출 버튼 눌렀을 때 이벤트
  $("#submit-group-room").click(function (e) {
    e.preventDefault();
    console.log("groupUserId:",groupUserId);

    $("input[name='userId']:checked").each(function () {
      let selectedUserId = parseInt($(this).val());
      groupUserId.push(parseInt($(this).val()));
    });
    console.log("groupUserId:",groupUserId);

    let groupRoomName = $("#group-room-name").val().trim();

    if(!groupRoomName || groupUserId.length === 0) {
      alert("채팅방 이름을 설정하거나, 직원 1명 이상 선택하세요");
      return;
    }

    let groupData = {
      id: groupUserId,
      name: groupRoomName,
    }

    $.ajax({
      type: "POST",
      url: "/api/chat",
      contentType: "application/json",
      data: JSON.stringify(groupData),
      dataType: "json",
      success: function (data) {
        let groupChatRoom = data.data;
        console.log("groupChatRoom:", groupChatRoom);
        let groupChatRoomId = groupChatRoom.roomId;
        let groupChatRoomName = groupChatRoom.roomName;
        openChatPopup(groupChatRoomId);
      }
    });
    $("#add-participant-modal").modal('hide');
  });

  //나가기 버튼 이벤트
  $("#leave-room").click(function (e) {
    e.preventDefault();
    const result = confirm("채팅방을 나가시겠습니까?? 기존 데이터가 사라집니다.");

    let data = {
      userId : userId,
      roomId : currentRoomId
    }

    if(result) {
      $.ajax({
        type: "POST",
        url: "/api/chat/leftRoom",
        data: JSON.stringify(data),
        dataType: "json",
        contentType:  "application/json",
        success: function (data) {
          window.close();
        }
      });
    }
    return;
  });

  // 연결 시작
  $(function () {
    loadMessageThisRoom();
    connectWebSocket();

    localStorage.setItem("currentRoomId",currentRoomId);
    window.onbeforeunload = function () {
      localStorage.removeItem("currentRoomId");
    }
  });

  //$(function() {..}) 이 문장 자체가 이 jsp 페이지의 HTML 요소, 스크립트 문장을 전부 로딩이 된 후, 실행 하겠다는 뜻!
</script>

</body>
</html>