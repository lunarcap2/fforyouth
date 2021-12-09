<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual="/common/common.asp"--> 
<!--#include virtual="/include/header/header.asp"-->
<%
'--------------------------------------------------------------------
'   Comment		: ȭ����� ���� ������ ��� ����/���� �߼�
' 	History		: 2020-07-15, �̻��� 
'---------------------------------------------------------------------
Session.CodePage  = 949			'�ѱ�
Response.CharSet  = "euc-kr"	'�ѱ�
Response.AddHeader "Pragma","no-cache"
Response.AddHeader "cache-control", "no-staff"
Response.Expires  = -1

Dim jid		: jid		= Request("jidnum")	' ä������ȣ
Dim bizid	: bizid		= Request("bizid")  ' ȸ�� ���̵�
Dim hostId	: hostId	= Request("confid")	' ȭ������� ȸ�� ���̵�

If jid="" Or bizid="" Or hostId="" Then 
	Response.Write "<script language=javascript>"&_
		"alert('�ش� �޴��� ���� ���� ������ �����ϴ�.');"&_
		"location.href='/';"&_
		"</script>"
	response.End 
End If

ConnectDB DBCon, Application("DBInfo_FAIR")

Dim sql, arrList, i, interviewDt, interviewTmCd, urlCd, interviewTime, interviewYoil, chkSql, sql2, sql3, sql4, sql5
sql = "SELECT DISTINCT ������, �����ð�, CAST(ä���Ϲ�ȣ AS VARCHAR)+'sdate'+REPLACE(������,'-','')+'stime'+CAST(�����ð� AS VARCHAR)+'_zdomain_'+'"&ontactDomain_maltalk&"'+'_cd1' AS 'URLCODE', " 
sql = sql & " CASE �����ð� WHEN 1 THEN '09:00~09:25 (25��)' WHEN 2 THEN '09:30~09:55 (25��)' WHEN 3 THEN '10:00~10:25 (25��)' WHEN 4 THEN '10:30~10:55 (25��)' WHEN 5 THEN '11:00~11:25 (25��)' WHEN 6 THEN '11:30~11:55 (25��)' WHEN 7 THEN '13:00~13:25 (25��)' WHEN 8 THEN '13:30~13:55 (25��)' WHEN 9 THEN '14:00~14:25 (25��)' WHEN 10 THEN '14:30~14:55 (25��)' WHEN 11 THEN '15:00~15:25 (25��)' WHEN 12 THEN '15:30~15:55 (25��)' WHEN 13 THEN '16:00~16:25 (25��)' WHEN 14 THEN '16:30~16:55 (25��)' WHEN 15 THEN '17:00~17:25 (25��)' WHEN 16 THEN '17:30~17:55 (25��)' END AS tm, '('+left(DATENAME(DW, ������),1)+')' AS yoil "
sql = sql & " FROM ������������ WHERE ä���Ϲ�ȣ='"&jid&"' AND ȸ����̵�='"&bizid&"' AND ISNULL(����Ȯ������,'N')<>'Y' AND (������>CONVERT(CHAR(10),GETDATE(),121)) "
sql = sql & " OR (������=CONVERT(CHAR(10),GETDATE(),121) AND (CASE WHEN �����ð�=1 THEN '09:25' WHEN �����ð�=2 THEN '09:55' WHEN �����ð�=3 THEN '10:25' WHEN �����ð�=4 THEN '10:55' WHEN �����ð�=5 THEN '11:25' WHEN �����ð�=6 THEN '11:55' WHEN �����ð�=7 THEN '13:25' WHEN �����ð�=8 THEN '13:55' WHEN �����ð�=9 THEN '14:25' WHEN �����ð�=10 THEN '14:55' WHEN �����ð�=11 THEN '15:25' WHEN �����ð�=12 THEN '15:55' WHEN �����ð�=13 THEN '16:25' WHEN �����ð�=14 THEN '16:55' WHEN �����ð�=15 THEN '17:25' WHEN �����ð�=16 THEN '17:55' END)>=CONVERT(CHAR(5),GETDATE(),108)) "

