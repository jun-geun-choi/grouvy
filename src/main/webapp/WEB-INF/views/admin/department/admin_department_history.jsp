<%-- /WEB-INF/views/admin/department/admin_department_history.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>부서 이력 관리</title>
    <meta charset="UTF-8">
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
        <h2>부서 이력 조회</h2>

        <div class="filter-section">
            <label for="departmentSelect">부서 선택:</label>
            <select id="departmentSelect">
                <option value="">전체 부서</option>
            </select>
            <button id="searchButton">조회</button>
        </div>

        <div id="historyTableContainer">
            <p class="text-center text-muted">조회할 부서를 선택하거나, 전체 부서로 조회해주세요.</p>
        </div>
    </div>
</div>
<%@include file="../../common/footer.jsp" %>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const initialDepartmentId = "${selectedDepartmentId}" === "null" || "${selectedDepartmentId}" === "" ? null : parseInt("${selectedDepartmentId}");
        const departmentSelect = document.getElementById('departmentSelect');
        const searchButton = document.getElementById('searchButton');
        const historyTableContainer = document.getElementById('historyTableContainer');

        async function fetchAndRenderHistories(departmentId) {
            const apiUrl = departmentId ? `/api/v1/dept/history/\${departmentId}` : '/api/v1/dept/history';
            historyTableContainer.innerHTML = '<p class="text-center text-muted">로딩 중...</p>';
            try {
                const response = await fetch(apiUrl);
                if (!response.ok) {
                    if (response.status === 404) throw new Error('데이터 없음');
                    else throw new Error(`HTTP 오류! Status: \${response.status}`);
                }
                const histories = await response.json();
                renderHistoryTable(histories);
            } catch (error) {
                historyTableContainer.innerHTML = (error.message === '데이터 없음')
                    ? '<p class="text-center text-muted">해당 이력이 없습니다.</p>'
                    : '<p class="alert alert-danger">이력 조회 중 오류가 발생했습니다.</p>';
            }
        }

        async function setupDepartmentDropdown() {
            try {
                const response = await fetch('/api/v1/dept/list');
                if (!response.ok) throw new Error('부서 목록 로딩 실패');
                const departments = await response.json();
                departmentSelect.innerHTML = '<option value="">-- 모든 부서 이력 --</option>';
                departments.forEach(dept => {
                    const option = document.createElement('option');
                    option.value = dept.departmentId;
                    option.textContent = `\${dept.departmentName} (ID: \${dept.departmentId})`;
                    departmentSelect.appendChild(option);
                });
                if (initialDepartmentId) {
                    departmentSelect.value = initialDepartmentId;
                }
            } catch (error) {
                console.error(error);
                departmentSelect.innerHTML = '<option value="">로딩 실패</option>';
            }
        }

        function renderHistoryTable(histories) {
            if (!histories || histories.length === 0) {
                historyTableContainer.innerHTML = '<p class="text-center text-muted">조회된 이력이 없습니다.</p>';
                return;
            }
            const tableClasses = "history-table table table-bordered table-hover";
            const tableRows = histories.map(history => {
                const changeDate = new Date(history.changeDate).toISOString().split('T')[0];
                const departmentInfo = `\${history.departmentName} (\${history.departmentId})`;
                const changerInfo = `\${history.changerUserName} (\${history.changerUserId})`;
                const oldValueFormatted = formatHistoryValue(history.oldValue);
                const newValueFormatted = formatHistoryValue(history.newValue);
                return `<tr>
                            <td>\${history.historyId}</td>
                            <td>\${departmentInfo}</td>
                            <td>\${history.changeType}</td>
                            <td class="value-cell"><pre class="json-data">\${oldValueFormatted}</pre></td>
                            <td class="value-cell"><pre class="json-data">\${newValueFormatted}</pre></td>
                            <td>\${changerInfo}</td><td>\${changeDate}</td>
                        </tr>`;
            }).join('');
            const tableHtml = `<table class="\${tableClasses}">
                                    <thead>
                                        <tr>
                                            <th style="width: 5%;">이력ID</th>
                                            <th style="width: 15%;">부서</th>
                                            <th style="width: 8%;">변경 타입</th>
                                            <th>이전 값</th>
                                            <th>새로운 값</th>
                                            <th style="width: 12%;">변경자</th>
                                            <th style="width: 10%;">변경일</th>
                                        </tr>
                                    </thead>
                                <tbody>\${tableRows}</tbody>
                                </table>`;
            historyTableContainer.innerHTML = tableHtml;
        }

        function formatHistoryValue(jsonString) {
            if (!jsonString || jsonString.trim() === '') return '-';
            try {
                const data = JSON.parse(jsonString);
                const output = [];
                if (data.departmentName) output.push(`부서명: \${data.departmentName}`);
                if (data.parentDepartmentId !== undefined) output.push(`상위 부서 ID: \${data.parentDepartmentId === null ? '최상위' : data.parentDepartmentId}`);
                if (data.departmentOrder !== undefined) output.push(`정렬 순서: \${data.departmentOrder}`);
                return output.join('\n');
            } catch (e) {
                return jsonString.replace(/\r?\n/g, '<br>');
            }
        }

        searchButton.addEventListener('click', () => {
            const selectedId = departmentSelect.value ? parseInt(departmentSelect.value) : null;
            fetchAndRenderHistories(selectedId);
        });

        fetchAndRenderHistories(initialDepartmentId);
        setupDepartmentDropdown();
    });
</script>
</body>
</html>