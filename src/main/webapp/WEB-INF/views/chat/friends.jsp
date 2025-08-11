<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=320, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>친구 리스트</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
          rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/resources/css/chat/style.css' />"/>
    <style>
      /* 즐겨찾기 목록 컨테이너에 대한 스타일 */
      #friends-list {
        /* 최대 높이를 지정합니다. 이 높이를 넘어가면 스크롤이 생깁니다. */
        /* 뷰포트 높이의 40%로 설정하거나, 300px 등 고정값으로 설정할 수 있습니다. */
        max-height: 40vh;

        /* 내용이 max-height를 초과할 경우 세로 스크롤바를 자동으로 표시합니다. */
        overflow-y: auto;
      }
    </style>
</head>
<body>

<div class="sidebar">
    <%@include file="common/header.jsp" %>

    <!-- 1. 같은 부서 직원 목록 -->
    <div class="list-section">
        <h4 class="list-header">
            <i class="bi bi-diagram-3"></i> 같은 부서 직원
        </h4>
        <div class="accordion" id="my-department-section">
            <%-- ajax로 값을 불러온다. --%>
        </div>
    </div>

    <hr class="section-divider">

    <!-- 2. 즐겨찾기 목록 -->
    <div class="list-section">
        <h4 class="list-header">
            <i class="bi bi-star"></i> 즐겨찾기
        </h4>
        <div class="chat_list" id="friends-list">
            <div class="accordion" id="friends-dept-accordion">
                <!-- JS로 동적 생성 -->
            </div>
        </div>
    </div>
</div>

<!-- 컨텍스트 메뉴 -->
<div id="context-menu" class="custom_context_menu"></div>

<!-- 프로필 상세 모달 -->
<div class="modal fade" id="profile-modal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">프로필 상세</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"
                        aria-label="Close"></button>
            </div>

            <%-- 프로필 주요 내용. --%>
            <div class="modal-body text-center" id="profile-modal-body">
                <!-- JS로 내용 채움 -->
            </div>

        </div>
    </div>
