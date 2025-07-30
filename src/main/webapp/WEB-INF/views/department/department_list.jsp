<%-- src/main/webapp/WEB-INF/views/department/organization_chart.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${formTitle}</title>

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/department/department.css">
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
            rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <c:url var="homeCss" value="/resources/css/user/home.css"/>
    <link href="${homeCss}" rel="stylesheet"/>
</head>
<body>
<%@include file="../common/nav.jsp" %>
<div class="main-container">
    <h2>조직도</h2>

    <div class="org-chart-tree" id="orgChartTree">
        <p>조직도 데이터를 불러오는 중...</p>
    </div>
</div>
<%@include file="../common/footer.jsp" %>
<script>
    document.addEventListener('DOMContentLoaded', function () {
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
                deptNameElement.addEventListener('click', function (event) {
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
</body>
</html>