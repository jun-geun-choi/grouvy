<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>GROUVY 메인 화면</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Bootstrap CSS CDN -->
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
            rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="resources/css/user/home.css">

</head>
<body>
<!-- 네비게이션바 -->
<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand d-flex align-items-center" href="/">
				<span class="logo-crop">
					<img src="resources/image/grouvy_logo.png" alt="GROUVY 로고" class="logo-img">
				</span>
        </a>
        <ul class="navbar-nav mb-2 mb-lg-0">
            <li class="nav-item"><a class="nav-link active" href="#">전자결재</a></li>
            <!-- 커서 active-->
            <li class="nav-item"><a class="nav-link" href="#">업무문서함</a></li>
            <li class="nav-item"><a class="nav-link" href="#">업무 관리</a></li>
            <li class="nav-item"><a class="nav-link" href="#">쪽지</a></li>
            <li class="nav-item"><a class="nav-link" href="#" onclick="window.open('chat/friends', 'messengerPopup', 'width=380,height=650,resizable=no,scrollbars=yes'); return false;">메신저</a></li>
            <li class="nav-item"><a class="nav-link" href="#">조직도</a></li>
            <li class="nav-item"><a class="nav-link" href="#">일정</a></li>
            <li class="nav-item"><a class="nav-link" href="admin_dashboard.html">관리자</a></li>
        </ul>
        <div class="d-flex align-items-center">
            <!-- 로그인 사용자 드롭다운 -->
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
                                <i class="bi bi-person me-2"></i> 마이페이지
                            </a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item d-flex align-items-center text-danger" href="/logout">
                                <i class="bi bi-box-arrow-right me-2"></i> 로그아웃
                            </a></li>
                        </ul>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- 로그인 안 한 경우 -->
                    <a href="/login" class="btn btn-outline-secondary btn-sm ms-3">로그인</a>
                </c:otherwise>
            </c:choose>

        </div>
    </div>
</nav>

