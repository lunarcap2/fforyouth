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

Dim jid		: jid		= Request("jid")		' ä������ȣ
Dim applyid	: applyid	= Request("applyid")	' �Ի�������ȣ

If jid="" Or applyid="" Then 
	Response.Write "<script language=javascript>"&_
		"alert('�ش� �޴��� ���� ���� ������ �����ϴ�.');"&_
		"location.href=history.go(-1);"&_
		"</script>"
	response.End 
End If


If comid="" Then 
	Response.Write "<script language=javascript>"&_
		"alert('�ش� �޴��� ���� ���� ������ �����ϴ�.');"&_
		"location.href='/';"&_
		"</script>"
	response.End 
End If


' ȭ����� ���� �� guest�� URL ���� ����
ConnectDB DBCon, Application("DBInfo_FAIR")

	Set Rs = Server.CreateObject("ADODB.RecordSet")
	chkSql = "SELECT TOP 1 guest.������, '('+left(DATENAME(DW, guest.������),1)+')' AS yoil, guest.�����ð�, "
	chkSql = chkSql & " CASE guest.�����ð� WHEN 1 THEN '09:00~09:25 (25��)' WHEN 2 THEN '09:30~09:55 (25��)' WHEN 3 THEN '10:00~10:25 (25��)' WHEN 4 THEN '10:30~10:55 (25��)' WHEN 5 THEN '11:00~11:25 (25��)' WHEN 6 THEN '11:30~11:55 (25��)' WHEN 7 THEN '13:00~13:25 (25��)' WHEN 8 THEN '13:30~13:55 (25��)' WHEN 9 THEN '14:00~14:25 (25��)' WHEN 10 THEN '14:30~14:55 (25��)' WHEN 11 THEN '15:00~15:25 (25��)' WHEN 12 THEN '15:30~15:55 (25��)' WHEN 13 THEN '16:00~16:25 (25��)' WHEN 14 THEN '16:30~16:55 (25��)' WHEN 15 THEN '17:00~17:25 (25��)' WHEN 16 THEN '17:30~17:55 (25��)' END AS tm, guest.URL�ڵ�, guest.������URL, apply.�޴���, apply.���ڿ���  "
	chkSql = chkSql & " FROM ��������_������URL guest INNER JOIN ���ͳ��Ի�����_�������� apply ON guest.ä���Ϲ�ȣ=apply.ä��������Ϲ�ȣ AND guest.�Ի�������Ϲ�ȣ=apply.������ȣ "
	chkSql = chkSql & " WHERE guest.ä���Ϲ�ȣ='"&jid&"' AND guest.�Ի�������Ϲ�ȣ='"&applyid&"' "
	Rs.Open chkSql, DBCon, 0, 1
	If Not (Rs.BOF Or Rs.EOF) Then
		interviewDate	= Trim(Rs(0))
		interviewYoil	= Trim(Rs(1))
		interviewTimeCd	= Trim(Rs(2))
		interviewTime	= Trim(Rs(3))
		urlCd			= Trim(Rs(4))
		guestUrl		= Trim(Rs(5))
		resume_phone	= Trim(Rs(6))
		resume_email	= Trim(Rs(7))
	End If
	Rs.Close

		' ȭ����� �� ���� ���� ���� ���� üũ
		Set Rs2 = Server.CreateObject("ADODB.RecordSet")
		chkSql2 = "SELECT * FROM ��������_������URL WHERE URL�ڵ�='"&urlCd&"'"
		Rs2.Open chkSql2, DBCon, 0, 1
		If Not (Rs2.BOF Or Rs2.EOF) Then
			ontactYn = "Y"
		Else 	
			ontactYn = "N"
		End If
		Rs2.Close	


		If ontactYn = "N" Then ' �ش��Ͻÿ� ���� ������ ȭ�� ���� ���� ���� ��� ���� ���� ����

			'1) ȭ������� ȸ�� ���̵� ���� üũ
			Dim sql, arrRsdata, hostId
			sql = "SELECT ȭ�������ȸ����̵� FROM ��������_ȸ����̵� WHERE ȸ����̵�='"&comid&"' "
			arrRsdata = arrGetRsSql(DBCon, sql, "", "")
			If IsArray(arrRsdata) Then
				hostId = Trim(arrRsdata(0,0))
			Else 
				Response.Write "<script language=javascript>"&_
					"alert('ȭ������� ���̵� �߱޵��� �ʾҽ��ϴ�.\n����Ʈ �����ڿ��� ���̵� ���� ��û �ٶ��ϴ�.');"&_
					"location.href=history.go(-1);"&_
					"</script>"
				response.End 
			End If

			'2) �������� URL ���� ����
			Dim hostUrl : hostUrl = "https://vc.dial070.co.kr/"&urlCd&"?st="&serviceType_maltalk&"&id="&hostId&"&name="&comname
			sql2 = "SET NOCOUNT ON;"
			sql2 = sql2 &" INSERT INTO ��������_������URL ("
			sql2 = sql2 &" ä���Ϲ�ȣ, ������, �����ð�, URL�ڵ�, ������URL, ȸ����̵�, ȭ�������ȸ����̵�, API���ۿ��� "
			sql2 = sql2 &" ) VALUES ("
			sql2 = sql2 &" '"&jid&"', '"&interviewDate&"', '"&interviewTimeCd&"', '"&urlCd&"', '"&hostUrl&"', '"&comid&"', '"&hostId&"', 'N'"
			sql2 = sql2 &" );"
			DBCon.Execute(sql2)		


			'3) SMS������ ��ư Ŭ���ϰ� �������ڰ� ���� ��� ������ ���� API ����
			If CDate(interviewDate)=Date() Then 
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
	sql3 = sql3&"UPDATE ��������_������URL SET API���ۿ���='Y' WHERE ä���Ϲ�ȣ='"&jid&"' AND ȸ����̵�='"&comid&"' AND ������='"&interviewDate&"' AND �����ð�='"&interviewTimeCd&"'  " 
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


			'4) �������� Ȯ�� ���·� ����
			sql4 = "UPDATE ������������ SET ����Ȯ������='Y', ����Ȯ����=getdate() WHERE ä���Ϲ�ȣ='"&jid&"' AND ȸ����̵�='"&comid&"' AND ������='"&interviewDate&"' AND �����ð�='"&interviewTimeCd&"'  " 
			DBCon.Execute(sql4)

		End If


