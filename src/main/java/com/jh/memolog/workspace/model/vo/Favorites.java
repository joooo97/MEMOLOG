package com.jh.memolog.workspace.model.vo;

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
public class Favorites implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int favoritesNo;
	private String memberId;
	private String favoritesType;
	private int workspaceNo;
	private int pageNo;
	private Date favoritesDate;
	
	// favorites + workspace(workspaceName, workspaceWriter, workspaceDesc) 
	//           + page(pageName, pageWriter, pageDesc) + ws_member(role_code)
	private String workspaceName;
	private String workspaceWriter;
	private String workspaceDesc;
	private String pageName;
	private String pageWriter;
	private String pageDesc;
	private String roleCode;

}
