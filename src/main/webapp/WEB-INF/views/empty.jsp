<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
<script src="${pageContext.request.contextPath }/resources/js/jquery.min.js"></script>

</head>
<body>

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
								<div class="item pin"><i class="icon fas fa-thumbtack"></i>고정하기 / 고정해제</div>
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
										<div class="metadata"><div class="date">${page.pageDate }</div></div>
										<div class="text">'위영드림.jpg'</div>
									</div>
								</div>
							</div>
							<!-- /.post-writer -->
							<span class="image main"><img src="${pageContext.request.contextPath }/resources/images/위영드림.jpg" alt="" /></span>
						</div>
						<!-- .page-post -->
					</div>

<script>

</script>
















</body>
<jsp:include page="/WEB-INF/views/common/commonScript.jsp"></jsp:include>

</html>