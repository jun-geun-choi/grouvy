<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="modal fade" id="departmentListModal" tabindex="-1" role="dialog" aria-labelledby="departmentListModalLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="departmentListModalLabel">사용자 선택</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span>
                </button>
            </div>
            <div class="modal-body">
                <div class="input-group mb-3">
                    <input type="text" id="searchKeywordModal" class="form-control" placeholder="부서명 또는 사용자명 검색">
                    <div class="input-group-append">
                        <button class="btn btn-outline-secondary" type="button" onclick="searchTreeModal()">검색</button>
                    </div>
                </div>
                <div id="orgChartTreeModal" style="max-height: 400px; overflow-y: auto;">
                    <p>조직도 데이터를 불러오는 중...</p>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>

<style>
    .dept-list {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .dept-item {
        margin-bottom: 3px;
    }

    .department-name {
        font-weight: bold;
        color: #333;
        cursor: pointer;
        padding: 5px 0;
        display: block;
    }

    .department-name:hover {
        background-color: #f0f0f0;
    }

    .toggle-icon {
        display: inline-block;
        transition: transform 0.2s ease-in-out;
        margin-right: 5px;
        color: #555;
        font-size: 0.8em;
    }

    .department-name.expanded .toggle-icon {
        transform: rotate(90deg);
    }

    .user-list {
        list-style: none;
        padding: 0;
        margin-left: 20px;
        display: none; /* 초기에는 숨김 */
    }

    .user-list.expanded-users {
        display: block;
    }

    .dept-list.child-dept-list {
        margin-left: 20px;
    }

    .user-item {
        font-size: 0.9em;
        color: #555;
        margin-bottom: 2px;
        padding: 3px 0;
    }

    .user-item a { /* 사용자 클릭 가능한 링크 스타일 */
        color: #007bff;
        text-decoration: none;
        display: inline-block; /* 또는 block, flex 사용 시 필요 없음 */
        max-width: calc(100% - 20px); /* 토글 아이콘 등을 고려한 최대 너비 */
        overflow: hidden;
        white-space: nowrap;
        text-overflow: ellipsis;
        vertical-align: middle; /* 텍스트와 아이콘 정렬 */
    }

    .user-item a:hover {
        text-decoration: underline;
    }

    /* 들여쓰기 레벨 (0부터 시작) */
    .indent-level-0 {
        margin-left: 0px;
    }

    .indent-level-1 {
        margin-left: 20px;
    }

    .indent-level-2 {
        margin-left: 40px;
    }

    .indent-level-3 {
        margin-left: 60px;
    }

    .indent-level-4 {
        margin-left: 80px;
    }
</style>

<script>
    let modalOrgChartDataCache = null;
    let expandedDepartmentIds = new Set();

    document.addEventListener('DOMContentLoaded', function () {
        $('#departmentListModal').on('shown.bs.modal', function () {
            if (modalOrgChartDataCache) {
                const orgChartTreeModal = document.getElementById('orgChartTreeModal');
                orgChartTreeModal.innerHTML = '';
                document.getElementById('searchKeywordModal').value = '';
                renderDepartmentTreeModal(modalOrgChartDataCache, orgChartTreeModal, 0, '', expandedDepartmentIds);
                setupEventListenersModal();
            } else {
                loadOrgChartTreeModal();
            }
        });

        $('#departmentListModal').on('hidden.bs.modal', function () {
            expandedDepartmentIds.clear();
            document.querySelectorAll('#departmentListModal .department-name.expanded').forEach(deptNameElement => {
                const departmentId = deptNameElement.dataset.departmentId;
                if (departmentId) {
                    expandedDepartmentIds.add(parseInt(departmentId, 10));
                }
            });
            console.log("모달 닫힘: 저장된 열린 부서 ID:", Array.from(expandedDepartmentIds));
        });
    });

    async function loadOrgChartTreeModal(keyword = '') {
        const orgChartTreeModal = document.getElementById('orgChartTreeModal');
        orgChartTreeModal.innerHTML = '<p>조직도 데이터를 불러오는 중...</p>';

        try {
            const response = await fetch('/api/v1/dept/tree');

            if (!response.ok) {
                throw new Error(`HTTP 요청 실패! 상태코드: \${response.status}`);
            }

            const departmentTreeData = await response.json();
            modalOrgChartDataCache = departmentTreeData;
            orgChartTreeModal.innerHTML = '';

            renderDepartmentTreeModal(departmentTreeData, orgChartTreeModal, 0, keyword, expandedDepartmentIds);
            setupEventListenersModal();

        } catch (error) {
            console.error('조직도 데이터를 불러오는 중 오류 발생:', error);
            orgChartTreeModal.innerHTML = `<p style="color:red;">조직도 데이터를 불러오는 데 실패했습니다. 오류: \${error.message}</p>`;
        }
    }

    function renderDepartmentTreeModal(departments, parentElement, level = 0, keyword = '', expandedIdsSet = new Set()) {
        if (!departments || departments.length === 0) {
            return;
        }

        const ul = document.createElement('ul');
        if (parentElement.id !== 'orgChartTreeModal') {
            ul.className = 'dept-list child-dept-list';
        } else {
            ul.className = 'dept-list';
        }

        departments.forEach(department => {
            const currentIndentLevel = (department.level != null) ? department.level - 1 : 0;
            const li = document.createElement('li');
            li.className = `dept-item indent-level-${currentIndentLevel}`;

            const deptNameContainer = document.createElement('span');
            deptNameContainer.className = `department-name department-level-${currentIndentLevel}`;
            if (department.departmentId) {
                deptNameContainer.dataset.departmentId = `\${department.departmentId}`;
            }

            const toggleIcon = document.createElement('span');
            toggleIcon.className = 'toggle-icon';
            if ((department.users && department.users.length > 0) || (department.children && department.children.length > 0)) {
                toggleIcon.textContent = '▶';
            } else {
                toggleIcon.textContent = '';
            }
            deptNameContainer.appendChild(toggleIcon);

            const deptText = document.createTextNode(String(department.departmentName || '부서명 없음'));
            deptNameContainer.appendChild(deptText);
            li.appendChild(deptNameContainer);

            const userListUl = document.createElement('ul');
            userListUl.className = 'user-list';

            if (department.users && department.users.length > 0) {
                department.users.forEach(user => {
                    if (!user || (!user.userId && !user.name)) {
                        const userLi = document.createElement('li');
                        userLi.className = 'user-item';
                        userLi.style.fontStyle = 'italic';
                        userLi.style.color = '#888';
                        userLi.textContent = '유효하지 않은 사용자 데이터';
                        userListUl.appendChild(userLi);
                        return;
                    }

                    const userLi = document.createElement('li');
                    userLi.className = 'user-item';
                    userLi.innerHTML = `\
                        <a href="#" class="user-link-modal" data-user-id="\${user.userId}" data-user-name="\${user.name}">\
                            \${highlightKeywordModal(String(user.name || '이름없음'), keyword)} (\${String(user.email || '이메일없음')})\
                        </a>\
                    `;
                    userListUl.appendChild(userLi);
                });
            } else {
                const noUserLi = document.createElement('li');
                noUserLi.className = 'user-item';
                noUserLi.style.fontStyle = 'italic';
                noUserLi.style.color = '#888';
                noUserLi.textContent = '소속된 사용자가 없습니다.';
                userListUl.appendChild(noUserLi);
            }
            li.appendChild(userListUl);

            if (department.children && department.children.length > 0) {
                renderDepartmentTreeModal(department.children, li, level + 1, keyword, expandedIdsSet);
            }

            ul.appendChild(li);

            if (department.departmentId && expandedIdsSet.has(department.departmentId)) {
                deptNameContainer.classList.add('expanded');
                if (userListUl) userListUl.classList.add('expanded-users');
                const childDeptList = li.querySelector('.child-dept-list');
                if (childDeptList) childDeptList.classList.add('expanded-users');
                toggleIcon.style.transform = 'rotate(90deg)';
            }
        });
        parentElement.appendChild(ul);
    }

    function searchTreeModal() {
        const keyword = document.getElementById('searchKeywordModal').value;
        const orgChartTreeModal = document.getElementById('orgChartTreeModal');
        orgChartTreeModal.innerHTML = '';

        if (modalOrgChartDataCache) {
            renderDepartmentTreeModal(modalOrgChartDataCache, orgChartTreeModal, 0, keyword, new Set());
            setupEventListenersModal();
        } else {
            alert('조직도 데이터가 아직 로드되지 않았습니다. 잠시 후 다시 시도해주세요.');
            loadOrgChartTreeModal(keyword);
        }
    }

    function setupEventListenersModal() {

        document.querySelectorAll('#departmentListModal .department-name').forEach(deptNameElement => {
            if (!deptNameElement.dataset.listenerAddedDept) {
                deptNameElement.addEventListener('click', function (event) {
                    const deptItem = deptNameElement.closest('.dept-item');
                    if (!deptItem) return;

                    const userList = deptItem.querySelector('.user-list');
                    const toggleIcon = deptNameElement.querySelector('.toggle-icon');
                    const childDeptList = deptItem.querySelector('.child-dept-list');

                    let isExpanded = false;
                    if (userList) {
                        userList.classList.toggle('expanded-users');
                    }
                    if (childDeptList) {
                        childDeptList.classList.toggle('expanded-users');
                    }

                    deptNameElement.classList.toggle('expanded');
                    isExpanded = deptNameElement.classList.contains('expanded');

                    if (toggleIcon) {
                        if (isExpanded) {
                            toggleIcon.style.transform = 'rotate(90deg)';
                            const departmentId = deptNameElement.dataset.departmentId;
                            if (departmentId) expandedDepartmentIds.add(parseInt(departmentId, 10));
                        } else {
                            toggleIcon.style.transform = 'rotate(0deg)';
                            const departmentId = deptNameElement.dataset.departmentId;
                            if (departmentId) expandedDepartmentIds.delete(parseInt(departmentId, 10));
                        }
                    }
                });
                deptNameElement.dataset.listenerAddedDept = 'true';
            }
        });

        document.querySelectorAll('#departmentListModal .user-link-modal').forEach(link => {
            if (!link.dataset.listenerAddedUser) {
                link.addEventListener('click', function (event) {
                    event.preventDefault();
                    const userId = parseInt(this.dataset.userId, 10);
                    const userName = this.dataset.userName;

                    if (typeof window.addSelectedUser === 'function' && typeof window.currentRecipientType === 'string' && window.currentRecipientType !== '') {
                        window.addSelectedUser(window.currentRecipientType, userId, userName);
                    } else {
                        console.error('window.addSelectedUser 함수가 정의되지 않았거나 window.currentRecipientType이 설정되지 않았습니다.');
                    }
                });
                link.dataset.listenerAddedUser = 'true';
            }
        });
    }

    function highlightKeywordModal(text, keyword) {
        if (!keyword) return text;
        const regex = new RegExp(`(\${keyword})`, 'gi');
        return text.replace(regex, '<mark>$1</mark>');
    }
</script>