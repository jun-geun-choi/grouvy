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
            <div class="card card-custom mb-4 p-4">
                <!-- 프로필과 이름 -->
                <div class="d-flex align-items-center mb-4">
                    <c:set var="profilePath">
                        <sec:authentication property="principal.user.profileImgPath"/>
                    </c:set>
                    <c:choose>
                        <c:when test="${empty profilePath or profilePath eq 'null'}">
                            <img src="https://storage.googleapis.com/grouvy-bucket/default-profile.jpeg" alt="기본 프로필"
                                 class="rounded-circle me-3" style="width: 72px; height: 72px; object-fit: cover;"/>
                        </c:when>
                        <c:otherwise>
                            <img src="https://storage.googleapis.com/grouvy-bucket/${profilePath}" alt="사용자 프로필"
                                 class="rounded-circle me-3" style="width: 72px; height: 72px; object-fit: cover;"/>
                        </c:otherwise>
                    </c:choose>
                    <h4 class="mb-0 fw-semibold"><sec:authentication property="principal.user.name"/></h4>
                </div>

                <!-- 정보 입력 폼 -->
                <form action="/user/update/profile" method="post" enctype="multipart/form-data">
                    <div class="row g-3 border-top pt-3">
                        <div class="col-md-6">
                            <label class="form-label">소속/직급</label>
                            <input type="text" name="position" class="form-control" value="그루비 / 관리직">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">부서/직책</label>
                            <input type="text" name="department" class="form-control" value="서비스 1본부 > 서비스기획1팀">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">사내 번호</label>
                            <input type="text" name="internalPhone" class="form-control" value="">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">휴대폰</label>
                            <div class="input-group">
                                <select class="form-select" name="countryCode">
                                    <option value="+82" selected>대한민국 +82</option>
                                </select>
                                <input type="text" name="phoneNumber" class="form-control" value="">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">이메일</label>
                            <input type="email" class="form-control" name="email" value="example@grouvy.com">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">메신저/SNS</label>
                            <div class="input-group">
                                <select class="form-select" name="sns">
                                    <option selected>LINE</option>
                                    <option>KakaoTalk</option>
                                    <option>Telegram</option>
                                </select>
                                <input type="text" name="snsId" class="form-control" placeholder="ID 입력">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">생일</label>
                            <input type="date" name="birthDate" class="form-control">
                        </div>
                    </div>

                    <div class="text-end mt-4">
                        <button type="submit" class="btn btn-primary">저장</button>
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
