package com.jh.memolog.search.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.servlet.ModelAndView;

import com.jh.memolog.member.model.vo.Member;
import com.jh.memolog.page.model.vo.Page;
import com.jh.memolog.page.model.vo.Post;
import com.jh.memolog.page.model.vo.PostComment;
import com.jh.memolog.search.model.service.SearchService;
import com.jh.memolog.workspace.model.exception.WorkspaceException;
import com.jh.memolog.workspace.model.service.WorkspaceService;
import com.jh.memolog.workspace.model.vo.Favorites;
import com.jh.memolog.workspace.model.vo.Workspace;

@Controller
public class SearchController {
	
	private static final Logger logger = LoggerFactory.getLogger(SearchController.class);
	
	@Autowired
	SearchService searchService;
	
	@Autowired
	WorkspaceService workspaceService;
	
	@GetMapping("/search/{keyword}")
	public ModelAndView search(ModelAndView mav, HttpSession session, @PathVariable("keyword") String keyword) {
		Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
		String memberId = memberLoggedIn.getMemberId();
		
		Map<String, Object> param = new HashMap<>();
		param.put("memberId", memberId);
		param.put("keyword", keyword);
		
		try {
			// 업무로직
			// 1. 좌측 사이드바 영역
			// 1) 즐겨찾기 리스트
			List<Favorites> favoritesList = workspaceService.selectAllFavorites(memberId);
			// 2) 워크스페이스 리스트
			List<Workspace> workspaceList = workspaceService.selectWorkspaceList(memberId);
			// 3) 워크스페이스 + 페이지 리스트
			List<Workspace> workspacePageList = workspaceService.selectWorkspacePageList(memberId);
			
			// 2. 검색 결과 영역
			// 1) 검색된 워크스페이스 목록
			List<Workspace> searchedWsList = searchService.selectWsListByKeyword(param);
			// 2) 검색된 페이지 목록
			List<Page> searchedPageList = searchService.selectPageListByKeyword(param);
			// 3) 검색된 포스트 목록
			List<Post> searchedPostList = searchService.selectPostListByKeyword(param);
			// 4) 검색된 코멘트 목록
			List<PostComment> searchedCommentList = searchService.selectCommentListByKeyword(param);
			
			// 뷰모델 처리
			// 사이드바 영역
			mav.addObject("favoritesList", favoritesList);
			mav.addObject("workspaceList", workspaceList);
			mav.addObject("workspacePageList", workspacePageList);
			// 검색 결과 영역
			mav.addObject("keyword", keyword);
			mav.addObject("searchedWsList", searchedWsList.isEmpty() ? null : searchedWsList); // 검색된 워크스페이스 리스트
			mav.addObject("searchedPageList", searchedPageList.isEmpty() ? null : searchedPageList); // 검색된 페이지 리스트
			mav.addObject("searchedPostList", searchedPostList.isEmpty() ? null : searchedPostList); // 검색된 포스트 리스트
			mav.addObject("searchedCommentList", searchedCommentList.isEmpty() ? null : searchedCommentList); // 검색된 코멘트 리스트
			mav.setViewName("search/search");
			
		} catch(Exception e) {
			logger.error("키워드 검색 오류 : ", e);
			throw new WorkspaceException("키워드 검색 오류!");
		}
		
		return mav;
	}
	
}
