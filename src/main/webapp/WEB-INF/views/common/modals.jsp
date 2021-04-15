<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 

<script>
var contextPath = "${pageContext.request.contextPath}"; //contextPath 전역변수 (juhyunModal.js파일에서 사용)
var v_workspaceNo; // 특정 워크스페이스 번호 전역변수 (페이지 생성, 워크스페이스 수정 시 - leftSideBar.jsp/modal.jsp)
var v_pageNo; // 특정 페이지 번호 전역변수 (페이지 수정 시 - leftSideBar.jsp/modal.jsp)
var v_nowWorkspaceNo; // 현재 조회하고 있는 워크스페이스 번호
var v_roleCode; // 현재 조회하고 있는 워크스페이스/페이지 내의 사용자 권한
var v_memberId = "${memberLoggedIn.memberId}"; // juhyunModal.js 파일에서 사용

// 현재 워크스페이스를 조회하고 있다면
if("${workspace}" != "") {
	v_nowWorkspaceNo = "${workspace.workspaceNo}";
	v_roleCode = "${workspace.roleCode}";
}
// 페이지를 조회하고 있다면
if("${page}" != "") {
	v_nowWorkspaceNo = "${page.workspaceNo}"; 	
	v_roleCode = "${page.roleCode}";
}


</script>
    

