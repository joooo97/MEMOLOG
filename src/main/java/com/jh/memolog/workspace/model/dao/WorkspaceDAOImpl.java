package com.jh.memolog.workspace.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.jh.memolog.member.model.vo.Member;
import com.jh.memolog.page.model.vo.Page;
import com.jh.memolog.workspace.model.vo.Favorites;
import com.jh.memolog.workspace.model.vo.Workspace;
import com.jh.memolog.workspace.model.vo.WorkspaceMember;

@Repository
public class WorkspaceDAOImpl implements WorkspaceDAO {

	@Autowired
	SqlSessionTemplate sqlSession;
	
	@Override
	public List<Favorites> selectAllFavorites(String memberId) {
		return sqlSession.selectList("workspace.selectAllFavorites", memberId);
	}
	
	@Override
	public List<Workspace> selectWorkspaceList(String memberId) {
		return sqlSession.selectList("workspace.selectWorkspaceList", memberId);
	}

	@Override
	public List<Workspace> selectWorkspacePageList(String memberId) {
		return sqlSession.selectList("workspace.selectWorkspacePageList", memberId);
	}
	
	@Override
	public Workspace selectFirstWorkspace(Map<String, Object> param) {
		return sqlSession.selectOne("workspace.selectFirstWorkspace", param);
	}

	@Override
	public Workspace selectOneWorkspace(Map<String, Object> param) {
		return sqlSession.selectOne("workspace.selectOneWorkspace", param);
	}

	@Override
	public int insertWorkspace(Workspace workspace) {
		return sqlSession.insert("workspace.insertWorkspace", workspace);
	}

	@Override
	public List<Page> selectPageList(int workspaceNo) {
		return sqlSession.selectList("workspace.selectPageList", workspaceNo);
	}

	@Override
	public int updateWorkspaceCoverColor(Map<String, Object> param) {
		return sqlSession.update("workspace.updateWorkspaceCoverColor", param);
	}

	@Override
	public int updateWorkspace(Map<String, Object> param) {
		return sqlSession.update("workspace.updateWorkspace", param);
	}

	@Override
	public int deleteWorkspace(int workspaceNo) {
		return sqlSession.delete("workspace.deleteWorkspace", workspaceNo);
	}

	@Override
	public String selectWorkspaceType(int workspaceNo) {
		return sqlSession.selectOne("workspace.selectWorkspaceType", workspaceNo);
	}

	@Override
	public int insertWorkspaceMember(Map<String, Object> param) {
		return sqlSession.insert("workspace.insertWorkspaceMember", param);
	}
	
	@Override
	public List<Member> selectNotWsMemberList(int workspaceNo) {
		return sqlSession.selectList("workspace.selectNotWsMemberList", workspaceNo);
	}
	
	@Override
	public List<WorkspaceMember> selectWsMemberList(int workspaceNo) {
		return sqlSession.selectList("workspace.selectWsMemberList", workspaceNo);
	}

	@Override
	public int selectWsMemberCnt(int workspaceNo) {
		return sqlSession.selectOne("workspace.selectWsMemberCnt", workspaceNo);
	}

	@Override
	public WorkspaceMember selectOneWsMember(Map<String, Object> param) {
		return sqlSession.selectOne("workspace.selectOneWsMember", param);
	}

	@Override
	public int updateWorkspaceMemberRole(Map<String, Object> param) {
		return sqlSession.update("workspace.updateWorkspaceMemberRole", param);
	}

	@Override
	public int deleteWorkspaceMember(int workspaceMemberNo) {
		return sqlSession.delete("workspace.deleteWorkspaceMember", workspaceMemberNo);
	}

	@Override
	public int deleteFavorite(int favoritesNo) {
		return sqlSession.delete("workspace.deleteFavorite", favoritesNo);
	}

	@Override
	public int insertWsFavorite(Map<String, Object> param) {
		return sqlSession.insert("workspace.insertWsFavorite", param);
	}


}
