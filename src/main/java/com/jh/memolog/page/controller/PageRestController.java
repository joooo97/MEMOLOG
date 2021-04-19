package com.jh.memolog.page.controller;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.jh.memolog.member.model.vo.Member;
import com.jh.memolog.page.model.exception.PageException;
import com.jh.memolog.page.model.service.PageService;
import com.jh.memolog.page.model.vo.Page;
import com.jh.memolog.page.model.vo.Post;
import com.jh.memolog.page.model.vo.PostComment;
import com.jh.memolog.workspace.model.exception.WorkspaceException;

@RestController
public class PageRestController {
	
	private static final Logger logger = LoggerFactory.getLogger(PageRestController.class);
	
	@Autowired
	PageService pageService;
	
	// 페이지 생성
	@PostMapping("/pages")
	public Map<String, Object> createPage(HttpSession session, Page page){
		
		Map<String, Object> map = new HashMap<>();
		Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
		String memberId = memberLoggedIn.getMemberId();
		
		try {
			// xss공격방어
			String pageName = page.getPageName().replaceAll("<", "&lt;").replaceAll(">", "&gt;");
			String pageDesc = page.getPageDesc().replaceAll("<", "&lt;").replaceAll(">", "&gt;");
			
			// page 정보 저장
			page.setPageWriter(memberId);
			page.setPageName(pageName);
			page.setPageDesc(pageDesc);
			logger.debug("page={}", page);
			
			// 페이지 생성 후 페이지 번호 받아오기
			int pageNo = pageService.insertPage(page);
			
			map.put("pageNo", pageNo);
			
		} catch(Exception e) {
			logger.error("페이지 생성 오류: ", e);;
			throw new WorkspaceException("페이지 생성 오류!", e);
		}
		
		return map;
	}
	
	// 페이지 커버 색 변경
	@PutMapping("/pages/{pageNo}/cover-color")
	public void updatePageCoverColor(@PathVariable("pageNo") int pageNo, @RequestBody String pageCoverCode) {
		Map<String, Object> param = new HashMap<>();
		
		try {
			param.put("pageNo", pageNo);
			param.put("pageCoverCode", pageCoverCode);
			logger.debug("pageNo={}", pageNo);
			logger.debug("pageCoverCode={}", pageCoverCode);
			
			// 커버 색 변경
			pageService.updatePageCoverColor(param); 
			
		} catch(Exception e) {
			logger.error("페이지 커버 색 변경 오류: ", e);
			throw new PageException("페이지 커버 색 변경 오류!", e);
		}
	}
	
	// 페이지 수정
	@PutMapping("/pages/{pageNo}")
	public void updatePage(@PathVariable("pageNo") int pageNo, @RequestBody Page page) {
		Map<String, Object> param = new HashMap<>();
	
		try {
			param.put("pageNo", pageNo);
			param.put("pageName", page.getPageName());
			param.put("pageDesc", page.getPageDesc());
			logger.debug("pageNo = {}", pageNo);
			logger.debug("page = {}", page);
			
			pageService.updatePage(param);
			
		} catch(Exception e) {
			logger.error("페이지 수정 오류: ", e);
			throw new PageException("페이지 수정 오류!", e);
		}
		
		
	}
	
	// 페이지 삭제
	@DeleteMapping("/pages/{pageNo}")
	public void deletePage(@PathVariable("pageNo") int pageNo, HttpSession session) {
		try {
			pageService.deletePage(pageNo);
			
			String saveDirectory = session.getServletContext().getRealPath("/resources/upload/page/"+pageNo);
			File dir = new File(saveDirectory); // 폴더
			// 페이지에 업로드된 모든 파일 삭제
			if(dir.exists()) {
				File[] files = dir.listFiles();
				
				for(int i = 0; i < files.length; i++) {
					if(files[i].delete()) 
						logger.debug("파일 삭제 성공: {}", files[i].getName());
					else
						logger.debug("파일 삭제 실패: {}", files[i].getName());
				}
			}
			// 해당 페이지 폴더 삭제
			if(dir.delete())
				logger.debug("페이지 폴더 삭제 성공: {}", dir.getName());
			else
				logger.debug("페이지 폴더 삭제 실패: {}", dir.getName());
			
		} catch(Exception e) {
			logger.error("페이지 삭제 오류: ", e);
			throw new PageException("페이지 삭제 오류!", e);
		}
	}
	
