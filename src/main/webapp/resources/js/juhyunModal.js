$(function(){
	// <상단 메뉴>
	moreMenu(); // 더보기 메뉴 (...) 활성화
	$('.ui.dropdown').dropdown(); // semantic dropdown 활성화
	
	// 워크스페이스 멤버 추가 모달 - 추가 버튼 클릭 시
	$('#modal-addMember div.modal-button').on('click', function(){
		addWsMember();
	});
	
});

// 워크스페이스 멤버보기 모달 열었을 때
$('#modal-viewMember').on('shown.bs.modal', function() {
	viewWsMember();
});

// 워크스페이스 멤버 추가 모달 열었을 때
$('#modal-addMember').on('shown.bs.modal', function() {
	viewAddWsMember();
	$('.ui.dropdown').dropdown();
});


// [함수 영역]

// <상단 메뉴>
// 1. 더보기 메뉴(...)
function moreMenu() {
	$("#btn-more-menu").on("click", function(){
		$("#more-menu-list").toggle();
	});
}


// < 모달 기능 >
// #1. 워크스페이스 멤버 보기 모달
// 1-1. 멤버 검색창에 멤버 옵션 불러오기
function viewWsMember() {
	var select = $("#select-view-member option[id='view-placeholder']");
	
	// 멤버 검색창 초기화
	$('.ui.dropdown.member-search-area').dropdown('clear');
	$("#modal-viewMember option[id!='view-placeholder']").remove();
	
	$.ajax({
		url: contextPath+'/workspace-members/list/'+v_nowWorkspaceNo,
		type: 'GET',
		dataType: 'json',
		success: data => {
			console.log(data);
			
			// 멤버 수 불러오기
			$("#ws-member-cnt").text("워크스페이스 멤버 ["+data.memberCnt+"]");
						
			$.each(data.memberList, (idx, member) => {
				console.log(idx, member);
				
				// 검색창에 멤버 아이디 불러오기
				select.after("<option value="+member.memberId+">"+member.memberName+" ("+member.memberId+")</option>");
			
			});
			
			select.after("<option value='all'>전체선택</option>"); 
			
			wsMemberList(data.memberList); // 1-2. 멤버 리스트 불러오기
			viewMemberAccess(); // 1-3. 권한 라벨 색 지정
		},
		error: (x, s, e) => {
			console.log("워크스페이스 멤버 리스트 불러오기 ajax 요청 실패!", x, s, e);
		}
	});
	
}

// 1-2. 멤버 리스트 불러오기
function wsMemberList(data){
	var divAdmin;
	
	// 멤버리스트 초기화
	$("#view-ws-member-list").html("");
		
	$.each(data, (idx, member) => {
		var commonTag = "<img src="+contextPath+"/resources/images/profile/"+member.profileRenamedFilename+" class='img-writer' alt='멤버 사진' onclick='showProfile(\""+member.memberId+"\");'>"
						+ "<span>"+member.memberName;
		
		// 사용자가 현재 워크스페이스의 관리자일 경우만 멤버 삭제 버튼 띄우기
		if(v_roleCode == 'R1'){
			commonTag += "<i class='delete icon' onclick='deleteWsMember("+member.workspaceMemberNo+");'></i></span>"; 
		} else {
			commonTag += "</span>";
		}
			
		if(member.roleCode == 'R1'){ // 모달에 표시될 워크스페이스 멤버의 권한이 관리자라면
			divAdmin = $("<div class='one-member "+member.workspaceMemberNo+"'></div>");
			
			divAdmin.append("<img src="+contextPath+"/resources/images/profile/"+member.profileRenamedFilename+" class='img-writer' alt='멤버 사진' onclick='showProfile(\""+member.memberId+"\");'>"
							+ "<span>"+member.memberName+"</span>");
			divAdmin.append("<div class='ui red label access'>관리자</div>");
		} 
		else {
			var divMember = $("<div class='one-member m "+member.workspaceMemberNo+"'></div>");
			divMember.append(commonTag);
			
			if(member.roleCode == 'R2'){ // 표시될 멤버가 생성권한이라면
				if(v_roleCode == 'R1'){ // 현재 사용자의 워크스페이스 권한이 관리자일 경우만 멤버 권한 변경 가능
					divMember.append("<button value='R2' class='btn btn-sm dropdown-toggle role-dropdown' data-toggle='dropdown' aria-haspopup='true' aria-expanded='false'>생성 권한</button>"
									+ "<div class='dropdown-menu'><div class='dropdown-item role-select' onclick='changeMemberAccess("+member.workspaceMemberNo+", \"R3\");'>조회 권한</div>"
									+ "<div class='dropdown-item role-select' onclick='changeMemberAccess("+member.workspaceMemberNo+", \"R2\");'>생성 권한</div></div>");
				}
				else{
					divMember.append("<div class='ui blue label access'>생성 권한</div>")
				}
			} 
			else { //조회권한이라면
				if(v_roleCode == 'R1'){ // 현재 사용자의 워크스페이스 권한이 관리자일 경우만 멤버 권한 변경 가능
					divMember.append("<button value='R3' class='btn btn-sm dropdown-toggle role-dropdown' data-toggle='dropdown' aria-haspopup='true' aria-expanded='false'>조회 권한</button>"
							+ "<div class='dropdown-menu'><div class='dropdown-item role-select' onclick='changeMemberAccess("+member.workspaceMemberNo+", \"R3\");'>조회 권한</div>"
							+ "<div class='dropdown-item role-select' onclick='changeMemberAccess("+member.workspaceMemberNo+", \"R2\");'>생성 권한</div></div>");
				}
				else{
					divMember.append("<div class='ui gray label access'>조회 권한</div>")
				}
			}
			$("#view-ws-member-list").append(divMember); // 생성/조회 권한의 멤버들 리스트 띄우기
		}
		
	}); //$.each
	
	$("#view-ws-member-list").prepend(divAdmin); // 관리자 멤버 띄우기
	
}

