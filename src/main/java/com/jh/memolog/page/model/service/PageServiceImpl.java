package com.jh.memolog.page.model.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.jh.memolog.page.model.dao.PageDAO;
import com.jh.memolog.page.model.exception.PageException;
import com.jh.memolog.page.model.vo.Page;
import com.jh.memolog.page.model.vo.Post;
import com.jh.memolog.page.model.vo.PostComment;

@Service
public class PageServiceImpl implements PageService {

	private static final Logger logger = LoggerFactory.getLogger(PageService.class);
	
	@Autowired
	PageDAO pageDAO;

	// 페이지 생성 후 생성된 페이지 번호 조회
	@Override
	public int insertPage(Page page) {
		
		// 페이지 생성
		int result = pageDAO.insertPage(page);
		int pageNo;
		
		if(result == 0) {
			throw new PageException("페이지 생성 오류!");
		}
		else {
			// 생성된 페이지 번호
			pageNo = page.getPageNo(); 
		}
		
		return pageNo;
	}

	// 페이지 조회
	@Override
	public Page selectOnePage(Map<String, Object> param) {
		
		Page page = pageDAO.selectOnePage(param);
		
		if(page == null)
			throw new PageException("페이지 조회 오류!");
		
		return page;
	}

	// 페이지 커버 색 변경
	@Override
	public void updatePageCoverColor(Map<String, Object> param) {
		int result = pageDAO.updatePageCoverColor(param);
		
		if(result == 0)
			throw new PageException("페이지 커버 색 변경 오류!");
	}

	// 페이지 수정
	@Override
	public void updatePage(Map<String, Object> param) {
		int result = pageDAO.updatePage(param);
		
		if(result == 0)
			throw new PageException("페이지 수정 오류!");
	}

	// 페이지 삭제
	@Override
	public void deletePage(int pageNo) {
		int result = pageDAO.deletePage(pageNo);
		
		if(result == 0)
			throw new PageException("페이지 삭제 오류!!");
	}

	// 포스트 추가 후 생성된 포스트 번호 조회
	@Override
	public void insertPost(Post post) {
		int result = pageDAO.insertPost(post);
		
		if(result == 0)
			throw new PageException("포스트 추가 오류!");
	}

	// 특정 포스트 조회 (by postNo)
	@Override
	public Post selectOnePost(int postNo) {
		Post post = pageDAO.selectOnePost(postNo);
		
		if(post == null)
			throw new PageException("포스트 조회 오류!");
		
		return post;
	}

	// 특정 페이지의 포스트 리스트 + 포스트별 댓글 수 + 포스트 작성자 이미지 이름 조회 (by pageNo)
	@Override
	public List<Post> selectPostListByPageNo(int pageNo) {
		List<Post> list = pageDAO.selectPostListByPageNo(pageNo);
		
		return list;
	}

	// 포스트 고정 / 고정 해제
	@Override
	public void updatePostPinnedYn(Map<String, Object> param) {
		int result = pageDAO.updatePostPinnedYn(param);
		
		if(result == 0)
			throw new PageException("포스트 고정 / 고정 해제 오류!");
	}

	// 포스트 수정
	@Override
	public void updatePost(Post post) {
		int result = pageDAO.updatePost(post);
		
		if(result == 0)
			throw new PageException("포스트 수정 오류!");
	}

	// 포스트 삭제
	@Override
	public void deletePost(int postNo) {
		int result = pageDAO.deletePost(postNo);
		
		if(result == 0)
			throw new PageException("포스트 삭제 오류!");
	}

	// 포스트 코멘트 리스트 조회
	@Override
	public List<PostComment> selectPostCommentList(int postNo) {
		List<PostComment> list = pageDAO.selectPostCommentList(postNo);
		
		return list;
	}

	// 포스트 코멘트 추가
	@Override
	public void insertPostComment(PostComment postComment) {
		int result = pageDAO.insertPostComment(postComment);
		
		if(result == 0)
			throw new PageException("포스트 코멘트 작성 오류!");
		
	}

	// 포스트 코멘트 삭제
	@Override
	public void deletePostComment(int commentNo) {
		int result = pageDAO.deletePostComment(commentNo);
		
		if(result == 0)
			throw new PageException("포스트 코멘트 삭제 오류!");
	}
	
	// 포스트 코멘트 수정
	@Override
	public void updatePostComment(Map<String, Object> param) {
		int result = pageDAO.updatePostComment(param);
		
		if(result == 0)
			throw new PageException("포스트 코멘트 수정 오류!");
	}

	// 종류별 포스트 리스트 조회
	@Override
	public List<Post> selectPostListBySort(Map<String, Object> param) {
		List<Post> postList = pageDAO.selectPostListBySort(param);
		
		return postList;
	}

	// 페이지 즐겨찾기 추가 후 생성된 즐겨찾기 번호 반환
	@Override
	public int insertPageFavorite(Map<String, Object> param) {
		int result = pageDAO.insertPageFavorite(param);
		int favoritesNo;
		
		if(result == 0)
			throw new PageException("페이지 즐겨찾기 추가 오류!");
		else
			favoritesNo = (int)param.get("favoritesNo");
		
		return favoritesNo;
	}

	// 사용자가 고정한 포스트의 번호 리스트 조회 (공유 워크스페이스 멤버 나가기, 계정 탈퇴 시 사용)
	@Override
	public List<Integer> selectPinnedPostNoList(String memberId) {
		List<Integer> list = pageDAO.selectPinnedPostNoList(memberId);
		
		return list;
	}

	
}
