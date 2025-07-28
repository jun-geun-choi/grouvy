<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=320, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>채팅방 리스트</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
          rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/resources/css/chat/style.css' />"/>
</head>
<body>
<div class="sidebar">
    <%@include file="common/header.jsp" %>

<%--    <div class="p-3 pb-2">
        <input type="text" class="form-control" placeholder="채팅방 검색">
    </div>--%>
    <div class="chat_list" id="chats-list">
        <!-- JS로 동적 생성 -->
    </div>
</div>

<!-- 컨텍스트 메뉴 -->
<div id="context-menu" class="custom_context_menu"></div>

<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src ="<c:url value='/resources/js/chat/chatrooms.js' />"></script>
</body>
</html> 