package com.jh.memolog.page.model.service;

import java.util.List;
import java.util.Map;

import com.jh.memolog.page.model.vo.Page;
import com.jh.memolog.page.model.vo.Post;
import com.jh.memolog.page.model.vo.PostComment;

public interface PageService {

	int insertPage(Page page);

	Page selectOnePage(Map<String, Object> param);

	void updatePageCoverColor(Map<String, Object> param);

	void updatePage(Map<String, Object> param);

	void deletePage(int pageNo);

	void insertPost(Post post);

	Post selectOnePost(int postNo);

	List<Post> selectPostListByPageNo(int pageNo);

	void updatePostPinnedYn(Map<String, Object> param);

	void updatePost(Post post);

	void deletePost(int postNo);

	List<PostComment> selectPostCommentList(int postNo);

	void insertPostComment(PostComment postComment);

	void deletePostComment(int commentNo);

	void updatePostComment(Map<String, Object> param);

	List<Post> selectPostListBySort(Map<String, Object> param);

	int insertPageFavorite(Map<String, Object> param);

	List<Integer> selectPinnedPostNoList(Map<String, Object> param);

	int selectPageNoByFavoritesNo(int favoritesNo);

}
