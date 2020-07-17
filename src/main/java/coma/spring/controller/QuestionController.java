package coma.spring.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;

import coma.spring.dto.MemberDTO;
import coma.spring.dto.QuestionDTO;
import coma.spring.service.MsgService;
import coma.spring.service.QuestionService;

@Controller
@RequestMapping("/question/")
public class QuestionController {
	@Autowired
	private QuestionService qservice;
	
	@Autowired
	private MsgService msgservice;
	
	@Autowired
	private HttpSession session;
	
	@ExceptionHandler
	public String exceptionHandler(NullPointerException npe){
		npe.printStackTrace();
		System.out.println("NullPointerException Handler : 에러가 발생하였습니다.");
		return "member/loginview";
	}
	
	@RequestMapping("question_list")
	public String question_list(HttpServletRequest request)throws Exception{
		MemberDTO mdto = (MemberDTO) session.getAttribute("loginInfo");
		String msg_receiver=mdto.getId();
		System.out.println(msg_receiver+"의 1:1문의");
		if(session.getAttribute("qcpage")==null) {
			session.setAttribute("qcpage", 1);
		}
		try {
			session.setAttribute("qcpage", Integer.parseInt(request.getParameter("qcpage")));
		}catch(Exception e) {}
		int qcpage = (int)session.getAttribute("qcpage");
		List<QuestionDTO> qdto = qservice.selectByQuestion(qcpage, msg_receiver);
		String navi = qservice.QuestionNavi(qcpage, msg_receiver);
		request.setAttribute("navi", navi);
		request.setAttribute("list", qdto);
		
		return "question/mypage_question";
	}
	//문의 보기
	@RequestMapping("questionView")
	public String QuestionView(HttpServletRequest request,int msg_seq)throws Exception{
		QuestionDTO qdto = qservice.selectBySeq(msg_seq);
		
		request.setAttribute("qdto", qdto);
		return "question/questionView";
	}
	

	//1:1문의 보내기
	@RequestMapping("insertQuestion")
	public String insertQuestion(QuestionDTO qdto)throws Exception{
		MemberDTO mdto=(MemberDTO)session.getAttribute("loginInfo");
		String msg_sender = mdto.getId();
		//보낸 사람 넣기
		qdto.setMsg_sender(msg_sender);
		qdto.setMsg_title("[1:1문의]"+qdto.getMsg_title());
		int result = qservice.insertQuestion(qdto);
		if(result==1) {
			return "msg/msgWriteResult";
		}else {
			return "error";
		}
		
	}
	//문의작성
	@RequestMapping("question_write")
	public String question_write(){
		return "question/writeQuestion";
	}
	
	//문의삭제
	@RequestMapping("QuestionReceiverDel")
	public String ReceiverDel(int msg_seq)throws Exception{
		int result = msgservice.receiver_del(msg_seq);
		
		return "redirect:question_list?qcpage=1";
	}
}