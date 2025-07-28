<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>GROUVY 로그인</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
            rel="stylesheet">
    <link rel="stylesheet" href="resources/css/user/login.css">
</head>
<body>
<div class="auth-card">
    <img src="https://storage.googleapis.com/grouvy-profile-bucket/grouvy_logo.png" alt="GROUVY 로고" class="auth-logo">
    <div class="auth-title">로그인</div>
    <form action="/login" method="post">
      <!-- <sec:csrfInput/> -->
        <div class="mb-3">
            <label for="loginEmail" class="form-label small">이메일</label> <input
                type="text" class="form-control" id="loginEmail" name="email" required>
        </div>
        <!-- name="email" : SecurityConfig 설정에 따름 -->
        <div class="mb-3">
            <label for="loginPw" class="form-label small">비밀번호</label> <input
                type="password" class="form-control" id="loginPw" name="password" required>
        </div>
        <button type="submit" class="btn btn-grouvy w-100 mb-2">로그인</button>
    </form>
    <div class="text-center mt-2">
        <a href="register" class="auth-link">회원가입</a>
    </div>
</div>
</body>
</html>
