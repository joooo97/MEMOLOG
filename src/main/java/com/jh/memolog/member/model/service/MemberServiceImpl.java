package com.jh.memolog.member.model.service;

import java.util.Map;

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

	// 회원 정보 수정
	@Override
	public void updateMember(Member member) {
		int result = memberDAO.updateMember(member);
		
		if(result == 0)
			throw new MemberException("회원 정보 수정 오류!");
	}

	// 비밀번호 변경
	@Override
	public int updatePassword(Map<String, Object> param) {
		int result = memberDAO.updatePassword(param);
		
		if(result == 0)
			throw new MemberException("비밀번호 변경 오류!");
		
		return result;
	}


}