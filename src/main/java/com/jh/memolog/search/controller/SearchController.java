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
import com.jh.memolog.search.model.service.SearchService;
import com.jh.memolog.workspace.model.exception.WorkspaceException;
import com.jh.memolog.workspace.model.vo.Workspace;

@Controller
public class SearchController {
	
	private static final Logger logger = LoggerFactory.getLogger(SearchController.class);
	
	@Autowired
	SearchService searchService;
	
	@GetMapping("/search/{keyword}")
	public ModelAndView search(ModelAndView mav, HttpSession session, @PathVariable("keyword") String keyword) {
		Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
		String memberId = memberLoggedIn.getMemberId();
		
		Map<String, Object> param = new HashMap<>();
		param.put("memberId", memberId);
		param.put("keyword", keyword);
		
		try {
			// 1. 업무로직
			// 1) 워크스페이스명 검색 결과
			List<Workspace> workspaceList = searchService.selectWsListByKeyword(param);
			logger.debug("controller@wsList = {}", workspaceList);
			
			// 2. 뷰모델 처리
			mav.addObject("keyword", keyword);
			mav.addObject("workspaceList", workspaceList);
			mav.setViewName("search/search");
			
		} catch(Exception e) {
			logger.error("키워드 검색 오류 : ", e);
			throw new WorkspaceException("키워드 검색 오류!");
		}
		
		return mav;
	}
	
}
