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
	                                <div id="update-profile-image-area"></div>
	                                <label>이미지 변경</label>
									<div class="input-group mb-3">
									  <div class="custom-file">
									    <input type="file" class="custom-file-input">
									    <label class="custom-file-label"></label>
									  </div>
									</div>
									<div class="ui checkbox" id="check-default-img">
										<input type="checkbox">
										<label>기본 이미지</label>
							  		</div>
							</div>
							<div class="field">
								<label>아이디</label>
								<input type="text" id="update-profile-id" value="${memberLoggedIn.memberId}" disabled>
							</div>
							<div class="field">
								<label>이름</label>
								<input type="text" placeholder="이름을 입력해주세요." id="update-profile-name">
								<span class="valid">알맞은 형식의 이름을 입력해주세요.</span>
							</div>
							<div class="field">
								<label>이메일</label>
								<input type="email" placeholder="이메일을 입력해주세요." id="update-profile-email">
								<span class="valid">알맞은 형식의 이메일을 입력해주세요.</span>
							</div>
							<div class="field">
								<label>전화번호</label>
								<input type="tel" placeholder="전화번호를 입력해주세요. ( - 제외)" id="update-profile-phone">
								<span class="valid">알맞은 형식의 전화번호를 입력해주세요.</span>
							</div>
							<button class="ui button btn-update-settings" type="button" onclick="updateProfile('${memberLoggedIn.profileOriginalFilename}');">프로필 변경</button>
						</form>
					</div>	
	
					<!-- 비밀번호 변경 -->
					<div class="ui segment" id="update-password-area">
						<form class="ui form">
							<div class="field">
								<label for="currentPassword">현재 비밀번호</label>
								<input type="password" id="currentPassword">
							</div>
							<div class="field">
								<label for="newPassword">변경할 비밀번호</label>
								<input type="password" id="newPassword" placeholder="영문자, 숫자, 특수문자를 포함하여 8-15자를 입력해주세요.">
								<span class="valid">알맞은 형식의 비밀번호를 입력해주세요.</span>
							</div>
							<div class="field">
								<label for="check-newPassword">변경할 비밀번호 확인</label>
								<input type="password" id="check-newPassword">
							</div>
							<button class="ui button btn-update-settings" type="button" onclick="checkPasswordValid();">비밀번호 변경</button>
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
	// 정규 표현식
	var regName = /^[a-zA-Z가-힣]{2,}$/;
	var regPassword = /^(?=.*[a-z])(?=.*[0-9])(?=.*[~!@#$%^&*()\-_+=]).{8,15}$/;
	//또는 var regPassword = /^(?=^.{8,15}$)(?=.*[a-zA-z])(?=.*[0-9])(?=.*[~!@#$%^&*()\-_+=]).*$/;
	var regEmail = /[a-zA-Z0-9._+-]+@[a-zA-Z0-9]+\.[a-zA-Z0-9.]+/;
	var regPhone = /^\d{10,11}$/;
	
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
		$("#update-profile-area input:file").on('change', function() {
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
		
		// 사용자 정보 입력 시 유효성 체크에 따른 메세지 띄우기
		// 이름 유효성 체크
		$("#update-profile-name").keyup(function() {
			var name = $(this).val().trim();
			
			if(!regName.test(name)) {
				$(this).css('border', '1px solid red');
				$(this).next().css('display', 'block'); // 유효성 체크 메세지 띄우기
			}
			else {
				$(this).css('border', '1px solid rgba(34, 36, 38, 0.15)');
				$(this).next().css('display', 'none');
			}
		});
		// 이메일 유효성 체크
		$("#update-profile-email").keyup(function() {
			var email = $(this).val().trim();
			
			if(!regEmail.test(email)) {
				$(this).css('border', '1px solid red');
				$(this).next().css('display', 'block');
			}
			else {
				$(this).css('border', '1px solid rgba(34, 36, 38, 0.15)');
				$(this).next().css('display', 'none');
			}
		});
		// 전화번호 유효성 체크
		$("#update-profile-phone").keyup(function() {
			var phone = $(this).val().trim();
			
			if(!regPhone.test(phone)) {
				$(this).css('border', '1px solid red');
				$(this).next().css('display', 'block');
			}
			else {
				$(this).css('border', '1px solid rgba(34, 36, 38, 0.15)');
				$(this).next().css('display', 'none');
			}
		});
		
		// 변경할 비밀번호 유효성 체크
		$("#newPassword").keyup(function() {
			var newPassword = $(this).val().trim();
			
			if(!regPassword.test(newPassword)) {
				$(this).css('border', '1px solid red');
				$(this).next().css('display', 'block');
			}
			else {
				$(this).css('border', '1px solid rgba(34, 36, 38, 0.15)');
				$(this).next().css('display', 'none');
			}
		});
		
	});
		
	// 함수 영역
	// 프로필 변경 영역 띄우기
	function showUpdateProfileArea() {
		viewProfileAjax(); // 프로필 정보 입력
		
		$("#update-password-area").css('display', 'none');
		$("#remove-account-area").css('display', 'none');
		$("#update-profile-area").css('display', 'block');
	}
	
	// 비밀번호 변경 영역 띄우기
	function showUpdatePasswordArea() {
		// 비밀번호 입력칸 초기화
		$("#update-password-area input:password").val("");
		
		// 비밀번호 유효성 체크 메세지 초기화
		$("#newPassword").next().css('display', 'none');
		$("#newPassword").css('border', '1px solid rgba(34, 36, 38, 0.15)');

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
	
	// 프로필 변경
	// profileOriginalFilename: 기존 사용자 이미지
	function updateProfile(profileOriginalFilename) {
		var memberName = $("#update-profile-name");
		var email = $("#update-profile-email");
		var phone = $("#update-profile-phone");

		// 1. 정보 입력 여부 확인
		if(memberName.val().trim().length == 0) {
			alert("이름을 입력하지 않으셨습니다.");
			memberName.focus();
			return;
		}
		if(email.val().trim().length == 0) {
			alert("이메일을 입력하지 않으셨습니다.");
			email.focus();
			return;
		}
		if(phone.val().trim().length == 0) {
			alert("번호를 입력하지 않으셨습니다.");
			phone.focus();
			return;
		}
		
		// 2. 유효성 체크
		var valid = false;
		if(!regName.test(memberName.val().trim())) valid = false;
		else if(!regEmail.test(email.val().trim())) valid = false;
		else if(!regPhone.test(phone.val().trim())) valid = false;
		else valid = true;
		
		if(!valid) {
			alert("알맞은 형식의 정보를 입력해주세요.");
			return;
		}
		
		// 3. 모든 조건 만족 시 변경할 정보 저장
		// 3-1. 입력 정보 저장
		var formData = new FormData();
		formData.append('memberName', memberName.val().trim());
		formData.append('email', email.val().trim());
		formData.append('phone', phone.val().trim());
		
		// 3-2. 이미지 저장
		// 1) 기본 이미지를 선택한 경우
		if($("#check-default-img input:checkbox").is(":checked")) {
			formData.append('defaultYn', 'Y'); // 기본 이미지 여부 Y로 설정
		}
		// 2) 기본 이미지를 선택하지 않은 경우
		else {
			formData.append('defaultYn', 'N'); // 기본 이미지 여부 N으로 설정
			
			// 2-1) 이미지를 변경하지 않는 경우
			if($("#update-profile-area input:file").prop('files')[0] === undefined) {
				formData.append('newImageYn', 'N');
			}
			else { // 2-2) 새 이미지를 선택한 경우
				formData.append('newImageYn', 'Y');
			
				// 업로드할 이미지 저장
				var upFile = $("#update-profile-area input:file").prop('files')[0];
				formData.append('upFile', upFile);
			}
		}

		// 4. 프로필 정보 변경
 		$.ajax({
			url: '${pageContext.request.contextPath}/members/${memberLoggedIn.memberId}/profile',
			type: 'POST',
			data: formData,
			processData: false, // 파일 업로드 ajax시 필수 속성
			contentType: false, // 파일 업로드 ajax시 필수 속성,
			success: data => {
				console.log("프로필 변경 ajax 처리 성공!");
			
				location.href = '${pageContext.request.contextPath}/account';
			},
			error: (x, s, e) => {
				console.log("프로필 변경 ajax 요청 실패!", x, s, e);
			}
			
		});
	}
	
	// 프로필 정보 띄우기
	function viewProfileAjax() {
		$.ajax({
			url: '${pageContext.request.contextPath}/members/${memberLoggedIn.memberId}',
			type: 'GET',
			dataType: 'json',
			success: data => {
				// console.log(data);
				
				// 파일 초기화 (input:file)
				var agent = navigator.userAgent.toLowerCase();
				if ( (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1) ) {
				    $("#update-profile-area input:file").replaceWith($("#update-profile-area input:file").clone(true));
				} else {
				    $("#update-profile-area input:file").val("");
				}
				
				// 프로필 영역 정보 갱신
				// 1. 이미지
				if(data.profileRenamedFilename == 'default.jpg')
					$("#update-profile-image-area").html('<img src="resources/images/profile/default.jpg" alt="프로필 이미지">');
				else
					$("#update-profile-image-area").html('<img src="resources/upload/profile/'+data.memberId+'/'+data.profileRenamedFilename+'" alt="프로필 이미지">');

				// 2. 이미지명
				if(data.profileRenamedFilename == 'default.jpg')
					$("#update-profile-area input:file").next('.custom-file-label').html("이미지 선택");
				else
					$("#update-profile-area input:file").next('.custom-file-label').html(data.profileOriginalFilename);
				
				// 3. 기본 이미지 체크 여부
				if(data.profileOriginalFilename == 'default.jpg')
					$("#check-default-img input:checkbox").prop('checked', true);	
				else
					$("#check-default-img input:checkbox").prop('checked', false);	
				
				// 4. 이름, 유효성 체크 초기화
				$("#update-profile-name").val(data.memberName);
				$("#update-profile-name").next().css('display', 'none');
				$("#update-profile-name").css('border', '1px solid rgba(34, 36, 38, 0.15)');
				
				// 5. 이메일, 유효성 체크 초기화
				$("#update-profile-email").val(data.email);
				$("#update-profile-email").next().css('display', 'none');
				$("#update-profile-email").css('border', '1px solid rgba(34, 36, 38, 0.15)');
				
				// 6. 전화번호, 유효성 체크 초기화
				$("#update-profile-phone").val(data.phone);
				$("#update-profile-phone").next().css('display', 'none');
				$("#update-profile-phone").css('border', '1px solid rgba(34, 36, 38, 0.15)');
				
			},
			error: (x, s, e) => {
				console.log("프로필 정보 조회 ajax 요청 실패!", x, s, e);
			}
			
		});
	}
	
	// 비밀번호 변경 시 유효성 체크
	function checkPasswordValid() {
		var currentPwd = $("#currentPassword").val().trim();
		var newPwd = $("#newPassword").val().trim();
		var checkPwd = $("#check-newPassword").val().trim();
		
		// 1. 입력 여부 확인
		if(currentPwd.length == 0) {
			alert("현재 비밀번호를 입력하지 않으셨습니다.");
			$("#currentPassword").focus();
			return;
		}
		if(newPwd.length == 0) {
			alert("변경할 비밀번호를 입력하지 않으셨습니다.");
			$("#newPassword").focus();
			return;
		}
		if(checkPwd.length == 0) {
			alert("비밀번호 확인란을 입력하지 않으셨습니다.");
			$("#check-newPassword").focus();
			return;
		}
		
		// 2. 변경할 비밀번호의 유효성 체크
		var valid = false;
		
		if(!regPassword.test($("#newPassword").val().trim())) valid = false;
		else valid = true;
		
		if(!valid) {
			alert("알맞은 형식의 비밀번호를 입력해주세요.");
			$("#newPassword").focus();
			return;
		}
		
		// 3. 비밀번호 확인란 일치 여부 체크
		if(newPwd != checkPwd) {
			alert("변경할 비밀번호와 변경할 비밀번호 확인란이 일치하지 않습니다.");
			$("#check-newPassword").focus();
			return;
		}
		
		// 4. 입력한 현재 비밀번호의 일치 여부에 따른 비밀번호 변경
		var param = {currentPwd: currentPwd, newPwd: newPwd};
		
		$.ajax({
			url: '${pageContext.request.contextPath}/members/${memberLoggedIn.memberId}/password',
			type: 'PUT',
			data: JSON.stringify(param),
			contentType: 'application/json; charset=utf-8',
			success: data => {
				if(data.isMatched) {
					alert(data.msg);
					$("#update-password-area input:password").val("");
				}
				else {
					alert("입력한 현재 비밀번호가 일치하지 않습니다.");
					$("#currentPassword").focus();
				}
			},
			error: (x, s, e) => {
				console.log("비밀번호 변경 ajax 처리 실패!", x, s, e);
			}
		});
		
	}
	
	</script>

	</body>
</html>