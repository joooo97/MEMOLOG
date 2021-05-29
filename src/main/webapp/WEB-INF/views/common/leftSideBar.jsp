<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 

		<!-- Sidebar -->
		<!-- 부트스트랩과 semantic ui의 충돌로 사이드바 내에서 모달 띄우기가 안 되어 다른 요소를 이용하여 모달 띄우기 -->
		<span id="show-modal-add-p-ws" data-toggle="modal" data-target="#modal-add-p-ws"></span>
		<span id="show-modal-add-s-ws" data-toggle="modal" data-target="#modal-add-s-ws"></span>
		<span id="show-modal-add-page" data-toggle="modal" data-target="#modal-add-page"></span>
		<span id="show-modal-update-ws" data-toggle="modal" data-target="#modal-update-ws"></span>
		<span id="show-modal-update-p" data-toggle="modal" data-target="#modal-update-p"></span>
		<span id="show-modal-view-profile" data-toggle="modal" data-target="#modal-view-profile"></span>
	
		<div id="sidebar">
			<nav id="header-workspace-name">
				<ul>
					<li class="toggle"><i id="left-toggle-button" class="fas fa-bars"></i></li>
					<!-- 워크스페이스명 나타내기 -->
					<c:choose>
						<c:when test="${workspace != null}">
							<li class="hover ws-name"><i class="fas fa-feather" style="color: ${workspace.workspaceCoverCode};"></i><a href="${pageContext.request.contextPath}/workspaces/${workspace.workspaceNo}">${workspace.workspaceName}</a></li>
						</c:when>
						<c:when test="${page != null}">
							<li class="hover ws-name"><i class="fas fa-feather" style="color: ${page.workspaceCoverCode};"></i><a href="${pageContext.request.contextPath}/workspaces/${page.workspaceNo}">${page.workspaceName}</a></li>
						</c:when>
						<c:otherwise>
							<li class="hover ws-name"><i class="fas fa-feather" style="color: #F3D7E0;"></i><a href="#">MEMOLOG</a></li>
						</c:otherwise>
					</c:choose>
					<!-- 페이지명 나타내기 -->
					<c:if test="${page != null}">
						<li class="span"><span>/</span></li>
						<li class="hover p-name"><i class="fas fa-sticky-note" style="color: ${page.pageCoverCode}"></i><a href="${pageContext.request.contextPath}/pages/${page.pageNo}">${page.pageName}</a></li>
					</c:if>
				</ul>
			</nav>
			<div id="sidebar-header" class="ui dropdown">
				<c:if test="${memberLoggedIn.profileRenamedFilename == 'default.jpg'}">
					<img src="${pageContext.request.contextPath}/resources/images/profile/default.jpg" alt="사용자 프로필 이미지">
				</c:if>
				<c:if test="${memberLoggedIn.profileRenamedFilename != 'default.jpg'}">
					<img src="${pageContext.request.contextPath}/resources/upload/profile/${memberLoggedIn.memberId}/${memberLoggedIn.profileRenamedFilename}" alt="사용자 프로필 이미지">
				</c:if>
				<span> ${memberLoggedIn.memberName }'s MEMOLOG</span>
				<div class="menu menu-profile">
				  <div id="btn-show-profile" class="item" onclick="showProfile('${memberLoggedIn.memberId}');">프로필 보기</div>
				  <div class="item" onclick="location.href='${pageContext.request.contextPath}/account'">계정 설정</div>
				  <div class="item" onclick="location.href='${pageContext.request.contextPath}/logOut'">로그아웃</div>
				</div>
			</div>
			<div id="sidebar-content">
				<div class="inner">
					<nav id="menu">
						<ul>
							<li>
								<span class="opener no-click">FAVORITES</span>
								<ul>
									<li class="opener2">
										<span class="opener opener2 no-click"><a href="#">WORKSPACE</a></span>
										<ul class="opener2" id="ul-ws-favorites">
											<c:forEach items="${favoritesList}" var="f" varStatus="vs">
												<c:if test="${f.favoritesType == 'W'}">
												<li id="favorites-${f.favoritesNo}"><span><a href="#" class="hover-text">
													<div class="btn-go-workspace">
														<div class="ws-p-name" onclick="goWorkspace(${f.workspaceNo});">${f.workspaceName}</div>
														<i class="plus square outline icon btn-add-page" onclick="addPage('${f.roleCode}', '${f.workspaceNo }');"></i>
														<div class="ui buttons btn-settings">
															<i class="ui dropdown fas fa-ellipsis-h">
																<div class="menu menu-settings">
																  <div class="item" onclick="deleteWsFavorite(${f.favoritesNo});"><i class="star outline icon"></i>즐겨찾기 취소</div>
																  <c:if test="${f.workspaceWriter == memberLoggedIn.memberId}">
																  	<div class="item btn-update-ws" onclick="updateWorkspace('${f.workspaceNo}', '${f.workspaceName}', '${f.workspaceDesc}');"><i class="edit icon"></i>수정</div>
																	<div class="item" onclick="deleteWorkspace('${f.workspaceNo}');"><i class="delete icon"></i>삭제</div>
																  </c:if>
																  <c:if test="${f.workspaceWriter != memberLoggedIn.memberId}">
																  	<div class="item" onclick="leaveShareWorkspace(${f.workspaceMemberNo});"><i class="icon fas fa-sign-out-alt"></i>나가기</div>
																  </c:if>
																</div>
															</i>
														</div>
													</div>
												</a></span></li>
												</c:if>
											</c:forEach>
										</ul>
									</li>
									<li>
										<span class="opener opener2 no-click"><a href="#">PAGE</a></span>
										<ul class="opener2" id="ul-page-favorites">
											<c:forEach items="${favoritesList}" var="f" varStatus="vs">
												<c:if test="${f.favoritesType == 'P'}">
												<li id="favorites-${f.favoritesNo}"><span><a href="#" class="hover-text">
													<div class="btn-go-page">
														<div class="ws-p-name" onclick="goPage(${f.pageNo});">${f.pageName}</div>
														<div class="ui buttons btn-settings">
															<i class="ui dropdown fas fa-ellipsis-h">
																<div class="menu menu-settings">
																  <div class="item" onclick="deletePageFavorite(${f.favoritesNo});"><i class="star outline icon"></i>즐겨찾기 취소</div>
																  <c:if test="${f.workspaceWriter == memberLoggedIn.memberId || f.pageWriter == memberLoggedIn.memberId}">
																	<div class="item btn-update-p" onclick="updatePage('${f.pageNo}', '${f.pageName}', '${f.pageDesc}');"><i class="edit icon"></i>수정</div>
																  	<div class="item" onclick="deletePage('${f.pageNo}', '${f.workspaceNo}');"><i class="delete icon"></i>삭제</div>
																  </c:if>
																</div>
															</i>
														</div>
													</div>
												</a></span></li>
												</c:if>
											</c:forEach>
										</ul>
									</li>
								</ul>
							</li>
						</ul>
						<ul>
							<li>
								<span class="opener no-click" id="s-workspace-menu">SHARED WORKSPACE<i class="plus square outline icon" id="btn-add-s-workspace"></i></span>
								<ul>
									<c:forEach items="${workspaceList}" var="w" varStatus="wvs">
									<c:if test="${w.workspaceType == 'S'}">
										<li>
											<span class="opener opener2"><a href="#" class="hover-text">
												<div class="btn-go-workspace">
													<div class="ws-p-name" onclick="goWorkspace(${w.workspaceNo});">${w.workspaceName}</div>
													<i class="plus square outline icon btn-add-page" onclick="addPage('${w.roleCode}', '${w.workspaceNo}');"></i>
													<div class="ui buttons btn-settings">
														<i class="ui dropdown fas fa-ellipsis-h">
															<div class="menu menu-settings">
															<c:if test="${w.workspaceWriter == memberLoggedIn.memberId}">
															  <div class="item btn-update-ws" onclick="updateWorkspace('${w.workspaceNo}', '${w.workspaceName}', '${w.workspaceDesc}');"><i class="edit icon"></i>수정</div>
															  <div class="item" onclick="deleteWorkspace('${w.workspaceNo}');"><i class="delete icon"></i>삭제</div>
															</c:if>
															<c:if test="${w.workspaceWriter != memberLoggedIn.memberId}">
															  <div class="item" onclick="leaveShareWorkspace(${w.workspaceMemberNo});"><i class="icon fas fa-sign-out-alt"></i>나가기</div>
															</c:if>
															</div>
														</i>
													</div>
												</div>
											</a></span>
											<ul class="opener2">
												<c:forEach items="${workspacePageList}" var="wp" varStatus="wpvs">
													<c:if test="${w.workspaceNo == wp.workspaceNo}">
														<li><span><a href="#" class="hover-text">
															<div class="btn-go-page">
																<div class="ws-p-name" onclick="goPage(${wp.pageNo});">${wp.pageName}</div>
																<div class="ui buttons btn-settings">
																<c:if test="${wp.workspaceWriter == memberLoggedIn.memberId || wp.pageWriter == memberLoggedIn.memberId}">
																	<i class="ui dropdown fas fa-ellipsis-h">
																		<div class="menu menu-settings">
																		  <div class="item btn-update-p" onclick="updatePage('${wp.pageNo}', '${wp.pageName}', '${wp.pageDesc}');"><i class="edit icon"></i>수정</div>
																		  <div class="item" onclick="deletePage('${wp.pageNo}', ${wp.workspaceNo});"><i class="delete icon"></i>삭제</div>
																		</div>
																	</i>
																</c:if>
																</div>
															</div>
														</a></span></li>
													</c:if>
												</c:forEach>
											</ul>
										</li>
									</c:if>
									</c:forEach>
								</ul>
							</li>
						</ul>
						<ul>
							<li>
								<span class="opener no-click" id="p-workspace-menu">PRIVATE WORKSPACE
									<i class="plus square outline icon" id="btn-add-p-workspace" data-toggle="modal" data-target="#modal-add-p-ws"></i>
								</span>
								<ul>
									<c:forEach items="${workspaceList}" var="w" varStatus="wvs">
									<c:if test="${w.workspaceType == 'P'}">
										<li>
											<span class="opener opener2"><a href="#" class="hover-text">
												<div btn-go-workspace">
													<div class="ws-p-name" onclick="goWorkspace(${w.workspaceNo});">${w.workspaceName}</div>
													<i class="plus square outline icon btn-add-page" onclick="addPage('${w.roleCode}', '${w.workspaceNo }');"></i>
													<div class="ui buttons btn-settings">
														<i class="ui dropdown fas fa-ellipsis-h">
															<div class="menu menu-settings">
															  <div class="item btn-update-ws" onclick="updateWorkspace('${w.workspaceNo}', '${w.workspaceName}', '${w.workspaceDesc}');"><i class="edit icon"></i>수정</div>
															  <div class="item" onclick="deleteWorkspace('${w.workspaceNo}');"><i class="delete icon"></i>삭제</div>
															</div>
														</i>
													</div>
												</div>
											</a></span>
											<ul class="opener2">
												<c:forEach items="${workspacePageList}" var="wp" varStatus="wpvs">
													<c:if test="${w.workspaceNo == wp.workspaceNo}">
														<li><span><a href="#" class="hover-text">
															<div class="btn-go-page" onclick="goPage(${wp.pageNo});">
																<div class="ws-p-name">${wp.pageName}</div> 
																<div class="ui buttons btn-settings">
																	<i class="ui dropdown fas fa-ellipsis-h">
																		<div class="menu menu-settings">
																		  <div class="item btn-update-p" onclick="updatePage('${wp.pageNo}', '${wp.pageName}', '${wp.pageDesc}');"><i class="edit icon"></i>수정</div>
																		  <div class="item" onclick="deletePage('${wp.pageNo}', '${wp.workspaceNo}');"><i class="delete icon"></i>삭제</div>
																		</div>
																	</i>
																</div>
															</div>
														</a></span></li>
													</c:if>
												</c:forEach>
											</ul>
										</li>
									</c:if>
									</c:forEach>
								</ul>
							</li>
						</ul>
					</nav>
				</div>
				<!-- /.inner -->
			</div>
			<!-- /#sidebar-content -->
		</div>
		<!-- /#sidebar -->

