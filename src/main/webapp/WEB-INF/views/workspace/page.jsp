<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
<!-- workspace, page 페이지만 css -->
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/juhyun.css" />

<script>
var v_nowPageNo = "${page.pageNo}"; // 포스트 추가, 조회, 수정 위한 현재 페이지 번호 전역변수
var v_nowPostNo; // 포스트 수정 / 포스트 댓글 사이드 바 조회를 위한 포스트 번호
var v_fileName; // 첨부파일 포스트 수정을 위한 파일명
var v_commentLevel = 1; // 코멘트 레벨 1로 초기화
var v_commentRefNo; // 코멘트 참조 번호
var v_commentRefWriter; // 참조 코멘트 작성자
var v_updateCommentNo; // 댓글 수정 시 수정할 댓글 번호 저장
</script>
</head>

<body class="is-preload">

	<!-- 상단바 우측 아이콘 -->
	<nav id="header-icons">
		<ul>
		<c:if test="${page.workspaceType == 'S'}">
			<li><i id="btn-view-member" class="fas fa-user" data-toggle="modal" data-target="#modal-viewMember"></i></li>
		</c:if>
		<c:if test="${page.workspaceType == 'S' && page.roleCode == 'R1'}">
			<li><i id="btn-add-member" class="fas fa-user-plus" data-toggle="modal" data-target="#modal-addMember"></i></li>
		</c:if>
			<!-- <li><i id="btn-bell" class="fas fa-bell"></i></li> -->
		<c:choose>
			<c:when test="${page.PFavoriteYn == 'Y'}">
				<li><i id="btn-star" class="fas fa-star" onclick="deletePageFavorite(${page.favoritesNo});"></i></li>
			</c:when>
			<c:otherwise>
				<li><i id="btn-star" class="far fa-star" onclick="addPageFavorite(${page.workspaceNo}, ${page.pageNo});"></i></li>
			</c:otherwise>
		</c:choose>	
			<li><i id="btn-more-menu" class="fas fa-ellipsis-h"></i></li>
		</ul>
	</nav>
	<!-- /nav#header-icons -->

	<!-- 코멘트 사이드바 -->
	<div id="comments-bar" class="right ui sidebar vertical menu">
		<div id="commentsbar-header" class="item">
			<i id="btn-close-comments" class="close icon"></i>
			<div><i class="comment alternate icon" style="margin-right: .5rem;"></i>코멘트<div class="ui label comment-cnt"></div></div>
		</div>
		<div id="comment-overflow">
			<div class="item" style="overflow-y: hidden;">
				<!-- 포스트 작성자 -->
				<div class="ui comments post-writer" style="font-weight: bold;">
					<div class="comment" id="commentBar-post-writer">
						<a class="avatar"></a>
						<div class="content">
						</div>
					</div>
				</div><!-- /.post-writer -->
				<!-- 포스트 내용 -->
				<div id="comment-content" class="post-content">
				</div>
			</div>
			<!-- 전체 포스트 코멘트 영역 -->
			<div class="item ui minimal comments">
			<div id="post-comment-area"></div> <!-- #post-comment-area -->
			</div> <!-- div.ui.comments -->
			
			<div id="comment-summernote-area">
				<div id="reply-area"></div>
				<textarea class="comment-summernote summernote" name="editordata"></textarea>
			</div>
		</div>
		<!-- /#comment-overflow -->
	</div>
	<!-- /#comments-bar -->

	<!-- Wrapper -->
	<div id="wrapper" class="pusher">
		<!-- Main -->
		<div id="main">
			<!-- Header -->
			<div id="header"></div>

				<div id="page-cover" style="background: ${page.pageCoverCode};">
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
					<div id="page-name"><i class="fas fa-sticky-note" style="color: ${page.pageCoverCode}; margin-right: 1rem;"></i>${page.pageName}</div>
					<div id="page-description"><p>${page.pageDesc}</p></div>
					<hr>
					
					<!-- 포스트 영역 -->
					<div id="all-post-area"></div> <!-- #all-post-area -->
	 					
	 					<!-- 포스트 추가 영역 -->
						<div id="add-post-area">
							<hr style='display: none;'>
							<!-- 텍스트 추가 -->
							<form id="form-add-text" class="post-form" method="post">
								<textarea class="text-summernote summernote" name="editordata"></textarea>
							</form> 
							<!-- 첨부파일 추가 -->
							<form id="form-add-file" class="post-form">
								<div class="input-group">
									<div class="custom-file">
									  <input type="file" class="custom-file-input" id="inputGroupFile04" aria-describedby="inputGroupFileAddon04">
									  <label class="custom-file-label" for="inputGroupFile04">파일 선택</label>
									</div>
									<div class="input-group-append">
									  <button class="btn btn-outline-secondary" type="button" id="inputGroupFileAddon04">완료</button>
									</div>
								</div>
							</form>
							<!-- 테이블 추가 -->
							<form id="form-add-table" class="post-form" method="post">
								<textarea class="table-summernote summernote" name="editordata"></textarea>
							</form>
						</div>
						<!-- /#add-post-area -->
					</section>
				</div>
			</div>
			<!-- /#main -->
			
			<!-- 게시물 작성 버튼 -->
			<div class="btn-group dropleft">
				<i id="btn-add-post" class="fa fa-plus-square" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"></i>
				<div class="dropdown-menu dropdown-menu-right" id="list-add-post">
					<div class="add-post list-group-item-action" onclick="addPost('text');">텍스트</div>
					<div class="add-post list-group-item-action" onclick="addPost('file');">첨부파일</div>
					<div class="add-post list-group-item-action" onclick="addPost('table');">테이블</div>
				</div>
			</div>
			
			<!-- 상단 우측 헤더 드롭다운 메뉴 -->
			<ul class="list-group" id="more-menu-list" style="display: none;">
				<!-- <li class="list-group-item" onclick="location.href='SearchPage.html'"><i class="fas fa-search" id="search-tab"></i><span>검색</span></li> -->
				<li class="list-group-item">
					<div class="ui icon input" id="more-menu-search">
						<input type="text" placeholder="검색">
						<i class="search icon"></i>
					</div>
				</li>
				<li class="list-group-item">
					<div class="ui toggle checkbox" style="margin-left: 1rem;">
						<input type="checkbox" name="public" id="btn-switch" class='switch-on'>
						<label>작성자 보기</label>
					</div>

				<li class="list-group-item">
					<button id="classification-tab" class="btn btn-sm dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
						  종류별 정렬
					</button>
					<div class="dropdown-menu" style="font-size: 95%;">
					    <div class="dropdown-item" onclick="viewPostBySort('all');">모든 게시물</div>
					    <div class="dropdown-item" onclick="viewPostBySort('file');">첨부파일</div>
					    <div class="dropdown-item" onclick="viewPostBySort('pinned');">고정 게시물</div>
					</div>
				</li>
			</ul>
			
			<!-- 좌측 사이드바 -->
			<jsp:include page="/WEB-INF/views/common/leftSideBar.jsp"></jsp:include>
		
		</div>
		<!-- /#wrapper -->
		
		<!-- 모달 모음 - 모든 모달 필요 -->	
		<jsp:include page="/WEB-INF/views/common/modals.jsp"></jsp:include>
		<!-- 모달 / 상단바 우측 아이콘 기능 js -->
		<script src="${pageContext.request.contextPath }/resources/js/juhyunModal.js?ver=2"></script>
		<!-- 공통스크립트 -->
		<jsp:include page="/WEB-INF/views/common/commonScript.jsp"></jsp:include>	
	
