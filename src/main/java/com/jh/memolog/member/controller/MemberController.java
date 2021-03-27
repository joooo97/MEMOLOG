package com.jh.memolog.member.controller;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class MemberController {
	
	private static final Logger logger = LoggerFactory.getLogger(MemberController.class);
	
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
	
	//테스트용 jsp 이동
	@GetMapping("/empty")
	public void empty() {
		
	}
	

}
