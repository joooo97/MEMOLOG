package com.jh.memolog.member.model.service;

import com.jh.memolog.member.model.vo.Member;

public interface MemberService {

	Member selectOneMember(String memberId);

	int insertMember(Member member);

	void updateMember(Member member);

}