	// 포스트 추가
	@PostMapping("/pages/{pageNo}/posts")
	public void insertPost(@PathVariable("pageNo") int pageNo, HttpSession session, Post post, @RequestParam(value="upFile", required=false) MultipartFile upFile) {
		Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
		String memberId = memberLoggedIn.getMemberId();
		
		try {
			// #1. 모든 포스트 공통 설정 (페이지 번호, 페이지 작성자)
			post.setPageNo(pageNo);
			post.setPostWriter(memberId);
			logger.debug("추가할 포스트: post = {}", post);
			
			// #2. 포스트 유형이 첨부파일일 경우 파일 업로드 처리
			if(post.getPostSortCode().equals("P2")) {
				logger.debug("첨부파일 포스트 등록 요청!");
				
				// 파일 저장 경로
				String saveDirectory = session.getServletContext().getRealPath("/resources/upload/page/"+post.getPageNo());
				
				// 동적으로 directory 생성
				File dir = new File(saveDirectory);
				if(dir.exists() == false)
					dir.mkdir();
				
				// MultipartFile 객체 파일 업로드 처리
				if(!upFile.isEmpty()) {
					// 파일명 재생성
					String originalFileName = upFile.getOriginalFilename();
					String ext = originalFileName.substring(originalFileName.lastIndexOf(".")); // 확장자 자르기
					SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
					int rndNum = (int)(Math.random()*1000); // 0~999
					String renamedFileName = sdf.format(new Date()) + "_" + rndNum + ext;
					
					// 서버컴퓨터에 파일 저장
					try {
						upFile.transferTo(new File(saveDirectory + "/" + renamedFileName));
					} catch (IllegalStateException e) {
						e.printStackTrace();
					} catch (IOException e) {
						e.printStackTrace();
					}
					
					// 첨부파일 이름 저장
					post.setPostOriginalFilename(originalFileName);
					post.setPostRenamedFilename(renamedFileName);
				} // MultipartFile 객체 업로드 처리 끝
				
			}
			
			// #3. 포스트 추가
			pageService.insertPost(post);
			
		} catch(Exception e) {
			logger.error("포스트 추가 오류: ", e);
			throw new PageException("포스트 추가 오류!", e);
		}
		
	}
	
	// 전체 포스트 조회
	// 특정 페이지의 포스트 리스트 + 포스트별 댓글 수 + 포스트 작성자 이미지 이름 조회 (by pageNo)
	@GetMapping("/pages/{pageNo}/posts")
	public List<Post> selectPostListByPageNo(@PathVariable("pageNo") int pageNo) {
		List<Post> postList = pageService.selectPostListByPageNo(pageNo);
		logger.debug("postList = {}", postList);
		
		return postList;
	}
	
	// 첨부파일 포스트 리스트 조회
	@GetMapping("/pages/{pageNo}/posts/files")
	public List<Post> selectFilePostList(@PathVariable("pageNo") int pageNo) {
		Map<String, Object> param = new HashMap<>();
		param.put("pageNo", pageNo);
		param.put("postSort", "files");
		
		List<Post> postList = pageService.selectPostListBySort(param);
		logger.debug("postList = {}", postList);
		
		return postList;
	}
	
	// 고정된 포스트 리스트 조회
	@GetMapping("/pages/{pageNo}/posts/pinnedPosts")
	public List<Post> selectPinnedPostList(@PathVariable("pageNo") int pageNo) {
		Map<String, Object> param = new HashMap<>();
		param.put("pageNo", pageNo);
		param.put("postSort", "pinnedPosts");
		
		List<Post> postList = pageService.selectPostListBySort(param);
		logger.debug("postList = {}", postList);
		
		return postList;
	}
	
	// 포스트 고정 / 고정 해제
	@PutMapping("pages/{pageNo}/posts/{postNo}/post-pinned-yn")
	public void updatePostPinnedYn(@PathVariable("pageNo") int pageNo, @PathVariable("postNo") int postNo, @RequestBody String postPinnedYn, HttpSession session) {
		Map<String, Object> param = new HashMap<>();
		Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
		String memberId = memberLoggedIn.getMemberId();
		
		try {
			// 포스트 번호 저장
			param.put("postNo", postNo);
			
			// 포스트를 고정하는 경우
			if("Y".equals(postPinnedYn)) {
				param.put("postPinnedYn", "Y");
				param.put("postPinnedPerson", memberId);
			}
			else { // 포스트 고정을 해제하는 경우
				param.put("postPinnedYn", "N");
				param.put("postPinnedPerson", null);
			}
			
			// 포스트 고정/고정 해제
			pageService.updatePostPinnedYn(param); 
			
		} catch(Exception e) {
			logger.error("포스트 고정/고정 해제 오류: ", e);
			throw new PageException("포스트 고정/고정 해제 오류!", e);
		}
		
	}
	
