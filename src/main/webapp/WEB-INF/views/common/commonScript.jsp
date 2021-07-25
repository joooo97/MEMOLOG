<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
	
	<!-- Scripts -->
	<!-- 스크립트 없어도 되는지 확인하기! -->
	<!-- #1. 좌측 sidebar 관련 js -->
	<!-- browser, breakpoints, main 없으면 왼쪽 사이드바 안 됨 -->
	<script src="${pageContext.request.contextPath }/resources/js/setting/browser.min.js"></script> 
	<script src="${pageContext.request.contextPath }/resources/js/setting/breakpoints.min.js"></script>
	<!-- <script src="${pageContext.request.contextPath }/resources/js/setting/util.js"></script> -->
	<script src="${pageContext.request.contextPath }/resources/js/setting/main.js?"></script>
	<!-- #2. bootstrap script -->
	<!-- <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script> -->
	<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
	<!-- #3. semantic script -->
	<!-- semantic.js 아래 있어야 사이드바 움직임 -->
	<script src="${pageContext.request.contextPath }/resources/plugins/semantic/semantic.js"></script>
	<!-- #4. summernote -->
	<script src="${pageContext.request.contextPath }/resources/plugins/summernote/summernote-lite.js"></script>
	<script src="${pageContext.request.contextPath }/resources/plugins/summernote/lang/summernote-ko-KR.js"></script>
	<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/plugins/summernote/summernote-lite.css">
