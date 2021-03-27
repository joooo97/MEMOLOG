package com.jh.memolog.workspace.model.vo;

import java.io.Serializable;
import java.sql.Date;
import java.util.List;

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
public class Workspace implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int workspaceNo;
	private String workspaceWriter;
	private String workspaceType;
	private String workspaceName;
	private String workspaceDesc;
	private String workspaceCoverCode;
	private Date workspaceDate;
	
	//view_workspacePage (workspace + page)
	private int pageNo;
	private int workspaceNo1;
	private String pageWriter;
	private String pageName;
	private String pageDesc;
	private String pageCoverCode;
	private Date pageDate;
	
	// 가상 컬럼
	private String memberId;
	private String roleCode;
	private int favoritesNo;
	private String wsFavoriteYn;
	
	

}
