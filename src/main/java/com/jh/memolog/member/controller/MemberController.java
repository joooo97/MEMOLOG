package com.jh.memolog.member.controller;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.servlet.ModelAndView;

import com.jh.memolog.member.model.exception.MemberException;
import com.jh.memolog.member.model.service.MemberService;
import com.jh.memolog.member.model.vo.Member;

@Controller
public class MemberController {
	
	private static final Logger logger = LoggerFactory.getLogger(MemberController.class);
	
	@Autowired
	MemberService memberService;
	
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
		Member member;
		
		try {
			member = memberService.selectOneMember(memberId);
		} catch(Exception e) {
			logger.error("사용자 정보 불러오기 오류!", e);
			throw new MemberException("사용자 정보 불러오기 오류!", e);
		}
		
		mav.addObject("member", member);
		mav.setViewName("member/accountSettings");
		
		return mav;
	}
	
	

}
