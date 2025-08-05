<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>업무문서함</title>
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

.folder-tree-section {
    background: #f8f9fa;
    border-radius: 8px;
    padding: 10px;
    margin-bottom: 15px;
    border: 1px solid #e2e8f0;
}

.folder-tree-title {
    font-size: 14px;
    font-weight: 600;
    margin-bottom: 8px;
    color: #333;
}

.folder-tree-controls {
    display: flex;
    align-items: center;
    gap: 4px;
    margin-bottom: 8px;
}

.tree-btn {
    width: 20px;
    height: 20px;
    border: 1px solid #ccc;
    background: #fff;
    color: #333;
    border-radius: 3px;
    font-size: 12px;
    cursor: pointer;
    padding: 0;
    display: flex;
    align-items: center;
    justify-content: center;
}

.tree-btn:hover {
    background: #f0f0f0;
}

.tree-all {
    font-size: 12px;
    color: #666;
    margin-left: 5px;
}

.folder-tree {
    list-style: none;
    padding-left: 0;
    margin: 0;
}

.tree-folder {
    margin-bottom: 2px;
    padding-left: 2px;
}

.tree-toggle {
    cursor: pointer;
    color: #e6002d;
    font-weight: bold;
    margin-right: 2px;
    font-size: 14px;
}

.tree-folder-icon {
    margin-right: 4px;
    font-size: 14px;
}

.tree-folder-name {
    font-weight: 500;
    color: #333;
}

.tree-leaf {
    margin-left: 20px;
    display: flex;
    align-items: center;
    gap: 4px;
    padding: 2px 0;
}

.tree-leaf-icon {
    font-size: 12px;
}

.tree-leaf-name {
    color: #333;
    font-size: 12px;
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

.file-search-box {
    background: #fff;
    border-radius: 8px;
    padding: 15px;
    margin-bottom: 20px;
    display: flex;
    align-items: center;
    gap: 18px;
    box-shadow: 0 1px 4px rgba(0,0,0,0.1);
    flex-wrap: wrap;
    flex-direction: row;
}
.file-search-group {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-right: 18px;
}
.file-search-divider {
    width: 1px;
    height: 28px;
    background: #eee;
    margin: 0 10px;
}

.file-search-box select, .file-search-box input[type="date"], .input-file-name {
    padding: 6px 10px;
    border-radius: 4px;
    border: 1px solid #ccc;
    font-size: 14px;
}

.date-label {
    font-size: 14px;
    font-weight: 500;
    color: #333;
}

.date-input {
    width: 120px;
}

.date-separator {
    font-size: 14px;
    color: #666;
    font-weight: 500;
}

.input-file-name {
    width: 150px;
}

.search-btn {
    background-color: #4CAF50;
    color: #fff;
    border: none;
    padding: 6px 16px;
    border-radius: 4px;
    font-size: 14px;
    cursor: pointer;
}

.search-btn:hover {
    background-color: #45a049;
}

.file-list-box {
    background: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    padding: 15px;
}

.file-list-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 15px;
}

.file-list-title {
    font-weight: 600;
    color: #e6002d;
    font-size: 16px;
}

.file-list-actions button {
    background: #fff;
    color: #e6002d;
    border: 1px solid #e6002d;
    border-radius: 4px;
    padding: 6px 12px;
    font-size: 12px;
    margin-left: 4px;
    cursor: pointer;
    transition: background 0.15s, color 0.15s;
}

.file-list-actions button:hover {
    background: #e6002d;
    color: #fff;
}

.file-list-actions .delete-btn {
    background: #f44336;
    color: #fff;
    border: none;
}

.file-list-actions .delete-btn:hover {
    background: #d32f2f;
}

.file-table {
    width: 100%;
    border-collapse: collapse;
    background: #fff;
    border-radius: 8px;
    overflow: hidden;
    margin-top: 10px;
}

.file-table th, .file-table td {
    padding: 10px 8px;
    text-align: center;
    border-bottom: 1px solid #e2e8f0;
    font-size: 14px;
}

