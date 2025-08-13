<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
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

                <h5 class="mt-2 mb-1"><sec:authentication property="principal.user.name"/> <sec:authentication
                        property="principal.user.position.positionName"/>님</h5>
                <small class="text-muted"><sec:authentication property="principal.user.position.positionName"/></small>
                <div class="icon-group mt-3">
                    <%--안 읽은 쪽지 개수 --%>
                    <a href="<c:url value='/message/inbox'/>" class="text-dark text-decoration-none">
                        <i class="bi bi-envelope"></i>
                        <span class="small custom-gap"><c:out value="${unreadMessageCount}"/></span>
                    </a>
                    <%--안 읽은 알림 개수 --%>
                    <a href="<c:url value='/notification/list'/>" class="text-dark text-decoration-none">
                        <i class="bi bi-bell"></i>
                        <span class="small ms-2"><c:out value="${unreadNotificationCount}"/></span>
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
                                    <li>쪽지 <span class="float-end"><c:out value="${unreadMessageCount}"/>건</span></li>
                                </ul>
                            </div>
                        </div>

                        <div class="col-12">
                            <div class="card p-3 h-100">
                                <h6 class="fw-bold mb-2 d-flex justify-content-between">
                                    <span>미확인 쪽지</span>
                                    <a href="<c:url value='/message/inbox'/>" class="small text-secondary text-decoration-none">더보기</a>
                                </h6>
                                <c:choose>
                                    <c:when test="${not empty unreadMessages}">
                                        <ul class="list-group list-group-flush">
                                            <c:forEach items="${unreadMessages}" var="msg">
                                                <li class="list-group-item d-flex justify-content-between align-items-center p-1 border-0">
                                                    <a href="<c:url value='/message/detail?messageId=${msg.messageId}'/>" class="text-decoration-none text-dark small text-truncate" title="<c:out value='${msg.subject}'/>">
                                                        <strong>[<c:out value="${msg.senderName}"/>]</strong>
                                                        <c:out value="${msg.subject}"/>
                                                    </a>
                                                    <span class="badge bg-light text-muted ms-2"><fmt:formatDate value="${msg.sendDate}" pattern="MM-dd"/></span>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-muted small h-100 d-flex align-items-center justify-content-center">수신된 쪽지가 없습니다.</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="card p-3 h-100">
                                <h6 class="fw-bold mb-2">결제요청함</h6>
                                <c:if test="${empty myRequestApprovals}">
                                    <div class="text-muted small">결재요청 내역이 없습니다.</div>
                                </c:if>
                                <div class="approval-request-list">
                                    <c:forEach var="myRequestApproval" items="${myRequestApprovals }" varStatus="loop">
                                        <div class="d-flex justify-content-between align-items-center mb-2 p-2 border-bottom">
                                            <div>
                                                <div class="fw-bold small"><a href="/approval/requestDetail?no=${myRequestApproval.approvalNo}">${myRequestApproval.title}</a></div>
                                                <div class="text-muted" style="font-size: 0.8rem;"><fmt:formatDate value="${myRequestApproval.createdDate}" pattern="yyyy-MM-dd HH:mm:ss" /></div>
                                            </div>
                                            <c:choose>
                                                <c:when test="${myRequestApproval.status eq '결재완료'}">
                                                    <span class="badge bg-success text-white">결재완료</span>
                                                </c:when>
                                                <c:when test="${myRequestApproval.status eq '진행중'}">
                                                    <span class="badge bg-info text-white">진행중</span>
                                                </c:when>
                                                <c:when test="${myRequestApproval.status eq '반려'}">
                                                    <span class="badge bg-warning text-dark">반려</span>
                                                </c:when>
                                            </c:choose>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="card p-3 h-100">
                                <h6 class="fw-bold mb-2">결제대기함</h6>
                                <c:if test="${empty approvalsWait}">
                                    <div class="text-muted small">결재대기 내역이 없습니다.</div>
                                </c:if>
                                <div class="approval-wait-list">
                                    <c:forEach var="approvalWait" items="${approvalsWait }" varStatus="loop">
                                        <div class="d-flex justify-content-between align-items-center mb-2 p-2 border-bottom">
                                            <div>
                                                <div class="fw-bold small"><a href="/approval/waitDetail?no=${approvalWait.approvalNo}">${approvalWait.title}</a></div>
                                                <div class="text-muted" style="font-size: 0.8rem;">${approvalWait.writerName} - <fmt:formatDate value="${approvalWait.createdDate}" pattern="yyyy-MM-dd" /></div>
                                            </div>
                                            <span class="badge bg-danger text-white">진행중</span>
                                        </div>
                                    </c:forEach>
                                </div>
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
                                    <span id="currentTime"></span>
