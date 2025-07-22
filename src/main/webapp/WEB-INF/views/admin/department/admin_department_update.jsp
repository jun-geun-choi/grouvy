<%-- src/main/webapp/WEB-INF/views/admin/department/department_form.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title><c:out value="${formTitle}"/></title>
    <%-- Bootstrap CSS CDN 직접 추가 --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* 관리자 페이지 공통 스타일 */
        body {
            background-color: #f7f7f7;
            font-family: Arial, sans-serif;
            margin: 0;
        }

        /* 관리자 페이지 자체 상단 내비게이션 (.navbarr) - HTML에 추가되지 않았으므로 이 스타일은 적용되지 않습니다. */
        .navbarr {
            display: flex;
            justify-content: flex-end; /* 우측 정렬 */
            background-color: #34495e; /* 어두운 배경 */
        }

        .navbarr a {
            padding: 10px 20px;
            color: white;
            text-decoration: none;
            display: inline-block;
        }

        .navbarr a:hover, .navbarr a.active {
            background-color: #1abc9c; /* 호버/활성 시 배경색 변경 */
        }

        /* 일반적인 navbar 스타일 (상단 로고/마이페이지 부분) - HTML에 추가되지 않았으므로 이 스타일은 적용되지 않습니다. */
        .navbar-brand {
            color: #e6002d !important; /* 로고 브랜드 색상 */
            font-size: 1.5rem;
        }

        .navbar h4 {
            margin: 0 auto; /* 중앙 정렬 */
        }

        .logo-img {
            width: 160px;
            height: 50px;
            object-fit: contain; /* 이미지 비율 유지 */
            object-position: center;
        }

        .navbar .container-fluid {
            padding-right: 2rem;
            padding-left: 2rem; /* 좌우 여백 */
        }

        /* 컨테이너, 사이드바, 메인 콘텐츠 */
        .container {
            display: flex;
            padding: 20px;
            max-width: 1200px;
            margin: 20px auto;
        }

        .sidebar {
            width: 200px;
            background-color: white;
            border-radius: 8px;
            padding: 15px;
            margin-right: 20px;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
        }

        .sidebar h3 {
            margin-top: 0;
            font-size: 16px;
            border-bottom: 1px solid #ddd;
            padding-bottom: 10px;
        }

        .sidebar ul {
            list-style: none;
            padding: 0;
        }

        .sidebar ul li {
            margin: 10px 0;
        }

        .sidebar ul li a {
            color: #333;
            text-decoration: none;
        }

        .sidebar ul li a.active, .sidebar ul li a:hover {
            color: #1abc9c;
            font-weight: bold;
        }

        .main-content {
            flex: 1; /* flex-grow: 1 */
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
        }

        /* 푸터 스타일 */
        footer {
            text-align: center;
            padding: 10px;
            font-size: 12px;
            color: #999;
            margin-top: 20px;
        }

        /* 관리자 대시보드 카드 스타일 (이 페이지에서는 사용되지 않음) */
        .card {
            background-color: #ecf0f1;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 15px;
            text-align: left;
        }

        .card h4 {
            margin-top: 0;
            font-size: 15px;
        }

        /* 부서 목록 테이블 스타일 (이 페이지에서는 사용되지 않음) */
        table {
            margin-top: 15px;
        }

        th, td {
            vertical-align: middle;
        }

        /* 부서 폼 스타일 */
        .department-form-container {
            max-width: 600px;
            margin: 0 auto;
            padding-top: 20px;
        }

        .department-form-container label {
            font-weight: bold;
            margin-bottom: 5px;
        }

        .department-form-container .form-control {
            margin-bottom: 15px;
        }

        .department-form-container .btn-group {
            justify-content: center;
            display: flex;
        }

        /* 이력 테이블 스타일 (이 페이지에서는 사용되지 않음) */
        .json-pre {
            white-space: pre-wrap;
            word-break: break-all;
            font-family: monospace;
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            padding: 10px;
            max-height: 150px;
            overflow-y: auto;
            font-size: 0.85em;
            margin-top: 5px;
            border-radius: 4px;
        }

        .history-filter-form {
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
<%-- 상단 내비게이션 (navbar)은 요청에 따라 포함하지 않습니다. --%>

<%-- currentPage 변수를 설정하여 사이드바에서 현재 페이지를 활성화 --%>
<c:set var="currentPage" value="departmentList" scope="request"/>

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
            <input type="hidden" id="departmentId" name="departmentId" value="${department.departmentId}">
            <input type="hidden" id="formMode" value="${formMode}"/>

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
                <a href="/admin/dept/list" class="btn btn-secondary">목록으로</a>
            </div>
        </form>
    </div>
</div>

<footer>
    <p>© 2025 그룹웨어 Corp.</p>
</footer>
<%-- Bootstrap JS CDN 직접 추가 --%>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
<!-- admin_department_update.jsp 내 script 태그 -->
<!-- admin_department_update.jsp 내 script 태그 -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const departmentForm = document.getElementById('departmentForm');
        const departmentIdField = document.getElementById('departmentId');
        const departmentNameField = document.getElementById('departmentName');
        const parentDepartmentIdField = document.getElementById('parentDepartmentId');
        const departmentOrderField = document.getElementById('departmentOrder');
        const serverMessageArea = document.getElementById('serverMessageArea');

        const formMode = document.getElementById('formMode') ? document.getElementById('formMode').value : 'create'; // Hidden input에서 가져오는 방식으로 변경
        const currentDepartmentId = departmentIdField.value; // 생성 모드일 경우 비어있을 수 있음

        async function loadParentDepartments() {
            try {
                // 상위 부서 목록 API 경로: /api/v1/dept/list
                const response = await fetch('/api/v1/dept/list'); // OK, 기존 경로 유지
                if (!response.ok) throw new Error('상위 부서 목록 로드 실패');
                const departments = await response.json();

                let optionsHtml = '<option value="">-- 최상위 부서 --</option>';
                departments.forEach(dept => {
                    // 현재 수정 중인 부서는 상위 부서 목록에서 제외 (자기 자신을 부모로 가질 수 없음)
                    if (formMode === 'update' && dept.departmentId == currentDepartmentId) {
                        return;
                    }
                    // 백슬래시 제거 확인
                    optionsHtml += `<option value="\${dept.departmentId}">\${dept.departmentName} (ID: \${dept.departmentId})</option>`;
                });
                parentDepartmentIdField.innerHTML = optionsHtml;

            } catch (error) {
                console.error('상위 부서 목록을 불러오는 중 오류:', error);
                displayClientMessage('상위 부서 목록을 불러올 수 없습니다.', 'danger');
            }
        }

        async function loadDepartmentDataForUpdate() {
            // 'update' 모드이고 departmentId가 유효할 때만 실행
            if (formMode === 'update' && currentDepartmentId) {
                try {
                    // 특정 부서 상세 조회 API 경로: /api/v1/dept/{id}
                    const response = await fetch(`/api/v1/dept/\${currentDepartmentId}`); // 수정!
                    if (!response.ok) {
                        if (response.status === 404) {
                            throw new Error('해당 부서를 찾을 수 없습니다.');
                        } else if (response.status === 401) {
                            displayClientMessage('관리자 권한이 없습니다.', 'danger');
                            return;
                        }
                        throw new Error(`HTTP error! status: \${response.status}`); // 백슬래시 제거 확인
                    }
                    const department = await response.json();
                    console.log('로드된 부서 데이터:', department);

                    departmentNameField.value = department.departmentName;
                    departmentOrderField.value = department.departmentOrder;

                    // 부모 부서가 있다면 선택
                    if (department.parentDepartmentId) {
                        parentDepartmentIdField.value = department.parentDepartmentId;
                    }

                } catch (error) {
                    console.error('부서 데이터를 불러오는 중 오류:', error);
                    displayClientMessage(`부서 데이터를 불러올 수 없습니다: \${error.message}`, 'danger'); // 백슬래시 제거 확인
                }
            }
        }

        departmentForm.addEventListener('submit', async function(event) {
            event.preventDefault(); // 기본 폼 제출 방지

            console.log('Form Mode:', formMode);
            console.log('Current Department ID:', currentDepartmentId);

            const departmentData = {
                departmentName: departmentNameField.value.trim(),
                // value가 빈 문자열이면 null로 변환 (상위 부서 없음)
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

            let url = '/api/v1/dept'; // 생성 API 기본 URL
            let method = 'POST';

            if (formMode === 'update') {
                url += `/\${currentDepartmentId}`; // 수정 API URL
                method = 'PUT';
                departmentData.departmentId = parseInt(currentDepartmentId); // ID 포함하여 전송
            }

            console.log('API URL:', url);
            console.log('HTTP Method:', method);
            try {
                const response = await fetch(url, {
                    method: method,
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(departmentData)
                });
                const result = await response.json();

                if (response.ok) {
                    displayClientMessage(result.message, 'info');
                    setTimeout(() => window.location.href = '/admin/dept/list', 1000); // 목록 페이지로 이동
                } else {
                    displayClientMessage(result.message || (formMode === 'create' ? '부서 생성 실패!' : '부서 수정 실패!'), 'danger'); // 백슬래시 제거 확인
                }
            } catch (error) {
                console.error('부서 저장 중 오류:', error);
                displayClientMessage('부서 저장 중 네트워크 오류.', 'danger');
            }
        });

        // displayClientMessage 함수 (common function)
        function displayClientMessage(message, type) {
            if (!serverMessageArea) {
                console.error('serverMessageArea 엘리먼트를 찾을 수 없습니다.');
                return;
            }
            const tempMessageDiv = document.createElement('div');
            tempMessageDiv.innerHTML = `<p class="alert alert-\${type} text-center">\${message}</p>`; // 백슬래시 제거 확인
            serverMessageArea.prepend(tempMessageDiv);

            setTimeout(() => {
                tempMessageDiv.remove();
            }, 5000);
        }

        loadParentDepartments(); // 상위 부서 목록 로드
        loadDepartmentDataForUpdate(); // 수정 모드 시 데이터 로드
    });
</script>
</body>
</html>