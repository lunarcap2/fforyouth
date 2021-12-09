<!--#include virtual = "/common/common.asp"-->
<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual="/wwwconf/function/library/KISA_SHA256.asp"-->
<!--#include virtual = "/wwwconf/function/library/AES256.asp"-->

<%
'--------------------------------------------------------------------
'   Comment		: 개인회원 가입
' 	History		: 2020-04-20, 이샛별 
'---------------------------------------------------------------------
Session.CodePage  = 949			'한글
Response.CharSet  = "euc-kr"	'한글
Response.AddHeader "Pragma","no-cache"
Response.AddHeader "cache-control", "no-staff"
Response.Expires  = -1


Response.AddHeader "P3P", "CP='ALL CURa ADMa DEVa TAIa OUR BUS IND PHY ONL UNI PUR FIN COM NAV INT DEM CNT STA POL HEA PRE LOC OTC'"

Dim txtId, txtPass, txtEmail, txtPhone, chkAgrPrv
Dim txtName, jumin1, juminH, zipcode, addr, detailAddr, chk_num
Dim univ_kind, univ_name, univ_major, univ_syear, univ_smonth, univ_eyear, univ_emonth, univ_etype
Dim jc_code, exp_info, exp_month, jc_content, area, home, employ, salary, salary_txt, salary_meet, hire_h2, hire_info, individual_info
Dim compId, encPass, juminLen7, juminLen13, univ_sdate, univ_edate

' step1. 개인회원정보 입력
txtId			= RTrim(LTrim(Replace(Request("txtId"), "'", "''")))						' 아이디
txtPass			= Replace(Request("txtPass"), "'", "''")									' 비밀번호
txtEmail		= RTrim(LTrim(LCase(Replace(Request("txtEmail"), " ", ""))))				' 이메일
txtPhone		= Request("txtPhone")														' 휴대폰번호
chkAgrPrv		= Request("chkAgrPrv")														' 홍보성 문자/이메일 수신 동의


' 연락처에 하이픈 누락된 경우 강제 설정
Dim len_txtPhone, strPhone
If InStr(txtPhone,"-")=0 Then 
	len_txtPhone	= Len(txtPhone)
	strPhone		= Left(txtPhone,3)&"-"&Mid(txtPhone,4,len_txtPhone-7)&"-"&Right(txtPhone,4)
Else 
	strPhone		= txtPhone
End If 


' step2. 구직신청서 작성
txtName			= RTrim(LTrim(Replace(Replace(Request("txtName"), "'", "''"), " ", "")))	' 이름
jumin1			= Request("jumin1")															' 주민등록번호(생년월일)
juminH			= Request("juminH")															' 주민등록번호 뒷자리(마스킹전)
zipcode			= Request("zipcode")														' 우편번호
addr			= Request("addr")															' 주소
detailAddr		= Request("detailAddr")														' 상세주소
chk_num			= Request("chk_num")														' 주민등록번호수집동의

univ_kind		= Request("univ_kind")														' 학력구분
univ_name		= Request("univ_name")														' 학교명
univ_major		= Request("univ_major")														' 전공
univ_syear		= Request("univ_syear")														' 입학년도
univ_smonth		= Request("univ_smonth")													' 입학월
univ_eyear		= Request("univ_eyear")														' 졸업년도
univ_emonth		= Request("univ_emonth")													' 졸업월
univ_etype		= Request("graduated")														' 졸업구분

jc_code			= Request("hdn_jc_name")													' 희망직종
exp_info		= Request("career")															' 희망입사형태
exp_month		= (CInt(Request("career_year")) * 12) + CInt(Request("hdn_career_month"))	' 희망입사형태 - 경력입력
jc_content		= Request("jc_content")														' 희망직무내용
area			= Request("hdn_area")														' 희망근무지역
home			= Request("home")															' 희망근무지역 - 재택근무
employ			= Request("hdn_employ")														' 고용형태
salary			= Request("hdn_salary")														' 희망입금형태및금액 - 입금형태
salary_txt		= Replace(Request("salary_txt"), ",", "")									' 희망입금형태및금액 - 금액입력
hire_h2			= Request("hire_h2")														' 구직알선희망정도
hire_info		= Request("hdn_hire_info")													' 구직정보제공동의여부
individual_info	= Request("individual_info")												' 개인정보 조회동의여부