<script>
$(function() {
	
	// <왼쪽 사이드바>
	// 사이드바 각 메뉴 호버 시 관리, 추가 버튼 나타내기
	hoverSideBarBtn();
	
	// 사이드바 메뉴 클릭 시 모달 띄우기
	//#1. 개인 워크스페이스 생성 모달 띄우기
	$("#btn-add-p-workspace").on('click', function(){
		$("#show-modal-add-p-ws").click();
	});
	//#2. 공유 워크스페이스 생성 모달 띄우기
	$("#btn-add-s-workspace").on('click', function(){
		$("#show-modal-add-s-ws").click();
	});
	//#6. 프로필 보기 모달 띄우기
	$("#btn-show-profile").on('click', function(){
		$("#show-modal-view-profile").click();
	});

});

// 함수 영역

// 즐겨찾기 추가된 워크스페이스/페이지의 관리 메뉴 수동으로 열고 닫기
function viewSettingsMenu(createdFavoriteNo) {
	// 관리 버튼 클릭 시 관리 메뉴(즐겨찾기 취소 / 수정 / 삭제)가 뜨지 않아 수동으로 띄워주기
	$("li#favorites-"+createdFavoriteNo+" .btn-settings").on('click', function() {
		$(this).find("div.menu-settings").toggleClass("visible");
	});
	
	// 사이드바 내 다른 요소 클릭 시 관리 메뉴 닫기
	$('#sidebar, #sidebar i').on('click', function(e) {
		$("#favorites-"+createdFavoriteNo+" div.menu-settings").removeClass('visible');
	});	
}

