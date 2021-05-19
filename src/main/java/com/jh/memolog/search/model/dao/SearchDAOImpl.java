package com.jh.memolog.search.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.jh.memolog.workspace.model.vo.Workspace;

@Repository
public class SearchDAOImpl implements SearchDAO {
	
	@Autowired
	SqlSessionTemplate sqlSession;

	@Override
	public List<Workspace> selectWsListByKeyword(Map<String, Object> param) {
		return sqlSession.selectList("search.selectWsListByKeyword", param);
	}

}
