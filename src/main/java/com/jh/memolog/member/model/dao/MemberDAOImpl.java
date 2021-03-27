package com.jh.memolog.member.model.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.jh.memolog.member.model.vo.Member;

@Repository
public class MemberDAOImpl implements MemberDAO {
	
	@Autowired
	SqlSessionTemplate sqlSession;

	@Override
	public Member selectOneMember(String memberId) {
		return sqlSession.selectOne("member.selectOneMember", memberId);
	}

	@Override
	public int insertMember(Member member) {
		return sqlSession.insert("member.insertMember", member);
	}


	/*	@Override
	public List<Member> selectMemberList() {
		return sqlSession.selectList("member.selectMemberList");
	}*/
	
}
