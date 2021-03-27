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
var v_nowPageNo = "${page.pageNo}";
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
			<li><i id="btn-star" class="fas fa-star"></i></li>
			<!-- <li><i id="btn-star" class="far fa-star"></i></li> -->
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
				<div id="post-comment-area">
				<!-- 각 코멘트 -->
 				<div class="comment"> <!-- id="comment-12" -->
				  <a class="avatar">
					<img src="${pageContext.request.contextPath }/resources/images/pic11.jpg" class="img-writer">
				  </a>
				  <!-- .content: 코멘트 내용 -->
				  <div class="content">
					<a class="author">Elliot Fu</a>
					<div class="metadata">
					  <span class="date">Yesterday at 12:30AM</span>
					  <a class="reply">답글</a>
					</div>
					<!-- 1. 포스트 관리 드롭다운 -->
						<div class="ui dropdown post-dropdown">
							<i class="dropdown fas fa-ellipsis-v"></i>
							<div class="menu">
								<div class="item" data-toggle="modal" data-target="#modal-update-post-file">
									<i class="edit icon"></i>코멘트 수정
								</div>
								<div class="item"><i class="delete icon"></i>코멘트 삭제</div>
							</div>
						</div>
					
					<div class="text">
					  <p>This has been very useful for my research. Thanks as well!</p>
					</div>
				  </div>
				  <!-- .comments: 답글 -->
				  <div class="comments">
					<div class="comment">
					  <a class="avatar">
						<img src="${pageContext.request.contextPath }/resources/images/pic11.jpg"  class="img-writer">
					  </a>
					  <div class="content">
						<a class="author">Jenny Hess</a>
						<div class="metadata">
						  <span class="date">Just now</span>
						</div>
						<div class="text">
						  Elliot you are always so right :)
						</div>
						<div class="actions">
						  <a class="reply">답글</a>
						</div>
					  </div>
					</div>
				  </div>
				</div>

				<div class="comment">
				  <a class="avatar">
					<img src="${pageContext.request.contextPath }/resources/images/pic11.jpg" class="img-writer">
				  </a>
				  <div class="content">
					<a class="author">Elliot Fu</a>
					<div class="metadata">
					  <span class="date">Yesterday at 12:30AM</span>
					</div>
					<div class="text">
					  <p>This has been very useful for my research. Thanks as well!</p>
					</div>
					<div class="actions">
					  <a class="reply">답글</a>
					</div>
				  </div>
				  <div class="comments">
					<div class="comment">
					  <a class="avatar">
						<img src="${pageContext.request.contextPath }/resources/images/pic11.jpg"  class="img-writer">
					  </a>
					  <div class="content">
						<a class="author">Jenny Hess</a>
						<div class="metadata">
						  <span class="date">Just now</span>
						</div>
						<div class="text">
						  Elliot you are always so right :)
						</div>
					  </div>
					</div>
				  </div>
				</div>
				</div> <!-- #post-comment-area -->

				<div id="comment-summernote-area">
					<div id="reply-area">
						<span>jthis님에게 답글 작성하기</span>
						<i class="fas fa-times" id="cancle-reply"></i>
					</div>
					<textarea class="comment-summernote summernote" name="editordata"></textarea>
				</div>
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
					
					<div id="all-post-area">
					<!-- 포스트 영역 -->
					<!-- #1. 포스트 (첨부파일) -->
					<div class="page-post-area">
						<!-- 1. 포스트 관리 드롭다운 -->
						<div class="ui dropdown post-dropdown">
							<i class="dropdown btn-post-management fas fa-ellipsis-v"></i>
							<div class="menu post-menu">
								<div class="item" data-toggle="modal" data-target="#modal-update-post-file">
									<i class="edit icon"></i>포스트 수정
								</div>
								<div class="item"><i class="delete icon"></i>포스트 삭제</div>
								<div class="divider"></div>
								<!-- <div class="item btn-view-comment" onclick="openCommentBar(post.postNo);"> -->
								<div class="item btn-view-comment">
									<i class="comment alternate icon"></i>코멘트
									<div class="ui label comment-cnt">1</div>
								</div>
								<div class="item"><i class="icon fas fa-thumbtack"></i>고정하기 / 고정해제</div>
								<div class="divider"></div>
								<div class="item">원본 보기 [?]</div>
								<div class="item">다운로드</div>
							</div>
						</div>
						<div class="icon-pin"><i class="fas fa-thumbtack"></i>Pinned by '주현'</div>
						<!-- 2. 포스트 -->
						<div class="page-post"> 
							<!-- 포스트 작성자 -->
							<div class="ui comments post-writer">
								<div class="comment">
									<a class="avatar">
										<img src="${pageContext.request.contextPath }/resources/images/pic11.jpg" class="img-writer">
									</a>
									<div class="content">
										<a class="author">이주현</a>
										<div class="metadata"><div class="date">07.26</div></div>
										<div class="text">'위영드림.jpg'</div>
									</div>
								</div>
							</div>
							<!-- /.post-writer -->
							<span class="image main"><img src="${pageContext.request.contextPath }/resources/images/위영드림.jpg" alt="" /></span>
						</div>
						<!-- .page-post -->
					</div>
					<!-- /.page-post-area -->

					  <!-- #2. 포스트 (텍스트) -->
  					<div class="page-post-area">
						<!-- 1. 포스트 관리 드롭다운 -->
						<div class="ui dropdown post-dropdown">
							<i class="dropdown btn-post-management fas fa-ellipsis-v"></i>
							<div class="menu post-menu">
								<div class="item" data-toggle="modal" data-target="#modal-update-post-text">
									<i class="edit icon"></i>포스트 수정
								</div>
								<div class="item"><i class="delete icon"></i>포스트 삭제</div>
								<div class="divider"></div>
								<!-- <div class="item btn-view-comment" onclick="openCommentBar(post.postNo);"> -->
								<div class="item btn-view-comment">
									<i class="comment alternate icon"></i>코멘트
									<div class="ui label comment-cnt">1</div>
								</div>
								<div class="item" onclick="pinPost(postNo)";><i class="icon fas fa-thumbtack"></i>고정하기 / 고정해제</div>
						    </div>
						</div>
						<div class="icon-pin"><i class="fas fa-thumbtack"></i>Pinned by '제노'</div>
						<!-- 2. 포스트 -->
						<div class="page-post"> 
						  <!-- 포스트 작성자 -->
						  <div class="ui comments post-writer">
							<div class="comment">
							  <a class="avatar">
								<img src="${pageContext.request.contextPath }/resources/images/pic11.jpg" class="img-writer">
							  </a>
							  <div class="content">
								<a class="author">이제노</a>
								<div class="metadata"><div class="date">07.26</div></div>
							  </div>
							</div>
						  </div>
						  <!-- /.post-writer -->
						  <p>Donec eget ex magna. Interdum et malesuada fames ac ante ipsum primis in faucibus. Pellentesque venenatis dolor imperdiet dolor mattis sagittis. Praesent rutrum sem diam, vitae egestas enim auctor sit amet. Pellentesque leo mauris, consectetur id ipsum sit amet, fergiat. Pellentesque in mi eu massa lacinia malesuada et a elit. Donec urna ex, lacinia in purus ac, pretium pulvinar mauris. Curabitur sapien risus, commodo eget turpis at, elementum convallis elit. Pellentesque enim turpis, hendrerit.</p>
						</div>
						<!-- .page-post -->
	 					</div>
	 					<!-- /.page-post-area -->
				  
	 					<!-- #3. 포스트 (테이블) -->
	 					<div class="page-post-area">
						<!-- 1. 포스트 관리 드롭다운 -->
						<div class="ui dropdown post-dropdown">
							<i class="dropdown btn-post-management fas fa-ellipsis-v"></i>
							<div class="menu post-menu">
								<div class="item" data-toggle="modal" data-target="#modal-update-post-table">
									<i class="edit icon"></i>포스트 수정
								</div>
								<div class="item"><i class="delete icon"></i>포스트 삭제</div>
								<div class="divider"></div>
								<!-- <div class="item btn-view-comment" onclick="openCommentBar(post.postNo);"> -->
								<div class="item btn-view-comment">
									<i class="comment alternate icon"></i>코멘트
									<div class="ui label comment-cnt">1</div>
								</div>
								<div class="item"><i class="icon fas fa-thumbtack"></i>고정하기 / 고정해제</div>
						    </div>
						</div>
						<div class="icon-pin"><i class="fas fa-thumbtack"></i>Pinned by '마크리'</div>
						<!-- 2. 포스트 -->
						<div class="page-post"> 
						  <!-- 포스트 작성자 -->
						  <div class="ui comments post-writer">
							<div class="comment">
							  <a class="avatar">
								<img src="${pageContext.request.contextPath }/resources/images/pic11.jpg" class="img-writer">
							  </a>
							  <div class="content">
								<a class="author">이민형</a>
								<div class="metadata"><div class="date">07.29</div></div>
							  </div>
							</div>
						  </div>
						  <!-- /.post-writer -->
						  <table class="ui celled table">
							<thead>
							  <tr><th>Name</th>
							  <th>Age</th>
							  <th>Job</th>
							</tr></thead>
							<tbody>
							  <tr>
							  <td data-label="Name">James</td>
							  <td data-label="Age">24</td>
							  <td data-label="Job">Engineer</td>
							  </tr>
							  <tr>
							  <td data-label="Name">Jill</td>
							  <td data-label="Age">26</td>
							  <td data-label="Job">Engineer</td>
							  </tr>
							  <tr>
							  <td data-label="Name">Elyse</td>
							  <td data-label="Age">24</td>
							  <td data-label="Job">Designer</td>
							  </tr>
							</tbody>
						  </table>
						</div>
						<!-- .page-post -->
	 					</div> <!-- /.page-post-area -->
	 					</div> <!-- #all-post-area -->
	 					
	 					<!-- 포스트 추가 영역 -->
						<div id="add-post-area">
							<hr>
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
						<input type="checkbox" name="public" id="btn-switch">
						<label>작성자 보기</label>
					</div>

				<li class="list-group-item">
					<button id="classification-tab" class="btn btn-sm dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
						  종류별 정렬
					</button>
					<div class="dropdown-menu" style="font-size: 95%;">
					    <div class="dropdown-item" onclick="clickMoreMenu('모든 게시물');">모든 게시물</div>
					    <div class="dropdown-item" onclick="clickMoreMenu('첨부파일');">첨부파일</div>
					    <div class="dropdown-item" onclick="clickMoreMenu('고정 게시물');">고정 게시물</div>
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
		<script src="${pageContext.request.contextPath }/resources/js/juhyunModal.js?"></script>
		<!-- 공통스크립트 -->
		<jsp:include page="/WEB-INF/views/common/commonScript.jsp"></jsp:include>	
	
