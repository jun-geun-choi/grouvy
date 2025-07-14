<%-- src/main/webapp/WEB-INF/views/department/organization_chart_final_style_integrated.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>조직도</title>
    <style>
        /* 님께서 주신 organization_chart.jsp의 스타일을 기반으로 통합 */
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
        }

        .panel {
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            padding: 25px;
            min-height: 500px;
            display: flex;
            flex-direction: column;
        }

        .panel h2 {
            margin-top: 0;
            margin-bottom: 20px;
            color: #2c3e50;
            font-size: 1.5em;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }

        .org-chart-tree {
            max-height: 550px;
            overflow-y: scroll;
            flex-grow: 1;
            padding-right: 15px; /* 스크롤바 때문에 내용이 가려지는 것 방지 */
        }

        /* UL/LI 기본 스타일 (님 원본과 유사하게) */
        .dept-list, .user-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .dept-item {
            margin-bottom: 3px;
        }

        /* 들여쓰기 클래스 (JavaScript에서 level에 따라 동적으로 추가) */
        .indent-level-0 { margin-left: 0px; }
        .indent-level-1 { margin-left: 20px; }
        .indent-level-2 { margin-left: 40px; }
        .indent-level-3 { margin-left: 60px; }
        .indent-level-4 { margin-left: 80px; }

        /* 부서명 스타일 (토글 아이콘 포함한 클릭 영역) */
        .department-name { /* 스크립틀릿 버전의 .dept-name과 동일한 역할 */
            font-weight: bold;
            color: #333;
            cursor: pointer;
            padding: 5px 0;
            display: block; /* 스크립틀릿과 동일하게 block */
            /* width: fit-content; 스크립틀릿에 없으므로 제거 */
        }
        .department-name:hover {
            background-color: #f9f9f9;
            /* border-radius: 4px; 스크립틀릿에 없으므로 제거 */
        }

        /* 토글 아이콘 스타일 */
        .toggle-icon { /* 스크립틀릿 버전의 .toggle-icon과 동일 */
            display: inline-block;
            transition: transform 0.2s ease-in-out;
            margin-right: 5px;
            color: #555;
            font-size: 0.8em;
        }
        .department-name.expanded .toggle-icon { /* 펼쳐졌을 때 아이콘 회전 */
            transform: rotate(90deg);
        }

        /* 사용자 목록 스타일 (기본 숨김) */
        .user-list { /* 스크립틀릿 버전의 .user-list와 동일 */
            list-style: none;
            margin-left: 20px; /* 사용자 목록 들여쓰기 */
            padding-left: 0;
            display: none; /* 초기에는 숨김 */
        }
        /* .user-list.open { display: block; } // 스크립틀릿은 style.display 직접 제어 */

        /* 개별 사용자 항목 스타일 */
        .user-item { /* 스크립틀릿 버전의 .user-item과 동일 */
            font-size: 0.9em;
            color: #555;
            margin-bottom: 2px;
            padding: 3px 0;
        }
        .user-item a { /* 사용자 이름 링크 스타일 */
            cursor: pointer;
            text-decoration: none;
            color: #007bff;
            /* font-weight: normal; 스크립틀릿에 없으므로 제거 */
        }
        .user-item a:hover {
            text-decoration: underline;
            /* color: #e05624; 스크립틀릿에 없으므로 제거 */
        }

        /* 세션 사용자 정보 패널 (기존 스타일 유지) */
        .selected-user-info {
            background-color: #e0f2f7;
            border: 1px solid #b3e5fc;
            padding: 10px;
            margin-top: 20px;
            border-radius: 5px;
            font-size: 0.95em;
            color: #01579b;
        }
        footer {
            text-align: center;
            padding: 20px;
            color: #777;
            font-size: 0.9em;
            margin-top: 30px;
        }
    </style>
</head>
<body>
<c:import url="/WEB-INF/views/common/top.jsp" />

