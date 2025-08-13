<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<!-- 알림 배너 컨테이너 -->
<div class="grouvy-notice-popup hide" id="notice-popup" style="display: none;">
  <div class="grouvy-notice-header">
    <span class="grouvy-notice-brand">GROUVY</span>
    <button class="grouvy-notice-close-btn" id="close-popup" aria-label="닫기">&times;</button>
  </div>

  <div class="grouvy-notice-body" id="notice-body">
    <span class="grouvy-notice-avatar" id="notice-img">
      <img src=""
           alt="프로필"
           class="rounded-circle profile-photo">
    </span>
    <div class="grouvy-notice-texts">
      <div class="grouvy-notice-title" id="msg-name">
        <%-- 함수로 값이 들어간다.--%>
      </div>
      <div class="grouvy-notice-sub" id="msg-content">
<%--        <c:choose>
          <c:when test="${not empty param.message}">
            ${param.message}
          </c:when>
          <c:otherwise>알림 테스트</c:otherwise>
        </c:choose>--%>
      </div>
      <div class="grouvy-notice-time" id="msg-time">
  <%--      <c:choose>
          <c:when test="${not empty param.time}">
            ${param.time}
          </c:when>
          <c:otherwise>방금 전</c:otherwise>
        </c:choose>--%>
      </div>
    </div>
  </div>
</div>

<!-- 알림 스타일 (선택적으로 상위 layout css에 이동 가능) -->
<style>
  .grouvy-notice-popup {
    position: fixed;
    right: 20px;
    bottom: 20px;
    width: 320px;
    max-height: 300px;
    overflow: hidden;
    z-index: 9999;
    background: #fff;
    color: #333;
    font-size: 0.95rem;
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
    border-radius: 12px;
    border: 1.5px solid #e5e7eb;
    display: flex;
    flex-direction: column;
    padding: 0;
    transition: all 0.3s ease;
    opacity: 1;
    transform: translateY(0);
  }

  .grouvy-notice-popup.hide {
    opacity: 0;
    transform: translateY(20px) scale(0.95);
    pointer-events: none;
  }

  .grouvy-notice-header {
    padding: 1rem 1.2rem 0.8rem 1.2rem;
    border-bottom: 1px solid #e5e7eb;
    text-align: center;
    background: #fff;
    position: relative;
  }

  .grouvy-notice-brand {
    font-weight: 600;
    font-size: 1.05rem;
  }

  .grouvy-notice-close-btn {
    position: absolute;
    top: 0.8rem;
    right: 1rem;
    background: none;
    border: none;
    color: #888;
    font-size: 1.2rem;
    cursor: pointer;
    opacity: 0.7;
    transition: all 0.2s;
    padding: 4px;
    border-radius: 50%;
    width: 28px;
    height: 28px;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .grouvy-notice-close-btn:hover {
    opacity: 1;
    color: #b8000d;
    background: #f3f6fa;
  }

  .grouvy-notice-body {
    display: flex;
    align-items: center;
    gap: 0.8rem;
    padding: 1rem 1.2rem;
    background: #fff;
    border-radius: 0 0 12px 12px;
    overflow-y: auto;
    max-height: 200px;
  }

  .grouvy-notice-avatar img {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    object-fit: cover;
    background: #e5e7eb;
  }

  .grouvy-notice-texts {
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 0.2rem;
  }

  .grouvy-notice-title {
    font-weight: 600;
    font-size: 1.05rem;
    color: #333;
    line-height: 1.2;
  }

  .grouvy-notice-sub {
    font-size: 0.9rem;
    color: #aaa;
    font-weight: 400;
    line-height: 1.3;
  }

  .grouvy-notice-time {
    font-size: 0.8rem;
    color: #999;
    margin-top: 0.2rem;
  }
</style>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
  // [수정 1] 알림 자동 닫기 타이머 ID를 저장할 변수 선언
  let notificationTimer;

  // 닫기 버튼 클릭 이벤트
  $("#close-popup").click(function () {
    // [수정 2] 수동으로 닫을 때도 자동 닫기 타이머를 반드시 취소
    clearTimeout(notificationTimer);

    const $popup = $("#notice-popup");
    $popup.addClass("hide");
    setTimeout(() => $popup.hide(), 300);
  });

  /*
   * [수정 3] 페이지 로드 시 실행되던 기존의 잘못된 자동 닫기 코드는 삭제합니다.
   */

  // 알림 배너를 띄우는 로직 함수
  function showNotification(userName, content, time, profile, roomId, roomName, isGroup, selectUserId) {
    // [수정 4] 새로운 알림이 뜨면, 기존에 설정된 자동 닫기 타이머가 있다면 먼저 취소
    clearTimeout(notificationTimer);

    const $noticePopup = $("#notice-popup");
    const $noticeImg = $("#notice-img img");
    const $msgName = $("#msg-name");
    const $msgContent = $("#msg-content");
    const $msgTime = $("#msg-time");

    // 1:1 채팅 또는 그룹 채팅에 따라 이름 설정
    if (isGroup == "Y") {
      $msgName.text(roomName);
    } else {
      $msgName.text(userName + "님의 메세지");
    }

    $msgContent.text(content);
    $msgTime.text(time);

    const imgPath = (!profile || profile === "null")
            ? "https://storage.googleapis.com/grouvy-bucket/default-profile.jpeg"
            : "https://storage.googleapis.com/grouvy-bucket/" + profile;
    $noticeImg.attr("src", imgPath);

    $noticePopup.removeClass("hide").css("display", "flex");

    // [수정 5] 알림이 표시된 후, 5초 뒤에 자동으로 닫히도록 새로운 타이머 설정
    notificationTimer = setTimeout(() => {
      const $popup = $("#notice-popup");
      if (!$popup.hasClass("hide")) {
        $popup.addClass("hide");
        setTimeout(() => $popup.hide(), 300);
      }
    }, 2000); // 5초 (5000ms), 시간은 원하시는 대로 조절 가능합니다.

    // 배너 클릭 시 채팅창 열기 (이벤트 중복을 막기 위해 .off().on() 사용)
    $("#notice-body").off('click').on('click', function() {
      // 배너를 클릭해서 창을 열면 자동 닫기 타이머는 취소
      clearTimeout(notificationTimer);

      if (isGroup == "N") {
        window.open(
                `/chat/chatting?roomId=\${roomId}`,
                '_blank',
                'width=420,height=650,resizable=no,scrollbars=no'
        );
      } else if (isGroup == "Y") {
        window.open(
                `/chat/chatting?roomId=\${roomId}`,
                '_blank',
                'width=420,height=650,resizable=no,scrollbars=no'
        );
      }

      // 클릭 후 즉시 팝업 닫기
      const $popup = $("#notice-popup");
      $popup.addClass("hide");
      setTimeout(() => $popup.hide(), 300);
    });
  }
</script>
