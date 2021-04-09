package com.jh.memolog.member.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.jh.memolog.member.model.exception.MemberException;
import com.jh.memolog.member.model.service.MemberService;
import com.jh.memolog.member.model.vo.Member;


//해당 클래스 내에서 모델에 저장하는 키를 @SessionAttributes에 정의된 Key와 동일하게 저장하는 경우, 
//자동으로 세션에도 저장시켜 줌 
@SessionAttributes(value={"memberLoggedIn"})
@RestController
public class MemberRestController {
	
	private static final Logger logger = LoggerFactory.getLogger(MemberRestController.class);
	
	@Autowired
	MemberService memberService;
	
	@Autowired
	BCryptPasswordEncoder bcryptPasswordEncoder;
	
	//로그인
	@PostMapping("/login")
	public Map<String, String> login(@RequestParam String memberId, @RequestParam String password, @RequestParam(value="saveId", required=false) String saveId,
		   HttpSession session, HttpServletResponse response) {
		
		Map<String, String> map = new HashMap<>();
	
		try {
			//1. 업무로직
			Member m = memberService.selectOneMember(memberId);
			logger.debug("member={}", m);
			logger.debug("saveId={}", saveId);

			String msg = "";
			String loc = "/";
			
			String encryptedPassword = bcryptPasswordEncoder.encode(password);
			
			logger.debug("rawPassword={}",password);
			logger.debug("encryptedPassword={}",encryptedPassword);
			
			//로그인 분기
			//1) 아이디 존재하지 않는 경우
			if(m == null) {
				msg = "존재하지 않는 아이디입니다.";
			} else {
				//2) 아이디 존재하는 경우
				//2-1) 비밀번호 일치하는 경우
				if(bcryptPasswordEncoder.matches(password, m.getPassword())) {
					session.setAttribute("memberLoggedIn", m);
					// session 유효시간 설정: 초단위
					session.setMaxInactiveInterval(60 * 30); // 30분동안 사용자의 요청이 없으면 세션 만료되어 로그아웃 처리됨
					
					loc = "/workspaces";
					
					//2-1-1) 아이디 저장 체크 했을 경우
					// 체크된 경우: "on", 체크되지 않은 경우: null
					if(saveId != null) {
						Cookie c = new Cookie("saveId", memberId);
						c.setMaxAge(7*24*60*60); //7일후 소멸
						c.setPath("/"); //쿠키사용디렉토리. 도메인 전역에서 사용함.
						response.addCookie(c);
					}
					//2-1-2) 아이디 저장 체크하지 않은 경우
					else {
						Cookie c = new Cookie("saveId", memberId);
						c.setMaxAge(0); //쿠키 삭제를 위해 유효기간을 0으로 설정 
						c.setPath("/");
						response.addCookie(c);
					}
					
					//2-2) 비밀번호 불일치
				} else {
					msg = "비밀번호가 일치하지 않습니다.";
				}
				
			}
			
			//2. view모델 처리
			map.put("msg", msg);
			map.put("loc", loc);
			
		} catch (Exception e) {
			logger.error("로그인 오류 : ", e);
			throw new MemberException("로그인 오류!", e);
		}
		
		return map;
	}
	
	// 아이디 중복 체크
	@GetMapping("/checkIdDuplicate")
	public Map<String, Object> checkIdDuplicate(@RequestParam String memberId){
		Map<String, Object> map = new HashMap<>();
			map.put("memberId", memberId);
			logger.debug("멤버 조회 memberId={}", memberId);
			
			Boolean isUsable = memberService.selectOneMember(memberId) == null ? true : false;
			map.put("isUsable", isUsable);
			logger.debug("아이디 사용 가능 여부 : {}", isUsable);

		return map;
	}
	
	// 회원가입
	// 파라미터를 Member member로 받아도, 파라미터를 @RequestBody로 받아도 둘다 됨
	@PostMapping("/signUp")
	public Map<String, Object> signUp(@RequestBody Member member){
		Map<String, Object> map = new HashMap<>();
		String rawPassword = member.getPassword();
		String encryptedPassword = bcryptPasswordEncoder.encode(rawPassword);

		logger.debug("rawPassword={}", rawPassword);
		logger.debug("encryptedPassword={}", encryptedPassword);
		
		// 비밀번호 암호화 처리
		member.setPassword(encryptedPassword);
		logger.debug("member={}", member);
		
		int result = memberService.insertMember(member);
		
		String msg = "";
		
		if(result > 0) msg = "회원가입이 완료되었습니다.";
		else msg = "회원가입에 실패하셨습니다.";
		
		map.put("msg", msg);
		
		return map;
		
	}
	

	// 멤버 정보 조회(아이디, 이름, 이메일, 전화번호, 프로필 사진 이름)
	@GetMapping("/members/{memberId}")
	public Map<String, Object> selectOneMember(@PathVariable("memberId") String memberId) {
		Map<String, Object> map = new HashMap<>();
		
		try {
			Member member = memberService.selectOneMember(memberId);
			
			map.put("memberId", member.getMemberId());
			map.put("memberName", member.getMemberName());
			map.put("email", member.getEmail());
			map.put("phone", member.getPhone());
			map.put("profileRenamedFilename", member.getProfileRenamedFilename());
			
		} catch(Exception e) {
			logger.error("멤버 정보 조회 오류: ", e);
			throw new MemberException("멤버 정보 조회 오류!", e);
		}
		
		return map;
	}
	
	
	

}
