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

<%--    <div class="p-3 pb-2">
      <input type="text" class="form-control" placeholder="이름, 부서명 검색">
    </div>--%>
    <div class="chat_list" id="org-list">
      <div class="accordion" id="org-dept-accordion">
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
  <script src ="<c:url value='/resources/js/chat/organization.js' />"></script>
</body>
</html> 