// 사이드바 내 워크스페이스/페이지 호버 시 관리버튼 나타내기
function hoverSideBarBtn() {
	$("#menu span").hover(function() {
		$(this).find('i').css('visibility', 'visible');
	});
	$("#menu span").mouseleave(function() {
		$(this).find('i').css('visibility', 'hidden');
	});
}

// 공유 워크스페이스 멤버 나가기
function leaveShareWorkspace(workspaceMemberNo) {
	if(!confirm("현재 공유 워크스페이스를 나가시겠습니까?"))
		return;
	
	$.ajax({
		url: '${pageContext.request.contextPath}/workspace-members/'+workspaceMemberNo,
		type: 'DELETE',
		success: data => {
			// 현재 조회중이던 공유 워크스페이스가 아닌 사용자가 속한 다른 공유 워크스페이스 조회
			location.href = "${pageContext.request.contextPath}/workspaces";
			
			console.log("공유 워크스페이스 멤버 나가기 성공!");
			
			
		},
		error: (x, s, e) => {
			console.log("공유 워크스페이스 멤버 나가기 실패!", x, s, e);
		}
	});
}

// 페이지 생성 모달 띄우기
function addPage(roleCode, workspaceNo) {
	if(roleCode == 'R3'){
		alert("페이지 생성 권한이 없습니다.");
		return;
	}
	else {
		// 전역변수에 워크스페이스 번호 저장
		v_workspaceNo = workspaceNo;
		// 페이지 생성 모달 열기
		$("#show-modal-add-page").click();
	}
}

