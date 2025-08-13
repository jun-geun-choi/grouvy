<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>결재대기함 - 도서구입 신청서</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
  <style>
    body {
      margin: 0;
      font-family: Arial, sans-serif;
      background-color: #f5f5f5;
      color: #333;
      padding-top: 80px;
    }
    .navbar-brand { color: #e6002d !important; font-size: 1.5rem; }
    .nav-item { padding-right: 1rem; }
    .navbar-nav .nav-link.active { font-weight: bold; color: #e6002d !important; }
    .logo-img { width: 160px; height: 50px; object-fit: cover; object-position: center; }
    .navbar .container-fluid { padding-right: 2rem; }
    .container { display: flex; padding: 20px; }
    .sidebar { width: 220px; background-color: white; border-radius: 12px; padding: 15px; margin-right: 20px; box-shadow: 0 0 5px rgba(0, 0, 0, 0.1); height: fit-content; }
    .sidebar h3 { margin-top: 0; font-size: 16px; border-bottom: 1px solid #ddd; padding-bottom: 10px; color: #e6002d; font-weight: bold; }
    .sidebar-section { margin-bottom: 20px; }
    .sidebar-section-title { font-size: 14px; font-weight: bold; color: #333; margin-bottom: 8px; cursor: pointer; display: flex; align-items: center; justify-content: space-between; }
    .sidebar-section-title.red { color: #e6002d; }
    .sidebar-list { list-style: none; padding: 0; margin: 0; }
    .sidebar-list li { margin: 5px 0; padding: 8px 12px; border-radius: 6px; cursor: pointer; transition: background-color 0.2s; font-size: 16px; }
    .sidebar-list li.active, .sidebar-list li:hover { background-color: #f8f9fa; color: #1abc9c; font-weight: bold; }
    .sidebar-list li .badge { background-color: #e6002d; color: white; border-radius: 12px; padding: 2px 6px; font-size: 11px; margin-left: 5px; }
    .sidebar-list li .badge.orange { background-color: #ff9800; }
    .sidebar-list li .badge.gray { background-color: #6c757d; }
    .main-content { flex: 1; background-color: white; padding: 30px; border-radius: 12px; box-shadow: 0 0 5px rgba(0, 0, 0, 0.1); }
    .main-content h2 { font-size: 24px; font-weight: bold; margin-bottom: 24px; color: #333; }
    .info-table { width: 100%; margin-bottom: 24px; background: #fafbfc; border-radius: 8px; border: 1px solid #eee; table-layout: fixed; }
    .info-table th, .info-table td { padding: 10px 14px; font-size: 15px; border-bottom: 1px solid #f0f0f0; }
    .info-table th { background: #f8f9fa; color: #888; font-weight: 500; width: 20%; }
    .info-table td { width: 30%; }
    .info-table tr:last-child th, .info-table tr:last-child td { border-bottom: none; }

    .approval-line-table { width: 100%; border-collapse: collapse; }
    .approval-line-table th, .approval-line-table td { 
      padding: 8px 12px; 
      text-align: center; 
      border: 1px solid #ddd; 
      font-size: 14px; 
    }
    .approval-line-table th { 
      background-color: #f8f9fa; 
      color: #888; 
      font-weight: 500; 
      font-size: 13px; 
    }
    .approval-line-table td { 
      color: #333; 
      font-weight: 500; 
    }
    .approval-line-table tbody tr:last-child td { 
      color: #aaa; 
      font-size: 13px; 
      font-weight: normal; 
    }
    .doc-table { width: 100%; margin-bottom: 24px; border-radius: 8px; border: 1px solid #eee; background: #fafbfc; table-layout: fixed; }
    .doc-table th, .doc-table td { padding: 10px 14px; font-size: 15px; border-bottom: 1px solid #f0f0f0; }
    .doc-table th { background: #f8f9fa; color: #888; font-weight: 500; }
    .doc-table tr:last-child th, .doc-table tr:last-child td { border-bottom: none; }
    .btn-group { margin-bottom: 24px; }
    .btn-group .btn { margin-right: 8px; min-width: 90px; }
    .btn-group .btn:last-child { margin-right: 0; }
    @media (max-width: 1000px) { .container { flex-direction: column; } .sidebar { width: 100%; margin-bottom: 20px; } }
  </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/nav.jsp" />
  <main>
    <div class="container">
        <jsp:include page="/WEB-INF/views/approval/common/sidebar.jsp" />
      <div class="main-content">
          <div class="d-flex justify-content-end gap-2 mb-3">
              <c:choose>
                  <c:when test="${active eq 'wait'}">
                      <button class="btn btn-primary" id="btnApprove">결재</button>
                      <a href="/approval/main/wait" class="btn btn-outline-secondary">목록</a>
                  </c:when>
                  <c:when test="${active eq 'progress'}">
                      <a href="/approval/main/progress" class="btn btn-outline-secondary">목록</a>
                  </c:when>
                  <c:when test="${active eq 'request'}">
                      <a href="/approval/main/request" class="btn btn-outline-secondary">목록</a>
                  </c:when>
                  <c:when test="${active eq 'complete'}">
                      <a href="/approval/main/complete" class="btn btn-outline-secondary">목록</a>
                  </c:when>
                  <c:when test="${active eq 'reject'}">
                      <a href="/approval/main/reject" class="btn btn-outline-secondary">목록</a>
                  </c:when>
                  <c:otherwise>
                      <a href="/approval/main" class="btn btn-outline-secondary">목록</a>
                  </c:otherwise>
              </c:choose>
          </div>
        <h2 class="text-center mb-4">도서구입 신청서</h2>
        <div class="row mb-4 justify-content-end">
          <div class="col-md-5">
            <table class="approval-line-table">
              <thead>
                <tr>
                  <th>기안</th>
                    <c:forEach var="approver" items="${approvers }" varStatus="loop">
                      <c:choose>
                        <c:when test="${fn:length(approvers) != loop.count}">
                          <th>결재</th>
                        </c:when>
                        <c:otherwise>
                          <th>최종</th>
                        </c:otherwise>
                    </c:choose>
                  </c:forEach>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>${approvalWriter.writerName} ${approvalWriter.positionName}</td>
                  <c:forEach var="approver" items="${approvers}" varStatus="loop">
                    <td>${approver.approverName} ${approver.positionName} ${approver.isdelegatee}</td>
                  </c:forEach>
                </tr>
                <tr>
                  <td><fmt:formatDate value="${approvalWriter.createdDate}" pattern="yyyy-MM-dd" /></td>
                  <c:forEach var="approver" items="${approvers}" varStatus="loop">
                    <td>${approver.status}</td>
                  </c:forEach>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
        <table class="info-table mb-4">
          <tr>
            <th>문서번호</th><td>${approval.approvalNo}</td>
            <th>기안일자</th><td><fmt:formatDate value="${approval.createdDate}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
          </tr>
          <tr>
            <th>기안자</th><td>${approval.writerName}</td>
            <th>기안부서</th><td>${approval.approvalDepartmentName}</td>
          </tr>
          <tr>
            <th>참조자</th><td></td>
            <th>수신처</th><td>${approval.receiverDepartmentName}</td>
          </tr>
          <tr>
            <th>문서제목</th><td colspan="3">${approval.title}</td>
          </tr>
        </table>

        <table class="doc-table mb-4">
          <tr>
            <th style="width:20%;">신청부서</th>
            <td style="width:30%;">${approval.approvalDepartmentName}</td>
            <th style="width:20%;">수령희망일</th>
            <td style="width:30%;">${formData.desiredDate}</td>
          </tr>
          <tr>
            <th>구입사유</th>
            <td colspan="3">${formData.reason}</td>
          </tr>
        </table>
        <table class="doc-table">
          <thead>
            <tr>
              <th>도서명</th>
              <th>출판사</th>
              <th>저자</th>
              <th>수량</th>
              <th>금액</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="book" items="${formData.books}" varStatus="loop">
              <tr>
                <td>${book.title}</td>
                <td>${book.publisher}</td>
                <td>${book.author}</td>
                <td>${book.quantity}</td>
                <td>${book.price}</td>
              </tr>
            </c:forEach>
            <tr>
              <td></td>
              <td></td>
              <th>합계</th>
              <td>${formData.totalQty}</td>
              <td>${formData.totalPrice}</td>
            </tr>
          </tbody>
        </table>
        
        <!-- 결재의견 표시 -->
        <div class="approval-comment-section mt-4">
                     <h4 class="mb-3" style="color: #333; font-weight: bold; border-bottom: 2px solid #e6002d; padding-bottom: 8px;">
             결재의견
           </h4>
          <div class="row">
            <div class="col-12">
              <c:choose>
                <c:when test="${hasAnyOpinion}">
                  <div class="approval-comments-container">
                    <c:forEach var="approver" items="${approvers}" varStatus="loop">
                      <c:if test="${not empty approver.opinion}">
                                                 <div class="approval-comment-card mb-2" style="background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%); border: 1px solid #e9ecef; border-radius: 12px; padding: 12px 16px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); transition: all 0.3s ease;">
                           <div class="comment-header d-flex align-items-center mb-2" style="border-bottom: 1px solid #e9ecef; padding-bottom: 8px;">
                            <div class="approver-avatar me-3" style="width: 40px; height: 40px; background: linear-gradient(135deg, #e6002d, #ff6b6b); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-weight: bold; font-size: 14px;">
                              ${fn:substring(approver.approverName, 0, 1)}
                            </div>
                            <div class="approver-info">
                                                             <div class="approver-name" style="font-weight: bold; color: #333; font-size: 16px; margin-bottom: 2px;">
                                 ${approver.approverName}
                                 <c:if test="${not empty approver.isdelegatee}">
                                   <span class="badge bg-warning text-dark ms-2" style="font-size: 12px; padding: 4px 8px;">위임중</span>
                                 </c:if>
                               </div>
                              <div class="approver-position" style="color: #6c757d; font-size: 13px;">
                                ${approver.positionName}
                              </div>
                            </div>
                            <div class="approval-status ms-auto">
                              <c:choose>
                                <c:when test="${approver.status eq '결재완료'}">
                                  <span class="badge bg-success" style="font-size: 12px; padding: 6px 12px;">
                                    <i class="fas fa-check me-1"></i>결재완료
                                  </span>
                                </c:when>
                                <c:when test="${approver.status eq '반려'}">
                                  <span class="badge bg-danger" style="font-size: 12px; padding: 6px 12px;">
                                    <i class="fas fa-times me-1"></i>반려
                                  </span>
                                </c:when>
                              </c:choose>
                            </div>
                          </div>
                          <div class="comment-content">
                              <div class="comment-text" style="color: #333; line-height: 1.6; font-size: 16px; white-space: pre-wrap; background-color: #ffffff; padding: 1px; border-radius: 8px; border-left: 4px solid #e6002d;">    ${approver.opinion}
                             </div>
                          </div>
                        </div>
                      </c:if>
                    </c:forEach>
                  </div>
                </c:when>
                <c:otherwise>
                  <div class="no-comment-display" style="background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%); border: 2px dashed #dee2e6; border-radius: 12px; padding: 40px; text-align: center; min-height: 120px; display: flex; align-items: center; justify-content: center;">
                    <div class="no-comment-content">
                      <i class="fas fa-comment-slash" style="font-size: 48px; color: #adb5bd; margin-bottom: 16px; display: block;"></i>
                      <p style="margin: 0; color: #6c757d; font-size: 16px; font-weight: 500;">등록된 결재의견이 없습니다.</p>
                      <p style="margin: 8px 0 0 0; color: #adb5bd; font-size: 14px;">결재자가 의견을 등록하면 여기에 표시됩니다.</p>
                    </div>
                  </div>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
        </div>
      </div>
    </div>
  </main>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
  <script>
document.getElementById('btnApprove').onclick = function(e) {
  e.preventDefault();
  var popupWidth = 900;
  var popupHeight = 500;
  var left = window.screenX + (window.outerWidth - popupWidth) / 2;
  var top = window.screenY + (window.outerHeight - popupHeight) / 2;
  const approvalNo = '${approval.approvalNo}';
  window.open('/approval/approval_approve_popup?no=' + approvalNo, 'approvePopup', 'width=' + popupWidth + ',height=' + popupHeight + ',left=' + left + ',top=' + top + ',resizable=yes,scrollbars=yes');
};
document.getElementById('btnProgress').onclick = function(e) {
  e.preventDefault();
  var popupWidth = 900;
  var popupHeight = 600;
  var left = window.screenX + (window.outerWidth - popupWidth) / 2;
  var top = window.screenY + (window.outerHeight - popupHeight) / 2;
  window.open('approval_progress_popup.html', 'progressPopup', `width=${popupWidth},height=${popupHeight},left=${left},top=${top},resizable=yes,scrollbars=yes`);
};
</script>
</body>
</html>
