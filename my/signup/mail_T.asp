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

Dim txtId, txtPass, txtName, txtEmail, chkAgrMail, txtPhone, chkAgrSms, compId, encPass, len_txtPhone, strPhone


txtEmail	= "dleksql98@naver.com"


ConnectDB DBCon, Application("DBInfo_FAIR")

	
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
										"�ȳ��ϼ���. <strong></strong>��<br>"&_
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
												"<td style=""width:56%;padding:20px 0 20px 20px;vertical-align:top;text-align:left;font-size:17px;""></td>"&_
											"</tr>"&_
											"<tr>"&_
												"<th style=""width:44%;padding:20px 20px 20px 0;vertical-align:top;text-align:right;font-size:17px;"">����ID</th>"&_
												"<td style=""width:56%;padding:20px 0 20px 20px;vertical-align:top;text-align:left;font-size:17px;""></td>"&_
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

DisconnectDB DBCon
%>