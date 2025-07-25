<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Department List Modal -->
<!--
**중요 수정:**
1. aria-hidden="true"를 초기 HTML에서 제거했습니다.
Bootstrap이 모달의 display 상태에 따라 이 속성을 자동으로 관리합니다.
-->
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
                <!-- 검색 폼 -->
                <div class="input-group mb-3">
                    <input type="text" id="searchKeywordModal" class="form-control" placeholder="부서명 또는 사용자명 검색">
                    <div class="input-group-append">
                        <button class="btn btn-outline-secondary" type="button" onclick="searchTreeModal()">검색</button>
                    </div>
                </div>
                <!-- 조직도 표시 영역 -->
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
    /* organization_chart.jsp 에서 가져온 스타일 복사 (이 모달에만 적용) */
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
        /* 추가: 텍스트가 길어질 때 잘림 처리 */
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
    .indent-level-0 { margin-left: 0px; }
    .indent-level-1 { margin-left: 20px; }
    .indent-level-2 { margin-left: 40px; }
    .indent-level-3 { margin-left: 60px; }
    .indent-level-4 { margin-left: 80px; }
</style>

<script>
    // 조직도 데이터를 캐싱할 변수 (이 모달 스크립트 내에서만 유효)
    let modalOrgChartDataCache = null;
    // ⭐ 추가: 열려있는 부서 ID를 저장할 Set
    let expandedDepartmentIds = new Set();

    document.addEventListener('DOMContentLoaded', function() {
        // 모달이 열릴 때마다 조직도를 다시 로드하도록 변경 (이제 캐시된 데이터 사용)
        $('#departmentListModal').on('shown.bs.modal', function () {
            // 캐시된 데이터가 있으면 즉시 렌더링, 없으면 로드 시도
            if (modalOrgChartDataCache) {
                const orgChartTreeModal = document.getElementById('orgChartTreeModal');
                orgChartTreeModal.innerHTML = ''; // 기존 내용 초기화
                document.getElementById('searchKeywordModal').value = ''; // 검색어 필드 초기화
                // ⭐ 토글 상태 유지를 위해 expandedDepartmentIds Set 전달
                renderDepartmentTreeModal(modalOrgChartDataCache, orgChartTreeModal, 0, '', expandedDepartmentIds);
                setupEventListenersModal();
            } else {
                // 데이터가 캐시되어 있지 않으면 로드 시도
                loadOrgChartTreeModal();
            }
        });

        // ⭐ 추가: 모달이 닫힐 때 현재 토글 상태를 저장
        $('#departmentListModal').on('hidden.bs.modal', function () {
            // 기존 상태를 초기화하고, 현재 열려있는 부서들을 다시 스캔하여 ID를 저장
            // 이렇게 하면 모달이 닫히는 시점의 정확한 상태를 저장할 수 있습니다.
            expandedDepartmentIds.clear();
            document.querySelectorAll('#departmentListModal .department-name.expanded').forEach(deptNameElement => {
                const departmentId = deptNameElement.dataset.departmentId; // data-department-id 속성 사용
                if (departmentId) {
                    expandedDepartmentIds.add(parseInt(departmentId, 10));
                }
            });
            console.log("모달 닫힘: 저장된 열린 부서 ID:", Array.from(expandedDepartmentIds));
        });
    });

    // 조직도 데이터를 불러와 캐시하고 렌더링하는 함수 (모달용)
    async function loadOrgChartTreeModal(keyword = '') {
        const orgChartTreeModal = document.getElementById('orgChartTreeModal');
        orgChartTreeModal.innerHTML = '<p>조직도 데이터를 불러오는 중...</p>'; // 로딩 메시지

        try {
            const response = await fetch('/api/v1/dept/tree'); // 기존 API 경로 사용

            if (!response.ok) {
                throw new Error(`HTTP 요청 실패! 상태코드: \${response.status}`);
            }

            const departmentTreeData = await response.json();
            modalOrgChartDataCache = departmentTreeData; // 데이터 캐싱
            orgChartTreeModal.innerHTML = ''; // 로딩 메시지 제거

            // ⭐ 토글 상태 유지를 위해 expandedDepartmentIds Set 전달
            renderDepartmentTreeModal(departmentTreeData, orgChartTreeModal, 0, keyword, expandedDepartmentIds);
            setupEventListenersModal();

        } catch (error) {
            console.error('조직도 데이터를 불러오는 중 오류 발생:', error);
            orgChartTreeModal.innerHTML = `<p style="color:red;">조직도 데이터를 불러오는 데 실패했습니다. 오류: \${error.message}</p>`;
        }
    }

    // 조직도 HTML을 렌더링하는 함수 (모달용) - `organization_chart.jsp`와 중복되는 로직
    // ⭐ expandedIdsSet 인자 추가
    function renderDepartmentTreeModal(departments, parentElement, level = 0, keyword = '', expandedIdsSet = new Set()) {
        if (!departments || departments.length === 0) {
            return;
        }

        const ul = document.createElement('ul');
        if (parentElement.id !== 'orgChartTreeModal') { // 최상위 ul이 아니면 자식으로 처리
            ul.className = 'dept-list child-dept-list';
        } else {
            ul.className = 'dept-list';
        }

        departments.forEach(department => {
            // 부서 레벨에 따른 들여쓰기 클래스
            const currentIndentLevel = (department.level != null) ? department.level - 1 : 0;
            const li = document.createElement('li');
            li.className = `dept-item indent-level-${currentIndentLevel}`;

            const deptNameContainer = document.createElement('span');
            deptNameContainer.className = `department-name department-level-${currentIndentLevel}`;
            // ⭐ 추가: departmentId를 data-속성으로 저장하여 토글 상태 저장/복원 시 사용
            if (department.departmentId) {
                deptNameContainer.dataset.departmentId = `\${department.departmentId}`;
            }

            const toggleIcon = document.createElement('span');
            toggleIcon.className = 'toggle-icon';
            // 사용자가 있거나 하위 부서가 있으면 토글 아이콘 표시
            if ((department.users && department.users.length > 0) || (department.children && department.children.length > 0)) {
                toggleIcon.textContent = '▶';
            } else {
                toggleIcon.textContent = ''; // 내용이 없으면 아이콘 숨김
            }
            deptNameContainer.appendChild(toggleIcon);

            const deptText = document.createTextNode(String(department.departmentName || '부서명 없음'));
            deptNameContainer.appendChild(deptText);
            li.appendChild(deptNameContainer);

            // 사용자 목록 (초기에는 숨김)
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
                    // ⭐ 여기를 수정했습니다: highlightKeywordModal 호출 앞에 \를 추가했습니다.
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

            // 하위 부서 재귀 호출
            // ⭐ 토글 상태 유지를 위해 expandedIdsSet 전달
            if (department.children && department.children.length > 0) {
                renderDepartmentTreeModal(department.children, li, level + 1, keyword, expandedIdsSet);
            }

            ul.appendChild(li);

            // ⭐ 추가: 저장된 expandedIdsSet에 현재 부서 ID가 있으면 펼쳐진 상태로 렌더링
            if (department.departmentId && expandedIdsSet.has(department.departmentId)) {
                deptNameContainer.classList.add('expanded'); // 부서명에 expanded 클래스 추가
                if (userListUl) userListUl.classList.add('expanded-users'); // 사용자 목록 펼침
                // 하위 부서도 있다면 펼침
                const childDeptList = li.querySelector('.child-dept-list');
                if (childDeptList) childDeptList.classList.add('expanded-users');
                // 토글 아이콘 방향 변경
                toggleIcon.style.transform = 'rotate(90deg)';
            }
        });
        parentElement.appendChild(ul);
    }

    // 모달 내 검색 기능
    function searchTreeModal() {
        const keyword = document.getElementById('searchKeywordModal').value;
        const orgChartTreeModal = document.getElementById('orgChartTreeModal');
        orgChartTreeModal.innerHTML = ''; // 기존 내용 초기화

        if (modalOrgChartDataCache) {
            // ⭐ 검색 시에는 토글 상태를 유지하지 않음 (모든 검색 결과가 보이도록)
            // 필요하다면 검색 결과에 따라 일부만 펼치도록 로직 변경 가능
            renderDepartmentTreeModal(modalOrgChartDataCache, orgChartTreeModal, 0, keyword, new Set()); // 새 Set 전달 (검색시 초기화)
            setupEventListenersModal();
        } else {
            // 캐시된 데이터가 없으면 다시 로드 시도
            alert('조직도 데이터가 아직 로드되지 않았습니다. 잠시 후 다시 시도해주세요.');
            loadOrgChartTreeModal(keyword);
        }
    }

    // 모달 내 이벤트 리스너 설정
    function setupEventListenersModal() {
        // 이벤트 리스너 중복 등록 방지를 위해 DOMContentLoaded에서 한 번만 설정하는 것을 권장하며,
        // 동적으로 추가되는 요소에 대해서는 이벤트 위임(delegation)을 사용합니다.
        // 현재는 각 요소에 플래그를 사용하여 중복을 방지합니다.

        document.querySelectorAll('#departmentListModal .department-name').forEach(deptNameElement => {
            if (!deptNameElement.dataset.listenerAddedDept) { // 리스너 추가 플래그 변경
                deptNameElement.addEventListener('click', function(event) {
                    const deptItem = deptNameElement.closest('.dept-item');
                    if (!deptItem) return;

                    const userList = deptItem.querySelector('.user-list');
                    const toggleIcon = deptNameElement.querySelector('.toggle-icon');
                    const childDeptList = deptItem.querySelector('.child-dept-list');

                    // 사용자 목록과 하위 부서 목록을 모두 토글
                    let isExpanded = false;
                    if (userList) {
                        userList.classList.toggle('expanded-users');
                    }
                    if (childDeptList) {
                        childDeptList.classList.toggle('expanded-users');
                    }

                    // 부서명 자체의 expanded 클래스도 토글
                    deptNameElement.classList.toggle('expanded');
                    isExpanded = deptNameElement.classList.contains('expanded'); // 최종 expanded 상태 확인

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
                deptNameElement.dataset.listenerAddedDept = 'true'; // 리스너가 추가되었음을 표시
            }
        });

        document.querySelectorAll('#departmentListModal .user-link-modal').forEach(link => {
            if (!link.dataset.listenerAddedUser) { // 리스너 추가 플래그 변경
                link.addEventListener('click', function(event) {
                    event.preventDefault();
                    const userId = parseInt(this.dataset.userId, 10);
                    const userName = this.dataset.userName;

                    if (typeof window.addSelectedUser === 'function' && typeof window.currentRecipientType === 'string' && window.currentRecipientType !== '') {
                        window.addSelectedUser(window.currentRecipientType, userId, userName);
                        // $('#departmentListModal').modal('hide'); // 선택 후 모달 닫기 여부
                    } else {
                        console.error('window.addSelectedUser 함수가 정의되지 않았거나 window.currentRecipientType이 설정되지 않았습니다.');
                    }
                });
                link.dataset.listenerAddedUser = 'true'; // 리스너가 추가되었음을 표시
            }
        });
    }

    // 검색어 하이라이팅 함수 (모달용)
    function highlightKeywordModal(text, keyword) {
        if (!keyword) return text;
        // 정규식 내의 패턴이 문자열 리터럴이므로 백틱 대신 일반 따옴표를 사용합니다.
        const regex = new RegExp(`(\${keyword})`, 'gi');
        return text.replace(regex, '<mark>$1</mark>');
    }
</script>