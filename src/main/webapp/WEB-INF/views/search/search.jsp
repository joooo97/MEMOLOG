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
					<div class="ui icon input" id="searchPage-search-tab">
						<input type="text" placeholder="검색">
						<i class="search icon"></i>
					</div>
					<div class="ui secondary pointing menu" id="menu-tab">
						<a class="item active">워크스페이스명</a>
						<a class="item">페이지명</a>
						<a class="item">포스트</a>
						<a class="item">코멘트</a>
					</div>
					<div class="ui segment" id="search-result-area">
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
								<div class="meta"><span class="category">텍스트</span></div>
								<div class="comment">
								  <a class="avatar"><img src="${pageContext.request.contextPath }/resources/images/위영드림.jpg" class="img-writer"></a>
								  <div class="content">
									<a class="author">Stevie Feliciano</a>
									<div class="metadata">
									  <div class="date">2 days ago</div>
									</div>
									<div class="text">
									  Hey guys, I hope this example comment is helping you read this documentation.
									</div>
								  </div>
								</div>
							</div>
						</div>
						<!-- 2. 이미지 -->
						<div class="ui raised link card">
							<div class="ui comments content">
								<div class="meta"><span class="category">첨부파일//테이블은 나중</span></div>
								<div class="comment">
									<a class="avatar"><img src="${pageContext.request.contextPath }/resources/images/위영드림.jpg" class="img-writer"></a>
									<div class="content">
										<div class="author">'위영드림.jpg'</div>
										<div class="metadata">
											 <span>제노</span>
											  <span>2 days ago</span>
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
