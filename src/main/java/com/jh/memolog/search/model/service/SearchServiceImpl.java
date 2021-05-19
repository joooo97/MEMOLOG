package com.jh.memolog.search.model.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.jh.memolog.search.model.dao.SearchDAO;
import com.jh.memolog.search.model.exception.SearchException;
import com.jh.memolog.workspace.model.vo.Workspace;

@Service
public class SearchServiceImpl implements SearchService {
	
	private static final Logger logger = LoggerFactory.getLogger(SearchServiceImpl.class);
	
	@Autowired
	SearchDAO searchDAO;

	@Override
	public List<Workspace> selectWsListByKeyword(Map<String, Object> param) {
		List<Workspace> list = searchDAO.selectWsListByKeyword(param);
		logger.debug("serviceImpl@wsList = {}", list);
		
		if(list == null)
			throw new SearchException("워크스페이스명 검색 오류!");
		
		return list;
	}

}
