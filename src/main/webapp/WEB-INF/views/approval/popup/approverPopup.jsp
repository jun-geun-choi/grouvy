<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>결재선지정</title>
  <meta name="viewport" content="width=900, initial-scale=1.0">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      margin: 0;
      font-family: Arial, sans-serif;
      background-color: #fff;
      color: #333;
    }
    .popup-wrap {
      background: #fff;
      width: 900px;
      max-width: 98vw;
      min-height: 540px;
      border-radius: 4px;
      box-shadow: none;
      margin: 0;
      display: flex;
      flex-direction: column;
      padding: 0;
    }
    .popup-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 16px 24px 12px 24px;
      border-bottom: none;
    }
    .popup-title {
      font-size: 22px;
      font-weight: bold;
      color: #e6002d;
    }
    .popup-close {
      background: none;
      border: none;
      font-size: 32px;
      line-height: 1;
      cursor: pointer;
      color: #888;
      transition: color 0.2s;
    }
    .popup-close:hover {
      color: #e6002d;
    }
    .popup-body {
      display: flex;
      flex: 1;
      min-height: 400px;
      padding: 0 24px 24px 24px;
      gap: 24px;
    }
    .org-tree {
      width: 280px;
      background: #f8f9fa;
      border-radius: 8px;
      border: none;
      padding: 16px 12px;
      display: flex;
      flex-direction: column;
      min-height: 400px;
    }
    .org-tabs {
      display: flex;
      gap: 4px;
      margin-bottom: 10px;
    }
    .org-tab {
      padding: 4px 16px;
      border: 1px solid #ccc;
      border-bottom: none;
      border-radius: 6px 6px 0 0;
      background: #f8f9fb;
      font-size: 15px;
      cursor: pointer;
    }
    .org-tab.active {
      background: #fff;
      font-weight: bold;
      border-bottom: 1px solid #fff;
    }
    .org-search {
      margin-bottom: 10px;
    }
    .org-search input {
      width: 100%;
      font-size: 15px;
      border-radius: 4px;
      border: 1px solid #ccc;
      padding: 6px 10px;
    }
    .org-list {
      font-size: 15px;
      line-height: 2;
      user-select: none;
    }
    .org-user {
      display: flex;
      align-items: center;
      gap: 4px;
      cursor: pointer;
      padding: 2px 4px;
      border-radius: 4px;
      transition: background 0.15s;
    }
    .org-user.selected {
      background: #e0e7ff;
    }
    .org-user .icon {
      font-size: 16px;
    }
    .org-user .name {
      font-weight: 500;
    }
    .approval-panel {
      flex: 1;
      padding: 18px 0 0 0;
      display: flex;
      flex-direction: column;
    }
    .approval-title {
      font-size: 18px;
      font-weight: bold;
      margin-bottom: 12px;
      color: #333;
    }
    .approval-list-wrap {
      display: flex;
      gap: 16px;
    }
    .approval-list-box {
      background: #f8f9fb;
      border: none;
      border-radius: 8px;
      flex: 1;
      min-width: 180px;
      padding: 8px 0;
      position: relative;
    }
    .approval-list-label {
      font-size: 14px;
      color: #888;
      padding: 0 8px 4px 8px;
    }
    .approval-list {
      min-height: 80px;
      padding: 0 8px;
      /* 중앙 안내문구가 잘 보이도록 min-height를 늘릴 수 있음 */
      min-height: 120px;
    }
    .approval-item {
      display: flex;
      align-items: center;
      gap: 8px;
      background: #fff;
      border: 1px solid #d1d5db;
      border-radius: 6px;
      margin-bottom: 6px;
      padding: 6px 10px;
      font-size: 15px;
      cursor: grab;
    }
    .approval-item:last-child { margin-bottom: 0; }
    .approval-item.dragging { opacity: 0.5; }
    .approval-item .role {
      font-size: 13px;
      color: #888;
      margin-right: 6px;
    }
    .approval-item .remove-btn {
      margin-left: auto;
      color: #e6002d;
      background: none;
      border: none;
      font-size: 16px;
      cursor: pointer;
    }
    .approval-controls {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      gap: 8px;
      margin: 0 8px;
    }
    .approval-controls button {
      width: 32px;
      height: 32px;
      border-radius: 50%;
      border: 1px solid #ccc;
      background: #fff;
      font-size: 18px;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      color: #333;
      transition: background 0.15s, color 0.15s;
    }
    .approval-controls button:disabled {
      opacity: 0.4;
      cursor: not-allowed;
    }
    .approval-controls button:hover:not(:disabled) {
      background: #f5f5f5;
      color: #1abc9c;
    }
    .approval-info-box {
      margin-top: 16px;
      display: flex;
      gap: 24px;
      align-items: center;
      flex-wrap: wrap;
    }
    .approval-info-box label {
      font-size: 15px;
      min-width: 90px;
      margin-bottom: 0;
      margin-right: 8px;
    }
    .approval-info-box select,
    .approval-info-box input[type=text] {
      padding: 6px 10px;
      font-size: 15px;
      border: 1px solid #ccc;
      border-radius: 4px;
      min-width: 110px;
      max-width: 180px;
      margin-right: 16px;
    }
    .approval-info-box input[type=checkbox] {
      margin-left: 8px;
    }
    .approval-footer {
      display: flex;
      gap: 8px;
      justify-content: flex-end;
      margin-top: 24px;
    }
    .approval-footer button {
      padding: 8px 32px;
      font-size: 15px;
      border-radius: 4px;
      border: none;
      cursor: pointer;
      transition: background 0.15s, color 0.15s;
    }
    .approval-footer .main {
      background: #1abc9c;
      color: #fff;
    }
    .approval-footer .main:hover {
      background: #16a085;
    }
    .approval-footer .cancel {
      background: #e5e7eb;
      color: #222;
    }
    .approval-footer .cancel:hover {
      background: #ccc;
    }
    .popup-footer {
      font-size: 13px;
      color: #999;
      padding: 8px 24px 16px 24px;
      text-align: left;
    }
    #approvalListHint {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      width: 100%;
      pointer-events: none;
      z-index: 2;
      font-size: 15px;
    }
    @media (max-width: 1000px) {
      .popup-wrap {
        width: 99vw;
        margin: 0;
      }
    }
  </style>