<div class="container-fluid mt-3">
    <div class="row">
        <!-- 왼쪽 사이드바 -->
        <div class="col-lg-3 col-md-3 col-12 mb-3">
            <div class="card p-5 mb-3 text-center">
                <img
                        src="https://search.pstatic.net/sunny/?src=https%3A%2F%2Fs3.orbi.kr%2Fdata%2Ffile%2Funited2%2F6cc64e06aa404ac3a176745b9c1d5bfa.jpeg&type=sc960_832"
                        alt="프로필" class="rounded-circle mx-auto" width="80" height="80">
                <h5 class="mt-2 mb-1">그루비 사원</h5>
                <small class="text-muted">사원</small>
                <div class="icon-group mt-3">
                    <a href="#" class="text-dark text-decoration-none"> <i
                            class="bi bi-envelope"></i> <span class="small custom-gap">0</span>
                    </a> <a href="#" class="text-dark text-decoration-none"> <i
                        class="bi bi-bell"></i> <span class="small ms-2">0</span>
                </a>
                </div>
            </div>
            <div class="card p-3 mb-3">
                <div class="calendar">
                    <div
                            class="d-flex justify-content-between align-items-center mb-2">
                        <span class="fw-bold">7월</span> <span class="text-muted">2025</span>
                    </div>
                    <!-- 간단한 캘린더 예시 -->
                    <table
                            class="table table-bordered text-center mb-2 calendar-table">
                        <tr>
                            <th>일</th>
                            <th>월</th>
                            <th>화</th>
                            <th>수</th>
                            <th>목</th>
                            <th>금</th>
                            <th>토</th>
                        </tr>
                        <tr>
                            <td class="text-danger">29</td>
                            <td>30</td>
                            <td>1</td>
                            <td>2</td>
                            <td>3</td>
                            <td>4</td>
                            <td class="text-primary">5</td>
                        </tr>
                        <tr>
                            <td class="text-danger">6</td>
                            <td>7</td>
                            <td>8</td>
                            <td>9</td>
                            <td>10</td>
                            <td>11</td>
                            <td class="text-primary">12</td>
                        </tr>
                        <!-- 필요에 따라 추가 -->
                    </table>
                    <button class="btn btn-sm btn-outline-primary w-100">오늘
                        일정 등록
                    </button>
                </div>
            </div>
        </div>

        <!-- 메인 컨텐츠 -->
        <div class="col-lg-9 col-md-9 col-12">
            <div class="row g-3">
                <!-- 공지 -->
                <div class="col-12">
                    <div class="card p-3">
                        <h6 class="mb-1 fw-bold">
                            NOTICE <span class="text-muted ms-2">[공지] kkkk</span>
                        </h6>
                    </div>
                </div>
                <!-- 대시보드/근태관리/미확인 쪽지/결제요청함/결제대기함/수신 업무 요청/수신 업무 보고/업무 문서함/날씨/뉴스 -->
                <div class="col-lg-6 col-md-6 col-12 d-flex flex-column">
                    <div class="row flex-grow-1 min-vh-50 g-3">
                        <div class="col-12">
                            <div class="card p-3 h-100">
                                <h6 class="fw-bold mb-2">대시보드</h6>
                                <div class="dashboard-chart text-center">
                                    <span class="display-6 fw-bold">6</span> <span
                                        class="text-muted">total</span>
                                </div>
                                <ul class="list-unstyled mt-2 mb-0 small">
                                    <li>메일 <span class="float-end">0건</span></li>
                                    <li>전자결재 <span class="float-end">0건</span></li>
                                    <li>업무관리 <span class="float-end">6건</span></li>
                                    <li>일정 <span class="float-end">0건</span></li>
                                    <li>쪽지 <span class="float-end">0건</span></li>
                                </ul>
                            </div>
                        </div>

                        <div class="col-12">
                            <div class="card p-3 h-100">
                                <h6 class="fw-bold mb-2">미확인 쪽지</h6>
                                <div class="text-muted small">해당하는 데이터가 없습니다.</div>
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="card p-3 h-100">
                                <h6 class="fw-bold mb-2">결제요청함</h6>
                                <div class="text-muted small">해당하는 데이터가 없습니다.</div>
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="card p-3 h-100">
                                <h6 class="fw-bold mb-2">결제대기함</h6>
                                <div class="text-muted small">해당하는 데이터가 없습니다.</div>
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="card p-3 h-100">
                                <h6 class="fw-bold mb-2">뉴스</h6>
                                <div class="text-muted small">뉴스 정보 없음</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6 col-md-6 col-12 d-flex flex-column">
                    <div class="row flex-grow-1 min-vh-50 g-3">
                        <div class="col-12">
                            <div class="card p-3 h-100">
                                <h6 class="fw-bold mb-2">근태관리</h6>
                                <div class="mb-2 text-secondary small">
                                    2025년 07월 07일 (월) 15:39:35 <span
                                        class="badge bg-white border text-primary ms-2"
                                        style="font-size: 0.8rem; font-weight: 500;">휴가</span>
                                </div>
                                <div
                                        class="bg-light rounded-3 py-2 px-2 mb-2 d-flex align-items-center justify-content-between flex-wrap">
                                    <div class="text-center flex-fill">
                                        <div class="text-secondary mb-1 small">출근 시간</div>
                                        <div class="fw-bold" style="font-size: 1.1rem;">08:37:16</div>
                                    </div>
                                    <div class="text-center flex-fill">
                                        <span class="text-secondary" style="font-size: 1.2rem;">→</span>
                                    </div>
                                    <div class="text-center flex-fill">
                                        <div class="text-secondary mb-1 small">퇴근 시간</div>
                                        <div class="fw-bold" style="font-size: 1.1rem;">15:39:20</div>
                                    </div>
                                </div>
                                <div class="mb-1">
										<span class="fw-bold"
                                              style="color: #00c3aa; font-size: 0.95rem;">주간누적 14h
											2m</span> <span class="text-secondary ms-2 small">이번주 32h 0m
											더 필요해요.</span>
                                </div>
                                <div class="progress position-relative mb-2"
                                     style="height: 8px; background: #eaeaea;">
                                    <div class="progress-bar" role="progressbar"
                                         style="width: 27%; background: linear-gradient(90deg, #00eaff 60%, #00c3aa 100%);"
                                         aria-valuenow="14" aria-valuemin="0" aria-valuemax="52"></div>
                                    <span class="position-absolute start-0 translate-middle-y"
                                          style="top: 16px; font-size: 0.8rem; color: #aaa;">0h</span>
                                    <span class="position-absolute"
                                          style="left: 75%; top: 16px; font-size: 0.8rem; color: #aaa;">40h</span>
                                    <span class="position-absolute end-0 translate-middle-y"
                                          style="top: 16px; font-size: 0.8rem; color: #aaa;">52h</span>
                                </div>
                                <div class="d-flex gap-2 mb-2">
                                    <button class="btn btn-light flex-fill border py-1 px-1 small">출근하기</button>
                                    <button class="btn btn-light flex-fill border py-1 px-1 small">퇴근하기</button>
                                </div>
                                <button class="btn btn-outline-success w-100 py-1 px-1 small"
                                        style="font-weight: 500; border-color: #00c3aa; color: #00c3aa;">
                                    근무상태변경 <span class="ms-1">&#9660;</span>
                                </button>
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="card p-3 h-100">
                                <h6 class="fw-bold mb-2">수신 업무 요청</h6>
                                <div class="text-muted small">해당하는 데이터가 없습니다.</div>
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="card p-3 h-100">
                                <h6 class="fw-bold mb-2">수신 업무 보고</h6>
                                <div class="text-muted small">해당하는 데이터가 없습니다.</div>
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="card p-3 h-100">
                                <h6 class="fw-bold mb-2">업무 문서함</h6>
                                <div class="text-muted small">해당하는 데이터가 없습니다.</div>
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="card p-3 h-100">
                                <h6 class="fw-bold mb-2">날씨</h6>
                                <div class="text-muted small">날씨 정보 없음</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- row -->
        </div>
    </div>
</div>
<footer> © 2025 그룹웨어 Corp.</footer>
<!-- Bootstrap JS (필수: 드롭다운 등 작동에 필요) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>