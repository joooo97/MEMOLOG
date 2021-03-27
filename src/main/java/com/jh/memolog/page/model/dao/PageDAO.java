package com.jh.memolog.page.model.dao;

import java.util.List;
import java.util.Map;

import com.jh.memolog.page.model.vo.Page;
import com.jh.memolog.page.model.vo.Post;
import com.jh.memolog.page.model.vo.PostComment;

public interface PageDAO {

	int insertPage(Page page);

	Page selectOnePage(Map<String, Object> param);

	int updatePageCoverColor(Map<String, Object> param);

	int updatePage(Map<String, Object> param);

	int deletePage(int pageNo);

	int insertPost(Post post);

	Post selectOnePost(int postNo);

	List<Post> selectPostListByPageNo(int pageNo);

	int updatePostPinnedYn(Map<String, Object> param);

	int updatePost(Post post);

	int deletePost(int postNo);

	List<PostComment> selectPostCommentList(int postNo);

	int insertPostComment(PostComment postComment);

	int deletePostComment(int commentNo);

	int updatePostComment(Map<String, Object> param);

	List<Post> selectPostListBySort(Map<String, Object> param);

}
