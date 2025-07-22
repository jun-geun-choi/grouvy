// 더미 데이터
const orgData = [
  {
    dept: '경영본부',
    teams: [
      {name: '총무팀', members: [{name: '홍길동', avatar: '홍'}]},
      {name: '회계팀', members: [{name: '최나라', avatar: '최'}]},
      {
        name: '인사팀',
        members: [{name: '박메카', avatar: '박'}, {name: '송한국', avatar: '송'}]
      }
    ]
  },
  {
    dept: '기술본부',
    teams: [
      {name: '프론트엔드팀', members: [{name: '이비즈', avatar: '이'}]},
      {name: '백엔드팀', members: [{name: '김업무', avatar: '김'}]},
      {name: '인프라팀', members: [{name: '김이지', avatar: '김'}]}
    ]
  },
  {
    dept: '기획본부',
    teams: [
      {name: '상품기획팀', members: [{name: '박메카', avatar: '박'}]},
      {name: '서비스기획팀', members: [{name: '송한국', avatar: '송'}]}
    ]
  },
  {
    dept: '마케팅본부',
    teams: [
      {name: '온/오프광고팀', members: [{name: '김업무', avatar: '김'}]},
      {name: '고객관리팀', members: [{name: '이비즈', avatar: '이'}]}
    ]
  }
];

// 채팅방 더미 데이터
const chatRooms = [
  {id: 0, name: '김업무', last: '나 이거 지금 테스트 중인데 어떠신가요??', unread: 1},
  {id: 1, name: '송한국', last: '반갑습니다.', unread: 0},
  {id: 2, name: '그룹채팅', last: '인생은 뭐다?!', unread: 6},
  {id: 3, name: '박메카', last: 'ㅎㅎㅎㅎ', unread: 0}
];

// 조직도 랜더링 함수
function renderOrgList() {
  const $accordion = $('#org-dept-accordion').empty();
  orgData.forEach((dept, deptIndex) => {
    const accordionId = `orgDept${deptIndex}`;
    const $item = $(`
          <div class="accordion_item">
            <h2 class="accordion-header" id="heading-${accordionId}">
              <button class="accordion_button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse-${accordionId}" aria-expanded="false" aria-controls="collapse-${accordionId}">
                ${dept.dept}
              </button>
            </h2>
            <div id="collapse-${accordionId}" class="accordion-collapse collapse" aria-labelledby="heading-${accordionId}" data-bs-parent="#org-dept-accordion">
              <div class="accordion_body p-0">
                ${dept.teams.map((team, teamIndex) => `
                  <div class="accordion_item">
                    <h3 class="accordion-header" id="heading-${accordionId}-team-${teamIndex}">
                      <button class="accordion_button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse-${accordionId}-team-${teamIndex}" aria-expanded="false" aria-controls="collapse-${accordionId}-team-${teamIndex}">
                        ${team.name}
                      </button>
                    </h3>
                    <div id="collapse-${accordionId}-team-${teamIndex}" class="accordion-collapse collapse" aria-labelledby="heading-${accordionId}-team-${teamIndex}" data-bs-parent="#collapse-${accordionId}">
                      <div class="accordion_body p-0">
                        ${team.members.map(member => `
                          <div class="chat_list_item align-items-center">
                            <input type="checkbox" class="form-check-input org-member-checkbox me-2" data-member-name="${member.name}" data-member-avatar="${member.avatar}">
                            <div class="chat_avatar">${member.avatar}</div>
                            <div class="chat_info">
                              <div class="chat_name">${member.name}</div>
                            </div>
                          </div>
                        `).join('')}
                      </div>
                    </div>
                  </div>
                `).join('')}
              </div>
            </div>
          </div>
        `);
    $accordion.append($item);
  });
  setupOrgMemberSelection();
  setupMemberContextMenu('#org-list .chat_list_item');
}

// 조직도 직원 선택 및 하단 버튼 동작
let orgSelectedMembers = new Set();

function setupOrgMemberSelection() {
  orgSelectedMembers = new Set();
  updateOrgSelectedCount();

  // 체크박스 클릭 시 선택 관리
  $('#org-list').off('change', '.org-member-checkbox').on('change',
      '.org-member-checkbox', function () {
        const name = $(this).data('member-name');
        const avatar = $(this).data('member-avatar');
        if (this.checked) {
          orgSelectedMembers.add(JSON.stringify({name, avatar}));
        } else {
          orgSelectedMembers.delete(JSON.stringify({name, avatar}));
        }
        updateOrgSelectedCount();
      });

  // 버튼 클릭 이벤트
  $('#org-add-friend-btn').off('click').on('click', function () {
    if (orgSelectedMembers.size === 0) {
      return alert('직원을 선택하세요.');
    }
    alert('친구 추가 기능은 데모입니다. 선택: ' + Array.from(orgSelectedMembers).map(
        m => JSON.parse(m).name).join(', '));
  });

  $('#org-chat-btn').off('click').on('click', function () {
    if (orgSelectedMembers.size === 0) {
      return alert('직원을 선택하세요.');
    }
    const members = Array.from(orgSelectedMembers).map(m => JSON.parse(m));
    if (members.length === 1) {
      openChatPopupByName(members[0].name);
    } else {
      // 그룹채팅: 이름 조합으로 새 채팅방 생성
      const groupName = members.map(m => m.name).join(', ');
      let idx = chatRooms.findIndex(r => r.name === groupName);
      if (idx === -1) {
        chatRooms.push(
            {id: chatRooms.length, name: groupName, last: '-', unread: 0});
        idx = chatRooms.length - 1;
      }
      openChatPopup(idx);
    }
  });
}

