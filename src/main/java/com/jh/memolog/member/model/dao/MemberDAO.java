package com.jh.memolog.member.model.dao;

import com.jh.memolog.member.model.vo.Member;

public interface MemberDAO {

	Member selectOneMember(String memberId);

	int insertMember(Member member);

}
