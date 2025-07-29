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
<nav class="navbarr">
    <a href="/admin/user/list">인사관리</a>
    <a href="#">전자결재</a>
    <a href="#">업무관리</a>
    <a href="#">업무문서함</a>
    <a href="${pageContext.request.contextPath}/admin/dept/list">조직도</a>
</nav>
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
</body>
</html>
