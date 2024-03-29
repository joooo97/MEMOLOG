package com.jh.memolog.search.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.jh.memolog.page.model.vo.Page;
import com.jh.memolog.page.model.vo.Post;
import com.jh.memolog.page.model.vo.PostComment;
import com.jh.memolog.workspace.model.vo.Workspace;

@Repository
public class SearchDAOImpl implements SearchDAO {
	
	@Autowired
	SqlSessionTemplate sqlSession;

	@Override
	public List<Workspace> selectWsListByKeyword(Map<String, Object> param) {
		return sqlSession.selectList("search.selectWsListByKeyword", param);
	}
	
	@Override
	public List<Page> selectPageListByKeyword(Map<String, Object> param) {
		return sqlSession.selectList("search.selectPageListByKeyword", param);
	}

	@Override
	public List<Post> selectPostListByKeyword(Map<String, Object> param) {
		return sqlSession.selectList("search.selectPostListByKeyword", param);
	}
	
	@Override
	public List<PostComment> selectCommentListByKeyword(Map<String, Object> param) {
		return sqlSession.selectList("search.selectCommentListByKeyword", param);
	}

}
