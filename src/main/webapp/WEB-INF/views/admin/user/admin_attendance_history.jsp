<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>출근/퇴근 기록 관리</title>
    <%@include file="../../common/head.jsp" %>
    <c:url var="adminCss" value="/resources/css/user/admin_main.css"/>
    <link href="${adminCss}" rel="stylesheet"/>
</head>
<body>
<%@include file="../../common/nav.jsp" %>
<%@include file="../admin_nav.jsp" %>
<div class="container">
    <%@include file="admin_user_sidebar.jsp" %>
    <div class="main-content">
        <h2>출근/퇴근 기록 관리</h2>
        <table class="table table-bordered align-middle">
            <thead class="table-light">
            <tr>
                <th>사원명</th>
                <th>사원번호</th>
                <th>부서</th>
                <th>출근 시각</th>
                <th>퇴근 시각</th>
                <th>근무 시간</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td>홍길순</td>
                <td>20250001</td>
                <td>영업팀</td>
                <td>2025-07-07 08:37:16</td>
                <td>2025-07-07 15:39:20</td>
                <td>7시간 2분</td>
            </tr>
            <!-- 추가 행 -->
            </tbody>
        </table>
    </div>
</div>
<%@include file="../../common/footer.jsp" %>
</body>
</html>