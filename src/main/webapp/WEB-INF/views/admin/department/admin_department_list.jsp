<%-- src/main/webapp/WEB-INF/views/admin/department/admin_department_list.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>부서 관리</title> <%-- 페이지 타이틀 명확화 --%>
    <style>
        body {
            background-color: #f7f7f7;
            font-family: Arial, sans-serif; /* 폰트 통일 */
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        .container {
            display: flex;
            padding: 20px;
            max-width: 1400px; /* 넓은 화면에서 더 많은 내용이 보이도록 확장 */
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

        /* 필터 섹션 (history 페이지의 filter-section 기준) - list 페이지에는 이 클래스 없음 */
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
</head>
<body>
<div class="container">
    <div class="sidebar">
        <h3>관리 기능</h3>
        <ul>
            <li><a href="/admin" class="${currentPage == 'adminHome' ? 'active' : ''}">대시보드</a></li>
            <li><a href="/admin/dept/list" class="${currentPage == 'departmentList' ? 'active' : ''}">부서 관리</a></li>
            <li><a href="/admin/dept/history" class="${currentPage == 'departmentHistory' ? 'active' : ''}">부서 기록</a></li>
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
                button.addEventListener('click', async  function() {
                    const departmentId = this.dataset.deptId;
                    if(!confirm(`정말 ID \${departmentId} 부서를 삭제하시겠습니까? 하위 부서나 소속 직원이 있는 경우 삭제할 수 없습니다.`)) {
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