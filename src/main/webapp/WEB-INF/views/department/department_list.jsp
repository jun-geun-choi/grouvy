<%-- src/main/webapp/WEB-INF/views/department/organization_chart.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>AJAX 조직도</title>
    <style>
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
        .org-chart-tree {
            max-height: 550px;
            overflow-y: auto;
            padding-right: 15px;
        }

        /* 조직도 요소 스타일 */
        .dept-list {
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
            cursor: pointer; /* 부서명 클릭 가능하도록 */
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
        /* 펼쳐진 상태의 아이콘 */
        .department-name.expanded .toggle-icon {
            transform: rotate(90deg);
        }
        /* 사용자 리스트 스타일 */
        .user-list {
            list-style: none; /* 동그란 점 제거 */
            padding: 0;      /* 기본 패딩 제거 */
            margin-left: 20px;
            display: none; /* 초기에는 숨김 */
        }
        /* 사용자 리스트가 펼쳐졌을 때 */
        .user-list.expanded-users {
            display: block;
        }
        /* 자식 부서 리스트는 항상 표시 */
        .dept-list.child-dept-list { /* 자식 부서 ul에 붙는 클래스 */
            margin-left: 20px;
            /* display는 기본적으로 block이므로 명시하지 않아도 됨 */
        }
        .user-item { /* 사용자 개별 항목 스타일 */
            font-size: 0.9em;
            color: #555;
            margin-bottom: 2px;
            padding: 3px 0;
        }

        /* 들여쓰기 레벨 (0부터 시작) */
        .indent-level-0 { margin-left: 0px; }
        .indent-level-1 { margin-left: 20px; }
        .indent-level-2 { margin-left: 40px; }
        .indent-level-3 { margin-left: 60px; }
        .indent-level-4 { margin-left: 80px; }
    </style>
</head>
<body>
<div class="main-container">
    <h2>조직도</h2>

    <div class="org-chart-tree" id="orgChartTree">
        <p>조직도 데이터를 불러오는 중...</p>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        console.log("AJAX 조직도 페이지 로드 완료!");

        const orgChartTree = document.getElementById('orgChartTree');

        // 조직도 데이터를 백엔드에서 불러와 렌더링하는 함수
        async function fetchAndRenderOrgChart() {
            orgChartTree.innerHTML = '<p>조직도 데이터를 백엔드에서 불러오는 중...</p>';

            try {
                // API 경로가 /api/v1/departments/tree 인지 /api/v1/dept/tree 인지 확인해주세요.
                // 여기서는 /api/v1/departments/tree 로 가정합니다.
                const response = await fetch('/api/v1/dept/tree');

                if (!response.ok) {
                    throw new Error(`HTTP 요청 실패! 상태코드: \${response.status}`);
                }

                const departmentTreeData = await response.json();
                console.log('조직도 데이터 로드 완료:', departmentTreeData);

                orgChartTree.innerHTML = ''; // 로딩 메시지 제거

                // 재귀적으로 부서 트리를 렌더링 시작.
                // departmentTreeData는 최상위 부서들의 리스트이고, parentElement는 렌더링될 부모 DOM 요소입니다.
                renderDepartmentTree(departmentTreeData, orgChartTree);

                // 부서명 클릭 이벤트 리스너 설정 (DOM이 다 그려진 후)
                setupEventListeners();

            } catch (error) {
                console.error('조직도 데이터를 불러오는 중 오류 발생:', error);
                orgChartTree.innerHTML = `<p style="color:red;">조직도 데이터를 불러오는 데 실패했습니다. 오류: \${error.message}</p>`;
            }
        }

        // 재귀적으로 부서 트리를 렌더링하는 함수
        // department.level (백엔드에서 1부터 시작)을 프론트엔드 들여쓰기 level (0부터 시작)에 맞춤.
        function renderDepartmentTree(departments, parentElement) {
            if (!departments || departments.length === 0) {
                return; // 부서 배열이 없거나 비어있으면 렌더링 중단
            }

            const ul = document.createElement('ul');
            // 자식 부서 목록일 경우, 'child-dept-list' 클래스 추가
            // 최상위 목록은 이 조건에 해당하지 않음 (parentElement가 orgChartTree 일 때)
            if (parentElement.id !== 'orgChartTree') { // 부모 요소가 orgChartTree가 아니면 (즉, 자식 부서 목록이면)
                ul.className = 'dept-list child-dept-list';
            } else {
                ul.className = 'dept-list'; // 최상위 목록
            }

            departments.forEach(department => {
                // 백엔드에서 받은 department.level (1부터 시작)을 CSS indent-level-X (0부터 시작)에 맞게 조정
                const currentIndentLevel = (department.level != null) ? department.level - 1 : 0;

                const li = document.createElement('li');
                li.className = `dept-item indent-level-\${currentIndentLevel}`; // 들여쓰기 클래스 적용

                const deptNameContainer = document.createElement('span');
                deptNameContainer.className = `department-name department-level-\${currentIndentLevel}`; // 부서명 컨테이너

                const toggleIcon = document.createElement('span');
                toggleIcon.className = 'toggle-icon';
                // 해당 부서에 사용자가 존재할 때만 토글 아이콘 표시
                if (department.users && department.users.length > 0) {
                    toggleIcon.textContent = '▶'; // 펼치기 아이콘
                } else {
                    toggleIcon.textContent = ''; // 사용자가 없으면 아이콘 표시 안 함
                }
                deptNameContainer.appendChild(toggleIcon);

                const deptText = document.createTextNode(String(department.departmentName || '부서명 없음'));
                deptNameContainer.appendChild(deptText);
                li.appendChild(deptNameContainer);

                // 사용자 리스트 렌더링 (ul.user-list는 초기 display: none;)
                const userListUl = document.createElement('ul');
                userListUl.className = 'user-list';

                if (department.users && department.users.length > 0) {
                    department.users.forEach(user => {
                        // 유효성 검사 (사용자 ID나 이름이 없는 경우)
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
                        userLi.textContent = `\${String(user.name || '이름없음')} (\${String(user.position.positionName || '직책없음')})`;
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
                li.appendChild(userListUl); // 사용자 리스트를 부서 li에 직접 추가

                // 자식 부서 리스트 렌더링 (재귀 호출)
                // 자식 부서는 항상 표시되므로, 별도의 래퍼 없이 li에 직접 추가
                if (department.children && department.children.length > 0) {
                    renderDepartmentTree(department.children, li); // 자식 부서는 항상 보이도록 li에 직접 추가
                }

                ul.appendChild(li); // 완성된 li를 현재 ul에 추가
            });
            parentElement.appendChild(ul); // 완성된 ul을 부모 요소에 추가
        }

        // 이벤트 리스너 설정 함수
        function setupEventListeners() {
            console.log("이벤트 리스너 설정 시작...");
            // 모든 .department-name 요소에 클릭 이벤트 리스너 추가
            document.querySelectorAll('.department-name').forEach(deptNameElement => {
                deptNameElement.addEventListener('click', function(event) {
                    const deptItem = deptNameElement.closest('.dept-item');
                    if (!deptItem) {
                        console.warn("deptItem을 찾을 수 없습니다.");
                        return;
                    }

                    // 클릭 시 토글 대상은 해당 부서의 'user-list'만
                    const userList = deptItem.querySelector('.user-list');
                    const toggleIcon = deptNameElement.querySelector('.toggle-icon');

                    // 사용자 리스트가 존재하고, 토글 아이콘이 있는 경우에만 토글 기능 수행
                    if (userList && toggleIcon && toggleIcon.textContent === '▶') { // 아이콘이 있을 때만
                        // userList의 'expanded-users' 클래스를 토글하여 표시 상태 변경
                        if (userList.classList.contains('expanded-users')) { // 이미 펼쳐져 있다면 접기
                            userList.classList.remove('expanded-users');
                            toggleIcon.style.transform = 'rotate(0deg)'; // 아이콘 회전 원상복귀
                            console.log("사용자 접기:", deptNameElement.textContent.trim());
                        } else { // 접혀 있다면 펼치기
                            userList.classList.add('expanded-users');
                            toggleIcon.style.transform = 'rotate(90deg)'; // 아이콘 90도 회전
                            console.log("사용자 펼치기:", deptNameElement.textContent.trim());
                        }
                    } else if (userList) {
                        // 사용자 리스트는 있지만 토글 아이콘이 없는 경우 (사용자가 없어서 아이콘이 없는 부서)
                        console.log("부서 클릭: 해당 부서에 사용자가 없어 토글 기능이 없습니다.", deptNameElement.textContent.trim());
                    }
                    // userList가 아예 없는 경우 (renderDepartmentTree에서 생성되지 않는 경우)는 무시
                });
            });
            console.log("이벤트 리스너 설정 완료.");
        }

        // 페이지 로드 시 조직도 데이터 불러오기 및 렌더링 시작
        fetchAndRenderOrgChart();
    });
</script>
</body>
</html>