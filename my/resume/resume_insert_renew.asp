<%@  codepage="949" language="VBScript" %>
<%
 Option Explicit
 Session.CodePage = 949
 Response.ChaRset = "EUC-KR"
%>
<%
'============================================================
'	이력서 저장(입력/수정) : 단계별(step), 완료된 이력서 수정
'
'	#최초작성일	: 2009-12-07
'	#작성자		: 임기정(gidol@career.co.kr)
'============================================================
'Response.Buffer= True

'------ 페이지 기본정보 셋팅.
g_MenuID = "110101"
'redir = ""	'롤백URL이 현재페이지이면 정의하지 마세요.
%>
<!--#include virtual = "/common/common.asp"-->
<% Call FN_LoginLimit("1")    '개인회원만 접근가능 %>

<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/wwwconf/code/code_resume.asp"-->
<!--#include virtual = "/wwwconf/function/common/base_util.asp"-->
<!--#include virtual = "/wwwconf/function/resume/getResumeExecParamsNew.asp"-->
<!--#include virtual = "/wwwconf/query_lib/user/ResumeInfo.asp"-->
<%
Dim svrNm : svrNm = Request.ServerVariables("SERVER_NAME")
Dim myDir : myDir = "/my"
Dim siteGubun : siteGubun = "W"
dim siteDomain : siteDomain = "career.co.kr"
dim siteDomainstr : siteDomainstr = ""
if siteDomain <> "" then	siteDomainstr = "document.domain='" & siteDomain & "';" & vbcrlf


Dim stp : stp = Request.Form("step")
Dim rid : rid = strFix(Request.Form("rid"), "int", 0)
Dim rtype : rtype = Request.Form("rtype")
Dim cflag : cflag = request.form("cflag")
Dim rGubun : rGubun = Request.Form("rGubun")
'If rtype = "C" Then stp = "5"

Dim complete_rid    '완료된 이력서 등록번호
Dim resumeIsComplete : resumeIsComplete = Request.Form("resumeIsComplete")
Dim isBaseResume : isBaseResume = Request.Form("isBaseResume")

Dim ii, seq
Dim retUrl, ret_val, execRid, res_seq
Dim self_intro, jc_code_all, ct_code_all
Dim save_resume_id, complete_resume_id

save_resume_id		= 0
complete_resume_id	= 0




'Response.write "rid : " & arrParams2_career(0, 0)(0) & "<br>"
'Response.write "step : " & arrParams2_career(0, 0)(1) & "<br>"
'Call execResumeCareer(DBCon, arrParams2_career(0, 0), "", "") '전체삭제  error
'Response.write  "<br>"
'
'seq=1
'For ii=1 To Request.Form("experience_corp_name").count
'	If Request.Form("experience_corp_name")(ii) <> "" Then
'
'		Response.write "seq : " & seq & "<br>"
'		Response.write "name : " & Request.Form("experience_corp_name")(ii) & "<br><br>"
'
'
'		Call execResumeCareer(DBCon, arrParams2_career(seq,ii), "", "")
'
'		seq = seq+1
'	End If
'Next


'Response.End 


