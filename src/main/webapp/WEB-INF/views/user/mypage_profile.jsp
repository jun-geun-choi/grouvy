<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>마이페이지</title>
  <%@include file="../common/head.jsp" %>
  <link rel="stylesheet" href="resources/css/user/mypage_profile.css">
</head>
<body>
  <%@include file="../common/nav.jsp" %>
<main>
  <div class="container">
    <!-- 좌측 nav -->
    <div class="sidebar">
      <h3>마이페이지</h3>
      <ul>
        <li><a href="mypage_profile.html">개인 정보</a></li>
        <li><a href="mypage_attendance.html">근태 관리</a></li>
        <li><a href="mypage_loginlog.html">로그인 기록</a></li>
        <li><a href="mypage_settings.html">페이지 설정</a></li>
      </ul>
    </div>

    <!-- 마이페이지 > 개인 정보 -->
    <div class="main-content text-start">
      <h4 class="mb-4 fw-bold border-bottom pb-2">개인 정보</h4>

      <div class="card card-custom mb-4 card-wrapper">
<%--        <div class="d-flex align-items-center mb-4">--%>
          <form action="${pageContext.request.contextPath}/user/update/profile"
            method="post" enctype="multipart/form-data" class="d-flex align-items-center mb-4">
                      <c:set var="profilePath">
                        <sec:authentication property="principal.user.profileImgPath"/>
                      </c:set>
                      <c:choose>
                        <c:when test="${empty profilePath or profilePath eq 'null'}">
                          <img src="https://storage.googleapis.com/grouvy-profile-bucket/default-profile.jpeg"
                               alt="기본 프로필"
                               class="profile-photo"/>
                        </c:when>
                        <c:otherwise>
                          <img src="https://storage.googleapis.com/grouvy-profile-bucket/${profilePath}" alt="사용자 프로필"
                               class="profile-photo"/>
                        </c:otherwise>
                      </c:choose>
                      <input type="file" name="image" class="form-control form-control-sm w-auto me-2">
                      <input type="hidden" name="userId" value="<sec:authentication property="principal.user.userId" /> ">
                      <button type="submit" class="btn btn-primary btn-sm">업로드</button>
          </form>
<%--        </div>--%>

        <div class="info-grid">
          <div class="fw-bold">이름</div>
          <div><sec:authentication property="principal.user.name"/></div>
          <div class="fw-bold">사원번호</div>
          <div>20250001</div>

          <div class="fw-bold">직급</div>
          <div>대리</div>
          <div class="fw-bold">부서</div>
          <div>개발팀</div>

          <div class="fw-bold">생년월일</div>
          <div>1990-01-01</div>
          <div class="fw-bold">주소</div>
          <div>서울특별시 강남구</div>

          <div class="fw-bold">이메일</div>
          <div>example@grouvy.com (local)</div>
          <div class="fw-bold"></div>
          <div>
            <a href="#" class="text-decoration-none small text-muted">비밀번호
              초기화</a>
          </div>

          <div class="fw-bold">입사일</div>
          <div>2020-03-15</div>
        </div>
      </div>

      <div class="card card-custom mb-4 card-wrapper">
        <h5 class="fw-bold mb-3">인사 관련 정보</h5>
        <div class="info-grid">
          <div class="fw-bold">인사변동일자</div>
          <div>2024-05-01</div>
          <div class="fw-bold">근무상태변경일자</div>
          <div>2023-12-10</div>

          <div class="fw-bold">발령일자</div>
          <div>2023-11-05</div>
          <div class="fw-bold">계정상태변경일자</div>
          <div>2025-01-01</div>
        </div>
      </div>
    </div>
  </div>
</main>
<%@include file="../common/footer.jsp" %>
</body>
</html>
