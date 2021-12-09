<%
	 Response.CharSet="euc-kr"
     Session.codepage="949"
     Response.codepage="949"
     Response.ContentType="text/html;charset=euc-kr"
%>

<!--#include virtual = "/common/common.asp"-->

<%
	Response.AddHeader "P3P", "CP='ALL CURa ADMa DEVa TAIa OUR BUS IND PHY ONL UNI PUR FIN COM NAV INT DEM CNT STA POL HEA PRE LOC OTC'"

	Dim receiver, rece_type, rece_tit, rece_con, smsYN, jid, rece_sch
	Dim arrNM
	Dim now_time, msg, smsid
	Dim mailForm

	receiver		= Request("receiver")
	rece_type		= Request("rece_type")
	rece_tit		= unescape(Request.form("rece_tit"))
	rece_con		= unescape(Request.form("rece_con"))
	smsYN			= Request("smsYN")
	jid				= Request("jid")
	rece_sch		= Request("rece_sch")

	mailForm = "<html>"&_
				"<head>"&_
					"<title>" & site_name & "</title>"&_
					"<meta content=""text/html; charset=euc-kr"" http-equiv=""Content-Type"" />"&_
					"<meta http-equiv=""X-UA-Compatible"" content=""IE=Edge"">"&_
				"</head>"&_
				"<body style=""text-align: center; padding-bottom: 0px; margin: 0px; padding-left: 0px; padding-right: 0px; font-family: Dotum, '돋움', Times New Roman, sans-serif; background: #ffffff; color: #666; font-size: 12px; padding-top: 0px"">"&_
					"<table border=""0"" cellspacing=""0"" cellpadding=""0"" width=""738"" align=""center"" style=""border:solid 1px #e4e4e4; border-top:0 none; border-bottom:0 none;table-layout: fixed;"">"&_
						"<colgroup>"&_
							"<col style=""width:82px;"">"&_
							"<col style=""width:575px;"">"&_
							"<col style=""width:82px;"">"&_
						"</colgroup>"&_
						"<tbody>"&_
							"<tr>"&_
								"<td style=""width:82px;""></td>"&_
								"<td style=""width:574px;height:325px;border-collapse: inherit;background:#f0f0f0;border:1px dashed #c10e2c;text-align:center;"">"&_
									"<p style=""font-size:20px;line-height:1.8;letter-spacing: -1px;color:#000;"">" & rece_con& "</p>"&_
								"</td>"&_
								"<td style=""width:82px;""></td>"&_
							"</tr>"&_
						"</tbody>"&_	
					"</table>"&_
				"</body>"&_
				"</html>"

	dbCon.Open Application("DBInfo_FAIR")	
	
	arrNM = split(receiver, ",")
	
	For i=0 To Ubound(arrNM)
		strSql = "SELECT 전자우편, 휴대폰, 성명 FROM 인터넷입사지원_개인정보 WITH(NOLOCK) WHERE 개인아이디= '" & arrNM(i) & "' "
		
		Rs.Open strSql, dbCon, 0, 1

		If (Rs.BOF = false and Rs.EOF = false) Then
			If rece_type = "email" Then
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
				mailer.To = Rs("전자우편")
				mailer.Subject = rece_tit
				mailer.HTMLBody = mailForm
				mailer.BodyPart.Charset="ks_c_5601-1987"
				mailer.HTMLBodyPart.Charset="ks_c_5601-1987"
				mailer.Send
				set mailer = Nothing
			End If

			If smsYN = "Y" Or rece_type = "sms" Then
				dbCon1.Open Application("DBInfo_etc")
				
				If CInt(hour(now)) >= CInt(21) Or CInt(hour(now)) < CInt(9) Then
					now_time = Replace(Left(dateadd("d",1,now()),10),"-","") & "090101"
				Else
					now_time = year(now) & right("0" & month(now),2) & right("0" & day(now),2) & right("0" & hour(now),2) & right("0" & minute(now),2) & right("0" & second(now),2)
				End If
				
				smsTit = "[" & Replace(Replace(Replace(rece_sch, "5", "서류"), "6", "면접"), "7", "면접") & "전형 결과 안내]"
				msg = Replace(rece_con,"<br>",vbcrlf)

				strSql = "SELECT MAX(CMP_MSG_ID) AS cmid FROM arreo_sms WHERE NOT (LEFT(CMP_MSG_ID, 5) = 'ALARM') "
				
				Rs1.Open strSql, dbCon1, 0, 1
				
				If not (Rs1.BOF or Rs1.EOF ) Then
					smsid = Rs1("cmid") + 1

					strSql = "INSERT INTO arreo_sms (CMP_MSG_ID, CMP_USR_ID, ODR_FG, SMS_GB, USED_CD, MSG_GB, WRT_DTTM, SND_DTTM, SND_PHN_ID, RCV_PHN_ID, CALLBACK, SND_MSG, EXPIRE_VAL, SMS_ST, RSLT_VAL, RSRVD_ID, RSRVD_WD, SUBJECT)" &_
							" VALUES ('" & smsid & "', '00000', '2', '1', '00', 'M', '" & now_time & "', '" & now_time & "', 'daumhr', '" & Replace(Replace(Rs("휴대폰"), " ", ""),"-","") & "', '"& Replace(site_callback_phone, "-", "") &"', '" & msg & "', 0, '0', 99,'','', '" & smsTit & "');"

					dbCon1.Execute(strSql)
				End If

				Rs1.close
				dbCon1.close
			End If
			
			strSql = "INSERT INTO tbl_result_noti_history VALUES('" & Rs("성명") & "', '" & rece_sch & "', GETDATE(), '" & rece_type & "', '" & smsid & "', '" & jid & "')"

			dbCon.Execute(strSql)
		End If
		
		Rs.close		
	Next
	
	dbCon.close
%>

<OBJECT RUNAT="SERVER" PROGID="ADODB.Connection" ID="dbCon"></OBJECT>
<OBJECT RUNAT="SERVER" PROGID="ADODB.Connection" ID="dbCon1"></OBJECT>
<OBJECT RUNAT="SERVER" PROGID="ADODB.RecordSet" ID="Rs"></OBJECT>
<OBJECT RUNAT="SERVER" PROGID="ADODB.RecordSet" ID="Rs1"></OBJECT>