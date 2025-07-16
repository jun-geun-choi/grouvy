<%-- /src/main/webapp/WEB-INF/views/common/top.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header>
    <div style="display: flex; justify-content: space-between; padding: 10px; border-bottom: 1px solid #ccc;">
        <div>
            <a href="/">홈</a> |
            <a href="/dept/chart">조직도</a> |
            <a href="/message/send">쪽지 쓰기</a> <!-- **새로운 쪽지 발송 링크 추가** -->
        </div>
        <div>
            <a href="/login">로그인</a>
        </div>
    </div>
</header>