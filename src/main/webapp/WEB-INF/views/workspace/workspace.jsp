<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>

<!-- workspace, page 페이지만 css -->
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/juhyun.css" />
</head>

<body class="is-preload">

	<!-- 상단바 우측 아이콘 -->
	<nav id="header-icons">
		<ul>
		<c:if test="${workspace.workspaceType == 'S'}">
			<li><i id="btn-view-member" class="fas fa-user" data-toggle="modal" data-target="#modal-viewMember"></i></li>
		</c:if>
		<c:if test="${workspace.workspaceType == 'S' && workspace.roleCode == 'R1'}">
			<li><i id="btn-add-member" class="fas fa-user-plus" data-toggle="modal" data-target="#modal-addMember"></i></li>
		</c:if>
			<!-- <li><i id="btn-bell" class="fas fa-bell"></i></li> -->
		<c:choose>
			<c:when test="${workspace.wsFavoriteYn == 'Y'}">
				<li><i id="btn-star" class="fas fa-star" onclick="deleteWsFavorite(${workspace.favoritesNo});"></i></li>
			</c:when>
			<c:otherwise>
				<li><i id="btn-star" class="far fa-star" onclick="addWsFavorite(${workspace.workspaceNo});"></i></li>
			</c:otherwise>
		</c:choose>
			<li><i id="btn-more-menu" class="fas fa-ellipsis-h"></i></li>
		</ul>
	</nav>
	<!-- /nav#header-icons -->
	
	
	
	<!-- Wrapper -->
	<div id="wrapper" class="pusher">
	
		<!-- Main -->
		<div id="main">
			<!-- Header -->
			<div id="header"></div>
			<c:choose>
				<c:when test="${workspace != null}">
					<div id="page-cover" style="background: ${workspace.workspaceCoverCode};">
				</c:when>
				<c:otherwise>
					<div id="page-cover" style="background: #F3D7E0;">
				</c:otherwise>
			</c:choose>
				<div class="ui dropdown" id="btn-change-cover-color">
					<div id="color-header"><i class="fas fa-palette"></i>CHANGE COVER COLOR</div>
					<div class="menu color-menu">
						<div class="scrolling menu">
							<div class="item" onclick="changeCoverColor('#F3D7E0');"><div class="ui empty circular label" style="background: #F3D7E0;"></div>BABY PINK</div>
							<div class="item" onclick="changeCoverColor('#F7CAC9');"><div class="ui empty circular label" style="background: #F7CAC9;"></div>ROSE QUARTZ</div>
							<div class="item" onclick="changeCoverColor('plum');"><div class="ui empty circular label" style="background: plum;"></div>PLUM</div>
							<div class="item" onclick="changeCoverColor('lightcoral');"><div class="ui empty circular label" style="background: lightcoral;"></div>LIGHT CORAL</div>
							<div class="item" onclick="changeCoverColor('orange');"><div class="ui empty circular label" style="background: orange;"></div>ORANGE</div>
							<div class="item" onclick="changeCoverColor('burlywood');"><div class="ui empty circular label" style="background: burlywood;"></div>BURLYWOOD</div>
							<div class="item" onclick="changeCoverColor('gold');"><div class="ui empty circular label" style="background: gold;"></div>GOLD</div>
							<div class="item" onclick="changeCoverColor('yellowgreen');"><div class="ui empty circular label" style="background: yellowgreen;"></div>YELLOW GREEN</div>
							<div class="item" onclick="changeCoverColor('powderblue');"><div class="ui empty circular label" style="background: powderblue"></div>POWDER BLUE</div>
							<div class="item" onclick="changeCoverColor('lightskyblue');"><div class="ui empty circular label" style="background: lightskyblue"></div>LIGHT SKY BLUE</div>
							<div class="item" onclick="changeCoverColor('#92abd1');"><div class="ui empty circular label" style="background: #92abd1"></div>SERENITY</div>
							<div class="item" onclick="changeCoverColor('cornflowerblue');"><div class="ui empty circular label" style="background: cornflowerblue"></div>CORN FLOWER BLUE</div>
							<div class="item" onclick="changeCoverColor('lavender');"><div class="ui empty circular label" style="background: lavender"></div>LAVENDER</div>
							<div class="item" onclick="changeCoverColor('mediumpurple');"><div class="ui empty circular label" style="background: mediumpurple"></div>MEDIUM PURPLE</div>
							<div class="item" onclick="changeCoverColor('gainsboro');"><div class="ui empty circular label" style="background: gainsboro"></div>GAINSBORO</div>
							<div class="item" onclick="changeCoverColor('black');"><div class="ui empty circular label" style="background: black"></div>BLACK</div>
						</div>
					</div>
				</div>
			</div>
	
			<div class="inner">
				<!-- Content -->
				<section>
					<c:choose>
						<c:when test="${workspace != null}">
							<div id="workspace-name"><i class="fas fa-feather" style="color: ${workspace.workspaceCoverCode}; margin-right: 1rem;"></i>${workspace.workspaceName}</div>
							<div id="workspace-description">${workspace.workspaceDesc}</div>
						</c:when>
						<c:otherwise>
							<div id="workspace-name"><i class="fas fa-feather" style="color: #F3D7E0; margin-right: 1rem;"></i>MEMOLOG</div>
						</c:otherwise>
					</c:choose>
					<div id="page-list">
					<c:forEach items="${pageList}" var="p" varStatus="pvs">
						<div onclick="location.href='${pageContext.request.contextPath}/pages/${p.pageNo}'"><i class="fas fa-sticky-note" style="color: ${p.pageCoverCode};"></i><span>${p.pageName}</span></div>
					</c:forEach>
