<%@ codepage="949" language="VBScript" %>

<%
	Option Explicit

	Session.CodePage = 949
	Response.ChaRset = "EUC-KR"
%>

<%
	Response.Buffer = True
	Response.Expires = -1

	'// -- ���� �ٿ�ε�
	Response.ContentType = "application/vdn.ms_excel"
	Response.AddHeader "Content-Disposition","attachment; filename=�̷¼�_��ü����Ʈ.xls"
	Server.ScriptTimeout = 10000
	g_MenuID = "100000"
%>

<!--#include virtual = "/common/common.asp"-->

<!--#include virtual = "/wwwconf/code/code_function_ac.asp"-->
<!--#include virtual = "/wwwconf/code/code_function_jc.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->

<%
	' ���ȸ���� ���ٰ���
	Call FN_LoginLimit("2")
%>

<%
	'Response.write "mode : " & Request("mode") & "<br>"
	'Response.write "jid : " & Request("jid") & "<br>"
	'Response.write "pid : " & Request("pid") & "<br>"
	'Response.write "page : " & Request("page") & "<br>"
	'Response.write "psize : " & Request("psize") & "<br>"

	Dim mode, jid, pid, sch_kw, sch_gb, isRead, sch_sc, sch_ex, sch_area, sch_age, chk_1, chk_2, chk_3, chk_4, so1, so2, so3, page, psize
	Dim spName, arrRs
	ReDim param(24)
	
	mode		= Request("mode")
	jid			= Request("jid")
	pid			= Request("pid")
	sch_kw		= Request("sch_kw")
	sch_gb		= Request("sch_gb")
	isRead		= Request("isRead")
	sch_sc		= Request("sch_sc")
	sch_ex		= Request("sch_ex")
	sch_area	= Request("sch_area")
	sch_age		= Request("sch_age")
	chk_1		= Request("chk_1")
	chk_2		= Request("chk_2")
	chk_3		= Request("chk_3")
	chk_4		= Request("chk_4")
	so1			= Request("so1")
	so2			= Request("so2")
	so3			= Request("so3")
	page		= Request("page")
	psize		= Request("psize")

	ConnectDB DBCon, Application("DBInfo_FAIR")	

	spName = "usp_�������_�Ի�������_���2"

	param(0)  = makeParam("@mode",			adVarchar, adParamInput, 10, mode) '--ing:����, cl:����
	param(1)  = makeParam("@jid",			adVarchar, adParamInput, 30, jid)
	param(2)  = makeParam("@pid",			adVarchar, adParamInput, 30, pid)
	param(3)  = makeParam("@sch_kw",		adVarchar, adParamInput, 30, sch_kw)
	param(4)  = makeParam("@sch_gb",		adVarchar, adParamInput, 30, sch_gb)
	param(5)  = makeParam("@isRead",		adVarchar, adParamInput, 30, isRead)
	param(6)  = makeParam("@sch_sc",		adVarchar, adParamInput, 30, sch_sc)
	param(7)  = makeParam("@sch_ex",		adVarchar, adParamInput, 30, sch_ex)
	param(8)  = makeParam("@sch_area",		adVarchar, adParamInput, 30, sch_area)
	param(9)  = makeParam("@sch_age",		adVarchar, adParamInput, 30, sch_age)
	param(10) = makeParam("@chk_1",			adVarchar, adParamInput, 30, chk_1)
	param(11) = makeParam("@chk_2",			adVarchar, adParamInput, 30, chk_2)
	param(12) = makeParam("@chk_3",			adVarchar, adParamInput, 30, chk_3)
	param(13) = makeParam("@chk_4",			adVarchar, adParamInput, 30, chk_4)
	param(14) = makeParam("@so1",			adVarchar, adParamInput, 50, so1) '������ desc, ������ȣ desc
	param(15) = makeParam("@so2",			adVarchar, adParamInput, 30, so2)
	param(16) = makeParam("@so3",			adVarchar, adParamInput, 30, so3)

	param(17) = makeParam("@PageSize",		adInteger, adParamInput, 4 , psize)
	param(18) = makeParam("@Page",			adInteger, adParamInput, 4 , page)
	param(19) = makeParam("@sch_method",	adVarchar, adParamInput, 1 , "")
	param(20) = makeParam("@formtype",		adVarchar, adParamInput, 2 , "")
	param(21) = makeParam("@TotalCount",	adInteger, adParamOutput, 4 , 0)
	param(22) = makeParam("@TotalCount1",	adInteger, adParamOutput, 4 , 0)
	param(23) = makeParam("@TotalCount2",	adInteger, adParamOutput, 4 , 0)
	param(24) = makeParam("@TotalCount3",	adInteger, adParamOutput, 4 , 0)

	arrRs = arrGetRsSP(dbCon, spName, param, "", "")

	'response.write 	mode		& "<br>"
	'response.write 	jid			& "<br>"
	'response.write 	pid			& "<br>"
	'response.write 	sch_kw		& "<br>"
	'response.write 	sch_gb		& "<br>"
	'response.write 	isRead		& "<br>"
	'response.write 	sch_sc		& "<br>"
	'response.write 	sch_ex		& "<br>"
	'response.write 	sch_area	& "<br>"
	'response.write 	sch_age		& "<br>"
	'response.write 	chk_1		& "<br>"
	'response.write 	chk_2		& "<br>"
	'response.write 	chk_3		& "<br>"
	'response.write 	chk_4		& "<br>"
	'response.write 	so1			& "<br>"
	'response.write 	so2			& "<br>"
	'response.write 	so3			& "<br>"
	'response.write 	page		& "<br>"
	'response.write 	psize		& "<br>"

	'Response.write "EXEC usp_�������_�Ի�������_���2 " & "'" & mode & "', " & "'" & jid & "', " & "'" & pid & "', " & "'" & sch_kw & "', " & "'" & sch_gb & "', " & "'" & isRead & "', " & "'" & sch_sc & "', " & "'" & sch_ex & "', " & "'" & sch_area & "', " & "'" & sch_age & "', " & "'" & chk_1 & "', " & "'" & chk_2 & "', " & "'" & chk_3 & "', " & "'" & chk_4 & "', " & "'" & so1 & "', " & "'" & so2 & "', " & "'" & so3 & "', " & "'" & psize & "', " & "'" & page & "', '', '', '', '', '', ''"
	'Response.end

	If Not IsArray(arrRs) Then
		DisconnectDB DBCon
		ShowAlertMsg "�ٿ�ε� �� �����Ͱ� �����ϴ�.", "history.back();", True
	End If

	'---------------------------------- ���� �⺻ �׸� ���� ----------------------------------
	Dim objDicResume : Set objDicResume = Server.CreateObject("Scripting.Dictionary")