	// 특정 포스트 조회 (by postNo)
	@GetMapping("/pages/{pageNo}/posts/{postNo}")
	public Post selectOnePost(@PathVariable("pageNo") int pageNo, @PathVariable("postNo") int postNo) {
		Post post = new Post();
		try {
			post = pageService.selectOnePost(postNo);
		} catch(Exception e) {
			logger.error("특정 포스트 조회 오류: ", e);
			throw new PageException("특정 포스트 조회 오류!", e);
		}
		
		return post;
	}
	
	// 포스트 수정
	// PutMapping -> 415 에러 또는 nullPoint 에러남
	@PostMapping("/pages/{pageNo}/posts/{postNo}")
	public void updatePost(@PathVariable("pageNo") int pageNo, @PathVariable("postNo") int postNo, Post post, @RequestParam(value="upFile", required=false) MultipartFile upFile, HttpSession session) {
		logger.debug("수정할 포스트: post = {}", post);
		
		try {
			// 포스트 종류가 첨부파일(P2)일 경우
			if(post.getPostSortCode().equals("P2")) {
				
				// 1. 파일 업로드 처리
				// 파일 저장 경로
				String saveDirectory = session.getServletContext().getRealPath("/resources/upload/page/"+pageNo);
				
				// 동적으로 directory 생성
				File dir = new File(saveDirectory);
				if(!dir.exists())
					dir.mkdir();
				
				// MultipartFile 객체 파일 업로드 처리
				if(!upFile.isEmpty()) {
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
					
					// 첨부파일 이름 저장
					post.setPostOriginalFilename(originalFileName);
					post.setPostRenamedFilename(renamedFileName);
					
				} // MultipartFile 객체 업로드 처리 끝
				
				// 2. 기존 파일 삭제
				Post existingPost = pageService.selectOnePost(postNo);
				File deleteFile = new File(saveDirectory+"/"+existingPost.getPostRenamedFilename());
				
				if(deleteFile.exists()) {
					if(deleteFile.delete()) {
						logger.debug("기존 파일 삭제 성공: {}", existingPost.getPostRenamedFilename());
					}
					else {
						logger.debug("기존 파일 삭제 실패: {}", existingPost.getPostRenamedFilename());
					}
				}
				else {
					logger.debug("기존 파일이 존재하지 않습니다: {}", existingPost.getPostRenamedFilename());
				}
				
			}
			
			// 포스트 수정
			pageService.updatePost(post);
			
		} catch(Exception e) {
			logger.error("포스트 수정 오류: ", e);
			throw new PageException("포스트 수정 오류!", e);
		}
	}
	
	// 포스트 삭제
	@DeleteMapping("/pages/{pageNo}/posts/{postNo}")
	public void deletePost(@PathVariable("pageNo") int pageNo, @PathVariable("postNo") int postNo, HttpSession session) {
		try {
			// 서버컴퓨터에 저장된 첨부파일 삭제 처리
			String saveDirectory = session.getServletContext().getRealPath("/resources/upload/page/"+pageNo);
			Post post = pageService.selectOnePost(postNo);
			File deleteFile = new File(saveDirectory+"/"+post.getPostRenamedFilename());

			if(deleteFile.exists()) {
				if(deleteFile.delete()) {
					logger.debug("파일 삭제 성공: {}", post.getPostRenamedFilename());
				}
				else {
					logger.debug("파일 삭제 실패: {}", post.getPostRenamedFilename());
				}
			}
			else {
				logger.debug("기존 파일이 존재하지 않습니다: {}", post.getPostRenamedFilename());
			}
			
			// 포스트 삭제
			pageService.deletePost(postNo);
			
		} catch(Exception e) {
			logger.error("포스트 삭제 오류: ", e);
			throw new PageException("포스트 삭제 오류!", e);
		}
	}
	
	// 첨부파일 다운로드
	@GetMapping("/pages/{pageNo}/posts/{postNo}/download")
	public void downloadFile(@PathVariable("pageNo") int pageNo, @RequestParam String oName, @RequestParam String rName, HttpServletRequest request, HttpServletResponse response) {
		try {
			String saveDirectory = request.getServletContext().getRealPath("/resources/upload/page/"+pageNo);
			
			logger.debug("saveDirectory={}", saveDirectory);
			
			BufferedInputStream bis = new BufferedInputStream(new FileInputStream(saveDirectory+File.separator+rName));
			
			ServletOutputStream sos = response.getOutputStream();
			BufferedOutputStream  bos = new BufferedOutputStream(sos);
			
			String resFileName = "";
			
			boolean isMSIE = request.getHeader("user-agent").indexOf("MSIE") != -1 
					|| request.getHeader("user-agent").indexOf("Trident") != -1;
			
			if(isMSIE) {
				resFileName = URLEncoder.encode(oName, "utf-8");
				resFileName = resFileName.replaceAll("\\+", "%20");
			}
			else {
				resFileName = new String(oName.getBytes("utf-8"), "iso-8859-1");
			}
			
			response.setContentType("application/octet-stream;charset=utf-8");
			response.setHeader("Content-Disposition", "attachment;filename=\""+resFileName+"\"");
			
			int read = -1;
			while((read = bis.read()) != -1) {
				sos.write(read);
			}
			bos.close();
			bis.close();
			
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new PageException("첨부파일 다운로드 오류!", e);
		}
	}
	
