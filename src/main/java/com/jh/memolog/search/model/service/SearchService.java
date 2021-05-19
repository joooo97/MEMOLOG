package com.jh.memolog.search.model.service;

import java.util.List;
import java.util.Map;

import com.jh.memolog.workspace.model.vo.Workspace;

public interface SearchService {

	List<Workspace> selectWsListByKeyword(Map<String, Object> param);

}