<!-- 						<div><i class="fas fa-sticky-note" style="color: lavender"></i><a href="">GO</a></div>
						<div><i class="fas fa-sticky-note"></i><a href="">7DAYS A WEEK</a></div>
						<div><i class="fas fa-sticky-note"></i><a href="">BOOM</a></div> -->
					</div>						
				</section>
			</div>
		</div>
		<!-- /#main -->

		<!-- 상단 우측 헤더 드롭다운 메뉴 -->
		<ul class="list-group" id="more-menu-list" style="display: none;">
			<!-- <li class="list-group-item" onclick="location.href='SearchPage.html'"><i class="fas fa-search" id="search-tab"></i><span>검색</span></li> -->
			<li class="list-group-item">
				<div class="ui icon input" id="more-menu-search">
					<input type="text" placeholder="검색">
					<i class="search icon"></i>
				</div>
			</li>
		</ul>
		
		<!-- 좌측 사이드바 -->
		<jsp:include page="/WEB-INF/views/common/leftSideBar.jsp"></jsp:include>	
	</div>
	<!-- /#wrapper -->
	
	<!-- 모달 모음 - 1,2,3,4,5,6,7,9 필요 -->
	<jsp:include page="/WEB-INF/views/common/modals.jsp"></jsp:include>	
	<!-- 모달 / 상단바 우측 아이콘 기능 js -->
	<script src="${pageContext.request.contextPath }/resources/js/juhyunModal.js?ver=1"></script>
	<!-- 공통스크립트 -->
	<jsp:include page="/WEB-INF/views/common/commonScript.jsp"></jsp:include>	

<script>
		$(function(){
			//토글버튼, 워크스페이스명만 보이기
			$("#header-workspace-name li").not(".toggle, .ws-name").remove();

		});
	
		//함수 영역
		//워크스페이스 커버 컬러 변경
		function changeCoverColor(colorOption) {
			if(v_roleCode != 'R1') {
				alert("워크스페이스 커버 색 변경 권한이 없습니다.");
				return;
			}
			
			$("#page-cover").css('background', colorOption);
			$(".ws-name i").css('color', colorOption);
			$("#workspace-name i").css('color', colorOption);
			
			var workspaceNo = ${workspace.workspaceNo};			
			
			// 커버 색 변경
			// data에 쓴 파라미터를 GET방식에서는 jquery가 자동으로 url단으로 올려서 처리하지만 PUT/DELETE에서는 messageBody에 써짐.
			// data는 messageBody에 작성되고, @RequestBody에 의해 json데이터 처리됨(직렬화된 형태 허용안함.)
 			$.ajax({
				url: "${pageContext.request.contextPath}/workspaces/"+workspaceNo+"/cover-color",
				data: colorOption,
				type: "PUT",
				contentType: 'application/json; charset=utf-8',
				success: data => {
					console.log("워크스페이스 커버 색 변경 성공!");
				},
				error: (x, s, e) => {
					console.log("워크스페이스 커버 색 변경 ajax 요청 실패!", x, s, e);
				}
			}); 
		}
		
		// 워크스페이스 즐겨찾기 해제
		function deleteWsFavorite(favoritesNo) {
			$.ajax({
				url: '${pageContext.request.contextPath}/favorites/'+favoritesNo,
				type: 'DELETE',
				success: data => {
					console.log("워크스페이스 즐겨찾기 해제 성공!");
					
					// 즐겨찾기 표시 해제
					$("#btn-star").attr("class", "far fa-star")
								  .attr("onclick", "addWsFavorite("+v_nowWorkspaceNo+");");
	 				// 사이드바 내 워크스페이스 즐겨찾기 리스트에서 제외
	 				$("li#favorites-"+favoritesNo+"").remove();
					
				},
				error: (x, s, e) => {
					console.log("워크스페이스 즐겨찾기 해제 실패!", x, s, e);
				}
			});
		}
		
		// 워크스페이스 즐겨찾기 추가
		function addWsFavorite(workspaceNo) {
			$.ajax({
				url: '${pageContext.request.contextPath}/workspace-favorites',
				type: 'POST',
				data: {workspaceNo: workspaceNo},
				success: data => {
					console.log("워크스페이스 즐겨찾기 추가 성공!");
					
					// 즐겨찾기 표시 (data.createdFavoriteNo: 생성된 즐겨찾기 번호)
					$("#btn-star").attr("class", "fas fa-star")
								  .attr("onclick", "deleteWsFavorite("+data.createdFavoriteNo+");");
				},
				error: (x, s, e) => {
					console.log("워크스페이스 즐겨찾기 추가 실패!", x, s, e);
				}
			});
		}
	
	</script>

	</body>
</html>
	