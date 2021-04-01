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
public class Page implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int pageNo;
	private int workspaceNo;
	private String pageWriter;
	private String pageName;
	private String pageDesc;
	private String pageCoverCode;
	private Date pageDate;
	
	// 가상 컬럼
	private String workspaceWriter;
	private String workspaceName;
	private String workspaceCoverCode;
	private String workspaceType;
	private String memberId;
	private String roleCode;
	private int favoritesNo;
	private String pFavoriteYn;
}