DisconnectDB DBCon


	'5) ȭ����� �ȳ� ���� �߼�	
	ConnectDB DBCon2, Application("DBInfo_etc")
	Dim now_time, msg, strSql, smsid
	now_time = year(now) & Right("0"&month(now),2) & Right("0"&day(now),2) & Right("0"&hour(now),2) & Right("0"&minute(now),2) & Right("0"&second(now),2)
	
	msg = "�ȳ��ϼ��� "&comname&" �λ�ä�� ������Դϴ�."& vbCrlf & vbCrlf
	msg = msg & "�����Ͻ� ä������� ���� �հݿ� ���� ȭ����� ���� �� ���� URL ���� �ȳ� �帳�ϴ�."& vbCrlf & vbCrlf
	msg = msg & "�� ȭ������Ͻ�: "&interviewDate&interviewYoil&" "&interviewTime&""& vbCrlf
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

		sql2 = "insert into arreo_sms (CMP_MSG_ID, CMP_USR_ID, ODR_FG, SMS_GB, USED_CD, MSG_GB, WRT_DTTM, SND_DTTM, SND_PHN_ID, RCV_PHN_ID, CALLBACK, SUBJECT, SND_MSG, EXPIRE_VAL, SMS_ST, RSLT_VAL, RSRVD_ID, RSRVD_WD)" &_
				" values ('" & smsid & "', '00000', '2', '1', '00', 'M', '" & now_time & "', '" & now_time & "', 'daumhr', '" & Replace(Replace(resume_phone, " ", ""),"-","") & "', '"& Replace(Replace(site_callback_phone, " ", ""),"-","") &"', '"&site_short_name&"', '" & msg & "', 0, '0', 99,'','');"
		DBCon2.Execute(sql2)
	End If
	Rs.Close
	DisconnectDB DBCon2		

	
	'6) ȭ����� �ȳ� ���� �߼�
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
								"<td style=""width:70%;padding:20px 0;vertical-align:top;font-size:17px;"">" & interviewDate&interviewYoil & " " & interviewTime & "</td>"&_
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
										"�� ���� �� On-tact ���� �ַ�ǿ��� ���� ����� ī�޶�, ����Ŀ, ����ũ�� ���� �۵��ϴ���<br>&nbsp;&nbsp;&nbsp;������ �̸� ������ �ּ���.<br>"&_
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



Response.Write "<script language=javascript>"&_
	"alert('ȭ����� ���� �ȳ� ����/���� �߼��� �Ϸ�Ǿ����ϴ�.');"&_
	"window.location=document.referrer;"&_
	"</script>"
Response.End 
%>