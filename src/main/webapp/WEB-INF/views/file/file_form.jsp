<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>파일 업로드</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
    rel="stylesheet">
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

.sidebar-list li.active {
    background-color: #e0f7f4 !important; /* 민트색 계열의 연한 배경 */
    color: #1abc9c !important;
    font-weight: bold;
}

.sidebar-list li:hover {
    background-color: #f8f9fa;
    color: #1abc9c;
    font-weight: bold;
}

.main-content {
    flex: 1;
    background-color: white;
    padding: 50px 20px;
    text-align: center;
    border-radius: 12px;
    padding: 20px;
    box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
}

.main-content h2 {
    text-align: left;
    margin-bottom: 20px;
    color: #e6002d;
}

.upload-form {
    background: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    padding: 30px;
    margin-bottom: 20px;
    max-width: 600px;
    margin-left: auto;
    margin-right: auto;
}

.form-group {
    margin-bottom: 20px;
    text-align: left;
}

.form-group label {
    display: block;
    margin-bottom: 8px;
    font-weight: 600;
    color: #333;
}

.form-group input, .form-group select, .form-group textarea {
    width: 100%;
    padding: 12px;
    border: 1px solid #ccc;
    border-radius: 4px;
    font-size: 14px;
}

.form-group textarea {
    resize: vertical;
    min-height: 100px;
}

.file-upload-area {
    border: 2px dashed #ccc;
    border-radius: 8px;
    padding: 40px;
    text-align: center;
    cursor: pointer;
    transition: border-color 0.3s;
    margin-bottom: 20px;
}

.file-upload-area:hover {
    border-color: #e6002d;
}

.file-upload-area.dragover {
    border-color: #e6002d;
    background-color: #fff5f5;
}

.file-upload-icon {
    font-size: 48px;
    color: #ccc;
    margin-bottom: 10px;
}

.file-upload-text {
    color: #666;
    margin-bottom: 10px;
}

.file-upload-hint {
    font-size: 12px;
    color: #999;
}

.selected-files {
    margin-top: 20px;
}

.file-item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 10px;
    background: #f8f9fa;
    border-radius: 4px;
    margin-bottom: 8px;
}

.file-item .file-info {
    display: flex;
    align-items: center;
    gap: 10px;
}

.file-item .file-name {
    font-weight: 500;
}

.file-item .file-size {
    color: #666;
    font-size: 12px;
}

.file-item .remove-btn {
    background: #dc3545;
    color: white;
    border: none;
    padding: 4px 8px;
    border-radius: 4px;
    cursor: pointer;
    font-size: 12px;
}

.form-actions {
    display: flex;
    gap: 10px;
    justify-content: center;
    margin-top: 30px;
}

.btn-primary {
    background-color: #4CAF50;
    color: #fff;
    border: none;
    padding: 12px 24px;
    border-radius: 4px;
    font-size: 14px;
    cursor: pointer;
}

.btn-primary:hover {
    background-color: #45a049;
}

.btn-secondary {
    background-color: #ccc;
    color: #333;
    border: none;
    padding: 12px 24px;
    border-radius: 4px;
    font-size: 14px;
    cursor: pointer;
}

.btn-secondary:hover {
    background-color: #bbb;
}

footer {
    text-align: center;
    padding: 15px;
    font-size: 12px;
    color: #999;
    border-top: 1px solid #eee;
    margin-top: 40px;
}

/* 공유 대상 선택 관련 스타일 */
.share-target-section {
    margin-top: 15px;
    padding: 15px;
    background-color: #f8f9fa;
    border-radius: 4px;
    border: 1px solid #dee2e6;
}

.add-assignee-btn {
    background: #007bff;
    color: white;
    border: none;
    border-radius: 50%;
    width: 24px;
    height: 24px;
    font-size: 16px;
    cursor: pointer;
    margin-left: 8px;
}

.add-assignee-btn:hover {
    background: #0056b3;
}

.assignee-list {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    margin-top: 8px;
}

