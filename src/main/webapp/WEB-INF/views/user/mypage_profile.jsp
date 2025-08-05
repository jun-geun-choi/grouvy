<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>마이페이지</title>
    <%@include file="../common/head.jsp" %>
    <c:url var="mypageCss" value="/resources/css/user/mypage_profile.css"/>
    <link href="${mypageCss}" rel="stylesheet"/>
</head>
<body>
<%@include file="../common/nav.jsp" %>
<main>
    <div class="container">
        <!-- 좌측 nav -->
        <div class="sidebar">
            <h3>마이페이지</h3>
            <ul>
                <li><a href="/mypage/profile">개인 정보</a></li>
                <li><a href="/mypage/attendance">근태 관리</a></li>
                <li><a href="/mypage/login-history">로그인 기록</a></li>
                <li><a href="/mypage/setting">페이지 설정</a></li>
            </ul>
        </div>

        <!-- 마이페이지 > 개인 정보 -->
        <div class="main-content text-start">
            <h4 class="mb-4 fw-bold border-bottom pb-2">개인 정보</h4>
            <div class="card card-custom mb-4 card-wrapper">

                <div class="d-flex align-items-center mb-4 position-relative">
<%--                     프로필 이미지 --%>
                    <div class="position-relative">
                        <c:set var="profilePath">
                            <sec:authentication property="principal.user.profileImgPath"/>
                        </c:set>

                        <c:choose>
                            <c:when test="${empty profilePath or profilePath eq 'null'}">
                                <img src="https://storage.googleapis.com/grouvy-bucket/default-profile.jpeg"
                                     alt="기본 프로필"
                                     class="rounded-circle profile-photo"
                                     style="width: 120px; height: 120px; object-fit: cover;">
                            </c:when>
                            <c:otherwise>
                                <img src="https://storage.googleapis.com/grouvy-bucket/${profilePath}"
                                     alt="사용자 프로필"
                                     class="rounded-circle profile-photo"
                                     style="width: 120px; height: 120px; object-fit: cover;">
                            </c:otherwise>
                        </c:choose>

                        <!-- 카메라 아이콘 버튼 -->
                        <button class="btn btn-light btn-sm rounded-circle position-absolute bottom-0 end-0 border"
                                type="button" data-bs-toggle="dropdown" aria-expanded="false"
                                style="width: 32px; height: 32px;">
                            <i class="bi bi-camera"></i>
                        </button>
                        <ul class="dropdown-menu">
                            <c:choose>
                                <c:when test="${empty profilePath or profilePath eq 'null'}">
                                    <li>
                                        <label class="dropdown-item" for="imageUploadInput">프로필 변경</label>
                                    </li>
                                </c:when>
                                <c:otherwise>
                                    <li>
<%--                                        TODO : 프로필 이미지 삭제 --%>
                                        <form action="/user/delete/profile-image" method="post">
                                            <button type="submit" class="dropdown-item">프로필 삭제</button>
                                        </form>
                                    </li>
                                    <li>
                                        <label class="dropdown-item" for="imageUploadInput">프로필 변경</label>
                                    </li>
                                </c:otherwise>
                            </c:choose>
                        </ul>
                    </div>

                    <!-- 숨겨진 input & form -->
                    <form action="/mypage/update/profile/image" method="post" enctype="multipart/form-data" class="ms-4">
                        <input type="file" id="imageUploadInput" name="image" class="d-none"
                               onchange="this.form.submit()">
                        <input type="hidden" name="userId"
                               value="<sec:authentication property='principal.user.userId' />">
                    </form>
                </div>

                <form action="/mypage/update/profile/info" method="post">
                    <div class="info-grid">
                        <div class="fw-bold">이름</div>
                        <div><sec:authentication property="principal.user.name" /></div>
                        <div class="fw-bold">사원번호</div>
                        <div><sec:authentication property="principal.user.employeeNo" /></div>

                        <div class="fw-bold">직급</div>
                        <div><sec:authentication property="principal.user.position.positionName" /></div>
<%--                        TODO : 상위 부서 표시--%>
                        <div class="fw-bold">부서</div>
                        <div><sec:authentication property="principal.user.department.departmentName" /></div>

                        <div class="fw-bold">생년월일</div>
                        <div><input type="date" name="birthDate" class="form-control" value="1990-01-01"></div>
                        <div class="fw-bold">전화번호</div>
                        <div><sec:authentication property="principal.user.phoneNumber" /></div>
                        <div class="fw-bold">주소</div>
                        <div><sec:authentication property="principal.user.address" /></div>

                        <div class="fw-bold">이메일</div>
                        <div><sec:authentication property="principal.username" /> (<sec:authentication property="principal.user.loginProvider"  />)</div>

                        <div class="fw-bold">입사일</div>
                        <div><fmt:formatDate value="${joinDate}" pattern="yyyy-MM-dd"/></div>
                    </div>
                </form>
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