<%--                                    <span--%>
<%--                                            class="badge bg-white border text-primary ms-2"--%>
<%--                                            style="font-size: 0.8rem; font-weight: 500;">휴가</span>--%>
                                </div>
                                <div id="locationStatus" class="text-secondary small mb-2"></div>
                                <div
                                        class="bg-light rounded-3 py-2 px-2 mb-2 d-flex align-items-center justify-content-between flex-wrap">
                                    <div class="text-center flex-fill">
                                        <div class="text-secondary mb-1 small">출근 시간</div>
                                        <div class="fw-bold" style="font-size: 1.1rem;">
                                            <span id="checkInTimeText">--:--:--</span>
                                        </div>
                                    </div>
                                    <div class="text-center flex-fill">
                                        <span class="text-secondary" style="font-size: 1.2rem;">→</span>
                                    </div>
                                    <div class="text-center flex-fill">
                                        <div class="text-secondary mb-1 small">퇴근 시간</div>
                                        <div class="fw-bold" style="font-size: 1.1rem;">
                                            <span id="checkOutTimeText">--:--:--</span>
                                        </div>
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
                                    <button id="checkInBtn" class="btn btn-light flex-fill border py-1 px-1 small">
                                        출근하기
                                    </button>
                                    <button id="checkOutBtn" class="btn btn-light flex-fill border py-1 px-1 small">
                                        퇴근하기
                                    </button>
                                </div>
                                <button class="btn btn-outline-success w-100 py-1 px-1 small"
                                        style="font-weight: 500; border-color: #00c3aa; color: #00c3aa;">
                                    근무상태변경 <span class="ms-1">&#9660;</span>
                                </button>
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="card p-3 h-100">
                                <h6 class="fw-bold mb-2 "><a href="/task/request/receive" class="text-decoration-none text-dark">수신 업무 요청</a></h6>
                                <div class="text-muted small">
                                    <ul class="list-group list-group-flush">

                                        <c:forEach var="request" items="${receiveRequestList}" varStatus="st">
                                          <c:if test="${st.count <= 5}">
                                            <li class="list-group-item px-0 py-2">
                                              <div class="d-flex justify-content-between align-items-start">
                                                <div class="me-2">
                                                  <a href="/task/detail/${request.taskId}" class="text-decoration-none text-dark fw-semibold text-truncate d-block" style="max-width: 400px;">
                                                    ${request.title}
                                                  </a>
                                                  <div class="small text-muted mt-1">
                                                    요청자: ${request.writerName} ${request.writerPositionName}
                                                  </div>
                                                </div>

                                                <div class="text-end">
                                                  <c:choose>
                                                      <c:when test="${not empty request.dueDate}">
                                                        <span class="badge bg-secondary">
                                                          마감일: ${request.dueDate}
                                                        </span>
                                                      </c:when>
                                                      <c:otherwise>
                                                        <span class="badge bg-secondary">
                                                          마감일 없음
                                                        </span>
                                                      </c:otherwise>
                                                    </c:choose>

                                                  <%-- 상태 배지 --%>
                                                  <span class="badge ${request.status eq '처리완료' ? 'bg-success' : 'bg-primary'} ms-1">
                                                  ${request.status}
                                                </span>
                                                </div>
                                              </div>
                                            </li>
                                          </c:if>
                                        </c:forEach>
                                      </ul>
                                </div>
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="card p-3 h-100">
                                <h6 class="fw-bold mb-2 "><a href="/task/report/receive" class="text-decoration-none text-dark">수신 업무 보고</a></h6>
                                <div class="text-muted small">
                                    <ul class="list-group list-group-flush">

                                        <c:forEach var="report" items="${receiveReportList}" varStatus="st">
                                          <c:if test="${st.count <= 5}">
                                            <li class="list-group-item px-0 py-2">
                                              <div class="d-flex justify-content-between align-items-start">
                                                <div class="me-2">
                                                  <a href="/task/request/detail/${report.taskId}" class="text-decoration-none text-dark fw-semibold text-truncate d-block" style="max-width: 400px;">
                                                    ${report.title}
                                                  </a>
                                                  <div class="small text-muted mt-1">
                                                    보고자: ${report.writerName} ${report.writerPositionName}
                                                  </div>
                                                </div>

                                                <div class="text-end">

                                                  <%-- 상태 배지 --%>
                                                  <span class="badge ${report.status eq '검토완료' ? 'bg-success' : 'bg-primary'} ms-1">
                                                  ${report.status}
                                                </span>
                                                </div>
                                              </div>
                                            </li>
                                          </c:if>
                                        </c:forEach>
                                      </ul>
                                </div>
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
<%-- 얘는 메신저 알림을 받기 위한, 설정 정보들 입니다. --%>
<%@include file="chat/chatNotice.jsp" %>
<script src="<c:url value="/resources/js/chat/chatNoticeSocket.js"/>"></script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
<script>
    function updateCurrentTime() {
        const timeEl = document.getElementById("currentTime");
        const now = new Date();

        const year = now.getFullYear();
        const month = now.getMonth() + 1;
        const date = now.getDate();
        const dayNames = ["일", "월", "화", "수", "목", "금", "토"];
        const day = dayNames[now.getDay()];

        const hours = now.getHours().toString().padStart(2, '0');
        const minutes = now.getMinutes().toString().padStart(2, '0');
        const seconds = now.getSeconds().toString().padStart(2, '0');

        timeEl.textContent =
            year + "년 " +
            month.toString().padStart(2, '0') + "월 " +
            date.toString().padStart(2, '0') + "일 (" +
            day + ") " +
            hours + ":" + minutes + ":" + seconds;
    }

    // 최초 1번 실행 + 1초마다 갱신
    updateCurrentTime();
    setInterval(updateCurrentTime, 1000);
