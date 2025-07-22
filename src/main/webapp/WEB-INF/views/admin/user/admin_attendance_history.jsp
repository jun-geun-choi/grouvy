<%--
  Created by IntelliJ IDEA.
  User: hyunbin
  Date: 2025. 7. 22.
  Time: 오후 1:52
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>출근/퇴근 기록 관리</title>
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
            rel="stylesheet">
    <style>
        body {
            background-color: #f7f7f7;
            font-family: Arial, sans-serif;
            margin: 0;
        }

        .navbarr {
            display: flex;
            justify-content: flex-end;
            background-color: #34495e;
        }

        .navbarr a {
            padding: 10px 20px;
            color: white;
            text-decoration: none;
            display: inline-block;
        }

        .navbarr a:hover, .navbarr a.active {
            background-color: #1abc9c;
        }

        .navbar-brand {
            color: #e6002d !important;
            font-size: 1.5rem;
        }

        .navbar h3 {
            margin: 0 auto;
            padding-top: 10px;  /* 🔑 이 부분 추가 */
            padding-bottom: 10px;
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
            width: 200px;
            background-color: white;
            border-radius: 8px;
            padding: 15px;
            margin-right: 20px;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
        }

        .sidebar h3 {
            margin-top: 0;
            font-size: 16px;
            border-bottom: 1px solid #ddd;
            padding-bottom: 10px;
        }

        .sidebar ul {
            list-style: none;
            padding: 0;
        }

        .sidebar ul li {
            margin: 10px 0;
        }

        .sidebar ul li a {
            color: #333;
            text-decoration: none;
        }

        .sidebar ul li a.active, .sidebar ul li a:hover {
            color: #1abc9c;
            font-weight: bold;
        }

        .main-content {
            flex: 1;
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
        }

        footer {
            text-align: center;
            padding: 10px;
            font-size: 12px;
            color: #999;
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand d-flex align-items-center" href="/">
				<span class="logo-crop">
					<img src="grouvy_logo.jpg" alt="GROUVY 로고" class="logo-img">
				</span>
        </a>
        <h3>
            <a class="mb-2 mb-lg-0 text-decoration-none text-dark" href="/admin">관리자 페이지</a>
        </h3>
        <div class="d-flex align-items-center">
            <a href="mypage.html" >
                <img src="https://search.pstatic.net/sunny/?src=https%3A%2F%2Fs3.orbi.kr%2Fdata%2Ffile%2Funited2%2F6cc64e06aa404ac3a176745b9c1d5bfa.jpeg&type=sc960_832"
                     alt="프로필" class="rounded-circle" width="36" height="36">
            </a>
            <a href="mypage.html" class="ms-2 text-decoration-none text-dark">마이페이지</a>
        </div>
    </div>
</nav>
<nav class="navbarr">
    <a href="#">전자결재</a>
    <a href="#">업무관리</a>
    <a href="#">업무문서함</a>
    <a href="#">조직도</a>
</nav>
<div class="container">
    <div class="sidebar">
        <h3>관리 기능</h3>
        <ul>
            <li><a href="/userApproval">회원가입 승인</a> </li>
            <li><a href="/userList">사용자 계정관리</a> </li>
            <li><a href="/userLoginHistory">로그인 기록</a> </li>
            <li><a href="/userAttendanceHistory" class="active">출퇴근 기록</a></li>
        </ul>
    </div>
    <div class="main-content">
        <h2>출근/퇴근 기록 관리</h2>
        <table class="table table-bordered align-middle">
            <thead class="table-light">
            <tr>
                <th>사원명</th>
                <th>사원번호</th>
                <th>부서</th>
                <th>출근 시각</th>
                <th>퇴근 시각</th>
                <th>근무 시간</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td>홍길순</td>
                <td>20250001</td>
                <td>영업팀</td>
                <td>2025-07-07 08:37:16</td>
                <td>2025-07-07 15:39:20</td>
                <td>7시간 2분</td>
            </tr>
            <!-- 추가 행 -->
            </tbody>
        </table>
    </div>
</div>
<footer>© 2025 그룹웨어 Corp.</footer>
</body>
</html>