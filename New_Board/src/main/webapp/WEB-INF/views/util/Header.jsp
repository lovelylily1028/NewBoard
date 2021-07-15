<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- HeaderBox start -->
<div id="header">
	<div class="container">
		<div class="header">
			<h1>
				<a href="/"><img src="../resources/img/huation_CI_5.png" alt="휴에이션 마크"></a>
			</h1>
			<div class="gnb">
				<ul>
					<%-- 로그인/ 로그아웃 --%>
					<c:choose>
						<c:when test="${empty sessionScope.user_id }">
							<li><a href="/list">Home</a><span>|</span></li>
							<li><a href="/login">로그인</a><span>|</span></li>
							<li><a onclick="location.href='../joinPage'">회원가입</a></li>
						</c:when>
						<c:otherwise>
							<li><strong>${user_id }</strong> 님 환영합니다.<span>|</span></li>
							<li><a href="/list">HOME</a><span>|</span></li>
							<li><a onclick="location.href='../logout'">로그아웃</a></li>
						</c:otherwise>
					</c:choose>
				</ul>
			</div>
		</div>
		<!-- //header-->
	</div>
	<!-- //container -->
	<div id="lnb">
		<div class="container">
			<div class="lnb">
				<ul>
					<li><a class="mMenu"></a></li>
				</ul>
			</div>
		</div>
	</div>
	<!-- // lnb -->
</div>
<!--// HeaderBox -->
