<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<div class="grouvy-nav">
    <style>
        /* nav 상단 여백 확보 */
        body {
            padding-top: 80px;
        }

        /* 네임스페이스 클래스 (중복 방지) */
        .grouvy-nav .navbar {
            z-index: 1030;
            height: 60px;
            min-height: 60px;
            padding-top: 0;
            padding-bottom: 0;
            background-color: white;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        .grouvy-nav .navbar-brand {
            height: 60px;
            width: 160px;
            display: flex;
            align-items: center;
            justify-content: start;
        }

        .grouvy-nav .logo-img {
            height: 60px;
            width: auto;
            object-fit: cover;
            display: block;
            margin: 0;
            padding: 0;
            line-height: 1;
        }

        .grouvy-nav .nav-item {
            padding-right: 1rem;
        }

        .grouvy-nav .navbar-nav .nav-link {
            color: #333;
            font-family: 'Malgun Gothic', '맑은 고딕', sans-serif;
        }

        .grouvy-nav .navbar-nav .nav-link.active {
            font-weight: bold;
            color: #e6002d !important;
        }

        .grouvy-nav .navbar .container-fluid {
            padding-right: 2rem;
            padding-left: 2rem;
        }

        .grouvy-nav .dropdown-menu-end {
            right: 0;
            left: auto;
        }

        .grouvy-nav .dropdown-menu {
            min-width: 150px;
            font-size: 0.9rem;
        }

        .grouvy-nav .dropdown-item i {
            margin-right: 8px;
        }

        .grouvy-nav .dropdown-toggle {
            font-weight: 500;
            font-size: 0.95rem;
        }
    </style>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

    <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand d-flex align-items-center" href="/">
        <span class="logo-crop">
          <img src="/resources/image/grouvy_logo.png" alt="GROUVY 로고" class="logo-img" />
        </span>
            </a>

            <ul class="navbar-nav mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link" href="#">전자결재</a></li>
                <li class="nav-item"><a class="nav-link" href="/file/personal">업무문서함</a></li>
                <li class="nav-item"><a class="nav-link" href="#">업무 관리</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/message/send">쪽지</a></li>
                <li class="nav-item"><a class="nav-link" href="#" onclick="window.open('chat/friends', 'messengerPopup', 'width=380,height=650,resizable=no,scrollbars=yes'); return false;">메신저</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/dept/list">조직도</a></li>
                <li class="nav-item"><a class="nav-link" href="#">일정</a></li>
                <li class="nav-item"><a class="nav-link" href="/admin">관리자</a></li>
            </ul>

            <div class="d-flex align-items-center">
                <c:choose>
                    <c:when test="${not empty pageContext.request.userPrincipal}">
                        <div class="dropdown ms-3">
                            <a href="#" class="d-flex align-items-center text-dark text-decoration-none dropdown-toggle"
                               id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                <span class="ms-2 fw-semibold">
                        ${pageContext.request.userPrincipal.name}
                </span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow" aria-labelledby="userDropdown">
                                <li><a class="dropdown-item d-flex align-items-center" href="/mypage_profile.html">
                                    <i class="bi bi-person me-2"></i> 마이페이지</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item d-flex align-items-center text-danger" href="/logout">
                                    <i class="bi bi-box-arrow-right me-2"></i> 로그아웃</a></li>
                            </ul>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="/login" class="btn btn-outline-secondary btn-sm ms-3">로그인</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </nav>
</div>
