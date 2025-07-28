<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    <div class="main_header">
        <div class="chat_title" id="chat-title">채팅방</div>
        <div class="dropdown">
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

    <div class="chat_body" id="chat-body">
        <!-- JS로 채팅 내용이 동적으로 들어감 -->
    </div>

    <form class="chat_input_area" id="chat-input-form" autocomplete="off">
        <label for="chat-file-input" class="btn btn-light p-0 me-2"
               style="width:44px;height:44px;display:flex;align-items:center;justify-content:center;cursor:pointer;">
            <i class="bi bi-paperclip" style="font-size:1.3rem;"></i>
        </label>
        <input type="file" id="chat-file-input" style="display:none" multiple>
        <input type="text" id="chat-input" placeholder="대화내용을 입력해 주세요" autocomplete="off">
        <button type="submit"><i class="bi bi-arrow-up"></i></button>
    </form>
</div>

<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<script>
  /*  // 쿼리스트링에서 roomId 추출
    function getRoomIdFromQuery() {
      const urlParams = new URLSearchParams(window.location.search);
      const roomId = urlParams.get('roomId');
      return roomId !== null ? parseInt(roomId, 10) : 0;
    }*/

  /*let currentRoomId = getRoomIdFromQuery();
  if (isNaN(currentRoomId) || currentRoomId < 0 || currentRoomId
      >= chatRooms.length) currentRoomId = 0;*/

  const urlParam = new URLSearchParams(window.location.search); // roomId =\${값} 이 추출
  const roomId = urlParam.get('roomId');                        // 그 값을 js 변수에 할당

  const $chatTitle = $("#chat-title");              // 채팅방 제목
  const $chatBody = $("#chat-body");                // 기존 메세지 내용 표시
  const $chatInputForm = $("#chat-input-form");     // 첨부 파일 및 메세지 입력 폼
  const chatInput = $("#chat-input")                // 메세지 입력 필드

  // 1.
  function renderChatRoom(roomId) {
    const room = chatRooms[roomId];
    chatTitle.textContent = room.name;
    chatBody.innerHTML = '';
    let lastDate = '';
    room.messages.forEach(msg => {
      if (msg.date && msg.date !== lastDate) {
        chatBody.innerHTML += `<div class="chat_date">${msg.date}</div>`;
        lastDate = msg.date;
      }
      chatBody.innerHTML += `<div class="chat_message${msg.me ? ' me' : ''}">${msg.text}</div>`;
    });
    chatBody.scrollTop = chatBody.scrollHeight;
  }

  chatInputForm.addEventListener('submit', function (e) {
    e.preventDefault();
    const text = chatInput.value.trim();
    if (!text) return;
    chatRooms[currentRoomId].messages.push({date: '', sender: '나', text, me: true});
    renderChatRoom(currentRoomId);
    chatInput.value = '';
  });

  // 페이지 로드 시 채팅방 내용 보여주기
  renderChatRoom(currentRoomId);

  // 메뉴 기능 구현
  $(function () {
    // 대화 상대 추가
    $('#add-participant').on('click', function (e) {
      e.preventDefault();
      const name = prompt('추가할 대화 상대 이름을 입력하세요:');
      if (!name) return;
      // 단순히 이름만 추가 (실제 서비스에서는 사용자 검색/선택 필요)
      const room = chatRooms[currentRoomId];
      if (room.name.includes(name)) {
        alert('이미 추가된 사용자입니다.');
        return;
      }
      // 그룹채팅이면 이름 추가, 1:1이면 그룹채팅으로 변환
      if (room.name.includes(',')) {
        room.name += ', ' + name;
      } else {
        room.name = room.name + ', ' + name;
      }
      renderChatRoom(currentRoomId);
    });
    // 채팅방 이름 설정
    $('#rename-room').on('click', function (e) {
      e.preventDefault();
      const newName = prompt('새 채팅방 이름을 입력하세요:', chatRooms[currentRoomId].name);
      if (newName && newName.trim()) {
        chatRooms[currentRoomId].name = newName.trim();
        renderChatRoom(currentRoomId);
      }
    });
    // 채팅방 나가기
    $('#leave-room').on('click', function (e) {
      e.preventDefault();
      if (confirm('채팅방을 나가시겠습니까?')) {
        // chatRooms에서 삭제
        chatRooms.splice(currentRoomId, 1);
        window.close();
      }
    });
  }); // end 메뉴 기능 구현

  // 파일 첨부 기능 (데모)
  $('#chat-file-input').on('change', function (e) {
    const files = Array.from(e.target.files);
    if (!files.length) return;
    files.forEach(file => {
      let preview = '';
      if (file.type.startsWith('image/')) {
        const reader = new FileReader();
        reader.onload = function (ev) {
          preview = `<img src="${ev.target.result}" alt="${file.name}" style="max-width:120px;max-height:80px;display:block;margin-bottom:4px;">`;
          chatRooms[currentRoomId].messages.push({
            date: '',
            sender: '나',
            text: preview + '<div style="font-size:0.95em;color:#888;">' + file.name + '</div>',
            me: true
          });
          renderChatRoom(currentRoomId);
        };
        reader.readAsDataURL(file);
      } else {
        preview = `<div style=\"font-size:0.95em;color:#888;\">${file.name}</div>`;
        chatRooms[currentRoomId].messages.push({date: '', sender: '나', text: preview, me: true});
        renderChatRoom(currentRoomId);
      }
    });
    // 파일 선택 초기화
    $(this).val('');
  }); // end 파일 첨부 기능
</script>
</body>
</html>