//1-3. 멤버 권한 조회 & 변경
// 워크스페이스 멤버 권한 조회
function viewMemberAccess() {
	// 사용자 권한 라벨 색 지정
	$("#view-ws-member-list button.role-dropdown").each(function(){
		//권한에 따른 라벨 색 지정
		if($(this).val() == 'R2') { // 생성 권한
			$(this).css('background', '#2185D0').css('color', 'white');
		}
		else { // 조회 권한
			$(this).css('background', '#e4e0e0').css('color', 'rgba(0, 0, 0, 0.6)');
		}
	});
}

// 워크스페이스 멤버 권한 선택
function changeMemberAccess(memberNo, memberAccess) {
	$("div.one-member."+memberNo+" button.role-dropdown").val(memberAccess); // value에 권한코드 저장
	
	if(memberAccess == 'R2') { // 생성 권한
		$("div.one-member."+memberNo+" button.role-dropdown").text("생성 권한");
		$("div.one-member."+memberNo+" button.role-dropdown").css('background', '#2185D0').css('color', 'white');
	}
	else { // 조회 권한
		$("div.one-member."+memberNo+" button.role-dropdown").text("조회 권한");
		$("div.one-member."+memberNo+" button.role-dropdown").css('background', '#e4e0e0').css('color', 'rgba(0, 0, 0, 0.6)');
	}
}

// 1-4. 워크스페이스 멤버 검색
function searchViewMember(memberId){
	if(memberId == '') {
		return;
	} 
	else if(memberId == 'all'){
		viewWsMember();
	} else {
		$.ajax({
			url: contextPath+'/workspace-members/'+v_nowWorkspaceNo+'/'+memberId,
			type: 'GET',
			dataType: 'json',
			success: data => {
				console.log(data);
				
				wsMemberList(data); // 1-2. 멤버리스트 불러오기
				viewMemberAccess(); // 1-3. 멤버 권한 조회
			}, 
			error: (x, s, e) => {
				console.log("워크스페이스 멤버 조회 ajax 처리 실패!", x, s, e);
			}
				
		});
				
	}
}

