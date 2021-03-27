package com.jh.memolog.workspace.model.vo;

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
public class WorkspaceMember implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private int workspaceMemberNo;
	private int workspaceNo;
	private String memberId;
	private String roleCode;
	private String workspaceType;
	
	// 가상컬럼
	private String memberName;
	private String profileRenamedFilename;
}
