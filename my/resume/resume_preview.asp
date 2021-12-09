<%
option Explicit

'------ 페이지 기본정보 셋팅.
g_MenuID = "010001"  '앞 두 숫자는 lnb 페이지명, 맨 뒤 숫자는 메뉴 이미지 파일명에 참조
g_MenuID_Navi = "0,1"  '내비게이션 값
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header.asp"-->
<%
Call FN_LoginLimit("1")	'개인회원 허용

Dim stp     : stp = 1					'이력서 단계
Dim rid     : rid = request("rid")		'이력서 등록번호 (rid가 있으며 수정)
Dim rtype   : rtype = "T"				'이력서 구분(T:중간저장, C:완료)
Dim cflag   : cflag = request("cflag")	'신입/경력 구분. 1/8 로 현재값과 동일
Dim set_user_id '다른 사용자의 이력서를 보기위한 사용자아이디
Dim apply_resume

If rid = "" Or rid = "0" Then
	ShowAlertMsg "잘못된 접근입니다.", "window.close();", True
End If

Dim i, ii
Dim v_pop_yn, v_menu_data, v_menu_file
v_pop_yn = "Y"
v_menu_data = "N" '이력서수정, 오늘날짜 업데이트
v_menu_file = "N" '인쇄, word/pdf 다운로드
%>
<!--#include virtual = "/wwwconf/code/code_function.asp"-->
<!--#include virtual = "/wwwconf/code/code_function_ac.asp"-->
<!--#include virtual = "/wwwconf/code/code_function_jc.asp"-->
<!--#include virtual = "/wwwconf/code/code_function_resume.asp"-->
<!--#include virtual = "/wwwconf/code/code_resume.asp"-->

<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/wwwconf/query_lib/user/ResumeInfo.asp"-->
<!--#include virtual = "/my/resume/comm/getResumeStepDBInfo.asp"-->
</head>

<body id="bodyResume">

<!-- 본문 -->
<!--#include file = "./comm/inc_resume_view.asp"-->
<!-- //본문 -->

</body>
</html>
