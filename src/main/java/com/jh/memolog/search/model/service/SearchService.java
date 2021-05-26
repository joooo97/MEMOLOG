package com.jh.memolog.search.model.service;

import java.util.List;
import java.util.Map;

import com.jh.memolog.page.model.vo.Page;
import com.jh.memolog.page.model.vo.Post;
import com.jh.memolog.page.model.vo.PostComment;
import com.jh.memolog.workspace.model.vo.Workspace;

public interface SearchService {

	List<Workspace> selectWsListByKeyword(Map<String, Object> param);

	List<Page> selectPageListByKeyword(Map<String, Object> param);

	List<Post> selectPostListByKeyword(Map<String, Object> param);

	List<PostComment> selectCommentListByKeyword(Map<String, Object> param);

}
