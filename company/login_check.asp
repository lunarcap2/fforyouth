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

	' ��Ʈ�� ���� ��ο� ���� ä��� ���� ������ ����(������ġ - W: �ϰ���, D: ������)
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
	dim logtype		: logtype	= Request("logtype")  ' �α��� Ÿ�� : 2 or ""-����� 4-�Ϲݱ�� 5-�İ߱�� 6:��ġ�߸� �α��ΰ���
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

	strSql = "select ȸ���, ȸ����̵�, ��ȣȭ_��й�ȣ, ����ڼ���, ������޴���" &_
			 " from ȸ������ WITH(NOLOCK) " &_
			 "where ȸ����̵� = '"& com_id & "'"

	Rs.Open strSql, dbCon, adOpenForwardOnly, adLockReadOnly, adCmdText

	If Rs.BOF=False and Rs.EOF=False Then
		If strComp(trim(Rs(2)),SHA256_Encrypt(passwd),1)=0 then  '(,,1)->textcompare ������� 0 ��ȯ
			Call ClearCookieWK  ' ��� ��Ű reset
			
			Response.Cookies(site_code & "WKC_F")("comname")		= Rs(0)
			Response.Cookies(site_code & "WKC_F")("comid")			= Rs(1)
			Response.Cookies(site_code & "WKC_F")("managername")	= Rs(3)
			Response.Cookies(site_code & "WKC_F")("managerhp")		= Rs(4)

			Rs.Close

			strSql = "SELECT COUNT(��Ϲ�ȣ) FROM ä������ WITH(NOLOCK) WHERE ȸ����̵� = '"& com_id &"'"
			Rs.Open strSql, dbCon, 0, 1
			Response.Cookies(site_code & "WKC_F")("COMMON1") = Rs(0)
			Rs.Close

			
			' �ֱ� ��ϵ� ȭ����� ���� ��� ä������ȣ ��ȸ
			strSql = "SELECT TOP 1 ä���Ϲ�ȣ FROM ������������ WITH(NOLOCK) WHERE ȸ����̵� = '"& com_id &"' AND ����Ȯ������='Y' ORDER BY ��Ϲ�ȣ DESC"
			Rs.Open strSql, dbCon, 0, 1
			Response.Cookies(site_code & "WKC_F")("COMMON2") = Rs(0)
			Rs.Close


			Response.Cookies(site_code & "WKC_F").Domain	= "career.co.kr"	' ������ ����

			ErrURL = redir
		Else
			Rs.close
			msg=msg & "�Է��Ͻ� ��й�ȣ�� ��ġ���� �ʽ��ϴ�.\r��й�ȣ�� �ٽ� Ȯ�����ֽñ� �ٶ��ϴ�."
			ErrURL = hostnm & "/company/login.asp?redir="&Server.URLEncode(redir)
		End If
	Else
		Rs.close
		
		msg=msg & "�Է��Ͻ� ���̵� �������� �ʽ��ϴ�.\r���̵� �ٽ� Ȯ���Ͻñ� �ٶ��ϴ�"
		ErrURL = hostnm & "/company/login.asp?redir="&Server.URLEncode(redir)
	End If

	dbCon.close
%>

<OBJECT RUNAT="SERVER" PROGID="ADODB.Connection" ID="dbCon"></OBJECT>
<OBJECT RUNAT="SERVER" PROGID="ADODB.RecordSet" ID="Rs"></OBJECT>

<%IF Request.Form("WINTYPE") = "POP" THEN	'�˾��α����ΰ��%>

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