.assignee-tag {
    display: inline-flex;
    align-items: center;
    background: #e3f2fd;
    border: 1px solid #2196f3;
    border-radius: 16px;
    padding: 4px 12px;
    font-size: 14px;
    color: #1976d2;
}

.assignee-tag .remove-assignee-btn {
    background: none;
    border: none;
    color: #d00;
    font-size: 16px;
    cursor: pointer;
    padding: 0 4px;
}

.assignee-tag .remove-assignee-btn:hover {
    color: #fff;
    background: #d00;
    border-radius: 50%;
}

/* 모달 스타일 */
.modal-overlay {
    display: none;
    position: fixed;
    z-index: 1000;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0,0,0,0.5);
}

.modal-content {
    background-color: white;
    margin: 5% auto;
    padding: 20px;
    border-radius: 8px;
    width: 80%;
    max-width: 600px;
    max-height: 80vh;
    overflow-y: auto;
    position: relative;
}

.modal-close {
    position: absolute;
    top: 10px;
    right: 15px;
    font-size: 24px;
    font-weight: bold;
    cursor: pointer;
    color: #aaa;
}

.modal-close:hover {
    color: #000;
}

/* 조직도 트리 스타일 */
.org-tree, .org-tree ul {
    list-style: none;
    margin: 0;
    padding-left: 18px;
    position: relative;
}

.org-tree ul {
    border-left: 1.5px solid #d0d6e1;
}

.org-tree > li {
    margin-bottom: 8px;
    padding-left: 0;
}

.org-dept {
    font-weight: 600;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 4px;
    margin: 2px 0;
    color: #2a3a5a;
    border-radius: 4px;
    transition: background 0.15s;
    padding: 2px 0 2px 2px;
}

.org-dept .tree-toggle {
    font-size: 1.1em;
    color: #888;
    margin-right: 2px;
    user-select: none;
    width: 1em;
    display: inline-block;
    text-align: center;
}

.org-dept:hover {
    background: #f0f4fa;
}

.org-emp {
    margin: 2px 0 2px 0;
    padding-left: 8px;
    color: #333;
    cursor: pointer;
    border-radius: 4px;
    transition: background 0.15s;
    font-weight: 400;
    display: block;
}

.org-emp:hover {
    background: #e3e7f0;
}
.share-checkbox-row {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-left: 18px;
    margin-top: 4px;
    justify-content: flex-start;
}
.share-check-label {
    margin: 0;
    font-weight: 400;
    font-size: 15px;
    line-height: 1.2;
}
.share-setting-group {
    text-align: left !important;
    margin-bottom: 20px;
}
.share-setting-label {
    font-weight: bold;
    display: block;
    margin-bottom: 2px;
}
.form-check-input {
    margin-top: 0;
    margin-right: 6px;
}
.custom-share-check {
    display: flex !important;
    align-items: center;
    width: auto !important;
    padding: 0 !important;
    background: none !important;
    border: none !important;
}
.custom-share-check .form-check-input {
    width: 18px !important;
    height: 18px !important;
    min-width: 0 !important;
    flex: none !important;
    margin: 0 8px 0 0 !important;
}
.custom-share-check .form-check-label {
    margin: 0 !important;
    font-weight: 400;
    font-size: 15px;
    line-height: 1.2;
}
.box-type-group {
    text-align: left !important;
    margin-bottom: 20px;
}
.box-type-label {
    font-weight: bold;
    display: block;
    margin-bottom: 2px;
}
.box-type-row {
    display: flex;
    align-items: center;
    gap: 18px;
    margin-left: 2px;
    margin-top: 4px;
    justify-content: flex-start;
}
.custom-box-type-check {
    display: flex !important;
    align-items: center;
    width: auto !important;
    padding: 0 !important;
    background: none !important;
    border: none !important;
}
.custom-box-type-check .form-check-input {
    width: 18px !important;
    height: 18px !important;
    min-width: 0 !important;
    flex: none !important;
    margin: 0 8px 0 0 !important;
}
.custom-box-type-check .form-check-label {
    margin: 0 !important;
    font-weight: 400;
    font-size: 15px;
    line-height: 1.2;
}
/* 작은 버튼(예: .file-list-actions button, .search-btn 등)에 민트색 적용 */
.file-list-actions button,
.search-btn,
.tree-btn,
.file-item .remove-btn,
.add-assignee-btn,
.assignee-tag .remove-assignee-btn {
    background: #1abc9c !important;
    color: #fff !important;
    border: none !important;
}
.file-list-actions button:hover,
.search-btn:hover,
.tree-btn:hover,
.file-item .remove-btn:hover,
.add-assignee-btn:hover,
.assignee-tag .remove-assignee-btn:hover {
    background: #159c86 !important;
    color: #fff !important;
}

