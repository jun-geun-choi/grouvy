<%-- src/main/webapp/WEB-INF/views/admin/department/department_form.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title><c:out value="${formTitle}"/></title>
    <%-- admin_top.jsp에서 CSS를 가져오므로 여기서는 공통 CSS 제거 --%>
</head>
<body>
<%-- currentPage 변수를 설정하여 사이드바에서 현재 페이지를 활성화 --%>
<c:set var="currentPage" value="departmentList" scope="request"/>

<%-- admin_top.jsp를 import하여 공통 상단 내비게이션 사용 --%>
<c:import url="/WEB-INF/views/common/admin_top.jsp" />

<div class="container">
    <div class="sidebar">
        <h3>관리 기능</h3>
        <ul>
            <li><a href="/admin" class="${currentPage == 'adminHome' ? 'active' : ''}">대시보드</a></li>
            <li><a href="/admin/departments/list" class="${currentPage == 'departmentList' ? 'active' : ''}">부서 관리</a></li>
            <li><a href="/admin/departments/history" class="${currentPage == 'departmentHistory' ? 'active' : ''}">부서 이력</a></li>
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
            <input type="hidden" id="departmentId" name="departmentId" value="${departmentId}">

            <div class="mb-3">
                <label for="departmentName" class="form-label">부서명:</label>
                <input type="text" id="departmentName" name="departmentName" class="form-control" required placeholder="부서명을 입력하세요">
            </div>
            <div class="mb-3">
                <label for="parentDepartmentId" class="form-label">상위 부서:</label>
                <select id="parentDepartmentId" name="parentDepartmentId" class="form-select">
                    <option value="">-- 최상위 부서 --</option>
                    <!-- JavaScript로 상위 부서 목록이 로드됩니다 -->
                </select>
            </div>
            <div class="mb-3">
                <label for="departmentOrder" class="form-label">정렬 순서:</label>
                <input type="number" id="departmentOrder" name="departmentOrder" class="form-control" value="0" required>
            </div>

            <div class="btn-group" role="group">
                <button type="submit" class="btn btn-primary me-2">
                    <c:if test="${formMode eq 'create'}">생성</c:if>
                    <c:if test="${formMode eq 'update'}">수정</c:if>
                </button>
                <a href="/admin/departments/list" class="btn btn-secondary">목록으로</a>
            </div>
        </form>
    </div>
</div>

<footer>
    <p>© 2025 그룹웨어 Corp.</p>
</footer>
<%-- admin_top.jsp에서 bootstrap.bundle.min.js가 포함되었으므로 여기서는 제거 --%>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const departmentForm = document.getElementById('departmentForm');
        const departmentIdField = document.getElementById('departmentId');
        const departmentNameField = document.getElementById('departmentName');
        const parentDepartmentIdField = document.getElementById('parentDepartmentId');
        const departmentOrderField = document.getElementById('departmentOrder');
        const serverMessageArea = document.getElementById('serverMessageArea');

        const formMode = '${formMode}';
        const currentDepartmentId = departmentIdField.value;

        async function loadParentDepartments() {
            try {
                const response = await fetch('/api/v1/departments/list');
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
                    const response = await fetch(`/api/v1/admin/departments/\${currentDepartmentId}`);
                    if (!response.ok) {
                        if (response.status === 404) {
                            throw new Error('해당 부서를 찾을 수 없습니다.');
                        } else if (response.status === 401) {
                            displayClientMessage('관리자 권한이 없습니다. 발신자를 다시 선택해주세요.', 'danger');
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

        departmentForm.addEventListener('submit', async function(event) {
            event.preventDefault();

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

            let url = '/api/v1/admin/departments';
            let method = 'POST';

            if (formMode === 'update') {
                url += `/\${currentDepartmentId}`;
                method = 'PUT';
                departmentData.departmentId = parseInt(currentDepartmentId);
            }

            try {
                const response = await fetch(url, {
                    method: method,
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(departmentData)
                });
                const result = await response.json();

                if (response.ok) {
                    displayClientMessage(result.message, 'info');
                    setTimeout(() => window.location.href = '/admin/departments/list', 1000);
                } else {
                    displayClientMessage(result.message || (formMode === 'create' ? '부서 생성 실패!' : '부서 수정 실패!'), 'danger');
                }
            } catch (error) {
                console.error('부서 저장 중 오류:', error);
                displayClientMessage('부서 저장 중 네트워크 오류.', 'danger');
            }
        });

        function displayClientMessage(message, type) {
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