// 워크스페이스 수정 모달 띄우기
function updateWorkspace(workspaceNo, workspaceName, workspaceDesc) {
	// 전역변수에 수정할 워크스페이스 정보 저장
	v_workspaceNo = workspaceNo;
	
	// 워크스페이스 수정 모달 열기
	$("#show-modal-update-ws").click();
	
	// 기존 워크스페이스 정보 모달에 띄우기
	$("#modal-update-ws input[name='workspaceName']").val(workspaceName);
	$("#modal-update-ws input[name='workspaceDesc']").val(workspaceDesc);
}

//페이지 수정 모달 띄우기
function updatePage(pageNo, pageName, pageDesc) {
	// 전역변수에 수정할 페이지 정보 저장
	v_pageNo = pageNo;
	
	// 페이지 수정 모달 열기
	$("#show-modal-update-p").click();
	
	// 기존 페이지 정보 모달에 띄우기
	$("#modal-update-p input[name='pageName']").val(pageName);
	$("#modal-update-p input[name='pageDesc']").val(pageDesc);
}

// 워크스페이스 삭제
function deleteWorkspace(workspaceNo) {
	if(!confirm("정말 삭제하시겠습니까?"))
		return;
	
	$.ajax({
		url: '${pageContext.request.contextPath}/workspaces/'+workspaceNo,
		type: 'DELETE',
		success: data => {
			alert("워크스페이스가 삭제되었습니다.");
			location.href = "${pageContext.request.contextPath}/workspaces";
		},
		error: (x, s, e) => {
			console.log("워크스페이스 삭제 ajax 요청 실패!", x, s, e);
		}
	});
}

// 페이지 삭제
function deletePage(pageNo, workspaceNo) {
	if(!confirm("정말 삭제하시겠습니까?"))
		return;
	
	$.ajax({
		url: '${pageContext.request.contextPath}/pages/'+pageNo,
		type: "DELETE",
		success: data => {
			alert("페이지가 삭제되었습니다.");
			location.href = "${pageContext.request.contextPath}/workspaces/"+workspaceNo;
		}, 
		error : (x, s, e) => {
			console.log("페이지 삭제 ajax 요청 실패!", x, s, e);
		}
	});
}

// 워크스페이스 클릭 시 조회
function goWorkspace(workspaceNo) {
	location.href = "${pageContext.request.contextPath}/workspaces/"+workspaceNo;
}

// 페이지명 클릭 시 페이지 조회
function goPage(pageNo) {
	location.href = "${pageContext.request.contextPath}/pages/"+pageNo;
}

// 검색
function search() {
	var keyword = $(".search-tab input").val().trim();
	
	if(keyword == "") {
		alert("검색어를 입력하지 않으셨습니다.");
		return;
	}
	
	location.href = '${pageContext.request.contextPath}/search/'+keyword;
}

</script>
		
		
		