<%-- src/main/webapp/WEB-INF/views/department/organization_chart.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>조직도</title>

    <%-- Bootstrap 및 아이콘 라이브러리는 그대로 사용 --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

    <%-- home.css 및 department.css 링크 --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/department/department.css">
    <c:url var="homeCss" value="/resources/css/user/home.css"/>
    <link href="${homeCss}" rel="stylesheet"/>
</head>
<body>
<%@include file="../common/nav.jsp" %>
<div class="main-container">
    <h2>조직도</h2>

    <div class="org-layout-container">
        <%-- 왼쪽: 조직도 영역 --%>
        <div class="org-chart-wrapper">
            <div class="org-chart-tree" id="orgChartTree">
                <p>조직도 데이터를 불러오는 중...</p>
            </div>
        </div>

        <%-- 오른쪽: 상세 정보 및 검색 영역 --%>
        <div class="details-panel-wrapper">
            <div class="search-box">
                <i class="bi bi-search search-icon"></i>
                <input type="text" id="userSearchInput" class="form-control" placeholder="이름 또는 부서명으로 검색">
                <div id="searchResultsContainer" class="search-results"></div>
            </div>
            <div id="userDetailsPanel" class="user-details-panel">
                <%-- 초기 메시지 --%>
                <div class="initial-message">
                    <i class="bi bi-people"></i>
                    <p>조직도에서 사용자를 선택하거나<br>검색하여 상세 정보를 확인하세요.</p>
                </div>
            </div>
        </div>
    </div>