// 1-5. 워크스페이스 멤버 수정
function updateWorkspaceMember() {

	// jQuery 유틸리티 메서드 - $.each(object, function(index, item){ }); 
	// jQuery 일반 메서드 - $(selector).each(function(index, item){ });
	// 멤버별 권한 수정
	$("#view-ws-member-list div.one-member.m").each(function() {
		// 관리자 멤버 div의 클래스 - one-member.멤버번호
		// 일반 멤버 idv이 클래스 - one-member.m.멤버번호
		var workspaceMemberNo = $(this).attr('class').split(' ')[2]; // 수정할 멤버들의 ws_member 번호 가져오기(관리자 제외)
		var roleCode = $(this).find('button.role-dropdown').val();

		$.ajax({
			url: contextPath+'/workspace-members/'+workspaceMemberNo,
			data: roleCode, // JSON.stringify(roleCode)로 하니 쿼리문에서 role_code = 'R2' 가 아닌 role_code = '"R2"'로 들어가 오류남
			type: 'PUT',
			contentType: "application/json; charset=utf-8",
			success: data => {
				console.log("워크스페이스 멤버 수정 성공");
			},
			error: (x, s, e) => {
				console.log("워크스페이스 멤버 수정 ajax 처리 실패!", x, s, e);
			}
		}); // ajax
	}); // each
	
	alert("워크스페이스 멤버가 수정되었습니다.");
}

// 1-6. 워크스페이스 멤버 삭제
function deleteWsMember(wsMemberNo){
	if(!confirm("정말 삭제하시겠습니까?"))
		return;
	
	$.ajax({
		url: contextPath+"/workspace-members/"+wsMemberNo,
		type: 'DELETE',
		success: data => {
			console.log("워크스페이스 멤버 삭제 ajax 성공");
			
			// 멤버리스트에서 삭제된 멤버 제거
//			$("#view-ws-member-list div.one-member.m."+wsMemberNo+"").remove();
			viewWsMember();
		},
		error: (x, s, e) => {
			console.log("워크스페이스 멤버 삭제 ajax 요청 실패!", x, s, e);
		}
		
	});
}

//#2. 워크스페이스 멤버 추가 모달
//2-1. 모달 열렸을 때 가입된 회원들의 이름 불러오기
function viewAddWsMember() {
	var select = $("#select-add-member option[id='add-placeholder']"); 
	// 멤버 검색창 초기화
	$('.ui.dropdown.member-add-area').dropdown('clear');
	$("#modal-addMember option[id!='add-placeholder']").remove();
	
	// 조회할 워크스페이스에 속하지 않은 회원들 불러오기
	$.ajax({
		url: contextPath+'/not-workspace-members/'+v_nowWorkspaceNo,
		type: 'GET',
		dataType: 'json',
		success: data => {
			console.log(data);
			
			$.each(data, (idx, member) => {
				console.log(idx, member);
				
				select.after("<option value="+member.memberId+">"+member.memberName+" ("+member.memberId+")</option>")
			});
			
		},
		error: (x, s, e) => {
			console.log("워크스페이스 멤버가 아닌 회원 리스트 불러오기 ajax 요청 실패!", x, s, e);
		}
	});
}

// 2-2. 워크스페이스 멤버 추가
function addWsMember(){
	
	// 2-2-1. 선택된 멤버의 아이디 가져오기
	// 선택한 멤버의 이름과 같은 option의 value값(아이디) 가져오기
	var selectedText = $("div.member-add-area div.text").text();
	var selectedValue;
	
	$("#select-add-member").each(function(){
		var selectedOption = $(this).find('option:selected').text().trim();
		
		if(selectedOption == selectedText)
			selectedValue = $(this).val(); // 선택한 멤버의 아이디			
	});
	
	// 2-2-2. 설정할 권한 가져오기
	var selectedAccess = $("#modal-addMember div.access-select div.text").text();
	var access;
	if(selectedAccess == '생성 권한'){
		access = 'R2';
	}
	else {
		access = 'R3';
	}
	
	// 2-2-3. 워크스페이스 멤버 추가하기
	if(selectedValue.length == 0){
		alert("워크스페이스에 추가할 멤버를 선택하지 않으셨습니다.");
	}
	else{
		$.ajax({
			url: contextPath+'/workspace-members/'+v_nowWorkspaceNo,
			type: 'POST',
			data: {memberId: selectedValue, roleCode: access},
			success: data => {
				alert("워크스페이스 멤버가 추가되었습니다.");
				viewAddWsMember();
			},
			error: (x, s, e) => {
				console.log("워크스페이스 멤버 추가 ajax 요청 실패!", x, s, e);
			}
		});
	}

}



