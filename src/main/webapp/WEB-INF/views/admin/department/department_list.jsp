<%-- src/main/webapp/WEB-INF/views/admin/department/department_list.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>부서 관리</title>
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
    <h1>부서 관리</h1>

    <div id="serverMessageArea">
      <c:if test="${not empty errorMessage}">
        <p class="alert alert-danger text-center">${errorMessage}</p>
      </c:if>
    </div>

    <div class="d-flex justify-content-end mb-3">
      <a href="/admin/departments/form" class="btn btn-primary">새 부서 생성</a>
    </div>

    <div id="departmentListTable" class="table-responsive">
      <p>부서 목록을 불러오는 중...</p>
    </div>
  </div>
</div>

<footer>
  <p>© 2025 그룹웨어 Corp.</p>
</footer>
<%-- admin_top.jsp에서 bootstrap.bundle.min.js가 포함되었으므로 여기서는 제거 --%>
<script>
  document.addEventListener('DOMContentLoaded', function() {
    const departmentListTable = document.getElementById('departmentListTable');
    const serverMessageArea = document.getElementById('serverMessageArea');

    async function fetchAndRenderDepartments() {
      departmentListTable.innerHTML = '<p>부서 목록을 불러오는 중...</p>';
      try {
        const response = await fetch('/api/v1/admin/departments');
        if (!response.ok) {
          if (response.status === 401) {
            displayClientMessage('세션이 만료되었거나 관리자 권한이 없습니다. 발신자를 다시 선택해주세요.', 'danger');
            departmentListTable.innerHTML = '';
            return;
          }
          throw new Error(`HTTP error! status: \${response.status}`);
        }
        const departments = await response.json();
        console.log('부서 목록 데이터:', departments);

        renderDepartmentTable(departments);

      } catch (error) {
        console.error('부서 목록을 불러오는 중 오류 발생:', error);
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
        const createdDate = dept.createdDate ? new Date(dept.createdDate).toLocaleString('ko-KR') : '-';
        const updatedDate = dept.updatedDate ? new Date(dept.updatedDate).toLocaleString('ko-KR') : '-';

        tableHtml += `
                    <tr>
                        <td>\${dept.departmentId}</td>
                        <td>\${dept.departmentName}</td>
                        <td>\${dept.parentDepartmentId || '-'}</td>
                        <td>\${dept.departmentOrder}</td>
                        <td>\${createdDate}</td>
                        <td>\${updatedDate}</td>
                        <td>\${dept.isDeleted}</td>
                        <td>
                            <a href="/admin/departments/form/\${dept.departmentId}" class="btn btn-info btn-sm me-1">수정</a>
                            <button type="button" class="btn btn-danger btn-sm delete-dept-btn" data-dept-id="\${dept.departmentId}">삭제</button>
                            <a href="/admin/departments/history/\${dept.departmentId}" class="btn btn-secondary btn-sm ms-1">이력</a>
                        </td>
                    </tr>
                `;
      });

      tableHtml += `</tbody></table>`;
      departmentListTable.innerHTML = tableHtml;

      attachTableEventListeners();
    }

    function attachTableEventListeners() {
      document.querySelectorAll('.delete-dept-btn').forEach(button => {
        button.addEventListener('click', async function() {
          const departmentId = this.dataset.deptId;
          if (!confirm(`정말 ID \${departmentId} 부서를 삭제하시겠습니까? 하위 부서나 소속 직원이 있는 경우 삭제할 수 없습니다.`)) {
            return;
          }

          try {
            const response = await fetch(`/api/v1/admin/departments/\${departmentId}`, {
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