g_debug = False

	if rtype = "T" and CK_ResumeCnt >= 10 and rid = 0 then
		ShowAlertMsg "이력서는 10개까지 등록이 가능합니다.", "location.replace('"& mydir &"/resume/resume_list.asp');", True
	end if

    self_intro = Request.Form("self_intro")
	self_intro = CareerEnCrypt(self_intro)
	
	'ConnectDBTrans DBCon, Application("DBInfo_FAIR")
	ConnectDB DBCon, Application("DBInfo_FAIR")

		'--공통정보
		Call execResumeCommon(DBCon, arrParams1_1(), "", "")

		'--이력서1,2
		rid = execResumeResumeNew(DBCon, arrParams10(), "", "")

		If rtype = "T" Then
			save_resume_id = rid
		End If

		'--간략 자기소개
		Call execResumeSelfIntro(DBCon, Array(rid,user_id,stp,self_intro), "", "")

		'--보훈/장애
		Call execResumePariotHandicap(DBCon, arrParams1_4(), "", "")

		'--고용지원금 대상
		ret_val = regReNewalResume_EmploymentSupport(DBCon, arrParams1_EmpSupport(), "", "")

		'--병역
		Call execResumeMilitary(DBCon, arrParams1_3(), "", "")

		'--희망근무지
		Call execResumeWorkArea(DBCon, arrParams1_7(), "", "")

		'--희망근무형태
		Call execResumeWorkStyle(DBCon, arrParams1_8(), "", "")

		'--학력
		Call execResumeSchool(DBCon, arrParamsSchool(1,0,1,1), "", "")
		seq=1
		For ii=1 To Request.Form("univ_name").count

			If Request.Form("univ_name")(ii) <> "" Then
				Call execResumeSchool(DBCon, arrParamsSchool(2, seq, ii, Request.Form("univ_kind")(ii)), "", "")
				seq = seq+1
			End If
		Next

		'--경력
		Call execResumeCareer(DBCon, arrParams2_career(0, 0), "", "") '전체삭제  error
		If Request.Form("experience") = "8" Then '신입/경력 경력선택시만 경력저장
		seq=1
		For ii=1 To Request.Form("experience_corp_name").count
			If Request.Form("experience_corp_name")(ii) <> "" Then
				Call execResumeCareer(DBCon, arrParams2_career(seq,ii), "", "")
				seq = seq+1
			End If
		Next
		End If

		'--주요활동사항
		Call delReNewalResume_ActivityAll(DBCon, rid, rtype, "", "")
		for ii=1 to request.form("rac_type").count
			if request.form("rac_type")(ii) <> "" Then
				ret_val = regReNewalResume_Activity(DBCon, arrParams2_Activity(ii), "", "")	' 주요활동사항 등록(이력서개편201103)				
				if request.form("temp_save_flag") = "Y" and ret_val > 0 then
				end if
			end if
		Next
		
		'--희망직종/키워드
	    Call execResumeJcCodeKeyword(DBCon, arrParamsHopeJc(), "", "")

		'--희망업종/키워드
	    Call execResumeCtCodeKeyword(DBCon, arrParamsHopeCt(), "", "")
		
		'--희망업종,직종 이력서 테이블 반영 (리스트,뷰 적용)
	    jc_code_all = Replace(Request.Form("resume_jobcode"),", ","|")
	    ct_code_all = Replace(Request.Form("resume_jobtype"),", ","|")

        redim parameters(4)
	    parameters(0) = makeParam("@userid", adVarchar, adParamInput, 20, user_id)
	    parameters(1) = makeParam("@rid", adInteger, adParamInput, 4, rid)
	    parameters(2) = makeParam("@jc_code_all", adVarchar, adParamInput, 64, jc_code_all)
	    parameters(3) = makeParam("@ct_code_all", adVarchar, adParamInput, 64, ct_code_all)
	    parameters(4) = makeParam("@execRid", adInteger, adParamOutput, 4, 0)

	    Call execSP(DBCon, "usp_resume_ctjc_update", parameters, "", "")
	    execRid = getParamOutputValue(parameters, "@execRid")

		'--자격증
		Call execResumeLicense(DBCon, arrParams3_2(0, 0), "", "")
		seq=1
		For ii=1 To Request.Form("license_name").count
			If Request.Form("license_name")(ii) <> "" Then
				Call execResumeLicense(DBCon, arrParams3_2(seq,ii), "", "")
				seq = seq+1
			End If
		Next

		'--어학능력(회화)
		Call execResumeLanguageUse(DBCon, arrParams3_3(0, 0), "", "")
		seq=1
		For ii=1 To Request.Form("language_name").count
			If Request.Form("language_name")(ii) <> "" Then
				Call execResumeLanguageUse(DBCon, arrParams3_3(seq,ii), "", "")
				seq = seq+1
			End If
		Next

		'--어학시험(공인시험)
		Call execResumeLanguageExam(DBCon, arrParams3_4_renew(0, 0), "", "")
		seq=1
		For ii=1 To Request.Form("language_exam_group").count
			If Request.Form("language_exam_group")(ii) <> "" Then
				Call execResumeLanguageExam(DBCon, arrParams3_4_renew(seq,ii), "", "")
				seq = seq+1
			End If
		Next

		'--해외연수
		Call execResumeAbroad(DBCon, arrParams3_5(0, 0), "", "")
		seq=1
		For ii=1 To Request.Form("abroad_nation_code").count
			If Request.Form("abroad_nation_code")(ii) <> "" Then
				Call execResumeAbroad(DBCon, arrParams3_5(seq,ii), "", "")
				seq = seq+1
			End If
		Next

		'--교육이수
		Call execResumeAcademy(DBCon, arrParams3_6(0, 0), "", "")
		seq=1
		For ii=1 To Request.Form("academy_org_name").count
			If Request.Form("academy_org_name")(ii) <> "" Then
				Call execResumeAcademy(DBCon, arrParams3_6(seq,ii), "", "")
				seq = seq+1
			End If
		Next

		'--수상내역
		Call execResumePrize(DBCon, arrParams3_7(0, 0), "", "")
		seq=1
		For ii=1 To Request.Form("prize_org_name").count
			If Request.Form("prize_org_name")(ii) <> "" Then
				Call execResumePrize(DBCon, arrParams3_7(seq,ii), "", "")
				seq = seq+1
			End If
		Next

		'--포트폴리오
		Call execResumePortfolio(DBCon, arrParams3_Portfolio_1(0, 0), "", "")
		seq=1
		For ii=1 To Request.Form("portfolio_type1").count
			If Request.Form("pf_url_addr")(ii) <> "" Then
				Call execResumePortfolio(DBCon, arrParams3_Portfolio_1(seq,ii), "", "")
				seq = seq+1
			End If
		Next
		For ii=1 To Request.Form("portfolio_type2").count
			If Request.Form("pf_upload_file")(ii) <> "" Then				
				Call execResumePortfolio(DBCon, arrParams3_Portfolio_2(seq,ii), "", "")
				seq = seq+1
			End If
		Next

		'--자기소개서

		'If inside_yn = "Y" Then 
		'	Response.write "rid : " & rid
		'	Response.End 
		'End If 

		Call regReNewalResume_Essay_Del(DBCon, rid, rtype, "", "")
		seq=1
		for ii=1 to Request.Form("res_seq").count
			if request.form("res_content")(ii) <> "" Then
				res_seq = regReNewalResume_Essay(DBCon, arrParams4_EssayReNew(seq, ii), "", "")
				seq = seq + 1
			end if
		Next

		If resumeIsComplete = "1" Then '중간저장이 아닐경우만 완료부분
			if rtype = "T" then
				'--이력서 등록완료 (이력서 이동 : 중간저장 -> 완료 이력서)
				rid = execResumeRegCompleteNew(DBCon, Array(rid,user_id,stp), "", "")
				
				'--이력서 건수 +1 쿠키저장
				Call setCookie(site_code & "WKP_F", "CK_ResumeCnt", "career.co.kr", CK_ResumeCnt + 1)
			end If
		End If

		Call execResumeMonth(DBCon, Array(rid, "", ""), "", "") '이력서 경력월수 update


		'이력서 충실도 업데이트
		ReDim parameter(1)
		parameter(0)    = makeParam("@RID", adInteger, adParamInput, 4, rid)
		parameter(1)    = makeParam("@FAITH", adInteger, adParamOutput, 4, "")
		Call execSP(DBCon, "usp_이력서_충실도_등록수정", parameter, "", "")


		'이력서등록유입체크
		If resumeIsComplete = "1" Or rtype = "C" Then
			complete_resume_id = rid
		End If

		ReDim parameter(3)
		parameter(0)    = makeParam("@gubun", adVarChar, adParamInput, 20, "PC")
		parameter(1)    = makeParam("@userid", adVarChar, adParamInput, 20, user_id)
		parameter(2)    = makeParam("@save_resume_id", adInteger, adParamInput, 4, save_resume_id)
		parameter(3)    = makeParam("@complete_resume_id", adInteger, adParamInput, 4, complete_resume_id)		

		Call execSP(DBCon, "usp_이력서_등록_LOG", parameter, "", "")

	'DisconnectDBTrans DBCon
	DisconnectDB DBCon


	if rtype = "T" Then		
		If resumeIsComplete = "2" Then '중간저장일경우
			Response.Write "<script>parent.document.frm1.rid.value =" & rid & ";alert('임시저장이 완료되었습니다.');</script>"
			Response.End
		ElseIf resumeIsComplete = "3" Then '중간저장 미리보기
			Response.Write "<script>parent.document.frm1.rid.value =" & rid & "; parent.fn_resume_preview(); </script>"
			Response.End
		Else
			If isBaseResume = "1" Then
			Response.write "<script>alert('이력서 등록이 완료되었습니다.\n채용 기회를 높이기 위하여 협력사 인사담당자의 면접제의를 받을 수 있도록 공개설정을 부탁드립니다.'); location.href='/my/resume_list.asp?open_chk=Y';</script>"
			Else
			Response.write "<script>alert('이력서 등록이 완료되었습니다.'); location.href='/my/resume_list.asp';</script>"
			End If 
			Response.End
		End If
	Else
		If resumeIsComplete = "2" Then '중간저장일경우
			Response.Write "<script>parent.document.frm1.rid.value =" & rid & ";alert('임시저장이 완료되었습니다.');</script>"
			Response.End
		ElseIf resumeIsComplete = "3" Then '중간저장 미리보기
			Response.Write "<script>parent.document.frm1.rid.value =" & rid & "; parent.fn_resume_preview();</script>"
			Response.End
		Else
			If isBaseResume = "1" Then
			Response.write "<script>alert('이력서 수정이 완료되었습니다.\n채용 기회를 높이기 위하여 협력사 인사담당자의 면접제의를 받을 수 있도록 공개설정을 부탁드립니다.'); location.href='/my/resume_list.asp?open_chk=Y';</script>"
			Else
			Response.write "<script>alert('이력서 수정이 완료되었습니다.'); location.href='/my/resume_list.asp';</script>"
			End If 
			Response.End
		End If
	End If
%>