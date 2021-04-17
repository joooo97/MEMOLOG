package com.jh.memolog.member.model.dao;

import java.util.Map;

import com.jh.memolog.member.model.vo.Member;

public interface MemberDAO {

	Member selectOneMember(String memberId);

	int insertMember(Member member);

	int updateMember(Member member);

	int updatePassword(Map<String, Object> param);

}
