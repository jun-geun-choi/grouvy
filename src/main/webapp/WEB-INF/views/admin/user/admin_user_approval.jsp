<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../common/taglib.jsp"%>
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
<nav class="navbarr">
  <a href="#">전자결재</a>
  <a href="#">업무관리</a>
  <a href="#">업무문서함</a>
  <a href="${pageContext.request.contextPath}/admin/dept/list">조직도</a>
</nav>
<div class="container">
  <div class="sidebar">
    <h3>관리 기능</h3>
    <ul>
      <li><a href="/admin/user/approval">회원가입 승인</a> </li>
      <li><a href="/admin/user/list">사용자 계정관리</a> </li>
      <li><a href="/admin/user/login-history">로그인 기록</a> </li>
      <li><a href="/admin/user/attendance-history" class="active">출퇴근 기록</a></li>
    </ul>
  </div>
  <div class="main-content">
    <h2>신규 사원번호 발급 및 회원가입 승인</h2>
    <form class="row g-3">
      <div class="col-md-4">
        <label class="form-label">이름</label> <input type="text"
                                                    class="form-control" value="홍길순" readonly>
      </div>
      <div class="col-md-4">
        <label class="form-label">이메일</label> <input type="email"
                                                     class="form-control" value="hongsoon@email.com" readonly>
      </div>
      <div class="col-md-4">
        <label class="form-label">비밀번호</label> <input type="text"
                                                      class="form-control" value="자동생성1234" readonly>
      </div>
      <div class="col-md-4">
        <label class="form-label">사원번호</label> <input type="text"
                                                      class="form-control" value="20250001">
      </div>
      <div class="col-md-4">
        <label class="form-label">부서</label> <select class="form-select">
        <option>영업팀</option>
        <option>개발팀</option>
        <option>인사팀</option>
      </select>
      </div>
      <div class="col-md-4">
        <label class="form-label">직위</label> <select class="form-select">
        <option>사원</option>
        <option>대리</option>
        <option>과장</option>
        <option>차장</option>
        <option>부장</option>
      </select>
      </div>
      <div class="col-12 mt-3">
        <button type="submit" class="btn btn-success">최종 승인</button>
      </div>
    </form>
  </div>
</div>
<%@include file="../../common/footer.jsp" %>
</body>
</html>