<div class="main-container">
    <div class="panel org-chart-panel">
        <h2 style="font-family:'Segoe UI', 'Malgun Gothic', Arial,sans-serif; font-size:1.2em;">조직도</h2>

        <%-- 세션에 저장된 사용자 정보 표시 (JSTL/EL 사용) --%>
        <div id="selectedUserInfoPanel">
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
        <br>

        <div class="org-chart-tree" id="orgChartTree">
            <p>조직도 데이터를 불러오는 중...</p>
        </div>
    </div>
</div>

<footer>
    <p>© 2025 그룹웨어 Corp.</p>
</footer>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const orgChartTree = document.getElementById('orgChartTree');
        const selectedUserInfoPanel = document.getElementById('selectedUserInfoPanel');

        // 사용자 선택 정보를 서버에 비동기(Ajax)로 전송하고, 세션 정보를 업데이트하는 함수
        async function selectUserAndRefreshSession(userId) {
            try {
                // 백엔드의 DepartmentRestController에 추가된 /api/v1/users/select 엔드포인트 호출
                const response = await fetch(`/api/v1/users/select?userId=\${userId}`, { // \${} 사용
                    method: 'GET',
                    headers: { 'Content-Type': 'application/json' }
                });

                if (!response.ok) {
                    throw new Error(`Failed to select user: \${response.status}`); // \${} 사용
                }

                const updatedUser = await response.json(); // 서버에서 업데이트된 사용자 정보(User VO/DTO)를 받음
                console.log("사용자 세션 저장 성공:", updatedUser);
                // 세션 정보 패널 UI 업데이트 (JavaScript로 동적 변경)
                updateSelectedUserInfo(updatedUser);

            } catch (error) {
                console.error("사용자 세션 저장 중 오류 발생:", error);
                alert("사용자 선택 및 세션 저장에 실패했습니다. 백엔드 API를 확인하세요.");
            }
        }

        // 선택된 사용자 정보 패널 UI를 업데이트하는 함수
        function updateSelectedUserInfo(user) {
            let htmlContent = '';
            if (user && user.userId) { // user 객체가 유효하면
                htmlContent = `
                    <div class="selected-user-info">
                        <strong>세션에 저장된 사용자:</strong><br>
                        ID: \${String(user.userId || '')} / 이름: \${String(user.name || '이름없음')} / 직위: \${String(user.positionName || '직책없음')} / 이메일: \${String(user.email || '')}
                        <button onclick="clearSelectedUser()">선택 사용자 해제</button>
                    </div>
                `; // \${} 사용
            } else { // user 객체가 유효하지 않으면 (선택 해제 등)
                htmlContent = `
                    <div class="selected-user-info">
                        <strong>세션에 저장된 사용자 없음</strong><br>
                        조직도에서 사용자를 클릭해서 세션에 저장해 보세요.
                    </div>
                `;
            }
            selectedUserInfoPanel.innerHTML = htmlContent;
        }

        // 조직도 데이터를 가져와 렌더링하는 핵심 함수
        async function fetchAndRenderOrgChart() {
            orgChartTree.innerHTML = '<p>조직도 데이터를 불러오는 중...</p>'; // 로딩 메시지
            try {
                // 백엔드의 DepartmentRestController에 정의된 /api/v1/departments/tree 엔드포인트 호출
                const response = await fetch('/api/v1/departments/tree');
                if (!response.ok) {
                    throw new Error(`HTTP error! status: \${response.status}`); // \${} 사용
                }
                const departmentTreeData = await response.json();
                console.log('조직도 데이터 로드 완료:', departmentTreeData);

                orgChartTree.innerHTML = ''; // "로딩 중..." 메시지 삭제
                renderDepartmentTree(departmentTreeData, orgChartTree, 0); // 조직도 렌더링 시작

                setupEventListeners(); // 모든 DOM 요소 렌더링 후 이벤트 리스너 설정

            } catch (error) {
                console.error('조직도 데이터를 불러오는 중 오류 발생:', error);
                orgChartTree.innerHTML = `<p style="color:red;">조직도 데이터를 불러올 수 없습니다. 오류: \${error.message}</p>`; // \${} 사용
            }
        }

        // 재귀적으로 조직도 HTML을 렌더링하는 함수 (스크립틀릿 버전과 동일한 구조와 스타일)
        function renderDepartmentTree(departments, parentElement, level) {
            if (!departments || departments.length === 0) return;

            const ul = document.createElement('ul');
            ul.className = 'dept-list';

            departments.forEach(department => {
                const li = document.createElement('li');
                li.className = `dept-item indent-level-\${level}`; // \${} 사용

                // 부서명 컨테이너 (클릭 영역: 스크립틀릿의 <span class='department-name'> 에 해당)
                const deptNameContainer = document.createElement('span'); // 스크립틀릿과 동일하게 span 사용
                deptNameContainer.className = `department-name department-level-\${level}`; // \${} 사용
                // 스크립틀릿의 data-target='...'은 JavaScript가 직접 DOM 요소를 찾으므로 필요 없습니다.

                // 토글 아이콘 (▶ 또는 ▼)
                const toggleIcon = document.createElement('span');
                toggleIcon.className = 'toggle-icon'; // 스크립틀릿과 동일한 클래스명
                toggleIcon.textContent = '▶'; // 초기 상태는 '숨김'이므로 아이콘은 '▶' (펼치기)
                deptNameContainer.appendChild(toggleIcon);

                // 부서명 텍스트 노드
                const deptText = document.createTextNode(String(department.departmentName || '부서명 없음'));
                deptNameContainer.appendChild(deptText);

                li.appendChild(deptNameContainer); // li에 부서명 컨테이너 추가

                // 사용자 목록 UL (초기에는 숨김)
                const userListUl = document.createElement('ul');
                userListUl.className = 'user-list';

                if (department.users && department.users.length > 0) {
                    department.users.forEach(user => {
                        // 사용자 객체 유효성 안전 검사
                        if (!user || (!user.userId && !user.name)) { // 최소한 userId나 name은 있어야 유효
                            const userLi = document.createElement('li');
                            userLi.className = 'user-item'; // 스크립틀릿과 동일하게 user-item만 사용
                            userLi.style.fontStyle = 'italic'; // 스크립틀릿과 동일한 inline style
                            userLi.style.color = '#888'; // 스크립틀릿과 동일한 inline style
                            userLi.textContent = '유효하지 않은 사용자 데이터';
                            userListUl.appendChild(userLi);
                            return;
                        }

                        const userLi = document.createElement('li');
                        userLi.className = 'user-item';

                        const userLink = document.createElement('a');
                        userLink.className = 'select-user-link'; // 스크립틀릿과 동일
                        userLink.href = `#`; // 페이지 이동 방지
                        userLink.setAttribute('data-user-id', String(user.userId || ''));

                        // String() 함수를 사용하여 어떤 값이든 문자열로 확실히 변환
                        const userNameText = String(user.name || '이름없음');
                        const userPositionText = String(user.positionName || '직책없음');
                        // const userEmailText = String(user.email || ''); // 스크립틀릿에 이메일 정보는 없었음.

                        // 스크립틀릿과 동일한 형식: <a>이름</a> (직위)
                        userLink.textContent = userNameText; // 링크 텍스트는 이름만
                        userLi.appendChild(userLink);

                        // 직위 추가 (링크 바깥, 스크립틀릿과 동일한 위치)
                        // 스크립틀릿: out.println("<a ...>" + user.getName() + "</a> (" + user.getPositionName() + ")");
                        userLi.appendChild(document.createTextNode(` (\${userPositionText})`)); // \${} 사용

                        // 사용자 이름 클릭 이벤트 (Ajax로 세션 등록)
                        userLink.addEventListener('click', function(event) {
                            event.preventDefault();
                            const clickedUserId = this.getAttribute('data-user-id');
                            if (clickedUserId) {
                                selectUserAndRefreshSession(clickedUserId);
                            }
                        });

                        userListUl.appendChild(userLi);
                    });
                } else {
                    const noUserLi = document.createElement('li');
                    noUserLi.className = 'user-item'; // 스크립틀릿과 동일하게 user-item만 사용
                    noUserLi.style.fontStyle = 'italic'; // 스크립틀릿과 동일한 inline style
                    noUserLi.style.color = '#888'; // 스크립틀릿과 동일한 inline style
                    noUserLi.textContent = '소속된 사용자가 없습니다.';
                    userListUl.appendChild(noUserLi);
                }
                li.appendChild(userListUl); // 사용자 목록을 li에 추가

                // 하위 부서 재귀 호출
                if (department.children && department.children.length > 0) {
                    renderDepartmentTree(department.children, li, level + 1); // 현재 li가 부모가 됨
                }

                ul.appendChild(li); // 현재 레벨의 ul에 li 추가
            });
            parentElement.appendChild(ul); // 완성된 ul을 부모 요소에 추가
        }

        // 모든 이벤트 리스너 설정 함수 (동적으로 생성된 요소에 바인딩)
        function setupEventListeners() {
            // 부서명 클릭 시 사용자 목록 토글 기능
            document.querySelectorAll('.department-name').forEach(deptNameElement => {
                deptNameElement.addEventListener('click', function(event) {
                    event.stopPropagation(); // 중복 클릭 이벤트 방지

                    // 클릭된 .department-name의 부모 .dept-item 찾기
                    const deptItem = deptNameElement.closest('.dept-item');
                    if (!deptItem) return;

                    // .dept-item 내에서 사용자 목록 UL과 토글 아이콘 찾기
                    const userList = deptItem.querySelector('.user-list');
                    const toggleIcon = deptNameElement.querySelector('.toggle-icon'); // .department-name 안의 토글 아이콘

                    if (userList && toggleIcon) {
                        // 스크립틀릿 버전과 동일하게 style.display를 직접 제어
                        if (userList.style.display === 'block') {
                            userList.style.display = 'none';
                            deptNameElement.classList.remove('expanded'); // 'expanded' 클래스 제거
                            if (toggleIcon) toggleIcon.style.transform = 'rotate(0deg)'; // 아이콘 회전 원위치
                        } else {
                            userList.style.display = 'block'; // 현재 사용자 목록 표시
                            deptNameElement.classList.add('expanded'); // 'expanded' 클래스 추가
                            if (toggleIcon) toggleIcon.style.transform = 'rotate(90deg)'; // 아이콘 회전
                        }
                    }
                });
            });
            // 사용자 선택 링크 이벤트 리스너는 renderDepartmentTree 함수 내에서 개별적으로 추가되므로 여기에선 필요 없음
        }

        // 세션에 저장된 사용자 정보 해제 함수 (Ajax 요청)
        // 이 함수는 global scope에 있어야 onclick="clearSelectedUser()" 에서 호출 가능
        window.clearSelectedUser = async function() { // window 객체에 추가
            if (!confirm('선택된 사용자를 세션에서 제거하시겠습니까?')) {
                return;
            }
            try {
                // 백엔드의 DepartmentRestController에 추가된 /api/v1/users/clearSelected 엔드포인트 호출
                const response = await fetch('/api/v1/users/clearSelected', {
                    method: 'GET'
                });
                if (!response.ok) {
                    throw new Error(`Failed to clear selected user: \${response.status}`); // \${} 사용
                }
                console.log("세션 사용자 해제 성공");
                updateSelectedUserInfo(null); // UI 업데이트 (사용자 없음 상태로)
            } catch (error) {
                console.error("세션 사용자 해제 중 오류 발생:", error);
                alert("세션 사용자 해제에 실패했습니다. 백엔드 API를 확인하세요.");
            }
        };

        // 페이지 로드 시 조직도 데이터 불러오기 시작
        fetchAndRenderOrgChart();
    });
</script>
</body>
</html>