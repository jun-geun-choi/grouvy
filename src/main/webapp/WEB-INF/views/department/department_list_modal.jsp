<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="modal fade" id="departmentListModal" tabindex="-1" aria-labelledby="departmentListModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="departmentListModalLabel">사용자 선택</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div id="orgChartTreeModal" style="max-height: 400px; overflow-y: auto;">
                    <p>조직도 데이터를 불러오는 중...</p>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>

<style>
    .dept-list { list-style: none; padding: 0; margin: 0; }
    .dept-item { margin-bottom: 3px; }
    .department-name { font-weight: bold; color: #333; cursor: pointer; padding: 5px 0; display: block; }
    .department-name:hover { background-color: #f0f0f0; }
    .toggle-icon { display: inline-block; transition: transform 0.2s ease-in-out; margin-right: 5px; color: #555; font-size: 0.8em; }
    .department-name.expanded .toggle-icon { transform: rotate(90deg); }
    .child-dept-list { list-style: none; padding: 0; margin-left: 20px; }
    .user-list { list-style: none; padding: 0; margin-left: 20px; display: none; }
    .user-list.expanded-users { display: block; }
    .user-item { font-size: 0.9em; color: #555; margin-bottom: 2px; padding: 3px 0; }
    .user-item a { color: #007bff; text-decoration: none; display: inline-block; }
    .user-item a:hover { text-decoration: underline; }
    .indent-level-0 { margin-left: 0px; }
    .indent-level-1 { margin-left: 20px; }
    .indent-level-2 { margin-left: 40px; }
</style>

<script>
    let modalOrgChartDataCache = null;
    let expandedDepartmentIds = new Set();

    document.addEventListener('DOMContentLoaded', function () {
        const modalElement = document.getElementById('departmentListModal');
        const orgChartTreeContainer = document.getElementById('orgChartTreeModal');

        modalElement.addEventListener('shown.bs.modal', function () {
            if (modalOrgChartDataCache) {
                renderDepartmentTree(modalOrgChartDataCache, orgChartTreeContainer, expandedDepartmentIds);
            } else {
                loadOrgChartTree();
            }
        });

        orgChartTreeContainer.addEventListener('click', function (event) {
            const departmentName = event.target.closest('.department-name');
            if (departmentName) {
                toggleDepartment(departmentName);
                return;
            }

            const userLink = event.target.closest('.user-link-modal');
            if (userLink) {
                event.preventDefault();
                const userId = parseInt(userLink.dataset.userId, 10);
                const userName = userLink.dataset.userName;
                if (window.addSelectedUser) {
                    window.addSelectedUser(window.currentRecipientType, userId, userName);
                }
            }
        });
    });

    async function loadOrgChartTree() {
        const orgChartTreeModal = document.getElementById('orgChartTreeModal');
        orgChartTreeModal.innerHTML = '<p>조직도 데이터를 불러오는 중...</p>';
        try {
            const response = await fetch('/api/v1/dept/tree');
            if (!response.ok) throw new Error(`HTTP 요청 실패: \${response.status}`);

            modalOrgChartDataCache = await response.json();
            renderDepartmentTree(modalOrgChartDataCache, orgChartTreeModal, expandedDepartmentIds);

        } catch (error) {
            console.error('조직도 데이터 로딩 오류:', error);
            orgChartTreeModal.innerHTML = `<p style="color:red;">조직도 데이터를 불러오는 데 실패했습니다.</p>`;
        }
    }

    function toggleDepartment(departmentElement) {
        const deptItem = departmentElement.closest('.dept-item');
        if (!deptItem) return;

        const departmentIdStr = departmentElement.dataset.departmentId;
        const departmentId = departmentIdStr ? parseInt(departmentIdStr, 10) : null;

        const isExpanded = departmentElement.classList.toggle('expanded');

        const userList = deptItem.querySelector(':scope > .user-list');
        if (userList) {
            userList.classList.toggle('expanded-users', isExpanded);
        }

        if (departmentId !== null) {
            if (isExpanded) {
                expandedDepartmentIds.add(departmentId);
            } else {
                expandedDepartmentIds.delete(departmentId);
            }
        }
    }

    function renderDepartmentTree(departments, parentElement, expandedIdsSet) {
        parentElement.innerHTML = '';
        if (!departments || departments.length === 0) {
            parentElement.innerHTML = '<p>표시할 데이터가 없습니다.</p>';
            return;
        }

        const fragment = document.createDocumentFragment();
        const rootUl = document.createElement('ul');
        rootUl.className = 'dept-list';

        function buildTree(nodes, parentUl, currentLevel) {
            nodes.forEach(department => {
                const li = document.createElement('li');
                const indentLevel = department.level != null ? department.level - 1 : currentLevel;
                li.className = `dept-item indent-level-\${indentLevel}`;

                const hasToggleContent = (department.users && department.users.length > 0);
                const isExpanded = department.departmentId && expandedIdsSet.has(department.departmentId);

                const deptNameContainer = document.createElement('span');
                deptNameContainer.className = `department-name \${isExpanded ? 'expanded' : ''}`;
                if (department.departmentId) deptNameContainer.dataset.departmentId = department.departmentId;
                deptNameContainer.innerHTML = `
                    <span class="toggle-icon">\${hasToggleContent ? '▶' : ''}</span>
                    \${String(department.departmentName || '부서명 없음')}
                `;

                const userListUl = document.createElement('ul');
                userListUl.className = `user-list \${isExpanded ? 'expanded-users' : ''}`;
                if (department.users && department.users.length > 0) {
                    userListUl.innerHTML = department.users.map(user => {
                        if (!user || !user.userId) return '';
                        return `
                            <li class="user-item">
                                <a href="#" class="user-link-modal" data-user-id="\${user.userId}" data-user-name="\${user.name}">
                                    \${String(user.name || '이름없음')} (\${String(user.email || '이메일없음')})
                                </a>
                            </li>`;
                    }).join('');
                }

                li.appendChild(deptNameContainer);
                li.appendChild(userListUl);

                if (department.children && department.children.length > 0) {
                    const childDeptUl = document.createElement('ul');
                    childDeptUl.className = 'dept-list child-dept-list';
                    buildTree(department.children, childDeptUl, currentLevel + 1);
                    li.appendChild(childDeptUl);
                }
                parentUl.appendChild(li);
            });
        }

        buildTree(departments, rootUl, 0);
        fragment.appendChild(rootUl);
        parentElement.appendChild(fragment);
    }
</script>