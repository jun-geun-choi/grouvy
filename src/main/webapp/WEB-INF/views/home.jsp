<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="common/taglib.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>GROUVY 메인 화면</title>
    <%@include file="common/head.jsp" %>
</head>
<body>
<%@include file="common/nav.jsp" %>
<div class="container-fluid mt-3">
    <div class="row">
        <!-- 왼쪽 사이드바 -->
        <div class="col-lg-3 col-md-3 col-12 mb-3">
            <div class="card p-5 mb-3 text-center">
                <c:set var="profilePath">
                    <sec:authentication property="principal.user.profileImgPath"/>
                </c:set>
                <c:choose>
                    <c:when test="${empty profilePath or profilePath eq 'null'}">
                        <img src="https://storage.googleapis.com/grouvy-bucket/default-profile.jpeg"
                             alt="기본 프로필"
                             class="rounded-circle mx-auto" width="80" height="80"/>
                    </c:when>
                    <c:otherwise>
                        <img src="https://storage.googleapis.com/grouvy-bucket/${profilePath}" alt="사용자 프로필"
                             class="rounded-circle mx-auto" width="80" height="80"/>
                    </c:otherwise>
                </c:choose>

                <h5 class="mt-2 mb-1"><sec:authentication property="principal.user.name"/> 사원</h5>
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
<%@include file="common/footer.jsp" %>
</body>
</html>