<%@ page language="java" pageEncoding="UTF-8" %>
<!-- 네비게이션바 -->
<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm fixed-top">
  <div class="container-fluid">
    <a class="navbar-brand d-flex align-items-center" href="/">
				<span class="logo-crop">
					<img src="https://storage.googleapis.com/grouvy-profile-bucket/grouvy_logo.png" alt="GROUVY 로고" class="logo-img">
				</span>
    </a>
    <ul class="navbar-nav mb-2 mb-lg-0">
      <li class="nav-item"><a class="nav-link active" href="#">전자결재</a></li>
      <!-- 커서 active-->
      <li class="nav-item"><a class="nav-link" href="/file/personal">업무문서함</a></li>
      <li class="nav-item"><a class="nav-link" href="#">업무 관리</a></li>
      <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/message/send">쪽지</a></li>
      <li class="nav-item"><a class="nav-link" href="#"
                              onclick="window.open('/chat/friends', 'messengerPopup', 'width=380,height=650,resizable=no,scrollbars=yes'); return false;">메신저</a>
      </li>
      <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/dept/list">조직도</a></li>
      <li class="nav-item"><a class="nav-link" href="#">일정</a></li>
      <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/notification/list">알림
      <span id="navUnreadNotificationBadge" class="badge bg-danger ms-1" style="display: none;"></span></a></li>
      <sec:authorize access="hasRole('ROLE_ADMIN')">
        <li class="nav-item"><a class="nav-link" href="/admin">관리자</a></li>
      </sec:authorize>
    </ul>
    <sec:authorize access="isAuthenticated()">
      <div class="d-flex align-items-center">
        <!-- 로그인 사용자 드롭다운 -->
        <div class="dropdown ms-3">
          <a href="#" class="d-flex align-items-center text-dark text-decoration-none dropdown-toggle"
             id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false" style="padding-right: 10px;">
            <c:set var="profilePath">
              <sec:authentication property="principal.user.profileImgPath"/>
            </c:set>
            <c:choose>
              <c:when test="${empty profilePath or profilePath eq 'null'}">
                <img src="https://storage.googleapis.com/grouvy-bucket/default-profile.jpeg" alt="기본 프로필"
                     class="rounded-circle" width="36" height="36"/>
              </c:when>
              <c:otherwise>
                <img src="https://storage.googleapis.com/grouvy-bucket/${profilePath}" alt="사용자 프로필"
                     class="rounded-circle" width="36" height="36"/>
              </c:otherwise>
            </c:choose>
            <span class="ms-3 fw-semibold">
              <sec:authentication property="principal.user.name"/>
              <span class="ms-1">사원님</span>
            </span>
          </a>
          <ul class="dropdown-menu dropdown-menu-end shadow" aria-labelledby="userDropdown">
            <li><a class="dropdown-item d-flex align-items-center" href="/mypage-profile">
              <i class="bi bi-person me-2"></i> 마이페이지
            </a></li>
            <li>
              <hr class="dropdown-divider">
            </li>
            <li><a class="dropdown-item d-flex align-items-center text-danger" href="/logout">
              <i class="bi bi-box-arrow-right me-2"></i> 로그아웃
            </a></li>
          </ul>
        </div>
      </div>
    </sec:authorize>
  </div>
</nav>

<!-- sse알림 스크립트 -->
<sec:authorize access="isAuthenticated()">
<script>
    document.addEventListener('DOMContentLoaded', function() {

        function connectSse() {
            const eventSource = new EventSource('/api/v1/notifications/connect');

            eventSource.addEventListener('connect', (event) => {
                console.log('SSE connected:', event.data);
            });

            eventSource.addEventListener('unreadCounts', (event) => {
                try {
                    const counts = JSON.parse(event.data);
                    updateUnreadCounts(counts.unreadMessages, counts.unreadNotifications);
                } catch (error) {
                    console.error('Error parsing unreadCounts data:', error);
                }
            });

            eventSource.onerror = (error) => {
                console.error('EventSource failed. Closing connection.', error);
                eventSource.close();
            };
        }

        // 카운트를 업데이트하는 함수 (간소화됨)
        function updateUnreadCounts(messageCount, notificationCount) {
            // 쪽지 카운트 업데이트
            const messageLink = document.querySelector('.sidebar a[href$="/message/inbox"]'); // id 사용을 권장
            updateCountBadge(messageLink, messageCount, 'sidebarUnreadMessageBadge');

            // 알림 카운트 업데이트
            const notificationBadge = document.getElementById('navUnreadNotificationBadge');
            if (notificationBadge) {
                if (notificationCount > 0) {
                    notificationBadge.textContent = notificationCount;
                    notificationBadge.style.display = 'inline-block';
                } else {
                    notificationBadge.style.display = 'none';
                }
            }
        }

        // 특정 링크 요소 옆에 카운트 배지를 동적으로 관리하는 헬퍼 함수
        function updateCountBadge(linkElement, count, badgeId) {
            if (!linkElement) return;

            let badge = document.getElementById(badgeId);

            if (count > 0) {
                if (!badge) {
                    badge = document.createElement('span');
                    badge.id = badgeId;
                    badge.className = 'badge bg-danger ms-2';
                    linkElement.appendChild(badge);
                }
                badge.textContent = count;
            } else {
                if (badge) {
                    badge.remove();
                }
            }
        }

        connectSse();
    });
</script>
</sec:authorize>