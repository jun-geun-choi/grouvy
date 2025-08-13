<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 페이지</title>
    <%@include file="../common/head.jsp" %>
    <c:url var="adminCss" value="/resources/css/user/admin_main.css"/>
    <link href="${adminCss}" rel="stylesheet"/>
</head>
<body>
<%@include file="../common/nav.jsp" %>
<%@include file="admin_nav.jsp" %>
<div class="container">
    <div class="main-content">
        <div class="card">
            <h4>전체 사용자</h4>
            <p>총 100명 (활성: 95 / 비활성: 5)</p>
        </div>

        <div class="card">
            <h4>최근 가입 승인 요청</h4>
            <p>3건 대기중</p>
        </div>

        <div class="card">
            <h4>최근 로그인 현황</h4>
            <p>오늘 로그인: 82명</p>
        </div>

        <div class="card">
            <h4>공지사항</h4>
            <p>현재 등록된 공지: 2건</p>
        </div>

    </div>
</div>

<%@include file="../common/footer.jsp" %>
<%@include file="../chat/chatNotice.jsp" %>
<script src="<c:url value="/resources/js/chat/chatNoticeSocket.js"/>"></script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
<script>
    // 최초 연결
    connectNoticeSocket();
</script>
<%-- 얘는 메신저 알림을 받기 위한, 설정 정보들 입니다. --%>
</body>
</html>
