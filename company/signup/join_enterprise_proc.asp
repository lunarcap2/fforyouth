<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual="/common/common.asp"-->
<!--#include virtual="/wwwconf/function/library/KISA_SHA256.asp"-->
<%
'--------------------------------------------------------------------
'   Comment		: ���ȸ�� ����
' 	History		: 2020-04-24, �̻��� 
'---------------------------------------------------------------------
Session.CodePage  = 949			'�ѱ�
Response.CharSet  = "euc-kr"	'�ѱ�
Response.AddHeader "Pragma","no-cache"
Response.AddHeader "cache-control", "no-staff"
Response.Expires  = -1


Response.AddHeader "P3P", "CP='ALL CURa ADMa DEVa TAIa OUR BUS IND PHY ONL UNI PUR FIN COM NAV INT DEM CNT STA POL HEA PRE LOC OTC'"

Dim txtCompNum, compno_check, txtEmpCnt, selCompType, txtCompName, txtBossName, hidZipCode, txtCompAddr, txtCompAddrDetail
txtId, txtPass, txtName, txtEmail, chkAgrMail, txtPhone, chkAgrSms, encPass, len_txtPhone, strPhone


txtCompNum	= Request("txtCompNum")		' ����ڹ�ȣ


compno_check		= Request("compno_check")	' ������� ���� ��� üũ ������(0: �ſ��򰡻� ȸ������ ���� X, 1: �ſ��򰡻� ȸ������ ���� O)
txtEmpCnt			= Request("txtEmpCnt")		' �����
selCompType			= Request("selCompType")	' �������
txtCompName			= Replace(Request("txtCompName"), "'", "''")		' �����
txtBossName			= Replace(Request("txtBossName"), "'", "''")		' ��ǥ�ڸ�
hidZipCode			= Replace(Request("hidZipCode"), "'", "''")			' ȸ������ȣ
txtCompAddr			= Replace(Request("txtCompAddr"), "'", "''")		' ȸ���ּ�
txtCompAddrDetail	= Replace(Request("txtCompAddrDetail"), "'", "''")	' ȸ���ּһ�

txtId				= Replace(Request("txtId"), "'", "''")		' ���̵�
txtPass				= Replace(Request("txtPass"), "'", "''")	' ��й�ȣ	
txtName				= Replace(Request("txtName"), "'", "''")	' �̸�
txtEmail			= RTrim(LTrim(LCase(Replace(Request("txtEmail"), " ", ""))))	' �̸���
chkAgrMail			= Request("chkAgrMail")		' ȫ���� ���� ���� ����
txtPhone			= Request("txtPhone")		' �޴�����ȣ
chkAgrSms			= Request("chkAgrSms")		' ȫ���� ���� ���� ����


encPass = SHA256_Encrypt(txtPass)	' ��� ��ȣȭ(sha256 ���)

' ����ó�� ������ ������ ��� ���� ����
If InStr(txtPhone,"-")=0 Then 
	len_txtPhone	= Len(txtPhone)
	strPhone		= Left(txtPhone,3)&"-"&Mid(txtPhone,4,len_txtPhone-7)&"-"&Right(txtPhone,4)
Else 
	strPhone		= txtPhone
End If 


' �������� ��η� �̵����� ���� ��� ȸ������ ȭ������ ����
If Len(txtId) = 0 Or Len(txtPass) = 0 Or Len(txtCompNum) = 0 Then Response.Write "<meta http-equiv='refresh' content='0; url=http://" & Request.ServerVariables("SERVER_NAME") & "/company/signup/join.asp'>"
	

ConnectDB DBCon, Application("DBInfo_FAIR")


ConnectDB DBCon2, Application("DBInfo")
' ����ڵ�Ϲ�ȣ�� �ſ��򰡱�� ���� ������� ������ �Ϸ�� ��� ���� �� ����
If compno_check="1" Then 	
    strSql = "SELECT BizName, BossName, ZipCode, AddrKor, Workforce, BizScale, GoodsName, CreateDate " &_
	          "FROM T_NICE_COMVIEW_NEW WITH(NOLOCK) "&_
	          "WHERE BizRegCode='"& txtCompNum &"'"
	Rs.Open strSql, DBCon2, adOpenForwardOnly, adLockReadOnly, adCmdText
	Dim flagRs : flagRs = False 
	If Rs.eof = False And Rs.bof = False Then
		flagRs		= True 
		BizName		= Rs(0)	' ȸ���
		BossName	= Rs(1)	' ��ǥ�ڸ�
		ZipCode		= Rs(2)	' ȸ������ȣ
		AddrKor		= Rs(3)	' ȸ���ּ�
		Workforce	= Rs(4)	' �����
		BizScale	= Rs(5)	' �������
		GoodsName	= Rs(6)	' �ֿ� �������
		CreateDate	= Rs(7) ' ������
	End If
	
	txtCompName = BizName
	txtBossName	= BossName
	hidZipCode	= ZipCode
	txtCompAddr	= AddrKor
	txtEmpCnt	= Workforce
	selCompType	= BizScale
