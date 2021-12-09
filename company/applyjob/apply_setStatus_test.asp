<%
	session.codepage = "65001"
	response.expires = -1
	response.cachecontrol = "no-cache"
	response.charset = "utf-8"
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<%
	Response.AddHeader "P3P", "CP='ALL CURa ADMa DEVa TAIa OUR BUS IND PHY ONL UNI PUR FIN COM NAV INT DEM CNT STA POL HEA PRE LOC OTC'"

	Dim gubun, mode, jid, apply_num, status, tgb_str
	gubun		= Request("gubun")
	mode		= Request("mode")
	jid			= Request("jid")
	apply_num	= Request("apply_num")
	status		= Request("status")

	If mode = "cl" Then
		tgb_str = "마감"
	Else
		tgb_str = ""
	End If

	ConnectDB DBCon, Application("DBInfo_FAIR")
		Dim strSql, result, str_apply_num
		strSql = ""
		strSql = strSql & " SELECT 등록번호 " 
		strSql = strSql & "   FROM " & tgb_str & "사이버채용정보 "
		strSql = strSql & "  WHERE 채용정보등록번호 = '" & jid & "' " 
		strSql = strSql & "    AND 상태 = '1' "
		strSql = strSql & "    AND 등록번호 IN (SELECT value FROM dbo.fn_Split('" & apply_num & "', ',')) "
		
		result = arrGetRsParam(DBCon, strSql, "", "", "")

		If isArray(result) Then
			For i=0 to ubound(result, 2)
				str_apply_num = str_apply_num & "," & result(0,i)
			Next
		End If
		
		Dim SpName : SpName = "USP_BIZSERVICE_APPLY_STATUS_UPDATE"
		ReDim param(5)
		param(0) = makeParam("@Gubun", adVarChar, adParamInput, 1, gubun)
		param(1) = makeParam("@ListType", adVarChar, adParamInput, 10, mode)
		param(2) = makeParam("@jid", adInteger, adParamInput, 4, jid)
		param(3) = makeParam("@ApplyNum", adVarChar, adParamInput, 500, apply_num)
		param(4) = makeParam("@Status", adVarChar, adParamInput, 1, status)
		param(5) = makeParam("@Rtn", adInteger, adParamOutput, 4, "")

		'@Gubun VARCHAR(1) -- 1:지원자삭제 2:지원자열람 3:지원자상태 변경    
		'@ListType VARCHAR(10) -- 리스트구분 : (ing)진행, (cl)마감    
		'@jid INT --채용공고번호    
		'@ApplyNum VARCHAR(500) --입사지원 번호    
		'@Status VARCHAR(1) = '' --(Gubun=3 에서만 사용) 1:심사전 2:검토중 3:서류합격 4:최종합격 5:불합격    
		'@Rtn INT OUTPUT    
		
		'Call execSP(DBCon, SpName, param, "", "")
		'rtn = getParamOutputValue(param, "@Rtn")
		rtn = "1"

		If rtn = "1" Then
			Dim strSql2, result2, ii
			strSql2 = ""
			strSql2 = strSql2 & " SELECT A.성명, B.회사명, B.모집내용제목 "
			strSql2 = strSql2 & "      , CASE WHEN (SELECT COUNT(등록번호) FROM 마감채용정보 WITH(NOLOCK) WHERE 등록번호 = B.등록번호) > 0 THEN '마감' "
			strSql2 = strSql2 & "		     WHEN B.접수마감종류 = 1 THEN CONVERT(CHAR(10), B.접수마감일, 23) "
			strSql2 = strSql2 & "		     WHEN B.접수마감종류 = 2 THEN '채용시마감' "
			strSql2 = strSql2 & "		     ELSE '상시채용' "
			strSql2 = strSql2 & "	    END AS EDATE "
			strSql2 = strSql2 & "      , (SELECT COUNT(채용등록번호) FROM " & tgb_str & "기업열람용이력서리스트 WHERE 채용등록번호 = A.채용등록번호) AS CNT "
			strSql2 = strSql2 & "	  , A.전자우편 "
			strSql2 = strSql2 & "  FROM  " & tgb_str & "기업열람용이력서리스트 AS A WITH(NOLOCK) "
			strSql2 = strSql2 & " INNER JOIN " & tgb_str & "채용정보 AS B WITH(NOLOCK) ON A.채용등록번호 = B.등록번호 "
			strSql2 = strSql2 & " WHERE A.채용등록번호 = '" & jid & "' "
			strSql2 = strSql2 & "   AND A.지원번호 IN (SELECT value FROM dbo.fn_Split('" & Mid(str_apply_num,2,Len(str_apply_num)) & "', ',')) "

			result2 = arrGetRsParam(DBCon, strSql2, "", "", "")
			
			If isArray(result2) Then
				For ii=0 to ubound(result2, 2)
					Dim applyNM, comNM, jobTit, EDate, TotalCnt, applyEmail
					applyNM		= result2(0,ii)
					comNM		= result2(1,ii)
					jobTit		= result2(2,ii)
					EDate		= result2(3,ii)
					TotalCnt	= result2(4,ii)
					applyEmail	= result2(5,ii)

					Dim mailForm, iConf, mailer
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
														"안녕하세요. <strong>" & applyNM & "</strong>님<br>"&_
														"<strong>" & comNM &" 채용담당자가 지원하신 이력서를 열람했습니다.</strong><br>"&_
													"</p>"&_
													"<table border=""0"" cellspacing=""0"" cellpadding=""0"" align=""center"" style=""width:100%;"">"&_
														"<colgroup>"&_
															"<col style=""width:30%;"">"&_
															"<col style=""width:70%;"">"&_
														"</colgroup>"&_
														"<tbody>"&_
															"<tr>"&_
																"<th style=""width:30%;padding:10px 10px 10px 0;vertical-align:top;text-align:right;font-size:17px;"">채용공고문</th>"&_
																"<td style=""width:70%;padding:10px 0 10px 10px;vertical-align:top;text-align:left;font-size:17px;"">" & jobTit & "</td>"&_
															"</tr>"&_
															"<tr>"&_
																"<th style=""width:30%;padding:10px 10px 10px 0;vertical-align:top;text-align:right;font-size:17px;"">공고마감일</th>"&_
																"<td style=""width:70%;padding:10px 0 10px 10px;vertical-align:top;text-align:left;font-size:17px;"">" & EDate & "</td>"&_
															"</tr>"&_
															"<tr>"&_
																"<th style=""width:30%;padding:10px 10px 10px 0;vertical-align:top;text-align:right;font-size:17px;"">현재까지 지원자</th>"&_
																"<td style=""width:70%;padding:10px 0 10px 10px;vertical-align:top;text-align:left;font-size:17px;"">" & TotalCnt &"명</td>"&_
															"</tr>"&_
															"<tr>"&_
																"<td colspan=""2"" style=""padding:10px 20px 10px 20px;text-align:center;"">"&_
																	"<a href=""http://" & equest.ServerVariables("SERVER_NAME") & "/my/job_application_list.asp"" target=""_blank"">"&_
																		"<img border=""0"" alt=""지원 현황 보러가기"" src=""http://image.career.co.kr/career_new/event/2020/starfield/view_btn.jpg"">"&_
																	"</a>"&_
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

					Response.write mailForm & "<br><br><br>"


				Next 	
			End If
		End If		
		
	DisconnectDB DBCon
	
	Response.write rtn
%>	