<script>

	$(function() {
		commentSideBar(); //코멘트 사이드바 활성화
		summernoteSetting(); //summernote 설정

		// 포스트 작성자 보이기
		$("#btn-switch").on('change', function() {
			if($("#btn-switch").is(":checked")){
				$(".post-writer").css('display', 'inline-block');
			} else {
				$(".post-writer").css('display', 'none');
			}
		});
		
		// #1. 포스트 작성 완료 버튼 누를 시
		// 1-1. 텍스트 포스트
		$("#form-add-text button.btn-submit-summernote").on('click', function() {
			addTextPost();
		});
		
		// 1-2. 첨부파일 포스트
		// 1-2-1. 파일 선택, 취소 시에 파일명 노출
		$("#form-add-file input:file").on('change', function(){
			// 파일선택 취소 시
			if($(this).prop('files')[0] === undefined){
				$(this).next('.custom-file-label').html("파일 선택");
				return;
			}
			// 파일선택 시
			var fileName = $(this).prop('files')[0].name; // ex)코드사진.jpg
			$(this).next('.custom-file-label').html(fileName);
		});
	
		// 1-2-2. 파일 업로드
		$("#inputGroupFileAddon04").on('click', function(){
			addFilePost();
		});
		
		// 1-3. 테이블 포스트
		// 1-1 함수를 같이 쓰면 될지?

	});

	// [ 함수 영역 ]
	// 게시글 종류별 조회 탭
	function clickMoreMenu(menu){
		$("#classification-tab").text(menu);
	};

	//코멘트 사이드바 활성화 함수
	function commentSideBar(){
		$(".btn-view-comment").on('click', function(){
			$('#comments-bar').sidebar('setting', 'transition', 'overlay').sidebar('show');
		});
		$("#btn-close-comments").on('click', function(){
			$('#comments-bar').sidebar('setting', 'transition', 'overlay').sidebar('hide');
		});
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
			} else if (post == 'file') {
				$(".post-form").css('display', 'none');
				$("#form-add-file").css('display', 'block');
			} else {
				$(".post-form").css('display', 'none');
				$("#form-add-table").css('display', 'block');
			}
		}
	};
	
	// 포스트 작성
	// 1. 텍스트 포스트 추가
	function addTextPost(){
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
				dataType: 'json',
			    success: data => {
			    	console.log(data);
			    	//viewPostList('add'); // 포스트 조회 ajax 처리
			    	// 우선 ajax로 포스트 하나만 추가해보기
			    	// 내일 -> 포스트 조회 ajax 함수 selectAjaxPost(data) 이런식으로 만들어서 -> 포스트 삭제/분류별 포스트 정렬 시 이용
			    	// 포스트 추가 시에 위의 함수 이용했는데 페이지 내에서 화면이 맨 위로 이동한다던가 하면 포스트 추가 시에는 함수 이용하지 말고
			    	// 현재 ajax에서 각 각 하나씩 추가하도록 하기
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
		
		//var fileName = $("#form-add-file input:file").prop('files')[0].name;
		var upFile = $("#form-add-file input:file").prop('files')[0];
		var formData = new FormData();
		formData.append('postSortCode', 'P2');
		formData.append('upFile', upFile);
		
		$.ajax({
			url: "${pageContext.request.contextPath}/pages/"+v_nowPageNo+"/posts",
			type: 'POST',
			data: formData,
			processData: false, // 파일 업로드 ajax 시 필수 속성
			contentType: false, // 파일 업로드 ajax 시 필수 속성
			dataType: 'json',
			success: data => {
				console.log(data);
			},
			error: (x, s, e) => {
				console.log("첨부파일 포스트 추가 ajax 처리 실패!", x, s, e);
			}
		});
		
	} //addFilePost
	
	// 3. 테이블 포스트 추가
	
	// 4. 포스트 불러오기
/* 	function viewPostList(){
		$.ajax({
			url: '${pageContext.request.contextPath}/pages/'+v_nowPageNo+'/posts',
			type: 'GET',
			dataType: 'json',
			success: data => {
				
			},
			error: (x, s, e) => {
				console.log("포스트 조회 ajax 요청 실패!", x, s, e);
			}
			
		});
	} */

	//summernote 함수
	function summernoteSetting() {

		//1. 텍스트, 테이블 툴바
		var textToolbar = [
			// [groupName, [list of button]]
			['font', ['style', 'bold', 'italic', 'underline', 'strikethrough']],
			['fontname', ['fontname']],
			['fontsize', ['fontsize']],
			['color', ['color']],
			['para', ['paragraph']],
			['height', ['height']],
		];

		var tableToolbar = [
			['table'],
			['fontname', ['fontname', 'fontsize', 'color']],
		];

		var commentToolbar = [
			['font', ['bold', 'italic', 'underline', 'strikethrough']],
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
/* 		var submitButton = '<button class="btn-submit-summernote" type="submit"><i class="paper plane icon"></i></button>'; */
		var submitButton = '<button class="btn-submit-summernote" type="button"><i class="paper plane icon"></i></button>';
		var closeButton = '<div class="btn-close-post-form"><i class="fas fa-times"></i></div>';
		$(".note-toolbar").append(submitButton);
		$(".post-form").append(closeButton);

		//3. summernote 닫기
		$(".btn-close-post-form").on('click', function(){
			$("form.post-form").css('display', 'none');
		});
		
	};

	//페이지 커버 컬러 변경
	function changeCoverColor(colorOption) {
		$("#page-cover").css("background", colorOption);
		$(".p-name i").css("color", colorOption);
		$("#page-name i").css("color", colorOption);
		
		var pageNo = ${page.pageNo};
		
		// 커버 색 변경
		$.ajax({
			url: "${pageContext.request.contextPath}/pages/"+pageNo+"/cover-color",
			data: colorOption,
			type: "PUT",
			/* contentType: "application/json; charset=utf-8", */
			success: data => {
				console.log("페이지 커버 색 변경 성공");
			},
			error: (x, s, e) => {
				console.log("페이지 커버 색 변경 ajax 요청 실패!", x, s, e);
			}
		})
		
	}


</script>

	</body>
</html>
	
	
	