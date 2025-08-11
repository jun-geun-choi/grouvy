<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>결재처리</title>
  <meta name="viewport" content="width=900, initial-scale=1.0">
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    body {
      margin: 0;
      font-family: Arial, sans-serif;
      background: #fff;
      color: #333;
    }
    .popup-wrap {
      background: #fff;
      width: 900px;
      max-width: 98vw;
      min-height: 420px;
      border-radius: 0;
      box-shadow: none;
      border: none;
      margin: 0;
      display: flex;
      flex-direction: column;
      padding: 0;
      position: relative;
    }
    .popup-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 20px 32px 12px 32px;
      border-bottom: none;
      background: #fff;
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
      flex: 1;
      padding: 40px 48px 0 48px;
      display: flex;
      flex-direction: column;
      justify-content: flex-start;
    }
    .approve-table {
      width: 100%;
      border-collapse: collapse;
      background: #fff;
      margin: 0;
      border: none;
    }
    .approve-table th, .approve-table td {
      border: none;
      padding: 18px 16px;
      font-size: 17px;
      vertical-align: middle;
      background: #fff;
    }
    .approve-table th {
      background: #fff;
      color: #333;
      font-weight: 500;
      width: 140px;
      text-align: right;
      border: none;
    }
    .approve-table input[type="radio"] {
      margin-right: 6px;
    }
    .approve-table textarea {
      width: 100%;
      min-height: 120px;
      resize: vertical;
      font-size: 15px;
      border-radius: 4px;
      border: 1px solid #ccc;
      padding: 8px;
    }
    .approve-table input[type="file"] {
      width: 70%;
      font-size: 15px;
      border-radius: 4px;
      border: 1px solid #ccc;
      padding: 6px 8px;
    }
    .approve-table .file-btn {
      margin-left: 8px;
      padding: 6px 16px;
      font-size: 15px;
      border-radius: 4px;
      border: 1px solid #888;
      background: #f8f9fa;
      color: #333;
      cursor: pointer;
      transition: background 0.15s;
    }
    .approve-table .file-btn:hover {
      background: #e0e7ff;
    }
    .popup-footer {
      display: flex;
      justify-content: flex-end;
      align-items: center;
      gap: 12px;
      padding: 24px 48px 32px 48px;
      background: #fff;
      border-top: none;
    }
    .btn-approve {
      min-width: 110px;
      padding: 10px 32px;
      font-size: 17px;
      border-radius: 4px;
      border: none;
      background: #34495e;
      color: #fff;
      font-weight: 500;
      transition: background 0.15s;
    }
    .btn-approve:hover {
      background: #222;
    }
    .btn-cancel {
      min-width: 110px;
      padding: 10px 32px;
      font-size: 17px;
      border-radius: 4px;
      border: 1px solid #bbb;
      background: #fff;
      color: #333;
      font-weight: 500;
      transition: background 0.15s;
    }
    .btn-cancel:hover {
      background: #f8f9fa;
    }
    @media (max-width: 1000px) { 
      .popup-wrap { 
        width: 99vw; 
        margin: 0;
        border-radius: 0;
        box-shadow: none;
        border: none;
      } 
      .popup-body, .popup-footer { padding-left: 12px; padding-right: 12px; }
    }
  </style>
</head>
<body>
  <div class="popup-wrap">
    <div class="popup-header">
      <span class="popup-title">결재처리</span>
      <button class="popup-close" onclick="window.close()">&times;</button>
    </div>

    <div class="popup-body">
      <form id="approveForm"
            action="/approval/approve"
            method="post"
            enctype="multipart/form-data">

        <table class="approve-table">
          <tr>
            <th>결재처리</th>
            <td>
               <input type="hidden" name="approvalNo" value="${approvalNo}">
               <label><input type="radio" name="decision" value="approve" checked> 승인</label>
               <label style="margin-left: 12px;"><input type="radio" name="decision" value="reject"> 반려</label>
            </td>
          </tr>
          <tr>
            <th>결재의견</th>
            <td><textarea name="opinion" placeholder="결재의견을 입력하세요."></textarea></td>
          </tr>
          <tr>
            <th>파일</th>
            <td>
              <input type="file" name="file" id="fileInput">
              <button class="file-btn" onclick="document.getElementById('fileInput').click();return false;">파일 선택</button>
            </td>
          </tr>
        </table>
    </div>

      <div class="popup-footer">
        <button id="approve" type="submit" class="btn-approve">결재</button>
        <button type="button" class="btn-cancel" onclick="window.close()">취소</button>
      </div>
      </form>
  </div>
<script>
  const form = document.getElementById('approveForm');
  form.addEventListener('submit', e => {
    e.preventDefault();
    const data = new FormData(form);

    fetch(form.action, {
      method: 'POST',
      body: data
    })
            .then(res => {
              window.opener.location.href= '/approval/main/wait';
              window.close();
            })
            .catch(err => {
              console.log(err);
              alert('결재 처리 중 오류가 발생했습니다.');
            });
  });
</script>
</body>
</html>