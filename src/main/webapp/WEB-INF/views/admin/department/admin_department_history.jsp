<%-- /WEB-INF/views/admin/department/admin_department_history.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>부서 이력 관리</title>
    <%-- [핵심] 통합된 스타일 시트 시작 --%>
    <style>
        /* 통합 CSS for both admin_department_history.jsp and admin_department_list.jsp */
        body {
            background-color: #f7f7f7;
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        .container {
            display: flex;
            padding: 20px;
            max-width: 1400px; /* 콘텐츠가 많으므로 너비를 조금 넓힘 */
            margin: 20px auto;
        }

        /* [수정] 사이드바 스타일 (사용자 요구사항에 정확히 맞춤) */
        .sidebar {
            width: 200px;
            background-color: white;
            border-radius: 8px;
            padding: 15px;
            margin-right: 20px;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
            /* height: fit-content; 삭제 - 원본 스타일에는 없으며, flex 컨테이너에서 자연스럽게 높이 조절 */
        }

        .sidebar h3 {
            margin-top: 0;
            font-size: 16px;
            border-bottom: 1px solid #ddd;
            padding-bottom: 10px;
            /* margin-bottom 삭제 - 원본 스타일에는 없음 */
        }

        .sidebar ul {
            list-style: none;
            padding: 0;
        }

        .sidebar ul li {
            margin: 10px 0; /* 원본 스타일과 동일하게 */
        }

        .sidebar ul li a {
            color: #333;
            text-decoration: none;
            /* display: block, padding, border-radius, transition 삭제 - 원본 스타일에는 없음 */
        }

        .sidebar ul li a.active, .sidebar ul li a:hover {
            color: #1abc9c; /* 활성 메뉴 텍스트 색상 및 호버 색상 통일 */
            font-weight: bold;
            /* background-color 삭제 - 원본 스타일에는 없음 */
        }

        /* 메인 콘텐츠 영역 스타일 (admin_department_list 기준) */
        .main-content {
            flex: 1;
            background-color: white;
            border-radius: 8px;
            padding: 25px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .main-content h2 { /* h1 대신 h2로 통일 */
            margin-top: 0;
            margin-bottom: 30px;
            color: #34495e;
            font-size: 1.6em;
            border-bottom: 1px solid #eee;
            padding-bottom: 18px;
        }

        /* 필터 섹션 (history 페이지의 filter-section 기준) */
        .filter-section {
            margin-bottom: 25px;
            padding: 20px;
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .filter-section label {
            font-weight: bold;
            font-size: 0.9em;
        }

        .filter-section select {
            padding: 8px 12px;
            border: 1px solid #ccc;
            border-radius: 5px;
            min-width: 250px;
        }

        .filter-section button {
            padding: 8px 20px;
            border: none;
            background-color: #3498db;
            color: white;
            border-radius: 5px;
            cursor: pointer;
            font-size: 0.9em;
            transition: background-color 0.2s;
        }

        .filter-section button:hover {
            background-color: #2980b9;
        }

        /* 테이블 공통 스타일 (Bootstrap table, table-bordered, table-hover 대체) */
        .table { /* Bootstrap의 .table과 유사하게 */
            width: 100%;
            margin-bottom: 1rem;
            color: #212529;
            border-collapse: collapse;
        }

        .table th,
        .table td {
            padding: 0.75rem; /* Bootstrap 기본 패딩 */
            vertical-align: top;
            border-top: 1px solid #dee2e6;
            text-align: left; /* 기본 왼쪽 정렬 */
        }

        .table thead th {
            vertical-align: bottom;
            border-bottom: 2px solid #dee2e6;
            background-color: #f8f9fa; /* list 페이지의 thead 배경색 */
            font-weight: 600;
            color: #495057;
            white-space: nowrap; /* 헤더 줄바꿈 방지 */
        }

        .table tbody + tbody {
            border-top: 2px solid #dee2e6;
        }

        .table-bordered { /* Bootstrap의 .table-bordered와 유사하게 */
            border: 1px solid #dee2e6;
        }
        .table-bordered th,
        .table-bordered td {
            border: 1px solid #dee2e6;
        }
        .table-bordered thead th,
        .table-bordered thead td {
            border-bottom-width: 2px;
        }

        .table-hover tbody tr:hover { /* Bootstrap의 .table-hover와 유사하게 */
            color: #212529;
            background-color: rgba(0, 0, 0, 0.075);
        }

        /* 추가된 이력 테이블 전용 스타일 */
        #historyTableContainer {
            margin-top: 20px; /* 여백 유지 */
        }

        .history-table th, .history-table td {
            text-align: center; /* 이력 테이블은 중앙 정렬 유지 */
            vertical-align: middle; /* 세로 중앙 정렬로 다시 오버라이드 */
        }

        .history-table td.value-cell {
            text-align: left; /* 값 컬럼은 왼쪽 정렬 유지 */
            background-color: #fdfdfd;
        }

        /* JSON 데이터 표시용 스타일 (history 페이지 전용) */
        .json-data {
            white-space: pre-wrap;
            word-break: break-word;
            font-family: 'Consolas', 'Courier New', monospace;
            font-size: 0.88em;
            padding: 10px;
            border-radius: 5px;
            background-color: #f1f3f5;
            color: #495057;
            max-height: 200px;
            overflow-y: auto;
        }

        /* 기타 유틸리티 */
        .text-muted {
            color: #6c757d;
        }
        .text-center {
            text-align: center;
        }
        .alert-danger { /* 메시지 박스 스타일 */
            color: #721c24;
            background-color: #f8d7da;
            border-color: #f5c6cb;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 15px;
            text-align: center;
        }
        .alert-info { /* 메시지 박스 스타일 */
            color: #0c5460;
            background-color: #d1ecf1;
            border-color: #bee5eb;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 15px;
            text-align: center;
        }

        /* 버튼 공통 스타일 (list 페이지의 btn-primary, btn-info, btn-danger, btn-secondary 대체) */
        .btn {
            display: inline-block;
            font-weight: 400;
            line-height: 1.5;
            color: #212529;
            text-align: center;
            text-decoration: none;
            vertical-align: middle;
            cursor: pointer;
            user-select: none;
            background-color: transparent;
            border: 1px solid transparent;
            padding: 0.375rem 0.75rem; /* 기본 버튼 패딩 */
            font-size: 1rem;
            border-radius: 0.25rem;
            transition: color .15s ease-in-out, background-color .15s ease-in-out, border-color .15s ease-in-out, box-shadow .15s ease-in-out;
        }
        .btn-primary {
            color: #fff;
            background-color: #0d6efd;
            border-color: #0d6efd;
        }
        .btn-primary:hover {
            color: #fff;
            background-color: #0b5ed7;
            border-color: #0a58ca;
        }
        .btn-info {
            color: #fff;
            background-color: #0dcaf0;
            border-color: #0dcaf0;
        }
        .btn-info:hover {
            color: #fff;
            background-color: #31d2f2;
            border-color: #25cff2;
        }
        .btn-danger {
            color: #fff;
            background-color: #dc3545;
            border-color: #dc3545;
        }
        .btn-danger:hover {
            color: #fff;
            background-color: #bb2d3b;
            border-color: #bb2d3b;
        }
        .btn-secondary {
            color: #fff;
            background-color: #6c757d;
            border-color: #6c757d;
        }
        .btn-secondary:hover {
            color: #fff;
            background-color: #5c636a;
            border-color: #565e64;
        }
        .btn-sm { /* 작은 버튼 */
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
            border-radius: 0.2rem;
        }
        .me-1 { margin-right: 0.25rem !important; }
        .ms-1 { margin-left: 0.25rem !important; }

        /* Flexbox 유틸리티 (Bootstrap d-flex, justify-content-end, mb-3 대체) */
        .d-flex { display: flex !important; }
        .justify-content-end { justify-content: flex-end !important; }
        .mb-3 { margin-bottom: 1rem !important; }
        .table-responsive {
            display: block;
            width: 100%;
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
        }

        /* 반응형 디자인을 위한 미디어 쿼리 */
        @media (max-width: 768px) {
            .container {
                flex-direction: column;
                padding: 15px;
            }
            .sidebar {
                width: 100%;
                margin-right: 0;
                margin-bottom: 20px;
                padding: 15px;
            }
            .main-content {
                padding: 20px;
            }
            .main-content .d-flex.justify-content-end.mb-3 {
                justify-content: center !important;
            }
            .main-content .d-flex.justify-content-end.mb-3 .btn {
                width: 100%;
            }
            .department-form-container { /* form 페이지용. 일단 남겨둠 */
                padding: 20px;
            }
        }
        @media (max-width: 576px) {
            .container {
                padding: 10px;
            }
            .main-content {
                padding: 15px;
            }
            .main-content h2 {
                font-size: 1.2em;
                margin-bottom: 15px;
                padding-bottom: 10px;
            }
            .table thead th,
            .table tbody td { /* .table 대신 .table-responsive 안의 table에 적용될 수 있음 */
                padding: 8px 10px;
                font-size: 0.85em;
            }
            .department-form-container {
                padding: 20px;
            }
            .department-form-container .btn-group { /* form 페이지용. 일단 남겨둠 */
                flex-direction: column;
            }
            .department-form-container .btn {
                width: 100%;
                margin-bottom: 10px;
                margin-right: 0 !important;
            }
            .department-form-container .btn:last-child {
                margin-bottom: 0;
            }
        }
    </style>
    <%-- [핵심] 통합된 스타일 시트 끝 --%>
</head>
<body>
<div class="container">
    <div class="sidebar">
        <h3>관리 기능</h3>
        <ul>
            <%-- [수정] 사이드바 메뉴 활성화 클래스 적용 --%>
            <li><a href="/admin" class="${currentPage == 'adminHome' ? 'active' : ''}">대시보드</a></li>
            <li><a href="/admin/dept/list" class="${currentPage == 'departmentList' ? 'active' : ''}">부서 관리</a></li>
            <li><a href="/admin/dept/history" class="${currentPage == 'departmentHistory' ? 'active' : ''}">부서 이력</a></li>
        </ul>
    </div>
    <%-- [변경] 기존 main-container를 main-content로 변경하여 레이아웃 통일 --%>
    <div class="main-content">
        <h2>부서 이력 조회</h2> <%-- [변경] h1 대신 h2로 통일 --%>

        <div class="filter-section">
            <label for="departmentSelect">부서 선택:</label>
            <select id="departmentSelect">
                <option value="">전체 부서</option>
                <%-- 부서 목록은 JavaScript로 채워집니다 --%>
            </select>
            <button id="searchButton">조회</button>
        </div>

        <div id="historyTableContainer">
            <p class="text-center text-muted">조회할 부서를 선택하거나, 전체 부서로 조회해주세요.</p>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // 컨트롤러에서 전달받은 값 (URL에 departmentId가 있는 경우)
        // \${...} EL 충돌 방지용은 그대로 유지
        const initialDepartmentId = "\${selectedDepartmentId}";

        const departmentSelect = document.getElementById('departmentSelect');
        const searchButton = document.getElementById('searchButton');
        const historyTableContainer = document.getElementById('historyTableContainer');

        // 1. 부서 목록 로딩 함수
        async function loadDepartmentOptions() {
            try {
                const response = await fetch('/api/v1/dept/list');
                if (!response.ok) {
                    // [확인] 백슬래시 제거된 상태
                    throw new Error(`HTTP error! status: \${response.status}`);
                }
                const departments = await response.json();

                departments.forEach(dept => {
                    const option = document.createElement('option');
                    option.value = dept.departmentId;
                    // [확인] 백슬래시 제거된 상태
                    option.textContent = `\${dept.departmentName} (ID: \${dept.departmentId})`;
                    departmentSelect.appendChild(option);
                });

                if (initialDepartmentId) {
                    departmentSelect.value = initialDepartmentId;
                    fetchAndRenderHistories();
                }

            } catch (error) {
                console.error('부서 목록 로딩 실패:', error);
                departmentSelect.innerHTML = '<option value="">부서 목록을 불러올 수 없습니다.</option>';
            }
        }

        // 2. 이력 데이터 조회 함수
        async function fetchAndRenderHistories() {
            const selectedId = departmentSelect.value;
            // [확인] 백슬래시 제거된 상태
            const apiUrl = selectedId ? `/api/v1/dept/history/\${selectedId}` : '/api/v1/dept/history';

            historyTableContainer.innerHTML = '<p class="text-center text-muted">이력 데이터를 불러오는 중...</p>';

            try {
                const response = await fetch(apiUrl);
                if (!response.ok) {
                    if (response.status === 404) {
                        historyTableContainer.innerHTML = '<p class="text-center text-muted">해당 부서의 이력이 존재하지 않습니다.</p>';
                    } else {
                        // [확인] 백슬래시 제거된 상태
                        throw new Error(`HTTP error! status: \${response.status}`);
                    }
                    return;
                }
                const histories = await response.json();
                renderHistoryTable(histories);

            } catch (error) {
                console.error('이력 조회 중 오류:', error);
                // [확인] 백슬래시 제거된 상태
                historyTableContainer.innerHTML = `<p class="alert alert-danger">이력 조회 중 오류가 발생했습니다: \${error.message}</p>`;
            }
        }


        // 원본 JSON을 받아 가독성 좋은 텍스트로 가공
        function formatHistoryValue(jsonString) {
            if (!jsonString || jsonString.trim() === '') return '-';

            try {
                const data = JSON.parse(jsonString);
                const output = [];

                // 1. 부서명 추출
                if (data.departmentName) {
                    // [확인] 백슬래시 제거된 상태
                    output.push(`부서명: \${data.departmentName}`);
                }

                // 2. 상위 부서 정보 추출 (parentDepartmentId는 null일 수 있음)
                if (data.parentDepartmentId) {
                    // [확인] 백슬래시 제거된 상태
                    output.push(`상위 부서 ID: \${data.parentDepartmentId}`);
                } else if (data.parentDepartmentId === null) {
                    output.push(`상위 부서: 최상위`);
                }

                // 3. 정렬 순서 추출
                if (data.departmentOrder !== undefined && data.departmentOrder !== null) {
                    // [확인] 백슬래시 제거된 상태
                    output.push(`정렬 순서: \${data.departmentOrder}`);
                }

                // 가공된 텍스트들을 줄바꿈 문자로 연결하여 반환
                return output.join('\n');

            } catch (e) {
                // JSON 파싱 실패 시 원본 텍스트 반환 (만약을 대비)
                // [확인] 백슬래시 제거된 상태
                return jsonString.replace(/\r?\n/g, '<br>');
            }
        }

        // 테이블 렌더링 함수
        function renderHistoryTable(histories) {
            if (!histories || histories.length === 0) {
                historyTableContainer.innerHTML = '<p class="text-center text-muted">조회된 이력이 없습니다.</p>';
                return;
            }

            // [수정] Bootstrap table 클래스 추가 (여기서 추가하면 history-table에도 적용됨)
            const tableClasses = "history-table table table-bordered table-hover";

            const tableRows = histories.map(history => {
                const changeDate = new Date(history.changeDate).toISOString().split('T')[0];
                // [확인] 백슬래시 제거된 상태
                const departmentInfo = `\${history.departmentName} (\${history.departmentId})`;
                // [확인] 백슬래시 제거된 상태
                const changerInfo = `\${history.changerUserName} (\${history.changerUserId})`;

                // 헬퍼 함수를 사용하여 oldValue, newValue 가공
                const oldValueFormatted = formatHistoryValue(history.oldValue);
                const newValueFormatted = formatHistoryValue(history.newValue);

                return `
                    <tr>
                        <td>\${history.historyId}</td>
                        <td>\${departmentInfo}</td>
                        <td>\${history.changeType}</td>
                        <td class="value-cell"><pre class="json-data">\${oldValueFormatted}</pre></td>
                        <td class="value-cell"><pre class="json-data">\${newValueFormatted}</pre></td>
                        <td>\${changerInfo}</td>
                        <td>\${changeDate}</td>
                    </tr>
                `;
            }).join('');

            const tableHtml = `
                <table class="\${tableClasses}">
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
                </table>
            `;
            historyTableContainer.innerHTML = tableHtml;
        }

        // 이벤트 리스너 등록 및 초기 데이터 로드
        searchButton.addEventListener('click', fetchAndRenderHistories);
        loadDepartmentOptions();
    });
</script>
</body>
</html>