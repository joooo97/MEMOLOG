package com.jh.memolog.page.model.vo;

import java.io.Serializable;
import java.sql.Date;

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
public class Post implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int postNo;
	private int pageNo;
	private String postSortCode;
	private String postContent;
	private String postOriginalFilename;
	private String postRenamedFilename;
	private String postWriter;
	private String postDate;
	private String postPinnedYn;
	private String postPinnedPerson;
	
	// 가상 컬럼
	private int commentCount;
	private String profileRenamedFilename;
	private String workspaceName;
	private String workspaceCoverCode;
	private String pageName;
	private String pageCoverCode;
}

