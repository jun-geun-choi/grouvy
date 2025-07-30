<%-- src/main/webapp/WEB-INF/views/admin/department/admin_department_list.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<html>
<head>
    <title>부서 관리</title>
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
            rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <c:url var="homeCss" value="/resources/css/user/home.css"/>
    <link href="${homeCss}" rel="stylesheet"/>

    <c:url var="adminCss" value="/resources/css/user/admin_main.css"/>
    <link href="${adminCss}" rel="stylesheet"/>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/department/admin_department.css">

</head>
<body>
    <%@include file="../../common/nav.jsp" %>
<nav class="navbarr">
    <a href="/admin/user/list">인사관리</a>
    <a href="#">전자결재</a>
    <a href="#">업무관리</a>
    <a href="#">업무문서함</a>
    <a href="${pageContext.request.contextPath}/admin/dept/list">조직도</a>
</nav>
<div class="container">
    <div class="sidebar">
        <h3>관리 기능</h3>
        <ul>
            <li><a href="/admin" class="${currentPage == 'adminHome' ? 'active' : ''}">대시보드</a></li>
            <li><a href="/admin/dept/list" class="${currentPage == 'departmentList' ? 'active' : ''}">부서 관리</a></li>
            <li><a href="/admin/dept/history" class="${currentPage == 'departmentHistory' ? 'active' : ''}">부서 이력</a>
            </li>
        </ul>
    </div>
    <div class="main-content">
        <h2>부서 관리</h2>

        <div id="serverMessageArea"></div>

        <div class="d-flex justify-content-end mb-3">
            <a href="/admin/dept/form" class="btn btn-primary">새 부서 생성</a>
        </div>

        <div id="departmentListTable" class="table-responsive">
            <p>부서 목록을 불러오는 중...</p>
        </div>
    </div>
</div>
<%@include file="../../common/footer.jsp" %>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const departmentListTable = document.getElementById('departmentListTable')
        const serverMessageArea = document.getElementById('serverMessageArea');

        async function fetchAndRenderDepartments() {
            departmentListTable.innerHTML = '<p>로딩중...</p>';
            try {
                const response = await fetch('/api/v1/dept/list');
                if (!response.ok) {
                    throw new Error(`HTTP error! status: \${response.status}`);
                }
                const departments = await response.json();
                console.log('부서 목록 데이터: ', departments);

                renderDepartmentTable(departments);
                attachTableEventListeners();
            } catch (error) {
                console.error('부서 목록을 불러오는 중 오류 발생: ', error);
                departmentListTable.innerHTML = `<p class="alert alert-danger">부서 목록을 불러올 수 없습니다. 오류: \${error.message}</p>`;
            }
        }

        function renderDepartmentTable(departments) {
            if (!departments || departments.length === 0) {
                departmentListTable.innerHTML = '<p class="text-center text-muted">등록된 부서가 없습니다.</p>';
                return;
            }
            let tableHtml = `
                    <table class="table table-bordered table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>부서명</th>
                                    <th>상위 부서 ID</th>
                                    <th>정렬 순서</th>
                                    <th>등록일</th>
                                    <th>수정일</th>
                                    <th>삭제 여부</th>
                                    <th>액션</th>
                                </tr>
                            </thead>
                            <tbody>
                    `;
            departments.forEach(dept => {
                const createdDate = dept.createdDate ? new Date(dept.createdDate).toISOString().split('T')[0] : '-';
                const updatedDate = dept.updatedDate ? new Date(dept.updatedDate).toISOString().split('T')[0] : '-';

                tableHtml += `
                            <tr>
                                <td>\${dept.departmentId}</td>
                                <td>\${dept.departmentName}</td>
                                <td>\${dept.parentDepartmentId || '최상위 부서'}</td>
                                <td>\${dept.departmentOrder}</td>
                                <td>\${createdDate}</td>
                                <td>\${updatedDate}</td>
                                <td>\${dept.isDeleted}</td>
                                <td>
                                    <a href="/admin/dept/update/\${dept.departmentId}" class="btn btn-info btn-sm me-1">수정</a>
                                    <button type="button" class="btn btn-danger btn-sm delete-dept-btn" data-dept-id="\${dept.departmentId}">삭제</button>
                                    <a href="/admin/dept/history/\${dept.departmentId}" class="btn btn-secondary btn-sm ms-1">이력</a>
                                </td>
                            </tr>
                    `;
            });
            tableHtml += '</tbody></table>';
            departmentListTable.innerHTML = tableHtml;

        }

        function attachTableEventListeners() {
            document.querySelectorAll('.delete-dept-btn').forEach(button => {
                button.addEventListener('click', async function () {
                    const departmentId = this.dataset.deptId;
                    if (!confirm(`정말 ID \${departmentId} 부서를 삭제하시겠습니까? 하위 부서나 소속 직원이 있는 경우 삭제할 수 없습니다.`)) {
                        return;
                    }

                    try {
                        const response = await fetch(`/api/v1/dept/\${departmentId}`, {
                            method: 'DELETE',
                        });
                        const result = await response.json();

                        if (response.ok) {
                            displayClientMessage(result.message, 'info');
                            fetchAndRenderDepartments();
                        } else {
                            displayClientMessage(result.message || '부서 삭제 실패!', 'danger');
                        }
                    } catch (error) {
                        console.error('부서 삭제 중 오류:', error);
                        displayClientMessage('부서 삭제 중 네트워크 오류.', 'danger');
                    }
                });
            });
        }

        function displayClientMessage(message, type) {
            if (!serverMessageArea) {
                console.error('serverMessageArea 엘리먼트를 찾을 수 없습니다.');
                return;
            }
            const tempMessageDiv = document.createElement('div');
            tempMessageDiv.innerHTML = `<p class="alert alert-\${type} text-center">\${message}</p>`;
            serverMessageArea.prepend(tempMessageDiv);

            setTimeout(() => {
                tempMessageDiv.remove();
            }, 5000);
        }

        fetchAndRenderDepartments();
    });

</script>
</body>
</html>