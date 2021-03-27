<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

 			<!-- 여기 아래부터@!@2@@ -->
  				<!-- 코멘트 1 -->
 				<div class="comment">
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
					<!-- 코멘트 관리 버튼 -->
					<div class="dropdown comment-management">
					  <i class="fas fa-ellipsis-v" data-toggle="dropdown"></i>
					  <div class="dropdown-menu comment-menu">
					  	<div class="dropdown-item">댓글 수정</div>
					  	<div class="dropdown-item">댓글 삭제</div>
					  </div>
					</div>
					<!-- 코멘트 내용 -->
					<div class="text">
					  <p>This has been very useful for my research. Thanks as well!</p>
					</div>
					<!-- <div class="actions">
					  <a class="reply">답글</a>
					</div> -->
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
						  <a class="reply">답글</a>
						</div>
						<!-- 코멘트 관리 버튼 -->
						<div class="dropdown comment-management">
						  <i class="fas fa-ellipsis-v" data-toggle="dropdown"></i>
						  <div class="dropdown-menu comment-menu">
						    <div class="dropdown-item">댓글 수정</div>
						    <div class="dropdown-item">댓글 삭제</div>
						  </div>
						</div>
						<!-- 코멘트 내용 -->
						<div class="text">
						  Elliot you are always so right :)
						</div>
						<!-- <div class="actions">
						  <a class="reply">답글</a>
						</div> -->
					  </div>
					</div>
				  </div>
				</div>

  				<!-- 코멘트 2 -->
				<!-- 여기 위까지@@@ -->	


</body>
</html>