	// 포스트 코멘트 바 조회
	@GetMapping("/pages/{pageNo}/posts/{postNo}/post-comments")
	public Map<String, Object> selectPostCommentList(@PathVariable("postNo") int postNo) {
		Map<String, Object> map = new HashMap<>();
		
		try {
			// 1. 해당 포스트 + 코멘트 개수 + 포스트 작성자 이미지 
			Post post = pageService.selectOnePost(postNo);
			// 2. 해당 포스트의 포스트 코멘트 리스트
			List<PostComment> commentList = pageService.selectPostCommentList(postNo);
			
			map.put("post", post);
			map.put("commentList", commentList);
			
		} catch(Exception e) {
			logger.error("포스트 코멘트 조회 오류: ", e);
			throw new PageException("포스트 코멘트 조회 오류!", e);
		}
		
		return map;
	}
	
	// 포스트 코멘트 추가
	@PostMapping("/pages/{pageNo}/posts/{postNo}/post-comments")
	public void insertPostComment(@PathVariable("pageNo") int pageNo, @PathVariable("postNo") int postNo, HttpSession session, PostComment postComment) {
		Member member = (Member)session.getAttribute("memberLoggedIn");
		String memberId = member.getMemberId();
		logger.debug("postCommet = {}", postComment);
		
		try {
			// 포스트 코멘트 작성자 저장
			postComment.setPostCommentWriter(memberId);
			// 포스트 코멘트 추가
			pageService.insertPostComment(postComment);
			
		} catch(Exception e) {
			logger.error("포스트 코멘트 작성 오류: ", e);
			throw new PageException("포스트 코멘트 작성 오류!", e);
		}
	}
	
	// 포스트 코멘트 삭제
	@DeleteMapping("/pages/{pageNo}/posts/{postNo}/post-comments/{commentNo}")
	public void deletePostComment(@PathVariable("commentNo") int commentNo) {
		try {
			pageService.deletePostComment(commentNo);
		} catch(Exception e) {
			logger.error("포스트 코멘트 삭제 오류: ", e);
			throw new PageException("포스트 코멘트 삭제 오류!", e);
		}
	}
	
	// 포스트 코멘트 수정
	@PutMapping("/pages/{pageNo}/posts/{postNo}/post-comments/{commentNo}")
	public void updatePostComment(@PathVariable("commentNo") int commentNo, @RequestBody String commentContent) {
		Map<String, Object> param = new HashMap<>();
		
		try {
			param.put("commentNo", commentNo);
			param.put("commentContent", commentContent);
			
			pageService.updatePostComment(param);
			
		} catch(Exception e) {
			logger.error("포스트 코멘트 수정 오류: ", e);
			throw new PageException("포스트 코멘트 수정 오류!", e);
		}
	}
	
	// 페이지 즐겨찾기 추가
	@PostMapping("/page-favorites")
	public Map<String, Object> insertPageFavorite(@RequestParam(value="workspaceNo") int workspaceNo, @RequestParam(value="pageNo") int pageNo, HttpSession session) {
		Map<String, Object> map = new HashMap<>();
		Map<String, Object> param = new HashMap<>();
		Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
		String memberId = memberLoggedIn.getMemberId();
		int createdFavoriteNo = 0;
		
		try {
			param.put("memberId", memberId);
			param.put("workspaceNo", workspaceNo);
			param.put("pageNo", pageNo);
			
			// 즐겨찾기 추가 후 생성된 즐겨찾기 번호 조회
			createdFavoriteNo = pageService.insertPageFavorite(param);
			map.put("createdFavoriteNo", createdFavoriteNo);
			logger.debug("createdFavoriteNo = {}", createdFavoriteNo);
			
		} catch(Exception e) {
			logger.error("페이지 즐겨찾기 추가 오류: ", e);
			throw new PageException("페이지 즐겨찾기 추가 오류!", e);
		}
		
		return map;
	}

}
