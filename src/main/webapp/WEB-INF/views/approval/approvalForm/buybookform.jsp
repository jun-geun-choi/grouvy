<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.text.SimpleDateFormat, java.util.Date" %>
<%@ include file="../../common/taglib.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>전자결재 - 도서구입 신청서</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            color: #333;
            padding-top: 80px;
        }
        .navbar-brand {
            color: #e6002d !important;
            font-size: 1.5rem;
        }
        .nav-item {
            padding-right: 1rem;
        }
        .navbar-nav .nav-link.active {
            font-weight: bold;
            color: #e6002d !important;
        }
        .logo-img {
            width: 160px;
            height: 50px;
            object-fit: cover;
            object-position: center;
        }
        .navbar .container-fluid {
            padding-right: 2rem;
        }
        .container {
            display: flex;
            padding: 20px;
        }
        .sidebar {
            width: 220px;
            background-color: white;
            border-radius: 12px;
            padding: 15px;
            margin-right: 20px;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
            height: fit-content;
        }
        .sidebar h3 {
            margin-top: 0;
            font-size: 16px;
            border-bottom: 1px solid #ddd;
            padding-bottom: 10px;
            color: #e6002d;
            font-weight: bold;
        }
        .sidebar-section {
            margin-bottom: 20px;
        }
        .sidebar-section-title {
            font-size: 14px;
            font-weight: bold;
            color: #333;
            margin-bottom: 8px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .sidebar-section-title.red {
            color: #e6002d;
        }
        .sidebar-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .sidebar-list li {
            margin: 5px 0;
            padding: 8px 12px;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.2s;
            font-size: 16px;
        }
        .sidebar-list li.active,
        .sidebar-list li:hover {
            background-color: #f8f9fa;
            color: #1abc9c;
            font-weight: bold;
        }
        .sidebar-list li .badge {
            background-color: #e6002d;
            color: white;
            border-radius: 12px;
            padding: 2px 6px;
            font-size: 11px;
            margin-left: 5px;
        }
        .sidebar-list li .badge.orange {
            background-color: #ff9800;
        }
        .sidebar-list li .badge.gray {
            background-color: #6c757d;
        }
        .main-content {
            flex: 1;
            background-color: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
        }
        .main-content h2 {
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 20px;
            color: #333;
            text-align: center;
        }
        .form-label {
            font-weight: 500;
            color: #333;
        }
        .table th, .table td {
            vertical-align: middle;
        }
        .btn-primary {
            background-color: #1abc9c;
            border-color: #1abc9c;
            color: white;
        }
        .btn-primary:hover {
            background-color: #16a085;
            border-color: #16a085;
        }
        .btn-success {
            background-color: #4CAF50;
            border-color: #4CAF50;
            color: white;
        }
        .btn-success:hover {
            background-color: #45a049;
            border-color: #45a049;
        }
        .btn-outline-secondary {
            color: #333;
            border-color: #ccc;
        }
        .btn-outline-secondary:hover {
            background: #f5f5f5;
            color: #1abc9c;
            border-color: #1abc9c;
        }
        .info-text {
            color: #666;
            font-size: 13px;
            line-height: 1.5;
            margin-top: 15px;
        }
        footer {
            text-align: center;
            padding: 15px;
            font-size: 12px;
            color: #999;
            border-top: 1px solid #eee;
            margin-top: 40px;
        }
    </style>
</head>
<body>
<sec:authentication property="principal.user" var="user"/>
<%@include file="../../common/nav.jsp" %>
<main>
    <div class="container">
        <jsp:include page="/WEB-INF/views/approval/common/sidebar.jsp" />
        <div class="main-content">
            <h2>도서구입 신청서</h2>
            <div class="row mb-4 justify-content-end">
              <div class="col-md-5">
                <div id="approvalLinePreview"></div>
              </div>
            </div>
            <form id="approvalForm"
                  action="/approval/create"
                  method="post"
                  enctype="multipart/form-data">

                <div class="row mb-3">
                    <div class="col-md-4 mb-2">
                        <label class="form-label">문서번호</label>
                        <input type="text" class="form-control" value="자동채번" readonly>
                        <input type="hidden" name="formNo" value="1">
                        <input type="hidden" name="writerId" value="${user.employeeNo}">
                        <input type="hidden" name="writerName" value="${user.name}">
                    </div>
                    <div class="col-md-4 mb-2">
                        <label class="form-label">기안일자</label>
                        <input type="String" class="form-control" value="${today}" readonly>
                    </div>
                    <div class="col-md-4 mb-2">
                        <label class="form-label">기안자</label>
                        <input type="text" class="form-control" value="${user.name}" readonly>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-4 mb-2">
                        <label class="form-label">기안부서</label>
                        <input name="approvalDepartmentName" type="text" class="form-control" value="${user.department.departmentName}" readonly>
                    </div>
                    <div class="col-md-4 mb-2">
                        <label class="form-label">기결계첨부</label>
                        <input type="text" class="form-control" value="기결계첨부" readonly>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6 mb-2">
                        <label class="form-label">수신처</label>
                        <div class="input-group">
                            <input name="receiverDepartmentName" type="text" id="receiverDept" class="form-control" readonly>
                            <button class="btn btn-outline-secondary" type="button" id="selectReceiverBtn">수신처</button>
                        </div>
                    </div>
                    <div class="col-md-6 mb-2">
                        <label class="form-label">문서제목 <span class="text-danger">*</span></label>
                        <input name="title" type="text" class="form-control">
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6 mb-2">
                        <label class="form-label">SMS 알림</label>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="checkbox" id="sms1">
                            <label class="form-check-label" for="sms1">SMS 알림</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="checkbox" id="sms2">
                            <label class="form-check-label" for="sms2">SMS 발송 <span style="color:#d32f2f;">&#10068;</span></label>
                        </div>
                    </div>
                </div>

                <input type="hidden" name="formData" id="detailsClobInput">
                <input type="hidden" name="approversNo" id="approversData">

                <div class="row mb-3">
                    <div class="col-md-4 mb-2">
                        <label class="form-label">신청부서</label>
                        <div class="input-group">
                            <input type="text" id="requestDept" class="form-control" readonly>
                            <button class="btn btn-outline-secondary" type="button" id="selectRequestDeptBtn">신청부서</button>
                        </div>
                    </div>
                    <div class="col-md-4 mb-2">
                        <label class="form-label">수령희망일</label>
                        <div class="input-group">
                            <input type="date" name="desiredDate" class="form-control" min="">
                            <span class="input-group-text">📅</span>
                        </div>
                    </div>
                    <div class="col-md-4 mb-2">
                        <label class="form-label">구입사유</label>
                        <textarea class="form-control" rows="1"></textarea>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label">도서 목록</label>
                    <div class="table-responsive">
                        <table class="table table-bordered align-middle bg-white" id="bookTable">
                            <thead class="table-light">
                            <tr>
                                <th>도서명</th>
                                <th>출판사</th>
                                <th>저자</th>
                                <th>수량</th>
                                <th>금액</th>
                                <th style="width:80px; text-align:center; vertical-align:middle;">
                                    <div class="d-flex justify-content-center align-items-center" style="height:100%;">
                                        <button type="button" class="btn btn-outline-primary btn-sm" id="addBookRow">추가</button>
                                    </div>
                                </th>
                            </tr>
                            </thead>
                            <tbody id="bookTableBody">
                            <tr>
                                <td><input type="text" class="form-control"></td>
                                <td><input type="text" class="form-control"></td>
                                <td><input type="text" class="form-control"></td>
                                <td><input type="number" class="form-control book-qty" min="0"></td>
                                <td><input type="number" class="form-control book-price" min="0"></td>
                                <td class="text-center">
                                    <button type="button" class="btn btn-outline-danger btn-sm deleteBookRow">삭제</button>
                                </td>
                            </tr>
                            </tbody>
                            <tfoot>
                            <tr>
                                <td colspan="3" class="text-end fw-bold">합계</td>
                                <td id="totalQty" class="fw-bold text-end">0</td>
                                <td id="totalPrice" class="fw-bold text-end">0</td>
                                <td></td>
                            </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label">파일 업로드</label>
                    <div class="bg-light p-3 rounded border">
                        <div class="mb-2">
                            <button id="addFileBtn" class="btn btn-outline-secondary btn-sm">파일 추가</button>
                            <input type="file" id="fileInput" style="display:none;" multiple>
                            <!-- 미리보기 버튼 제거됨 -->
                        </div>
                        <div id="fileList" class="text-secondary small"></div>
                        <div class="text-end text-muted small">0% &nbsp; 0 B / 500 MB</div>
                    </div>
                </div>
                <div class="d-flex justify-content-end gap-2 mt-4">
                    <button class="btn btn-primary" id="openApprovalLine">결재선</button>
                    <button type="submit" class="btn btn-primary">결재요청</button>
<%--                    <button class="btn btn-outline-secondary">임시저장</button>--%>
                    <a href="/approval/main/draft" class="btn btn-outline-secondary">취소</a>
                </div>
            </form>
        </div>
    </div>
</main>
<footer>© 2025 그룹웨어 Corp.</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    window.setApproversInForm = function(approvers) {
        console.log('부모에서 받은 결재선:', approvers);
        renderApprovalLine(approvers);
        const nos = approvers.map(a => a.no);
        const approverNosString = nos.join(',');
        document.getElementById('approversData').value = approverNosString;
    };
</script>
<script>
    window.setReceiverDept = function(dept) {
        document.getElementById('receiverDept').value = dept;
    };

    window.setRequestDept = function(dept) {
        document.getElementById('requestDept').value = dept;
    };
    document.getElementById('selectReceiverBtn').onclick = function(e) {
        e.preventDefault();
        var popupWidth = 400;
        var popupHeight = 500;
        var left = window.screenX + (window.outerWidth - popupWidth) / 2;
        var top = window.screenY + (window.outerHeight - popupHeight) / 2;
        window.open('/approval/receiver_requestdept_popup?type=receiver', 'receiverPopup', `width=\${popupWidth},height=\${popupHeight},left=\${left},top=\${top},resizable=yes,scrollbars=yes`);
    };

    document.getElementById('addFileBtn').onclick = function(e) {
        if (e) e.preventDefault();
        document.getElementById('fileInput').click();
    };
    document.getElementById('fileInput').onchange = function(e) {
        const fileListDiv = document.getElementById('fileList');
        const files = Array.from(e.target.files);
        if (files.length === 0) {
            fileListDiv.innerHTML = '';
            return;
        }
        let html = '<ul class="mt-2 ps-3">';
        files.forEach(file => {
            html += `<li>📄 \${file.name} <span class='text-muted small'>(\${(file.size/1024).toFixed(1)} KB)</span></li>`;
        });
        html += '</ul>';
        fileListDiv.innerHTML = html;
    };

    document.getElementById('openApprovalLine').onclick = function(e) {
        e.preventDefault();
        var popupWidth = 900;
        var popupHeight = 550;
        var left = window.screenX + (window.outerWidth - popupWidth) / 2;
        var top = window.screenY + (window.outerHeight - popupHeight) / 2;
        window.open('/approval/approverPopup', 'approverPopup', `width=\${popupWidth},height=\${popupHeight},left=\${left},top=\${top},resizable=yes,scrollbars=yes`);
    };
    document.getElementById('selectRequestDeptBtn').onclick = function(e) {
        if (e) e.preventDefault();
        var popupWidth = 400;
        var popupHeight = 500;
        var left = window.screenX + (window.outerWidth - popupWidth) / 2;
        var top = window.screenY + (window.outerHeight - popupHeight) / 2;
        window.open('/approval/receiver_requestdept_popup?type=requestDept', 'requestDeptPopup', `width=\${popupWidth},height=\${popupHeight},left=\${left},top=\${top},resizable=yes,scrollbars=yes`);
    };

</script>
<script>
    function updateBookTotals() {
        let totalQty = 0;
        let totalPrice = 0;
        document.querySelectorAll('#bookTableBody tr').forEach(row => {
            const qty = parseInt(row.querySelector('.book-qty')?.value) || 0;
            const price = parseInt(row.querySelector('.book-price')?.value) || 0;
            totalQty += qty;
            totalPrice += price;
        });
        document.getElementById('totalQty').textContent = totalQty;
        document.getElementById('totalPrice').textContent = totalPrice;
    }

    function updateDeleteButtons() {
        const rows = document.querySelectorAll('#bookTableBody tr');
        const deleteButtons = document.querySelectorAll('.deleteBookRow');

        if (rows.length === 1) {
            // 책이 한 권만 있으면 삭제 버튼 비활성화
            deleteButtons.forEach(btn => {
                btn.disabled = true;
                btn.classList.add('disabled');
            });
        } else {
            // 책이 두 권 이상이면 삭제 버튼 활성화
            deleteButtons.forEach(btn => {
                btn.disabled = false;
                btn.classList.remove('disabled');
            });
        }
    }

    function addBookRow() {
        const tbody = document.getElementById('bookTableBody');
        const tr = document.createElement('tr');
        tr.innerHTML = `
      <td><input type="text" class="form-control"></td>
      <td><input type="text" class="form-control"></td>
      <td><input type="text" class="form-control"></td>
      <td><input type="number" class="form-control book-qty" min="0"></td>
      <td><input type="number" class="form-control book-price" min="0"></td>
      <td class="text-center">
        <button type="button" class="btn btn-outline-danger btn-sm deleteBookRow">삭제</button>
      </td>
    `;
        tbody.appendChild(tr);
        tr.querySelector('.deleteBookRow').onclick = function() {
            tr.remove();
            updateBookTotals();
            updateDeleteButtons();
        };
        tr.querySelector('.book-qty').oninput = updateBookTotals;
        tr.querySelector('.book-price').oninput = updateBookTotals;
        updateDeleteButtons();
    }

    document.getElementById('addBookRow').onclick = function() {
        addBookRow();
    };
    // 초기 행의 삭제/합계 이벤트 바인딩
    (function initBookTable() {
        const tbody = document.getElementById('bookTableBody');
        function bindRowEvents(tr) {
            tr.querySelector('.deleteBookRow').onclick = function() {
                tr.remove();
                updateBookTotals();
                updateDeleteButtons();
            };
            tr.querySelector('.book-qty').oninput = updateBookTotals;
            tr.querySelector('.book-price').oninput = updateBookTotals;
        }
        tbody.querySelectorAll('tr').forEach(bindRowEvents);
        updateBookTotals();
        updateDeleteButtons();
    })();
</script>
<script>
async function renderApprovalLine(approvers) {
    if (approvers.length > 0) {
        let approversNo = [];
        for (let approver of approvers) {
            approversNo.push(approver.no);
        }
        const params = new URLSearchParams();
        approversNo.forEach(no => params.append("approversNo", no));
        console.log('params', params.toString());
        console.log("url", `/approval/delegatee?\${params.toString()}`)
        const response = await fetch(`/approval/delegatee?\${params.toString()}`);
        const realApprovers = await response.json();

        const drafter = { name: '<sec:authentication property="principal.user.name"/>',
            position: '<sec:authentication property="principal.user.position.positionName"/>'};

        let html = '<table class="table table-bordered mb-0" style="width:auto; min-width:220px; max-width:600px; margin-left:auto; margin-right:0;">';
        html += '<thead><tr>';
        html += `<th class='text-center align-middle'>\${drafter.position}</th>`;
        realApprovers.forEach(appr => {
            html += `<th class='text-center align-middle'>\${appr.positionName}</th>`;
        });
        html += '</tr></thead><tbody><tr>';
        html += `<td class='text-center align-middle'>\${drafter.name}</td>`;
        realApprovers.forEach(appr => {
            html += `<td class='text-center align-middle'>\${appr.name}</td>`;
        });
        html += '</tr></tbody></table>';
        document.getElementById('approvalLinePreview').innerHTML = html;
    } else {
        const drafter = { name: '<sec:authentication property="principal.user.name"/>',
            position: '<sec:authentication property="principal.user.position.positionName"/>'};
        let html = '<table class="table table-bordered mb-0" style="width:auto; min-width:220px; max-width:600px; margin-left:auto; margin-right:0;">';
        html += '<thead><tr>';
        html += `<th class='text-center align-middle'>\${drafter.position}</th>`;
        html += '</tr></thead><tbody><tr>';
        html += `<td class='text-center align-middle'>\${drafter.name}</td>`;
        html += '</tr></tbody></table>';
        document.getElementById('approvalLinePreview').innerHTML = html;
    }
}
// 결재선이 지정되지 않았을 때 기본값(기안자만)
document.addEventListener('DOMContentLoaded', function() {
  renderApprovalLine([]);

  // 수령희망일 최소값을 오늘로 설정
  const today = new Date().toISOString().split('T')[0];
  document.querySelector('input[name="desiredDate"]').min = today;
});
// 결재선 지정 시 외부에서 window.setApprovalLine 호출
window.setApprovalLine = function(approvers) {
  renderApprovalLine(approvers || []);
};
</script>
<script>
    const form = document.getElementById('approvalForm');
    form.addEventListener('submit', function(e) {
        // 문서제목 필수 입력 검증
        const titleInput = document.querySelector('input[name="title"]');
        if (!titleInput.value.trim()) {
            e.preventDefault();
            alert('문서제목을 입력해주세요.');
            titleInput.focus();
            return;
        }

        // 구입사유 필수 입력 검증
        const reasonTextarea = document.querySelector('textarea');
        if (!reasonTextarea.value.trim()) {
            e.preventDefault();
            alert('구입사유를 입력해주세요.');
            reasonTextarea.focus();
            return;
        }

        const receiverDept = document.querySelector('input[name="receiverDepartmentName"]');
        if (!receiverDept.value.trim()) {
            e.preventDefault();
            alert('수신처를 선택해주세요.');
            receiverDept.focus();
            return;
        }

        const requestDept = document.querySelector('input[id="requestDept"]');
        if (!requestDept.value.trim()) {
            e.preventDefault();
            alert('신청부서를 선책해주세요.');
            requestDept.focus();
            return;
        }

        const desiredDate = document.querySelector('input[name="desiredDate"]');
        if (!desiredDate.value.trim()) {
            e.preventDefault();
            alert('수령희망일을 선택해주세요.');
            desiredDate.focus();
            return;
        }

        // 도서목록 필수 입력 검증
        const bookRows = document.querySelectorAll('#bookTableBody tr');
        for (let i = 0; i < bookRows.length; i++) {
            const row = bookRows[i];
            const title = row.querySelector('td:nth-child(1) input').value.trim();
            const publisher = row.querySelector('td:nth-child(2) input').value.trim();
            const author = row.querySelector('td:nth-child(3) input').value.trim();
            const quantity = row.querySelector('td:nth-child(4) input').value.trim();
            const price = row.querySelector('td:nth-child(5) input').value.trim();

            if (!title || !publisher || !author || !quantity || !price) {
                e.preventDefault();
                alert(`도서목록의 모든 항목을 입력해주세요.`);
                return;
            }
        }

        // 결재선 필수 입력 검증
        const approversData = document.getElementById('approversData').value;
        if (!approversData.trim()) {
            e.preventDefault();
            alert('결재선을 추가해주세요.');
            return;
        }

        const details = {
            requestDept: document.getElementById('requestDept').value,
            desiredDate: document.querySelector('input[name="desiredDate"]').value,
            reason     : document.querySelector('textarea').value,
            totalQty : document.querySelector('td[id="totalQty"]').textContent,
            totalPrice : document.querySelector('td[id="totalPrice"]').textContent,
            books: Array.from(document.querySelectorAll('#bookTableBody tr')).map(tr => ({
                title    : tr.querySelector('td:nth-child(1) input').value,
                publisher: tr.querySelector('td:nth-child(2) input').value,
                author   : tr.querySelector('td:nth-child(3) input').value,
                quantity : tr.querySelector('td:nth-child(4) input').value,
                price    : tr.querySelector('td:nth-child(5) input').value
            }))
        };
        document.getElementById('detailsClobInput').value = JSON.stringify(details);
        // (이후 폼은 자동 제출)
    });
</script>
<%@include file="/WEB-INF/views/chat/chatNotice.jsp" %>
<script src="<c:url value="/resources/js/chat/chatNoticeSocket.js"/>"></script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
<script>
  // 최초 연결
  connectNoticeSocket();
</script>
</body>
</html>
