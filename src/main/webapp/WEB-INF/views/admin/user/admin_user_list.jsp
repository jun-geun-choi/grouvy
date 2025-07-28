<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../common/taglib.jsp"%>
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
<nav class="navbarr">
  <a href="#">전자결재</a>
  <a href="#">업무관리</a>
  <a href="#">업무문서함</a>
  <a href="#">조직도</a>
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
    <form>
      <table class="table table-bordered align-middle">
        <thead class="table-light">
        <tr>
          <th>사원명</th>
          <th>사원번호</th>
          <th>이메일</th>
          <th>부서</th>
          <th>직위</th>
          <th>재직상태</th>
          <th>수정</th>
        </tr>
        </thead>
        <tbody>
        <tr>
          <td><input type="text" class="form-control form-control-sm"
                     value="홍길순"></td>
          <td>20250001</td>
          <td>hongsoon@email.com</td>
          <td><select class="form-select form-select-sm">
            <option>영업팀</option>
            <option>개발팀</option>
          </select></td>
          <td><select class="form-select form-select-sm">
            <option>사원</option>
            <option>대리</option>
          </select></td>
          <td><select class="form-select form-select-sm">
            <option>재직</option>
            <option>휴직</option>
            <option>퇴사</option>
          </select></td>
          <td>
            <button class="btn btn-success btn-sm">저장</button>
          </td>
        </tr>
        <!-- 추가 사원 행 반복 -->
        </tbody>
      </table>
    </form>
  </div>
</div>
<%@include file="../../common/footer.jsp" %>
</body>
</html>