/* 테이블 헤더 배경 흰색으로 변경 */
.file-table th {
    background: #fff !important;
    color: #333 !important;
    font-weight: 600;
}
.sidebar-link {
    display: block;
    width: 100%;
    height: 100%;
    color: inherit;
    text-decoration: none;
}
.sidebar-link:visited,
.sidebar-link:active {
    color: inherit;
}
.sidebar-list li.active .sidebar-link,
.sidebar-list li:hover .sidebar-link {
    color: #1abc9c !important;
    font-weight: bold;
    background-color: #e0f7f4 !important;
    border-radius: 6px;
}
</style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand d-flex align-items-center" href="index.html"> 
                <span class="logo-crop"> 
                    <img src="grouvy_logo.jpg" alt="GROUVY 로고" class="logo-img">
                </span>
            </a>
            <ul class="navbar-nav mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link" href="#">전자결재</a></li>
                <li class="nav-item"><a class="nav-link active" href="#">업무문서함</a></li>
                <li class="nav-item"><a class="nav-link" href="#">업무 관리</a></li>
                <li class="nav-item"><a class="nav-link" href="#">쪽지</a></li>
                <li class="nav-item"><a class="nav-link" href="#">메신저</a></li>
                <li class="nav-item"><a class="nav-link" href="#">조직도</a></li>
                <li class="nav-item"><a class="nav-link" href="#">일정</a></li>
                <li class="nav-item"><a class="nav-link" href="admin_dashboard.html">관리자</a></li>
            </ul>
            <div class="d-flex align-items-center">
                <a href="mypage.html" >
                    <img src="https://search.pstatic.net/sunny/?src=https%3A%2F%2Fs3.orbi.kr%2Fdata%2Ffile%2Funited2%2F6cc64e06aa404ac3a176745b9c1d5bfa.jpeg&type=sc960_832"
                            alt="프로필" class="rounded-circle" width="36" height="36">
                </a>
                <a href="mypage.html" class="ms-2 text-decoration-none text-dark">마이페이지</a>
            </div>
        </div>
    </nav>

    <main>
        <div class="container">
            <div class="sidebar">
                <h3>업무문서함</h3>
                <div class="sidebar-section">
                    <div class="sidebar-section-title">개인업무 문서함</div>
                    <ul class="sidebar-list">
                        <li><a href="/file/personal" class="sidebar-link">파일 목록</a></li>
                    </ul>
                </div>
                <div class="sidebar-section">
                    <div class="sidebar-section-title">부서업무 문서함</div>
                    <ul class="sidebar-list">
                        <li><a href="/file/department" class="sidebar-link">파일 목록</a></li>
                    </ul>
                </div>
                <div class="sidebar-section">
                    <div class="sidebar-section-title">공유받은 파일함</div>
                    <ul class="sidebar-list">
                        <li><a href="/file/share" class="sidebar-link">공유받은 파일 목록</a></li>
                    </ul>
                </div>
                <div class="sidebar-section">
                    <div class="sidebar-section-title"><a href="/file/trash" class="sidebar-link">휴지통</a></div>
                </div>
            </div>

            <!-- 기능 페이지 -->
            <div class="main-content">
                <h2>파일 업로드</h2>
                
                <form method="post" action="/file/form" class="upload-form" enctype="multipart/form-data">
                    <div class="form-group box-type-group">
                        <label class="form-label fw-bold mb-1 box-type-label">문서함 선택</label>
                        <div class="box-type-row">
                        <div class="form-check custom-box-type-check">
                            <input class="form-check-input" type="radio" id="personal-box" name="ownerType" value="personal" checked>
                            <label class="form-check-label" for="personal-box">개인업무 문서함</label>
                        </div>
                        <div class="form-check custom-box-type-check">
                            <input class="form-check-input" type="radio" id="department-box" name="ownerType" value="department">
                            <label class="form-check-label" for="department-box">부서업무 문서함</label>
                        </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="upload-area">파일 선택 📁</label>

                        <input type="file" class="form-control" name="file" />
                        <div id="selected-files" class="selected-files" style="display: none;">
                            <h4>선택된 파일</h4>
                            <div id="file-list"></div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="category">카테고리</label>
                        <select id="category" name="fileCategoryId">
                            <option disabled selected>카테고리 선택</option>
                            <c:forEach var="category" items="${categories}" >
                                <option value="${category.categoryId}" <c:if test="${file.fileCategoryId eq category.categoryId}">selected</c:if>>${category.categoryName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div class="form-group mb-3" style="text-align:left;">
                        <label class="form-label fw-bold mb-1">공유 설정</label>
                        <div class="form-check custom-share-check">
                        <input class="form-check-input" type="checkbox" id="share-check" name="shareStatus" value="Y">
                        <label class="form-check-label" for="share-check" style="font-weight:400;">공유함</label>
                        </div>
                    </div>

                    <div id="share-target-section" class="share-target-section" style="display: none;">
                        <label>공유 대상 <button type="button" id="open-share-target-modal" class="add-assignee-btn">+</button></label>
                        <div id="share-target-list" class="assignee-list"></div>
                    </div>
                    
                    
                    
                    <div class="form-actions">
                        <button class="btn-primary" onclick="uploadFiles()">저장</button>
                        <button type="button" class="btn-secondary" onclick="history.back()">취소</button>
                    </div>
                </form>
            </div>
        </div>

    </main>

    <!-- 공유 대상 선택 모달 -->
    <div id="share-target-modal" class="modal-overlay" style="display:none;">
        <div class="modal-content">
            <span class="modal-close" id="close-share-target-modal">&times;</span>
            <h3>직원 선택(공유 대상)</h3>
            <ul class="org-tree" id="share-target-org-tree">
                <!-- JS로 동적으로 조직도 트리 렌더링 -->
            </ul>
        </div>
    </div>

    <footer>© 2025 그룹웨어 Corp.</footer>

    <script>
let shareTargets = [];

// 공유함 체크박스 이벤트
const shareCheck = document.getElementById('share-check');
// 문서함 선택 라디오 버튼에 따른 공유설정 표시/숨김
const boxTypeRadios = document.querySelectorAll('input[name="ownerType"]');
const shareSettingGroup = document.querySelector('.form-group.mb-3'); // 공유설정 체크박스 영역
const shareTargetSection = document.getElementById('share-target-section');

function updateShareSettingVisibility() {
    const selected = document.querySelector('input[name="ownerType"]:checked').value;
    if (selected === 'department') {
        shareSettingGroup.style.display = 'none';
        shareTargetSection.style.display = 'none';
        shareCheck.checked = false;
        shareCheck.disabled = true; // 부서업무 문서함이면 비활성화
        shareTargets = [];
    } else {
        shareSettingGroup.style.display = '';
        shareCheck.disabled = false; // 개인업무 문서함이면 활성화
        // 공유함 체크 여부에 따라 공유 대상 영역 표시
        if (shareCheck.checked) {
            shareTargetSection.style.display = 'block';
        } else {
            shareTargetSection.style.display = 'none';
        }
    }
}
boxTypeRadios.forEach(radio => {
    radio.addEventListener('change', updateShareSettingVisibility);
});
// 공유함 체크박스 이벤트도 updateShareSettingVisibility로 통합
shareCheck.addEventListener('change', updateShareSettingVisibility);
window.addEventListener('DOMContentLoaded', updateShareSettingVisibility);




// 공유 대상 모달 열기/닫기
const openShareTargetModalBtn = document.getElementById('open-share-target-modal');
const shareTargetModal = document.getElementById('share-target-modal');
const closeShareTargetModalBtn = document.getElementById('close-share-target-modal');
const shareTargetOrgTree = document.getElementById('share-target-org-tree');

// 직원 클릭 시 태그 추가 함수
function bindEmpClickEvent() {
    const shareTargetList = document.getElementById('share-target-list');
    document.querySelectorAll('#share-target-org-tree .org-emp').forEach(emp => {
        emp.addEventListener('click', function(e) {
            e.stopPropagation();
            const name = this.getAttribute('data-name');
            if ([...shareTargetList.children].some(tag => tag.dataset.name === name)) return;
            const tag = document.createElement('span');
            tag.className = 'assignee-tag';
            tag.dataset.name = name;
            tag.textContent = name;
            const btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'remove-assignee-btn';
            btn.textContent = '×';
            btn.onclick = function() { tag.remove(); };
            tag.appendChild(btn);
            shareTargetList.appendChild(tag);
            shareTargetModal.style.display = 'none';
        });
    });
}

openShareTargetModalBtn.addEventListener('click', () => {
    // 모달 열릴 때 서버에서 유저 flat 목록 요청 (jQuery ajax 사용)
    $.ajax({
        url: '/file/api/user-list',
        method: 'GET',
        dataType: 'json',
        success: function(data) {
            // data.data가 실제 직원 배열
            loadUsers(data.data);
            shareTargetModal.style.display = 'flex';
        },
        error: function() {
            alert('직원 목록 정보를 불러오지 못했습니다.');
        }
    });
});

// 단순 직원 리스트만
function loadUsers() {
    $.getJSON(`/file/api/user-list`, function(result) {
        let userList = result.data;
        let htmlContent = "";
        for (let user of userList) {
            htmlContent += generateHtml(user);
        }
        $("#share-target-org-tree").html(htmlContent);

        // 직원 li 클릭 이벤트 바인딩
        $("#share-target-org-tree .org-emp").off('click').on('click', function() {
            const userId = $(this).data('user-id');
            const info = $(this).text();
            const shareTargetList = $('#share-target-list');
            // 이미 추가된 경우 중복 추가 방지 (userId 기준)
            if (shareTargetList.find(`input[name='targetUserIds'][value='\${userId}']`).length) return;
            // 태그 생성
            const tag =
                $(`
                    <span class="assignee-tag">\${info}
                        <button type="button" class="remove-assignee-btn">×</button>
                        <input type="hidden" name="targetUserIds" value="\${userId}">
                    </span>`);
            // 삭제 버튼 이벤트
            tag.find('.remove-assignee-btn').on('click', function() { tag.remove(); });
            shareTargetList.append(tag);
            // 모달 닫기
            $('#share-target-modal').hide();
        });
    })
}

function generateHtml(user) {
    let htmlContent = `
	         <li class="org-emp" data-user-id="\${user.userId}">
                \${user.departmentName} \${user.name} \${user.positionName}
             </li>
	      `;


    return htmlContent;
}

closeShareTargetModalBtn.addEventListener('click', () => {
    shareTargetModal.style.display = 'none';
})

// 페이지 로드 시, 이미 있는 assignee-tag의 삭제 버튼에도 이벤트 바인딩
$('#share-target-list').on('click', '.remove-assignee-btn', function() {
    $(this).closest('.assignee-tag').remove();
});
    </script>

</body>
</html> 