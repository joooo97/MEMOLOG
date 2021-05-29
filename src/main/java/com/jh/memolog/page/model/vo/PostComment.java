package com.jh.memolog.page.model.vo;

import java.io.Serializable;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class PostComment implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int postCommentNo;
	private int pageNo;
	private int postNo;
	private String postCommentWriter;
	private String postCommentLevel;
	private String postCommentContent;
	private String postCommentDate;
	private int postCommentRef;
	private String postCommentRefWriter;
	
	// 가상 컬럼
	private String profileRenamedFilename;
	// 코멘트 검색 결과에 사용
	private String workspaceName;
	private String workspaceCoverCode;
	private String pageName;
	private String pageCoverCode;
}