</div>
<%-- 프로필 상세 모달 종료 --%>
<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
<script src="<c:url value="/resources/js/chat/chatNoticeSocket.js"/>"></script>
<script>

    // 로그인된 사용자의 부서 아이디와, 사용자 아이디를 시큐리티에서 뽑음.
    let departmentId;
    let userId;
    <sec:authorize access="isAuthenticated">
        <sec:authentication property="principal.user" var="user"/>
        userId =${user.userId}
        departmentId = ${user.departmentId}
    </sec:authorize>

  // 1.나의 부서 직원들 리스트 뿌리기
  function loadMyList() {
        $.getJSON(`/api/chat/friends?deptNo=\${departmentId}`, function (data) {
          /*api/chat/friends?deptNo 얘는 상대 경로이다. ajax 호출할 때는 절대 경로 호츌하기
          *  위에 처럼 하면 경로가 chat/api/chat/friends?deptNo 이렇게 chat이 두번 호출하게 된다. */
          let htmlContent = "";
          let friends = data.data;

          if (friends.length !== 0) {
            console.log("friends: ", friends);

            for (let i = 0; i < friends.length; i++) {
              let parentDept = friends[i];
              let parentDeptName = parentDept.parentDeptName;
              let deptAndUserDtos = parentDept.deptAndUserDtos;

              htmlContent += `
                      <div class="accordion_item">
                        <h2 class="accordion-header" id="heading-parent-\${i}">
                          <button class="accordion_button collapsed"
                                  type="button"
                                  data-bs-toggle="collapse"
                                  data-bs-target="#collapse-parent-\${i}"
                                  aria-expanded="false"
                                  aria-controls="collapse-parent-\${i}">
                            본부: \${parentDeptName}
                          </button>
                        </h2>
                        <div id="collapse-parent-\${i}"
                             class="accordion-collapse collapse"
                             aria-labelledby="heading-parent-\${i}"
                             data-bs-parent="#my-department-section">
                          <div class="accordion-body p-0">
                    `;

              // 각 부서(deptAndUserDtos) 반복
              for (let j = 0; j < deptAndUserDtos.length; j++) {
                let dept = deptAndUserDtos[j];
                let departmentName = dept.departmentName;
                let members = dept.members;
                let headingId = `heading-dept-\${i}-\${j}`;
                let collapseId = `collapse-dept-\${i}-\${j}`;

                htmlContent += `
                        <div class="accordion_item">
                          <h2 class="accordion-header" id="\${headingId}">
                            <button class="accordion_button collapsed"
                                    type="button"
                                    data-bs-toggle="collapse"
                                    data-bs-target="#\${collapseId}"
                                    aria-expanded="false"
                                    aria-controls="\${collapseId}">
                              부서: \${departmentName}
                            </button>
                          </h2>
                          <div id="\${collapseId}"
                               class="accordion-collapse collapse"
                               aria-labelledby="\${headingId}"
                               data-bs-parent="#collapse-parent-\${i}">
                            <div class="accordion-body p-0">
                      `;

                for (let member of members) {
                  let profileImg = member.imgPath
                      ? `https://storage.googleapis.com/grouvy-bucket/\${member.imgPath}`
                      : `https://storage.googleapis.com/grouvy-bucket/default-profile.jpeg`;

                  htmlContent += `
                          <div class="chat_list_item"
                               data-user-id="\${member.id}"
                               data-user-name="\${member.userName}">
                            <div class="chat_avatar">
                              <img src="\${profileImg}"
                                   alt="프로필 이미지"
                                   class="rounded-circle profile-photo"
                                   style="width: 40px; height: 40px; object-fit: cover;">
                            </div>
                            <div class="chat_info">
                              <div class="chat_name">\${member.userName}</div>
                            </div>
                          </div>
                        `;
                }

                htmlContent += `</div></div></div>`; // 부서 아코디언 닫기
              }

              htmlContent += `</div></div></div>`; // 본부 아코디언 닫기
            }
          }


          // 1. 기존 내용 비우고
          $('#my-department-section').empty();
          // 2. 새로 만든 HTML 추가
          $('#my-department-section').append(htmlContent);
          // 3. 기존 이벤트 연결 함수 호출!
          setupMemberContextMenu("#my-department-section .chat_list_item");
          // 같은 부서 직원 div 공간 중 .chat_list_item에 이벤트를 건다
        });
  }

  // 2.내가 즐겨찾기한 직원들 리스트 뿌리기
    function renderFriendsList() {
      $.getJSON(`/api/chat/myWishList`, function (data) {
        let result = data.data; // 서버에서 받은 배열 [ {departmentName, members: [...]}, ... ]
        console.log("즐겨찾기 목록:", result);
        let htmlContent = "";

        if (result && result.length > 0) {
          // 1. 부서별로 반복 (result 배열 순회)
          for (let i = 0; i < result.length; i++) {
            let dept = result[i];
            let departmentName = dept.departmentName;
            let members = dept.members;

            // 해당 부서에 멤버가 없으면 아코디언을 생성하지 않음
            if (members.length === 0) {
              continue;
            }

            // 부서별 아코디언 아이템 생성
            htmlContent += `
                    <div class="accordion_item">
                      <h2 class="accordion-header" id="friends-heading-dept-\${i}">
                        <button class="accordion_button collapsed"
                                type="button"
                                data-bs-toggle="collapse"
                                data-bs-target="#friends-collapse-dept-\${i}"
                                aria-expanded="false"
                                aria-controls="friends-collapse-dept-\${i}">
                          \${departmentName} (\${members.length})
                        </button>
                      </h2>
                      <div id="friends-collapse-dept-\${i}"
                           class="accordion-collapse collapse"
                           aria-labelledby="friends-heading-dept-\${i}"
                           data-bs-parent="#friends-dept-accordion">
                        <div class="accordion-body p-0">
                `;

            // 2. 부서 내 멤버별로 반복 (members 배열 순회)
            for (let member of members) {
              // 프로필 이미지 경로 설정 (기본 이미지 포함)
              let profileImg = member.imgPath
                  ? `https://storage.googleapis.com/grouvy-bucket/\${member.imgPath}`
                  : `https://storage.googleapis.com/grouvy-bucket/default-profile.jpeg`;

              // 각 멤버의 리스트 아이템 HTML 생성
              htmlContent += `
                        <div class="chat_list_item"
                             data-user-id="\${member.id}"
                             data-user-name="\${member.userName}">
                          <div class="chat_avatar">
                            <img src="\${profileImg}"
                                 alt="프로필 이미지"
                                 class="rounded-circle profile-photo"
                                 style="width: 40px; height: 40px; object-fit: cover;">
                          </div>
                          <div class="chat_info">
                            <div class="chat_name">\${member.userName}</div>
                          </div>
                        </div>
                    `;
            }

            htmlContent += `</div></div></div>`; // 아코디언 아이템 닫기
          }
        }

        // 3. 생성된 HTML을 화면에 렌더링
        $('#friends-dept-accordion').empty();
        $('#friends-dept-accordion').append(htmlContent);
        // 4. 새로 추가된 요소들에 컨텍스트 메뉴 이벤트 연결
        setupMemberContextMenu("#friends-dept-accordion .chat_list_item");

     });
    }

  // 3.팝업 오픈 함수
  function openChatPopup(roomId) {

    window.open(
        `/chat/chatting?roomId=\${roomId}`,
        '_blank',
        'width=420,height=650,resizable=no,scrollbars=no'
    );
  }

  // 4.컨텍스트 메뉴 & 프로필 모달
  const contextMenu = document.getElementById('context-menu');
  let contextMenuTarget = null; // 우클릭을 눌렀을 때, 선택된 요소를 저장.

  // 5.우클릭 메뉴 닫는 기능을 정의
  function closeContextMenu() {
    $('#context-menu').hide();
    contextMenuTarget = null;
  }
  $(document).on('click', closeContextMenu);                        // 다른 화면을 클릭하거나
  $(window).on('scroll resize', closeContextMenu);                  // 스크롤 및 창 크기가 변경된다면, 우클릭 메뉴는 닫힌다.

  // 6.우클릭 했을 때 기능을 정의.
  function setupMemberContextMenu(selector) {
        $(selector).off('contextmenu').on('contextmenu', function (e) {
          e.preventDefault();
          closeContextMenu();

          contextMenuTarget = this;                                  // 방금 클릭한 요소 (chat_list_item)를 contextMenuTarget에 저장.

          let selectUserId = $(contextMenuTarget).data("user-id");   //그 직원의 userId를 selectUserId로 할당. data속성으로 빼야 int 값으로 나옴. - "프로필 상세보기"에서 사용.
          console.log("selectUserId:",selectUserId);

          /*let selectUserName = $(contextMenuTarget).data("user-name");
          console.log("selectUserName:",selectUserName);*/

          const name = $(this).find('.chat_name').text().trim();    // 선택한 상대방 사용자의 이름 뽑음.

          let $loadDepartmentId = $("#dept-id").data("dept-id");    // ajax로 받아온, 나의 부서 id를 data 속성으로 뽑음. - 삭제 버튼을 나의 리스트에서 안나오게 하기 위해서.

          //0.우클릭 메뉴들을 정의함. - 대화시작, 프로필, 삭제
          let menuHtml= "";
           menuHtml = `<button id='start-chat-btn'>대화 시작</button>
                          <button id='view-profile-btn'>프로필 상세 보기</button>`;


          $('#context-menu').html(menuHtml).css({                                         // 우클릭 메뉴 화면에 띄우기
            top: e.clientY + 'px',
            left: e.clientX + 'px'
          }).show();

          // 1. "대화 시작" 클릭 이벤트 설정
          $('#start-chat-btn').off('click').on('click', function () {
            closeContextMenu();

            let userIds = []
            userIds.push(userId);
            userIds.push(parseInt(selectUserId));
            let roomName = "";
            console.log(userIds);

            let userData = {
              id : userIds,
              name: roomName
            }
            console.log('userData', userData);

            $.ajax({
              type: "POST",
              url: "/api/chat",
              data: JSON.stringify(userData),
              contentType: "application/json",
              dataType: 'json',
              success: function (result) {
                /*console.log("전체 데이터: ",result);*/
                let room = result.data;
                console.log("room: ",room);
                console.log("room.roomId: ", room.roomId);
                openChatPopup(room.roomId);
              }
            }) //ajax
          });

          // 2. "프로필 상세 보기" - 클릭 이벤트 설정
          $('#view-profile-btn').off('click').on('click', function () {
            closeContextMenu();

            let htmlContent = "";
            $.getJSON(`/api/chat/userInfo?userId=\${selectUserId}`, function (data) {     // 직원 정보를 ajax로 받는다.
              console.log(data);
              let result = data.data;
              htmlContent += `
             <img src='\${result.profileImgPath}' class='modal_profile_img mb-2'>
            <div class='mb-2'><span class='modal_profile_label'>이름: </span><span class='modal_profile_value'>\${result.name}</span></div>
            <div class='mb-2'><span class='modal_profile_label'>직급: </span><span class='modal_profile_value'>\${result.positionName}</span></div>
            <div class='mb-2'><span class='modal_profile_label'>부서: </span><span class='modal_profile_value'>\${result.deptName}</span></div>
            <div class='mb-2'><span class='modal_profile_label'>연락처: </span><span class='modal_profile_value'>\${result.phoneNumber}</span></div>
            <div class='mb-2'><span class='modal_profile_label'>이메일: </span><span class='modal_profile_value'>\${result.email}</span></div>
            `;
              $("#profile-modal-body").html(htmlContent);
            });
            new bootstrap.Modal('#profile-modal').show();
          });

          // 3. "삭제" 버튼 클릭 이벤트 설정 - 수정 필요.
          $('#delete-friend-btn').off('click').on('click', function () {
            closeContextMenu();
            if (confirm('정말로 이 친구를 삭제하시겠습니까?')) {
              friendsData.forEach(dept => {
                const index = dept.members.findIndex(member => member.name === name);
                if (index !== -1) {
                  dept.members.splice(index, 1);
                }
              });
              $(contextMenuTarget).remove();
              alert('친구가 삭제되었습니다.');
            }
          });
        });
  }

  // 8.페이지 로드 시 내 부서 + 친구 리스트 렌더링
  $(document).ready(function () {
    loadMyList();
   /* connectNoticeSocket();*/
    renderFriendsList();
  });
  /*  */
</script>
</body>
</html>