// 채팅방 더미 데이터 -
const chatRooms = [
  {id: 0, name: '김업무', last: '나 이거 지금 테스트 중인데 어떠신가요??', unread: 1},
  {id: 1, name: '송한국', last: '반갑습니다.', unread: 0},
  {id: 2, name: '그룹채팅', last: '인생은 뭐다?!', unread: 6},
  {id: 3, name: '박메카', last: 'ㅎㅎㅎㅎ', unread: 0}
];

// 채팅방 리스트 렌더링 함수
function renderChatList() {
  const $chatsList = $('#chats-list').empty();
  chatRooms.forEach((room, idx) => {
    const $item = $(`
          <div class="chat_list_item">
            <div class="chat_avatar">${room.name[0]}</div>
            <div class="chat_info">
              <div class="chat_name">${room.name}</div>
              <div class="chat_last">${room.last}</div>
            </div>
            ${room.unread
        ? `<span class="badge bg-primary ms-auto">${room.unread}</span>` : ''}
          </div>
        `);
    $item.on('dblclick', function () {
      openChatPopup(room.id);
    });
    $chatsList.append($item);
  });
  setupChatListContextMenu();
}

// 팝업 오픈 함수
function openChatPopup(roomId) {
  window.open(
      `chatting.jsp?roomId=${roomId}`,
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

// 채팅방 리스트 우클릭 메뉴 (채팅방 나가기)
function setupChatListContextMenu() {
  $('#chats-list .chat_list_item').off('contextmenu').on('contextmenu',
      function (e) {
        e.preventDefault();
        closeContextMenu();
        contextMenuTarget = this;
        const $item = $(this);
        const name = $item.find('.chat_name').text().trim();
        let menuHtml = `<button id='leave-chatroom-btn' class='text-danger'>채팅방 나가기</button>`;
        $('#context-menu').html(menuHtml).css({
          top: e.clientY + 'px',
          left: e.clientX + 'px'
        }).show();

        $('#leave-chatroom-btn').off('click').on('click', function () {
          closeContextMenu();
          // chatRooms에서 해당 채팅방 삭제
          const idx = chatRooms.findIndex(r => r.name === name);
          if (idx !== -1) {
            chatRooms.splice(idx, 1);
            renderChatList();
          }
        });
      });
}

// 페이지 로드 시 채팅방 리스트 렌더링
$(document).ready(function () {
  renderChatList();
});
