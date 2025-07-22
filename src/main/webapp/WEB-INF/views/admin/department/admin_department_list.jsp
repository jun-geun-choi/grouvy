<%-- src/main/webapp/WEB-INF/views/admin/department/admin_department_list.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>조직도</title>
    <%-- Bootstrap CSS CDN 추가 --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f7f7f7;
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0; /* body의 기본 패딩 제거 */
            box-sizing: border-box; /* 패딩과 보더가 요소의 너비/높이에 포함되도록 */
        }

        /* 관리자 페이지 자체 상단 내비게이션 (.navbarr) */
        .navbarr {
            display: flex;
            justify-content: flex-end;
            background-color: #34495e;
            padding: 8px 15px; /* 상하 패딩, 좌우 패딩 조정 */
        }

        .navbarr a {
            padding: 8px 12px; /* 링크 내부 패딩 조정 */
            color: white;
            text-decoration: none;
            display: inline-block;
            border-radius: 4px;
            transition: background-color 0.2s ease;
        }

        .navbarr a:hover, .navbarr a.active {
            background-color: #1abc9c;
        }

        /* 일반적인 navbar 스타일 (현재 JSP에 사용되지 않음 - 주석 유지) */
        .navbar-brand {
            color: #e6002d !important;
            font-size: 1.5rem;
        }
        .navbar h4 {
            margin: 0 auto;
        }
        .logo-img {
            width: 160px;
            height: 50px;
            object-fit: contain;
            object-position: center;
        }
        .navbar .container-fluid {
            padding-right: 2rem;
            padding-left: 2rem;
        }

        /*
         * ----- 사이드바 CSS: 원본 그대로 유지합니다 (요청에 따라) -----
         */
        .container { /* 이 클래스 이름은 HTML에서 .admin-page-container로 변경하는 것을 권장합니다. */
            display: flex;
            padding: 20px; /* 원본 패딩 유지 */
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
        /* ----- 사이드바 CSS 끝 ----- */


        /* 메인 콘텐츠 영역 스타일 */
        .main-content {
            flex: 1; /* 남은 공간 모두 차지 */
            background-color: white;
            border-radius: 8px;
            padding: 25px; /* 내부 패딩 증가 */
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1); /* 그림자 효과 조정 */
        }

        .main-content h2 {
            margin-top: 0;
            margin-bottom: 30px; /* 제목 아래 여백 증가 */
            color: #34495e;
            font-size: 1.6em;
            border-bottom: 1px solid #eee;
            padding-bottom: 18px; /* 경계선과의 간격 증가 */
        }

        /* 푸터 스타일 */
        footer {
            text-align: center;
            padding: 15px; /* 패딩 조정 */
            font-size: 0.8em;
            color: #999;
            margin-top: 30px; /* 상단 마진 조정 */
            background-color: #ffffff;
            box-shadow: 0 -1px 5px rgba(0, 0, 0, 0.05);
        }

        /* 관리자 대시보드 카드 스타일 */
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

        /* 부서 목록 테이블 스타일 */
        /* 테이블 상단 '새 부서 생성' 버튼 div의 마진 조정 */
        .main-content .d-flex.justify-content-end.mb-3 {
            margin-bottom: 20px !important; /* 아래 여백 조정 */
            /* 기존 HTML에서 이 div는 .main-content 바로 아래에 있으므로,
               main-content의 padding-right와 겹치지 않도록 조정할 필요는 없을 수도 있습니다. */
        }
        .main-content .d-flex.justify-content-end.mb-3 .btn {
            padding: 8px 15px; /* 버튼 패딩 조정 */
            font-size: 0.9em; /* 버튼 폰트 크기 조정 */
            border-radius: 5px;
            min-width: 120px; /* 최소 너비 설정 */
        }

        table {
            margin-top: 0; /* .table-responsive의 마진과 겹치지 않도록 0으로 설정 */
            width: 100%;
        }
        th, td {
            vertical-align: middle; /* 세로 중앙 정렬 */
            padding: 10px 12px; /* 셀 내부 패딩 조정 */
            font-size: 0.9em;
        }
        th {
            white-space: nowrap; /* 테이블 헤더 줄바꿈 방지 */
        }
        td:last-child { /* 액션 컬럼의 버튼 간격 조정 */
            white-space: nowrap; /* 버튼들이 한 줄에 있도록 */
        }
        td:last-child .btn {
            margin-right: 5px; /* 버튼 사이 간격 */
            font-size: 0.85em;
            padding: 6px 10px;
        }
        td:last-child .btn:last-child {
            margin-right: 0;
        }


        /* 부서 폼 스타일 (admin_department_update.jsp에서 사용) */
        .department-form-container {
            max-width: 650px;
            margin: 25px auto; /* 상하 여백 및 중앙 정렬 */
            padding: 25px; /* 내부 패딩 조정 */
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        .department-form-container label {
            font-weight: bold;
            margin-bottom: 8px; /* 레이블 아래 여백 조정 */
        }
        .department-form-container .form-control,
        .department-form-container .form-select {
            margin-bottom: 18px; /* 입력 필드 아래 여백 조정 */
            padding: 9px 12px; /* 필드 내부 패딩 조정 */
            border-radius: 5px;
        }
        .department-form-container .btn-group {
            justify-content: center;
            display: flex;
            margin-top: 20px; /* 버튼 그룹 상단 여백 조정 */
        }
        .department-form-container .btn {
            padding: 9px 18px;
            font-size: 0.95em;
            border-radius: 5px;
            min-width: 80px;
        }


        /* 이력 테이블 스타일 (department_history.jsp에서 사용) */
        .json-pre {
            white-space: pre-wrap;
            word-break: break-all;
            font-family: monospace;
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            padding: 12px;
            max-height: 180px;
            overflow-y: auto;
            font-size: 0.88em;
            margin-top: 12px;
            border-radius: 5px;
        }
        .history-filter-form {
            margin-bottom: 20px;
        }

        /* 반응형 디자인을 위한 미디어 쿼리 (선택 사항) */
        /* 작은 화면에서 사이드바가 100% 너비가 되도록 조정하는 미디어 쿼리는 그대로 유지했습니다.
           이는 사이드바 자체의 스타일이 아니라, 레이아웃 변경에 대한 부분이므로 필요하다고 판단했습니다.
           만약 이 부분도 원하지 않으시면 제거하셔도 됩니다. */
        @media (max-width: 768px) {
            .container { /* 이 클래스 이름은 HTML에서 .admin-page-container로 변경하는 것을 권장합니다. */
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
            .department-form-container {
                padding: 20px;
            }
        }
        @media (max-width: 576px) {
            .container { /* .admin-page-container를 사용한다면 그 클래스에 적용 */
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
            table.table thead th,
            table.table tbody td {
                padding: 8px 10px;
                font-size: 0.85em;
            }
            .department-form-container {
                padding: 20px;
            }
            .department-form-container .btn-group {
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
</head>
<body>
<div class="container">
    <div class="sidebar">
        <h3>관리 기능</h3>
        <ul>
            <li><a href="/admin" class="${currentPage == 'adminHome' ? 'active' : ''}">대시보드</a></li>
            <li><a href="/admin/dept/list" class="${currentPage == 'departmentList' ? 'active' : ''}">부서 관리</a></li>
        </ul>
    </div>
    <%-- **여기부터 main-content div 추가** --%>
    <div class="main-content">
        <%-- 서버 메시지 또는 클라이언트 메시지를 표시할 영역 추가 --%>
        <div id="serverMessageArea"></div>

        <div class="d-flex justify-content-end mb-3">
            <a href="/admin/dept/form" class="btn btn-primary">새 부서 생성</a>
        </div>

        <div id="departmentListTable" class="table-responsive">
            <p>부서 목록을 불러오는 중...</p>
        </div>
    </div>
    <%-- **main-content div 끝** --%>
</div>
<%-- Bootstrap JS (Popper.js 포함) CDN 추가 (선택 사항이지만, 일부 Bootstrap 컴포넌트 동작에 필요할 수 있음) --%>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const departmentListTable = document.getElementById('departmentListTable')
        const serverMessageArea = document.getElementById('serverMessageArea'); // 메시지 표시 영역 변수 선언

        async function fetchAndRenderDepartments() {
            departmentListTable.innerHTML = '<p>로딩중...</p>';
            try {
                // 부서 목록 로드 API 경로: /api/v1/dept/list
                const response = await fetch('/api/v1/dept/list'); // OK, 기존 경로 유지
                if (!response.ok) {
                    throw new Error(`HTTP error! status: \${response.status}`); // 백슬래시 제거 확인
                }
                const departments = await response.json();
                console.log('부서 목록 데이터: ', departments);

                renderDepartmentTable(departments); // 렌더링
                attachTableEventListeners(); // 렌더링 후 이벤트 리스너 부착
            } catch (error) {
                console.error('부서 목록을 불러오는 중 오류 발생: ', error);
                departmentListTable.innerHTML = `<p class="alert alert-danger">부서 목록을 불러올 수 없습니다. 오류: \${error.message}</p>`; // 백슬래시 제거 확인
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
                const createdDate = dept.createdDate ? new Date(dept.createdDate).toLocaleString('ko-KR') : '-';
                const updatedDate = dept.updatedDate ? new Date(dept.updatedDate).toLocaleString('ko-KR') : '-';

                tableHtml += `
                            <tr>
                                <td>\${dept.departmentId}</td>
                                <td>\${dept.departmentName}</td>
                                <td>\${dept.parentDepartmentId || '최상위 부서'}</td>
                                <td>\${dept.departmentOrder}</td>
                                <td>\${createdDate}</td> <!-- 백슬래시 제거 확인 -->
                                <td>\${updatedDate}</td> <!-- 백슬래시 제거 확인 -->
                                <td>\${dept.isDeleted}</td>
                                <td>
                                    <!-- 수정 버튼 링크 URL 수정: /admin/dept/update/{id} -->
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
                button.addEventListener('click', async  function() {
                    const departmentId = this.dataset.deptId;
                    if(!confirm(`정말 ID \${departmentId} 부서를 삭제하시겠습니까? 하위 부서나 소속 직원이 있는 경우 삭제할 수 없습니다.`)) { // 백슬래시 제거 확인
                        return;
                    }

                    try {
                        // 삭제 API 경로: /api/v1/dept/{id}
                        const response = await fetch(`/api/v1/dept/\${departmentId}`, { // 수정!
                            method: 'DELETE',
                        });
                        const result = await response.json(); // 서버 응답이 JSON임을 가정

                        if (response.ok) {
                            displayClientMessage(result.message, 'info');
                            fetchAndRenderDepartments(); // 성공 시 목록 새로고침
                        } else {
                            displayClientMessage(result.message || '부서 삭제 실패!', 'danger'); // 백슬래시 제거 확인
                        }
                    } catch(error) {
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
            tempMessageDiv.innerHTML = `<p class="alert alert-\${type} text-center">\${message}</p>`; // 백슬래시 제거 확인
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