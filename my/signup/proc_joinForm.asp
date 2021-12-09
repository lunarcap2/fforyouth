<!--#include virtual = "/common/common.asp"-->
<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual="/wwwconf/function/library/KISA_SHA256.asp"-->
<!--#include virtual = "/wwwconf/function/library/AES256.asp"-->

<%
'--------------------------------------------------------------------
'   Comment		: ����ȸ�� ����
' 	History		: 2020-04-20, �̻��� 
'---------------------------------------------------------------------
Session.CodePage  = 949			'�ѱ�
Response.CharSet  = "euc-kr"	'�ѱ�
Response.AddHeader "Pragma","no-cache"
Response.AddHeader "cache-control", "no-staff"
Response.Expires  = -1


Response.AddHeader "P3P", "CP='ALL CURa ADMa DEVa TAIa OUR BUS IND PHY ONL UNI PUR FIN COM NAV INT DEM CNT STA POL HEA PRE LOC OTC'"

Dim txtId, txtPass, txtEmail, txtPhone, chkAgrPrv
Dim txtName, jumin1, juminH, zipcode, addr, detailAddr, chk_num
Dim univ_kind, univ_name, univ_major, univ_syear, univ_smonth, univ_eyear, univ_emonth, univ_etype
Dim jc_code, exp_info, exp_month, jc_content, area, home, employ, salary, salary_txt, salary_meet, hire_h2, hire_info, individual_info
Dim compId, encPass, juminLen7, juminLen13, univ_sdate, univ_edate

' step1. ����ȸ������ �Է�
txtId			= RTrim(LTrim(Replace(Request("txtId"), "'", "''")))						' ���̵�
txtPass			= Replace(Request("txtPass"), "'", "''")									' ��й�ȣ
txtEmail		= RTrim(LTrim(LCase(Replace(Request("txtEmail"), " ", ""))))				' �̸���
txtPhone		= Request("txtPhone")														' �޴�����ȣ
chkAgrPrv		= Request("chkAgrPrv")														' ȫ���� ����/�̸��� ���� ����


' ����ó�� ������ ������ ��� ���� ����
Dim len_txtPhone, strPhone
If InStr(txtPhone,"-")=0 Then 
	len_txtPhone	= Len(txtPhone)
	strPhone		= Left(txtPhone,3)&"-"&Mid(txtPhone,4,len_txtPhone-7)&"-"&Right(txtPhone,4)
Else 
	strPhone		= txtPhone
End If 


' step2. ������û�� �ۼ�
txtName			= RTrim(LTrim(Replace(Replace(Request("txtName"), "'", "''"), " ", "")))	' �̸�
jumin1			= Request("jumin1")															' �ֹε�Ϲ�ȣ(�������)
juminH			= Request("juminH")															' �ֹε�Ϲ�ȣ ���ڸ�(����ŷ��)
zipcode			= Request("zipcode")														' �����ȣ
addr			= Request("addr")															' �ּ�
detailAddr		= Request("detailAddr")														' ���ּ�
chk_num			= Request("chk_num")														' �ֹε�Ϲ�ȣ��������

univ_kind		= Request("univ_kind")														' �з±���
univ_name		= Request("univ_name")														' �б���
univ_major		= Request("univ_major")														' ����
univ_syear		= Request("univ_syear")														' ���г⵵
univ_smonth		= Request("univ_smonth")													' ���п�
univ_eyear		= Request("univ_eyear")														' �����⵵
univ_emonth		= Request("univ_emonth")													' ������
univ_etype		= Request("graduated")														' ��������

jc_code			= Request("hdn_jc_name")													' �������
exp_info		= Request("career")															' ����Ի�����
exp_month		= (CInt(Request("career_year")) * 12) + CInt(Request("hdn_career_month"))	' ����Ի����� - ����Է�
jc_content		= Request("jc_content")														' �����������
area			= Request("hdn_area")														' ����ٹ�����
home			= Request("home")															' ����ٹ����� - ���ñٹ�
employ			= Request("hdn_employ")														' �������
salary			= Request("hdn_salary")														' ����Ա����¹ױݾ� - �Ա�����
salary_txt		= Replace(Request("salary_txt"), ",", "")									' ����Ա����¹ױݾ� - �ݾ��Է�
hire_h2			= Request("hire_h2")														' �����˼��������
hire_info		= Request("hdn_hire_info")													' ���������������ǿ���
individual_info	= Request("individual_info")												' �������� ��ȸ���ǿ���


' ��������
txtName			= trim(txtName)
jumin1			= trim(jumin1)
juminH			= trim(juminH)
zipcode			= trim(zipcode)
addr			= trim(addr)
detailAddr		= trim(detailAddr)
chk_num			= trim(chk_num)
univ_kind		= trim(univ_kind)
univ_name		= trim(univ_name)
univ_major		= trim(univ_major)
univ_syear		= trim(univ_syear)
univ_smonth		= trim(univ_smonth)
univ_eyear		= trim(univ_eyear)
univ_emonth		= trim(univ_emonth)
univ_etype		= trim(univ_etype)
jc_code			= trim(jc_code)
exp_info		= trim(exp_info)
exp_month		= trim(exp_month)
jc_content		= trim(jc_content)
area			= trim(area)
home			= trim(home)
employ			= trim(employ)
salary			= trim(salary)
salary_txt		= trim(salary_txt)
hire_h2			= trim(hire_h2)
hire_info		= trim(hire_info)
individual_info	= Trim(individual_info)


' �������� ��η� �̵����� ���� ��� ȸ������ ȭ������ ����
If Len(txtId) = 0 Or Len(txtPass) = 0 Then Response.Write "<meta http-equiv='refresh' content='0; url=http://" & Request.ServerVariables("SERVER_NAME") & "/my/signup/joinForm_member.asp'>"


compId		= txtId&"_wk"				' ����ȸ�����̵�+"_wk" ����
encPass		= SHA256_Encrypt(txtPass)	' ��� ��ȣȭ(sha256 ���)
juminLen7	= jumin1 & Left(juminH,1)	' �ֹι�ȣ(������� + ����)
juminLen13	= jumin1 & juminH			' �ֹι�ȣ��ü(1234561234567)
univ_sdate	= univ_syear & univ_smonth	' ���г��(202009)
univ_edate	= univ_eyear & univ_emonth	' �������(202009)


ConnectDB DBCon, Application("DBInfo_FAIR")



' �Է� ���̵� �ߺ� üũ
SpName="usp_ID_CheckAll"
	Dim chkparam(1)
	chkparam(0)=makeParam("@user_id", adVarChar, adParamInput, 20, compId)
	chkparam(1)=makeParam("@rtn", adChar, adParamOutput, 1, "")

	Call execSP(DBCon, SpName, chkparam, "", "")

	rsltCmt = getParamOutputValue(chkparam, "@rtn")


