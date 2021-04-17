package com.jh.memolog.member.model.service;

import java.util.Map;

import com.jh.memolog.member.model.vo.Member;

public interface MemberService {

	Member selectOneMember(String memberId);

	int insertMember(Member member);

	void updateMember(Member member);

	int updatePassword(Map<String, Object> param);

}
