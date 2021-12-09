<%option explicit%>

<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/inc/function/auth/clearCookie.asp"-->
<!--#include virtual = "/wwwconf/function/library/CryptoHelper.asp"-->
<!--#include virtual = "/wwwconf/function/library/KISA_SHA256.asp"-->

<%
	Response.AddHeader "P3P", "CP=ALL CURa ADMa DEVa TAIa OUR BUS IND PHY ONL UNI PUR FIN COM NAV INT DEM CNT STA POL HEA PRE LOC OTC"
	Response.CacheControl="no-cache"
	Response.AddHeader "Pragma", "no-cache"
	Response.Expires=-1
	
	
	redir = Request("redir")

	' 인트로 유입 경로에 따라 채용관 연결 아이콘 제어(현재위치 - W: 일경험, D: 디지털)
	'Dim set_url
	'If introType = "W" Then
	'set_url = "/work/default.asp"
	'Else
	'set_url = "/digital/default.asp"
	'End If

	dim hostnm		: hostnm	= "http://" & Request.ServerVariables("SERVER_NAME")
	Dim pagegb		: pagegb	= Request("pagegb")
	dim svc			: svc		= Request("svc")
	dim from		: from		= Request("from")
	dim msg			: msg		= ""
	dim nv_query	: nv_query	= Request("nv_query")
	dim logtype		: logtype	= Request("logtype")  ' 로그인 타입 : 2 or ""-모든기업 4-일반기업 5-파견기업 6:서치펌만 로그인가능
	Dim ErrURL
	
	If trim(redir)="" then redir = hostnm
	If instr(1,redir,"http")=0 then redir = hostnm & redir

	dim com_id : com_id = trim(request.form("id"))
	dim passwd : passwd = trim(request.form("pw"))

	if Trim(com_id) = "" then Response.Write "<meta http-equiv='refresh' content='0; url="& hostnm &"/company/login.asp'>"

	dim strSql

	Const adOpenForwardOnly = 0
	Const adLockReadOnly = 1
	Const adCmdText = &H0001

	dbCon.open Application("DBInfo_FAIR")

	strSql = "select 회사명, 회사아이디, 암호화_비밀번호, 담당자성명, 담당자휴대폰" &_
			 " from 회사정보 WITH(NOLOCK) " &_
			 "where 회사아이디 = '"& com_id & "'"

	Rs.Open strSql, dbCon, adOpenForwardOnly, adLockReadOnly, adCmdText

	If Rs.BOF=False and Rs.EOF=False Then
		If strComp(trim(Rs(2)),SHA256_Encrypt(passwd),1)=0 then  '(,,1)->textcompare 같을경우 0 반환
			Call ClearCookieWK  ' 모든 쿠키 reset
			
			Response.Cookies(site_code & "WKC_F")("comname")		= Rs(0)
			Response.Cookies(site_code & "WKC_F")("comid")			= Rs(1)
			Response.Cookies(site_code & "WKC_F")("managername")	= Rs(3)
			Response.Cookies(site_code & "WKC_F")("managerhp")		= Rs(4)

			Rs.Close

			strSql = "SELECT COUNT(등록번호) FROM 채용정보 WITH(NOLOCK) WHERE 회사아이디 = '"& com_id &"'"
			Rs.Open strSql, dbCon, 0, 1
			Response.Cookies(site_code & "WKC_F")("COMMON1") = Rs(0)
			Rs.Close

			
			' 최근 등록된 화상면접 배정 결과 채용공고번호 조회
			strSql = "SELECT TOP 1 채용등록번호 FROM 면접배정정보 WITH(NOLOCK) WHERE 회사아이디 = '"& com_id &"' AND 면접확정여부='Y' ORDER BY 등록번호 DESC"
			Rs.Open strSql, dbCon, 0, 1
			Response.Cookies(site_code & "WKC_F")("COMMON2") = Rs(0)
			Rs.Close


			Response.Cookies(site_code & "WKC_F").Domain	= "career.co.kr"	' 도메인 설정

			ErrURL = redir
		Else
			Rs.close
			msg=msg & "입력하신 비밀번호가 일치하지 않습니다.\r비밀번호를 다시 확인해주시기 바랍니다."
			ErrURL = hostnm & "/company/login.asp?redir="&Server.URLEncode(redir)
		End If
	Else
		Rs.close
		
		msg=msg & "입력하신 아이디가 존재하지 않습니다.\r아이디를 다시 확인하시기 바랍니다"
		ErrURL = hostnm & "/company/login.asp?redir="&Server.URLEncode(redir)
	End If

	dbCon.close
%>

<OBJECT RUNAT="SERVER" PROGID="ADODB.Connection" ID="dbCon"></OBJECT>
<OBJECT RUNAT="SERVER" PROGID="ADODB.RecordSet" ID="Rs"></OBJECT>

<%IF Request.Form("WINTYPE") = "POP" THEN	'팝업로그인인경우%>

<script>
<%If msg <> "" then%>
	alert('<%=msg%>');
	history.back();
<%ELSE%>
	location.href = "http://<%=Request.Form("HOSTNM")%>/login/ie8msg.asp?redir=<%=redir%>"
<%END IF%>
</script>
<%ELSE%>

<script type="text/javascript">
<%If msg <> "" then%>
	alert('<%=msg%>');
<%End If%>
</script>
<%If Request.ServerVariables("HTTP_REFERER") <> "" Then %>
	<meta http-equiv='refresh' content='0; url=<%=ErrURL%>'>
<%End If%>
<%if msg<>"" then%>
	<%If Request.ServerVariables("HTTP_REFERER") <> "" Then
		response.end
	 %>
	<%
		response.end

	End If%>
<%end if%>
<%End If%>