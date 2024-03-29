package com.jh.memolog.member.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
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
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.jh.memolog.member.model.exception.MemberException;
import com.jh.memolog.member.model.service.MemberService;
import com.jh.memolog.member.model.vo.Member;
import com.jh.memolog.page.model.service.PageService;
import com.jh.memolog.workspace.model.service.WorkspaceService;


// 해당 클래스 내에서 모델에 저장하는 키를 @SessionAttributes에 정의된 Key와 동일하게 저장하는 경우 (mav.addObject("memberLoggedIn", m);)
// 자동으로 세션에도 저장시켜 줌 -> session.setAttribute("memberLoggedIn", m); --생략 가능
// @SessionAttributes(value={"memberLoggedIn"})
@RestController
public class MemberRestController {
	
	private static final Logger logger = LoggerFactory.getLogger(MemberRestController.class);
	
	@Autowired
	MemberService memberService;
	
	@Autowired
	PageService pageService;
	
	@Autowired
	WorkspaceService workspaceService;
	
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
			String loc = "";
			
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
	

	// 멤버 정보 조회
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
	
	// 프로필 정보 수정
	// 업로드할 파일이 있는 경우 PutMapping으로 수정 시 415 에러 또는 nullPoint 에러 남
	@PostMapping("/members/{memberId}/profile")
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
			
			// 세션에 변경된 회원 정보 저장
			Member m = memberService.selectOneMember(memberId);
			session.setAttribute("memberLoggedIn", m);
			logger.debug("변경 후 회원 정보: member =  {}", m);
			
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
	
	// 비밀번호 변경
	// @RequestBody : 클라이언트로부터 요청받은 json문자열을 java객체로 변환. 파라미터에 사용
	@PutMapping("/members/{memberId}/password")
	public Map<String, Object> updatePassword(@RequestBody Map<String, String> passwordParam, HttpSession session) {
		Map<String, Object> map = new HashMap<>();
		Map<String, Object> param = new HashMap<>();
		Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
		String memberId = memberLoggedIn.getMemberId();
		// logger.debug("변경 전 비밀번호 = {}", memberLoggedIn.getPassword());
		
		try {
			// 입력한 비밀번호가 일치하는 경우
			if(bcryptPasswordEncoder.matches(passwordParam.get("currentPwd"), memberLoggedIn.getPassword())) {
				// 비밀번호 암호화 후 변경
				String encryptedPassword = bcryptPasswordEncoder.encode(passwordParam.get("newPwd"));
				param.put("memberId", memberLoggedIn.getMemberId());
				param.put("password", encryptedPassword);
				
				int result = memberService.updatePassword(param);
				// 세션에 변경된 정보 저장
				memberLoggedIn = memberService.selectOneMember(memberId);
				session.setAttribute("memberLoggedIn", memberLoggedIn);
				// logger.debug("변경 후 비밀번호 = {}", memberLoggedIn.getPassword());
				
				map.put("isMatched", true); // 입력한 비밀번호의 일치 여부
				map.put("msg", result > 0 ? "비밀번호가 변경되었습니다." : "비밀번호 변경에 실패하셨습니다.");
			}
			else {
				map.put("isMatched", false);
			}
			
		} catch(Exception e) {
			logger.error("비밀번호 수정 오류: ", e);
			throw new MemberException("비밀번호 수정 오류!");
		}
		
		return map;
	}
	
	// 계정 탈퇴
	@DeleteMapping("/members/{memberId}")
	public Map<String, Object> deleteMember(@PathVariable String memberId, HttpSession session) {
		Map<String, Object> map = new HashMap<>();
		// 파라미터가 memberId 한 개 밖에 없지만, 워크스페이스 멤버를 나가는 경우에는 사용하는 쿼리문(selectPinnedPostNoList)에서 
		// memberId와 workspaceMemberNo 두 개의 파라미터를 조회해야 하는 경우도 있기 때문에 Map으로 전달
		Map<String, Object> paramForPostNo = new HashMap<>();
		Map<String, Object> paramForPin = new HashMap<>();
		
		try {
			// 1. 탈퇴자가 고정한 모든 포스트들의 고정 해제
			// 1-1. 탈퇴자가 고정한 모든 포스트의 번호 리스트
			paramForPostNo.put("memberId", memberId);
			List<Integer> pinnedPostNoList = pageService.selectPinnedPostNoList(paramForPostNo);
			logger.debug("고정된 포스트 목록 = {}", pinnedPostNoList);
			
			// 1-2. 포스트 고정 해제 (post_pinned_yn = 'N', post_pinned_person = null)
			if(!pinnedPostNoList.isEmpty()) {
				paramForPin.put("postPinnedYn", "N");
				paramForPin.put("postPinnedPerson", null);

				// 고정된 포스트마다 고정 정보 변경해주기
				for(int no : pinnedPostNoList) {
					paramForPin.put("postNo", no);
					pageService.updatePostPinnedYn(paramForPin);
				}
			}
			
			// 2. 탈퇴자의 프로필 이미지 폴더 및 파일 삭제
			String saveDirectory = session.getServletContext().getRealPath("/resources/upload/profile/"+memberId);
			File dir = new File(saveDirectory); // 폴더
			
			// 2-1. 프로필 이미지 폴더 내 파일 삭제
			if(dir.exists()) deleteAllFiles(dir);
			// 2-2. 프로필 이미지 폴더 삭제
			if(dir.delete())
				logger.debug("프로필 이미지 폴더 삭제 성공: {}", dir.getName());
			else
				logger.debug("프로필 이미지 폴더 삭제 실패: {}", dir.getName());
				
			
			// 3. 탈퇴자가 생성한 모든 워크스페이스의 각 페이지 폴더와 저장된 파일 삭제
			// 3-1. 탈퇴자가 생성한 모든 워크스페이스 번호 리스트
			List<Integer> workspaceNoList = workspaceService.selectWorkspaceNoList(memberId);
			
			if(!workspaceNoList.isEmpty()) {
				for(int workspaceNo : workspaceNoList) {
					// 3-2. 각 워크스페이스의  모든 페이지 번호 리스트
					List<Integer> pageNoList = workspaceService.selectPageNoList(workspaceNo);
					
					for(int pageNo : pageNoList) {
						String pageSaveDir = session.getServletContext().getRealPath("/resources/upload/page/"+pageNo);
						File pageDir = new File(pageSaveDir); // 각 페이지 폴더
						
						// 3-3. 페이지 폴더 내 모든 파일 삭제
						if(pageDir.exists()) deleteAllFiles(pageDir);
						// 3-4. 페이지 폴더 삭제
						if(pageDir.delete())
							logger.debug("페이지 폴더 삭제 성공: {}", pageDir.getName());
						else
							logger.debug("페이지 폴더 삭제 실패: {}", pageDir.getName());
					}
				}
			}
			
			
			// 4. 계정 탈퇴
			int result = memberService.deleteMember(memberId);
			
			// 탈퇴 완료 여부
			if(result > 0) {
				session.invalidate();
				map.put("result", true);
			}
			else
				map.put("result", false);
			
			
		} catch(Exception e) {
			logger.error("계정 탈퇴 오류: ", e);
			throw new MemberException("계정 탈퇴 오류!");
		}
		
		return map;
	}
	
}