function updateOrgSelectedCount() {
  $('#org-selected-count').text('선택(' + orgSelectedMembers.size + '명)');
}

// 팝업 오픈 함수
function openChatPopup(roomId) {
  window.open(
      `chatting.html?roomId=${roomId}`,
      '_blank',
      'width=420,height=650,resizable=no,scrollbars=no'
  );
}

// 컨텍스트 메뉴 & 프로필 모달
const contextMenu = document.getElementById('context-menu');
let contextMenuTarget = null;

// 더미 프로필 데이터
const profileData = {
  '홍길동': {
    name: '홍길동',
    position: '팀장',
    dept: '총무팀',
    phone: '010-7777-7777',
    email: 'hong@company.com',
    img: 'https://cdn-icons-png.flaticon.com/512/149/149071.png'
  },
  '최나라': {
    name: '최나라',
    position: '사원',
    dept: '회계팀',
    phone: '010-6666-6666',
    email: 'choi@company.com',
    img: 'https://cdn-icons-png.flaticon.com/512/149/149071.png'
  },
  '박메카': {
    name: '박메카',
    position: '사원',
    dept: '인사팀',
    phone: '010-4444-4444',
    email: 'park@company.com',
    img: 'https://cdn-icons-png.flaticon.com/512/149/149071.png'
  },
  '송한국': {
    name: '송한국',
    position: '차장',
    dept: '인사팀',
    phone: '010-5555-5555',
    email: 'song@company.com',
    img: 'https://cdn-icons-png.flaticon.com/512/149/149071.png'
  },
  '이비즈': {
    name: '이비즈',
    position: '프론트엔드',
    dept: '프론트엔드팀',
    phone: '010-8888-8888',
    email: 'ebiz@company.com',
    img: 'https://cdn-icons-png.flaticon.com/512/149/149071.png'
  },
  '김업무': {
    name: '김업무',
    position: '백엔드',
    dept: '백엔드팀',
    phone: '010-9999-9999',
    email: 'kim@company.com',
    img: 'https://cdn-icons-png.flaticon.com/512/149/149071.png'
  },
  '김이지': {
    name: '김이지',
    position: '인프라',
    dept: '인프라팀',
    phone: '010-1212-1212',
    email: 'lee@company.com',
    img: 'https://cdn-icons-png.flaticon.com/512/149/149071.png'
  }
};

// 컨텍스트 메뉴 닫기
function closeContextMenu() {
  $('#context-menu').hide();
  contextMenuTarget = null;
}

$(document).on('click', closeContextMenu);
$(window).on('scroll resize', closeContextMenu);

// 조직도 직원 우클릭 메뉴
function setupMemberContextMenu(selector) {
  $(selector).off('contextmenu').on('contextmenu', function (e) {
    e.preventDefault();
    closeContextMenu();
    contextMenuTarget = this;
    const name = $(this).find('.chat_name').text().trim();
    let menuHtml = `<button id='view-profile-btn'>프로필 상세 보기</button>`;
    $('#context-menu').html(menuHtml).css({
      top: e.clientY + 'px',
      left: e.clientX + 'px'
    }).show();

    // 프로필 상세 보기
    $('#view-profile-btn').off('click').on('click', function () {
      closeContextMenu();
      const data = profileData[name] || {
        name,
        position: '-',
        dept: '-',
        phone: '-',
        email: '-',
        img: 'https://cdn-icons-png.flaticon.com/512/149/149071.png'
      };
      $('#profile-modal-body').html(`
            <img src='${data.img}' class='modal_profile_img mb-2'>
            <div class='mb-2'><span class='modal_profile_label'>이름: </span><span class='modal_profile_value'>${data.name}</span></div>
            <div class='mb-2'><span class='modal_profile_label'>직급: </span><span class='modal_profile_value'>${data.position}</span></div>
            <div class='mb-2'><span class='modal_profile_label'>부서: </span><span class='modal_profile_value'>${data.dept}</span></div>
            <div class='mb-2'><span class='modal_profile_label'>연락처: </span><span class='modal_profile_value'>${data.phone}</span></div>
            <div class='mb-2'><span class='modal_profile_label'>이메일: </span><span class='modal_profile_value'>${data.email}</span></div>
          `);
      new bootstrap.Modal('#profile-modal').show();
    });
  });
}

// 채팅방 이름으로 팝업 오픈
function openChatPopupByName(name) {
  let idx = chatRooms.findIndex(r => r.name === name);
  if (idx === -1) {
    chatRooms.push({id: chatRooms.length, name, last: '-', unread: 0});
    idx = chatRooms.length - 1;
  }
  openChatPopup(idx);
}

// 페이지 로드 시 조직도 리스트 렌더링
$(document).ready(function () {
  renderOrgList();
});