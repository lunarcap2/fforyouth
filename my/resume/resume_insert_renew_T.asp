<%@  codepage="949" language="VBScript" %>
<%
 Option Explicit
 Session.CodePage = 949
 Response.ChaRset = "EUC-KR"
%>
<%
'============================================================
'	�̷¼� ����(�Է�/����) : �ܰ躰(step), �Ϸ�� �̷¼� ����
'
'	#�����ۼ���	: 2009-12-07
'	#�ۼ���		: �ӱ���(gidol@career.co.kr)
'============================================================
'Response.Buffer= True

'------ ������ �⺻���� ����.
g_MenuID = "110101"
'redir = ""	'�ѹ�URL�� �����������̸� �������� ������.
%>
<!--#include virtual = "/common/common.asp"-->
<% Call FN_LoginLimit("1")    '����ȸ���� ���ٰ��� %>

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

Dim complete_rid    '�Ϸ�� �̷¼� ��Ϲ�ȣ
Dim resumeIsComplete : resumeIsComplete = Request.Form("resumeIsComplete")
Dim isBaseResume : isBaseResume = Request.Form("isBaseResume")

Dim ii, seq
Dim retUrl, ret_val, execRid, res_seq
Dim self_intro, jc_code_all, ct_code_all






'Response.write "rid : " & arrParams2_career(0, 0)(0) & "<br>"
'Response.write "step : " & arrParams2_career(0, 0)(1) & "<br>"
'Call execResumeCareer(DBCon, arrParams2_career(0, 0), "", "") '��ü����  error
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

Response.write Request.Form("univ_name").count & "<br>"
seq=1
For ii=1 To Request.Form("univ_name").count
	If Request.Form("univ_name")(ii) <> "" Then
		Response.write seq & "<br>"
		Response.write Request.Form("univ_kind")(ii)	 			& "<br>"
		Response.write Request.Form("univ_name")(ii)				& "<br>"
		Response.write Request.Form("univ_depth")(ii)				& "<br>"
		Response.write Request.Form("univ_major")(ii)				& "<br>"
		Response.write Request.Form("univ_syear")(ii)				& "<br>"
		Response.write Request.Form("univ_eyear")(ii)				& "<br>"
		Response.write Request.Form("univ_point")(ii)				& "<br>"
		Response.write Request.Form("univ_pointavg")(ii)			& "<br>"
		Response.write Request.Form("univ_code")(ii)				& "<br>"
		Response.write Request.Form("univ_major_code")(ii)			& "<br>"
		Response.write Request.Form("univ_smonth")(ii)				& "<br>"
		Response.write Request.Form("univ_emonth")(ii)				& "<br>"
		Response.write Request.Form("univ1_grd")(ii)				& "<br>"
		Response.write Request.Form("univ_stype")(ii)				& "<br>"
		Response.write Request.Form("univ_etype")(ii)				& "<br>"
		Response.write Request.Form("univ_area")(ii)				& "<br>"
		Response.write Request.Form("univ_minor")(ii)				& "<br>"
		Response.write Request.Form("univ_minornm")(ii)				& "<br>"
		Response.write Request.Form("univ_minor_code")(ii)			& "<br>"
		Response.write Request.Form("univ_mdepth")(ii)				& "<br>"
		Response.write Request.Form("gde")(ii)					    & "<br>"
		Response.write ""											& "<br>"
		Response.write Request.Form("univ_research")(ii)			& "<br>"
		'Call execResumeSchool(DBCon, arrParamsSchool(2, seq, ii, Request.Form("univ_kind")(ii)), "", "")
		seq = seq+1
	End If
Next

'Response.end


