package com.jh.memolog.workspace.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.jh.memolog.member.model.exception.MemberException;
import com.jh.memolog.member.model.vo.Member;
import com.jh.memolog.workspace.model.exception.WorkspaceException;
import com.jh.memolog.workspace.model.service.WorkspaceService;
import com.jh.memolog.workspace.model.vo.Workspace;
import com.jh.memolog.workspace.model.vo.WorkspaceMember;

@RestController
public class WorkspaceRestController {
	
	private static final Logger logger = LoggerFactory.getLogger(WorkspaceRestController.class);
	
	@Autowired
	WorkspaceService workspaceService;
	
	//개인 워크스페이스 생성
	@PostMapping("/workspaces")
	public Map<String, Object> createWorkspace(HttpSession session, Workspace workspace) {
		
		Map<String, Object> map = new HashMap<>();
		Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
		String memberId = memberLoggedIn.getMemberId();
		String workspaceName;
		String workspaceDesc;
		
		try {			
			// xss공격방어
			workspaceName = workspace.getWorkspaceName().replaceAll("<", "&lt;").replaceAll(">", "&gt;");
			workspaceDesc = workspace.getWorkspaceDesc().replaceAll("<", "&lt;").replaceAll(">", "&gt;");
			
			// 생성할 workspace 정보 저장
			workspace.setWorkspaceWriter(memberId);
			workspace.setWorkspaceName(workspaceName);						
			workspace.setWorkspaceDesc(workspaceDesc);
			logger.debug("workspace={}", workspace);
			
			// 워크스페이스 생성 후 워크스페이스 번호 받아오기
			int workspaceNo = workspaceService.insertWorkspace(workspace);
			logger.debug("workspaceNo={}", workspaceNo);
			
			map.put("workspaceNo", workspaceNo);			
			
		} catch(Exception e) {
			logger.error("워크스페이스 생성 오류: ", e);
			throw new WorkspaceException("워크스페이스 생성 오류!", e);
		}
		
		return map;
	}
	
	// 워크스페이스 커버 색 변경
	@PutMapping("/workspaces/{workspaceNo}/cover-color")
	public void updateWorkspaceCoverColor(@PathVariable("workspaceNo") int workspaceNo, @RequestBody String workspaceCoverCode) {
		Map<String, Object> param = new HashMap<>();
		
		try {
			param.put("workspaceNo", workspaceNo);
			param.put("workspaceCoverCode", workspaceCoverCode);
			logger.debug("workspaceNo = {}", workspaceNo);
			logger.debug("workspaceCoverCode = {}", workspaceCoverCode);
			
			workspaceService.updateWorkspaceCoverColor(param);
			
		} catch(Exception e) {
			logger.error("워크스페이스 커버 색 변경 오류: ", e);
			throw new WorkspaceException("워크스페이스 커버 색 변경 오류!", e);
		}
		
	}
	
	// 워크스페이스 수정
	@PutMapping("/workspaces/{workspaceNo}")
	public void updateWorkspace(@PathVariable("workspaceNo") int workspaceNo, @RequestBody Workspace workspace) {
		Map<String, Object> param = new HashMap<>();
		
		try {
			param.put("workspaceNo", workspaceNo);
			param.put("workspaceName", workspace.getWorkspaceName());
			param.put("workspaceDesc", workspace.getWorkspaceDesc());
			logger.debug("workspaceNo={}", workspaceNo);
			logger.debug("workspace={}", workspace);
			
			workspaceService.updateWorkspace(param);
			
		} catch(Exception e) {
			logger.error("워크스페이스 수정 오류: ", e);
			throw new WorkspaceException("워크스페이스 수정 오류!", e);
		}
	}
	
	// 워크스페이스 삭제
	@DeleteMapping("/workspaces/{workspaceNo}")
	public void deleteWorkspace(@PathVariable("workspaceNo") int workspaceNo) {
		try {
			workspaceService.deleteWorkspace(workspaceNo);
		} catch(Exception e) {
			logger.error("워크스페이스 삭제 오류: ", e);
			throw new WorkspaceException("워크스페이스 삭제 오류!", e);
		}
	}
	
