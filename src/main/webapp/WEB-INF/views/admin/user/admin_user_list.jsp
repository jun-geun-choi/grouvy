<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../common/taglib.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>사용자 목록 관리</title>
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
        <h2>사용자 목록 관리</h2>
        <form class="row g-2 mb-3">
            <div class="col-md-2">
                <input type="text" class="form-control" placeholder="이름 검색">
            </div>
            <div class="col-md-2">
                <select class="form-select">
                    <option>부서 전체</option>
                    <option>영업팀</option>
                    <option>개발팀</option>
                </select>
            </div>
            <div class="col-md-2">
                <select class="form-select">
                    <option>직위 전체</option>
                    <option>사원</option>
                    <option>대리</option>
                </select>
            </div>
            <div class="col-md-2">
                <select class="form-select">
                    <option>재직상태 전체</option>
                    <option>재직</option>
                    <option>휴직</option>
                    <option>퇴사</option>
                </select>
            </div>
            <div class="col-md-2">
                <button class="btn btn-primary w-100">검색</button>
            </div>
        </form>

        <table class="table table-bordered align-middle">
            <thead class="table-light">
            <tr>
                <th>사원명</th>
                <th>사원번호</th>
                <th>이메일</th>
                <th>부서</th>
                <th>직위</th>
                <th>재직상태</th>
                <th>최종수정일자</th>
                <th>수정</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="user" items="${users }" varStatus="i">
                <form action="/admin/user/update" method="post">
                    <tr>
                        <td>${user.name}</td>
                        <td>${user.employeeNo}</td>
                        <td>${user.email}</td>
                        <td>
                            <select name="departmentId" class="form-select form-select-sm">
                                <c:forEach var="department" items="${departments }">
                                    <option value="${department.departmentId }"
                                            <c:if test="${user.departmentId eq department.departmentId }">
                                                selected
                                            </c:if>
                                    >${department.departmentName }</option>
                                </c:forEach>
                            </select>
                        </td>
                        <td><select name="positionNo" class="form-select form-select-sm">
                            <c:forEach var="position" items="${positions }">
                                <option value="${position.positionNo }"
                                        <c:if test="${user.positionNo eq position.positionNo }">
                                            selected
                                        </c:if>
                                >${position.positionName}</option>
                            </c:forEach>
                        </select></td>
                        <td>
                            <%
                                String[] statusList = {"재직", "휴직", "퇴사"};
                                request.setAttribute("statusList", statusList);
                            %>
                            <select name="employmentStatus" class="form-select form-select-sm">
                                <c:forEach var="status" items="${statusList}">
                                    <option value="${status}"
                                            <c:if test="${user.employmentStatus eq status}">selected</c:if>>
                                            ${status}
                                    </option>
                                </c:forEach>
                            </select></td>
                        <td><fmt:formatDate value="${user.updatedDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                        <td>
                            <input type="hidden" name="managerId" value="${managerId}">
                            <input type="hidden" name="userId" value="${user.userId}"/>
                            <button type="submit" class="btn btn-success btn-sm">저장</button>
                        </td>
                    </tr>
                </form>
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
