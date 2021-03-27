package com.jh.memolog.member.model.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.jh.memolog.member.model.dao.MemberDAO;
import com.jh.memolog.member.model.exception.MemberException;
import com.jh.memolog.member.model.vo.Member;

@Service
public class MemberServiceImpl implements MemberService {

	@Autowired
	MemberDAO memberDAO;

	// 특정 멤버 조회
	@Override
	public Member selectOneMember(String memberId) {
		Member member = memberDAO.selectOneMember(memberId);
		
		return member;
	}

	// 회원 가입
	@Override
	public int insertMember(Member member) {
		int result = memberDAO.insertMember(member);
		
		if(result == 0) throw new MemberException("회원가입 오류!");
		
		return result;
	}


	// 모든 멤버 조회
/*	@Override
	public List<Member> selectMemberList() {
		List<Member> memberList = memberDAO.selectMemberList(); 
		
		if(memberList == null)
			throw new MemberException("전체 멤버 조회 오류!");
		
		return memberList;
	}*/


}