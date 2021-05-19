package com.jh.memolog.search.model.dao;

import java.util.List;
import java.util.Map;

import com.jh.memolog.page.model.vo.Page;
import com.jh.memolog.workspace.model.vo.Workspace;

public interface SearchDAO {

	List<Workspace> selectWsListByKeyword(Map<String, Object> param);

	List<Page> selectPageListByKeyword(Map<String, Object> param);

}
