<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../common/taglib.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>신규 사원번호 발급 및 회원가입 승인</title>
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
        <h2 class="mb-4">신규 사원 회원가입 승인</h2>

        <table class="table table-bordered align-middle text-center">
            <thead class="table-light">
            <tr>
                <th>이름</th>
                <th>이메일</th>
                <th>사원번호</th>
                <th>부서</th>
                <th>직위</th>
                <th>승인</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="approval" items="${pendingUsers}">
                <tr>
                    <form action="/admin/handle-user-approval" method="post" class="align-middle">
                        <td>${approval.user.name}</td>
                        <td>${approval.user.email} (${approval.user.loginProvider})</td>
                        <td>
                            <input type="text" name="employeeNo" class="form-control form-control-sm"
                                   placeholder="사번 입력">
                        </td>
                        <td>
                            <select name="departmentId" class="form-select form-select-sm">
                                <option value="">부서 선택</option>
                                <c:forEach var="department" items="${departments}">
                                    <option value="${department.departmentId}">${department.departmentName}</option>
                                </c:forEach>
                            </select>
                        </td>
                        <td>
                            <select name="positionNo" class="form-select form-select-sm">
                                <option value="">직위 선택</option>
                                <c:forEach var="position" items="${positions}">
                                    <option value="${position.positionNo}">${position.positionName}</option>
                                </c:forEach>
                            </select>
                        </td>
                        <td>
                            <input type="hidden" name="userId" value="${approval.user.userId}"/>
                            <input type="hidden" name="approvalId" value="${approval.approvalId}"/>
                            <button type="submit" name="action" value="approve" class="btn btn-success btn-sm">승인</button>
                            <button type="submit" name="action" value="reject" class="btn btn-danger btn-sm">반려</button>
                        </td>
                    </form>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        <table class="table table-bordered align-middle text-center">
            <thead class="table-light">
            <tr>
                <th>이름</th>
                <th>이메일</th>
                <th>사원번호</th>
                <th>부서</th>
                <th>직위</th>
                <th>승인여부</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="approvedUser" items="${approvedUsers}" varStatus="i">
                <tr>

                    <td>${approvedUser.user.name}</td>
                    <td>${approvedUser.user.email} (${approvedUser.user.loginProvider})</td>
                    <td>${approvedUser.user.employeeNo}</td>
                    <td>${approvedUser.user.department.departmentName}</td>
                    <td>${approvedUser.user.position.positionName}</td>
                    <td>${approvedUser.status}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
<%@include file="../../common/footer.jsp" %>
<%@include file="../../chat/chatNotice.jsp" %>
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