' 공백제거
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


' 정상적인 경로로 이동하지 않은 경우 회원가입 화면으로 리턴
If Len(txtId) = 0 Or Len(txtPass) = 0 Then Response.Write "<meta http-equiv='refresh' content='0; url=http://" & Request.ServerVariables("SERVER_NAME") & "/my/signup/joinForm_member.asp'>"


compId		= txtId&"_wk"				' 개인회원아이디+"_wk" 조합
encPass		= SHA256_Encrypt(txtPass)	' 비번 암호화(sha256 방식)
juminLen7	= jumin1 & Left(juminH,1)	' 주민번호(생년월일 + 성별)
juminLen13	= jumin1 & juminH			' 주민번호전체(1234561234567)
univ_sdate	= univ_syear & univ_smonth	' 입학년월(202009)
univ_edate	= univ_eyear & univ_emonth	' 졸업년월(202009)


ConnectDB DBCon, Application("DBInfo_FAIR")



' 입력 아이디 중복 체크
SpName="usp_ID_CheckAll"
	Dim chkparam(1)
	chkparam(0)=makeParam("@user_id", adVarChar, adParamInput, 20, compId)
	chkparam(1)=makeParam("@rtn", adChar, adParamOutput, 1, "")

	Call execSP(DBCon, SpName, chkparam, "", "")

	rsltCmt = getParamOutputValue(chkparam, "@rtn")