// #3, 4 개인/공유 워크스페이스 생성 모달
function createWorkspace(type){
	var privateWorkspaceName = $("#private-workspace input[name='workspaceName']"); 
	var privateWorkspaceDesc = $("#private-workspace input[name='workspaceDesc']");
	var sharedWorkspaceName = $("#shared-workspace input[name='workspaceName']"); 
	var sharedWorkspaceDesc = $("#shared-workspace input[name='workspaceDesc']");
	var workspaceName;
	var workspaceDesc;

	// 개인 워크스페이스인 경우 
	if(type == 'P'){
		workspaceName = privateWorkspaceName.val();
		workspaceDesc = privateWorkspaceDesc.val();
	}
	// 공유 워크스페이스인 경우
	if(type == 'S'){
		workspaceName = sharedWorkspaceName.val();
		workspaceDesc = sharedWorkspaceDesc.val();
	}
	
	if(workspaceName.trim().length == 0){
		alert("워크스페이스명을 입력하지 않으셨습니다.");
	}
	else {
		
		$.ajax({
			url: contextPath+"/workspaces",
			data: {workspaceName: workspaceName, 
				   workspaceDesc: workspaceDesc, 
				   workspaceType: type},
			type: 'POST',
			dataType: 'json',
			success: data => {
				console.log(data);
				
				alert("워크스페이스가 생성되었습니다.");
				location.href = contextPath+"/workspaces/"+data.workspaceNo;
			},
			error: (x, s, e) => {
				console.log("워크스페이스 생성 ajax 요청 실패!", x, s, e);
			}
		});
		
	}
}

// #5. 페이지 생성 모달
function createPage(workspaceNo){
	var pageName = $("#modal-add-page input[name='pageName']").val();
	var pageDesc = $("#modal-add-page input[name='pageDesc']").val();

	if(pageName.trim().length == 0) {
		alert("페이지명을 입력하지 않으셨습니다.");
	}
	else{
		$.ajax({
			url: contextPath+"/pages",
			data: {pageName: pageName,
				   pageDesc: pageDesc,
				   workspaceNo: workspaceNo},
			type: 'POST',
			dataType: 'json',
			success: data => {
				console.log(data);
				
				alert("페이지가 생성되었습니다.");
				location.href = contextPath + "/pages/" + data.pageNo;
			},
			error: (x, s, e) => {
				console.log("페이지 생성 ajax 요청 실패!", x, s, e);
			}
		})
	}
}

// #6. 워크스페이스 수정
function updateWorkspaceAjax(workspaceNo) {
	
	var workspaceName = $("#modal-update-ws input[name='workspaceName']").val();
	var workspaceDesc = $("#modal-update-ws input[name='workspaceDesc']").val();
	var param = {workspaceName: workspaceName,
				 workspaceDesc: workspaceDesc};
	
	if(workspaceName.trim().length == 0){
		alert("워크스페이스명을 입력하지 않으셨습니다.");
	}
	else {
		
		$.ajax({
			url: contextPath+"/workspaces/"+workspaceNo,
			data: JSON.stringify(param),
			type: 'PUT',
			contentType: 'application/json; charset=utf-8',
			success: data => {				
				alert("워크스페이스가 수정되었습니다.");
				location.href = contextPath+"/workspaces/"+workspaceNo;
			},
			error: (x, s, e) => {
				console.log("워크스페이스 수정 ajax 요청 실패!", x, s, e);
			}
		});
		
	}
}

// #7. 페이지 수정 모달
function updatePageAjax(pageNo) {
	var pageName = $("#modal-update-p input[name='pageName']").val();
	var pageDesc = $("#modal-update-p input[name='pageDesc']").val();
	var param = {pageName: pageName, pageDesc: pageDesc};
	
	if(pageName.trim().length == 0) {
		alert("페이지명을 입력하지 않으셨습니다.");
	} else {
		$.ajax({
			url: contextPath+"/pages/"+pageNo,
			data: JSON.stringify(param),
			type: 'PUT',
			contentType: 'application/json; charset=utf-8',
			success: data => {
				alert("페이지가 수정되었습니다.");
				location.href = contextPath+"/pages/"+pageNo;
			},
			error: (x, s, e) => {
				console.log("페이지 수정 ajax 요청 실패!", x, s, e);
			}
		});
	}
}


