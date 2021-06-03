<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>

<!-- 로그인, 회원가입 페이지 css -->
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/loginPage.css" />
<style>
/* 아이디 중복 체크 */
span.guide {display:none; font-size: 12px; padding-left: 5px; font-weight: bold;}
span.valid {display:none; font-size: 12px; padding-left: 5px; font-weight: bold; color: red;}
span.error {color: red;}
span.ok {color: blue;}
</style>

<script>
// 로그인이 되어있는데 회원가입 페이지로 이동하려는 경우
<c:if test="${memberLoggedIn != null}">
	alert("잘못된 요청입니다.");
	location.href="${pageContext.request.contextPath}/workspaces";
</c:if>

// 정규 표현식
var regKorName = /^[가-힣]{2,}$/;
var regEngName = /^[a-zA-Z]{2,}$/;
var regPassword = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[~!@#$%^&*()\-_+=]).{8,15}$/;
//var regPassword = /^(?=^.{8,15}$)(?=.*[a-zA-z])(?=.*[0-9])(?=.*[~!@#$%^&*()\-_+=]).*$/;
var regEmail = /[a-zA-Z0-9._+-]+@[a-zA-Z0-9]+\.[a-zA-Z0-9.]+/;
var regPhone = /^\d{10,11}$/;

$(function(){
	
	$('.ui.dropdown').dropdown(); //semantic dropdown 활성화
	
	//semantic ui menu 활성화
	$('.ui.pointing.menu').on('click', '.item', function() {
		if(!$(this).hasClass('dropdown')) {
			$(this).addClass('active').siblings('.item').removeClass('active');
		}
	});
				
	//아이디 중복 검사 ajax
	$("#memberId").keyup(function(){
		var memberId = $(this).val().trim();
		
		if(memberId.length < 4){
			$(".guide").hide();
			$("#idValid").val(0);
			return;
		}
		$.ajax({
			url: "${pageContext.request.contextPath}/checkIdDuplicate",
			data: {memberId: memberId},
			dataType: "json",
			success: data => {
				console.log(data);
				
				if(data.isUsable == true){
					$(".guide.error").hide();
					$(".guide.ok").show();
					$("#memberId").css('border', '1px solid rgba(34, 36, 38, 0.15)');
					$("#idValid").val(1);
				}
				else {
					$(".guide.ok").hide();
					$(".guide.error").show();
					$("#memberId").css('border', '1px solid red');
					$("#idValid").val(0);
				}
			},
			error: (jqxhr, textStatus, errorThrown) => {
				console.log("아이디 중복 검사 ajax 요청 실패!", jqxhr, textStatus, errorThrown);
			}
		});
	});
	
	// 유효성 체크에 따른 메세지 띄우기
	$("#memberName").keyup(function() {
		var name = $(this).val().trim();
		
		if(!regKorName.test(name) && !regEngName.test(name)) {
			$(this).css('border', '1px solid red');
			$(this).next().css('display', 'block');
		}
		else {
			$(this).css('border', '1px solid rgba(34, 36, 38, 0.15)');
			$(this).next().css('display', 'none');
		}
	});
	
	$("#password").keyup(function() {
		var password = $(this).val().trim();
		var cPassword = $("#password2").val().trim();
		
		if(!regPassword.test(password)){
			$(this).css('border', '1px solid red');
			$(this).next().css('display', 'block');
		}
		else {
			$(this).css('border', '1px solid rgba(34, 36, 38, 0.15)');
			$(this).next().css('display', 'none');
		}
		
		// 비밀번호 입력 시에도 비밀번호 확인란의 값이 일치하지 않을 시 메세지 띄울 수 있도록
		if(cPassword != '' && password != cPassword) {
			$("#password2").css('border', '1px solid red');
			$("#password2").next().css('display', 'block');
		}
	});
	
	$("#password2").keyup(function() {
		var password = $("#password").val().trim();
		var cPassword = $("#password2").val().trim();
		
		if(password == '') {
			alert("비밀번호를 입력하지 않으셨습니다.");
			$("#password2").val('');
			$("#password").focus();
		}
		else if(password != cPassword){
			$(this).css('border', '1px solid red');
			$(this).next().css('display', 'block');
		}
		else {
			$(this).css('border', '1px solid rgba(34, 36, 38, 0.15)');
			$(this).next().css('display', 'none');
		}
	});
	
	$("#email").keyup(function() {
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
	
	$("#phone").keyup(function() {
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
	
});

function signUpValidate(){
	var memberId = $("#memberId").val();
	var memberName = $("#memberName").val();
	var password = $("#password").val();
	var cPassword = $("#password2").val();
	var email = $("#email").val();
	var phone = $("#phone").val();
	
	var valid = false;
	
	// 1. 입력 여부	
	if(memberId.trim().length < 4){
		alert("아이디는 최소 4자리 이상이어야 합니다.");
		$("#memberId").focus();
		return;
	}
	if(memberName.trim().length == 0){
		alert("이름을 입력하지 않으셨습니다.");
		$("#memberName").focus();
		return;
	}
	if(password.trim().length == 0){
		alert("비밀번호를 입력하지 않으셨습니다.");
		$("#password").focus();
		return;
	}
	if(cPassword.trim().length == 0){
		alert("비밀번호 확인란을 입력하지 않으셨습니다.");
		$("#cPassword").focus();
		return;
	}
	if(email.trim().length == 0){
		alert("이메일을 입력하지 않으셨습니다.");
		$("#email").focus();
		return;
	}
	if(phone.trim().length == 0){
		alert("번호를 입력하지 않으셨습니다.");
		$("#phone").focus();
		return;
	}
	
	// 2. 유효성 체크
	if($("#idValid").val() == 0) valid = false;
	else if(!regKorName.test(memberName) && !regEngName.test(memberName)) valid = false;
	else if(!regPassword.test(password)) valid = false;
	else if(!regEmail.test(email)) valid = false;
	else if(!regPhone.test(phone)) valid = false;
	else valid = true;
	
	if(password != cPassword) {
		alert("비밀번호와 비밀번호 확인란이 일치하지 않습니다.");
		$("#password2").focus();
		return;
	}
	
	if(!valid) {
		alert("알맞은 형식의 정보를 입력해주세요.");
		return;
	}
	
	// 조건 만족한다면 회원가입 처리
	var param = {
		memberId: memberId,
		memberName: memberName,
		password: password,
		email: email,
		phone: phone
	};
	
	$.ajax({
		url: "${pageContext.request.contextPath}/signUp",
		data: JSON.stringify(param),
		type: "post",
		dataType: "json",
		contentType: 'application/json; charset=utf-8',
		success: data => {
			alert(data.msg);
			location.href = '${pageContext.request.contextPath}';
		},
		error: (x, s, e) => {
			console.log("회원 가입 ajax 요청 실패!", x, s, e);
		}
		
	});
	
	
}

</script>
	
</head>
	<body class="is-preload">
		<!-- Wrapper -->
		<div id="wrapper">
			<!-- Main -->
			<div id="main">
				<div class="inner">
					<!-- Content -->
					<section>
                        <div id="header">
                            <div id="logo-area" onclick="location.href='${pageContext.request.contextPath}'">
                                <img src="${pageContext.request.contextPath }/resources/images/memolog_logo.png" alt="">
                                <span>MEMOLOG</span>
                            </div>
                            <nav>
	                            <span><a href="${pageContext.request.contextPath}">LOG IN</a></span>
                            </nav>
                        </div>
                        <div id="content" class="sign-up">
                            <div id="content-name">SIGN &nbsp;UP</div>
                            <hr>
                            <div id="login-form">
                                <form class="ui form">
                                    <div class="field">
                                        <label>ID</label>
                                        <input type="text" placeholder="4자 이상의 아이디를 입력해주세요." id="memberId" name="memberId" required style="margin-bottom: 5px;">
                                        <span class="guide ok">사용 가능한 아이디입니다.</span>
                                        <span class="guide error">이미 사용중인 아이디입니다.</span>
                                        <input type="hidden" id="idValid" value="0" />
                                    </div>
                                    <div class="field">
                                        <label>NAME</label>
                                        <input type="text" placeholder="이름을 입력해주세요." id="memberName" required>
                                        <span class="valid">알맞은 형식의 이름을 입력해주세요.</span>
                                    </div>
									<div class="field">
										<label>PASSWORD</label>
										<input type="password" placeholder="영문자, 숫자, 특수문자를 포함하여 8-15자를 입력해주세요." id="password" name="password" required>
										<span class="valid">알맞은 형식의 비밀번호를 입력해주세요.</span>
									</div>
									<div class="field">
										<label>CONFIRM PASSWORD</label>
										<input type="password" placeholder="비밀번호 확인" id="password2" required>
										<span class="valid">비밀번호가 일치하지 않습니다.</span>
									</div>
                                    <div class="field">
                                        <label>EMAIL</label>
                                        <input type="email" placeholder="이메일을 입력해주세요." id="email" required>
                                        <span class="valid">알맞은 형식의 이메일을 입력해주세요.</span>
                                    </div>
                                    <div class="field">
                                        <label>PHONE NUMBER</label>
                                        <input type="tel" placeholder="전화번호를 입력해주세요. ( - 제외)" id="phone" required>
                                        <span class="valid">알맞은 형식의 전화번호를 입력해주세요.</span>
                                    </div>
                                    <button class="ui button" type="button" onclick="signUpValidate()">SIGN UP</button>
                                </form>
                            </div>
                            
                        </div>

					</section>
				</div>
				<!-- /#main .inner -->
			</div>
			<!-- /#main -->

		</div>
		<!-- /#wrapper -->
		
		<!-- 공통 스크립트 -->
		<jsp:include page="/WEB-INF/views/common/commonScript.jsp"></jsp:include>
	</body>
</html>
	
	
	