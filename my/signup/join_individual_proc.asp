<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual="/common/common.asp"-->
<!--#include virtual="/wwwconf/function/library/KISA_SHA256.asp"-->
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

Dim txtId, txtPass, txtName, txtEmail, chkAgrMail, txtPhone, chkAgrSms, compId, encPass, len_txtPhone, strPhone, sel_birthY, sel_birthM, sel_birthD, strSex

txtId		= RTrim(LTrim(Replace(Request("txtId"), "'", "''")))	' ���̵�
txtPass		= Replace(Request("txtPass"), "'", "''")				' ��й�ȣ	
txtName		= RTrim(LTrim(Replace(Replace(Request("txtName"), "'", "''"), " ", "")))	' �̸�
txtEmail	= RTrim(LTrim(LCase(Replace(Request("txtEmail"), " ", ""))))	' �̸���
chkAgrMail	= Request("chkAgrMail")		' ȫ���� ���� ���� ����
txtPhone	= Request("txtPhone")		' �޴�����ȣ
chkAgrSms	= Request("chkAgrSms")		' ȫ���� ���� ���� ����

sel_birthY	= Request("sel_birthY")	' �������
sel_birthM	= Request("sel_birthM")	' �����
sel_birthD	= Request("sel_birthD")	' �������


' ����ó�� ������ ������ ��� ���� ����
If InStr(txtPhone,"-")=0 Then 
	len_txtPhone	= Len(txtPhone)
	strPhone		= Left(txtPhone,3)&"-"&Mid(txtPhone,4,len_txtPhone-7)&"-"&Right(txtPhone,4)
Else 
	strPhone		= txtPhone
End If 


' ��������� ���� �����ڵ� �������� �⺻ ����(1900��� �����: 1, 2000��� �����: 3)
If Len(sel_birthY)>0 Then 
	If Left(sel_birthY,1)="1" Then 
		strSex = "1"
	Else 
		strSex = "3"
	End If 
Else 
	Response.Write "<script language=javascript>"&_
	 "alert('ȸ������ ���� �� ������ �׸��� �ֽ��ϴ�.\n�ٽ� �õ��� �ּ���.');"&_
	"location.href='/my/signup/join.asp';"&_
	"</script>"
	response.End 
End If 


' �������� ��η� �̵����� ���� ��� ȸ������ ȭ������ ����
If Len(txtId) = 0 Or Len(txtPass) = 0 Then Response.Write "<meta http-equiv='refresh' content='0; url=http://" & Request.ServerVariables("SERVER_NAME") & "/my/signup/join.asp'>"


compId	= txtId&"_wk"				' ����ȸ�����̵�+"_wk" ����		
encPass = SHA256_Encrypt(txtPass)	' ��� ��ȣȭ(sha256 ���)


ConnectDB DBCon, Application("DBInfo_FAIR")


' �Է� ���̵� �ߺ� üũ
SpName="usp_ID_CheckAll"
	Dim chkparam(1)
	chkparam(0)=makeParam("@user_id", adVarChar, adParamInput, 20, compId)
	chkparam(1)=makeParam("@rtn", adChar, adParamOutput, 1, "")

	Call execSP(DBCon, SpName, chkparam, "", "")

	rsltCmt = getParamOutputValue(chkparam, "@rtn")


