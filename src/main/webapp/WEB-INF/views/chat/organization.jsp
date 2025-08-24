<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=320, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <title>조직도 리스트</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="<c:url value='/resources/css/chat/style.css' />" />
</head>
<body>
  <div class="sidebar">
    <%@include file="common/header.jsp"  %>

    <%-- 알림창에 대한 컨테이너 --%>
    <div id="alert-container" class="m-2"></div>

<%--    <div class="p-3 pb-2">
      <input type="text" class="form-control" placeholder="이름, 부서명 검색">
    </div>--%>
    <div class="chat_list" id="org-list">
      <div class="accordion" id="org-dept-accordion">           <%-- 전체 부서 목록 가져오는 공간--%>
        <!-- JS로 동적 생성 -->
      </div>
      <div id="org-action-bar" class="d-flex justify-content-between align-items-center p-2 border-top bg-white" style="position:sticky;bottom:0;z-index:2;">
        <span id="org-selected-count">선택(0명)</span>
        <div>
          <button id="org-add-friend-btn" class="btn btn-outline-secondary btn-sm me-1">친구 추가</button>
          <button id="org-chat-btn" class="btn btn-danger btn-sm">대화</button>
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
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>

        <div class="modal-body text-center" id="profile-modal-body">
          <!-- JS로 내용 채움 -->
        </div>
      </div>
    </div>
  </div>

  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
  <script>
    // 인증된 사용자 정보 가져오기
    let userId;
    let currentUserName;
    <sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal.user" var="user"/>
    userId = ${user.userId};
    currentUserName = "${user.name}";
    </sec:authorize>

    // 조직도 랜더링 함수
    function renderOrgList() {
      const $accordion = $('#org-dept-accordion').empty();

      $.getJSON(`/api/chat/organizations`, function (data){
        let orgainzations = data.data;
        let htmlContent = "";
        console.log(orgainzations);

        if(orgainzations.length != null ) {
          // 부모 부서
          for(let i  = 0; i < orgainzations.length; i++){
            let parentDept = orgainzations[i];
            let parentName = parentDept.parentDeptName;
            let deptAndUserDtos = parentDept.deptAndUserDtos;
            htmlContent += `
          <div class="accordion_item">
            <h2 class="accordion-header" id="heading-\${i}">
              <button class="accordion_button collapsed"
                      type="button" data-bs-toggle="collapse"
                      data-bs-target="#collapse-\${i}"
                      aria-expanded="false"
                      aria-controls="collapse-\${i}">
                \${parentName}
              </button>
            </h2>
            <div id="collapse-\${i}"
                class="accordion-collapse collapse"
                aria-labelledby="heading-\${i}"
                data-bs-parent="#org-dept-accordion">
              <div class="accordion_body p-0">
        `;

            // 자식 부서
            for(let j = 0; j<deptAndUserDtos.length; j++){
              let dept = deptAndUserDtos[j];
              let departmentName = dept.departmentName;
              let members = dept.members;
              let headingId = `heading-dept-\${i}-\${j}`;
              let collapseId = `collapse-dept-\${i}-\${j}`;
              let teamIndex = `teamIndex-dept-\${i}-\${j}`;
              htmlContent += `
                   <div class="accordion_item">
                    <h3 class="accordion-header"
                       id="heading-\${headingId}-team-\${teamIndex}">
                      <button class="accordion_button collapsed"
                              type="button"
                              data-bs-toggle="collapse"
                              data-bs-target="#collapse-\${collapseId}-team-\${teamIndex}"
                              aria-expanded="false"
                              aria-controls="collapse-\${collapseId}-team-\${teamIndex}">
                        \${departmentName}
                      </button>
                    </h3>
                    <div id="collapse-\${collapseId}-team-\${teamIndex}"
                        class="accordion-collapse collapse"
                        aria-labelledby="heading-\${headingId}-team-\${teamIndex}"
                        data-bs-parent="#collapse-\${collapseId}">
                      <div class="accordion_body p-0">
          `;

              //유저 데이터 가져오기
              for(let member of  members) {
                if(member.id != userId) {
                  let profileImg = member.imgPath
                          ? `https://storage.googleapis.com/grouvy-bucket/\${member.imgPath}`
                          : `https://storage.googleapis.com/grouvy-bucket/default-profile.jpeg`;
                  htmlContent += `
                    <div class="chat_list_item align-items-center"
                         data-member-id="\${member.id}">
                      <input type="checkbox"
                             class="form-check-input org-member-checkbox me-2"
                             data-member-name="\${member.userName}"
                             data-member-id="\${member.id}">
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
              }
              htmlContent += `</div></div></div>`; // 부서 아코디언 닫기
            }
            htmlContent += `</div></div></div>`; // 본부 아코디언 닫기
          }
        }
        $accordion.append(htmlContent);;
        setupOrgMemberSelection();
        setupMemberContextMenu('#org-list .chat_list_item');
      });
    }

    // 조직도 직원 선택 및 하단 버튼 동작
    let orgSelectedMembers = new Set();

    // ✅ 중복 방지: Set으로 관리
    let userIds = new Set();           // 선택된 직원 id
    let userNams = new Set();          // 선택된 직원 이름

    function resetSelectionSetsToSelf() {
      userIds = new Set([userId]);
      userNams = new Set([currentUserName]);
    }

    // 체크박스, 대화버튼, 친구 추가 버튼 이벤트 설정
    function setupOrgMemberSelection() {
      orgSelectedMembers = new Set();
      resetSelectionSetsToSelf();
      updateOrgSelectedCount();

      // 체크박스 선택/해제
      $('#org-list').off('change', '.org-member-checkbox').on('change', '.org-member-checkbox', function () {
        const memberId = parseInt($(this).data('member-id'));
        const memberName = $(this).data('member-name');

        if (this.checked) {
          userIds.add(memberId);
          userNams.add(memberName);
          orgSelectedMembers.add(memberId); // 고유 id로 관리
        } else {
          userIds.delete(memberId);
          userNams.delete(memberName);
          orgSelectedMembers.delete(memberId);
        }
        updateOrgSelectedCount();
      });

      // 친구추가 버튼
      $('#org-add-friend-btn').off('click').on('click', function () {
        if (orgSelectedMembers.size === 0) {
          return alert('직원을 선택하세요.');
        }

        const userData = { id: Array.from(userIds) };

        $.ajax({
          type: "POST",
          url: "/api/chat/wisiList",
          contentType: "application/json",
          data: JSON.stringify(userData),
          dataType: "json",
          success: function (data) {
            console.log(data);
            showAlert('성공적으로 추가되었습니다.', 'success');

            // 체크박스 해제 & 선택 초기화
            $('.org-member-checkbox:checked').prop('checked', false);
            orgSelectedMembers.clear();
            resetSelectionSetsToSelf();
            updateOrgSelectedCount();
          }
        });
      });

      // 대화 버튼
      $('#org-chat-btn').off('click').on('click', function () {
        if (orgSelectedMembers.size === 0) {
          return alert('직원을 선택하세요.');
        }

        // 그룹방 이름: 선택된 사용자 이름 + 본인 이름
        const namesArr = Array.from(userNams);
        const groupRoomName = namesArr.join(' ');

        const groupData = {
          id: Array.from(userIds),
          name: groupRoomName,
        };
        console.log(groupData);

        $.ajax({
          type: "POST",
          url: "/api/chat",
          contentType: "application/json",
          data: JSON.stringify(groupData),
          dataType: "json",
          success: function (data) {
            const groupChatRoom = data.data;
            console.log("groupChatRoom:", groupChatRoom);
            const roomId = groupChatRoom.roomId;
            openChatPopup(roomId);

            // 체크박스 해제 & 선택 초기화
            $('.org-member-checkbox:checked').prop('checked', false);
            orgSelectedMembers.clear();
            resetSelectionSetsToSelf();
            updateOrgSelectedCount();
          }
        });
      });
    }

    function updateOrgSelectedCount() {
      $('#org-selected-count').text('선택(' + orgSelectedMembers.size + '명)');
    }

    // 팝업 오픈 함수
    function openChatPopup(roomId) {
      window.open(
              `/chat/chatting?roomId=\${roomId}`,
              '_blank',
              'width=420,height=650,resizable=no,scrollbars=no'
      );
    }

    // 알림창 표시
    function showAlert(message, type) {
      const alertHtml = `
    <div class="alert alert-\${type} alert-dismissible fade show" role="alert">
      \${message}
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
  `;

      const $newAlert = $(alertHtml);
      $('#alert-container').append($newAlert);

      setTimeout(() => {
        $newAlert.fadeOut(500, function() {
          $(this).remove();
        });
      }, 1000);
    }

    // 컨텍스트 메뉴 & 프로필 모달
    const contextMenu = document.getElementById('context-menu');
    let contextMenuTarget = null;

    function closeContextMenu() {
      $('#context-menu').hide();
      contextMenuTarget = null;
    }
    $(document).on('click', closeContextMenu);
    $(window).on('scroll resize', closeContextMenu);

    function setupMemberContextMenu(selector) {
      $(selector).off('contextmenu').on('contextmenu', function (e) {
        e.preventDefault();
        closeContextMenu();

        contextMenuTarget = this;
        const selectUserId = $(this).data('member-id');
        console.log("selectUserId: ", selectUserId);

        const menuHtml = `<button id='view-profile-btn'>프로필 상세 보기</button>`;
        $('#context-menu').html(menuHtml).css({
          top: e.clientY + 'px',
          left: e.clientX + 'px'
        }).show();

        $('#view-profile-btn').off('click').on('click', function () {
          closeContextMenu();
          $.getJSON(`/api/chat/userInfo?userId=\${selectUserId}`, function (data) {
            const result = data.data;
            const profileImg = result.profileImgPath
                    ? `https://storage.googleapis.com/grouvy-bucket/\${result.profileImgPath}`
                    : `https://storage.googleapis.com/grouvy-bucket/default-profile.jpeg`;

            const htmlContent = `
              <img src='\${profileImg}' class='modal_profile_img mb-2'>
              <div class='mb-2'><span class='modal_profile_label'>이름: </span><span class='modal_profile_value'>\${result.name}</span></div>
              <div class='mb-2'><span class='modal_profile_label'>직급: </span><span class='modal_profile_value'>\${result.positionName}</span></div>
              <div class='mb-2'><span class='modal_profile_label'>부서: </span><span class='modal_profile_value'>\${result.deptName}</span></div>
              <div class='mb-2'><span class='modal_profile_label'>연락처: </span><span class='modal_profile_value'>\${result.phoneNumber}</span></div>
              <div class='mb-2'><span class='modal_profile_label'>이메일: </span><span class='modal_profile_value'>\${result.email}</span></div>
            `;

            $('#profile-modal-body').html(htmlContent);
            new bootstrap.Modal('#profile-modal').show();
          });
        });
      });
    }

    // 페이지 로드 시 조직도 리스트 렌더링
    $(document).ready(function () {
      renderOrgList();
    });
  </script>
</body>
</html> 