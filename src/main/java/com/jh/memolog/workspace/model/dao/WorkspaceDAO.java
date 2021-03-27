package com.jh.memolog.workspace.model.dao;

import java.util.List;
import java.util.Map;

import com.jh.memolog.member.model.vo.Member;
import com.jh.memolog.page.model.vo.Page;
import com.jh.memolog.workspace.model.vo.Favorites;
import com.jh.memolog.workspace.model.vo.Workspace;
import com.jh.memolog.workspace.model.vo.WorkspaceMember;

public interface WorkspaceDAO {
	
	List<Favorites> selectAllFavorites(String memberId);
	
	List<Workspace> selectWorkspaceList(String memberId);

	List<Workspace> selectWorkspacePageList(String memberId);

	Workspace selectFirstWorkspace(Map<String, Object> param);
	
	Workspace selectOneWorkspace(Map<String, Object> param);

	int insertWorkspace(Workspace workspace);

	List<Page> selectPageList(int workspaceNo);

	int updateWorkspaceCoverColor(Map<String, Object> param);

	int updateWorkspace(Map<String, Object> param);

	int deleteWorkspace(int workspaceNo);

	String selectWorkspaceType(int workspaceNo);

	int insertWorkspaceMember(Map<String, Object> param);

	List<Member> selectNotWsMemberList(int workspaceNo);

	List<WorkspaceMember> selectWsMemberList(int workspaceNo);

	int selectWsMemberCnt(int workspaceNo);

	WorkspaceMember selectOneWsMember(Map<String, Object> param);

	int updateWorkspaceMemberRole(Map<String, Object> param);

	int deleteWorkspaceMember(int workspaceMemberNo);














}
