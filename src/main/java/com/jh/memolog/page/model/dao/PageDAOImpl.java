package com.jh.memolog.page.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.jh.memolog.page.model.vo.Page;
import com.jh.memolog.page.model.vo.Post;
import com.jh.memolog.page.model.vo.PostComment;

@Repository
public class PageDAOImpl implements PageDAO {

	@Autowired
	SqlSessionTemplate sqlSession;

	@Override
	public int insertPage(Page page) {
		return sqlSession.insert("page.insertPage", page);
	}

	@Override
	public Page selectOnePage(Map<String, Object> param) {
		return sqlSession.selectOne("page.selectOnePage", param);
	}

	@Override
	public int updatePageCoverColor(Map<String, Object> param) {
		return sqlSession.update("page.updatePageCoverColor", param);
	}

	@Override
	public int updatePage(Map<String, Object> param) {
		return sqlSession.update("page.updatePage", param);
	}

	@Override
	public int deletePage(int pageNo) {
		return sqlSession.delete("page.deletePage", pageNo);
	}

	@Override
	public int insertPost(Post post) {
		return sqlSession.insert("page.insertPost", post);
	}

	@Override
	public Post selectOnePost(int postNo) {
		return sqlSession.selectOne("page.selectOnePost", postNo);
	}

	@Override
	public List<Post> selectPostListByPageNo(int pageNo) {
		return sqlSession.selectList("page.selectPostListByPageNo", pageNo);
	}

	@Override
	public int updatePostPinnedYn(Map<String, Object> param) {
		return sqlSession.update("page.updatePostPinnedYn", param);
	}
	
	@Override
	public int updatePost(Post post) {
		return sqlSession.update("page.updatePost", post);
	}

	@Override
	public int deletePost(int postNo) {
		return sqlSession.delete("page.deletePost", postNo);
	}

	@Override
	public List<PostComment> selectPostCommentList(int postNo) {
		return sqlSession.selectList("page.selectPostCommentList", postNo);
	}

	@Override
	public int insertPostComment(PostComment postComment) {
		return sqlSession.insert("page.insertPostComment", postComment);
	}
	
	@Override
	public int deletePostComment(int commentNo) {
		return sqlSession.delete("page.deletePostComment", commentNo);
	}
	
	@Override
	public int updatePostComment(Map<String, Object> param) {
		return sqlSession.update("page.updatePostComment", param);
	}

	@Override
	public List<Post> selectPostListBySort(Map<String, Object> param) {
		return sqlSession.selectList("page.selectPostListBySort", param);
	}
}