g_debug = False

	if rtype = "T" and CK_ResumeCnt >= 10 and rid = 0 then
		ShowAlertMsg "�̷¼��� 10������ ����� �����մϴ�.", "location.replace('"& mydir &"/resume/resume_list.asp');", True
	end if

    self_intro = Request.Form("self_intro")
	self_intro = CareerEnCrypt(self_intro)
	
	'ConnectDBTrans DBCon, Application("DBInfo_FAIR")
	ConnectDB DBCon, Application("DBInfo_FAIR")

		'--��������
		Call execResumeCommon(DBCon, arrParams1_1(), "", "")

		'--�̷¼�1,2
		rid = execResumeResumeNew(DBCon, arrParams10(), "", "")

		'--���� �ڱ�Ұ�
		Call execResumeSelfIntro(DBCon, Array(rid,user_id,stp,self_intro), "", "")

		'--����/���
		Call execResumePariotHandicap(DBCon, arrParams1_4(), "", "")

		'--��������� ���
		ret_val = regReNewalResume_EmploymentSupport(DBCon, arrParams1_EmpSupport(), "", "")

		'--����
		Call execResumeMilitary(DBCon, arrParams1_3(), "", "")

		'--����ٹ���
		Call execResumeWorkArea(DBCon, arrParams1_7(), "", "")

		'--����ٹ�����
		Call execResumeWorkStyle(DBCon, arrParams1_8(), "", "")

		'--�з�
		Call execResumeSchool(DBCon, arrParamsSchool(1,0,1,1), "", "")
		seq=1
		For ii=1 To Request.Form("univ_name").count
			If Request.Form("univ_name")(ii) <> "" Then
				Call execResumeSchool(DBCon, arrParamsSchool(2, seq, ii, Request.Form("univ_kind")(ii)), "", "")
				seq = seq+1
			End If
		Next

		'--���
		Call execResumeCareer(DBCon, arrParams2_career(0, 0), "", "") '��ü����  error
		seq=1
		For ii=1 To Request.Form("experience_corp_name").count
			If Request.Form("experience_corp_name")(ii) <> "" Then
				Call execResumeCareer(DBCon, arrParams2_career(seq,ii), "", "")
				seq = seq+1
			End If
		Next

		'--�ֿ�Ȱ������
		Call delReNewalResume_ActivityAll(DBCon, rid, rtype, "", "")
		for ii=1 to request.form("rac_type").count
			if request.form("rac_type")(ii) <> "" Then
				ret_val = regReNewalResume_Activity(DBCon, arrParams2_Activity(ii), "", "")	' �ֿ�Ȱ������ ���(�̷¼�����201103)				
				if request.form("temp_save_flag") = "Y" and ret_val > 0 then
				end if
			end if
		Next
		
		'--�������/Ű����
	    Call execResumeJcCodeKeyword(DBCon, arrParamsHopeJc(), "", "")

		'--�������/Ű����
	    Call execResumeCtCodeKeyword(DBCon, arrParamsHopeCt(), "", "")
		
		'--�������,���� �̷¼� ���̺� �ݿ� (����Ʈ,�� ����)
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

		'--�ڰ���
		Call execResumeLicense(DBCon, arrParams3_2(0, 0), "", "")
		seq=1
		For ii=1 To Request.Form("license_name").count
			If Request.Form("license_name")(ii) <> "" Then
				Call execResumeLicense(DBCon, arrParams3_2(seq,ii), "", "")
				seq = seq+1
			End If
		Next

		'--���дɷ�(ȸȭ)
		Call execResumeLanguageUse(DBCon, arrParams3_3(0, 0), "", "")
		seq=1
		For ii=1 To Request.Form("language_name").count
			If Request.Form("language_name")(ii) <> "" Then
				Call execResumeLanguageUse(DBCon, arrParams3_3(seq,ii), "", "")
				seq = seq+1
			End If
		Next

		'--���н���(���ν���)
		Call execResumeLanguageExam(DBCon, arrParams3_4_renew(0, 0), "", "")
		seq=1
		For ii=1 To Request.Form("language_exam_group").count
			If Request.Form("language_exam_group")(ii) <> "" Then
				Call execResumeLanguageExam(DBCon, arrParams3_4_renew(seq,ii), "", "")
				seq = seq+1
			End If
		Next

		'--�ؿܿ���
		Call execResumeAbroad(DBCon, arrParams3_5(0, 0), "", "")
		seq=1
		For ii=1 To Request.Form("abroad_nation_code").count
			If Request.Form("abroad_nation_code")(ii) <> "" Then
				Call execResumeAbroad(DBCon, arrParams3_5(seq,ii), "", "")
				seq = seq+1
			End If
		Next

		'--�����̼�
		Call execResumeAcademy(DBCon, arrParams3_6(0, 0), "", "")
		seq=1
		For ii=1 To Request.Form("academy_org_name").count
			If Request.Form("academy_org_name")(ii) <> "" Then
				Call execResumeAcademy(DBCon, arrParams3_6(seq,ii), "", "")
				seq = seq+1
			End If
		Next

		'--���󳻿�
		Call execResumePrize(DBCon, arrParams3_7(0, 0), "", "")
		seq=1
		For ii=1 To Request.Form("prize_org_name").count
			If Request.Form("prize_org_name")(ii) <> "" Then
				Call execResumePrize(DBCon, arrParams3_7(seq,ii), "", "")
				seq = seq+1
			End If
		Next

		'--��Ʈ������
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

		'--�ڱ�Ұ���
		Call regReNewalResume_Essay_Del(DBCon, rid, "", "")
		seq=1
		for ii=1 to Request.Form("res_seq").count
			if request.form("res_content")(ii) <> "" Then
				res_seq = regReNewalResume_Essay(DBCon, arrParams4_EssayReNew(seq, ii), "", "")
				seq = seq + 1
			end if
		Next

		If resumeIsComplete = "1" Then '�߰������� �ƴҰ�츸 �Ϸ�κ�
			if rtype = "T" then
				'--�̷¼� ��ϿϷ� (�̷¼� �̵� : �߰����� -> �Ϸ� �̷¼�)
				rid = execResumeRegCompleteNew(DBCon, Array(rid,user_id,stp), "", "")
				
				'--�̷¼� �Ǽ� +1 ��Ű����
				Call setCookie(site_code & "WKP_F", "CK_ResumeCnt", "career.co.kr", CK_ResumeCnt + 1)
			end If
		End If

		Call execResumeMonth(DBCon, Array(rid, "", ""), "", "") '�̷¼� ��¿��� update

	'DisconnectDBTrans DBCon
	DisconnectDB DBCon


	if rtype = "T" Then		
		If resumeIsComplete = "2" Then '�߰������ϰ��
			Response.Write "<script>parent.document.frm1.rid.value =" & rid & ";alert('�ӽ������� �Ϸ�Ǿ����ϴ�.');</script>"
			Response.End
		ElseIf resumeIsComplete = "3" Then '�߰����� �̸�����
			Response.Write "<script>parent.document.frm1.rid.value =" & rid & "; parent.fn_resume_preview(); </script>"
			Response.End
		Else
			If isBaseResume = "1" Then
			Response.write "<script>alert('�̷¼� ����� �Ϸ�Ǿ����ϴ�.\nä�� ��ȸ�� ���̱� ���Ͽ� ���»� �λ������� �������Ǹ� ���� �� �ֵ��� ���������� ��Ź�帳�ϴ�.'); location.href='/my/resume_list.asp?open_chk=Y';</script>"
			Else
			Response.write "<script>alert('�̷¼� ����� �Ϸ�Ǿ����ϴ�.'); location.href='/my/resume_list.asp';</script>"
			End If 
			Response.End
		End If
	Else
		If resumeIsComplete = "2" Then '�߰������ϰ��
			Response.Write "<script>parent.document.frm1.rid.value =" & rid & ";alert('�ӽ������� �Ϸ�Ǿ����ϴ�.');</script>"
			Response.End
		ElseIf resumeIsComplete = "3" Then '�߰����� �̸�����
			Response.Write "<script>parent.document.frm1.rid.value =" & rid & "; parent.fn_resume_preview();</script>"
			Response.End
		Else
			If isBaseResume = "1" Then
			Response.write "<script>alert('�̷¼� ������ �Ϸ�Ǿ����ϴ�.\nä�� ��ȸ�� ���̱� ���Ͽ� ���»� �λ������� �������Ǹ� ���� �� �ֵ��� ���������� ��Ź�帳�ϴ�.'); location.href='/my/resume_list.asp?open_chk=Y';</script>"
			Else
			Response.write "<script>alert('�̷¼� ������ �Ϸ�Ǿ����ϴ�.'); location.href='/my/resume_list.asp';</script>"
			End If 
			Response.End
		End If
	End If
%>