%>

<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40">
	<head>
		<meta http-equiv=Content-Type content="text/html; charset=ks_c_5601-1987">
		<meta name=ProgId content=Excel.Sheet>
		<meta name=Generator content="Microsoft Excel 11">
		<link rel=File-List href="�̷¼�_��ü����Ʈ.files/filelist.xml">
		<link rel=Edit-Time-Data href="�̷¼�_��ü����Ʈ.files/editdata.mso">
		<link rel=OLE-Object-Data href="�̷¼�_��ü����Ʈ.files/oledata.mso">
		<title>�̷¼� ��ü����Ʈ</title>
	</head>

	<body>
		<table border="1">
			<tr>
				<td bgcolor="CCCCCC" align="center">No</td>
				<td bgcolor="CCCCCC" align="center">�������</td>
				<td bgcolor="CCCCCC" align="center">�̸�</td>
				<td bgcolor="CCCCCC" align="center">�������(����)</td>
				<td bgcolor="CCCCCC" align="center">�̷¼�����</td>
				<td bgcolor="CCCCCC" align="center">��³��</td>
				<td bgcolor="CCCCCC" align="center">�������</td>
				<td bgcolor="CCCCCC" align="center">�����з�</td>
				<td bgcolor="CCCCCC" align="center">�������</td>
				<td bgcolor="CCCCCC" align="center">������</td>
				<td bgcolor="CCCCCC" align="center">��������</td>
				<td bgcolor="CCCCCC" align="center">����</td>
			</tr>

			<%
				If IsArray(arrRs) Then
					Dim i
					
					For i=0 To UBound(arrRs,2)
					
					' �������
					Dim applytype
					Select Case arrRs(48,i)
						Case "A" : applytype = "�¶��� �̷¼�"
						Case "B" : applytype = "�������"
						Case "C" : applytype = "�ڻ���"
					End Select 
					
					' �������/����
					Dim resume_birth, resume_birth_year, resume_age
					If arrRs(2,i) <> "" Then
						If arrRs(3,i) = "3" Or arrRs(3,i) = "4" Or arrRs(3,i) = "7" Or arrRs(3,i) = "8" Then
							resume_birth_year	= "20" & Left(arrRs(2,i),2)
							resume_birth		= "20" & arrRs(2,i)
						Else 
							resume_birth_year	= "19" & Left(arrRs(2,i),2)
							resume_birth		= "19" & arrRs(2,i)
						End If
					
						resume_age	= year(date) - resume_birth_year + 1
					End If
					
					' �̷¼�����
					Dim tit
					If arrRs(48,i) = "A" Then
						tit = arrRs(23,i)
					Else
						tit = arrRs(49,i)
					End If
					
					'���ǥ��
					Dim career_str, tot_sum
					
					tot_sum = Abs(arrRs(12, i))
					
					If tot_sum = "0" Then 
						career_str = "����"
					ElseIf tot_sum > 12 Then
						career_str = fix(tot_sum / 12) & "�� " & tot_sum mod 12 & "����"
					Else 
						career_str = tot_sum & "����"
					End If
					
					' �������
					Dim strjc
					If arrRs(10, i) <> "" Then
						strjc = Replace(getJobTypeAll(arrRs(10, i)),"/",",")
					End If
					
					' �����з�
					Dim strFinalSchool
					Select Case arrRs(9, i)
						Case "3" : strFinalSchool = "����б�"
						Case "4" : strFinalSchool = "����(2,3��)"
						Case "5" : strFinalSchool = "���б�(4��)"
						Case "6" : strFinalSchool = "���п�"
					End Select 
					
					' �������
					Dim workArea, workAreaDetail, ii, jj, strArea
					If arrRs(15, i) <> "" Then									
						workArea = split(arrRs(15, i), "|") 
					
						For ii=0 To Ubound(workArea)
							workAreaDetail = split(workArea(ii), "/")
					
							For jj=0 To Ubound(workAreaDetail)
								If jj = 0 Then
									strArea = strArea & get_simple_Ac(getAcName(workAreaDetail(jj)))
								End If
							Next
							
							If ii <> Ubound(workArea)  Then
								strArea = strArea & ", "
							Else
								strArea = strArea & ""
							End If
						Next
					End If
					
					'�հݻ���
					Dim statusNm
					Select Case arrRs(29, i)
						Case "1" : statusNm = "�ɻ���"
						Case "2" : statusNm = "������"
						Case "3" : statusNm = "�����հ�"
						Case "4" : statusNm = "�����հ�"
						Case "5" : statusNm = "���հ�"
					End Select 
					
					'�̷¼� ��������
					Dim isopen
					Select Case arrRs(31, i)
						Case "1" : isopen = "����"
						Case "0" : isopen = "�̿���"
					End Select
			%>
			<tr>
				<td><%=i+1%></td>
				<td><%=applytype%></td>
				<td><%=arrRs(0,i)%></td>
				<td><%=resume_birth%>(<%=resume_age%>��)</td>
				<td><%=tit%></td>				
				<td><%=career_str%></td>
				<td><%=strjc%></td>
				<td><%=strFinalSchool%></td>
				<td><%=strArea%></td>
				<td><%=arrRs(30, i)%></td>
				<td><%=isopen%></td>
				<td><%=statusNm%></td>
			</tr>
			<%
					Next
				End If
			%>
		</table>
	</body>
</html>

<%
	Response.flush
	DisconnectDB DBCon
	Set objDicResume = Nothing
%>