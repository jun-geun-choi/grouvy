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
<%--                <li><a href="/mypage/setting">페이지 설정</a></li>--%>
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
                                        <button id="deleteProfileBtn" type="submit" class="dropdown-item">프로필 삭제
                                        </button>
                                    </li>
                                    <li>
                                        <label class="dropdown-item" for="imageUploadInput">프로필 변경</label>
                                    </li>
                                </c:otherwise>
                            </c:choose>
                        </ul>
                    </div>


                    <!-- 숨겨진 input & form -->
                    <form action="/mypage/update/profile/image" method="post" enctype="multipart/form-data"
                          class="ms-4">
                        <input type="file" id="imageUploadInput" name="image" class="d-none"
                               onchange="this.form.submit()">
                        <input type="hidden" name="userId"
                               value="<sec:authentication property='principal.user.userId' />">
                    </form>
                    <h4 class="mb-0 fw-semibold"><sec:authentication property="principal.user.name"/></h4>
                </div>


                <%-- 정보 수정 --%>
                <form action="/mypage/update/profile/info" method="post">
                    <div class="info-grid">
                        <div class="fw-bold">이름</div>
                        <div><sec:authentication property="principal.user.name"/></div>
                        <div class="fw-bold">사원번호</div>
                        <div><sec:authentication property="principal.user.employeeNo"/></div>
                        <div class="fw-bold">이메일</div>
                        <div><sec:authentication property="principal.username"/> (<sec:authentication
                                property="principal.user.loginProvider"/>)
                        </div>
                        <%--                        TODO : 상위 부서 표시--%>
                        <div class="fw-bold">부서</div>
                        <div><sec:authentication property="principal.user.department.departmentName"/></div>
                        <div class="fw-bold">직급</div>
                        <div><sec:authentication property="principal.user.position.positionName"/></div>

                        <div class="fw-bold">전화번호</div>
                        <div><sec:authentication property="principal.user.phoneNumber"/></div>


                        <div class="fw-bold">입사일</div>
                        <div><fmt:formatDate value="${joinDate}" pattern="yyyy-MM-dd"/></div>

                        <c:set var="address">
                            <sec:authentication property="principal.user.address"/>
                        </c:set>

                        <div class="fw-bold">주소</div>
                        <div class="col-md-12">
                            <div class="input-group">
                                <input type="text"
                                       id="roadFullAddr"
                                       class="form-control"
                                       name="address"
                                       placeholder="도로명 주소를 입력하세요"
                                       value="${empty address or address eq 'null' ? '' : address}" readonly>
                                <button type="button"
                                        class="btn btn-outline-primary"
                                        id="btnSearchAddress"
                                        onclick="goPopup()">
                                    <i class="bi bi-search"></i> 주소검색
                                </button>
                            </div>
                            <!-- 필요시 안내문 -->
                            <!-- <div class="form-text">검색 버튼을 눌러 도로명주소를 선택하세요.</div> -->
                        </div>

                    </div>

                    <div class="text-end mt-4">
                        <button type="button" id="btnCancel" class="border border-primary-subtle btn btn-light">취소</button>
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
<%@include file="../chat/chatNotice.jsp" %>
<script src="<c:url value="/resources/js/chat/chatNoticeSocket.js"/>"></script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
<script>
    // 최초 연결
    connectNoticeSocket();
</script>
<%-- 얘는 메신저 알림을 받기 위한, 설정 정보들 입니다. --%>
<script>
    document.getElementById("deleteProfileBtn").addEventListener("click", async () => {
        if (!confirm("프로필 이미지를 삭제하시겠습니까?")) return;

        try {
            const res = await fetch("/user/delete/profile-image", {
                method: "DELETE"
            });

            if (res.ok) {
                alert("프로필 이미지가 삭제되었습니다.");
                location.reload(); // 페이지 새로고침해서 반영
            } else {
                alert("삭제 실패");
            }
        } catch (err) {
            console.error(err);
            alert("오류 발생");
        }
    });
</script>

<%-- 주소 입력 --%>
<script language="javascript">

    function goPopup() {
        // 호출된 페이지(jusopopup.jsp)에서 실제 주소검색URL(https://business.juso.go.kr/addrlink/addrLinkUrl.do)를 호출하게 됩니다.
        var pop = window.open("/popup/jusoPopup", "pop", "width=570,height=420, scrollbars=yes, resizable=yes");
    }

    function jusoCallBack(roadFullAddr) {
        const input = document.getElementById("roadFullAddr");
        if (input) input.value = roadFullAddr || "";
    }

    // 취소
    document.getElementById("btnCancel").addEventListener("click", function () {
        const input = document.getElementById("roadFullAddr");
        if (input) {
            const original = input.getAttribute("data-original") || "";
            input.value = original;
            // location.reload(); // 새로고침 방식
        }
    });
</script>
</body>
</html>
