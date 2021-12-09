<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual="/common/common.asp"--> 
<!--#include virtual="/include/header/header.asp"-->
<%
'--------------------------------------------------------------------
'   Comment		: 화상면접 배정 지원자 대상 문자/메일 발송
' 	History		: 2020-07-15, 이샛별 
'---------------------------------------------------------------------
Session.CodePage  = 949			'한글
Response.CharSet  = "euc-kr"	'한글
Response.AddHeader "Pragma","no-cache"
Response.AddHeader "cache-control", "no-staff"
Response.Expires  = -1

Dim jid		: jid		= Request("jid")		' 채용공고번호
Dim applyid	: applyid	= Request("applyid")	' 입사지원번호

If jid="" Or applyid="" Then 
	Response.Write "<script language=javascript>"&_
		"alert('해당 메뉴에 대한 접근 권한이 없습니다.');"&_
		"location.href=history.go(-1);"&_
		"</script>"
	response.End 
End If


If comid="" Then 
	Response.Write "<script language=javascript>"&_
		"alert('해당 메뉴에 대한 접근 권한이 없습니다.');"&_
		"location.href='/';"&_
		"</script>"
	response.End 
End If


' 화상면접 일정 및 guest용 URL 정보 추출
ConnectDB DBCon, Application("DBInfo_FAIR")

	Set Rs = Server.CreateObject("ADODB.RecordSet")
	chkSql = "SELECT TOP 1 guest.면접일, '('+left(DATENAME(DW, guest.면접일),1)+')' AS yoil, guest.면접시간, "
	chkSql = chkSql & " CASE guest.면접시간 WHEN 1 THEN '09:00~09:25 (25분)' WHEN 2 THEN '09:30~09:55 (25분)' WHEN 3 THEN '10:00~10:25 (25분)' WHEN 4 THEN '10:30~10:55 (25분)' WHEN 5 THEN '11:00~11:25 (25분)' WHEN 6 THEN '11:30~11:55 (25분)' WHEN 7 THEN '13:00~13:25 (25분)' WHEN 8 THEN '13:30~13:55 (25분)' WHEN 9 THEN '14:00~14:25 (25분)' WHEN 10 THEN '14:30~14:55 (25분)' WHEN 11 THEN '15:00~15:25 (25분)' WHEN 12 THEN '15:30~15:55 (25분)' WHEN 13 THEN '16:00~16:25 (25분)' WHEN 14 THEN '16:30~16:55 (25분)' WHEN 15 THEN '17:00~17:25 (25분)' WHEN 16 THEN '17:30~17:55 (25분)' END AS tm, guest.URL코드, guest.지원자URL, apply.휴대폰, apply.전자우편  "
	chkSql = chkSql & " FROM 면접배정_지원자URL guest INNER JOIN 인터넷입사지원_개인정보 apply ON guest.채용등록번호=apply.채용정보등록번호 AND guest.입사지원등록번호=apply.지원번호 "
	chkSql = chkSql & " WHERE guest.채용등록번호='"&jid&"' AND guest.입사지원등록번호='"&applyid&"' "
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

		' 화상면접 방 개설 정보 존재 여부 체크
		Set Rs2 = Server.CreateObject("ADODB.RecordSet")
		chkSql2 = "SELECT * FROM 면접배정_면접관URL WHERE URL코드='"&urlCd&"'"
		Rs2.Open chkSql2, DBCon, 0, 1
		If Not (Rs2.BOF Or Rs2.EOF) Then
			ontactYn = "Y"
		Else 	
			ontactYn = "N"
		End If
		Rs2.Close	


		If ontactYn = "N" Then ' 해당일시에 기존 개설된 화상 면접 방이 없을 경우 관련 정보 저장

			'1) 화상면접용 회사 아이디 정보 체크
			Dim sql, arrRsdata, hostId
			sql = "SELECT 화상면접용회사아이디 FROM 면접배정_회사아이디 WHERE 회사아이디='"&comid&"' "
			arrRsdata = arrGetRsSql(DBCon, sql, "", "")
			If IsArray(arrRsdata) Then
				hostId = Trim(arrRsdata(0,0))
			Else 
				Response.Write "<script language=javascript>"&_
					"alert('화상면접용 아이디가 발급되지 않았습니다.\n사이트 관리자에게 아이디 생성 요청 바랍니다.');"&_
					"location.href=history.go(-1);"&_
					"</script>"
				response.End 
			End If

			'2) 면접관용 URL 정보 저장
			Dim hostUrl : hostUrl = "https://vc.dial070.co.kr/"&urlCd&"?st="&serviceType_maltalk&"&id="&hostId&"&name="&comname
			sql2 = "SET NOCOUNT ON;"
			sql2 = sql2 &" INSERT INTO 면접배정_면접관URL ("
			sql2 = sql2 &" 채용등록번호, 면접일, 면접시간, URL코드, 면접관URL, 회사아이디, 화상면접용회사아이디, API전송여부 "
			sql2 = sql2 &" ) VALUES ("
			sql2 = sql2 &" '"&jid&"', '"&interviewDate&"', '"&interviewTimeCd&"', '"&urlCd&"', '"&hostUrl&"', '"&comid&"', '"&hostId&"', 'N'"
			sql2 = sql2 &" );"
			DBCon.Execute(sql2)		


			'3) SMS보내기 버튼 클릭일과 면접일자가 같을 경우 면접방 개설 API 전송
			If CDate(interviewDate)=Date() Then 
