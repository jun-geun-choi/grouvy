<%-- src/main/webapp/WEB-INF/views/department/organization_chart.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.grouvy.department.dto.DeptTreeDto" %>
<%@ page import="com.example.grouvy.user.vo.User" %>
<%@ page import="java.io.IOException" %>
<%@ page import="jakarta.servlet.jsp.JspWriter" %>
<html>
<head>
    <title>Title</title>
    <style>
        body {
            font-family: 'Malgun Gothic', '맑은 고딕', sans-serif;
            margin: 0;
            background-color: #f5f5f5;
            color: #333;
        }
        * {
            box-sizing: border-box;
        }

        .main-container {
            padding: 20px;
            max-width: 800px;
            margin: 20px auto;
        }

        .panel {
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            padding: 25px;
            min-height: 500px;
            display: flex;
            flex-direction: column;
        }

        .panel h2 {
            margin-top: 0;
            margin-bottom: 20px;
            color: #2c3e50;
            font-size: 1.5em;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }

        .org-chart-tree {
            max-height: 550px;
            overflow-y: scroll;
            flex-grow: 1;
            padding-right: 15px;
        }

        .dept-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .dept-item {
            margin-bottom: 3px;
        }
        .dept-name {
            font-weight: bold;
            color: #333;
            cursor: pointer;
            padding: 5px 0;
            display: block;
        }
        .dept-name:hover {
            background-color: #f9f9f9;
        }

        .toggle-icon {
            display: inline-block;
            transition: transform 0.2s ease-in-out;
            margin-right: 5px;
            color: #555;
            font-size: 0.8em;
        }
        .dept-name.expanded .toggle-icon {
            transform: rotate(90deg);
        }

        .user-list {
            list-style: none;
            margin-left: 20px;
            padding-left: 0;
            display: none;
        }
        .user-item {
            font-size: 0.9em;
            color: #555;
            margin-bottom: 2px;
            padding: 3px 0;
        }
        .user-item a {
            /* 세션 저장 로직을 위한 별도 클래스 추가 */
            cursor: pointer; /* 클릭 가능한 UI임을 표시 */
            text-decoration: none;
            color: #007bff;
        }
        .user-item a:hover {
            text-decoration: underline;
        }

        .indent-level-0 { margin-left: 0px; }
        .indent-level-1 { margin-left: 20px; }
        .indent-level-2 { margin-left: 40px; }
        .indent-level-3 { margin-left: 60px; }
        .indent-level-4 { margin-left: 80px; }

        footer {
            text-align: center;
            padding: 20px;
            color: #777;
            font-size: 0.9em;
            margin-top: 30px;
        }

        .selected-user-info {
            background-color: #e0f2f7;
            border: 1px solid #b3e5fc;
            padding: 10px;
            margin-top: 20px;
            border-radius: 5px;
            font-size: 0.95em;
            color: #01579b;
        }
    </style>
</head>
<body>
<c:import url="/WEB-INF/views/common/top.jsp" />

