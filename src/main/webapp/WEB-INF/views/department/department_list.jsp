<%-- src/main/webapp/WEB-INF/views/department/organization_chart.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <title>조직도</title>
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

        async function fetchAndRenderOrgChart() {
            orgChartTree.innerHTML = '<p>조직도 데이터를 백엔드에서 불러오는 중...</p>';

            try {
                const response = await fetch('/api/v1/dept/tree');

                if (!response.ok) {
                    throw new Error(`HTTP 요청 실패! 상태코드: \${response.status}`);
                }

                const departmentTreeData = await response.json();
                console.log('조직도 데이터 로드 완료:', departmentTreeData);

                orgChartTree.innerHTML = '';

                renderDepartmentTree(departmentTreeData, orgChartTree);
                setupEventListeners();

            } catch (error) {
                console.error('조직도 데이터를 불러오는 중 오류 발생:', error);
                orgChartTree.innerHTML = `<p style="color:red;">조직도 데이터를 불러오는 데 실패했습니다. 오류: \${error.message}</p>`;
            }
        }

        function renderDepartmentTree(departments, parentElement) {
            if (!departments || departments.length === 0) {
                return;
            }

            const ul = document.createElement('ul');
            if (parentElement.id !== 'orgChartTree') {
                ul.className = 'dept-list child-dept-list';
            } else {
                ul.className = 'dept-list';
            }

            departments.forEach(department => {
                const currentIndentLevel = (department.level != null) ? department.level - 1 : 0;

                const li = document.createElement('li');
                li.className = `dept-item indent-level-\${currentIndentLevel}`;

                const deptNameContainer = document.createElement('span');
                deptNameContainer.className = `department-name department-level-\${currentIndentLevel}`;

                const toggleIcon = document.createElement('span');
                toggleIcon.className = 'toggle-icon';
                if (department.users && department.users.length > 0) {
                    toggleIcon.textContent = '▶';
                } else {
                    toggleIcon.textContent = '';
                }
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
                li.appendChild(userListUl);

                if (department.children && department.children.length > 0) {
                    renderDepartmentTree(department.children, li);
                }

                ul.appendChild(li);
            });
            parentElement.appendChild(ul);
        }

        function setupEventListeners() {
            console.log("이벤트 리스너 설정 시작...");
            document.querySelectorAll('.department-name').forEach(deptNameElement => {
                deptNameElement.addEventListener('click', function(event) {
                    const deptItem = deptNameElement.closest('.dept-item');
                    if (!deptItem) {
                        console.warn("deptItem을 찾을 수 없습니다.");
                        return;
                    }

                    const userList = deptItem.querySelector('.user-list');
                    const toggleIcon = deptNameElement.querySelector('.toggle-icon');

                    if (userList && toggleIcon && toggleIcon.textContent === '▶') {
                        if (userList.classList.contains('expanded-users')) {
                            userList.classList.remove('expanded-users');
                            toggleIcon.style.transform = 'rotate(0deg)';
                            console.log("사용자 접기:", deptNameElement.textContent.trim());
                        } else {
                            userList.classList.add('expanded-users');
                            toggleIcon.style.transform = 'rotate(90deg)';
                            console.log("사용자 펼치기:", deptNameElement.textContent.trim());
                        }
                    } else if (userList) {
                        console.log("부서 클릭: 해당 부서에 사용자가 없어 토글 기능이 없습니다.", deptNameElement.textContent.trim());
                    }
                });
            });
            console.log("이벤트 리스너 설정 완료.");
        }

        fetchAndRenderOrgChart();
    });
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>