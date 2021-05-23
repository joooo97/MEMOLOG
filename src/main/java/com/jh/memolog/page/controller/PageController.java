package com.jh.memolog.page.controller;

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
import com.jh.memolog.page.model.service.PageService;
import com.jh.memolog.page.model.vo.Page;
import com.jh.memolog.workspace.model.service.WorkspaceService;
import com.jh.memolog.workspace.model.vo.Favorites;
import com.jh.memolog.workspace.model.vo.Workspace;

@Controller
public class PageController {
	
	private static final Logger logger = LoggerFactory.getLogger(PageController.class);
	
	@Autowired
	PageService pageService;
	
	@Autowired
	WorkspaceService workspaceService;
	
	// 페이지 조회
	@GetMapping(value = {"/pages/{pageNo}", "/pages/{pageNo}/searched-post/{postNo}"})
	public ModelAndView pageByPageNo(ModelAndView mav, HttpSession session, @PathVariable("pageNo") int pageNo, @PathVariable(required = false) Integer postNo) {
		
		Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
		String memberId = memberLoggedIn.getMemberId();
		Map<String, Object> param = new HashMap<>();
		
		logger.debug("조회할 페이지 번호: {}", pageNo);
		
		// 1. 업무로직
		// 1) 사이드바 영역
		//1-1) 즐겨찾기 워크스페이스 + 페이지 리스트
		List<Favorites> favoritesList = workspaceService.selectAllFavorites(memberId);
		
		//1-2) 워크스페이스 리스트
		List<Workspace> workspaceList = workspaceService.selectWorkspaceList(memberId);
		
		//1-3) 워크스페이스 + 페이지 리스트
		List<Workspace> workspacePageList = workspaceService.selectWorkspacePageList(memberId);
		
		// 페이지 영역
		// 2-1) 조회할 페이지
		param.put("pageNo", pageNo);
		param.put("memberId", memberId);
		
		Page page = pageService.selectOnePage(param);
		logger.debug("page={}", page);
				
		// 2. 뷰모델 처리
		// 사이드바 영역
		mav.addObject("favoritesList", favoritesList); // 즐겨찾기 리스트
		mav.addObject("workspaceList", workspaceList); // 사용자가 속한 워크스페이스 리스트
		mav.addObject("workspacePageList", workspacePageList); // 사용자가 속한 워크스페이스의 페이지 리스트
		
		// 페이지 영역
		mav.addObject("page", page); // 조회할 페이지
		
		// 검색된 포스트 조회 시
		if(postNo != null) {
			mav.addObject("searchedPostNo", postNo);
		}
		
		mav.setViewName("workspace/page");
		
		return mav;
		
	}
	
}
