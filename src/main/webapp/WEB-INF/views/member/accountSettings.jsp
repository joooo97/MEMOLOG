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
						<a class="item active">프로필</a>
						<a class="item">비밀번호 변경</a>
						<a class="item">계정 탈퇴</a>
	                </div>
	                    
	                <!-- 프로필 변경 -->
					<div class="ui segment" id="update-profile-area">
						<form class="ui form">
							<div class="field">
	                                <label>프로필 이미지</label>
	                                <div id="update-profile-image-area">
	                                    <img src="resources/images/위영드림.jpg" alt="프로필 이미지">
	                                </div>
	                                <label>이미지 변경</label>
	                                <input type="file" class="form-control-file">
							</div>
							<div class="field">
								<label>아이디</label>
								<input type="text" id="update-profile-id" value="joo0726" disabled>
							</div>
							<div class="field">
								<label>이름</label>
								<input type="text"value="">
							</div>
							<div class="field">
								<label>이메일</label>
								<input type="email" value="teetee77@naver.com">
							</div>
							<div class="field">
								<label>전화번호</label>
								<input type="tel">
							</div>
							<button class="ui button btn-update-settings" type="submit">프로필 변경</button>
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
				
			// semantic dropdown 활성화
			// 사이드바 내 드롭다운 활성화(프로필 보기, 계정 설정, 로그아웃 메뉴)
			$('.ui.dropdown').dropdown();
			
			//semantic ui menu 활성화
			// 프로필 / 비밀번호 변경 / 계정 탈퇴 메뉴 활성화
			$('.ui.pointing.menu').on('click', '.item', function() {
				if(!$(this).hasClass('dropdown')) {
					$(this).addClass('active').siblings('.item').removeClass('active');
				}
			});
	
		});
	
		//함수 영역
	
	</script>

	</body>
</html>