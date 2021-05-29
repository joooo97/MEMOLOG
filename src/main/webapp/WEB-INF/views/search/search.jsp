<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
<!-- 검색 페이지에서만 필요한 css -->
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/juhyun.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/searchPage-accountSettingsPage.css" />
</head>
<body class="is-preload">

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
			<div class="inner">
				<!-- Content -->
				<section>
					<div class="ui icon input search-tab" id="searchPage-search-tab">
						<input type="text" placeholder="검색" value="${keyword}">
						<i class="link search icon" onclick="search();"></i>
					</div>
					<div class="ui secondary pointing menu" id="menu-tab">
						<c:if test="${searchedWsList != null}">
							<a class="item" id="searched-ws">워크스페이스명</a>
						</c:if>
						<c:if test="${searchedPageList != null}">
							<a class="item" id="searched-page">페이지명</a>
						</c:if>
						<c:if test="${searchedPostList != null}">
							<a class="item" id="searched-post">포스트</a>
						</c:if>
						<c:if test="${searchedCommentList != null}">
							<a class="item" id="searched-comment">코멘트</a>
						</c:if>
					</div>
					<!-- 검색 결과 영역 -->
					<!-- 1. 워크스페이스명 검색 결과 -->
					<c:if test="${searchedWsList != null}">
						<div class="ui segment searched-result-area" id="searched-ws-area">
							<c:forEach items="${searchedWsList}" var="ws">
								<div class="ui raised link card">
									<div class="content card-ws-name" onclick="location.href='${pageContext.request.contextPath}/workspaces/${ws.workspaceNo}'">
										<i class="fas fa-feather" style="color: ${ws.workspaceCoverCode};"></i>${ws.workspaceName}
									</div>
								</div>
							</c:forEach>
						</div>	
					</c:if>
					<!-- 2. 페이지명 검색 결과 -->
					<c:if test="${searchedPageList != null}">
						<div class="ui segment searched-result-area" id="searched-page-area">
							<c:forEach items="${searchedPageList}" var="page">
								<div class="ui raised link card">
									<div class="content card-page-name" onclick="location.href='${pageContext.request.contextPath}/pages/${page.pageNo}'">
										<i class="fas fa-feather" style="color: ${page.workspaceCoverCode};"></i>${page.workspaceName}
										<span>/</span>
										<i class="fas fa-sticky-note" style="color: ${page.pageCoverCode}"></i>${page.pageName}
									</div>
								</div>
							</c:forEach>
						</div>	
					</c:if>
					<!-- 3. 포스트 검색 결과 -->
					<c:if test="${searchedPostList != null}">
						<div class="ui segment searched-result-area" id="searched-post-area">
							<c:forEach items="${searchedPostList}" var="post">
								<!-- 1. 텍스트 포스트 -->
								<c:if test="${post.postSortCode == 'P1'}">
									<div class="ui raised link card" onclick="location.href='${pageContext.request.contextPath}/pages/${post.pageNo}/searched-post/${post.postNo}'">
										<div class="ui comments content">
											<div class="meta">
												<i class="fas fa-feather" style="color: ${post.workspaceCoverCode};"></i>${post.workspaceName}
												<span>/</span>
												<i class="fas fa-sticky-note" style="color: ${post.pageCoverCode}"></i>${post.pageName}
												<span class="post-sort"> > 텍스트</span>
											</div>
											<div class="comment">
												<c:if test="${post.profileRenamedFilename == 'default.jpg'}">
													<a class="avatar"><img src="${pageContext.request.contextPath}/resources/images/profile/default.jpg" alt="사용자 프로필 이미지" class="img-writer"></a>
												</c:if>
												<c:if test="${post.profileRenamedFilename != 'default.jpg'}">
													<a class="avatar"><img src="${pageContext.request.contextPath}/resources/upload/profile/${post.postWriter}/${post.profileRenamedFilename}" alt="사용자 프로필 이미지" class="img-writer"></a>
												</c:if>
												<div class="content">
													<div class="author">${post.postWriter}
														<div class="metadata"><span>${post.postDate}</span></div>
													</div>
													<p>${post.postContent}</p>
												</div>
											</div>
										</div>
									</div>
								</c:if>
								<!-- 2. 이미지 포스트 -->
								<c:if test="${post.postSortCode == 'P2'}">
									<div class="ui raised link card" onclick="location.href='${pageContext.request.contextPath}/pages/${post.pageNo}/searched-post/${post.postNo}'">
										<div class="ui comments content">
											<div class="meta">
												<i class="fas fa-feather" style="color: ${post.workspaceCoverCode};"></i>${post.workspaceName}
												<span>/</span>
												<i class="fas fa-sticky-note" style="color: ${post.pageCoverCode}"></i>${post.pageName}
												<span class="post-sort"> > 이미지</span>
											</div>
											<div class="comment">
												<c:if test="${post.profileRenamedFilename == 'default.jpg'}">
													<a class="avatar"><img src="${pageContext.request.contextPath}/resources/images/profile/default.jpg" alt="사용자 프로필 이미지" class="img-writer"></a>
												</c:if>
												<c:if test="${post.profileRenamedFilename != 'default.jpg'}">
													<a class="avatar"><img src="${pageContext.request.contextPath}/resources/upload/profile/${post.postWriter}/${post.profileRenamedFilename}" alt="사용자 프로필 이미지" class="img-writer"></a>
												</c:if>
												<div class="content">
													<div class="author">${post.postWriter}
														<div class="metadata"><span>${post.postDate}</span></div>
													</div>
													<div>
														<div class="text">${post.postOriginalFilename}</div>
														<span class="image main"><img src="${pageContext.request.contextPath}/resources/upload/page/${post.pageNo}/${post.postRenamedFilename}" alt="포스트 이미지" class="post-image"/></span>
													</div>
												</div>
											</div>
										</div>
									</div>
								</c:if>
								<!-- 3. 테이블 포스트 -->
								<c:if test="${post.postSortCode == 'P3'}">
									<div class="ui raised link card" onclick="location.href='${pageContext.request.contextPath}/pages/${post.pageNo}/searched-post/${post.postNo}'">
										<div class="ui comments content">
											<div class="meta">
												<i class="fas fa-feather" style="color: ${post.workspaceCoverCode};"></i>${post.workspaceName}
												<span>/</span>
												<i class="fas fa-sticky-note" style="color: ${post.pageCoverCode}"></i>${post.pageName}
												<span class="post-sort"> > 테이블</span>
											</div>
											<div class="comment">
												<c:if test="${post.profileRenamedFilename == 'default.jpg'}">
													<a class="avatar"><img src="${pageContext.request.contextPath}/resources/images/profile/default.jpg" alt="사용자 프로필 이미지" class="img-writer"></a>
												</c:if>
												<c:if test="${post.profileRenamedFilename != 'default.jpg'}">
													<a class="avatar"><img src="${pageContext.request.contextPath}/resources/upload/profile/${post.postWriter}/${post.profileRenamedFilename}" alt="사용자 프로필 이미지" class="img-writer"></a>
												</c:if>
												<div class="content">
													<div class="author">${post.postWriter}
														<div class="metadata"><span>${post.postDate}</span></div>
													</div>
													<div>${post.postContent}</div>
												</div>
											</div>
										</div>
									</div>
								</c:if>
							</c:forEach>
						</div>	
					</c:if>
					<!-- 4. 코멘트 검색 결과 -->
					<c:if test="${searchedCommentList != null}">
						<div class="ui segment searched-result-area" id="searched-comment-area">
							<c:forEach items="${searchedCommentList}" var="c"> 
								<div class="ui raised link card" onclick="showComment(${c.pageNo}, ${c.postNo});">
									<div class="ui comments content">
										<div class="meta">
											<i class="fas fa-feather" style="color: ${c.workspaceCoverCode}"></i>${c.workspaceName}
											<span>/</span>
											<i class="fas fa-sticky-note" style="color: ${c.pageCoverCode}"></i> ${c.pageName}
										</div>
										<div class="comment">
											<c:if test="${c.profileRenamedFilename == 'default.jpg'}">
												<a class="avatar"><img src="${pageContext.request.contextPath}/resources/images/profile/default.jpg" alt="사용자 프로필 이미지" class="img-writer"></a>
											</c:if>
											<c:if test="${c.profileRenamedFilename != 'default.jpg'}">
												<a class="avatar"><img src="${pageContext.request.contextPath}/resources/upload/profile/${c.postCommentWriter}/${c.profileRenamedFilename}" alt="사용자 프로필 이미지" class="img-writer"></a>
											</c:if>
											<div class="content">
												<a class="author">${c.postCommentWriter}</a>
											<div class="metadata">
												<div class="date">${c.postCommentDate}</div>
											</div>
											<div class="text">
												<c:if test="${c.postCommentLevel == 3}">
													<span style="color: royalblue;">@${c.postCommentRefWriter}&nbsp;</span>
												</c:if>
												${c.postCommentContent}
											</div>
										  </div>
										</div>
									</div>
								</div>
							</c:forEach> 
						</div>	
					</c:if>
					<!-- 검색 결과가 존재하지 않을 때 -->
					<c:if test="${searchedWsList == null && searchedPageList == null && searchedPostList == null && searchedCommentList == null}">
						<div class="ui segment" id="no-search-results-area">
							<div class="content">
								<span>'${keyword}'</span> 와(과) 일치하는 검색결과가 없습니다.
							</div>
						</div>	
					</c:if>
				</section>
			</div>
			<!-- /#main .inner -->
		</div>
		<!-- /#main -->
		
		<!-- 좌측 사이드바 -->
		<jsp:include page="/WEB-INF/views/common/leftSideBar.jsp"></jsp:include>
	</div>
	<!-- /#wrapper -->
	
	<!-- 모달 모음 - 3,4,5,6,7,9 필요 -->
	<jsp:include page="/WEB-INF/views/common/modals.jsp"></jsp:include>
	<!-- 공통스크립트 -->		
	<jsp:include page="/WEB-INF/views/common/commonScript.jsp"></jsp:include>
	<!-- 모달 기능 js -->
	<script src="${pageContext.request.contextPath }/resources/js/juhyunModal.js"></script>	
	<!-- 댓글 관련 기능 js -->
	<script src="${pageContext.request.contextPath}/resources/js/comment.js"></script>
		
	<script>
	let v_nowPageNo; // 코멘트 검색 시 필요한 페이지 번호
	
	$(function() {
		// 워크스페이스명, 페이지명이 아닌 토글버튼만 보이기
		$("#header-workspace-name li").not(".toggle").remove();
		
		// semantic dropdown 활성화
		$('.ui.dropdown').dropdown();
		
		// semantic ui menu 활성화
		$('.ui.pointing.menu').on('click', '.item', function() {
			if(!$(this).hasClass('dropdown')) {
				$(this).addClass('active').siblings('.item').removeClass('active');
			}
		});
		
		// 검색 결과의 처음 탭에 active 클래스 추가
		$("#menu-tab").find("a.item").first().addClass("active");
		
		// 검색 결과의 처음 탭에 맞는 결과 띄우기 (나머지 결과 영역 지우기)
		let result_area = $("#menu-tab").find("a.item").first().attr('id');
		$(".searched-result-area").not("#"+result_area+"-area").css('display', 'none');
		
		// 탭 클릭 시 탭에 맞는 결과 띄우기
		$("#menu-tab a.item").on('click', function() {
			let area = $(this).attr('id');
			
			$("#"+area+"-area").css('display', 'block');
			$(".searched-result-area").not("#"+area+"-area").css('display', 'none');
		});
		
		
	});
		
	//함수 영역
	function showComment(pageNo, postNo) {
		v_nowPageNo = pageNo;
		openCommentBar(postNo);
	}
		
	
	</script>

	</body>
</html>	
