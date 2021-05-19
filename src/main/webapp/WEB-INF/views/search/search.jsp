<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>

	<!-- 검색 페이지에서만 필요한 css -->
	<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/juhyun.css" />
	<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/searchPage-accountSettingsPage.css" />

</head>
<body class="is-preload">
	<!-- Wrapper -->
	<div id="wrapper" class="pusher">
		<!-- Main -->
		<div id="main">
			<div class="inner">
				<!-- Content -->
				<section>
					<div class="ui icon input search-tab" id="searchPage-search-tab">
						<input type="text" placeholder="검색" value="${keyword}">
						<i class="link search icon" onclick="search();"></i>
					</div>
					<div class="ui secondary pointing menu" id="menu-tab">
						<a class="item active">워크스페이스명</a>
						<a class="item">페이지명</a>
						<a class="item">포스트</a>
						<a class="item">코멘트</a>
					</div>
					<!-- 검색 결과 -->
					<!-- 1. 워크스페이스명 -->
					<div class="ui segment search-result-area" id="ws-name-area">
						<c:forEach items="${workspaceList}" var="w">
							<div class="ui raised link card">
								<div class="content card-ws-name" onclick="location.href='${pageContext.request.contextPath}/workspaces/${w.workspaceNo}'">
									<i class="fas fa-feather" style="color: ${w.workspaceCoverCode};"></i>${w.workspaceName}
								</div>
							</div>
						</c:forEach>
					</div>	
					<!-- 2. 페이지명 -->
					<div class="ui segment search-result-area" id="page-name-area">
						<!-- 워크스페이스명/페이지명 -->
						<div class="ui raised link card">
							<div class="content card-ws-name">드림</div>
						</div>
						<div class="ui raised link card">
							<div class="content card-page-name">츄잉검</div>
						</div>
					</div>	
					<div class="ui segment search-result-area" id="search-result-workspace-name">
						<!-- 워크스페이스명/페이지명 -->
						<div class="ui raised link card">
							<div class="content card-ws-name">드림</div>
						</div>
						<div class="ui raised link card">
							<div class="content card-page-name">츄잉검</div>
						</div>
						<!-- 포스트 -->
						<!-- 1. 텍스트 -->
						<div class="ui raised link card">
							<div class="ui comments content">
								<div class="meta">
									<a>DEVELOP</a><span>/</span><a>SPRING FRAMEWORK</a><span style="font-weight: bold;">> 텍스트</span>
								</div>
								<div class="comment">
									<a class="avatar"><img src="resources/images/위영드림.jpg" class="img-writer"></a>
									<div class="content">
										<div class="author">이주현
											<div class="metadata"><span>07.25</span></div>
										</div>
										<p>워크스페이스 구현 중 mapper파일에서 문제 발생하였다. 오늘까지 오류 해결 하기!!!!</p>
									</div>
								</div>
							</div>
						</div>
						<!-- 2. 이미지 -->
						<div class="ui raised link card">
							<div class="ui comments content">
								<div class="meta">
									<a>DEVELOP</a>
									<!-- <i class="fas fa-feather" style="color: rgb(243, 215, 224);"></i><a href="#" style="color: gray;"></a>DEVELOP</a> -->
									<span>/</span>
									<!-- <i class="fas fa-sticky-note" style="color: yellowgreen"></i><a href="#" style="color: gray;">SPRING FRAMEWORK</a> -->
									<a>SPRING FRAMEWORK</a>
									<span style="font-weight: bold;">> 이미지</span>
								</div>
								<div class="comment">
									<a class="avatar"><img src="resources/images/위영드림.jpg" class="img-writer"></a>
									<div class="content">
										<div class="author">이주현
											<div class="metadata"><span>07.20</span></div>
										</div>
										<div>
											<div class="text">'0720_워크스페이스구현.jpg'</div>
											<span class="image main"><img src="resources/images/spring.PNG" alt="" style="width: 30%;"/></span>
										</div>
									</div>
								</div>
							</div>
						</div>
						<!-- 3. 코멘트 -->
						<div class="ui raised link card">
							<div class="ui comments content">
								<div class="comment">
								  <a class="avatar"><img src="${pageContext.request.contextPath }/resources/images/위영드림.jpg" class="img-writer"></a>
								  <div class="content">
									<a class="author">이주현</a>
									<div class="metadata">
									  <div class="date">2 days ago</div>
									</div>
									<div class="text">
										아악!!
									</div>
								  </div>
								</div>
							</div>
						</div>
						<div class="ui raised link card">
							<div class="ui comments content">
								<div class="comment">
								  <a class="avatar"><img src="${pageContext.request.contextPath }/resources/images/위영드림.jpg" class="img-writer"></a>
								  <div class="content">
									<a class="author">이주현</a>
									<div class="metadata">
									  <div class="date">2 days ago</div>
									</div>
									<div class="text">
										아악!!
									</div>
								  </div>
								</div>
							</div>
						</div>
						<div class="ui raised link card">
							<div class="ui comments content">
								<div class="comment">
								  <a class="avatar"><img src="${pageContext.request.contextPath }/resources/images/위영드림.jpg" class="img-writer"></a>
								  <div class="content">
									<a class="author">이주현</a>
									<div class="metadata">
									  <div class="date">2 days ago</div>
									</div>
									<div class="text">
										아악!!
									</div>
								  </div>
								</div>
							</div>
						</div>
					</div>	
				</section>
			</div>
			<!-- /#main .inner -->
		</div>
		<!-- /#main -->
		
		<!-- 좌측 사이드바 -->
		<jsp:include page="/WEB-INF/views/common/leftSideBar.jsp"></jsp:include>
	</div>
	<!-- /#wrapper -->
	
	<!-- 모달 모음 - 3,4,5,6,7,9 필요 -->
	<jsp:include page="/WEB-INF/views/common/modals.jsp"></jsp:include>
	<!-- 공통스크립트 -->		
	<jsp:include page="/WEB-INF/views/common/commonScript.jsp"></jsp:include>
		
	<script>

		$(function(){
			//워크스페이스명, 페이지명이 아닌 토글버튼만 보이기
			$("#header-workspace-name li").not(".toggle").remove();
	
			$('.ui.dropdown').dropdown(); //semantic dropdown 활성화
	
			//semantic ui menu 활성화
			$('.ui.pointing.menu').on('click', '.item', function() {
				if(!$(this).hasClass('dropdown')) {
					$(this).addClass('active').siblings('.item').removeClass('active');
				}
			});
	
			//사이드바 각 메뉴 호버 시 관리, 추가 버튼 나타내기
			$("#menu span").hover(function(){
				$(this).find('i').css('visibility', 'visible');
			});
			$("#menu span").mouseleave(function(){
				$(this).find('i').css('visibility', 'hidden');
			});
	
			//사이드바 메뉴 클릭 시 모달 띄우기
			//#1. 개인 워크스페이스 생성
			$("#btn-add-p-workspace").on('click', function(){
				$("#show-modal-add-p-ws").click();
			});
			//#2. 공유 워크스페이스 생성
			$("#btn-add-s-workspace").on('click', function(){
				$("#show-modal-add-s-ws").click();
			});
			//#3. 페이지 생성
			$(".btn-add-page").on('click', function(){
				$("#show-modal-add-page").click();
			});
			//#4. 워크스페이스 수정
			$(".btn-update-ws").on('click', function(){
				$("#show-modal-update-ws").click();
			});
			//#5. 페이지 수정
			$(".btn-update-p").on('click', function(){
				$("#show-modal-update-p").click();
			});
			//#6. 프로필 보기
			$(".btn-show-profile").on('click', function(){
				$("#show-modal-view-profile").click();
			});
			//#7. 이미지 클릭 시 프로필 보기
			$(".img-writer").on('click', function(){
				$("#show-modal-view-profile").click();
			});
	
	
		});
	
		//함수 영역
		
	
	</script>

	</body>
</html>	