</script>
<script>
    const companyLat = 37.572955; // 회사 위도
    const companyLon = 126.992257; // 회사 경도
    const allowedDistance = 70; // 허용 거리 (미터)

    const status = document.getElementById("locationStatus");
    const checkInBtn = document.getElementById("checkInBtn");
    const checkOutBtn = document.getElementById("checkOutBtn");

    function getDistanceFromCompany(lat1, lon1) {
        const R = 6371000; // 지구 반지름 (미터)
        const lat1Rad = lat1 * Math.PI / 180;
        const lat2Rad = companyLat * Math.PI / 180;
        const deltaLat = (companyLat - lat1) * Math.PI / 180;
        const deltaLon = (companyLon - lon1) * Math.PI / 180;

        const a = Math.sin(deltaLat / 2) * Math.sin(deltaLat / 2) +
            Math.cos(lat1Rad) * Math.cos(lat2Rad) *
            Math.sin(deltaLon / 2) * Math.sin(deltaLon / 2);
        const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

        return R * c; // 거리 (미터)
    }

    function isWithinCompany() {
        return new Promise((resolve, reject) => {
            if ("geolocation" in navigator) {
                navigator.geolocation.getCurrentPosition(
                    (position) => {
                        const {latitude, longitude} = position.coords;
                        const distance = getDistanceFromCompany(latitude, longitude);

                        if (distance <= allowedDistance) {
                            status.textContent = "회사 내부입니다 (" + distance.toFixed(1) + "m 이내)";
                            resolve({
                                withinCompany: distance <= allowedDistance,
                                latitude,
                                longitude,
                                distance
                            });
                        } else {
                            status.textContent = "회사 외부입니다 (" + distance.toFixed(1) + "m). 출퇴근 처리가 제한됩니다.";
                            resolve({
                                withinCompany: distance <= allowedDistance,
                                latitude,
                                longitude,
                                distance
                            });
                        }
                    },
                    (error) => {
                        status.textContent = "위치 정보를 가져올 수 없습니다: " + error.message;
                        reject(false);
                    },
                    {
                        enableHighAccuracy: true,
                        timeout: 15000,
                        maximumAge: 0
                    }
                );
            } else {
                status.textContent = "브라우저가 위치 서비스를 지원하지 않습니다.";
                reject(false);
            }
        });
    }

    // KST 기준 HH:mm:ss로 예쁘게 포맷
    function formatKST(timeStr) {
        if (!timeStr) return "--:--:--";
        // 서버가 "2025-08-11T08:37:16.123+09:00" 같은 ISO를 주면 그대로 파싱됨
        const d = new Date(timeStr);
        // 브라우저 로컬시간으로 보이게 하려면 timeZone 제거, KST 고정이면 아래 옵션 유지
        return d.toLocaleTimeString('ko-KR', { hour12: false, hour: '2-digit', minute: '2-digit', second: '2-digit', timeZone: 'Asia/Seoul' });
    }

    // 시간 표시에만 책임
    function renderTimes(status) {
        const inEl = document.getElementById("checkInTimeText");
        const outEl = document.getElementById("checkOutTimeText");
        inEl.textContent  = formatKST(status.checkInTime);
        outEl.textContent = formatKST(status.checkOutTime);
    }

    function updateButtonsBasedOnStatus(status) {
        // 먼저 시간 반영
        renderTimes(status);

        if (status.checkInTime && !status.checkOutTime) {
            // 출근했지만 퇴근 안함
            checkInBtn.disabled = true;
            checkOutBtn.disabled = false;
        } else if (status.checkInTime && status.checkOutTime) {
            // 출퇴근 모두 완료
            checkInBtn.disabled = true;
            checkOutBtn.disabled = true;
        } else {
            // 아무것도 안한 상태
            checkInBtn.disabled = false;
            checkOutBtn.disabled = true;
        }
    }

    async function refreshTodayStatus() {
        try {
            const res = await fetch("/attendance/today-status", {method: "GET"});
            if (res.ok) {
                const today = await res.json();
                updateButtonsBasedOnStatus(today || {});
            } else {
                checkInBtn.disabled = true;
                checkOutBtn.disabled = true;
                renderTimes({}); // "--:--:--"로 초기화
            }
        } catch (e) {
            console.error(e);
            checkInBtn.disabled = true;
            checkOutBtn.disabled = true;
            renderTimes({}); // "--:--:--"로 초기화
        }
    }

    // 페이지 로드 시 위치 확인
    window.onload = async function () {

        await refreshTodayStatus();

        checkInBtn.addEventListener("click", async () => {
            const locationResult = await isWithinCompany();
            if (!locationResult.withinCompany) return alert("회사 외부에서는 출근할 수 없습니다.");

            const res = await fetch("/attendance/checkin", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({
                    status: "출근",
                    latitude: locationResult.latitude,
                    longitude: locationResult.longitude,
                    distance: locationResult.distance
                })
            });
            if (res.ok) {
                alert("출근 완료!");
                await refreshTodayStatus();
            }
        });
        checkOutBtn.addEventListener("click", async () => {
            const locationResult = await isWithinCompany();
            if (!locationResult.withinCompany) return alert("회사 외부에서는 퇴근할 수 없습니다.");

            const res = await fetch("/attendance/checkout", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({
                    status: "퇴근",
                    latitude: locationResult.latitude,
                    longitude: locationResult.longitude,
                    distance: locationResult.distance
                })
            });
            if (res.ok) {
                alert("퇴근 완료!");
                await refreshTodayStatus();
            }
        });
    };

</script>
<script>
    // 최초 연결
    connectNoticeSocket();
</script>
<%-- 얘는 메신저 알림을 받기 위한, 설정 정보들 입니다. --%>
</body>
</html>