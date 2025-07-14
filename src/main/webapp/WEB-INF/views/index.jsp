<%-- /src/main/webapp/WEB-INF/views/index.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>메인페이지</title>
</head>
<body>
<c:import url="/WEB-INF/views/common/top.jsp" />

<h1>메인페이지</h1>
<p>환영합니다!</p>
<p>이제 조직도를 통해 사용자를 선택해보세요.</p>

<h2>주요 기능</h2>
<ul>
    <li><a href="/dept/chart">조직도 보기</a> </li>
</ul>
</body>
</html>
