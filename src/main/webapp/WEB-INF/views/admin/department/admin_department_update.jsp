<%-- src/main/webapp/WEB-INF/views/admin/department/department_form.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title><c:out value="${formTitle}"/></title>
    <meta charset="UTF-8">
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
            rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <c:url var="homeCss" value="/resources/css/user/home.css"/>
    <link href="${homeCss}" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <c:url var="adminCss" value="/resources/css/user/admin_main.css"/>
    <link href="${adminCss}" rel="stylesheet"/>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/department/admin_department.css">

</head>
<body>
<c:set var="currentPage" value="departmentList" scope="request"/>
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
        <h1><c:out value="${formTitle}"/></h1>

        <div id="serverMessageArea">
            <c:if test="${not empty errorMessage}">
                <p class="alert alert-danger text-center">${errorMessage}</p>
            </c:if>
        </div>

        <form id="departmentForm" class="department-form-container">
            <input type="hidden" id="departmentId" name="departmentId" value="${department.departmentId}">
            <input type="hidden" id="formMode" value="${formMode}"/>

            <div class="mb-3">
                <label for="departmentName" class="form-label">부서명:</label>
                <input type="text" id="departmentName" name="departmentName" class="form-control" required
                       placeholder="부서명을 입력하세요">
            </div>
            <div class="mb-3">
                <label for="parentDepartmentId" class="form-label">상위 부서:</label>
                <select id="parentDepartmentId" name="parentDepartmentId" class="form-select">
                    <option value="">-- 최상위 부서 --</option>
                </select>
            </div>
            <div class="mb-3">
                <label for="departmentOrder" class="form-label">정렬 순서:</label>
                <input type="number" id="departmentOrder" name="departmentOrder" class="form-control" value="0"
                       required>
            </div>

            <div class="btn-group" role="group">
                <button type="submit" class="btn btn-primary me-2">
                    <c:if test="${formMode eq 'create'}">생성</c:if>
                    <c:if test="${formMode eq 'update'}">수정</c:if>
                </button>
                <a href="/admin/dept/list" class="btn btn-secondary">목록으로</a>
            </div>
        </form>
    </div>
</div>
<%@include file="../../common/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const departmentForm = document.getElementById('departmentForm');
        const departmentIdField = document.getElementById('departmentId');
        const departmentNameField = document.getElementById('departmentName');
        const parentDepartmentIdField = document.getElementById('parentDepartmentId');
        const departmentOrderField = document.getElementById('departmentOrder');
        const serverMessageArea = document.getElementById('serverMessageArea');

        const formMode = document.getElementById('formMode') ? document.getElementById('formMode').value : 'create';
        const currentDepartmentId = departmentIdField.value;

        async function loadParentDepartments() {
            try {
                const response = await fetch('/api/v1/dept/list');
                if (!response.ok) throw new Error('상위 부서 목록 로드 실패');
                const departments = await response.json();

                let optionsHtml = '<option value="">-- 최상위 부서 --</option>';
                departments.forEach(dept => {
                    if (formMode === 'update' && dept.departmentId == currentDepartmentId) {
                        return;
                    }
                    optionsHtml += `<option value="\${dept.departmentId}">\${dept.departmentName} (ID: \${dept.departmentId})</option>`;
                });
                parentDepartmentIdField.innerHTML = optionsHtml;

            } catch (error) {
                console.error('상위 부서 목록을 불러오는 중 오류:', error);
                displayClientMessage('상위 부서 목록을 불러올 수 없습니다.', 'danger');
            }
        }

        async function loadDepartmentDataForUpdate() {
            if (formMode === 'update' && currentDepartmentId) {
                try {
                    const response = await fetch(`/api/v1/dept/\${currentDepartmentId}`);
                    if (!response.ok) {
                        if (response.status === 404) {
                            throw new Error('해당 부서를 찾을 수 없습니다.');
                        } else if (response.status === 401) {
                            displayClientMessage('관리자 권한이 없습니다.', 'danger');
                            return;
                        }
                        throw new Error(`HTTP error! status: \${response.status}`);
                    }
                    const department = await response.json();
                    console.log('로드된 부서 데이터:', department);

                    departmentNameField.value = department.departmentName;
                    departmentOrderField.value = department.departmentOrder;

                    if (department.parentDepartmentId) {
                        parentDepartmentIdField.value = department.parentDepartmentId;
                    }

                } catch (error) {
                    console.error('부서 데이터를 불러오는 중 오류:', error);
                    displayClientMessage(`부서 데이터를 불러올 수 없습니다: \${error.message}`, 'danger');
                }
            }
        }

        departmentForm.addEventListener('submit', async function (event) {
            event.preventDefault();

            console.log('Form Mode:', formMode);
            console.log('Current Department ID:', currentDepartmentId);

            const departmentData = {
                departmentName: departmentNameField.value.trim(),
                parentDepartmentId: parentDepartmentIdField.value ? parseInt(parentDepartmentIdField.value) : null,
                departmentOrder: parseInt(departmentOrderField.value),
            };

            if (!departmentData.departmentName) {
                displayClientMessage('부서명을 입력해주세요.', 'danger');
                return;
            }
            if (isNaN(departmentData.departmentOrder)) {
                displayClientMessage('정렬 순서를 숫자로 입력해주세요.', 'danger');
                return;
            }

            let url = '/api/v1/dept';
            let method = 'POST';

            if (formMode === 'update') {
                url += `/\${currentDepartmentId}`;
                method = 'PUT';
                departmentData.departmentId = parseInt(currentDepartmentId);
            }

            console.log('API URL:', url);
            console.log('HTTP Method:', method);
            try {
                const response = await fetch(url, {
                    method: method,
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify(departmentData)
                });
                const result = await response.json();

                if (response.ok) {
                    displayClientMessage(result.message, 'info');
                    setTimeout(() => window.location.href = '/admin/dept/list', 1000);
                } else {
                    displayClientMessage(result.message || (formMode === 'create' ? '부서 생성 실패!' : '부서 수정 실패!'), 'danger');
                }
            } catch (error) {
                console.error('부서 저장 중 오류:', error);
                displayClientMessage('부서 저장 중 네트워크 오류.', 'danger');
            }
        });

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

        loadParentDepartments();
        loadDepartmentDataForUpdate();
    });
</script>
</body>
</html>