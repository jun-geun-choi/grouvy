<%-- sidebar 헤더 부분, 버튼 부분을 네비게이션으로 사용. --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<sec:authorize access="isAuthenticated"> <%-- 인증이 될 경우에만 아래 아래 인증된 사용자의 정보가 나온다. --%>
<sec:authentication property="principal.user" var="user"/>
<div class="sidebar_header">
    <%-- 나중에 DB에서 값을 가져오는 것으로 한다. --%>
    <img src="https://cdn-icons-png.flaticon.com/512/149/149071.png" alt="프로필">
    <div class="fw-bold">${user.name}</div>
    <div class="text-muted" style="font-size:0.95em;">${user.position.positionName}</div>
</div>
</sec:authorize>

<div class="navigation_buttons">
    <button name="friends" onclick="location.href='friends'">친구
    </button>

    <button name="organization" onclick="location.href='organization'">조직도
    </button>

    <button name="chatrooms" onclick="location.href='chatrooms'">
        채팅
    </button>
</div>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
  var path = window.location.pathname;
  var currentPath = path.replace(/^\/+|\/+$/g, '');
  console.log(path);
  console.log(currentPath);

  if(currentPath === 'chat/friends') {
    $("[name = 'friends']").addClass('active');
  } else if(currentPath === 'chat/organization') {
    $("[name = 'organization']").addClass('active');
  } else if (currentPath === 'chat/chatrooms') {
    $("[name = 'chatrooms']").addClass('active');
  }


</script>