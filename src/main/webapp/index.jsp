<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
//쿠키
	boolean saveId = false;
	String memberId = "";
	Cookie[] cookies = request.getCookies();
	if(cookies != null){
		for(Cookie c : cookies){
			String k = c.getName();
			String v = c.getValue();
			if("saveId".equals(k)){
				saveId = true;
				memberId = v;
			}
		}
	}
%>

<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>

<!-- 로그인, 회원가입 페이지 css -->
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/loginPage.css" />
	
<script>
<c:if test="${memberLoggedIn != null}">
	alert("잘못된 요청입니다.");
	location.href="${pageContext.request.contextPath}/workspaces";
</c:if>

$(function(){
	$('.ui.dropdown').dropdown(); //semantic dropdown 활성화
	
	//semantic ui menu 활성화
	$('.ui.pointing.menu').on('click', '.item', function() {
		if(!$(this).hasClass('dropdown')) {
			$(this).addClass('active').siblings('.item').removeClass('active');
		}
	});
	
});

function checkInput() {
	var memberId = $("#memberId").val().trim();
	var password = $("#password").val().trim();
	var saveId = $("#saveId").val();
	
	if(memberId == '' || memberId == null){
		alert("아이디를 입력하지 않으셨습니다.");
		return;
	}
	
	if(password == '' || password == null){
		alert("비밀번호를 입력하지 않으셨습니다.");
		return;
	}
	
	$.ajax({
		url: "${pageContext.request.contextPath}/login",
		data: {memberId: memberId, password: password, saveId: saveId},
		type: "POST",
		dataType: "json",
		success: data => {
			if(data.msg != '')
				alert(data.msg);
			
			location.href = '${pageContext.request.contextPath}'+data.loc;
		},
		error: (x, s, e) => {
			console.log("로그인 ajax 요청 실패!", x, s, e);
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
 	                            <span><a href="${pageContext.request.contextPath}/signUp">SIGN UP</a></span>
	                        </nav>
	                    </div>
	                    <div id="content">
	                        <div id="content-name">LOG &nbsp;IN</div>
	                        <hr>
	                        <div id="login-form">
 	                            <form class="ui form">
	                                <div class="field">
	                                    <label>ID</label> 
	                                    <input id="memberId" name="memberId" type="text"placeholder="아이디를 입력해주세요." value="<%=saveId?memberId:""%>" >
	                                </div>
	                                <div class="field">
	                                    <label>PASSWORD</label>
	                                    <input id="password" name="password" type="password" placeholder="비밀번호를 입력해주세요.">
	                                </div>
	                                <div class="field last">
	                                    <div class="ui checkbox">
										<input id="saveId" name="saveId" type="checkbox" tabindex="0" <%=saveId?"checked":"" %>>
										<label>아이디 저장</label>
	                                    </div>
									<a href="#">비밀번호 찾기</a>
	                                </div>
	                                <button class="ui button" type="button" onclick="checkInput();">LOG IN</button>
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

	<!-- 공통스크립트 -->
	<jsp:include page="/WEB-INF/views/common/commonScript.jsp"></jsp:include>

</body>
</html>




