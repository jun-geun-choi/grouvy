<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<div class="sidebar">
    <h3>전자결재</h3>
    <div class="sidebar-section">
        <div class="sidebar-section-title">기안</div>
        <ul class="sidebar-list">
            <li class="${active eq 'draft' ? 'active' : ''}">
                <a href="/approval/main/draft" style="text-decoration: none; color: inherit;">기안문작성</a></li>
            <li class="${active eq 'request' ? 'active' : ''}">
                <a href="/approval/main/request" style="text-decoration: none; color: inherit;">결재요청함</a></li>
<%--            <li><a href="temp.jsp" style="text-decoration: none; color: inherit;">임시저장함</a></li>--%>
        </ul>
    </div>
    <div class="sidebar-section">
        <div class="sidebar-section-title red">결재</div>
        <ul class="sidebar-list">
            <li class="${active eq 'wait' ? 'active' : ''}">
                <a href="/approval/main/wait" style="text-decoration: none; color: inherit;">결재대기함</a></li>
            <li class="${active eq 'progress' ? 'active' : ''}">
                <a href="/approval/main/progress" style="text-decoration: none; color: inherit;">결재진행함</a></li>
            <li class="${active eq 'complete' ? 'active' : ''}">
                <a href="/approval/main/complete" style="text-decoration: none; color: inherit;">완료문서함</a></li>
            <li class="${active eq 'reject' ? 'active' : ''}">
                <a href="/approval/main/reject" style="text-decoration: none; color: inherit;">반려문서함</a></li>
        </ul>
    </div>
<%--    <div class="sidebar-section">--%>
<%--        <div class="sidebar-section-title">발신/수신</div>--%>
<%--        <ul class="sidebar-list">--%>
<%--            <li><a href="receive.jsp" style="text-decoration: none; color: inherit;">부서수신함 <span class="badge">0</span></a></li>--%>
<%--        </ul>--%>
<%--    </div>--%>
<%--    <div class="sidebar-section">--%>
<%--        <div class="sidebar-section-title">개인보관함</div>--%>
<%--    </div>--%>
    <div class="sidebar-section">
        <div class="sidebar-section-title">환경설정</div>
        <ul class="sidebar-list">
            <li class="${active eq 'delegatee' ? 'active' : ''}">
                <a href="/approval/main/delegatee" style="text-decoration: none; color: inherit;">위임관리</a></li>
<%--            <li>개인보관함관리</li>--%>
        </ul>
    </div>
</div>