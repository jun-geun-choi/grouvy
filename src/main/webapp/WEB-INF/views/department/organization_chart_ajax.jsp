<%-- src/main/webapp/WEB-INF/views/department/organization_chart_ajax.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>AJAX 조직도</title>
    <style>
        /* (스타일은 동일) */
        body {
            font-family: 'Malgun Gothic', '맑은 고딕', sans-serif;
            margin: 0;
            background-color: #f5f5f5;
            color: #333;
        }
        * {
            box-sizing: border-box;
        }
        .main-container {
            padding: 20px;
            max-width: 800px;
            margin: 20px auto;
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            min-height: 500px;
        }
        h2 {
            margin-top: 0;
            margin-bottom: 20px;
            color: #2c3e50;
            font-size: 1.5em;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }
        .selected-user-info {
            background-color: #e0f2f7;
            border: 1px solid #b3e5fc;
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 5px;
            font-size: 0.95em;
            color: #01579b;
        }
        .org-chart-tree {
            max-height: 550px;
            overflow-y: auto;
            padding-right: 15px;
        }

        /* 조직도 요소 스타일 */
        .dept-list, .user-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .dept-item {
            margin-bottom: 3px;
        }
        .department-name {
            font-weight: bold;
            color: #333;
            cursor: pointer;
            padding: 5px 0;
            display: block;
        }
        .department-name:hover {
            background-color: #f0f0f0;
        }
        .toggle-icon {
            display: inline-block;
            transition: transform 0.2s ease-in-out;
            margin-right: 5px;
            color: #555;
            font-size: 0.8em;
        }
        .department-name.expanded .toggle-icon {
            transform: rotate(90deg);
        }
        .user-list {
            margin-left: 20px;
            display: none; /* 초기에는 숨김 */
        }
        .user-item {
            font-size: 0.9em;
            color: #555;
            margin-bottom: 2px;
            padding: 3px 0;
        }
        .user-item a {
            cursor: pointer;
            text-decoration: none;
            color: #007bff;
        }
        .user-item a:hover {
            text-decoration: underline;
        }
        /* 들여쓰기 레벨 */
        .indent-level-0 { margin-left: 0px; }
        .indent-level-1 { margin-left: 20px; }
        .indent-level-2 { margin-left: 40px; }
        .indent-level-3 { margin-left: 60px; }
        .indent-level-4 { margin-left: 80px; }
    </style>