%>
<script type="text/javascript">
	// 화상면접용 URL 생성
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
	sql3 = sql3&"UPDATE 면접배정_면접관URL SET API전송여부='Y' WHERE 채용등록번호='"&jid&"' AND 회사아이디='"&comid&"' AND 면접일='"&interviewDate&"' AND 면접시간='"&interviewTimeCd&"'  " 
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


			'4) 면접배정 확정 상태로 변경
			sql4 = "UPDATE 면접배정정보 SET 면접확정여부='Y', 면접확정일=getdate() WHERE 채용등록번호='"&jid&"' AND 회사아이디='"&comid&"' AND 면접일='"&interviewDate&"' AND 면접시간='"&interviewTimeCd&"'  " 
			DBCon.Execute(sql4)

		End If


DisconnectDB DBCon


	'5) 화상면접 안내 문자 발송	
	ConnectDB DBCon2, Application("DBInfo_etc")
	Dim now_time, msg, strSql, smsid
	now_time = year(now) & Right("0"&month(now),2) & Right("0"&day(now),2) & Right("0"&hour(now),2) & Right("0"&minute(now),2) & Right("0"&second(now),2)
	
	msg = "안녕하세요 "&comname&" 인사채용 담당자입니다."& vbCrlf & vbCrlf
	msg = msg & "지원하신 채용공고의 서류 합격에 따른 화상면접 일정 및 참여 URL 정보 안내 드립니다."& vbCrlf & vbCrlf
	msg = msg & "■ 화상면접일시: "&interviewDate&interviewYoil&" "&interviewTime&""& vbCrlf
	msg = msg & "■ URL : "&guestUrl&""& vbCrlf & vbCrlf
	msg = msg & "※ 화상 면접 서비스는 크롬(Chrome) 브라우저로 접속했을 경우에만 이용 가능합니다."& vbCrlf	 & vbCrlf	
	msg = msg & "※ 안드로이드 기반 휴대폰에서 화상면접 링크로 접속했을 때 보안인증 관련 안내 문구 발생 시 아래 순서를 따라 기본 브라우저 설정을 변경해 주세요."& vbCrlf
	msg = msg & "▶ Android환경 기기에 따라 다음 중 한 가지 방법을 사용하여 Google 설정을 찾습니다."& vbCrlf
	msg = msg & "① 기기의 설정 앱을 엽니다."& vbCrlf
	msg = msg & "② 애플리케이션 관리를 누릅니다.(LG폰일 경우 일반> 앱 및 관리)"& vbCrlf
	msg = msg & "③ 기본 앱을 탭합니다."& vbCrlf
	msg = msg & "④ 브라우저 앱을 탭합니다."& vbCrlf
	msg = msg & "⑤ Chrome을 탭합니다."& vbCrlf & vbCrlf				
	msg = msg & "※ 해당 URL은 면접 당일에 한하여 접속 허용되니 지정된 면접시간에 맞춰 입장 바랍니다."& vbCrlf
	msg = msg & "※ 크롬을 제외한 인터넷익스플로러(IE) 등의 브라우저에서는 화상 면접 서비스가 지원되지 않습니다."& vbCrlf
	msg = msg & "※ PC/휴대폰을 사용하여 화상 면접에 참여 가능하며, 이력서에 기재하신 메일 주소로도 면접 안내 메일이 발송되었으니 PC로 면접 참여 시 참고하시면 됩니다."& vbCrlf
	msg = msg & "※ 원활한 진행을 위해 화상면접 참여 전 접속 휴대폰의 카메라, 스피커, 마이크가 정상 작동되는지 체크해 주세요."& vbCrlf
	msg = msg & "※ 휴대폰으로 화상면접에 참여할 경우 화면을 가로로 하여 접속 바랍니다."& vbCrlf & vbCrlf

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

	
	'6) 화상면접 안내 메일 발송
	Dim mailForm, iConf, mailer
	mailForm = "<html>"&_
	"<head>"&_
	"<title>"& site_name &"</title>"&_
	"<meta content=""text/html; charset=euc-kr"" http-equiv=""Content-Type"" />"&_
	"<meta http-equiv=""X-UA-Compatible"" content=""IE=Edge"">"&_
	"</head>"&_
	"<body style=""text-align: center; padding-bottom: 0px; margin: 0px; padding-left: 0px; padding-right: 0px; font-family: Dotum, '돋움', Times New Roman, sans-serif; background: #ffffff; color: #666; font-size: 12px; padding-top: 0px"">"&_
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
						"안녕하세요. " & comname & " 채용담당자 입니다.<br>"&_
						"<strong>아래와 같이 화상면접 일정이 확정되어 공지 드립니다.</strong><br>"&_
						"해당일시에 참석하셔서 면접 후 좋은 결과가 있으시기를 응원하겠습니다."&_
					"</p>"&_
					"<table border=""0"" cellspacing=""0"" cellpadding=""0"" align=""center"">"&_
						"<colgroup>"&_
							"<col style=""width:35%;"">"&_
							"<col style=""width:65%;"">"&_
						"</colgroup>"&_
						"<tbody>"&_
							"<tr>"&_
								"<th style=""width:30%;padding:20px;vertical-align:top;font-size:17px;text-align:right;"">On-tact 면접 일시</th>"&_
								"<td style=""width:70%;padding:20px 0;vertical-align:top;font-size:17px;"">" & interviewDate&interviewYoil & " " & interviewTime & "</td>"&_
							"</tr>"&_
							"<tr>"&_
								"<th style=""width:30%;padding:20px;vertical-align:top;font-size:17px;text-align:right;"">On-tact 면접 주소</th>"&_
								"<td style=""width:70%;padding:20px 0;vertical-align:top;font-size:17px;"">"&_
									"<a href=""" & guestUrl & """ target=""_blank"">바로가기</a>"&_
									"<br><br>" & guestUrl & "</td>"&_
							"</tr>"&_
							"<tr>"&_
								"<td colspan=""2"" style=""padding:20px 20px 0 30px;"">"&_
									"<p style=""font-size:15px;line-height:1.5;letter-spacing:0;color:#000;text-align:left;"">"&_
										"※ On-tact 면접주소는 면접 당일에 한하여 접속이 허용됩니다. 면접일시를 확인하고 시간에<br>&nbsp;&nbsp;&nbsp;맞게 입장해 주세요.<br>"&_
										"※ 입장 시 On-tact 면접 솔루션에서 접속 기기의 카메라, 스피커, 마이크가 정상 작동하는지<br>&nbsp;&nbsp;&nbsp;사전에 미리 점검해 주세요.<br>"&_
										"※ 인터넷 익스플로러(IE)에서는 On-tact 면접 서비스가 지원되지 않습니다.<br>&nbsp;&nbsp;&nbsp;솔루션이 최적화 된 Chrome(크롬)을 통해서 접속해 주세요."&_
									"</p>"&_
								"</td>"&_
							"</tr>"&_
							"<tr>"&_
								"<td colspan=""2"" style=""padding:20px 20px 0 20px;text-align:right;"">"&_
									"<a href=""https://www.google.com/intl/ko/chrome/"" target=""_blank"">Chrome 다운로드</a>&nbsp;"&_
									"<a href=""https://" & Request.ServerVariables("SERVER_NAME") & "/board/notice_view.asp?seq=53"" target=""_blank"">Chrome을 기본 브라우저로 설정하는 방법</a>"&_
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
	mailer.Subject	= "["& site_name &"] 지원하신 "&comname&" 채용공고의 서류합격에 따른 화상면접 일정 안내 드립니다."
	mailer.HTMLBody	= mailForm
	mailer.BodyPart.Charset="ks_c_5601-1987"
	mailer.HTMLBodyPart.Charset="ks_c_5601-1987"
	mailer.Send
	Set mailer = Nothing



Response.Write "<script language=javascript>"&_
	"alert('화상면접 일정 안내 문자/메일 발송이 완료되었습니다.');"&_
	"window.location=document.referrer;"&_
	"</script>"
Response.End 
%>