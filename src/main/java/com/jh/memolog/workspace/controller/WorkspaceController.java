package com.jh.memolog.workspace.controller;

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
import com.jh.memolog.workspace.model.exception.WorkspaceException;
import com.jh.memolog.workspace.model.service.WorkspaceService;
import com.jh.memolog.workspace.model.vo.Favorites;
import com.jh.memolog.workspace.model.vo.Workspace;

@Controller
public class WorkspaceController {

	private static final Logger logger = LoggerFactory.getLogger(WorkspaceRestController.class);
	
	@Autowired
	WorkspaceService workspaceService;
	
	//로그인 후 워크스페이스로 이동
	@GetMapping("/workspaces")
	public String workspace(HttpSession session) {
		
		Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
		String memberId = memberLoggedIn.getMemberId();
		int firstWorkspaceNo; // 조회할 워크스페이스 번호
		
		Map<String, Object> param = new HashMap<>();
		
		try {
			// 1-1. 가장 처음에 생성된 개인 워크스페이스 조회
			param.put("memberId", memberId);
			param.put("workspaceType", 'P');
			
			Workspace firstPrivateWorkspace = workspaceService.selectFirstWorkspace(param);		
			
			// 개인 워크스페이스가 존재한다면
			if(firstPrivateWorkspace != null) {
				// 조회할 워크스페이스 번호 지정 (개인워크스페이스)
				firstWorkspaceNo = firstPrivateWorkspace.getWorkspaceNo();
			}
			else {
				// 1-2. 개인 워크스페이스가 존재하지 않는다면, 가장 처음에 생성된 공유 워크스페이스 조회
				param.put("workspaceType", 'S');
				Workspace firstSharedWorkspace = workspaceService.selectFirstWorkspace(param);
				if(firstSharedWorkspace != null) {
					firstWorkspaceNo = firstSharedWorkspace.getWorkspaceNo();
				}
				else {
					// 1-3. 개인, 공유 워크스페이스가 모두 존재하지 않는다면
					return "workspace/workspace";
				}
			}
			
			logger.debug("firstWorkspaceNo={}", firstWorkspaceNo);
			
		} catch(Exception e) {
			logger.error("로그인 후 워크스페이스 번호 조회 오류 : ", e);
			throw new WorkspaceException("로그인 후 워크스페이스 번호 조회 오류", e);
		}
		
		return "redirect:/workspaces/"+firstWorkspaceNo;
	}
	
	//워크스페이스  조회
	//GET) /workspaces/:workspaceNo
	@GetMapping("/workspaces/{workspaceNo}")
	public ModelAndView workspace(ModelAndView mav, HttpSession session, @PathVariable("workspaceNo") int workspaceNo) {
		
		Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
		String memberId = memberLoggedIn.getMemberId();
		Map<String, Object> param = new HashMap<>();
		
		logger.debug("조회할 워크스페이스 번호: {}", workspaceNo);
		
			//1. 업무로직
	
			//1) 좌측 사이드바 영역
			//1-1) 즐겨찾기 워크스페이스 + 페이지 리스트
			List<Favorites> favoritesList = workspaceService.selectAllFavorites(memberId);
			
			//1-2) 워크스페이스 리스트
			List<Workspace> workspaceList = workspaceService.selectWorkspaceList(memberId);
			
			//1-3) 워크스페이스 + 페이지 리스트
			List<Workspace> workspacePageList = workspaceService.selectWorkspacePageList(memberId);
						
			//2) 워크스페이스 영역
			//2-1) 조회할 워크스페이스
			param.put("workspaceNo", workspaceNo);
			param.put("memberId", memberId);
			
			Workspace workspace = workspaceService.selectOneWorkspace(param);
			logger.debug("조회할 워크스페이스: workspace={}", workspace);
			
			//2-2) 조회할 워크스페이스의 페이지 리스트
			List<Page> pageList = workspaceService.selectPageList(workspaceNo);
			logger.debug("조회할 워크스페이스의 페이지 리스트: pageList={}", pageList);
			
			//2. 뷰모델 처리
			mav.addObject("favoritesList", favoritesList); // 즐겨찾기 리스트
			mav.addObject("workspaceList", workspaceList); // 사용자가 속한 워크스페이스 리스트
			mav.addObject("workspacePageList", workspacePageList); // 사용자가 속한 워크스페이스의 페이지 리스트
			
			mav.addObject("workspace", workspace); // 조회할 워크스페이스
			mav.addObject("pageList", pageList); // 조회할 워크스페이스의 페이지 리스트
			
			mav.setViewName("workspace/workspace");
		
		return mav;
	}

}
