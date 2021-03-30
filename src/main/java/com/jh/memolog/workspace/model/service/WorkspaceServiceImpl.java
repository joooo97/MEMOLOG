package com.jh.memolog.workspace.model.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.jh.memolog.member.model.vo.Member;
import com.jh.memolog.page.model.vo.Page;
import com.jh.memolog.workspace.model.dao.WorkspaceDAO;
import com.jh.memolog.workspace.model.exception.WorkspaceException;
import com.jh.memolog.workspace.model.vo.Favorites;
import com.jh.memolog.workspace.model.vo.Workspace;
import com.jh.memolog.workspace.model.vo.WorkspaceMember;

@Service
public class WorkspaceServiceImpl implements WorkspaceService {
	
	private static final Logger logger = LoggerFactory.getLogger(WorkspaceServiceImpl.class);

	@Autowired
	WorkspaceDAO workspaceDAO;
	
	// 즐겨찾기 리스트 조회
	@Override
	public List<Favorites> selectAllFavorites(String memberId) {
		List<Favorites> list = workspaceDAO.selectAllFavorites(memberId);
		
		return list;
	}
	
	// 워크스페이스 리스트 + 사용자 권한 조회
	@Override
	public List<Workspace> selectWorkspaceList(String memberId) {
		List<Workspace> list = workspaceDAO.selectWorkspaceList(memberId);
		
		return list;
	}

	// 워크스페이스 + 페이지 리스트 + 사용자 권한 조회
	@Override
	public List<Workspace> selectWorkspacePageList(String memberId) {
		List<Workspace> list = workspaceDAO.selectWorkspacePageList(memberId);
		
		return list;
	}
	
	// 처음으로 생성된 워크스페이스  조회
	@Override
	public Workspace selectFirstWorkspace(Map<String, Object> param) {
		
		Workspace workspace = workspaceDAO.selectFirstWorkspace(param);
		
		return workspace;
	}

	// 특정 워크스페이스 조회
	@Override
	public Workspace selectOneWorkspace(Map<String, Object> param) {
		Workspace workspace = workspaceDAO.selectOneWorkspace(param);
		
		return workspace;
	}

	// 워크스페이스 생성
	@Override
	public int insertWorkspace(Workspace workspace) {
		
		// 워크스페이스 생성
		int result = workspaceDAO.insertWorkspace(workspace);
		int workspaceNo;
		
		if(result == 0) {
			throw new WorkspaceException("워크스페이스 생성 오류!");
		} 
		else {
			// 생성된 워크스페이스 번호
			workspaceNo = workspace.getWorkspaceNo();
		}
		
		return workspaceNo;
	}

	// 특정 워크스페이스의 페이지 리스트 조회
	@Override
	public List<Page> selectPageList(int workspaceNo) {
		List<Page> list = workspaceDAO.selectPageList(workspaceNo);
		
		return list;
	}

	// 워크스페이스 커버 색 변경
	@Override
	public void updateWorkspaceCoverColor(Map<String, Object> param) {
		int result = workspaceDAO.updateWorkspaceCoverColor(param);
		
		if(result == 0)
			throw new WorkspaceException("워크스페이스 커버 색 변경 오류!");

	}

	// 워크스페이스 수정
	@Override
	public void updateWorkspace(Map<String, Object> param) {
		int result = workspaceDAO.updateWorkspace(param);
		
		if(result == 0)
			throw new WorkspaceException("워크스페이스 수정 오류!");
	}

	// 워크스페이스 삭제
	@Override
	public void deleteWorkspace(int workspaceNo) {
		int result = workspaceDAO.deleteWorkspace(workspaceNo);
		
		if(result == 0)
			throw new WorkspaceException("워크스페이스 삭제 오류!");
	}

	// 워크스페이스 타입 조회
	@Override
	public String selectWorkspaceType(int workspaceNo) {
		String type = workspaceDAO.selectWorkspaceType(workspaceNo);
		
		if(type == null)
			throw new WorkspaceException("워크스페이스 타입 조회 오류!");
		
		return type;
	}

	// 워크스페이스 멤버 추가
	@Override
	public void insertWorkspaceMember(Map<String, Object> param) {
		int result = workspaceDAO.insertWorkspaceMember(param);
		
		if(result == 0)
			throw new WorkspaceException("워크스페이스 멤버 추가 오류!");
	}
	
	// 특정 워크스페이스의 멤버가 아닌 회원 리스트 조회
	@Override
	public List<Member> selectNotWsMemberList(int workspaceNo) {
		List<Member> list = workspaceDAO.selectNotWsMemberList(workspaceNo);
		
		return list;
	}

	// 특정 워크스페이스의 멤버 리스트 조회
	@Override
	public List<WorkspaceMember> selectWsMemberList(int workspaceNo) {
		List<WorkspaceMember> list = workspaceDAO.selectWsMemberList(workspaceNo);
		
		return list;
	}
	
	// 특정 워크스페이스의 멤버 수 조회
	@Override
	public int selectWsMemberCnt(int workspaceNo) {
		int cnt = workspaceDAO.selectWsMemberCnt(workspaceNo);
		
		return cnt;
	}

	// 특정 워크스페이스의 한 멤버 조회
	@Override
	public WorkspaceMember selectOneWsMember(Map<String, Object> param) {
		WorkspaceMember member = workspaceDAO.selectOneWsMember(param);
		
		if(member == null)
			throw new WorkspaceException("특정 워크스페이스의 한 멤버 조회 오류!");
		
		return member;
	}

	// 특정 워크스페이스의 멤버들의 권한 수정
	@Override
	public void updateWorkspaceMemberRole(Map<String, Object> param) {
		int result = workspaceDAO.updateWorkspaceMemberRole(param);
		
		if(result == 0)
			throw new WorkspaceException("워크스페이스 멤버 권한 수정 오류!");
	}

	// 특정 워크스페이스 멤버 삭제
	@Override
	public void deleteWorkspaceMember(int workspaceMemberNo) {
		int result = workspaceDAO.deleteWorkspaceMember(workspaceMemberNo);
		
		if(result == 0)
			throw new WorkspaceException("워크스페이스 멤버 삭제 오류!");
	}

	// 워크스페이스 및 페이지 즐겨찾기 해제
	@Override
	public void deleteFavorite(int favoritesNo) {
		int result = workspaceDAO.deleteFavorite(favoritesNo);
		
		if(result == 0)
			throw new WorkspaceException("워크스페이스 및 페이지 즐겨찾기 해제 오류!");
	}

	// 워크스페이스 즐겨찾기 추가
	@Override
	public int insertWsFavorite(Map<String, Object> param) {
		int result = workspaceDAO.insertWsFavorite(param);
		int favoritesNo;
		
		if(result == 0)
			throw new WorkspaceException("워크스페이스 즐겨찾기 추가 오류!");
		else
			favoritesNo = (int)param.get("favoritesNo");
		
		return favoritesNo;
	}




}