// #8-1. 첨부파일 포스트 수정 모달
// PutMapping -> 테이블/텍스트는 잘 되지만 파일때문에 415 or nullPoint 에러나서 POST로 변경
function updateFilePost(postNo, fileName) {
	// 파일을 변경하지 않았을 때
	if($("#modal-update-post-P2 .custom-file-label").text() == fileName) {
		viewPostList();
		$("#modal-update-post-P2 button.close").click(); // 모달 닫기
		return;
	}
	else {
		if($("#modal-update-post-P2 input:file").prop('files')[0] === undefined) {
			alert("파일을 선택하지 않으셨습니다.");
			return;
		}
	}
	
	var upFile = $("#modal-update-post-P2 input:file").prop('files')[0];
	var formData = new FormData();
	formData.append('postNo', postNo);
	formData.append('postSortCode', 'P2');
	formData.append('upFile', upFile);
	console.log(formData);
	
	$.ajax({
		url: contextPath+'/pages/'+v_nowPageNo+'/posts/'+postNo,
		type: 'POST',
		data: formData,
		//contentType: 'application/json; charset=utf-8',
		processData: false, // 파일 업로드 ajax 시 필수 속성
		contentType: false, // 파일 업로드 ajax 시 필수 속성
		success: data => {
			console.log("첨부파일 포스트 수정 ajax 성공!");
			$("#modal-update-post-P2 button.close").click(); // 모달 닫기
			
			viewPostList(); // ajax로 모든 포스트 조회
			commentBarAjax(postNo); // 코멘트 바 수정
		},
		error: (x, s, e) => {
			console.log("첨부파일 포스트 수정 ajax 처리 실패!", x, s, e);
		}
	});
	
}


// #8-2, 8-3  텍스트, 테이블 포스트 수정 모달 
function updatePost(postNo, postSortCode) {
	var postContent = $("#modal-update-post-"+postSortCode+" textarea").val().trim();
	var param = {postNo: postNo,
				 postContent: postContent,
				 postSortCode, postSortCode};
	
	if(postContent.length == 0) {
		alert("내용을 입력하지 않으셨습니다.");
		return;
	}
	
	$.ajax({
		url: contextPath+'/pages/'+v_nowPageNo+'/posts/'+postNo,
		type: 'POST',
		data: param,
		success: data => {
			console.log("텍스트/테이블 포스트 수정 ajax 처리 성공!");
			$("#modal-update-post-"+postSortCode+" button.close").click(); // 모달 닫기
			
			viewPostList(); // ajax로 모든 포스트 조회
			commentBarAjax(postNo); // 코멘트 바 수정
		},
		error: (x, s, e) => {
			console.log("텍스트/테이블 포스트 수정 ajax 처리 실패!", x, s, e);
		}
	});

}

// 프로필 띄우기
function showProfile(memberId) {
	// 프로필을 조회할 멤버의 정보 가져오기
	$.ajax({
		url: contextPath+'/members/'+memberId,
		type: 'GET',
		dataType: 'json',
		success: data => {
			console.log(data);
			
			// 프로필 모달에 멤버 정보 띄우기
			// 프로필 이미지
			var profileImage = '<img src="'+contextPath+'/resources/images/profile/'+data.profileRenamedFilename+'">';
			$("#modal-view-profile #profile-image").html(profileImage);
			// 프로필 정보
			$("#modal-view-profile span.profile-id").text(data.memberId);
			$("#modal-view-profile div.profile-name").text(data.memberName);
			$("#modal-view-profile div.profile-email").text(data.email);
			
			// 현재 사용자와 프로필을 조회할 멤버가 동일한 경우만 프로필 변경 버튼 띄우기
			if(v_memberId != memberId) {
				$("#btn-edit-profile").css("display", "none");
			}
			else {
				$("#btn-edit-profile").css("display", "block");
			}
			
			// 모달 띄우기 (수동)
			$("#show-modal-view-profile").click();
		},
		error : (x, s, e) => {
			console.log("프로필 조회를 위한 멤버 정보 불러오기 ajax 요청 실패!", x, s, e);
		}
	});
		
}