arrList = arrGetRsSql(DBCon, sql,"","")
If IsArray(arrList) Then
	For i = LBound(arrList,2) To UBound(arrList,2)
		interviewDt		= Trim(arrList(0,i))
		interviewTmCd	= Trim(arrList(1,i))
		urlCd			= Trim(arrList(2,i))
		interviewTime	= Trim(arrList(3,i))
		interviewYoil	= Trim(arrList(4,i))
		
		
		' ȭ����� �� ���� ���� ���� ���� üũ
		Set Rs = Server.CreateObject("ADODB.RecordSet")
		chkSql = "SELECT * FROM ��������_������URL WHERE URL�ڵ�='"&urlCd&"'"
		Rs.Open chkSql, DBCon, 0, 1
		If Not (Rs.BOF Or Rs.EOF) Then
			ontactYn = "Y"
		Else 	
			ontactYn = "N"
		End If
		Rs.Close		

		If ontactYn = "N" Then ' �ش��Ͻÿ� ���� ������ ȭ�� ���� ���� ���� ��� ���� ���� ����

			'1) �������� URL ���� ����
			Dim hostUrl : hostUrl = "https://vc.dial070.co.kr/"&urlCd&"?st="&serviceType_maltalk&"&id="&hostId&"&name="&comname
			sql2 = "SET NOCOUNT ON;"
			sql2 = sql2 &" INSERT INTO ��������_������URL ("
			sql2 = sql2 &" ä���Ϲ�ȣ, ������, �����ð�, URL�ڵ�, ������URL, ȸ����̵�, ȭ�������ȸ����̵�, API���ۿ��� "
			sql2 = sql2 &" ) VALUES ("
			sql2 = sql2 &" '"&jid&"', '"&interviewDt&"', '"&interviewTmCd&"', '"&urlCd&"', '"&hostUrl&"', '"&bizId&"', '"&hostId&"', 'N'"
			sql2 = sql2 &" );"
			DBCon.Execute(sql2)		


			'2) SMS������ ��ư Ŭ���ϰ� �������ڰ� ���� ��� ������ ���� API ����
			If CDate(interviewDt)=Date() Then 
%>
<script type="text/javascript">
	// ȭ������� URL ����
	var param = {
		"memberid": "<%=hostId%>",
		"url": "<%=urlCd%>",
		"islock": "Y",
		"recording_option": "0",
		"service_type": "<%=serviceType_maltalk%>",
		"apikey": "<%=apiKey_maltalk%>"
	}

	$.ajax({
		type : "POST",
		url: "https://ext-api.maaltalk.com/career2/api/main/create-url.php",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		data: JSON.stringify(param),
		complete: function(data){
			var res = data.responseJSON;
			if(res.code == 0){
<%
	sql3 = "SET NOCOUNT ON;"
	sql3 = sql3&"UPDATE ��������_������URL SET API���ۿ���='Y' WHERE ä���Ϲ�ȣ='"&jid&"' AND ȸ����̵�='"&bizid&"' AND ������='"&interviewDt&"' AND �����ð�='"&interviewTmCd&"'  " 
	DBCon.Execute(sql3)
%>				
			}else{
				alert(res.code+' : '+res.message);
			}
		}
	});