</div>
<%@include file="../common/footer.jsp" %>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const orgChartTree = document.getElementById('orgChartTree');
        const userDetailsPanel = document.getElementById('userDetailsPanel');
        const searchInput = document.getElementById('userSearchInput');
        const searchResultsContainer = document.getElementById('searchResultsContainer');
        let activeUserItem = null;
        let searchDebounceTimer; // 디바운싱을 위한 타이머 변수

        //조직도 데이터 가져오기
        async function fetchAndRenderOrgChart() {
            try {
                const response = await fetch('/api/v1/dept/tree');
                if (!response.ok) throw new Error(`조직도 데이터 로딩 실패: \${response.status}`);
                const departmentTreeData = await response.json();

                orgChartTree.innerHTML = '';
                renderDepartmentTree(departmentTreeData, orgChartTree);
                setupEventListeners();
            } catch (error) {
                console.error(error);
                orgChartTree.innerHTML = `<p class="text-danger text-center">\${error.message}</p>`;
            }
        }

        //조직도 트리 렌더링 함수
        function renderDepartmentTree(departments, parentElement) {
            if (!departments || departments.length === 0) return;

            const ul = document.createElement('ul');
            if (parentElement.id === 'orgChartTree') {
                ul.className = 'dept-list';
            } else {
                ul.className = 'dept-list child-dept-list';
                // 하위부서 목록은 항상 보이도록
                ul.style.display = 'block';
            }

            departments.forEach(department => {
                const li = document.createElement('li');
                li.className = 'dept-item';

                // 부서명 컨테이너 생성
                const deptNameContainer = document.createElement('span');
                deptNameContainer.className = 'department-name';
                const toggleIcon = document.createElement('span');
                toggleIcon.className = 'toggle-icon';
                toggleIcon.textContent = department.users?.length > 0 ? '▶' : '';
                deptNameContainer.appendChild(toggleIcon);
                deptNameContainer.appendChild(document.createTextNode(department.departmentName || '부서명 없음'));
                li.appendChild(deptNameContainer);

                // 사용자 리스트 생성
                const userListUl = document.createElement('ul');
                userListUl.className = 'user-list';
                if (department.users?.length > 0) {
                    department.users.forEach(user => {
                        const userLi = document.createElement('li');
                        userLi.className = 'user-item';
                        userLi.dataset.userId = user.userId;
                        const positionName = user.position?.positionName || '직책없음';
                        userLi.textContent = `\${user.name || '이름없음'} (\${positionName})`;
                        userListUl.appendChild(userLi);
                    });
                } else {
                    const noUserLi = document.createElement('li');
                    noUserLi.className = 'user-item no-user';
                    noUserLi.textContent = '소속된 사용자가 없습니다.';
                    userListUl.appendChild(noUserLi);
                    userListUl.style.display = 'block';
                }
                li.appendChild(userListUl);
                ul.appendChild(li);

                if (department.children?.length > 0) {
                    renderDepartmentTree(department.children, li);
                }
            });
            parentElement.appendChild(ul);
        }

        //사용자 프로필 렌더링
        function renderUserProfile(user) {
            if (!user) {
                userDetailsPanel.innerHTML = '<p class="text-danger text-center">사용자 정보를 찾을 수 없습니다.</p>';
                return;
            }
            const profileImgPath = user.profileImgPath
                ? `https://storage.googleapis.com/grouvy-bucket/\${user.profileImgPath}`
                : `https://storage.googleapis.com/grouvy-bucket/default-profile.jpeg`;
            const userName = user.name || '이름 없음';
            const positionName = user.position?.positionName || '직책 정보 없음';
            const departmentName = user.department?.departmentName || '부서 정보 없음';
            const email = user.email || '이메일 정보 없음';
            const phoneNumber = user.phoneNumber || '연락처 정보 없음';
            const profileHtml = `
            <div class="user-profile-card">
                <img src="\${profileImgPath}" alt="\${userName} 프로필 사진" class="profile-img">
                <h4>\${userName}</h4>
                <p class="position-dept">\${positionName} / \${departmentName}</p>
                <ul class="info-list">
                    <li><i class="bi bi-envelope-fill"></i> \${email}</li>
                    <li><i class="bi bi-telephone-fill"></i> \${phoneNumber}</li>
                    <li><i class="bi bi-building-fill"></i> \${departmentName}</li>
                </ul>
            </div>
        `;
            userDetailsPanel.innerHTML = profileHtml;
        }

        //사용자 상세 정보 가져오기
        async function fetchAndShowUserDetails(userId) {
            if (!userId) return;
            const loadingSpinner = `<div class="d-flex justify-content-center mt-5"><div class="spinner-border" role="status"><span class="visually-hidden">Loading...</span></div></div>`;
            userDetailsPanel.innerHTML = loadingSpinner;
            try {
                const response = await fetch(`/api/v1/dept/user-profile/\${userId}`);
                if (!response.ok) throw new Error('사용자 정보를 불러올 수 없습니다.');
                const user = await response.json();
                renderUserProfile(user);
            } catch (error) {
                console.error(error);
                userDetailsPanel.innerHTML = `<p class="text-danger text-center">\${error.message}</p>`;
            }
        }

        //이벤트 리스너 설정
        function setupEventListeners() {
            orgChartTree.addEventListener('click', function(event) {
                const deptNameEl = event.target.closest('.department-name');
                const userItemEl = event.target.closest('.user-item:not(.no-user)');
                if (deptNameEl) {
                    const deptItem = deptNameEl.closest('.dept-item');
                    const userList = deptItem.querySelector('.user-list');
                    const toggleIcon = deptNameEl.querySelector('.toggle-icon');
                    if (userList && toggleIcon && toggleIcon.textContent) {
                        const isExpanded = userList.classList.toggle('expanded');
                        userList.style.display = isExpanded ? 'block' : 'none';
                        toggleIcon.style.transform = isExpanded ? 'rotate(90deg)' : 'rotate(0deg)';
                    }
                }
                if (userItemEl) {
                    const userId = userItemEl.dataset.userId;
                    fetchAndShowUserDetails(userId);
                    if(activeUserItem) activeUserItem.classList.remove('active');
                    userItemEl.classList.add('active');
                    activeUserItem = userItemEl;
                }
            });

            //검색 입력 이벤트 (디바운싱 적용)
            searchInput.addEventListener('input', function(e) {
                clearTimeout(searchDebounceTimer); // 이전 타이머를 취소

                searchDebounceTimer = setTimeout(async () => {
                    const keyword = e.target.value.trim();
                    if (keyword.length < 1) {
                        searchResultsContainer.style.display = 'none';
                        return;
                    }
                    try {
                        const response = await fetch(`/api/v1/dept/search-users?keyword=\${encodeURIComponent(keyword)}`);
                        const users = await response.json();

                        searchResultsContainer.innerHTML = '';
                        if (users.length > 0) {
                            users.forEach(user => {
                                const item = document.createElement('div');
                                item.className = 'search-result-item';
                                item.dataset.userId = user.userId;
                                const positionName = user.position?.positionName || '직책없음';
                                const departmentName = user.department?.departmentName || '부서없음';
                                item.innerHTML = `<strong>\${user.name}</strong> <span class="text-muted">(\${positionName} / \${departmentName})</span>`;
                                searchResultsContainer.appendChild(item);
                            });
                            searchResultsContainer.style.display = 'block';
                        } else {
                            searchResultsContainer.innerHTML = '<div class="p-2 text-muted text-center">검색 결과가 없습니다.</div>';
                            searchResultsContainer.style.display = 'block';
                        }
                    } catch (error) {
                        console.error('검색 중 오류:', error);
                        searchResultsContainer.style.display = 'none';
                    }
                }, 300); // 300ms 후에 검색 실행
            });

            // 검색 결과 클릭 이벤트
            searchResultsContainer.addEventListener('click', function(e){
                const target = e.target.closest('.search-result-item');
                if(target) {
                    const userId = target.dataset.userId;
                    fetchAndShowUserDetails(userId);
                    searchResultsContainer.style.display = 'none';
                    searchInput.value = '';
                    if(activeUserItem) activeUserItem.classList.remove('active');
                    activeUserItem = orgChartTree.querySelector(`.user-item[data-user-id='${userId}']`);
                    if(activeUserItem) activeUserItem.classList.add('active');
                }
            });

            // 다른 곳 클릭 시 검색 결과 숨기기
            document.addEventListener('click', function(e) {
                if (!e.target.closest('.search-box')) {
                    searchResultsContainer.style.display = 'none';
                }
            });
        }

        fetchAndRenderOrgChart();
    });
</script>
</body>
</html>