</head>
<body>
<c:import url="/WEB-INF/views/common/top.jsp" />
<div class="main-container">
    <h2>AJAX로 만든 조직도</h2>
    <div id="selectedUserInfoPanel">
        <%-- 이 부분은 JSTL/EL이므로 \는 없습니다. --%>
        <c:if test="${not empty sessionScope.selectedUser}">
            <div class="selected-user-info">
                <strong>세션에 저장된 사용자:</strong><br>
                ID: ${String(sessionScope.selectedUser.userId)} / 이름: ${String(sessionScope.selectedUser.name)} / 직위: ${String(sessionScope.selectedUser.positionName)} / 이메일: ${String(sessionScope.selectedUser.email)}
                <button onclick="clearSelectedUser()">선택 사용자 해제</button>
            </div>
        </c:if>
        <c:if test="${empty sessionScope.selectedUser}">
            <div class="selected-user-info">
                <strong>세션에 저장된 사용자 없음</strong><br>
                조직도에서 사용자를 클릭해서 세션에 저장해 보세요.
            </div>
        </c:if>
    </div>

    <div class="org-chart-tree" id="orgChartTree">
        <p>조직도 데이터를 불러오는 중...</p>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        console.log("AJAX 조직도 페이지 로드 완료!");

        const orgChartTree = document.getElementById('orgChartTree');
        const selectedUserInfoPanel = document.getElementById('selectedUserInfoPanel');

        async function fetchAndRenderOrgChart() {
            orgChartTree.innerHTML = '<p>조직도 데이터를 백엔드에서 불러오는 중...</p>';

            try {
                const response = await fetch('/api/v1/departments/tree');

                if (!response.ok) {
                    throw new Error(`HTTP 요청 실패! 상태코드: \${response.status}`);
                }

                const departmentTreeData = await response.json();
                console.log('조직도 데이터 로드 완료:', departmentTreeData);

                orgChartTree.innerHTML = ''; // 로딩 메시지 제거

                renderDepartmentTree(departmentTreeData, orgChartTree, 0);

                // setupEventListeners() 호출 활성화
                setupEventListeners();

            } catch (error) {
                console.error('조직도 데이터를 불러오는 중 오류 발생:', error);
                orgChartTree.innerHTML = `<p style="color:red;">조직도 데이터를 불러오는 데 실패했습니다. 오류: \${error.message}</p>`;
            }
        }

        function renderDepartmentTree(departments, parentElement, level) {
            if (!departments || departments.length ===0) {
                return;
            }

            const ul = document.createElement('ul');
            ul.className = 'dept-list';

            departments.forEach(department => {
                const li = document.createElement('li');
                li.className = `dept-item indent-level-\${level}`; // \${} 유지

                const deptNameContainer = document.createElement('span');
                deptNameContainer.className = `department-name department-level-\${level}`; // \${} 유지

                const toggleIcon = document.createElement('span');
                toggleIcon.className = 'toggle-icon';
                toggleIcon.textContent = '▶';
                deptNameContainer.appendChild(toggleIcon);

                const deptText = document.createTextNode(String(department.departmentName || '부서명 없음'));
                deptNameContainer.appendChild(deptText);
                li.appendChild(deptNameContainer);

                const userListUl = document.createElement('ul');
                userListUl.className = 'user-list';

                if (department.users && department.users.length > 0) {
                    department.users.forEach(user => {
                        if (!user || (!user.userId && !user.name)) {
                            const userLi = document.createElement('li');
                            userLi.className = 'user-item';
                            userLi.style.fontStyle = 'italic';
                            userLi.style.color = '#888';
                            userLi.textContent = '유효하지 않은 사용자 데이터';
                            userListUl.appendChild(userLi);
                            return;
                        }

                        const userLi = document.createElement('li');
                        userLi.className = 'user-item';

                        const userLink = document.createElement('a');
                        userLink.className = 'select-user-link';
                        userLink.href = '#';
                        userLink.setAttribute('data-user-id', String(user.userId || ''));

                        userLink.textContent = String(user.name || '이름없음');
                        userLi.appendChild(userLink);

                        userLi.appendChild(document.createTextNode(` (\${String(user.positionName || '직책없음')})`)); // \${} 유지
                        userListUl.appendChild(userLi);
                    });
                } else {
                    const noUserLi = document.createElement('li');
                    noUserLi.className = 'user-item';
                    noUserLi.style.fontStyle = 'italic';
                    noUserLi.style.color = '#888';
                    noUserLi.textContent = '소속된 사용자가 없습니다.';
                    userListUl.appendChild(noUserLi);
                }

                li.appendChild(userListUl);

                if (department.children && department.children.length > 0) {
                    renderDepartmentTree(department.children, li, level + 1);
                }
                ul.appendChild(li);
            });
            parentElement.appendChild(ul);
        }

        // 함수 이름 오타 수정 완료: setupEventListners -> setupEventListeners
        function setupEventListeners() {
            console.log("이벤트 리스너 설정 시작...");
            document.querySelectorAll('.department-name').forEach(deptNameElement => {
                deptNameElement.addEventListener('click',function (event) {
                    const deptItem = deptNameElement.closest('.dept-item');
                    if (!deptItem) {
                        console.warn("deptItem을 찾을 수 없습니다.");
                        return;
                    }

                    const userList = deptItem.querySelector('.user-list');
                    const toggleIcon = deptNameElement.querySelector('.toggle-icon');

                    if (userList && toggleIcon) {
                        if (userList.style.display === 'block') {
                            userList.style.display = 'none';
                            deptNameElement.classList.remove('expanded');
                            toggleIcon.style.transform = 'rotate(0deg)'; // 오타 'Odeg' -> '0deg' 수정
                            console.log("부서 접기:",deptNameElement.textContent);
                        } else {
                            userList.style.display = 'block';
                            deptNameElement.classList.add('expanded');
                            toggleIcon.style.transform = 'rotate(90deg)';
                            console.log("부서 펼치기:", deptNameElement.textContent);
                        }
                    } else {
                        console.warn("userList 또는 toggleIcon을 찾을 수 없습니다. (부서명 클릭)");
                    }
                });
            });

            document.querySelectorAll('.select-user-link').forEach(userLinkElement => {
                userLinkElement.addEventListener('click', async function(event) {
                    event.preventDefault();

                    const clickedUserId = this.getAttribute('data-user-id');
                    const userName = this.textContent;

                    if (clickedUserId) {
                        console.log(`사용자 클릭됨: \${userName} (ID: \${clickedUserId})`); // \${} 유지
                        await selectUserAndRefreshSession(clickedUserId);
                    } else {
                        console.warn("사용자 ID를 찾을 수 없습니다. (사용자 링크 클릭)");
                    }
                });
            });
            console.log("이벤트 리스너 설정 완료.");
        }

        function updateSelectedUserInfo(user) {
            let htmlContent = '';
            if (user && user.userId) { // user 객체가 유효하면
                htmlContent = `
                    <div class="selected-user-info">
                        <strong>세션에 저장된 사용자:</strong><br>
                        ID: \${String(user.userId || '')} / 이름: \${String(user.name || '이름없음')} / 직위: \${String(user.positionName || '직책없음')} / 이메일: \${String(user.email || '')}
                        <button onclick="clearSelectedUser()">선택 사용자 해제</button>
                    </div>
                `; // \${} 유지
            } else { // user 객체가 유효하지 않으면 (선택 해제 등)
                htmlContent = `
                    <div class="selected-user-info">
                        <strong>세션에 저장된 사용자 없음</strong><br>
                        조직도에서 사용자를 클릭해서 세션에 저장해 보세요.
                    </div>
                `;
            }
            selectedUserInfoPanel.innerHTML = htmlContent;
            console.log("세션 정보 패널 업데이트 완료.");
        }

        async function selectUserAndRefreshSession(userId) {
            try {
                console.log(`사용자 ID \${userId}를 세션에 저장 요청...`); // \${} 유지
                // 백엔드의 DepartmentRestController에 추가된 /api/v1/users/select 엔드포인트 호출
                const response = await fetch(`/api/v1/users/select?userId=\${userId}`, { // \${} 유지
                    method: 'GET',
                    headers: { 'Content-Type': 'application/json' }
                });

                if (!response.ok) {
                    throw new Error(`Failed to select user: \${response.status}`); // \${} 유지
                }

                const updatedUser = await response.json();
                console.log("사용자 세션 저장 성공:", updatedUser);

                updateSelectedUserInfo(updatedUser);

            } catch (error) {
                console.error("사용자 세션 저장 중 오류 발생:", error);
                alert("사용자 선택 및 세션 저장에 실패했습니다. 백엔드 API를 확인하세요.");
            }
        }

        fetchAndRenderOrgChart();

        window.clearSelectedUser = async function() {
            if (!confirm('선택된 사용자를 세션에서 제거하시겠습니까?')) {
                return;
            }
            try {
                console.log("세션 사용자 해제 요청...");
                const response = await fetch('/api/v1/users/clearSelected', {
                    method: 'GET'
                });
                if (!response.ok) {
                    throw new Error(`Failed to clear selected user: \${response.status}`); // \${} 유지
                }
                console.log("세션 사용자 해제 성공");
                updateSelectedUserInfo(null);
            } catch (error) {
                console.error("세션 사용자 해제 중 오류 발생:", error);
                alert("세션 사용자 해제에 실패했습니다. 백엔드 API를 확인하세요.");
            }
        };
    });
</script>
</body>
</html>