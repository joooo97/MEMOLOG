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
						<a class="item active" onclick="showUpdateProfileArea();">프로필</a>
						<a class="item" onclick="showUpdatePasswordArea();">비밀번호 변경</a>
						<a class="item" onclick="showRemoveAccountArea();">계정 탈퇴</a>
	                </div>
	                    
	                <!-- 프로필 변경 -->
					<div class="ui segment" id="update-profile-area">
						<form class="ui form">
							<div class="field">
	                                <label>프로필 이미지</label>
	                                <div id="update-profile-image-area">
	                                    <img src="resources/images/profile/${member.profileRenamedFilename}" alt="프로필 이미지">
	                                </div>
	                                <label>이미지 변경</label>
									<div class="input-group mb-3">
									  <div class="custom-file">
									    <input type="file" class="custom-file-input" id="inputGroupFile02">
										<!-- 이미지 설정하지 않았을 경우 (default 이미지일 경우) -->
										<c:if test="${member.profileRenamedFilename == 'default.jpg'}">
									    	<label class="custom-file-label" for="inputGroupFile02">이미지 선택</label>
										</c:if>
										<c:if test="${member.profileRenamedFilename != 'default.jpg'}">
									    	<label class="custom-file-label" for="inputGroupFile02">${member.profileRenamedFilename}</label>
										</c:if>
									  </div>
									</div>
									<div class="ui checkbox" id="check-default-img">
										<input type="checkbox">
										<label>기본 이미지</label>
							  		</div>
							</div>
							<div class="field">
								<label>아이디</label>
								<input type="text" id="update-profile-id" value="${member.memberId}" disabled>
							</div>
							<div class="field">
								<label>이름</label>
								<input type="text"value="${member.memberName}">
							</div>
							<div class="field">
								<label>이메일</label>
								<input type="email" value="${member.email}">
							</div>
							<div class="field">
								<label>전화번호</label>
								<input type="tel" value="${member.phone}">
							</div>
							<button class="ui button btn-update-settings" type="button">프로필 변경</button>
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
							<button class="ui button btn-update-settings" type="button">비밀번호 변경</button>
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
							<button class="ui button btn-remove-account" type="button">계정 탈퇴</button>
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
	<!-- 모달 js-->
	<script src="${pageContext.request.contextPath}/resources/js/juhyunModal.js?ver=1"></script>
	<!-- 공통스크립트 -->
	<jsp:include page="/WEB-INF/views/common/commonScript.jsp"></jsp:include>
			
	<script>
	
	$(function() {
		// 워크스페이스명, 페이지명이 아닌 토글버튼만 보이기
		$("#header-workspace-name li").not(".toggle").remove();
			
		// semantic dropdown 활성화
		// 사이드바 내 드롭다운 활성화(프로필 보기, 계정 설정, 로그아웃 메뉴)
		$('.ui.dropdown').dropdown();
		
		// semantic ui menu 활성화
		// 프로필 / 비밀번호 변경 / 계정 탈퇴 메뉴 활성화
		$('.ui.pointing.menu').on('click', '.item', function() {
			if(!$(this).hasClass('dropdown')) {
				$(this).addClass('active').siblings('.item').removeClass('active');
			}
		});
		
		// 프로필 메뉴만 보이기
		showUpdateProfileArea();
		
		// 프로필 이미지 변경
		// 1. 기본 이미지 선택 시
		$("#check-default-img input:checkbox").on('change', function() {
			// 기본 이미지 체크박스 체크 시
			if($(this).is(":checked")) {
				$("#update-profile-image-area").html('<img src="resources/images/profile/default.jpg" alt="프로필 이미지">');
				$("input:file").next('.custom-file-label').html("이미지 선택");
			}
		});
		
		// 2. 이미지 선택 클릭 시
		$("#inputGroupFile02").on('change', function() {
			// 2-1) 이미지 선택 취소 시
			if($(this).prop('files')[0] === undefined) {
				$(this).next('.custom-file-label').html("이미지 선택");
				// 기본 프로필 이미지 띄우기
				$("#update-profile-image-area").html('<img src="resources/images/profile/default.jpg" alt="프로필 이미지">');
				return;
			}
			// 2-2) 이미지 선택 시
			else {
				var imageName = $(this).prop('files')[0].name; // ex)이미지명.jpg
				// 이미지명 표시
				$(this).next('.custom-file-label').html(imageName);
				// 기본 이미지 체크 해제
				$("#check-default-img input:checkbox").prop('checked', false);
				// 선택한 이미지 띄우기
				viewProfileImage();
			}
			
			
		});
		
	});
		
	// 함수 영역
	// 프로필 변경 영역 띄우기
	function showUpdateProfileArea() {
		$("#update-password-area").css('display', 'none');
		$("#remove-account-area").css('display', 'none');
		$("#update-profile-area").css('display', 'block');
	}
	
	// 비밀번호 변경 영역 띄우기
	function showUpdatePasswordArea() {
		$("#update-profile-area").css('display', 'none');
		$("#remove-account-area").css('display', 'none');
		$("#update-password-area").css('display', 'block');
	}
	
	// 계정 탈퇴 영역 띄우기
	function showRemoveAccountArea() {
		$("#update-profile-area").css('display', 'none');
		$("#update-password-area").css('display', 'none');
		$("#remove-account-area").css('display', 'block');
	}
	
	// 선택한 프로필 이미지 띄우기
	function viewProfileImage() {
		var upFile = $("#update-profile-area input:file").prop('files')[0];
		var formData = new FormData();
		formData.append('upFile', upFile);
		console.log(formData);
		
		$.ajax({
			url: "${pageContext.request.contextPath}/members/${memberLoggedIn.memberId}/profile-images",
			type: 'POST',
			data: formData,
			processData: false, // 파일 업로드 ajax 시 필수 속성
			contentType: false, // 파일 업로드 ajax 시 필수 속성
			success: data => {
				console.log("선택한 프로필 이미지 불러오기 ajax 처리 성공!");
				console.log(data);
				// 업로드된 이미지 불러오기
				$("#update-profile-image-area").html('<img src="resources/upload/profile/${memberLoggedIn.memberId}/'+data.selectedFileName+'" alt="프로필 이미지">');

			},
			error: (x, s, e) => {
				console.log("선택한 프로필 이미지 불러오기 ajax 처리 실패!", x, s, e);
			}
		});
	};

	
	</script>

	</body>
</html>