Else 
	txtCompName = txtCompName
	txtBossName	= txtBossName
	hidZipCode	= hidZipCode
	txtCompAddr	= txtCompAddr&" "&txtCompAddrDetail
	txtEmpCnt	= txtEmpCnt
	selCompType	= selCompType
End If 
DisconnectDB DBCon2

		

' �Է� ���̵� �ߺ� üũ
SpName="usp_ID_CheckAll"
	Dim chkparam(1)
	chkparam(0)=makeParam("@user_id", adVarChar, adParamInput, 20, txtId)
	chkparam(1)=makeParam("@rtn", adChar, adParamOutput, 1, "")

	Call execSP(DBCon, SpName, chkparam, "", "")

	rsltCmt = getParamOutputValue(chkparam, "@rtn")



If rsltCmt = "O" Then ' �Է��� ���̵�� ���� ���Ե� ������ ������ ȸ�� ����

		' ȸ������ ���
		sql = "SET NOCOUNT ON;"
		sql = sql &" INSERT INTO ȸ������ ("
		sql = sql &" ȸ���, ��ǥ�ڼ���, ����ڵ�Ϲ�ȣ, �����ȣ, �ּ�, �ֿ�������, �����, ����, ȸ����̵�, ��ȣȭ_��й�ȣ, ����ڼ���, ���ڿ���, ������޴���, �̺�Ʈȫ������, SMS����, ��������, ����Ʈ����, ���Ի���Ʈ�����ڵ�, ȸ����, �����, ������"
		sql = sql &" ) VALUES ("
		sql = sql &" '"&txtCompName&"', '"&txtBossName&"', '"&txtCompNum&"', '"&hidZipCode&"', '"&txtCompAddr&"', '"&GoodsName&"', '"&txtEmpCnt&"', '"&selCompType&"', '"&txtId&"', '"&encPass&"', '"&txtName&"', '"&txtEmail&"', '"&strPhone&"', '"&chkAgrMail&"', '"&chkAgrSms&"', '" & CreateDate & "', 'W', '2', 'B', getdate(), getdate()"
		sql = sql &" );"
		DBCon.Execute(sql)

		' ����� ���� ��������� ���� ��� ���� ��� > ������� �� ������ ���� �̽��� �̻��, ����翡 ��ϵ� ��������� �־�߸� ȸ������ ����
		If compno_check="0" Then 
			sql2 = "SET NOCOUNT ON;"
			sql2 = sql2 &" INSERT INTO ȸ������_������ ("
			sql2 = sql2 &" ȸ���, ��ǥ�ڸ�, ����ڵ�Ϲ�ȣ, �����ȣ, ȸ���ּ�, �����, �������"
			sql2 = sql2 &" ) VALUES ("
			sql2 = sql2 &" '"&txtCompName&"', '"&txtBossName&"', '"&txtCompNum&"', '"&hidZipCode&"', '"&txtCompAddr&"', '"&txtEmpCnt&"', '"&selCompType&"'"
			sql2 = sql2 &" );"
			DBCon.Execute(sql2)
		End If 

		DisconnectDB DBCon

	
'	If sp_rtn = "O" Then	' ���� ���� �Ϸ� �� �ڵ��α��� ó��
		'#### ���ȸ������ ��Ű �Ҵ�
		Response.Cookies(site_code & "WKC_F")("comid")		= txtId
		Response.Cookies(site_code & "WKC_F")("comname")	= txtCompName
		Response.Cookies(site_code & "WKC_F")("comemail")	= txtEmail
		Response.Cookies(site_code & "WKC_F").Domain		= "career.co.kr"
		
		' ��Ʈ�� ���� ��ο� ���� ä��� ���� ������ ����(������ġ - W: �ϰ���, D: ������)
		Dim set_url

		set_url = "location.href='/default.asp';"

		Response.Write "<script language=javascript>"&_
			"alert('���ȸ�� ������ �Ϸ�Ǿ����ϴ�.');"&_
			set_url &_
			"</script>"
		Response.End 
'	Else ' ȸ�� ���� ���� �� ���� �߻� ����
'		Response.Write "<script language=javascript>"&_
'		 "alert('ȸ������ �� ������ �߻��߽��ϴ�.\n�ٽ� �õ��� �ּ���.');"&_
'		"location.href='http://hkpartner.career.co.kr/company/signup/join.asp';"&_
'		"</script>"
'		response.End 
'	End If

Else	' �Է��� ���̵�� ���Ե� ������ ������ ��� ȸ�� ���� ������ ����
	Response.Write "<script language=javascript>"&_
		"alert('�Է��Ͻ� ���̵�� ���Ե� ������ �����մϴ�.\n�ٸ� ���̵�� �ٽ� �õ��� �ּ���.');"&_
		"location.href='/company/signup/join.asp';"&_
		"</script>"
	Response.End 
End If 
%>
<OBJECT RUNAT="SERVER" PROGID="ADODB.RecordSet" ID="Rs"></OBJECT>