If rsltCmt = "O" Then ' 입력한 아이디로 기존 가입된 정보가 없으면 회원 가입
	

	
	' 개인회원정보 insert
	SpName="usp_회원가입_개인_암호화"
		Dim param(9)
		param(0)=makeParam("@개인아이디", adVarChar, adParamInput, 20, compId)
		param(1)=makeParam("@암호화_비밀번호", adVarChar, adParamInput, 100, encPass)
		param(2)=makeParam("@성명", adVarChar, adParamInput, 30, txtName)
		param(3)=makeParam("@전자우편", adVarChar, adParamInput, 100, txtEmail)
		param(4)=makeParam("@휴대폰", adVarChar, adParamInput, 20, strPhone)
		param(5)=makeParam("@SMS수신", adChar, adParamInput, 1, chkAgrPrv)
		param(6)=makeParam("@사이트구분", adChar, adParamInput, 2, "W")
		param(7)=makeParam("@가입사이트구분코드", adChar, adParamInput, 2, "1")
		param(8)=makeParam("@주민번호앞자리", adVarChar, adParamInput, 7, juminLen7)
		param(9)=makeParam("@rtn", adChar, adParamOutput, 1, "")
	
		Call execSP(DBCon, SpName, param, "", "")

		sp_rtn = getParamOutputValue(param, "@rtn")
		

		' 아이디 값 유실 여부 체크 후 저장
		Dim sp_sub_rtn 
		If Len(compId)>3 Then 
	' SUB_개인회원정보 insert
	SpName="usp_회원가입_SUB_개인회원정보"
		Dim subparam(25)
		subparam(0)=makeParam("@개인아이디", adVarChar, adParamInput, 20, compId)
		subparam(1)=makeParam("@주민등록번호", adVarChar, adParamInput, 500, objEncrypter.Encrypt(juminLen13))
		subparam(2)=makeParam("@우편번호", adVarChar, adParamInput, 5, zipcode)
		subparam(3)=makeParam("@주소", adVarChar, adParamInput, 500, addr)
		subparam(4)=makeParam("@상세주소", adVarChar, adParamInput, 500, detailAddr)
		subparam(5)=makeParam("@주민등록번호수집동의", adChar, adParamInput, 1, chk_num)
		subparam(6)=makeParam("@학력구분", adChar, adParamInput, 1, univ_kind)
		subparam(7)=makeParam("@학교명", adVarChar, adParamInput, 100, univ_name)
		subparam(8)=makeParam("@전공명", adVarChar, adParamInput, 100, univ_major)
		subparam(9)=makeParam("@입학년월", adChar, adParamInput, 6, univ_sdate)
		subparam(10)=makeParam("@졸업년월", adChar, adParamInput, 6, univ_edate)
		subparam(11)=makeParam("@졸업구분", adChar, adParamInput, 2, univ_etype)
		subparam(12)=makeParam("@희망직종코드", adVarChar, adParamInput, 10, jc_code)
		subparam(13)=makeParam("@희망입사형태", adChar, adParamInput, 1, exp_info)
		subparam(14)=makeParam("@경력월수", adInteger, adParamInput, 4, exp_month)
		subparam(15)=makeParam("@희망직무내용", adVarChar, adParamInput, 100, jc_content)
		subparam(16)=makeParam("@희망근무지역", adVarChar, adParamInput, 100, area)
		subparam(17)=makeParam("@재택근무", adChar, adParamInput, 1, home)
		subparam(18)=makeParam("@고용형태", adVarChar, adParamInput, 100, employ)
		subparam(19)=makeParam("@희망입금형태", adChar, adParamInput, 2, salary)
		subparam(20)=makeParam("@희망입금금액", adInteger, adParamInput, 4, salary_txt)
		subparam(21)=makeParam("@구직알선희망정도", adChar, adParamInput, 1, hire_h2)
		subparam(22)=makeParam("@구직정보제공동의여부", adVarChar, adParamInput, 100, hire_info)
		subparam(23)=makeParam("@개인정보조회동의여부", adChar, adParamInput, 1, individual_info)  
		subparam(24)=makeParam("@rtn", adChar, adParamOutput, 1, "")
		subparam(25)=makeParam("@주민번호뒷자리", adVarChar, adParamInput, 200, juminH) 

	
		Call execSP(DBCon, SpName, subparam, "", "")

			sp_sub_rtn = getParamOutputValue(subparam, "@rtn")
		Else
			sp_sub_rtn = "X"
		End If 
		'Response.write "sp_rtn: " & sp_rtn & "<br>"
		'Response.write "sp_sub_rtn: " & sp_sub_rtn & "<br>"


		'#### 유입 경로 저장
		Dim strSql2, strRemoteAddr, strUserAgent
		strRemoteAddr	= Request.ServerVariables("REMOTE_ADDR")
        strUserAgent	= Request.ServerVariables("HTTP_USER_AGENT")	
		strSql2 = "insert into LOG_회원가입환경정보(회원아이디, 가입아이피, 가입환경) values('"&compId&"', '"&strRemoteAddr&"', '"&strUserAgent&"')"
		DBCon.Execute(strSql2)

	

	If (sp_rtn = "O" And sp_sub_rtn = "O") Then	' 정상 가입 완료 시 자동로그인 처리

		'#### 회원가입 완료 메일 전송
		Dim strSql, arrRsView, mailForm
		strSql = "SELECT 개인아이디, 등록일 FROM 개인회원정보 WITH(NOLOCK) WHERE 개인아이디 ='" & compId & "'"
		arrRsView = arrGetRsSql(DBCon, strSql, "", "")
		
		mailForm = "<html>"&_
					"<head>"&_
						"<title>" & site_name & "</title>"&_
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
											"안녕하세요. <strong>" & txtName & "</strong>님<br>"&_
											site_name & "회원에 가입해 주셔서 감사합니다.<br>"&_
											site_name & "의 다양한 채용정보를 확인하세요.<br>"&_
										"</p>"&_
										"<table border=""0"" cellspacing=""0"" cellpadding=""0"" align=""center"" style=""width:100%;"">"&_
											"<colgroup>"&_
												"<col style=""width:44%;"">"&_
												"<col style=""width:56%;"">"&_
											"</colgroup>"&_
											"<tbody>"&_
												"<tr>"&_
													"<th style=""width:44%;padding:20px 20px 20px 0;vertical-align:top;text-align:right;font-size:17px;"">가입일시</th>"&_
													"<td style=""width:56%;padding:20px 0 20px 20px;vertical-align:top;text-align:left;font-size:17px;"">" & arrRsView(1,0) & "</td>"&_
												"</tr>"&_
												"<tr>"&_
													"<th style=""width:44%;padding:20px 20px 20px 0;vertical-align:top;text-align:right;font-size:17px;"">가입ID</th>"&_
													"<td style=""width:56%;padding:20px 0 20px 20px;vertical-align:top;text-align:left;font-size:17px;"">" & Replace(arrRsView(0,0),"_wk","") & "</td>"&_
												"</tr>"&_
												"<tr>"&_
													"<td colspan=""2"" style=""padding:20px 20px 0 50px;"">"&_
														"<p style=""font-size:15px;line-height:1.5;letter-spacing:0;color:#000;text-align:left;"">"&_
															"※" & site_name & "는 온라인으로만 채용이 진행됩니다.<br>"&_
															"※ 원하는 공고에 지원하려면 온라인 이력서를 작성해야만 지원이 가능합니다."&_
														"</p>"&_
													"</td>"&_
												"</tr>"&_
												"<tr>"&_
													"<td colspan=""2"" style=""padding:20px 20px 0 20px;text-align:right;"">"&_
														"<a href=""http://" & Request.ServerVariables("SERVER_NAME") & "/my/resume/resume_regist.asp"" target=""_blank"">이력서 등록하러 가기</a>"&_
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
		mailer.Subject = "["& site_name & "] " & "회원가입이 완료되었습니다."
		mailer.HTMLBody = mailForm
		mailer.BodyPart.Charset="ks_c_5601-1987"
		mailer.HTMLBodyPart.Charset="ks_c_5601-1987"
		mailer.Send
		set mailer = Nothing

		'#### 회원정보 쿠키 할당
		Response.Cookies(site_code & "WKP_F")("id")			= Replace(compId, "_wk", "")
		Response.Cookies(site_code & "WKP_F")("name")		= txtName
		Response.Cookies(site_code & "WKP_F")("email")		= txtEmail
		Response.Cookies(site_code & "WKP_F")("cellphone")	= strPhone
		Response.Cookies(site_code & "WKP_F").Domain		= "career.co.kr"
		'Response.Cookies("WKP_F").Domain	= Request.ServerVariables("SERVER_NAME")	' 도메인 설정

		Response.Write "<script language=javascript>"&_
		 "alert('회원가입이 완료되었습니다.');"&_
		"location.href='/';"&_
		"</script>"
		response.End 

	Else ' 회원 정보 저장 중 오류 발생 리턴
		Response.Write "<script language=javascript>"&_
		 "alert('회원가입 중 오류가 발생했습니다.\n다시 시도해 주세요.');"&_
		"location.href='/my/signup/joinForm_member.asp';"&_
		"</script>"
		response.End 
	End If 
Else	' 입력한 아이디로 가입된 정보가 존재할 경우 회원 가입 페이지 리턴
	Response.Write "<script language=javascript>"&_
	 "alert('입력하신 아이디로 가입된 정보가 존재합니다.\n다른 아이디로 다시 시도해 주세요.');"&_
	"location.href='/my/signup/joinForm_member.asp';"&_
	"</script>"
	response.End 
End If 

DisconnectDB DBCon
%>