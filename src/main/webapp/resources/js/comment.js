var v_commentLevel = 1; // 코멘트 레벨 1로 초기화 &5
var v_commentRefNo; // 코멘트 참조 번호
var v_commentRefWriter; // 참조 코멘트 작성자
var v_updateCommentNo; // 댓글 수정 시 수정할 댓글 번호 저장

$(function() {
	commentSummernoteSetting(); // 댓글 summernote 설정
	
	// 코멘트 사이드바 닫기 버튼 클릭 시 &1
	$("#btn-close-comments").on('click', function() {
		$('#comments-bar').sidebar('setting', 'transition', 'overlay').sidebar('hide');
	});
	
	// 댓글 작성 버튼 클릭 시 &2
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
	
});

function commentSummernoteSetting() {
	// &3 -1
	// 1. 댓글 툴바
	var commentToolbar = [
		['font', ['bold', 'underline', 'strikethrough']],
	];
	
	// &3-2
	$('.comment-summernote').summernote({
		toolbar: commentToolbar,
		lang: "ko-KR",
		height: 70,
		placeholder: '코멘트 입력',
		codeviewFilter: false,				//XSS 보호
			codeviewIframeFilter: true
	});
	
	// 2. 전송, 닫기 버튼 추가
	var submitButton = '<div class="btn-submit-summernote" type="button"><i class="paper plane icon"></i></div>';
	var closeButton = '<div class="btn-close-post-form"><i class="fas fa-times"></i></div>';
	$("#comment-summernote-area .note-toolbar").append(submitButton); // &3-3
	
}

// 5-1. 포스트 코멘트 바 열기 &4-1
function openCommentBar(postNo) {
	v_nowPostNo = postNo; // 댓글 작성을 위해 현재 포스트 번호 저장
	$('#comments-bar').sidebar('setting', 'transition', 'overlay').sidebar('show'); // 코멘트 바 열기
	
	commentBarAjax(postNo);
}

// 5-2. 포스트 코멘트 바 내용 띄우기 &4-2
function commentBarAjax(postNo) {
	$.ajax({
		url: contextPath+'/pages/'+v_nowPageNo+'/posts/'+postNo+'/post-comments',
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
				 $("#commentBar-post-writer a.avatar").html("<img src='"+contextPath+"/resources/images/profile/default.jpg' class='img-writer' onclick='showProfile(\""+data.post.postWriter+"\");'>");
			 else
				 $("#commentBar-post-writer a.avatar").html("<img src='"+contextPath+"/resources/upload/profile/"+data.post.postWriter+"/"+data.post.profileRenamedFilename+"' class='img-writer' onclick='showProfile(\""+data.post.postWriter+"\");'>");
			 
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
						$("#comment-content").html("<img src='"+contextPath+"/resources/upload/page/"+data.post.pageNo+"/"+data.post.postRenamedFilename+"'>");
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
							 comment_1 += "<img src='"+contextPath+"/resources/images/profile/default.jpg' class='img-writer' onclick='showProfile(\""+comment.postCommentWriter+"\");'></a>";
						 }
						 else {
							 comment_1 += "<img src='"+contextPath+"/resources/upload/profile/"+comment.postCommentWriter+"/"+comment.profileRenamedFilename+"' class='img-writer' onclick='showProfile(\""+comment.postCommentWriter+"\");'></a>";
						 }
						 
						 comment_1 += "<div class='content'><a class='writer-id'>"+comment.postCommentWriter+"</a>"
					  		   + "<div class='metadata'><span class='date'>"+comment.postCommentDate+"</span><a class='reply' onclick='viewReply(2, "+comment.postCommentNo+", \""+comment.postCommentWriter+"\")'>답글</a></div>";
					  			   
					 // 코멘트 작성자일 경우 코멘트 관리 버튼(수정, 삭제) 띄우기
					 if(v_memberId == comment.postCommentWriter){
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
							 comment_2 += "<img src='"+contextPath+"/resources/images/profile/default.jpg' class='img-writer' onclick='showProfile(\""+comment.postCommentWriter+"\");'></a>";
						 }
						 else {
							 comment_2 += "<img src='"+contextPath+"/resources/upload/profile/"+comment.postCommentWriter+"/"+comment.profileRenamedFilename+"' class='img-writer' onclick='showProfile(\""+comment.postCommentWriter+"\");'></a>";
						 }
					 
					 comment_2 += "<div class='content'><a class='writer-id'>"+comment.postCommentWriter+"</a>"
					 		   + "<div class='metadata'><span class='date'>"+comment.postCommentDate+"</span>"
					 		   + "<a class='reply' onclick='viewReply(3, "+comment.postCommentRef+", \""+comment.postCommentWriter+"\")'>답글</a></div>";
					 
					 // 코멘트 작성자일 경우 코멘트 관리 버튼(수정, 삭제) 띄우기
					 if(v_memberId == comment.postCommentWriter){
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
							 comment_3 += "<img src='"+contextPath+"/resources/images/profile/default.jpg' class='img-writer' onclick='showProfile(\""+comment.postCommentWriter+"\");'></a>";
						 }
						 else {
							 comment_3 += "<img src='"+contextPath+"/resources/upload/profile/"+comment.postCommentWriter+"/"+comment.profileRenamedFilename+"' class='img-writer' onclick='showProfile(\""+comment.postCommentWriter+"\");'></a>";
						 }
					 
						 comment_3 += "<div class='content'><a class='writer-id'>"+comment.postCommentWriter+"</a>"
					 		   + "<div class='metadata'><span class='date'>"+comment.postCommentDate+"</span>"
					 		   + "<a class='reply' onclick='viewReply(3, "+comment.postCommentRef+", \""+comment.postCommentWriter+"\")'>답글</a></div>";
					 			   
					 // 코멘트 작성자일 경우 코멘트 관리 버튼(수정, 삭제) 띄우기
					 if(v_memberId == comment.postCommentWriter){
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

// 5-3. 답글 클릭 시 답글 대상 표시 &4-3
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
			url: contextPath+'/pages/'+v_nowPageNo+'/posts/'+v_nowPostNo+'/post-comments',
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
		url: contextPath+'/pages/'+v_nowPageNo+'/posts/'+v_nowPostNo+'/post-comments/'+commentNo,
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
				url: contextPath+'/pages/'+v_nowPageNo+'/posts/'+v_nowPostNo+'/post-comments/'+v_updateCommentNo,
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