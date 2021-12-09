<%
	 Response.CharSet="euc-kr"
     Session.codepage="949"
     Response.codepage="949"
     Response.ContentType="text/html;charset=euc-kr"
%>

<!--#include virtual = "/common/common.asp"-->
<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->

<%
	Response.AddHeader "P3P", "CP='ALL CURa ADMa DEVa TAIa OUR BUS IND PHY ONL UNI PUR FIN COM NAV INT DEM CNT STA POL HEA PRE LOC OTC'"

	Dim mode, jid, gubun, kw, rece_type, rece_sch
	Dim content, rtn_value
	
	mode		= Request("mode")
	jid			= Request("jid")
	gubun		= Request("gubun")
	kw			= Trim(unescape(Request.form("kw")))
	rece_type	= Request("rece_type")
	rece_sch	= Request("rece_sch")

	ConnectDB DBCon, Application("DBInfo_FAIR")

	strSql = "SELECT RECE_CON FROM tbl_result_save_con WHERE COMID = '" & comid & "' AND RECE_TYPE = '" & rece_type & "' AND RECE_SCH = '" & rece_sch & "'"
	rtn_value = arrGetRsParam(DBCon, strSql, "", "", "")
	
	If isArray(rtn_value) Then
		content = rtn_value(0,0)
	End If

	Response.write content & "@"

	SpName="USP_APPLY_RECEIVERLIST"

	ReDim param(3)
	param(0) = makeParam("@mode", adVarChar, adParamInput, 10, mode)
	param(1) = makeParam("@jid", adVarChar, adParamInput, 30, jid)
	param(2) = makeParam("@gubun", adChar, adParamInput, 1, gubun)
	param(3) = makeParam("@kw", adVarChar, adParamInput, 100, kw)

	rtn_value = arrGetRsSP(DBCon, SpName, param, "", "")

	If isArray(rtn_value) Then
		Dim i, birth_ymd, birth_age, career_str, tot_sum, arrRsSchool, strFinalSchool
			
			For i = 0 to ubound(rtn_value, 2)
				'생년 / 나이
				If rtn_value(3, i) = "1" Or rtn_value(3, i) = "2" Then 
					birth_ymd = "19" & Left(rtn_value(2, i), 2)
					birth_age = Left(Date(), 4) - birth_ymd + 1
				ElseIf rtn_value(3, i) = "3" Or rtn_value(3, i) = "4" Then 
					birth_ymd = "20" & Left(rtn_value(2, i), 2)
					birth_age = Left(Date(), 4) - birth_ymd + 1
				End If

				'경력표기
				tot_sum = Abs(rtn_value(5, i))

				If tot_sum = "0" Then 
					career_str = "신입"
				ElseIf tot_sum > 12 Then
					career_str = fix(tot_sum / 12) & "년 " & tot_sum mod 12 & "개월"
				Else 
					career_str = tot_sum & "개월"
				End If
				
				' 학교
				Select Case rtn_value(4, i)
					Case "3" : strFinalSchool = "고등학교"
					Case "4" : strFinalSchool = "대학(2,3년)"
					Case "5" : strFinalSchool = "대학교(4년)"
					Case "6" : strFinalSchool = "대학원"
					Case Else strFinalSchool = ""
				End Select

				'회원탈퇴여부
				Dim secession
				If rtn_value(7, i) = "Y" Then
					secession = " (탈퇴회원)"
				Else
					secession = ""
				End If
				
				Response.write "<tr>"
				Response.write "<td>"
				Response.write "<label class='checkbox off'>"
				Response.write "<input class='chk' id='' name='rece_list' type='checkbox' value='" & rtn_value(6,i) & "' onclick='checkboxFnc();'>"
				Response.write "</label>"
				Response.write "</td>"
				Response.write "<td>" & rtn_value(0,i) & " (" & birth_ymd & "년생, " & birth_age & "세)" & secession & "</td>"
				
				strSql = " SELECT 학교명, 전공명, 졸업구분 FROM 이력서학력 WHERE 등록번호 = '" & rtn_value(1,i) & "' AND 학력종류 = '" & rtn_value(4,i) & "' "
				arrRsSchool = arrGetRsParam(DBCon, strSql, "", "", "")
				
				If isArray(arrRsSchool) Then
					Dim GraduatedState
					Select Case arrRsSchool(2,0)
						Case "3" : GraduatedState = "재학"
						Case "4" : GraduatedState = "휴학"
						Case "5" : GraduatedState = "중퇴"
						Case "7" : GraduatedState = "졸업(예)"
						Case "8" : GraduatedState = "졸업"
					End Select

					Response.write "<td>" & strFinalSchool & "&nbsp;" & GraduatedState & "<br>" & arrRsSchool(0,0) & "&nbsp;" & arrRsSchool(1,0) & "</td>"
				Else
					Response.write "<td>-</td>"
				End If
				
				Response.write "<td>" & career_str & "</td>"
				Response.write "</tr>"
			Next
	Else
		Response.write "<tr>"
		Response.write "<td colspan='4'>결과에 해당하는 지원자가 없습니다.</td>"
		Response.write "</tr>"
	End If									

	DisconnectDB DBCon
%>