.file-table th {
    background: #fff !important;
    color: #333 !important;
    font-weight: 600;
}

.file-table tr:last-child td {
    border-bottom: none;
}

.empty-row {
    color: #e6002d;
    text-align: center;
    font-size: 14px;
    padding: 30px 0;
}

footer {
    text-align: center;
    padding: 15px;
    font-size: 12px;
    color: #999;
    border-top: 1px solid #eee;
    margin-top: 40px;
}

.selected-row {
    background-color: #e6f2ff !important;
}

.sidebar-list li.active {
    background-color: #e0f7f4 !important; /* 민트색 계열의 연한 배경 */
    color: #1abc9c !important;
    font-weight: bold;
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
                <li>
                <a href="/file/personal" class="sidebar-link">파일 목록</a>
                </li>
            </ul>
        </div>
        <div class="sidebar-section">
            <div class="sidebar-section-title">부서업무 문서함</div>
            <ul class="sidebar-list">
            <li>
                <a href="/file/department" class="sidebar-link">파일 목록</a>
            </li>
            </ul>
        </div>
        <div class="sidebar-section">
            <div class="sidebar-section-title">공유받은 파일함</div>
            <ul class="sidebar-list">
                <li>
                    <a href="/file/share" class="sidebar-link">파일 목록</a>
                </li>
            </ul>
        </div>
        <div class="sidebar-section">
            <div class="sidebar-section-title"><a href="/file/trash" class="sidebar-link">휴지통</a></div>
        </div>
        </div>

            <!-- 기능 페이지 -->
            <div class="main-content">
                <h2>개인업무 문서함</h2>
                
                <div class="file-search-box">
                <div class="file-search-group">
    <select id="favorite-select">
        <option value="">즐겨찾기 여부</option>
        <option value="Y">즐겨찾기만</option>
        <option value="N">즐겨찾기 제외</option>
    </select>
    <select id="category-select">
        <option value="">카테고리</option>
        <option value="업무관리">업무관리</option>
        <option value="문서">문서</option>
        <option value="보고서">보고서</option>
        <option value="스프레드시트">스프레드시트</option>
        <option value="프레젠테이션">프레젠테이션</option>
        <option value="이미지">이미지</option>
        <option value="기타">기타</option>
    </select>
    <select id="shared-select">
        <option value="">공유여부</option>
        <option value="공유함">공유 O</option>
        <option value="공유안함">공유 X</option>
    </select>
    </div>
    <span class="file-search-divider"></span>
    <div class="file-search-group">
    <span class="date-label">등록일</span>
    <input type="date" class="date-input" placeholder="시작일">
    <span class="date-separator">~</span>
    <input type="date" class="date-input" placeholder="종료일">
    </div>
    <span class="file-search-divider"></span>
    <div class="file-search-group">
    <select>
        <option>파일명</option>
        <option>확장자</option>
    </select>
    <input type="text" class="input-file-name" placeholder="검색어">
    <button class="search-btn">검색</button>
    </div>
</div>
                
                <div class="file-list-box">
                    <div class="file-list-header">
                        <span class="file-list-title">파일 목록</span>
                        <form id="deleteForm" method="post" action="/file/delete">

                        <div class="file-list-actions">
                            <a href="/file/form" class="btn search-btn">업로드</a>
                            <input type="file" id="file-input" style="display:none" multiple>
                            <!-- 선택한 파일 편집 -->
                            <button type="button" class="btn edit-btn" id="edit-btn">파일편집</button>

                            <!-- 선택 파일 삭제 -->
                            <button type="submit" class="btn search-btn" id="delete-btn">삭제</button>
                            <input hidden="hidden" name="ownerType" value="personal">
                        </div>
                    </div>
                    <table class="file-table">
                        <thead>
                            <tr>
                                <th><input type="checkbox"></th>
                                <th>★</th>
                                <th>카테고리</th>
                                <th>파일명</th>
                                <th>공유여부</th>
                                <th>크기</th>
                                <th>등록일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="file" items="${files}" varStatus="status">
                                <tr data-file-id="${status.count}">
                                    <td><input type="checkbox" name="fileIds" value="${file.fileId}"></td>
                                    <td>★</td>
                                    <td>${file.fileCategoryName}</td>
                                    <td><a href="/file/download?fileId=${file.fileId}">${file.originalName}</a></td>
                                    <c:if test="${file.shareStatus eq 'Y'}">
                                        <td>공유함</td>
                                    </c:if>
                                    <c:if test="${file.shareStatus eq 'N'}">
                                        <td>공유안함</td>
                                    </c:if>

                                    <td>${file.size} byte</td>
                                    <td>${file.createdDate}</td>
                                </tr>

                            </c:forEach>
                        </tbody>
                    </table>
                    </form>
                </div>
            </div>
        </div>

    </main>

    <footer>© 2025 그룹웨어 Corp.</footer>

    <script>
    
    document.getElementById('deleteForm').addEventListener('submit', function(e) {
        const checked = document.querySelectorAll('input[name="fileIds"]:checked');
        if (checked.length === 0) {
            alert('삭제할 파일을 선택하세요.');
            e.preventDefault();
        }
    });

    document.getElementById('edit-btn').addEventListener('click', function() {
        const checked = document.querySelectorAll('input[name="fileIds"]:checked');
        if (checked.length === 0) {
            alert('편집할 파일을 선택하세요.');
            return;
        }
        if (checked.length > 1) {
            alert('편집은 하나의 파일만 선택할 수 있습니다.');
            return;
        }
        const fileId = checked[0].value;
        window.location.href = '/file/edit?fileId=' + fileId;
    });


// 즐겨찾기 토글 함수
function toggleFavorite(fileName) {
    favorites[fileName] = !favorites[fileName];
    renderTable();
}

// 전역 함수 등록
window.toggleFavorite = toggleFavorite;

document.querySelector('.file-table').addEventListener('change', function(e) {
    if (e.target.type === 'checkbox') {
    const tr = e.target.closest('tr');
    if (tr) {
        if (e.target.checked) {
        tr.classList.add('selected-row');
        } else {
        tr.classList.remove('selected-row');
        }
    }
    }
});
document.addEventListener('DOMContentLoaded', function() {
    const table = document.querySelector('.file-table');
    if (!table) return;
    const theadCheckbox = table.querySelector('thead input[type="checkbox"]');
    const tbody = table.querySelector('tbody');

    // 전체 선택
    if (theadCheckbox) {
        theadCheckbox.addEventListener('change', function() {
            const rowCheckboxes = tbody.querySelectorAll('input[type="checkbox"]');
            rowCheckboxes.forEach(cb => {
                cb.checked = theadCheckbox.checked;
                const tr = cb.closest('tr');
                if (tr) {
                    if (cb.checked) {
                        tr.classList.add('selected-row');
                    } else {
                        tr.classList.remove('selected-row');
                    }
                }
            });
        });
    }

    // 개별 체크박스 이벤트 위임
    tbody.addEventListener('change', function(e) {
        if (e.target.type === 'checkbox') {
            const tr = e.target.closest('tr');
            if (tr) {
                if (e.target.checked) {
                    tr.classList.add('selected-row');
                } else {
                    tr.classList.remove('selected-row');
                }
            }
            // 하나라도 체크 해제되면 thead 체크박스 해제
            if (!e.target.checked && theadCheckbox.checked) {
                theadCheckbox.checked = false;
            }
            // 모두 체크되면 thead 체크박스도 체크
            const rowCheckboxes = tbody.querySelectorAll('input[type="checkbox"]');
            const allChecked = Array.from(rowCheckboxes).length > 0 && Array.from(rowCheckboxes).every(cb => cb.checked);
            if (allChecked) {
                theadCheckbox.checked = true;
            }
        }
    });
});

</script>
</body>
</html> 