If rsltCmt = "O" Then ' �Է��� ���̵�� ���� ���Ե� ������ ������ ȸ�� ����
		
	SpName="usp_ȸ������_����_��ȣȭ"
		Dim param(13)
		param(0)=makeParam("@���ξ��̵�", adVarChar, adParamInput, 20, compId)
		param(1)=makeParam("@��ȣȭ_��й�ȣ", adVarChar, adParamInput, 100, encPass)
		param(2)=makeParam("@����", adVarChar, adParamInput, 30, txtName)
		param(3)=makeParam("@���ڿ���", adVarChar, adParamInput, 100, txtEmail)
		param(4)=makeParam("@�޴���", adVarChar, adParamInput, 20, strPhone)
		param(5)=makeParam("@���ϼ��ſ���", adChar, adParamInput, 1, chkAgrMail)
		param(6)=makeParam("@SMS����", adChar, adParamInput, 1, chkAgrSms)

		param(7)=makeParam("@�ֹι�ȣ��", adChar, adParamInput, 2, Right(sel_birthY,2))
		param(8)=makeParam("@�ֹι�ȣ��", adChar, adParamInput, 2, sel_birthM)
		param(9)=makeParam("@�ֹι�ȣ��", adChar, adParamInput, 2, sel_birthD)
		param(10)=makeParam("@�ֹι�ȣ����", adChar, adParamInput, 1, strSex)

		param(11)=makeParam("@����Ʈ����", adChar, adParamInput, 2, "W")
		param(12)=makeParam("@���Ի���Ʈ�����ڵ�", adChar, adParamInput, 2, "1")
		param(13)=makeParam("@rtn", adChar, adParamOutput, 1, "")
	
		Call execSP(DBCon, SpName, param, "", "")

		sp_rtn = getParamOutputValue(param, "@rtn")
	
	If sp_rtn = "O" Then	' ���� ���� �Ϸ� �� �ڵ��α��� ó��
		
		'#### ���� ��� ����
		Dim strSql2, strRemoteAddr, strUserAgent
		strRemoteAddr	= Request.ServerVariables("REMOTE_ADDR")
        strUserAgent	= Request.ServerVariables("HTTP_USER_AGENT")	
		strSql2 = "INSERT INTO LOG_ȸ������ȯ������(ȸ�����̵�, ���Ծ�����, ����ȯ��) VALUES('"&compId&"', '"&strRemoteAddr&"', '"&strUserAgent&"')"
		DBCon.Execute(strSql2)


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
											site_name & " ȸ������ ������ �ּż� �����մϴ�.<br>"&_
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

		mailer.From		= site_helpdesk_mail '"expohelp@career.co.kr"
		mailer.To		= txtEmail
		mailer.Subject	= "["& site_name & "] " & "ȸ�������� �Ϸ�Ǿ����ϴ�."
		mailer.HTMLBody = mailForm
		mailer.BodyPart.Charset		= "ks_c_5601-1987"
		mailer.HTMLBodyPart.Charset	= "ks_c_5601-1987"
		mailer.Send
		set mailer = Nothing

		'#### ȸ������ ��Ű �Ҵ�
		Response.Cookies(site_code & "WKP_F")("id")			= Replace(compId, "_wk", "")
		Response.Cookies(site_code & "WKP_F")("name")		= txtName
		Response.Cookies(site_code & "WKP_F")("email")		= txtEmail
		Response.Cookies(site_code & "WKP_F")("cellphone")	= strPhone
		Response.Cookies(site_code & "WKP_F").Domain		= "career.co.kr"
		'Response.Cookies("WKP_F").Domain	= Request.ServerVariables("SERVER_NAME")	' ������ ����
		
		set_url = "/default.asp"

		Response.Write "<script language=javascript>"&_
			"alert('ȸ�������� �Ϸ�Ǿ����ϴ�.');"&_
			"location.href='" & set_url & "';" &_
			"</script>"
		Response.End 

	Else ' ȸ�� ���� ���� �� ���� �߻� ����
		Response.Write "<script language=javascript>"&_
			"alert('ȸ������ �� ������ �߻��߽��ϴ�.\n�ٽ� �õ��� �ּ���.');"&_
			"location.href='/my/signup/join.asp';"&_
			"</script>"
		Response.End 
	End If 
Else	' �Է��� ���̵�� ���Ե� ������ ������ ��� ȸ�� ���� ������ ����
	Response.Write "<script language=javascript>"&_
		"alert('�Է��Ͻ� ���̵�� ���Ե� ������ �����մϴ�.\n�ٸ� ���̵�� �ٽ� �õ��� �ּ���.');"&_
		"location.href='/my/signup/join.asp';"&_
		"</script>"
	Response.End 
End If 

DisconnectDB DBCon
%>