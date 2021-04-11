package com.jh.memolog.member.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

import com.jh.memolog.member.model.exception.MemberException;
import com.jh.memolog.member.model.service.MemberService;
import com.jh.memolog.member.model.vo.Member;
import com.jh.memolog.workspace.model.service.WorkspaceService;
import com.jh.memolog.workspace.model.vo.Favorites;
import com.jh.memolog.workspace.model.vo.Workspace;

@Controller
public class MemberController {
	
	private static final Logger logger = LoggerFactory.getLogger(MemberController.class);
	
	@Autowired
	MemberService memberService;
	@Autowired
	WorkspaceService workspaceService;
	
	@GetMapping("/signUp")
	public String signUp() {
		return "member/signUp";
	}
	
	@GetMapping("/logOut")
	public String logOut(HttpSession session) {
		if(session != null)
			session.invalidate();
		
		return "redirect:/";
	}
	
	// 계정 설정 페이지로 이동
	@GetMapping("/account")
	public ModelAndView account(ModelAndView mav, HttpSession session) {
		Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
		String memberId = memberLoggedIn.getMemberId();
		//logger.debug("memberId = {}", memberId);
		Member member;
		
		// 1. 사이드바 영역에 필요한 정보 가져오기 (존재하지 않을 수 있음)
		// 1-1) 사용자의 즐겨찾기 리스트
		List<Favorites> favoritesList = workspaceService.selectAllFavorites(memberId);
		// 1-2) 사용자의 워크스페이스 리스트
		List<Workspace> workspaceList = workspaceService.selectWorkspaceList(memberId);
		// 1-3) 사용자의 워크스페이스 + 페이지 리스트
		List<Workspace> workspacePageList = workspaceService.selectWorkspacePageList(memberId);
		
		try {
			// 2. 사용자 계정 정보 가져오기 
			member = memberService.selectOneMember(memberId);
			
		} catch(Exception e) {
			logger.error("사용자 정보 불러오기 오류!", e);
			throw new MemberException("사용자 정보 불러오기 오류!", e);
		}
		
		// 뷰 모델 처리
		// 사이드바 영역
		mav.addObject("favoritesList", favoritesList); // 즐겨찾기 리스트
		mav.addObject("workspaceList", workspaceList); // 사용자가 속한 워크스페이스 리스트
		mav.addObject("workspacePageList", workspacePageList); // 사용자가 속한 워크스페이스의 페이지 리스트
		
		// 계정 설정 영역
		mav.addObject("member", member);
		
		mav.setViewName("member/accountSettings");
		
		return mav;
	}
	
	

}