If rsltCmt = "O" Then ' �Է��� ���̵�� ���� ���Ե� ������ ������ ȸ�� ����
	

	
	' ����ȸ������ insert
	SpName="usp_ȸ������_����_��ȣȭ"
		Dim param(9)
		param(0)=makeParam("@���ξ��̵�", adVarChar, adParamInput, 20, compId)
		param(1)=makeParam("@��ȣȭ_��й�ȣ", adVarChar, adParamInput, 100, encPass)
		param(2)=makeParam("@����", adVarChar, adParamInput, 30, txtName)
		param(3)=makeParam("@���ڿ���", adVarChar, adParamInput, 100, txtEmail)
		param(4)=makeParam("@�޴���", adVarChar, adParamInput, 20, strPhone)
		param(5)=makeParam("@SMS����", adChar, adParamInput, 1, chkAgrPrv)
		param(6)=makeParam("@����Ʈ����", adChar, adParamInput, 2, "W")
		param(7)=makeParam("@���Ի���Ʈ�����ڵ�", adChar, adParamInput, 2, "1")
		param(8)=makeParam("@�ֹι�ȣ���ڸ�", adVarChar, adParamInput, 7, juminLen7)
		param(9)=makeParam("@rtn", adChar, adParamOutput, 1, "")
	
		Call execSP(DBCon, SpName, param, "", "")

		sp_rtn = getParamOutputValue(param, "@rtn")
		

		' ���̵� �� ���� ���� üũ �� ����
		Dim sp_sub_rtn 
		If Len(compId)>3 Then 
	' SUB_����ȸ������ insert
	SpName="usp_ȸ������_SUB_����ȸ������"
		Dim subparam(25)
		subparam(0)=makeParam("@���ξ��̵�", adVarChar, adParamInput, 20, compId)
		subparam(1)=makeParam("@�ֹε�Ϲ�ȣ", adVarChar, adParamInput, 500, objEncrypter.Encrypt(juminLen13))
		subparam(2)=makeParam("@�����ȣ", adVarChar, adParamInput, 5, zipcode)
		subparam(3)=makeParam("@�ּ�", adVarChar, adParamInput, 500, addr)
		subparam(4)=makeParam("@���ּ�", adVarChar, adParamInput, 500, detailAddr)
		subparam(5)=makeParam("@�ֹε�Ϲ�ȣ��������", adChar, adParamInput, 1, chk_num)
		subparam(6)=makeParam("@�з±���", adChar, adParamInput, 1, univ_kind)
		subparam(7)=makeParam("@�б���", adVarChar, adParamInput, 100, univ_name)
		subparam(8)=makeParam("@������", adVarChar, adParamInput, 100, univ_major)
		subparam(9)=makeParam("@���г��", adChar, adParamInput, 6, univ_sdate)
		subparam(10)=makeParam("@�������", adChar, adParamInput, 6, univ_edate)
		subparam(11)=makeParam("@��������", adChar, adParamInput, 2, univ_etype)
		subparam(12)=makeParam("@��������ڵ�", adVarChar, adParamInput, 10, jc_code)
		subparam(13)=makeParam("@����Ի�����", adChar, adParamInput, 1, exp_info)
		subparam(14)=makeParam("@��¿���", adInteger, adParamInput, 4, exp_month)
		subparam(15)=makeParam("@�����������", adVarChar, adParamInput, 100, jc_content)
		subparam(16)=makeParam("@����ٹ�����", adVarChar, adParamInput, 100, area)
		subparam(17)=makeParam("@���ñٹ�", adChar, adParamInput, 1, home)
		subparam(18)=makeParam("@�������", adVarChar, adParamInput, 100, employ)
		subparam(19)=makeParam("@����Ա�����", adChar, adParamInput, 2, salary)
		subparam(20)=makeParam("@����Աݱݾ�", adInteger, adParamInput, 4, salary_txt)
		subparam(21)=makeParam("@�����˼��������", adChar, adParamInput, 1, hire_h2)
		subparam(22)=makeParam("@���������������ǿ���", adVarChar, adParamInput, 100, hire_info)
		subparam(23)=makeParam("@����������ȸ���ǿ���", adChar, adParamInput, 1, individual_info)  
		subparam(24)=makeParam("@rtn", adChar, adParamOutput, 1, "")
		subparam(25)=makeParam("@�ֹι�ȣ���ڸ�", adVarChar, adParamInput, 200, juminH) 

	
		Call execSP(DBCon, SpName, subparam, "", "")

			sp_sub_rtn = getParamOutputValue(subparam, "@rtn")
		Else
			sp_sub_rtn = "X"
		End If 
		'Response.write "sp_rtn: " & sp_rtn & "<br>"
		'Response.write "sp_sub_rtn: " & sp_sub_rtn & "<br>"


		'#### ���� ��� ����
		Dim strSql2, strRemoteAddr, strUserAgent
		strRemoteAddr	= Request.ServerVariables("REMOTE_ADDR")
        strUserAgent	= Request.ServerVariables("HTTP_USER_AGENT")	
		strSql2 = "insert into LOG_ȸ������ȯ������(ȸ�����̵�, ���Ծ�����, ����ȯ��) values('"&compId&"', '"&strRemoteAddr&"', '"&strUserAgent&"')"
		DBCon.Execute(strSql2)

	

	If (sp_rtn = "O" And sp_sub_rtn = "O") Then	' ���� ���� �Ϸ� �� �ڵ��α��� ó��

		'#### ȸ������ �Ϸ� ���� ����
		Dim strSql, arrRsView, mailForm
		strSql = "SELECT ���ξ��̵�, ����� FROM ����ȸ������ WITH(NOLOCK) WHERE ���ξ��̵� ='" & compId & "'"
		arrRsView = arrGetRsSql(DBCon, strSql, "", "")
		
		mailForm = "<html>"&_
					"<head>"&_
						"<title>" & site_name & "</title>"&_
						"<meta content=""text/html; charset=euc-kr"" http-equiv=""Content-Type"" />"&_
						"<meta http-equiv=""X-UA-Compatible"" content=""IE=Edge"">"&_
					"</head>"&_
					"<body style=""text-align: center; padding-bottom: 0px; margin: 0px; padding-left: 0px; padding-right: 0px; font-family: Dotum, '����', Times New Roman, sans-serif; background: #ffffff; color: #666; font-size: 12px; padding-top: 0px"">"&_
						"<table border=""0"" cellspacing=""0"" cellpadding=""0"" align=""center"" style=""width:738px;border:solid 1px #e4e4e4; border-top:0 none; border-bottom:0 none;table-layout: fixed;"">"&_
							"<colgroup>"&_
								"<col style=""width:20px;"">"&_
								"<col style=""width:699px;"">"&_
								"<col style=""width:20px;"">"&_
							"</colgroup>"&_
							"<tbody>"&_
								"<tr>"&_
									"<td style=""width:20px;""></td>"&_
									"<td style=""width:698px;padding:20px 0;border-collapse: inherit;background:#f0f0f0;border:1px dashed #c10e2c;text-align:center;"">"&_
										"<p style=""font-size:20px;line-height:1.8;letter-spacing: -1px;color:#000;"">"&_
											"�ȳ��ϼ���. <strong>" & txtName & "</strong>��<br>"&_
											site_name & "ȸ���� ������ �ּż� �����մϴ�.<br>"&_
											site_name & "�� �پ��� ä�������� Ȯ���ϼ���.<br>"&_
										"</p>"&_
										"<table border=""0"" cellspacing=""0"" cellpadding=""0"" align=""center"" style=""width:100%;"">"&_
											"<colgroup>"&_
												"<col style=""width:44%;"">"&_
												"<col style=""width:56%;"">"&_
											"</colgroup>"&_
											"<tbody>"&_
												"<tr>"&_
													"<th style=""width:44%;padding:20px 20px 20px 0;vertical-align:top;text-align:right;font-size:17px;"">�����Ͻ�</th>"&_
													"<td style=""width:56%;padding:20px 0 20px 20px;vertical-align:top;text-align:left;font-size:17px;"">" & arrRsView(1,0) & "</td>"&_
												"</tr>"&_
												"<tr>"&_
													"<th style=""width:44%;padding:20px 20px 20px 0;vertical-align:top;text-align:right;font-size:17px;"">����ID</th>"&_
													"<td style=""width:56%;padding:20px 0 20px 20px;vertical-align:top;text-align:left;font-size:17px;"">" & Replace(arrRsView(0,0),"_wk","") & "</td>"&_
												"</tr>"&_
												"<tr>"&_
													"<td colspan=""2"" style=""padding:20px 20px 0 50px;"">"&_
														"<p style=""font-size:15px;line-height:1.5;letter-spacing:0;color:#000;text-align:left;"">"&_
															"��" & site_name & "�� �¶������θ� ä���� ����˴ϴ�.<br>"&_
															"�� ���ϴ� ���� �����Ϸ��� �¶��� �̷¼��� �ۼ��ؾ߸� ������ �����մϴ�."&_
														"</p>"&_
													"</td>"&_
												"</tr>"&_
												"<tr>"&_
													"<td colspan=""2"" style=""padding:20px 20px 0 20px;text-align:right;"">"&_
														"<a href=""http://" & Request.ServerVariables("SERVER_NAME") & "/my/resume/resume_regist.asp"" target=""_blank"">�̷¼� ����Ϸ� ����</a>"&_
													"</td>"&_
												"</tr>"&_
											"</tbody>"&_
										"</table>"&_
									"</td>"&_
									"<td style=""width:20px;""></td>"&_
								"</tr>"&_
							"</tbody>"&_
						"</table>"&_
					"</body>"&_
					"</html>"

		dim iConf
		dim mailer
		set mailer = Server.CreateObject("CDO.Message")

		set iConf = mailer.Configuration
		with iConf.Fields
		.item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 1
		.item("http://schemas.microsoft.com/cdo/configuration/smtpserverpickupdirectory") = "C:\inetpub\mailroot\Pickup"
		.item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "127.0.0.1"
		.item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 10
		.update
		end with

		mailer.From = site_helpdesk_mail
		mailer.To = txtEmail
		mailer.Subject = "["& site_name & "] " & "ȸ�������� �Ϸ�Ǿ����ϴ�."
		mailer.HTMLBody = mailForm
		mailer.BodyPart.Charset="ks_c_5601-1987"
		mailer.HTMLBodyPart.Charset="ks_c_5601-1987"
		mailer.Send
		set mailer = Nothing

		'#### ȸ������ ��Ű �Ҵ�
		Response.Cookies(site_code & "WKP_F")("id")			= Replace(compId, "_wk", "")
		Response.Cookies(site_code & "WKP_F")("name")		= txtName
		Response.Cookies(site_code & "WKP_F")("email")		= txtEmail
		Response.Cookies(site_code & "WKP_F")("cellphone")	= strPhone
		Response.Cookies(site_code & "WKP_F").Domain		= "career.co.kr"
		'Response.Cookies("WKP_F").Domain	= Request.ServerVariables("SERVER_NAME")	' ������ ����

		Response.Write "<script language=javascript>"&_
		 "alert('ȸ�������� �Ϸ�Ǿ����ϴ�.');"&_
		"location.href='/';"&_
		"</script>"
		response.End 

	Else ' ȸ�� ���� ���� �� ���� �߻� ����
		Response.Write "<script language=javascript>"&_
		 "alert('ȸ������ �� ������ �߻��߽��ϴ�.\n�ٽ� �õ��� �ּ���.');"&_
		"location.href='/my/signup/joinForm_member.asp';"&_
		"</script>"
		response.End 
	End If 
Else	' �Է��� ���̵�� ���Ե� ������ ������ ��� ȸ�� ���� ������ ����
	Response.Write "<script language=javascript>"&_
	 "alert('�Է��Ͻ� ���̵�� ���Ե� ������ �����մϴ�.\n�ٸ� ���̵�� �ٽ� �õ��� �ּ���.');"&_
	"location.href='/my/signup/joinForm_member.asp';"&_
	"</script>"
	response.End 
End If 

DisconnectDB DBCon
%>