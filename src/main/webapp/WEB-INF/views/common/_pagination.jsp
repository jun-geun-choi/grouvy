<%-- src/main/webapp/WEB-INF/views/common/_pagination.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%--
    이 JSP는 JavaScript를 통해 동적으로 페이징 UI를 생성하고 이벤트를 처리합니다.
    따라서 직접적인 href 링크를 생성하지 않고, JavaScript 함수를 호출합니다.
    페이징 데이터를 JSON으로 받기 때문에, 이 JSP 자체는 더 이상 model에서 PaginationResponse를 직접 사용하지 않습니다.
    대신, JavaScript에서 이 HTML 구조를 동적으로 생성하여 사용하거나,
    아니면 이 JSP를 include하여 빈 컨테이너만 제공하고 JavaScript가 채우는 방식으로 사용합니다.

    여기서는 이 JSP 파일을 그대로 include해서 사용하고,
    JavaScript가 특정 HTML 요소(예: id="paginationContainer")의 내용을 동적으로 채우도록 할 것입니다.
    따라서 이 JSP 자체는 <c:if> 조건 없이 빈 DIV만 제공하고, 모든 로직은 JS에서 처리합니다.
--%>
<style>
    /* Bootstrap 5 기반 스타일 */
    .pagination-container {
        display: flex;
        justify-content: center;
        align-items: center;
        margin-top: 20px;
        flex-wrap: wrap;
    }

    .pagination-container .page-item {
        margin: 0 2px;
    }

    .pagination-container .page-link {
        padding: 8px 12px;
        border: 1px solid #dee2e6;
        border-radius: 0.25rem;
        text-decoration: none;
        color: #007bff;
        background-color: #fff;
        transition: all 0.2s ease;
    }

    .pagination-container .page-link:hover {
        background-color: #e9ecef;
        border-color: #0056b3;
        color: #0056b3;
    }

    .pagination-container .page-item.active .page-link {
        background-color: #007bff;
        color: white;
        border-color: #007bff;
        font-weight: bold;
        cursor: default;
    }

    .pagination-container .page-item.disabled .page-link {
        color: #6c757d;
        cursor: not-allowed;
        background-color: #f8f9fa;
        border-color: #dee2e6;
    }

    .pagination-container .page-item.disabled .page-link:hover {
        background-color: #f8f9fa;
        color: #6c757d;
        border-color: #dee2e6;
    }
</style>

<div id="paginationContainer" class="pagination-container">
    <!-- JavaScript가 페이징 링크들을 동적으로 여기에 삽입할 것입니다. -->
    <!-- 예시: <ul class="pagination">...</ul> -->
</div>

<script>
    // 이 스크립트는 _pagination.jsp가 include될 때마다 실행될 수 있으므로,
    // 동적 렌더링을 위한 함수는 각 목록 페이지의 JavaScript에서 직접 정의하고,
    // 이 _pagination.jsp는 그 함수를 호출할 수 있도록 헬퍼 함수를 제공하거나,
    // 아니면 이 부분은 완전히 각 페이지의 JS로 옮겨가는 것이 좋습니다.
    // 현재는 이 JSP가 단순히 컨테이너를 제공하고, JS가 이 컨테이너를 채우는 방식으로 사용될 것입니다.
    // 따라서, 이 JSP 자체에서는 페이지 번호를 생성하는 JS를 포함하지 않습니다.
</script>