	// 워크스페이스 멤버 추가
	@PostMapping("/workspace-members/{workspaceNo}")
	public void insertWorkspaceMmeber(@PathVariable("workspaceNo") int workspaceNo, @RequestParam String roleCode, @RequestParam String memberId) {
		
		Map<String, Object> param = new HashMap<>();
		logger.debug("workspaceNo = {}", workspaceNo);
		
		try {
			// 워크스페이스 타입 가져오기
			String workspaceType = workspaceService.selectWorkspaceType(workspaceNo);
			logger.debug("workspaceType = {}", workspaceType);
			
			// 생성할 워크스페이스 멤버 정보 저장
			param.put("workspaceNo", workspaceNo);
			param.put("memberId", memberId);
			param.put("roleCode", roleCode);
			param.put("workspaceType", workspaceType);
			
			//워크스페이스 멤버 추가
			workspaceService.insertWorkspaceMember(param);
			
		} catch(Exception e) {
			logger.error("워크스페이스 멤버 추가 오류: ", e);
			throw new WorkspaceException("워크스페이스 멤버 추가 오류!", e);
		}
		
	}
	
	// 특정 워크스페이스 멤버가 아닌 회원들 조회
	@GetMapping("/not-workspace-members/{workspaceNo}")
	public List<Member> selectNotWorkspaceMemberList(@PathVariable("workspaceNo") int workspaceNo){
		List<Member> memberList = workspaceService.selectNotWsMemberList(workspaceNo);
			logger.debug("memberList = {}", memberList);
			
		return memberList;
	}

	// 특정 워크스페이스 멤버리스트 조회(by workspaceNo)
	@GetMapping("/workspace-members/list/{workspaceNo}")
	public Map<String, Object> selectWorkspaceMemberList(@PathVariable("workspaceNo") int workspaceNo){
		Map<String, Object> map = new HashMap<>();
		
		// 1. 워크스페이스 멤버리스트
		List<WorkspaceMember> memberList = workspaceService.selectWsMemberList(workspaceNo);
		logger.debug("memberList = {}", memberList);
		// 2. 워크스페이스 멤버 수
		int memberCnt = workspaceService.selectWsMemberCnt(workspaceNo);
		
		map.put("memberList", memberList);
		map.put("memberCnt", memberCnt);
			
		return map;
	}
	
	// 특정 워크스페이스 멤버 조회(by memberId)
	@GetMapping("/workspace-members/{memberId}")
	public Map<String, Object> selectOneWorkspaceMember(@PathVariable("memberId") String memberId, @RequestParam String workspaceNo){
		Map<String, Object> map = new HashMap<>();
		Map<String, Object> param = new HashMap<>();
		
		try{
			param.put("workspaceNo", workspaceNo);
			param.put("memberId", memberId);
			
			//워크스페이스 멤버
			WorkspaceMember wsMember = workspaceService.selectOneWsMember(param);
			
			map.put("member", wsMember);
			
		} catch(Exception e) {
			logger.error("워크스페이스 멤버 조회 오류: ", e);
			throw new MemberException("워크스페이스 멤버 조회 오류!", e);
		}
		
		return map;
	}
	
	// 특정 워크스페이스의 멤버들의 권한 수정
	@PutMapping("/workspace-members/{workspaceMemberNo}")
	public void updateWorkspaceMember(@PathVariable("workspaceMemberNo") int workspaceMemberNo, @RequestBody String roleCode) {
		Map<String, Object> param = new HashMap<>();
		
		logger.debug("workspaceMemberNo = {}", workspaceMemberNo);
		logger.debug("roleCode = {}", roleCode);
		
		try {
			param.put("workspaceMemberNo", workspaceMemberNo);
			param.put("roleCode", roleCode);
			
			// 워크스페이스 멤버 권한 수정
			workspaceService.updateWorkspaceMemberRole(param);
			
		} catch(Exception e) {
			logger.error("워크스페이스 멤버 권한 수정 오류: ", e);
			throw new WorkspaceException("워크스페이스 멤버 권한 수정 오류!", e);
		}
	}
	
	// 특정 워크스페이스 멤버 삭제
	@DeleteMapping("/workspace-members/{workspaceMemberNo}")
	public void DeleteWorkspaceMember(@PathVariable("workspaceMemberNo") int workspaceMemberNo) {
		try {
			workspaceService.deleteWorkspaceMember(workspaceMemberNo);
		} catch(Exception e) {
			logger.error("워크스페이스 멤버 삭제 오류: ", e);
			throw new WorkspaceException("워크스페이스 삭제 오류!", e);
		}
	}


}