</head>
<body>
<sec:authentication property="principal.user.name" var="userName"/>
<div class="popup-wrap">
  <div class="popup-header">
    <span class="popup-title">결재선지정</span>
    <button class="popup-close" onclick="window.close()">&times;</button>
  </div>
  <div class="popup-body" style="display: flex; gap: 24px; align-items: flex-start;">
    <!-- 왼쪽: 조직도/검색 -->
    <div class="org-tree" style="width: 320px; min-width: 220px;">
      <div class="org-tabs">
        <div class="org-tab active">조직도</div>
        <div class="org-tab">검색</div>
      </div>
      <div class="org-search">
        <input type="text" id="orgSearch" placeholder="검색">
      </div>
      <div class="org-list" id="orgList">
        <!-- 트리 구조로 동적 생성 -->
      </div>
    </div>
    <!-- 가운데: 세로 버튼 -->
    <div class="approval-controls" style="display: flex; flex-direction: column; align-items: center; gap: 8px; margin-top: 120px;">
      <button id="addApproverBtn" title="추가" data-bs-toggle="tooltip" data-bs-placement="right" disabled style="width: 32px; height: 32px; font-size: 18px;">&#8594;</button>
      <button id="removeApproverBtn" title="제거" data-bs-toggle="tooltip" data-bs-placement="right" disabled style="width: 32px; height: 32px; font-size: 18px;">&#8592;</button>
      <button id="resetApproverBtn" title="초기화" data-bs-toggle="tooltip" data-bs-placement="right" style="width: 32px; height: 32px; font-size: 18px;">&#8634;</button>
    </div>
    <!-- 오른쪽: 결재선 정보 -->
    <div class="approval-panel" style="flex: 1; min-width: 340px;">
      <div class="approval-title" style="font-size: 22px; font-weight: bold; color: #222; margin-bottom: 18px;">결재선 정보</div>
      <div class="approval-list-box" style="background: #f8f9fb; border-radius: 8px; padding: 18px 18px 18px 18px; min-height: 140px; margin-bottom: 18px;">
        <div class="approval-list-label" style="font-size: 16px; color: #888; margin-bottom: 8px;">결재선</div>
        <div class="approval-list" id="approvalList" ondragover="event.preventDefault()" style="min-height: 80px; font-size: 16px;"></div>
        <div id="approvalListHint" class="text-secondary text-center py-3" style="display:none; font-size:16px;">선택한 결재자가 여기에 표시됩니다.</div>
      </div>
      <div class="approval-info-box align-items-center" style="display: flex; gap: 12px; margin-bottom: 18px;">
        <label for="approvalName" class="me-2" style="font-size: 15px; min-width: 120px;">사용자 결재선명</label>
        <input id="approvalName" type="text" class="form-control d-inline-block w-auto" style="width:220px;" placeholder="결재선명을 입력하세요">
        <button id="saveApprovalBtn" class="btn btn-success btn-sm ms-2" title="결재선을 저장" data-bs-toggle="tooltip" data-bs-placement="top">저장(결재선을 저장)</button>
      </div>
      <div class="approval-footer mt-4" style="display: flex; gap: 12px; justify-content: flex-start;">
        <button id="applyBtn" class="main" title="선택한 결재선을 적용" data-bs-toggle="tooltip" data-bs-placement="top" style="background: #1abc9c; color: #fff; min-width: 90px;">적용</button>
        <button id="closeBtn" class="cancel" title="팝업 종료" data-bs-toggle="tooltip" data-bs-placement="top" style="background: #e5e7eb; color: #222; min-width: 90px;" onclick="window.close()">닫기</button>
      </div>
    </div>
  </div>
  <div class="popup-footer">
    <span style="color:#e6002d;font-size:15px;">&#9888;</span> Ctrl버튼을 누르고 선택하면 다중선택 가능, 결재선은 Drag&Drop하여 결재순서를 변경할 수 있습니다.
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // 트리 데이터 구조
  const orgTreeData = [
    {
      name:"우리회사",
      children: []
    }
  ];



  // 트리 렌더링 함수
  function renderOrgTree(container, nodes, depth = 0) {
    nodes.forEach((node, idx) => {
      if (node.type === 'user') {
        const userDiv = document.createElement('div');
        userDiv.className = 'org-user';
        userDiv.style.marginLeft = (depth * 16 + 24) + 'px';
        userDiv.setAttribute('data-empNo', node.no);
        userDiv.setAttribute('data-name', node.name);
        userDiv.setAttribute('data-position', node.positionName);
        userDiv.innerHTML = `
            <span class="icon" style="color:\${node.color}">\${node.icon}</span>
            <span class="name">\${node.name}</span>
            <span class="position">\${node.positionName}</span>
        `;
        container.appendChild(userDiv);
      } else {
        const branchDiv = document.createElement('div');
        branchDiv.className = 'org-branch';
        branchDiv.style.display = 'flex';
        branchDiv.style.alignItems = 'center';
        branchDiv.style.marginLeft = (depth * 16) + 'px';
        branchDiv.style.userSelect = 'none';
        // 트리 토글 아이콘
        const toggle = document.createElement('span');
        toggle.className = 'org-toggle';
        toggle.style.cursor = 'pointer';
        toggle.style.display = 'inline-block';
        toggle.style.width = '18px';
        toggle.style.textAlign = 'center';
        toggle.innerHTML = node.children && node.children.length > 0 ? '▶' : '';
        branchDiv.appendChild(toggle);
        // 부서명
        const dept = document.createElement('b');
        dept.textContent = node.name;
        branchDiv.appendChild(dept);
        container.appendChild(branchDiv);
        // 하위 트리
        let childWrap = null;
        if (node.children && node.children.length > 0) {
          childWrap = document.createElement('div');
          childWrap.className = 'org-children';
          childWrap.style.display = (depth === 0) ? '' : 'none';
          toggle.innerHTML = (depth === 0) ? '▼' : '▶';
          renderOrgTree(childWrap, node.children, depth + 1);
          container.appendChild(childWrap);
          toggle.onclick = function(e) {
            e.stopPropagation();
            if (childWrap.style.display === 'none') {
              childWrap.style.display = '';
              toggle.innerHTML = '▼';
            } else {
              childWrap.style.display = 'none';
              toggle.innerHTML = '▶';
            }
          };
        }
      }
    });
  }

  // 트리 초기 렌더링
  const orgList = document.getElementById('orgList');
  orgList.innerHTML = '';


  (async function() {
    const response1 = await fetch('depts');
    const depts = await response1.json();

    const response2 = await fetch('emps');
    const emps = await response2.json();

    console.log(depts);
    console.log(emps);

    let specialEmps = [];

    for (let emp of emps) {
      if (emp.departmentId === 1) {
        specialEmps.push(emp);
      } else if (emp.departmentId === 2) {
        specialEmps.push(emp);
      } else if (emp.departmentId === 3) {
        specialEmps.push(emp);
      } else if (emp.departmentId === 4) {
        specialEmps.push(emp);
      } else if (emp.departmentId === 5) {
        specialEmps.push(emp);
      }
    }


    console.log(specialEmps);

    for (let dept of depts) {
      let foundNode = getParentNode(orgTreeData[0].children, dept.parentDepartmentId);
      let node = {
        no: dept.departmentId,
        name: dept.departmentName,
        pno: dept.parentDepartmentId,
        children: []
      };

      let specialEmp = specialEmps.find(emp => emp.departmentId === dept.departmentId);
      if (specialEmp) {
        node.children.push({
          no: specialEmp.empNo,
          name: specialEmp.name,
          icon: '🌱',
          color: '#28a745',
          positionName: specialEmp.positionName,
          type: 'user'
        });
      }

      if (foundNode == null) {
        orgTreeData[0].children.push(node);
      } else {
        foundNode.children.push(node);
      }
    }


    for (let emp of emps) {
      // specialEmps에 이미 추가된 사람은 제외
      if ([1, 2, 3, 4, 5].includes(emp.departmentId)) continue;

      let foundNode = getParentNode(orgTreeData[0].children, emp.departmentId);
      if (foundNode != null) {
        let node = {
          no: emp.empNo,
          name: emp.name,
          icon: '🌱',
          color: '#28a745',
          positionName: emp.positionName,
          type: 'user'
        };
        foundNode.children.push(node);
      }
    }

    // 트리 초기 렌더링
    renderOrgTree(orgList, orgTreeData[0].children);

    bindOrgUserEvents();
  })();

  function getParentNode(nodes, pno) {
    for (const node of nodes) {
      if (node.no === pno) {
        return node;
      }

      if (Array.isArray(node.children)) {
        const found = getParentNode(node.children, pno);
        if (found) return found;
      }
    }
    return null;
  }

  // 조직도 사용자 선택 (트리 렌더 후 바인딩)
  function bindOrgUserEvents() {
    let selectedUsers = [];
    let orgUsers = Array.from(document.querySelectorAll('.org-user'));
    orgUsers.forEach(user => {
      user.addEventListener('click', function(e) {
        if (e.ctrlKey) {
          if (selectedUsers.includes(this)) {
            this.classList.remove('selected');
            selectedUsers = selectedUsers.filter(u => u !== this);
          } else {
            this.classList.add('selected');
            selectedUsers.push(this);
          }
        } else {
          orgUsers.forEach(u => u.classList.remove('selected'));
          selectedUsers = [this];
          this.classList.add('selected');
        }
        document.getElementById('addApproverBtn').disabled = selectedUsers.length === 0;
      });
    });
    // expose for addBtn
    window._selectedUsers = selectedUsers;
    window._orgUsers = orgUsers;
  }

  // 결재선 추가/제거/초기화
  const approvalList = document.getElementById('approvalList');
  const addBtn = document.getElementById('addApproverBtn');
  const removeBtn = document.getElementById('removeApproverBtn');
  const resetBtn = document.getElementById('resetApproverBtn');
  let approvers = [];
  let dragIndex = null;

  function renderApprovers() {
    approvalList.innerHTML = '';
    if (approvers.length === 0) {
      document.getElementById('approvalListHint').style.display = '';
    } else {
      document.getElementById('approvalListHint').style.display = 'none';
    }
    approvers.forEach((a, idx) => {
      const div = document.createElement('div');
      div.className = 'approval-item';
      div.draggable = true;
      div.innerHTML = `
        <span class=\"role\">\${idx === approvers.length-1 ? '최종' : '결재'}</span>
        \${a.label}
        <button class=\"remove-btn\" title=\"제거\">✖</button>`;
      div.addEventListener('dragstart', function() {
        dragIndex = idx;
        div.classList.add('dragging');
      });
      div.addEventListener('dragend', function() {
        dragIndex = null;
        div.classList.remove('dragging');
      });
      div.addEventListener('dragover', function(e) {
        e.preventDefault();
      });
      div.addEventListener('drop', function(e) {
        e.preventDefault();
        if (dragIndex !== null && dragIndex !== idx) {
          const moved = approvers.splice(dragIndex, 1)[0];
          approvers.splice(idx, 0, moved);
          renderApprovers();
        }
      });
      div.querySelector('.remove-btn').onclick = function() {
        approvers.splice(idx, 1);
        renderApprovers();
      };
      approvalList.appendChild(div);
    });
    removeBtn.disabled = approvers.length === 0;
  }


  addBtn.onclick = function() {
    // 항상 최신 선택 상태를 DOM에서 가져옴
    let orgUsers = Array.from(document.querySelectorAll('.org-user'));
    let selectedUsers = orgUsers.filter(u => u.classList.contains('selected'));

    selectedUsers.forEach(u => {
      const no = u.getAttribute('data-empNo');
      const name = u.getAttribute('data-name');
      const position = u.getAttribute('data-position');
      const label = `\${name} \${position}`;

      const writerName = "${userName}";

      if(writerName === name) {
          alert("기안자는 결재선에 추가할 수 없습니다.");
          return;
      }

      // 동일인물 중복 체크 (사원번호로 확인)
      const isDuplicate = approvers.some(approver => approver.no === no);
      
      if (!isDuplicate) {
        approvers.push({no, name, position, label});
      } else {
        // 중복된 경우 알림 표시
        alert(`'\${name}'은(는) 이미 결재선에 추가되어 있습니다.`);
      }
    });
    renderApprovers();
    orgUsers.forEach(u => u.classList.remove('selected'));
    window._selectedUsers = [];
    addBtn.disabled = true;
  };
  removeBtn.onclick = function() {
    approvers.pop();
    renderApprovers();
  };
  resetBtn.onclick = function() {
    approvers = [];
    renderApprovers();
  };
  approvalList.ondragover = function(e) { e.preventDefault(); };
  renderApprovers();

  // 트리 렌더 후 사용자 이벤트 재바인딩
  setTimeout(bindOrgUserEvents, 0);

  // Tooltip 활성화
  document.addEventListener('DOMContentLoaded', function () {
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.forEach(function (tooltipTriggerEl) {
      new bootstrap.Tooltip(tooltipTriggerEl);
    });
  });

  applyBtn.onclick = function() {
    window.close();
    window.opener.setApproversInForm(approvers);
  }
</script>
</body>
</html> 