<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>

	<!-- accountSettingsp 페이지 css -->
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
					<div id="accountSettings-name"><i class="fas fa-user-cog"></i>계정 설정</div>
					<div class="ui secondary pointing menu" id="menu-tab">
						<a class="item active">이메일</a>
						<a class="item">전화번호</a>
						<a class="item">비밀번호</a> 
						<a class="item">계정 탈퇴</a>
					</div>
					<!-- 이메일 변경 -->
					<div class="ui segment" id="update-email-area">
						<form class="ui form">
							<div class="field">
								<label for="email-now">현재 이메일 주소</label>
								<input type="email" id="email-now" value="teetee77@naver.com" disabled>
							</div>
							<div class="field">
								<label for="email-new">변경할 이메일 주소</label>
								<input type="email" id="email-new">
							</div>
							<button class="ui button btn-update-settings" type="submit">이메일 변경</button>
						</form>
					</div>	
	
					<!-- 전화번호 변경 -->
					<div class="ui segment" id="update-tel-area">
						<form class="ui form">
							<div class="field">
								<label for="tel-now">현재 전화번호</label>
								<input type="tel" id="tel-now" value="010-2260-7158" disabled>
							</div>
							<div class="field">
								<label for="tel-new">변경할 전화번호</label>
								<input type="tel" id="tel-new">
							</div>
							<button class="ui button btn-update-settings" type="submit">전화번호 변경</button>
						</form>
					</div>	
	
					<!-- 비밀번호 변경 -->
					<div class="ui segment" id="update-password-area">
						<form class="ui form">
							<div class="field">
								<label for="password-now">현재 비밀번호</label>
								<input type="password" id="password-now" value="">
								<!-- <input type="hidden" value="$2a$10$LfAM52wl5CD/pJjloJpNkuPxxv3vXLrSWEfxZnkTiK.PEx1Tmx/vC" id="pwd-real"> -->
							</div>
							<div class="field">
								<label for="password-new">변경할 비밀번호</label>
								<input type="password" id="password-new">
							</div>
							<button class="ui button btn-update-settings" type="submit">비밀번호 변경</button>
						</form>
					</div>	
	
					<!-- 계정 탈퇴 -->
					<div class="ui segment" id="remove-account-area">
						<form class="ui form">
							<div class="field">
								<p>탈퇴된 계정은 다시 복구할 수 없으며, 탈퇴된 계정으로 생성했던 모든 데이터들 또한 복구할 수 없습니다.</p>
							</div>
							<div class="field">
							  <div class="ui checkbox">
								<input type="checkbox" tabindex="0" class="">
								<label>동의하고 탈퇴를 진행합니다.</label>
							  </div>
							</div>
							<button class="ui button btn-remove-account" type="submit">계정 탈퇴</button>
						</form>
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

	<!-- 모달 모음 (3,4,5,6,7,9 필요) -->
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