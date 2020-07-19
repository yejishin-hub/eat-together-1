<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<!-- BootStrap4 -->
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.5.1.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
<script
	src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js"></script>
<!-- BootStrap4 End-->
<!-- google font -->
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@500&display=swap"
	rel="stylesheet">
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@500;900&display=swap"
	rel="stylesheet">
<link
	href="https://fonts.googleapis.com/css2?family=Black+Han+Sans&display=swap"
	rel="stylesheet">
<!-- google font end-->
<!-- header,footer용 css  -->
<link rel="stylesheet" type="text/css"
	href="/resources/css/index-css.css">
<!-- header,footer용 css  -->
<!-- loginview css -->
<link rel="stylesheet" type="text/css"
	href="/resources/css/loginview.css">
<!-- loginview css -->

<meta charset="UTF-8">
<title>로그인</title>

</head>

<body>
	<!-- ******************* -->
	<!-- header  -->
	<jsp:include page="/WEB-INF/views/include/header.jsp" />
	<!-- header  -->
	<!-- ******************* -->
	<div id=container class="col-md-12 login-container">
		<h1 class="login_text">로그인</h1>
		<input type=hidden id="loginCheck" value="${loginInfo.id}">
		<form action="/member/login" method=post>
			<div class="login_text">
				<label for="id" class="login_text">아이디</label> <input type="text"
					class="form-control" id="id" name="id">
			</div>
			<div class="login_text">
				<label for="password" class="login_text">Password</label> <input
					type="password" class="form-control" id="pw" name="pw">
			</div>
			<div class="col-md-12 text-center login_text" id="btnBox">
					<button type="submit" id="loginBtn" class="btn btn-warning">로그인</button>
					<button type="button" id="SignupBtn" class="btn btn-secondary">회원가입</button>

					<br>
					<!-- **** 카카오톡 아이디로 로그인 버튼 노출 영역_ 최종테스트에서는 redirect_uri 수정할 필요가 있다 https://eat-together.net/member/kakaoLogin ****-->
					<a
						href="https://kauth.kakao.com/oauth/authorize?client_id=39543f4353dc8ce2c9268fc23c6d67e4&redirect_uri=https://eat-together.net/member/kakaoLogin&response_type=code"
						id="kakaoLoginBtn"> <img
						src="/resources/img/kakao_login_medium_narrow.png">
					</a>
			</div>
			<!-- 카카오톡 아이디로 로그인 버튼 노출 영역 -->
		</form>


		<div id="find-container" class="col-md-12 text-center login_text">
			<div id="findId"
				onclick="window.open('/member/findid','아이디 찾기','width=430,height=500,location=no,status=no,scrollbars=yes');">아이디를
				잊으셨나요?</div>
			<div id="findPw"
				onclick="window.open('/member/findpw','비밀번호 찾기','width=430,height=500,location=no,status=no,scrollbars=yes');">비밀번호를
				잊으셨나요?</div>
		</div>
	</div>

	<script>
		window.onload = function() {

			$("#loginBtn")
					.on(
							"click",
							function() {
								if ($("#id").val() == "") {
									alert("아이디를 입력해주세요.");
									return false;
								} else if ($("#pw").val() == "") {
									alert("비밀번호를 입력해주세요.");
									return false;
								} else {
									//by 지은. 비밀번호 오류 시 유효성 검사하기_20200706
									$
											.ajax({
												url : "/member/isPwCorrect",
												type : 'POST',
												data : {
													id : $("#id").val(),
													pw : $('#pw').val()
												},
												success : function(msg) {
													if (msg == "uncorrect") {
														alert("아이디 또는 비밀번호를 잘못 입력하셨습니다.");
														$("#pw").val("");
														$("#pw").focus();
														location
																.replace("redirect:/member/loginview")
													} else if (msg == "correct") {
														alert("로그인 성공하였습니다.");
														return true;
													}
												},
												error : function(jqXHR,
														textStatus, errorThrown) {
													console
															.log("arjax error : "
																	+ textStatus
																	+ "\n"
																	+ errorThrown);
													console
															.warn(jqxhr.responseText);
													return false;

												}
											});
								}
							})

			if ($("#loginCheck").val() != "") {
				console.log("로그인되어있음");
				location.replace("/");
			}

			$("#SignupBtn").on("click", function() {
				location.replace("/member/signup_check");
			})
		}
	</script>


	<!-- ******************* -->
	<!-- footer  -->
	<jsp:include page="/WEB-INF/views/include/footer.jsp" />
	<!-- footer  -->
	<!-- ******************* -->
</body>
</html>