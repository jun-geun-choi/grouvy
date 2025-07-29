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
                <li><a class="dropdown-item" href="#" id="rename-room">채팅방 이름 설정</a></li>
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

  // 인증된 사용자 정보 가져오기
  let userId;
  <sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal.user" var="user"/>
        userId = ${user.userId};
  </sec:authorize>

  //과거 메세지 이력 가져오기
  function loadMessageThisRoom() {
    $.getJSON(`/api/chat/loadMessage?roomId=\${currentRoomId}`, function (messages) {
      let messageInfo = messages.data;
      console.log("과거 메시지:", messageInfo);

      if (!messageInfo || messageInfo.length === 0) {
        const htmlContent = `<div class="text-center text-muted">"새로운 채팅을 시작하세요."</div>`;
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

        if (!isMe) {
          const $senderInfo = $('<div class="chat_sender_info"></div>');
          const $profile = $(`<div class="chat_avatar"></div>`).text(message.profileImgPath || "🧑");
          const $name = $('<span class="chat_name"></span>').text(message.name);
          $senderInfo.append($profile).append($name);
          $wrapper.append($senderInfo);
        }

        const $message = $('<div class="chat_message"></div>').text(message.content);
        if (isMe) $message.addClass('me');

        const $timestamp = $('<div class="chat_timestamp"></div>').text(message.formattedTime);
        $wrapper.append($message).append($timestamp);

        $chatBody.append($wrapper);
      }

      // 메시지 모두 append 후 스크롤 맨 아래로
      $chatBody.scrollTop($chatBody.prop('scrollHeight'));
    });
  }



  //  웹소켓 연결 및 구독처리
  function connectWebSocket() {
    const socket = new SockJS('/ws');
    stompClient = Stomp.over(socket);

    stompClient.connect({}, function (frame) {
      console.log('STOMP 연결 성공:', frame);

      //  채팅방 구독 (브로드캐스트)
      stompClient.subscribe(`/topic/chatting?roomId=\${currentRoomId}`, function (message) {
        const chatMessage = JSON.parse(message.body);
        console.log("chatMessage: ",chatMessage);
        renderIncomingMessage(chatMessage);
      });

      //  특정 사용자에게 온 메시지 수신
      stompClient.subscribe('/user/queue/messages', function (message) {
        const personalMessage = JSON.parse(message.body);
        console.log('1:1 알림 메시지 수신:', personalMessage);
        // 원하는 처리를 여기에...
      });
    });
  } // end

  // 실시간으로 등록된 메세지를 화면에 뿌리는 함수
  function renderIncomingMessage(chatMessage) {
    const isMe = chatMessage.senderId === userId;
    const $wrapper = $('<div class="chat_message_wrapper"></div>');

    if (isMe) {
        $wrapper.addClass('me');
    }

    // 상대방 메시지일 경우 프로필 이미지 + 이름 표시
    if (!isMe) {
      const $senderInfo = $('<div class="chat_sender_info"></div>');
      const $profile = $(`<div class="chat_avatar">\${chatMessage.profileImgPath}</div>`);
      const $name = $(`<span class="chat_name"></span>`).text(chatMessage.name);
      $senderInfo.append($profile).append($name);
      $wrapper.append($senderInfo);
    }

    // 메시지 본문 출력
    const $message = $('<div class="chat_message"></div>').text(chatMessage.content);
    if (isMe) $message.addClass('me');

    // 전송 시간 표시
    const $timestamp = $('<div class="chat_timestamp"></div>').text((chatMessage.formattedTime));

    // 메시지 렌더링 완료 후 append
    $wrapper.append($message).append($timestamp);
    $chatBody.append($wrapper);
    $chatBody.scrollTop($chatBody.prop('scrollHeight'));
  }

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
  }); // end

  // 파일 첨부 이벤트 노션에 있음.

  // 연결 시작
  $(function () {
    loadMessageThisRoom();
    connectWebSocket();
  });
  //$(function() {..}) 이 문장 자체가 이 jsp 페이지의 HTML 요소, 스크립트 문장을 전부 로딩이 된 후
  // 이 문장을 실행하겠다!! 라는 의미이고..
</script>