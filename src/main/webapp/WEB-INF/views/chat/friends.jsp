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
</head>
<body>

<div class="sidebar">
    <%@include file="common/header.jsp" %>

    <%-- 검색 입력필드 --%>
    <%--    <div class="p-3 pb-2">
          <input type="text" class="form-control" placeholder="이름을 입력하세요.">
        </div>--%>

    <%-- 같은 부서 직원 리스트를 뿌리는 곳. --%>
    <div class="accordion" id="my-department-section" style="margin-bottom: 0.5rem;">
        <%-- ajax로 값을 불러온다. --%>
    </div>
    <%-- 내가 즐겨찾기한 직원 리스트를 뿌리는 곳. --%>
    <div class="chat_list" id="friends-list">
        <div class="accordion" id="friends-dept-accordion">
            <!-- JS로 동적 생성 -->
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

<script>
  /*// 채팅방 더미 데이터
  const chatRooms = [
    { id: 0, name: '김업무', last: '나 이거 지금 테스트 중인데 어떠신가요??', unread: 1 },
    { id: 1, name: '송한국', last: '반갑습니다.', unread: 0 },
    { id: 2, name: '그룹채팅', last: '인생은 뭐다?!', unread: 6 },
    { id: 3, name: '박메카', last: 'ㅎㅎㅎㅎ', unread: 0 }
  ];*/

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
        $.getJSON(`/api/chat/friends?deptNo=\${departmentId}&userId=\${userId}`, function (data) {
          /*api/chat/friends?deptNo 얘는 상대 경로이다. ajax 호출할 때는 절대 경로 호츌하기
          *  위에 처럼 하면 경로가 chat/api/chat/friends?deptNo 이렇게 chat이 두번 호출하게 된다. */
          let htmlContent = "";
          let friends = data.data;
          console.log(friends);
          let deptName = friends[0].departmentName;

          if (friends.length != 0) {
            htmlContent += `
       <div class="accordion_item">
          <h2 class="accordion-header" id="heading-myDeptAccordion">
            <button class="accordion_button collapsed"
                   type="button"
                   id="dept-id"
                   data-dept-id="\${departmentId}"
                   data-bs-toggle="collapse"
                   data-bs-target="#collapse-myDeptAccordion"
                   aria-expanded="false"
                   aria-controls="collapse-myDeptAccordion">
              내 부서: \${deptName}
            </button>
          </h2>`;

            for (let friend of friends) {
              htmlContent += `
                <div id="collapse-myDeptAccordion"
                    class="accordion-collapse collapse"
                    aria-labelledby="heading-myDeptAccordion"
                    data-bs-parent="#my-department-section">

                    <div class="accordion-body p-0">
                        <div class="chat_list_item"
                             data-user-id ="\${friend.userId}">
                            <div class="chat_avatar">\${friend.profileImgpath}</div>
                            <div class="chat_info">
                                <div class="chat_name">\${friend.name}</div>
                            </div>
                        </div>
                `;
              /*<div class="chat_list_item"는 직원 한명 한명 어떻게 화면에 표시할지에 대한 div이다.*/
            } // for
            htmlContent += `</div></div></div>`;
          }// if

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
          console.log(selectUserId);

          const name = $(this).find('.chat_name').text().trim();    // 선택한 상대방 사용자의 이름 뽑음.

          let $loadDepartmentId = $("#dept-id").data("dept-id");    // ajax로 받아온, 나의 부서 id를 data 속성으로 뽑음. - 삭제 버튼을 나의 리스트에서 안나오게 하기 위해서.

          //0.우클릭 메뉴들을 정의함. - 대화시작, 프로필, 삭제
          let menuHtml= "";
          if(departmentId === $loadDepartmentId) {                 //- 나의 부서 직원들이라면, 삭제 버튼 비활성화
           menuHtml = `<button id='start-chat-btn'>대화 시작</button>
                          <button id='view-profile-btn'>프로필 상세 보기</button>
                          <button id='delete-friend-btn'
                                 class='d-none'>삭제</button>`;
          }
          else {
           menuHtml = `<button id='start-chat-btn'>대화 시작</button>
                          <button id='view-profile-btn'>프로필 상세 보기</button>
                          <button id='delete-friend-btn'>삭제</button>`;
          }

          $('#context-menu').html(menuHtml).css({                                         // 우클릭 메뉴 화면에 띄우기
            top: e.clientY + 'px',
            left: e.clientX + 'px'
          }).show();

          // 1. "대화 시작" 클릭 이벤트 설정
          $('#start-chat-btn').off('click').on('click', function () {
            closeContextMenu();

            let userData = {
              userId : userId,
              selectUserId: selectUserId
            }
            console.log('userData', userData);

            $.ajax({
              type: "POST",
              url: "/api/chat",
              data: JSON.stringify(userData),
              contentType: "application/json",
              dataType: 'json',
              success: function (result) {
                console.log(result);
                let roomId = result.data;
                console.log(roomId);
                openChatPopup(roomId);
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

/*  // 7.채팅방 이름으로 팝업 오픈 - 삭제 해도됨.
  function openChatPopupByName(name) {
    let idx = chatRooms.findIndex(r => r.name === name);
    if (idx === -1) {
      chatRooms.push({id: chatRooms.length, name, last: '-', unread: 0});
      idx = chatRooms.length - 1;
    }
    openChatPopup(idx);
  }*/

  // 8.페이지 로드 시 내 부서 + 친구 리스트 렌더링
  $(document).ready(function () {
    loadMyList();
    renderFriendsList();
  });
</script>
</body>
</html>