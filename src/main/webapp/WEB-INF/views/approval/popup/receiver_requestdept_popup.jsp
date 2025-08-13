<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>수신처 선택</title>
  <meta name="viewport" content="width=400, initial-scale=1.0">
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
      min-height: 320px;
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
      padding: 0 24px 24px 24px;
    }
    .dept-list {
      list-style: none;
      padding: 0;
      margin: 0;
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 16px;
    }
    .dept-list li {
      margin-bottom: 0;
    }
    .dept-btn {
      width: 220px;
      padding: 10px 0;
      font-size: 15px;
      border-radius: 6px;
      border: 1px solid #d1d5db;
      background: #fff;
      color: #333;
      cursor: pointer;
      transition: background 0.15s, color 0.15s, font-weight 0.15s;
    }
    .dept-btn:hover {
      background: #e0e7ff;
      color: #1abc9c;
      font-weight: bold;
    }
    .popup-footer {
      font-size: 13px;
      color: #999;
      padding: 8px 24px 16px 24px;
      text-align: left;
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
<div class="popup-wrap">
  <div class="popup-header">
    <c:choose>
      <c:when test="${param.type == 'receiver'}">
        <span class="popup-title">수신처 선택</span>
      </c:when>
      <c:when test="${param.type == 'requestDept'}">
        <span class="popup-title">요청부서 선택</span>
      </c:when>
    </c:choose>
    <button class="popup-close" onclick="window.close()">&times;</button>
  </div>
  <div class="popup-body">
    <ul class="dept-list">
      <li><button class="dept-btn" onclick="selectDept('관리팀')">관리팀</button></li>
      <li><button class="dept-btn" onclick="selectDept('영업팀')">영업팀</button></li>
      <li><button class="dept-btn" onclick="selectDept('인사팀')">인사팀</button></li>
      <li><button class="dept-btn" onclick="selectDept('회계팀')">회계팀</button></li>
    </ul>
  </div>
  <div class="popup-footer">부서를 선택하면 창이 닫히고, 본문에 자동 입력됩니다.</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
  (async function() {
    const response = await fetch('teams');
    const teams = await response.json();

    const ul = document.querySelector('.dept-list')
    ul.innerHTML = teams
            .map(team => `
               <li><button
                    type="button"
                    class="dept-btn"
                    onclick="selectDept('\${team.departmentName}')"
                  >
                      \${team.departmentName}
                  </button>
               </li>
            `)
            .join('');
  })();


  function selectDept(deptName) {
    try {
      if (window.opener && !window.opener.closed) {
        // type 파라미터 읽기
        var params = new URLSearchParams(window.location.search);
        var type = params.get('type');
        var inputId = (type === 'requestDept') ? 'requestDept' : 'receiverDept';
        var input = window.opener.document.getElementById(inputId);
        if (input) {
          input.value = deptName;
        }
        // setRequestDept/setReceiverDept 함수도 호출 (폼 값 외에 추가 동작 있을 수 있음)
        if (type === 'requestDept' && typeof window.opener.setRequestDept === 'function') {
          window.opener.setRequestDept(deptName);
        } else if (type === 'receiver' && typeof window.opener.setReceiverDept === 'function') {
          window.opener.setReceiverDept(deptName);
        }
      }
    } catch (e) {
      alert('부모창에 값을 전달할 수 없습니다.\n팝업이 차단되었거나, 브라우저 보안 정책 때문일 수 있습니다.');
    }
    window.close();
  }
  // 팝업을 항상 화면 중앙에 위치시키기
  (function centerPopup() {
    try {
      var popupWidth = 400;
      var popupHeight = 500;
      var left = window.screenX + (window.outerWidth - popupWidth) / 2;
      var top = window.screenY + (window.outerHeight - popupHeight) / 2;
      window.moveTo(left, top);
      window.resizeTo(popupWidth, popupHeight);
    } catch(e) {}
  })();
</script>
</body>
</html> 