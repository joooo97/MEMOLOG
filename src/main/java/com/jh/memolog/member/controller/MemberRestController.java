package com.jh.memolog.member.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
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
import org.springframework.web.multipart.MultipartFile;

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
	public Member selectOneMember(@PathVariable("memberId") String memberId) {
		Member member;
		
		try {
			member = memberService.selectOneMember(memberId);
		} catch(Exception e) {
			logger.error("멤버 정보 조회 오류: ", e);
			throw new MemberException("멤버 정보 조회 오류!", e);
		}
		
		return member;
	}
	
	
	// 프로필 이미지 변경 시 선택한 프로필 이미지 띄우기
	// 선택한 이미지를 업로드만 할 뿐 사용자의 프로필 이미지 속성 변경 x
	@PostMapping("/members/{memberId}/profile-images")
	public Map<String, Object> uploadProfileImage(@PathVariable("memberId") String memberId, @RequestParam(value="upFile") MultipartFile upFile, HttpSession session) {
		Map<String, Object> map = new HashMap<>();
		
		try {
			// 파일 저장 경로 (사용자별 프로필 이미지가 저장될 경로)
			String saveDirectory = session.getServletContext().getRealPath("/resources/upload/profile/"+memberId);
			
			// 동적으로 directory 생성
			File dir = new File(saveDirectory);
			if(!dir.exists())
				dir.mkdir();
			
			// MultipartFile 객체 파일 업로드 처리
			if(!upFile.isEmpty()) {
				// 파일명 재생성
				String originalFileName = upFile.getOriginalFilename();
				String ext = originalFileName.substring(originalFileName.lastIndexOf(".")); // 확장자  자르기
				SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
				int rndNum = (int)(Math.random() * 1000); // 0 ~ 999까지의 랜덤한 숫자
				String renamedFileName = sdf.format(new Date()) + "_" + rndNum + ext;
				
				// 서버 컴퓨터에 파일 저장
				try {
					upFile.transferTo(new File(saveDirectory + "/" + renamedFileName));
				} catch (IllegalStateException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
				
				// 업로드한 파일의 이름 반환
				map.put("selectedFileName", renamedFileName);
				
			}
			
		} catch (Exception e) {
			logger.error("프로필 이미지 업로드 오류: ", e);
			throw new MemberException("프로필 이미지 업로드 오류!", e);
		}
		
		return map;
	}
	
	// 회원 정보 수정
	// 업로드할 파일이 있는 경우 PutMapping으로 수정 시 415 에러 또는 nullPoint 에러 남
	@PostMapping("/members/{memberId}")
	public void updateMember(@PathVariable("memberId") String memberId, Member member, @RequestParam(value="defaultYn") String defaultYn, @RequestParam(value="newImageYn", required=false) String newImageYn, @RequestParam(value="upFile", required=false) MultipartFile upFile, HttpSession session) {
		try {
			logger.debug("들어온 정보 = {}", member);
			logger.debug("들어온 파일 = {}", upFile);
			// 1. 프로필 이미지 저장
			// 파일 저장 경로
			String saveDirectory = session.getServletContext().getRealPath("/resources/upload/profile/"+memberId);
			File dir = new File(saveDirectory);
			
			// 1-1. 기본 이미지인 경우 (defaultYn.equls("Y"))
			if(defaultYn.equals("Y")) {
				logger.debug("기본 이미지로 변경");
				
				// 디렉토리가 이미 존재하는 경우 디렉토리 내 모든 파일 삭제
				if(dir.exists()) deleteAllFiles(dir);
				
				// 사용자의 프로필 이미지 이름 지정
				member.setProfileOriginalFilename("default.jpg");
				member.setProfileRenamedFilename("default.jpg");
			}
			// 1-2. 새로운 이미지를 업로드 하는 경우
			else if(newImageYn.equals("Y")) {
				// 사용자의 기존 프로필 이미지와 다른 경우에만 이미지 업로드 진행
				if(!upFile.isEmpty()) {
					logger.debug("새 이미지 업로드 = {}", upFile.getName());
					
					// 이미지 업로드 과정
					// 1-1) directory가 존재하지 않는 경우 동적으로 directory 생성
					if(!dir.exists()) {
						dir.mkdir();
					}
					else { // 1-2) directory가 존재하는 경우 기존에 업로드된 디렉토리 내 파일 모두 삭제
						deleteAllFiles(dir);
					}
					
					// 2) 새 이미지 업로드 -  MultipartFile 객체 파일 업로드 처리
					// 파일명 재생성
					String originalFileName = upFile.getOriginalFilename();
					String ext = originalFileName.substring(originalFileName.lastIndexOf(".")); // 확장자 자르기
					SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
					int rndNum = (int)(Math.random()*1000); // 0~999
					String renamedFileName = sdf.format(new Date()) + "_" + rndNum + ext;
					
					// 서버컴퓨터에 파일 저장
					try {
						upFile.transferTo(new File(saveDirectory+"/"+renamedFileName));
					} catch (IllegalStateException e) {
						e.printStackTrace();
					} catch (IOException e) {
						e.printStackTrace();
					}
					
					// 이미지 이름 저장
					member.setProfileOriginalFilename(originalFileName);
					member.setProfileRenamedFilename(renamedFileName);
					
				}
			}
			
			// 2. 회원 정보 수정
			logger.debug("변경할 회원 정보: member = {}", member);
			memberService.updateMember(member);
			
		} catch(Exception e) {
			logger.error("회원 정보 수정 오류: ", e);
			throw new MemberException("회원 정보 수정 오류!", e);
		}
	}
	
	// 디렉토리 내 모든 파일을 삭제하는 메소드
	// 프로필 이미지 변경 시 사용자 프로필 이미지 디렉토리 내 모든 파일을 삭제
	public void deleteAllFiles(File dir) {
		File[] files = dir.listFiles();
		
		for(int i = 0; i < files.length; i++) {
			if(files[i].delete()) {
				logger.debug("파일 삭제 성공: {}", files[i].getName());
			} else {
				logger.debug("파일 삭제 실패: {}", files[i].getName());
			}
		}
	}

}