<div class="main-container">
    <div class="panel org-chart-panel">
        <h2>조직도</h2>
        <%--세션에 저장된 사용자 정보 표시--%>
        <c:if test="${not empty sessionScope.selectedUser}">
            <div class="selected-user-info">
                <strong>세션에 저장된 사용자:</strong><br>
                ID: ${sessionScope.selectedUser.userId} / 이름: ${sessionScope.selectedUser.name} / 직위: ${sessionScope.selectedUser.positionName} / 이메일: ${sessionScope.selectedUser.email}
                <button onclick="clearSelectedUser()">선택 사용자 해제</button>
            </div>
        </c:if>
        <c:if test="${empty sessionScope.selectedUser}">
            <div class="selected-user-info">
                <strong>세션에 저장된 사용자 없음</strong><br>
                조직도에서 사용자를 클릭해서 세션에 저장해 보세요.
            </div>
        </c:if><br>

        <div class="org-chart-tree">
            <%!
            // 이 메서드는 재귀적으로 부서 트리를 HTML 목록 형태로 출력합니다.
            public void printDepartmentTree(List<DeptTreeDto> departments, JspWriter out, int level) throws IOException {
            if (departments == null || departments.isEmpty()) {
            return;
            }

            out.println("<ul class='dept-list'>"); // 부서 목록 시작
            for (DeptTreeDto department : departments) {
            String departmentNodeId = "department-" + department.getDepartmentId(); // 각 부서 노드의 고유 ID
            out.println("<li class='dept-item indent-level-" + level + "'>"); // 들여쓰기 레벨 적용

            out.println("<span class='department-name department-level-" + level + "' data-target='" + departmentNodeId + "-users'>");
            out.println("<span class='toggle-icon'>▶</span> "); // 펼치기/접기 아이콘
            out.println(department.getDepartmentName()); // 부서 이름 출력
            out.println("</span>");

            out.println("<ul id='" + departmentNodeId + "-users' class='user-list'>"); // 해당 부서의 사용자 목록 시작
            if (department.getUsers() != null && !department.getUsers().isEmpty()) {
            // 부서에 소속된 사용자가 있다면 반복하여 출력
            for (User user : department.getUsers()) {
            out.println("<li class='user-item'>");
            // 사용자를 클릭하면 JavaScript 함수를 호출하여 세션에 userId를 저장하도록 변경
            out.println("<a href='#' class='select-user-link' data-user-id='" + user.getUserId() + "'>" + user.getName() + "</a> (" + user.getPositionName() + ")");
            out.println("</li>");
            }
            } else {
            // 소속된 사용자가 없을 경우 메시지 출력
            out.println("<li class='user-item' style='font-style: italic; color: #888;'>소속된 사용자가 없습니다.</li>");
            }
            out.println("</ul>"); // 사용자 목록 끝

            // 이 부서의 하위 부서가 있다면 재귀적으로 printDepartmentTree 메서드를 다시 호출하여 출력
            if (department.getChildren() != null && !department.getChildren().isEmpty()) {
            printDepartmentTree(department.getChildren(), out, level + 1);
            }
            out.println("</li>"); // 부서 목록 아이템 끝
            }
            out.println("</ul>"); // 부서 목록 끝
            }
        %>

            <%
                // Controller에서 Model에 담아준 departmentTree 데이터를 가져옵니다.
                List<DeptTreeDto> departmentTree = (List<DeptTreeDto>) request.getAttribute("departmentTree");
                if (departmentTree != null && !departmentTree.isEmpty()) {
                // 데이터가 있다면, 위에서 정의한 printDepartmentTree 메서드를 호출하여 조직도를 출력합니다.
                printDepartmentTree(departmentTree, out, 0); // 최상위 레벨은 0부터 시작
                } else {
                out.println("<p style='color:red;'>조직도 데이터를 불러올 수 없습니다. (데이터 없음)</p>");
                }
            %>
        </div>

    </div>
</div>

<footer>
    <p>© 2025 그룹웨어 Corp.</p>
</footer>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const departmentNames = document.querySelectorAll('.department-name'); // 부서 이름 요소를 선택
        const selectUserLinks = document.querySelectorAll('.select-user-link'); // 사용자 선택 링크 요소를 선택

        // 부서 이름 클릭 시 하위 사용자 목록 토글 기능
        // 부서 이름 클릭 시 하위 사용자 목록 토글 기능
        departmentNames.forEach(departmentName => {
            departmentName.addEventListener('click', function() {
                const targetId = this.dataset.target; // data-target 속성에서 사용자 목록 ID 가져오기
                const userList = document.getElementById(targetId); // 해당 ID의 사용자 목록 요소 가져오기
                const toggleIcon = this.querySelector('.toggle-icon'); // 토글 아이콘 요소 가져오기

                if (userList) {
                    // 현재 사용자 목록이 'block' (표시됨) 상태이면 'none' (숨김)으로, 아니면 'block'으로 변경
                    if (userList.style.display === 'block') {
                        userList.style.display = 'none';
                        this.classList.remove('expanded'); // 'expanded' 클래스 제거
                        if (toggleIcon) toggleIcon.style.transform = 'rotate(0deg)'; // 아이콘 회전 원위치
                    } else {
                        // 다른 열려있는 목록을 닫는 로직을 제거했으므로, 이 부서는 그냥 열립니다.
                        userList.style.display = 'block'; // 현재 사용자 목록 표시
                        this.classList.add('expanded'); // 'expanded' 클래스 추가
                        if (toggleIcon) toggleIcon.style.transform = 'rotate(90deg)'; // 아이콘 회전
                    }
                }
            });
        });

        // 사용자 이름 클릭 시 세션에 USER_ID 저장 기능
        selectUserLinks.forEach(link => {
            link.addEventListener('click', function(event) {
                event.preventDefault(); // 기본 링크 동작(페이지 이동) 방지
                const userId = this.dataset.userId; // data-user-id 속성에서 사용자 ID 가져오기
                // JavaScript에서 서버로 HTTP 요청을 보냅니다.
                // 이 요청은 DepartmentController의 /dept/selectUser 매핑으로 이동합니다.
                window.location.href = '/dept/selectUser?userId=' + userId;
            });
        });
    });

    // 세션에 저장된 사용자 정보 해제 함수
    function clearSelectedUser() {
        window.location.href = '/'; // 홈으로 이동하여 세션 리프레시 유도 (나중에 적절한 세션 삭제 API로 대체)
    }
</script>
</body>
</html>
