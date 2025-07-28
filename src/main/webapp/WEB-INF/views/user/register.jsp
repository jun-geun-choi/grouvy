<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../common/taglib.jsp"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
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
    <img src="https://storage.googleapis.com/grouvy-bucket/grouvy_logo.png" alt="GROUVY 로고" class="auth-logo">
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
            <div class="input-group">
                <form:input class="form-control" id="signupEmail" path="email"/>
                <button class="btn btn-grouvy-check" type="button" id="verifyEmailBtn">인증요청</button>
            </div>
            <form:errors path="email" cssClass="text-danger small"/>
        </div>
        <!-- 이메일 인증 코드 입력 -->
        <div class="mb-2" id="emailCodeDiv">
            <label for="emailCode" class="form-label small">인증 코드</label>
            <form:input type="text" class="form-control" id="emailCode" path="confirmCode" placeholder="이메일로 전송된 코드를 입력하세요" />
            <div class="form-text text-muted">입력 후 자동 인증됩니다.</div>
            <form:errors path="confirmCode" cssClass="text-danger small"/>
        </div>

        <div class="mb-2">
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
<!-- 이메일 인증 관련 JS -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    const $verifyEmailBtn = $('#verifyEmailBtn');
    const $signupEmail = $('#signupEmail');
    const $emailCodeDiv = $('#emailCodeDiv');
    const $emailCode = $('#emailCode');

    $verifyEmailBtn.click(function() {
        const email = $signupEmail.val();
        if (!email) {
            alert("이메일을 입력해주세요.");
            return;
        }

        $.ajax({
            type: "POST",
            url: "/register/check-mail",
            data: {email : email},
            success:function (isAvailable) {
                if (!isAvailable) {
                    alert("이미 가입된 이메일입니다.")
                    return;
                }

                alert("해당 이메일로 인증번호가 전송되었습니다.");

                $.ajax({
                    type: "POST",
                    url: "register/mailConfirm",
                    data: { email: email },
                    success: function(data) {
                        // $emailCodeDiv.show(); // 인증 코드 입력칸 보이기

                        $emailCode.on("keyup", function () {
                            if (data !== $emailCode.val()) {
                                $("#emailCodeDiv .form-text").html("인증번호가 잘못되었습니다")
                                    .css({ color: "#e6002d", fontWeight: "bold" });
                            } else {
                                $("#emailCodeDiv .form-text").html("인증 완료되었습니다")
                                    .css({ color: "#0D6EFD", fontWeight: "bold" });
                            }
                        });
                    },
                    error: function() {
                        alert("이메일 전송 실패. 서버 확인 필요.");
                    }
                });
            }
        })


    });
</script>
</body>
</html>