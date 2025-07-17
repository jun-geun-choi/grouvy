<%-- src/main/webapp/WEB-INF/views/admin/department/department_history.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>부서 변경 이력</title>
    <%-- admin_top.jsp에서 CSS를 가져오므로 여기서는 공통 CSS 제거 --%>
</head>
<body>
<%-- currentPage 변수를 설정하여 사이드바에서 현재 페이지를 활성화 --%>
<c:set var="currentPage" value="departmentHistory" scope="request"/>

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
        <h1>부서 변경 이력</h1>

        <div id="serverMessageArea">
            <c:if test="${not empty errorMessage}">
                <p class="alert alert-danger text-center">${errorMessage}</p>
            </c:if>
        </div>

        <div class="history-filter-form mb-3 d-flex align-items-center">
            <label for="filterDepartmentId" class="form-label me-2 mb-0">부서 선택:</label>
            <select id="filterDepartmentId" name="departmentId" class="form-select flex-grow-1 me-2">
                <option value="">-- 전체 부서 이력 --</option>
                <!-- JavaScript로 부서 목록이 로드됩니다 -->
            </select>
            <button type="button" id="applyFilterBtn" class="btn btn-secondary">조회</button>
        </div>

        <div id="departmentHistoryTable" class="table-responsive">
            <p>이력 목록을 불러오는 중...</p>
        </div>
    </div>
</div>

<footer>
    <p>© 2025 그룹웨어 Corp.</p>
</footer>
<%-- admin_top.jsp에서 bootstrap.bundle.min.js가 포함되었으므로 여기서는 제거 --%>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const departmentHistoryTable = document.getElementById('departmentHistoryTable');
        const filterDepartmentIdSelect = document.getElementById('filterDepartmentId');
        const applyFilterBtn = document.getElementById('applyFilterBtn');
        const serverMessageArea = document.getElementById('serverMessageArea');

        const initialDepartmentId = '${selectedDepartmentId}';

        async function loadDepartmentsForFilter() {
            try {
                const response = await fetch('/api/v1/departments/list');
                if (!response.ok) throw new Error('부서 목록 로드 실패');
                const departments = await response.json();

                let optionsHtml = '<option value="">-- 전체 부서 이력 --</option>';
                departments.forEach(dept => {
                    optionsHtml += `<option value="\${dept.departmentId}">\${dept.departmentName} (ID: \${dept.departmentId})</option>`;
                });
                filterDepartmentIdSelect.innerHTML = optionsHtml;

                if (initialDepartmentId && initialDepartmentId !== 'null') {
                    filterDepartmentIdSelect.value = initialDepartmentId;
                }

            } catch (error) {
                console.error('부서 목록을 불러오는 중 오류:', error);
                displayClientMessage('부서 목록을 불러올 수 없습니다.', 'danger');
            }
        }

        async function fetchAndRenderHistory(departmentId = null) {
            departmentHistoryTable.innerHTML = '<p>이력 목록을 불러오는 중...</p>';
            let url = '/api/v1/admin/departments/history';
            if (departmentId) {
                url += `/\${departmentId}`;
            }

            try {
                const response = await fetch(url);
                if (!response.ok) {
                    if (response.status === 401) {
                        displayClientMessage('세션이 만료되었거나 관리자 권한이 없습니다. 발신자를 다시 선택해주세요.', 'danger');
                        departmentHistoryTable.innerHTML = '';
                        return;
                    }
                    throw new Error(`HTTP error! status: \${response.status}`);
                }
                const histories = await response.json();
                console.log('부서 이력 데이터:', histories);

                renderHistoryTable(histories);

            } catch (error) {
                console.error('부서 이력 목록을 불러오는 중 오류 발생:', error);
                departmentHistoryTable.innerHTML = `<p class="alert alert-danger">부서 이력 목록을 불러올 수 없습니다. 오류: \${error.message}</p>`;
            }
        }

        function renderHistoryTable(histories) {
            if (!histories || histories.length === 0) {
                departmentHistoryTable.innerHTML = '<p class="text-center text-muted">변경 이력이 없습니다.</p>';
                return;
            }

            let tableHtml = `
                <table class="table table-bordered table-hover">
                    <thead>
                        <tr>
                            <th>이력 ID</th>
                            <th>부서명 (ID)</th>
                            <th>변경 타입</th>
                            <th>이전 값</th>
                            <th>새 값</th>
                            <th>변경자 (ID)</th>
                            <th>변경 일시</th>
                        </tr>
                    </thead>
                    <tbody>
            `;

            histories.forEach(history => {
                const changeDate = history.changeDate ? new Date(history.changeDate).toLocaleString('ko-KR') : '-';
                const oldValueHtml = history.oldValue ? `<pre class="json-pre">\${formatJson(history.oldValue)}</pre>` : '-';
                const newValueHtml = history.newValue ? `<pre class="json-pre">\${formatJson(history.newValue)}</pre>` : '-';

                tableHtml += `
                    <tr>
                        <td>\${history.historyId}</td>
                        <td>\${history.departmentName || '-'} (\${history.departmentId})</td>
                        <td>\${history.changeType}</td>
                        <td>\${oldValueHtml}</td>
                        <td>\${newValueHtml}</td>
                        <td>\${history.changerUserName || '-'} (\${history.changerUserId})</td>
                        <td>\${changeDate}</td>
                    </tr>
                `;
            });

            tableHtml += `</tbody></table>`;
            departmentHistoryTable.innerHTML = tableHtml;
        }

        function formatJson(jsonString) {
            try {
                const obj = JSON.parse(jsonString);
                return JSON.stringify(obj, null, 2);
            } catch (e) {
                return jsonString;
            }
        }

        applyFilterBtn.addEventListener('click', function() {
            const selectedDeptId = filterDepartmentIdSelect.value;
            fetchAndRenderHistory(selectedDeptId ? parseInt(selectedDeptId) : null);
        });

        function displayClientMessage(message, type) {
            const tempMessageDiv = document.createElement('div');
            tempMessageDiv.innerHTML = `<p class="alert alert-\${type} text-center">\${message}</p>`;
            serverMessageArea.prepend(tempMessageDiv);

            setTimeout(() => {
                tempMessageDiv.remove();
            }, 5000);
        }

        loadDepartmentsForFilter();
        fetchAndRenderHistory(initialDepartmentId && initialDepartmentId !== 'null' ? parseInt(initialDepartmentId) : null);
    });
</script>
</body>
</html>