</script>
<%
			End If 

		End If 


		'3) �ش� ����/�ð��� ���������� ������ ��� ȭ����� �ȳ� ����/���� �߼�
		Dim arrList2, j, seq, resume_phone, resume_email
		sql4 = "SELECT apply.�Ի�������Ϲ�ȣ, apply.������URL, resume.�޴���, resume.���ڿ��� FROM ��������_������URL apply " 
		sql4 = sql4 & " INNER JOIN ������������ interview ON interview.ä���Ϲ�ȣ=apply.ä���Ϲ�ȣ AND interview.�Ի�������Ϲ�ȣ=apply.�Ի�������Ϲ�ȣ "
		sql4 = sql4 & " INNER JOIN ���ͳ��Ի�����_�������� resume ON resume.ä��������Ϲ�ȣ=apply.ä���Ϲ�ȣ AND resume.������ȣ=apply.�Ի�������Ϲ�ȣ "
		sql4 = sql4 & " WHERE apply.ä���Ϲ�ȣ='"&jid&"' AND apply.������='"&interviewDt&"' AND apply.�����ð�='"&interviewTmCd&"' AND ISNULL(interview.����Ȯ������,'N')<>'Y' "
		arrList2 = arrGetRsSql(DBCon, sql4, "", "")
		If IsArray(arrList2) Then
			For j = LBound(arrList2,2) To UBound(arrList2,2)
				seq				= Trim(arrList2(0,j))
				guestUrl		= Trim(arrList2(1,j))
				resume_phone	= Trim(arrList2(2,j))
				resume_email	= Trim(arrList2(3,j))

				
				'3-1) ���� �߼�
				ConnectDB DBCon2, Application("DBInfo_etc")
				Dim now_time, msg, strSql, smsid
				now_time = year(now) & Right("0"&month(now),2) & Right("0"&day(now),2) & Right("0"&hour(now),2) & Right("0"&minute(now),2) & Right("0"&second(now),2)
				
				msg = "�ȳ��ϼ��� "&comname&" �λ�ä�� ������Դϴ�."& vbCrlf & vbCrlf
				msg = msg & "�����Ͻ� ä������� ���� �հݿ� ���� ȭ����� ���� �� ���� URL ���� �ȳ� �帳�ϴ�."& vbCrlf & vbCrlf
				msg = msg & "�� ȭ������Ͻ�: "&interviewDt&interviewYoil&" "&interviewTime&""& vbCrlf
				msg = msg & "�� URL : "&guestUrl&""& vbCrlf & vbCrlf
				msg = msg & "�� ȭ�� ���� ���񽺴� ũ��(Chrome) �������� �������� ��쿡�� �̿� �����մϴ�."& vbCrlf	 & vbCrlf	
				msg = msg & "�� �ȵ���̵� ��� �޴������� ȭ����� ��ũ�� �������� �� �������� ���� �ȳ� ���� �߻� �� �Ʒ� ������ ���� �⺻ ������ ������ ������ �ּ���."& vbCrlf
				msg = msg & "�� Androidȯ�� ��⿡ ���� ���� �� �� ���� ����� ����Ͽ� Google ������ ã���ϴ�."& vbCrlf
				msg = msg & "�� ����� ���� ���� ���ϴ�."& vbCrlf
				msg = msg & "�� ���ø����̼� ������ �����ϴ�.(LG���� ��� �Ϲ�> �� �� ����)"& vbCrlf
				msg = msg & "�� �⺻ ���� ���մϴ�."& vbCrlf
				msg = msg & "�� ������ ���� ���մϴ�."& vbCrlf
				msg = msg & "�� Chrome�� ���մϴ�."& vbCrlf & vbCrlf				
				msg = msg & "�� �ش� URL�� ���� ���Ͽ� ���Ͽ� ���� ���Ǵ� ������ �����ð��� ���� ���� �ٶ��ϴ�."& vbCrlf
				msg = msg & "�� ũ���� ������ ���ͳ��ͽ��÷η�(IE) ���� ������������ ȭ�� ���� ���񽺰� �������� �ʽ��ϴ�."& vbCrlf
				msg = msg & "�� PC/�޴����� ����Ͽ� ȭ�� ������ ���� �����ϸ�, �̷¼��� �����Ͻ� ���� �ּҷε� ���� �ȳ� ������ �߼۵Ǿ����� PC�� ���� ���� �� �����Ͻø� �˴ϴ�."& vbCrlf
				msg = msg & "�� ��Ȱ�� ������ ���� ȭ����� ���� �� ���� �޴����� ī�޶�, ����Ŀ, ����ũ�� ���� �۵��Ǵ��� üũ�� �ּ���."& vbCrlf
				msg = msg & "�� �޴������� ȭ������� ������ ��� ȭ���� ���η� �Ͽ� ���� �ٶ��ϴ�."& vbCrlf & vbCrlf



				Set Rs = Server.CreateObject("ADODB.RecordSet")
				strSql = "select max(CMP_MSG_ID) as cmid from arreo_sms where not (left(CMP_MSG_ID, 5) = 'ALARM') "
				Rs.Open strSql, DBCon2, 0, 1
				If Not (Rs.BOF Or Rs.EOF) Then
					smsid = rs("cmid") + 1

					sql5 = "insert into arreo_sms (CMP_MSG_ID, CMP_USR_ID, ODR_FG, SMS_GB, USED_CD, MSG_GB, WRT_DTTM, SND_DTTM, SND_PHN_ID, RCV_PHN_ID, CALLBACK, SUBJECT, SND_MSG, EXPIRE_VAL, SMS_ST, RSLT_VAL, RSRVD_ID, RSRVD_WD)" &_
							" values ('" & smsid & "', '00000', '2', '1', '00', 'M', '" & now_time & "', '" & now_time & "', 'daumhr', '" & Replace(Replace(resume_phone, " ", ""),"-","") & "', '"& Replace(Replace(site_callback_phone, " ", ""),"-","") &"', '"&site_short_name&"', '" & msg & "', 0, '0', 99,'','');"
					DBCon2.Execute(sql5)
				End If
				Rs.Close
				DisconnectDB DBCon2				

				'3-2) ���� �߼�
				Dim mailForm, iConf, mailer
				mailForm = "<html>"&_
				"<head>"&_
				"<title>"& site_name &"</title>"&_
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
									"�ȳ��ϼ���. " & comname & " ä������ �Դϴ�.<br>"&_
									"<strong>�Ʒ��� ���� ȭ����� ������ Ȯ���Ǿ� ���� �帳�ϴ�.</strong><br>"&_
									"�ش��Ͻÿ� �����ϼż� ���� �� ���� ����� �����ñ⸦ �����ϰڽ��ϴ�."&_
								"</p>"&_
								"<table border=""0"" cellspacing=""0"" cellpadding=""0"" align=""center"">"&_
									"<colgroup>"&_
										"<col style=""width:35%;"">"&_
										"<col style=""width:65%;"">"&_
									"</colgroup>"&_
									"<tbody>"&_
										"<tr>"&_
											"<th style=""width:30%;padding:20px;vertical-align:top;font-size:17px;text-align:right;"">On-tact ���� �Ͻ�</th>"&_
											"<td style=""width:70%;padding:20px 0;vertical-align:top;font-size:17px;"">" & interviewDt&interviewYoil & " " & interviewTime & "</td>"&_
										"</tr>"&_
										"<tr>"&_
											"<th style=""width:30%;padding:20px;vertical-align:top;font-size:17px;text-align:right;"">On-tact ���� �ּ�</th>"&_
											"<td style=""width:70%;padding:20px 0;vertical-align:top;font-size:17px;"">"&_
												"<a href=""" & guestUrl & """ target=""_blank"">�ٷΰ���</a>"&_
												"<br><br>" & guestUrl & "</td>"&_
										"</tr>"&_
										"<tr>"&_
											"<td colspan=""2"" style=""padding:20px 20px 0 30px;"">"&_
												"<p style=""font-size:15px;line-height:1.5;letter-spacing:0;color:#000;text-align:left;"">"&_
													"�� On-tact �����ּҴ� ���� ���Ͽ� ���Ͽ� ������ ���˴ϴ�. �����Ͻø� Ȯ���ϰ� �ð���<br>&nbsp;&nbsp;&nbsp;�°� ������ �ּ���.<br>"&_
													"�� ���� �� On-tact���� �ַ�ǿ��� ���� ����� ī�޶�, ����Ŀ, ����ũ�� ���� �۵��ϴ���<br>&nbsp;&nbsp;&nbsp;������ �̸� ������ �ּ���.<br>"&_
													"�� ���ͳ� �ͽ��÷η�(IE)������ On-tact ���� ���񽺰� �������� �ʽ��ϴ�.<br>&nbsp;&nbsp;&nbsp;�ַ���� ����ȭ �� Chrome(ũ��)�� ���ؼ� ������ �ּ���."&_
												"</p>"&_
											"</td>"&_
										"</tr>"&_
										"<tr>"&_
											"<td colspan=""2"" style=""padding:20px 20px 0 20px;text-align:right;"">"&_
												"<a href=""https://www.google.com/intl/ko/chrome/"" target=""_blank"">Chrome �ٿ�ε�</a>&nbsp;"&_
												"<a href=""https://" & Request.ServerVariables("SERVER_NAME") & "/board/notice_view.asp?seq=53"" target=""_blank"">Chrome�� �⺻ �������� �����ϴ� ���</a>"&_
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

				Set mailer	= Server.CreateObject("CDO.Message")
				Set iConf	= mailer.Configuration
				With iConf.Fields
				.item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 1
				.item("http://schemas.microsoft.com/cdo/configuration/smtpserverpickupdirectory") = "C:\inetpub\mailroot\Pickup"
				.item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "127.0.0.1"
				.item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 10
				.update
				End With 

				mailer.From = site_helpdesk_mail
				mailer.To	= resume_email
				mailer.Subject	= "["& site_name &"] �����Ͻ� "&comname&" ä������� �����հݿ� ���� ȭ����� ���� �ȳ� �帳�ϴ�."
				mailer.HTMLBody	= mailForm
				mailer.BodyPart.Charset="ks_c_5601-1987"
				mailer.HTMLBodyPart.Charset="ks_c_5601-1987"
				mailer.Send
				Set mailer = Nothing 


			Next 
		End If 
 
		'4) �������� Ȯ�� ���·� ����
		sql6 = "UPDATE ������������ SET ����Ȯ������='Y', ����Ȯ����=getdate() WHERE ä���Ϲ�ȣ='"&jid&"' AND ȸ����̵�='"&bizid&"' AND ������='"&interviewDt&"' AND �����ð�='"&interviewTmCd&"'  " 
		DBCon.Execute(sql6)
	Next
End If	
DisconnectDB DBCon


Response.Write "<script language=javascript>"&_
	"alert('���� ������ ��� ȭ����� ���� �ȳ� ���� �߼��� �Ϸ�Ǿ����ϴ�.');"&_
	"window.location=document.referrer;"&_
	"</script>"
Response.End 
%>