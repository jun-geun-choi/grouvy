<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>GROUVY 회원가입</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
            rel="stylesheet">
    <link rel="stylesheet" href="resources/css/user/register.css">
</head>
<body>
<div class="auth-card">
    <img src="resources/image/grouvy_logo.png" alt="GROUVY 로고" class="auth-logo">
    <div class="auth-title">회원가입</div>
    <form:form action="/register" method="post"
               modelAttribute="userRegisterForm">
        <div class="mb-2">
            <label for="signupName" class="form-label small">이름</label>
            <form:input class="form-control" id="signupName" path="name"/>
            <form:errors path="name" cssClass="text-danger"/>
        </div>
        <div class="mb-2">
            <label for="signupPhone" class="form-label small">전화번호</label>
            <form:input class="form-control" id="signupPhone" path="phoneNumber"/>
            <form:errors path="phoneNumber" cssClass="text-danger small"/>
        </div>
        <div class="mb-2">
            <label for="signupEmail" class="form-label small">이메일</label>
            <form:input class="form-control" id="signupEmail" path="email"/>
            <form:errors path="email" cssClass="text-danger small"/>
        </div>
        <div class="mb-3">
            <label for="password1" class="form-label small">비밀번호</label>
            <form:input type="password" class="form-control" id="password" path="password"/>
            <form:errors path="password" cssClass="text-danger small"/>
        </div>
        <div class="mb-3">
            <label for="password2" class="form-label small">비밀번호 확인</label>
            <form:input type="password" class="form-control" id="confirmPassword" path="confirmPassword"/>
            <form:errors path="confirmPassword" cssClass="text-danger small"/>
        </div>
        <button type="submit" class="btn btn-grouvy w-100 mb-2">회원가입</button>
    </form:form>
    <div class="text-center mt-2">
        <a href="login" class="auth-link">로그인으로 돌아가기</a>
    </div>
</div>
</body>
</html>