<!-- 모달 모음 -->
		<!-- #1. 멤버 보기 모달 -->
		<div class="modal fade" id="modal-viewMember">
			<div class="modal-dialog modal-dialog-scrollable">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title" id="ws-member-cnt"></h4>
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<select class="ui search dropdown member-search-area" id="select-view-member" onchange="searchViewMember(this.value);">
						<option value="" id="view-placeholder">워크스페이스 멤버 검색</option>
					</select>
					
					<div class="modal-body" id="view-ws-member-list"></div>
					<!-- /.modal-body -->
					<div class="modal-footer">
						<c:if test="${workspace.roleCode == 'R1' || page.roleCode == 'R1'}">
							<div class="modal-button" onclick="updateWorkspaceMember();">수정</div>
						</c:if>
					</div>
				</div>
			</div>
		</div>

		<!-- #2. 멤버 추가 모달 -->
		<div class="modal fade" id="modal-addMember">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title">워크스페이스 멤버 추가</h4>
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body">
							<select class="ui search dropdown member-add-area" id="select-add-member">
								<option value="" id="add-placeholder">멤버 선택 (이름 또는 아이디)</option>
							</select>
							<select class="ui dropdown access-select">
								<option>조회 권한</option>
								<option selected>생성 권한</option>
							</select>
					</div>
					<div class="modal-footer">
						<div class="modal-button">추가</div>
					</div>
					<!-- /.modal-body -->
				</div>
			</div>
		</div>

		<!-- #3. 개인 워크스페이스 생성 모달 -->
		<div class="modal fade" id="modal-add-p-ws">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title">개인 워크스페이스 생성</h4>
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<form>
						<div class="modal-body" id="private-workspace">
							<div class="name">
								<div>워크스페이스명</div>
								<input type="text" name="workspaceName" required>
							</div>
							<div class="description">
								<div>워크스페이스 설명 (선택 사항)</div>
								<input type="text" name="workspaceDesc">
							</div>
						</div>
						<!-- /.modal-body -->
						<div class="modal-footer">
							<button type="button" class="modal-button" onclick="createWorkspace('P');">생성</button>
						</div>
					</form>
				</div>
			</div>
		</div>

		<!-- #4. 공유 워크스페이스 생성 모달 -->
		<div class="modal fade" id="modal-add-s-ws">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title">공유 워크스페이스 생성</h4>
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body" id="shared-workspace">
						<div class="name">
							<div>워크스페이스명</div>
							<input type="text" name="workspaceName">
						</div>
						<div class="description">
							<div>워크스페이스 설명 (선택 사항)</div>
							<input type="text" name="workspaceDesc">
						</div>
					</div>
					<!-- /.modal-body -->
					<div class="modal-footer">
						<div class="modal-button" onclick="createWorkspace('S')">생성</div>
					</div>
				</div>
			</div>
		</div>

		<!-- #5. 페이지 생성 모달 -->
		<div class="modal fade" id="modal-add-page">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title">페이지 생성</h4>
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body">
						<div class="name">
							<div>페이지명</div>
							<input type="text" name="pageName">
						</div>
						<div class="description">
							<div>페이지 설명 (선택 사항)</div>
							<input type="text" name="pageDesc">
						</div>
					</div>
					<!-- /.modal-body -->
					<div class="modal-footer">
						<div class="modal-button" onclick="createPage(v_workspaceNo);">생성</div>
					</div>
				</div>
			</div>
		</div>

		<!-- #6. 워크스페이스 수정 모달 -->
		<div class="modal fade" id="modal-update-ws">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title">워크스페이스 수정</h4>
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body">
						<div class="name">
							<div>워크스페이스명</div>
							<input type="text" name="workspaceName">
						</div>
						<div class="description">
							<div>워크스페이스 설명</div>
							<input type="text" name="workspaceDesc">
						</div>
					</div>
					<!-- /.modal-body -->
					<div class="modal-footer">
						<div class="modal-button" onclick="updateWorkspaceAjax(v_workspaceNo);">수정</div>
					</div>
				</div>
			</div>
		</div>

		<!-- #7. 페이지 수정 모달 -->
		<div class="modal fade" id="modal-update-p">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title">페이지 수정</h4>
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body">
						<div class="name">
							<div>페이지명</div>
							<input type="text" name="pageName">
						</div>
						<div class="description">
							<div>페이지 설명</div>
							<input type="text" name="pageDesc">
						</div>
					</div>
					<!-- /.modal-body -->
					<div class="modal-footer">
						<div class="modal-button" onclick="updatePageAjax(v_pageNo);">수정</div>
					</div>
				</div>
			</div>
		</div>

		<!-- #8-1. 포스트 수정 모달 (첨부파일) -->
		<div class="modal fade" id="modal-update-post-P2">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title">포스트 수정</h4>
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body">
						<div class="name">
							<div>첨부파일</div>
							<div class="input-group">
								<div class="custom-file">
								  <input type="file" class="custom-file-input" id="inputGroupFile04" aria-describedby="inputGroupFileAddon04">
								  <label class="custom-file-label" for="inputGroupFile04">Choose file</label>
								</div>
							</div>
						</div>
					</div>
					<!-- /.modal-body -->
					<div class="modal-footer">
						<div class="modal-button" onclick="updateFilePost(v_nowPostNo, v_fileName);">수정</div>
					</div>
				</div>
			</div>
		</div>
		<!-- #8-2 포스트 수정 모달 (텍스트) -->
		<div class="modal fade" id="modal-update-post-P1">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title">포스트 수정</h4>
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body">
						<div class="name">
							<div>텍스트</div>
							<textarea class="text-summernote summernote" name="editordata"></textarea>
						</div>
					</div>
					<!-- /.modal-body -->
					<div class="modal-footer">
						<div class="modal-button" onclick="updatePost(v_nowPostNo, 'P1')">수정</div>
					</div>
				</div>
			</div>
		</div>
		<!-- #8-3 포스트 수정 모달 (테이블) -->
		<div class="modal fade" id="modal-update-post-P3">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title">포스트 수정</h4>
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body">
						<div class="name">
							<div>테이블</div>
							<textarea class="table-summernote summernote" name="editordata"></textarea>
						</div>
					</div>
					<!-- /.modal-body -->
					<div class="modal-footer">
						<div class="modal-button" onclick="updatePost(v_nowPostNo, 'P3')">수정</div>
					</div>
				</div>
			</div>
		</div>

		<!-- #9. 프로필 보기 모달 -->
 		<div class="modal fade" id="modal-view-profile">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="ui card modal-body">
						<i id="btn-close-profile" class="fas fa-times" data-dismiss="modal"></i>
						<div id="profile-image"></div>
						<div class="content">
							<span class="header profile-id"></span>
							<div class="meta">
								<div class="profile-name"></div>
								<div class="profile-email"></div>
							</div>
						</div>
						<div class="extra">
							<div id="btn-edit-profile" onclick="location.href='${pageContext.request.contextPath}/account'">프로필 변경</div>
						</div>
					</div> <!-- /.modal-body -->
				</div>
			</div>
		</div>