<script>

	$(function() {
		summernoteSetting(); //summernote 설정
		viewPostBySort('first'); // 전체 포스트 불러오기
		
		// 코멘트 사이드바 닫기
 		$("#btn-close-comments").on('click', function(){
			$('#comments-bar').sidebar('setting', 'transition', 'overlay').sidebar('hide');
		});
		
		// 작성자 보이기 메뉴
		$("#btn-switch").attr('checked', 'true'); 
		$("#btn-switch").on('change', function(){
			$(this).toggleClass('switch-on');	
			
			if($("#btn-switch").hasClass('switch-on')){
				$("div.post-writer").css('display', 'inline-block');
			}
			else {
				$("div.post-writer").css('display', 'none');
			}
		});
		
		// # 포스트 작성 완료 버튼 누를 시
		// 1. 텍스트 포스트 작성
		$("#form-add-text div.btn-submit-summernote").on('click', function() {
			addTextPost();
		});
		
		// 2. 첨부파일 포스트
		// 2-1. 파일 선택, 취소 시에 파일명 노출
		$("input:file").on('change', function(){
			// 파일선택 취소 시
			if($(this).prop('files')[0] === undefined){
				$(this).next('.custom-file-label').html("파일 선택");
				return;
			}
			// 파일선택 시
			var fileName = $(this).prop('files')[0].name; // ex)코드사진.jpg
			$(this).next('.custom-file-label').html(fileName);
		});
	
		// 2-2. 파일 포스트 작성 (파일 업로드)
		$("#inputGroupFileAddon04").on('click', function(){
			addFilePost();
		});
		
		// 3. 테이블 포스트 작성
		$("#form-add-table div.btn-submit-summernote").on('click', function() {
			addTablePost();
		});
		
		// 댓글 작성 버튼 클릭 시
		$("#comment-summernote-area div.btn-submit-summernote").on('click', function() {
			// 댓글 추가인 경우
			if(!$(this).hasClass('update-comment')) {
				addComment();
			}
			// 댓글 수정인 경우
			else {
	 			submitUpdatedComment();
			}
			
		});
		
		// 더보기탭 닫기 (더보기 탭 외의 다른 요소 클릭 시 수동으로 닫아주기)
		$('html').on('click', function(e) {
			// 더보기 메뉴 버튼과 더보기 메뉴 요소가 아닌 다른 요소 클릭 시 더보기 탭 닫기
			if($(e.target).attr('id') != 'btn-more-menu') {
				// 클릭한 요소의 상위 요소들 중 ul의 id 속성이 more-menu-list가 아니라면 (더보기 메뉴 요소가 아니라면)
				if($(e.target).parents('ul').attr('id') != 'more-menu-list') {
					$("#more-menu-list").css('display', 'none');
				}
			}			
		});
		
		// 포스트 관리 메뉴 닫기 (포스트 관리 메뉴 외의 요소 클릭 시 수동으로 닫아주기)
		$('html').on('click', function(e) {
			if(!$(e.target).hasClass('btn-post-management')) {
				// 클릭한 요소의 부모 요소가 post-menu 클래스 속성을 갖고 있지 않다면 (포스트 관리 메뉴들이 아니라면)
				if(!$(e.target).parent('div').hasClass('post-menu')) {
					$("div.post-menu").removeClass('transition visible');
				}
			}
		});
		
	});

	// [ 함수 영역 ]
	// 게시글 종류별 조회 탭
	function viewPostBySort(menu) {
		// 포스트 종류별 탭 닫기
		$("#more-menu-list").css('display', 'none');
		
		// 페이지 새로고침 시
		if(menu == 'first') { 
			$("#classification-tab").text('종류별 정렬');
			
			$.ajax({
				url: '${pageContext.request.contextPath}/pages/'+v_nowPageNo+'/posts',
				type: 'GET',
				dataType: 'json',
				success: data => {
					console.log(data);
					ajaxPostList(data);
				},
				error: (x, s, e) => {
					console.log("포스트 조회 ajax 요청 실패!", x, s, e);
				}
			});
		}		
		else if(menu == 'all') { // 모든 게시물 조회
			$("#classification-tab").text('모든 게시물');
			
			$.ajax({
				url: '${pageContext.request.contextPath}/pages/'+v_nowPageNo+'/posts',
				type: 'GET',
				dataType: 'json',
				success: data => {
					console.log(data);
					ajaxPostList(data);
				},
				error: (x, s, e) => {
					console.log("모든 게시물 조회 ajax 요청 실패!", x, s, e);
				}
			});
		}
		else if(menu == 'file') { // 첨부파일 포스트만 조회
			$("#classification-tab").text('첨부파일');
			
			$.ajax({
				url: '${pageContext.request.contextPath}/pages/'+v_nowPageNo+'/posts/files',
				type: 'GET',
				dataType: 'json',
				success: data => {
					console.log(data);
					ajaxPostList(data);
				},
				error: (x, s, e) => {
					console.log("첨부파일 게시물 조회 ajax 요청 실패!", x, s, e);
				}
			});
		}
		else { // 고정된 포스트만 조회
			$("#classification-tab").text('고정 게시물');
			
			$.ajax({
				url: '${pageContext.request.contextPath}/pages/'+v_nowPageNo+'/posts/pinnedPosts',
				type: 'GET',
				dataType: 'json',
				success: data => {
					console.log(data);
					ajaxPostList(data);
				},
				error: (x, s, e) => {
					console.log("고정 게시물 조회 ajax 요청 실패!", x, s, e);
				}
			});
		}
			
	};
	
	//포스트 작성 폼 열기
	function addPost(post){
		if("${page.roleCode}" == 'R3'){
			alert("포스트 작성 권한이 없습니다.");
			return;
		}
		else {
			//페이지 맨 아래로 이동
			$('html, body').scrollTop( $(document).height() );
			
			//포스트 종류에 따라 폼 열기
			if(post == 'text') {
				$(".post-form").css('display', 'none');
				$("#form-add-text").css('display', 'block');
				
				// 텍스트 포스트 추가 폼 초기화
		    	$("#form-add-text div.note-editable").empty();
		    	$("#form-add-text textarea").val('');
		    	$("#form-add-text div.note-placeholder").css('display', 'block');
			} 
			else if (post == 'file') {
				$(".post-form").css('display', 'none');
				$("#form-add-file").css('display', 'block');
				
				// 파일초기화
				var agent = navigator.userAgent.toLowerCase();
				if ( (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1) ) {
				    $("#form-add-file input:file").replaceWith($("#form-add-file input:file").clone(true));
				} else {
				    $("#form-add-file input:file").val("");
				}
				$(".custom-file-label").html("파일 선택");
			}
			else {
				$(".post-form").css('display', 'none');
				$("#form-add-table").css('display', 'block');
				
				// 테이블 폼 초기화
		    	$("#form-add-table div.note-editable").empty();
		    	$("#form-add-table textarea").val('');
		    	$("#form-add-table div.note-placeholder").css('display', 'block');
			}
			
			$("div#add-post-area hr").css('display', 'block');
		}
	};
	
	// 포스트 작성
	// 1. 텍스트 포스트 추가
	function addTextPost() {
		var postContent = $("#form-add-text textarea").val().trim(); 
		
		if(postContent.length == 0){
			alert("내용을 입력하지 않으셨습니다.");
		}
		else {
			$.ajax({
				url: "${pageContext.request.contextPath}/pages/"+v_nowPageNo+"/posts",
				type: 'POST',
				data: {postSortCode: 'P1',
					   postContent: postContent},
			    success: data => {
			    	// 텍스트 포스트 추가 폼 초기화
			    	$("#form-add-text div.note-editable").empty();
			    	$("#form-add-text textarea").val('');
			    	$("#form-add-text div.note-placeholder").css('display', 'block');
			    	
			    	viewPostBySort('first'); // 전체 포스트 불러오기
					$('html, body').scrollTop( $(document).height() ); // 페이지 맨 아래로 이동
			    },
			    error: (x, s, e) => {
			    	console.log("텍스트 포스트 추가 ajax 요청 실패!", x, s, e);
			    }
			});
		}
	}
	
	// 2. 첨부파일 포스트 추가
	function addFilePost() {
		if($("#form-add-file input:file").prop('files')[0] === undefined){
			alert("파일을 선택하지 않으셨습니다.");
			return;
		}
		
		var upFile = $("#form-add-file input:file").prop('files')[0];
		var formData = new FormData();
		formData.append('postSortCode', 'P2');
		formData.append('upFile', upFile);
		console.log(formData);
		
		$.ajax({
			url: "${pageContext.request.contextPath}/pages/"+v_nowPageNo+"/posts",
			type: 'POST',
			data: formData,
			processData: false, // 파일 업로드 ajax 시 필수 속성
			contentType: false, // 파일 업로드 ajax 시 필수 속성
			success: data => {
				// 파일초기화
				var agent = navigator.userAgent.toLowerCase();
				if ( (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1) ) {
				    $("#form-add-file input:file").replaceWith($("#form-add-file input:file").clone(true));
				} else {
				    $("#form-add-file input:file").val("");
				}
				$(".custom-file-label").html("파일 선택");
				
				viewPostBySort('first'); // 전체 포스트 불러오기
				$('html, body').scrollTop( $(document).height() ); // 페이지 맨 아래로 이동
			},
			error: (x, s, e) => {
				console.log("첨부파일 포스트 추가 ajax 처리 실패!", x, s, e);
			}
		});
		
	} //addFilePost
	
	// 3. 테이블 포스트 추가
	function addTablePost() {
		var postContent = $("#form-add-table textarea").val().trim(); 
		
		if(postContent.length == 0){
			alert("내용을 입력하지 않으셨습니다.");
		}
		else {
			$.ajax({
				url: "${pageContext.request.contextPath}/pages/"+v_nowPageNo+"/posts",
				type: 'POST',
				data: {postSortCode: 'P3',
					   postContent: postContent},
			    success: data => {
			    	// textarea 초기화
			    	$("#form-add-table div.note-editable").empty();
			    	$("#form-add-table textarea").val('');
			    	$("#form-add-table div.note-placeholder").css('display', 'block');
			    	
			    	viewPostBySort('first'); // 전체 포스트 불러오기
			    	$('html, body').scrollTop( $(document).height() ); // 페이지 맨 아래로 이동
			    },
			    error: (x, s, e) => {
			    	console.log("테이블 포스트 추가 ajax 요청 실패!", x, s, e);
			    }
			});
		}
	
	} //addTablePost
	
	// 4-1. 포스트 불러오기
	function viewPostList() {
		// 포스트 종류별 탭 닫기
		$("#more-menu-list").css('display', 'none');

		var postSort = $("#classification-tab").text().trim();
		
		// 현재 선택되어 있는 포스트 종류 탭에 따른 포스트 조회
		if(postSort == '모든 게시물' || postSort == '종류별 정렬')
			viewPostBySort('all');
		else if(postSort == '첨부파일')
			viewPostBySort('file');
		else
			viewPostBySort('pinned');
	}
	
	// 4-2. ajax로 넘겨받은 포스트 데이터 처리
	function ajaxPostList(data) {
		$("#all-post-area").empty();
		
		$.each(data, (idx, post) => {
			var postTag = $("<div class='page-post-area "+post.postSortCode+"' id='post-"+post.postNo+"'></div>");

			// 공통 태그 1 (포스트 관리 드롭다운 메뉴)
			var commonTag1 = "<div class='ui dropdown post-dropdown "+post.postSortCode+"' tabindex='0'>"
						   + "<i class='dropdown btn-post-management fas fa-ellipsis-v' onclick=clickPostManagement('"+post.postNo+"');></i>"
						   + "<div class='menu post-menu "+post.postNo+"' tabindex='-1'>";
						   
			// 관리자이거나 포스트 작성자일 경우만 포스트 수정/삭제 메뉴 띄우기
			if(v_roleCode == 'R1' || "${memberLoggedIn.memberId}" == post.postWriter) {
				
				commonTag1 += "<div class='item' data-toggle='modal' data-target='#modal-update-post-"+post.postSortCode+"' onclick='clickUpdatePost("+post.postNo+");'>"
				 			+ "<i class='edit icon'></i>포스트 수정</div>"
							+ "<div class='item' onclick='deletePost("+post.postNo+");'><i class='delete icon'></i>포스트 삭제</div>"
							+ "<div class='divider'></div>";
			}
		
			commonTag1 += "<div class='item btn-view-comment' onclick='openCommentBar("+post.postNo+");'>"
						+ "<i class='comment alternate icon'></i>코멘트"
						+ "<div class='ui label comment-cnt'>"+post.commentCount+"</div></div>"; //코멘트 숫자 적용해야 함!!!!!!!! [0]
			// 고정 메뉴
			if(post.postPinnedYn == 'N'){ // 고정된 게시물이 아니라면 고정하기 메뉴 뜨기
				commonTag1 += "<div class='item pin' onclick='pinPost(\"Y\", "+post.postNo+");'><i class='icon fas fa-thumbtack'></i>고정하기</div></div></div>"; // 첨부파일은 메뉴 더 추가!! [o]
			} 
			else { // 이미 고정된 게시물이고, 고정한 사람이 나일 경우만 고정해제 메뉴 뜨기
				if("${memberLoggedIn.memberId}" == post.postPinnedPerson){
					commonTag1 += "<div class='item pin' onclick='pinPost(\"N\", "+post.postNo+");'><i class='icon fas fa-thumbtack'></i>고정해제</div></div></div>"
				} 
					commonTag1 += "</div></div><div class='icon-pin'><i class='fas fa-thumbtack'></i>Pinned by '"+post.postPinnedPerson+"'</div>";
			}
						   
			// 공통태그 2 (포스트 작성자) -> 이 안에 포스트 내용 append해야 함
			var commonTag2 = "<div class='page-post'><div class='ui comments post-writer'><div class='comment'><a class='avatar'>";
			
			if(post.profileRenamedFilename == 'default.jpg') 
				commonTag2 += "<img src='${pageContext.request.contextPath}/resources/images/profile/default.jpg' class='img-writer' alt='작성자 사진' onclick='showProfile(\""+post.postWriter+"\");'></a>";
			else
				commonTag2 += "<img src='${pageContext.request.contextPath}/resources/upload/profile/"+post.postWriter+"/"+post.profileRenamedFilename+"' class='img-writer' alt='작성자 사진' onclick='showProfile(\""+post.postWriter+"\");'></a>";
						   
			commonTag2 += "<div class='content'><a class='writer-id'>"+post.postWriter+"</a>"
					   + "<div class='metadata'><div class='date' style='font-weight: bold;'>"+post.postDate+"</div></div></div></div></div>";
			
			// 포스트 종류별 추가
			if(post.postSortCode == 'P1') {
				postTag.append(commonTag1); // 포스트 관리 메뉴 추가
				commonTag2 += "<div class='post-content'>"+post.postContent+"</div></div>";// 포스트 내용
				postTag.append(commonTag2); // 포스트 관련 내용 추가
			}
			else if(post.postSortCode == 'P2') {
				var fileName = post.postRenamedFilename;
				var ext = fileName.substring(fileName.lastIndexOf(".")+1); // 파일 확장자 
				
				// 첨부파일이 이미지라면 이미지 띄우기
				if(ext == 'jpg' || ext == 'JPG' || ext == 'png' || ext == 'PNG' || ext == 'jpeg' || ext == 'JPEG' || ext == 'gif' || ext == 'GIF'){
					commonTag2 += "<span class='image main'><img src='${pageContext.request.contextPath}/resources/upload/page/"+post.pageNo+"/"+post.postRenamedFilename+"' alt='포스트 이미지' /></span></div>";
				}
				else { // 이미지가 아니라면 파일 아이콘 표시 
					commonTag2 += "<div class='file-area'><i class='far fa-file-alt'></i>"+"'"+post.postOriginalFilename+"'"+"</div></div>";
				}
				postTag.append(commonTag1); 
				postTag.append(commonTag2);
			}
			else {
				postTag.append(commonTag1); // 포스트 관리 메뉴 추가
				commonTag2 += "<div class='post-content'>"+post.postContent+"</div></div>";// 포스트 내용
				postTag.append(commonTag2); // 포스트 관련 내용 추가
			}
						   
			$("div#all-post-area").append(postTag);
			
			// 고정된 포스트에만 적용
			if(post.postPinnedYn == 'Y'){
				$("#post-"+post.postNo+" i.btn-post-management").css('top', '2.5rem');
			}
			
			// P2(첨부파일)만 추가
			if(post.postSortCode == 'P2') {
				// 포스트 타입이 첨부파일인 경우 다운로드 메뉴 추가
				if($("div#post-"+post.postNo+" div.pin").length) {
					$("div#post-"+post.postNo+" div.pin").after("<div class='divider'></div><div class='item' onclick='fileDownload(\""+post.postOriginalFilename+"\", \""+post.postRenamedFilename+"\", "+post.postNo+");'><i class='download icon'></i>다운로드</div>");
				}
				else {
					$("div#post-"+post.postNo+" div.btn-view-comment").after("<div class='divider'></div><div class='item'><i class='download icon'></i>다운로드</div>");
				}
				// 포스트 타입이 첨부파일인 경우 첨부파일 이름 추가
				$("div#post-"+post.postNo+" div.metadata").after("<div class='text' style='font-weight: bold; color: gray;'>'"+post.postOriginalFilename+"'</div>");
			}
			
			// P3(테이블)만 추가
			if(post.postSortCode == 'P3'){
				// 표의 기존 클래스 지우고 스타일 적용된 클래스 추가
				$("div#post-"+post.postNo+" table").removeClass('table-bordered');
				$("div#post-"+post.postNo+" table").addClass('ui celled');
			}
			
		});
		//$('html, body').scrollTop( $(document).height() ); // 페이지 맨 아래로 이동
		
		// 작성자 보이기
		if($("#btn-switch").hasClass('switch-on')){
			$("div.post-writer").css('display', 'inline-block');
		}
		else {
			$("div.post-writer").css('display', 'none');
		}
	}
	
	// 4-3. 포스트 관리 메뉴 드롭다운
	function clickPostManagement(postNo){
		 $("div.post-menu."+postNo+"").toggleClass('transition visible');
		 
		 // 다른 포스트의 메뉴는 닫기
		 $("div.post-menu").not("."+postNo+"").removeClass('transition visible');
	}
	
	// 4-4. 포스트 고정/고정 해제
	function pinPost(pinnedYn, postNo) {
		if(v_roleCode == 'R3') {
			alert("포스트 고정 권한이 없습니다.");
			return;
		}
		
		$.ajax({
			url: '${pageContext.request.contextPath}/pages/'+v_nowPageNo+'/posts/'+postNo+'/post-pinned-yn',
			type: 'PUT',
			data: pinnedYn,
			contentType: 'application/json; charset=utf-8',
			success: data => {
				console.log("포스트 고정/해제 성공");
				viewPostList(); // 포스트 불러오기
			},
			error: (x, s, e) => {
				console.log("포스트 고정/해제 실패!", x, s, e);
			}
			
		});

	}
	
	// 4-5. 포스트 수정 모달에 내용 입력시키기
	function clickUpdatePost(postNo) {
		// 생성할 포스트 번호를 전역변수에 저장
		v_nowPostNo = postNo; 
		
		$.ajax({
			url: '${pageContext.request.contextPath}/pages/'+v_nowPageNo+'/posts/'+postNo,
			type: 'GET',
			dataType: 'json',
			success: data => {
				console.log("포스트 수정 모달 불러오기");
				console.log(data);
				
				// 텍스트/테이블 포스트일 경우 수정 폼에 내용 입력
				if(data.postSortCode == 'P1' || data.postSortCode == 'P3') {
			    	$("#modal-update-post-"+data.postSortCode+" textarea").val(data.postContent);
					$("#modal-update-post-"+data.postSortCode+" div.note-editable").html(data.postContent);
					$("#modal-update-post-"+data.postSortCode+" div.note-placeholder").css('display', 'none');
				}
				else { // 첨부파일 포스트일 경우
					// 첨부파일명 전역변수에 저장
					v_fileName = data.postOriginalFilename;
					// 첨부파일 폼에 기존 첨부파일명 입력
					$("#modal-update-post-P2 .custom-file-label").html(data.postOriginalFilename);
					// 첨부파일 선택 취소할 시 
					$("#modal-update-post-P2 input:file").on('click', function(){
						if($(this).prop('files')[0] === undefined) {
							$(this).next('.custom-file-label').html("파일 선택");
						}
					});
					
				}

			},
			error: (x, s, e) => {
				console.log("포스트 수정 모달에 내용 띄우기 ajax 실패!", x, s, e);
			}
		});

	}
	
	// 4-6. 포스트 삭제
	function deletePost(postNo) {
		if(!confirm("정말 삭제하시겠습니까?"))
			return;
		
		$.ajax({
			url: '${pageContext.request.contextPath}/pages/'+v_nowPageNo+'/posts/'+postNo,
			type: 'DELETE',
			success: data => {
				console.log("포스트 삭제 ajax 처리 성공!");
				viewPostList();
			},
			error: (x, s, e) => {
				console.log("포스트 삭제 ajax 처리 실패!", x, s, e);
			}
		});
	}
	
	// 첨부파일 포스트 다운로드
	function fileDownload(oName, rName, postNo) {
		
		if(v_roleCode ==  'R3'){
			alert("파일 다운로드 권한이 없습니다.");
			return;
		}
		
		// 한글 파일명이 있을 수 있으므로, 명시적으로 encoding (특정한 문자를 UTF-8로 인코딩)
		oName = encodeURIComponent(oName);
		location.href="${pageContext.request.contextPath}/pages/"+v_nowPageNo+"/posts/"+postNo+"/download?oName="+oName+"&rName="+rName;
	}
	
	// 5. 포스트 코멘트
	// 5-1. 포스트 코멘트 바 열기
	function openCommentBar(postNo) {
		v_nowPostNo = postNo; // 댓글 작성을 위해 현재 포스트 번호 저장
		$('#comments-bar').sidebar('setting', 'transition', 'overlay').sidebar('show'); // 코멘트 바 열기
		
		commentBarAjax(postNo);
	}

	// 5-2. 포스트 코멘트 바 내용 띄우기
	function commentBarAjax(postNo) {
		$.ajax({
			url: '${pageContext.request.contextPath}/pages/'+v_nowPageNo+'/posts/'+postNo+'/post-comments',
			 type: 'GET',
			 dataType: 'json',
			 success: data => {
				 console.log(data);
				 
				 // 1. textarea 초기화
				 $("#reply-area").empty(); // 답글 대상 지우기
				 v_commentLevel = 1; // commentLevel을 1로 초기화
				 // textarea의 댓글 작성 버튼에 update-comment 클래스 제거
			 	 $("#comment-summernote-area div.btn-submit-summernote").removeClass('update-comment');
				 
				 // summernote 초기화 
				 // 기존에 작성한 댓글 내용 지우기, 비우지 않으면 코멘트 내용 앞 뒤로 p태그 감싸짐
				 $("#comment-summernote-area div.note-editable").empty();
				 // 이 코드 작성하지 않으면 댓글 작성 완료 후에도 textarea에 기존 댓글 내용이 저장되어 있어 댓글을 입력하지 않았음에도 기존 댓글 내용으로 댓글 작성됨
			     $("#comment-summernote-area textarea").val('');
			  		// 댓글 작성 완료 시 placeholder 다시 띄우기
			     $("#comment-summernote-area div.note-placeholder").css('display', 'block');
				 
				 // 2. 코멘트 바 ajax 처리
				 // 2-1. 코멘트 수 표시
				 // 2-1-1. 코멘트 바 내 코멘트 수 표시
				 $("#comments-bar div.comment-cnt").text(data.post.commentCount);
				 // 2-1-2. 포스트 메뉴 내 코멘트 수 표시
				 $("#post-"+data.post.postNo+" div.btn-view-comment div.comment-cnt").text(data.post.commentCount);
				
				 // 2-2. 포스트 작성자 및 포스트 이름 표시
				 if(data.post.profileRenamedFilename == 'default.jpg')
					 $("#commentBar-post-writer a.avatar").html("<img src='${pageContext.request.contextPath}/resources/images/profile/default.jpg' class='img-writer' onclick='showProfile(\""+data.post.postWriter+"\");'>");
				 else
					 $("#commentBar-post-writer a.avatar").html("<img src='${pageContext.request.contextPath}/resources/upload/profile/"+data.post.postWriter+"/"+data.post.profileRenamedFilename+"' class='img-writer' onclick='showProfile(\""+data.post.postWriter+"\");'>");
				 
				 var contentTag = "<a class='writer-id'>"+data.post.postWriter+"</a><div class='metadata'><div class='date'>"+data.post.postDate+"</div></div>";
				 
				 // 첨부파일 포스트일 경우 포스트 이름 표시
				 if(data.post.postSortCode == 'P2'){
					 contentTag += "<div class='text' style='color: gray;'>'"+data.post.postOriginalFilename+"'</div>";
				 }
				 
				 $("#commentBar-post-writer div.content").html(contentTag);
				

				 // 2-3. 포스트 내용 표시
				 if(data.post.postSortCode == 'P1' || data.post.postSortCode == 'P3'){
					$("#comment-content").html(data.post.postContent); 
					$("#comment-content table").removeClass('table-bordered');
					$("#comment-content table").addClass('ui celled');
				 }
				 else { // 포스트가 첨부파일일 경우
					 var fileName = data.post.postRenamedFilename;
					 var ext = fileName.substring(fileName.lastIndexOf(".")+1); // 파일 확장자
					 
						// 첨부파일이 이미지라면 이미지 띄우기
						if(ext == 'jpg' || ext == 'JPG' || ext == 'png' || ext == 'PNG' || ext == 'jpeg' || ext == 'JPEG' || ext == 'gif' || ext == 'GIF'){
							$("#comment-content").html("<img src='${pageContext.request.contextPath}/resources/upload/page/"+data.post.pageNo+"/"+data.post.postRenamedFilename+"'>");
						}
						else { // 이미지가 아니라면 파일 아이콘 표시 
							$("#comment-content").html("<div class='file-area'><i class='far fa-file-alt'></i>"+"'"+data.post.postOriginalFilename+"'"+"</div>");
						}
				 }
				 
				 $("#post-comment-area").html(""); // 포스트 코멘트 내용 초기화
				 
				 // 2-4. 포스트 코멘트 내용 표시
				 $.each(data.commentList, (idx, comment) => {
					 // level 1 코멘트
					 if(comment.postCommentLevel == 1) {
 						 var comment_1 = "<div class='comment' id='comment-"+comment.postCommentNo+"'><a class='avatar'>";
 						 
 						 if(comment.profileRenamedFilename == 'default.jpg') {
 							 comment_1 += "<img src='${pageContext.request.contextPath}/resources/images/profile/default.jpg' class='img-writer' onclick='showProfile(\""+comment.postCommentWriter+"\");'></a>";
 						 }
 						 else {
 							 comment_1 += "<img src='${pageContext.request.contextPath}/resources/upload/profile/"+comment.postCommentWriter+"/"+comment.profileRenamedFilename+"' class='img-writer' onclick='showProfile(\""+comment.postCommentWriter+"\");'></a>";
 						 }
 						 
 						 comment_1 += "<div class='content'><a class='writer-id'>"+comment.postCommentWriter+"</a>"
						  		   + "<div class='metadata'><span class='date'>"+comment.postCommentDate+"</span><a class='reply' onclick='viewReply(2, "+comment.postCommentNo+", \""+comment.postCommentWriter+"\")'>답글</a></div>";
						  			   
						 // 코멘트 작성자일 경우 코멘트 관리 버튼(수정, 삭제) 띄우기
						 if("${memberLoggedIn.memberId}" == comment.postCommentWriter){
							 comment_1 += "<div class='dropdown comment-management'><i class='fas fa-ellipsis-v' data-toggle='dropdown'></i>"
							 			+ "<div class='dropdown-menu comment-menu'>"
							 			+ "<div class='dropdown-item' onclick='updateComment("+comment.postCommentNo+", \""+comment.postCommentContent+"\");'>댓글 수정</div><div class='dropdown-item' onclick='deleteComment("+comment.postCommentNo+")'>댓글 삭제</div></div></div>";
						 }
						 // 워크스페이스 관리자일 경우 다른 사용자의 코멘트 삭제 버튼 띄우기
						 else if(v_roleCode == 'R1'){
							 comment_1 += "<div class='dropdown comment-management'><i class='fas fa-ellipsis-v' data-toggle='dropdown'></i>"
							 			+ "<div class='dropdown-menu comment-menu'>"
							 			+ "<div class='dropdown-item' onclick='deleteComment("+comment.postCommentNo+")'>댓글 삭제</div></div></div>";
						 }
						 						 
						 // 코멘트 내용 
						 comment_1 += "<div class='text'>"+comment.postCommentContent+"</div></div>";
						 
						 $("#post-comment-area").append(comment_1);
					 }
					 // level2 코멘트
 					 else if(comment.postCommentLevel == 2) {
						 var comment_2 = "<div class='comments'><div class='comment'><a class='avatar'>";
						 
 						 if(comment.profileRenamedFilename == 'default.jpg') {
 							 comment_2 += "<img src='${pageContext.request.contextPath}/resources/images/profile/default.jpg' class='img-writer' onclick='showProfile(\""+comment.postCommentWriter+"\");'></a>";
 						 }
 						 else {
 							 comment_2 += "<img src='${pageContext.request.contextPath}/resources/upload/profile/"+comment.postCommentWriter+"/"+comment.profileRenamedFilename+"' class='img-writer' onclick='showProfile(\""+comment.postCommentWriter+"\");'></a>";
 						 }
						 
						 comment_2 += "<div class='content'><a class='writer-id'>"+comment.postCommentWriter+"</a>"
						 		   + "<div class='metadata'><span class='date'>"+comment.postCommentDate+"</span>"
						 		   + "<a class='reply' onclick='viewReply(3, "+comment.postCommentRef+", \""+comment.postCommentWriter+"\")'>답글</a></div>";
						 
						 // 코멘트 작성자일 경우 코멘트 관리 버튼(수정, 삭제) 띄우기
						 if("${memberLoggedIn.memberId}" == comment.postCommentWriter){
							 comment_2 += "<div class='dropdown comment-management'><i class='fas fa-ellipsis-v' data-toggle='dropdown'></i>"
							 			+ "<div class='dropdown-menu comment-menu'>"
							 			+ "<div class='dropdown-item' onclick='updateComment("+comment.postCommentNo+", \""+comment.postCommentContent+"\");'>댓글 수정</div><div class='dropdown-item' onclick='deleteComment("+comment.postCommentNo+");'>댓글 삭제</div></div></div>";
						 }

						 
						 // 워크스페이스 관리자일 경우 다른 사용자의 코멘트 삭제 버튼 띄우기
						 else if(v_roleCode == 'R1') {
							 comment_2 += "<div class='dropdown comment-management'><i class='fas fa-ellipsis-v' data-toggle='dropdown'></i>"
							 			+ "<div class='dropdown-menu comment-menu'>"
							 			+ "<div class='dropdown-item' onclick='deleteComment("+comment.postCommentNo+");'>댓글 삭제</div></div></div>";
						 }
						 // 코멘트 내용
						 comment_2 += "<div class='text'>"+comment.postCommentContent+"</div></div></div></div>";
						 
						 $("#comment-"+comment.postCommentRef+"").append(comment_2);
					 }
					 // level 3 코멘트
					 else {
						 var comment_3 = "<div class='comments'><div class='comment'><a class='avatar'>";
						 
 						 if(comment.profileRenamedFilename == 'default.jpg') {
 							 comment_3 += "<img src='${pageContext.request.contextPath}/resources/images/profile/default.jpg' class='img-writer' onclick='showProfile(\""+comment.postCommentWriter+"\");'></a>";
 						 }
 						 else {
 							 comment_3 += "<img src='${pageContext.request.contextPath}/resources/upload/profile/"+comment.postCommentWriter+"/"+comment.profileRenamedFilename+"' class='img-writer' onclick='showProfile(\""+comment.postCommentWriter+"\");'></a>";
 						 }
						 
 						 comment_3 += "<div class='content'><a class='writer-id'>"+comment.postCommentWriter+"</a>"
						 		   + "<div class='metadata'><span class='date'>"+comment.postCommentDate+"</span>"
						 		   + "<a class='reply' onclick='viewReply(3, "+comment.postCommentRef+", \""+comment.postCommentWriter+"\")'>답글</a></div>";
						 			   
						 // 코멘트 작성자일 경우 코멘트 관리 버튼(수정, 삭제) 띄우기
						 if("${memberLoggedIn.memberId}" == comment.postCommentWriter){
							 comment_3 += "<div class='dropdown comment-management'><i class='fas fa-ellipsis-v' data-toggle='dropdown'></i>"
							 			+ "<div class='dropdown-menu comment-menu'>"
							 			+ "<div class='dropdown-item' onclick='updateComment("+comment.postCommentNo+", \""+comment.postCommentContent+"\");'>댓글 수정</div><div class='dropdown-item' onclick='deleteComment("+comment.postCommentNo+");'>댓글 삭제</div></div></div>";
						 }	   
						 // 워크스페이스 관리자일 경우 다른 사용자의 코멘트 삭제 버튼 띄우기
						 else if(v_roleCode == 'R1') {
							 comment_3 += "<div class='dropdown comment-management'><i class='fas fa-ellipsis-v' data-toggle='dropdown'></i>"
							 			+ "<div class='dropdown-menu comment-menu'>"
							 			+ "<div class='dropdown-item' onclick='deleteComment("+comment.postCommentNo+");'>댓글 삭제</div></div></div>";
						 }

						 // 코멘트 내용
						 comment_3 += "<div class='text'><span style='color: royalblue;'>@"+comment.postCommentRefWriter+"&nbsp</span>"
						 			   + comment.postCommentContent+"</div></div></div></div>"
						 
						 $("#comment-"+comment.postCommentRef+"").append(comment_3);
						 
					 }
					 
					 
				 });
				 
			 },
			 error: (x, s, e) => {
				 console.log("포스트 코멘트 ajax 요청 실패!", x, s, e);
			 }
		});
		
	}
	
	// 5-3. 답글 클릭 시 답글 대상 표시
	function viewReply(level, refNo, refWriter) {
		// 새로 작성할 답글 정보 저장
		v_commentLevel = level; // 코멘트 레벨 저장
		v_commentRefNo = refNo; // 참조 코멘트 번호 저장
		v_commentRefWriter = refWriter; // 참조 코멘트의 작성자 저장
		
		// 코멘트 작성 textarea로 이동 (코멘트바 맨 아래로 이동)
		$("div#comment-overflow").scrollTop($(document).height());
		
		// '@@님에게 답글 작성하기' 문구 보이기
		var replyTag = "<span>"+refWriter+"님에게 답글 작성하기</span>"
				     + "<i class='fas fa-times' id='cancle-reply'></i>";
		$("div#reply-area").html(replyTag);
		
		// 답글 취소 버튼 클릭 시
		$("i#cancle-reply").on('click', function() {
			// 답글 대상 지우기
			$("#reply-area").empty(); // #reply-area의 자식 요소 삭제
			v_commentLevel = 1; // commentLevel을 1로 초기화(답글이 아닌 댓글 작성) 
		});
	}
	
	// 5-4. 댓글 및 답글 작성
	function addComment() {
		var commentContent = $("#comment-summernote-area textarea").val().trim();
		
		if(commentContent.length == 0) {
			alert("댓글을 입력하지 않으셨습니다.");
			return;
		}
		
		// 코멘트 레벨이 1인 경우(댓글)
		if(v_commentLevel == 1) {
			var data = {postCommentLevel: v_commentLevel,
						postCommentContent: commentContent}
		}
		// 코멘트 레벨이 2, 3인 경우(답글)
		else {
			var data = {postCommentLevel: v_commentLevel,
						postCommentContent: commentContent,
						postCommentRef: v_commentRefNo,
						postCommentRefWriter: v_commentRefWriter}
		}
		
		$.ajax({
 			url: '${pageContext.request.contextPath}/pages/'+v_nowPageNo+'/posts/'+v_nowPostNo+'/post-comments',
			type: 'POST',
			data: data,
			success: data => {
				commentBarAjax(v_nowPostNo); // 댓글 불러오기
				
			},
			error: (x, s, e) => {
				console.log("댓글 작성 ajax 요청 오류!", x, s, e);
			}
			
		});
	}
	
 	// 5-5. 댓글 삭제
	function deleteComment(commentNo) {
		if(!confirm("정말 삭제하시겠습니까?"))
			return;
		
		$.ajax({
			url: '${pageContext.request.contextPath}/pages/'+v_nowPageNo+'/posts/'+v_nowPostNo+'/post-comments/'+commentNo,
			type: 'DELETE',
			success: data => {
				console.log("코멘트 삭제 ajax 처리 성공!");
				commentBarAjax(v_nowPostNo); // 댓글 불러오기
			},
			error: (x, s, e) => {
				console.log("코멘트 삭제 ajax 처리 실패!", x, s, e);
			}
		});
	}
 	
 	// 5-6. 댓글 수정
 	// 5-6-1. 수정할 댓글 띄우기
 	function updateComment(commentNo, commentContent) {
 		// 변수에 수정할 댓글 번호 저장
 		v_updateCommentNo = commentNo;
 		
 		// 댓글 작성 버튼에 update-comment 클래스 추가
 		$("#comment-summernote-area div.btn-submit-summernote").addClass('update-comment');
 		
		// 코멘트 작성 textarea로 이동 (코멘트바 맨 아래로 이동)
		$("div#comment-overflow").scrollTop($(document).height());
				
		// 답글 작성 중이었을 경우 답글 대상 지우기
		$("#reply-area").empty();
		
 		// '댓글 수정 중' 문구 보이기
  		var commentUpdateTag = "<span>댓글 수정 중</span><i class='fas fa-times' id='cancle-reply'></i>";
 		$("div#reply-area").html(commentUpdateTag);
 		
 		// 댓글 수정 취소 버튼 클릭 시
		$("i#cancle-reply").on('click', function() {
	 		// 댓글 작성 버튼에 update-comment 클래스 삭제
	 		$("#comment-summernote-area div.btn-submit-summernote").removeClass('update-comment');
			
			$("#reply-area").empty(); // #reply-area의 자식 요소 삭제
			v_commentLevel = 1;
			
			 // summernote 초기화 
			 // 기존에 작성한 댓글 내용 지우기, 비우지 않으면 코멘트 내용 앞 뒤로 p태그 감싸짐
			 $("#comment-summernote-area div.note-editable").empty();
			 // 이 코드 작성하지 않으면 댓글 작성 완료 후에도 textarea에 기존 댓글 내용이 저장되어 있어 댓글을 입력하지 않았음에도 기존 댓글 내용으로 댓글 작성됨
		     $("#comment-summernote-area textarea").val('');
		  		// 댓글 작성 완료 시 placeholder 다시 띄우기
		     $("#comment-summernote-area div.note-placeholder").css('display', 'block');
		  		
		});
 		
		// 수정할 댓글 내용 가져오기
		$("#comment-summernote-area div.note-editable").html(commentContent); // textarea에 수정할 댓글 내용 띄우기
		$("#comment-summernote-area textarea").val(commentContent); // textarea에 댓글 수정 시 넘겨줄 댓글 내용 저장
		$("#comment-summernote-area div.note-placeholder").css('display', 'none'); // placeholder(댓글 입력) 지우기
		
 	}
 	
 	// 5-6-2. 수정할 댓글 제출하기
 	function submitUpdatedComment() {
 		var commentContent = $("#comment-summernote-area textarea").val().trim();
 		
 		if(commentContent.length == 0) {
 			alert("댓글을 입력하지 않으셨습니다.");
 			return;
 		}
 		else {
 			$.ajax({
 				url: '${pageContext.request.contextPath}/pages/'+v_nowPageNo+'/posts/'+v_nowPostNo+'/post-comments/'+v_updateCommentNo,
 				type: 'PUT',
 				data: commentContent,
 				contentType: 'application/json; charset=utf-8',
 				success: data => {
 					console.log("포스트 코멘트 수정 ajax 처리 성공!");
 					commentBarAjax(v_nowPostNo); // 댓글 불러오기
 				},
 				error: (x, s, e) => {
 					console.log("포스트 코멘트 수정 ajax 처리 실패!", x, s, e);
 				}
 			});
 			
 		}
 		
 	}
 	
 	// 페이지 즐겨찾기 해제
 	function deletePageFavorite(favoritesNo) {
 		$.ajax({
 			url: '${pageContext.request.contextPath}/favorites/'+favoritesNo,
 			type: 'DELETE',
 			success: data => {
 				console.log("페이지 즐겨찾기 해제 성공!");
 				
 				// 즐겨찾기 표시 해제
 				$("#btn-star").attr("class", "far fa-star")
 							  .attr("onclick", "addPageFavorite("+v_nowWorkspaceNo+", "+v_nowPageNo+");");
 				// 사이드바 내 페이지 즐겨찾기 리스트에서 제외
 				$("li#favorites-"+favoritesNo+"").remove();
 				
 			},
 			error: (x, s, e) => {
 				console.log("페이지 즐겨찾기 해제 실패!", x, s, e);
 			}
 		});
 	}
 	
 	// 페이지 즐겨찾기 추가
 	function addPageFavorite(workspaceNo, pageNo) {
 		$.ajax({
 			url: '${pageContext.request.contextPath}/page-favorites',
 			type: 'POST',
 			data: {workspaceNo: workspaceNo, pageNo: pageNo},
 			success: data => {
 				console.log("페이지 즐겨찾기 추가 성공!");
 				
 				// 즐겨찾기 표시 (data.createdFavoriteNo: 생성된 즐겨찾기 번호)
 				$("#btn-star").attr("class", "fas fa-star")
 					          .attr("onclick", "deletePageFavorite("+data.createdFavoriteNo+");");
 			},
 			error: (x, s, e) => {
 				console.log("페이지 즐겨찾기 추가 실패!", x, s, e);
 			}
 		});
 	}
 	

	//summernote 함수
	function summernoteSetting() {

		//1. 텍스트, 테이블 툴바
		var textToolbar = [
			// [groupName, [list of button]]
			['font', ['style', 'bold', 'underline', 'strikethrough']],
			['fontname', ['fontname']],
			['fontsize', ['fontsize']],
			['color', ['color']],
			['para', ['paragraph']],
			['height', ['height']],
		];

		var tableToolbar = [
			['table'],
			['font', ['bold', 'strikethrough']],
			['fontname', ['fontname', 'fontsize', 'color']],
		];

		var commentToolbar = [
			['font', ['bold', 'underline', 'strikethrough']],
		];

		$('.text-summernote').summernote({
			toolbar: textToolbar,
			lang: "ko-KR",
			height: 100,
			placeholder: '텍스트 입력',
			codeviewFilter: false,				//XSS 보호
  			codeviewIframeFilter: true
		});

		$('.table-summernote').summernote({
			toolbar: tableToolbar,
			lang: "ko-KR",
			height: 100,
			placeholder: '테이블 작성',
			codeviewFilter: false,				//XSS 보호
  			codeviewIframeFilter: true
		});

		$('.comment-summernote').summernote({
			toolbar: commentToolbar,
			lang: "ko-KR",
			height: 70,
			placeholder: '코멘트 입력',
			codeviewFilter: false,				//XSS 보호
  			codeviewIframeFilter: true
		});
		
		//2. 전송, 닫기 버튼 추가
		var submitButton = '<div class="btn-submit-summernote" type="button"><i class="paper plane icon"></i></div>';
		var closeButton = '<div class="btn-close-post-form"><i class="fas fa-times"></i></div>';
		$(".post-form .note-toolbar").append(submitButton);
		$(".post-form").append(closeButton);
		$("#comment-summernote-area .note-toolbar").append(submitButton);

		//3. summernote 닫기
		$(".btn-close-post-form").on('click', function(){
			$("form.post-form").css('display', 'none');
			$("div#add-post-area hr").css('display', 'none');
		});
		
	};

	//페이지 커버 컬러 변경
	function changeCoverColor(colorOption) {
		if(v_roleCode == 'R1' || "${page.pageWriter}" == "${memberLoggedIn.memberId}") {
			
			$("#page-cover").css("background", colorOption);
			$(".p-name i").css("color", colorOption);
			$("#page-name i").css("color", colorOption);
			
			var pageNo = ${page.pageNo};
			
			// 커버 색 변경
			$.ajax({
				url: "${pageContext.request.contextPath}/pages/"+pageNo+"/cover-color",
				data: colorOption,
				type: "PUT",
				contentType: "application/json; charset=utf-8",
				success: data => {
					console.log("페이지 커버 색 변경 성공");
				},
				error: (x, s, e) => {
					console.log("페이지 커버 색 변경 ajax 요청 실패!", x, s, e);
				}
			})
		}
		else {
			alert("페이지 커버 색 변경 권한이 없습니다.");
		}
		
	}


</script>

	</body>
</html>
	
	
	