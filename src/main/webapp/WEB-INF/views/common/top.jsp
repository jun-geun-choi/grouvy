<%-- /src/main/webapp/WEB-INF/views/common/top.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header>
    <div style="display: flex; justify-content: space-between; padding: 10px; border-bottom: 1px solid #ccc;">
        <div>
            <a href="/">홈</a> |
            <a href="/dept/chart">조직도 (스크립틀릿)</a> |
            <a href="/dept/chart-test">조직도 (Test)</a>
        </div>
        <div>
            <a href="/login">로그인</a>
        </div>
    </div>
</header>