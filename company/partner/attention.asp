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

	Dim com_idnum, company_name, ArrRs, ArrRs2, totalcnt, chk_cnt

	com_idnum		= Request("com_idnum")
	company_name	= unescape(Request.form("company_name"))

	company_name = replace(company_name, "㈜", "(주)")

	ConnectDB DBCon, Application("DBInfo_FAIR")

	If com_idnum <> "" Then
		ArrRs		= arrGetRsSql(DBCon,"SELECT COUNT(개인아이디) FROM 개인관심기업 WHERE 개인아이디 = '" & user_id & "'","","")
		totalcnt	= ArrRs(0, 0)

		ArrRs2		= arrGetRsSql(DBCon,"SELECT 등록번호 FROM 개인관심기업 WHERE 사업자등록번호 = '" & com_idnum & "' and 개인아이디 = '" & user_id & "'","","")
		
		If isArray(ArrRs2) Then
			strSql = "DELETE 개인관심기업 WHERE 개인아이디 = '" & user_id & "' AND 등록번호 = '" & ArrRs2(0, 0) & "'"
			
			Call execSqlParam(DBCon, strSql, "", "", "")

			result = "2"
		Else
			chk_cnt = totalcnt + 1 '지금까지 등록한 관심기업 + 지금부터 추가할 관심기업

			If chk_cnt > 50 Then '50개 제한		
				Response.write "50"
				Response.End
			End If  
			
			strSql = "INSERT INTO 개인관심기업 (개인아이디, 사업자등록번호, 회사명, 회사아이디, 등록일, 사이트) " &_
					 "VALUES ('"& user_id &"', '"& com_idnum &"', '"& company_name &"', '', GETDATE(), 'P')"
			
			Call execSqlParam(DBCon, strSql, "", "", "")

			result = "1"				
		End If
	Else
		result = "0"
	End If

	Response.write result

	DisconnectDB DBCon
%>