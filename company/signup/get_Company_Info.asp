<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/common/common.asp"-->
<%
'--------------------------------------------------------------------
'   Comment		: 기업회원 가입
' 	History		: 2020-04-22, 이샛별 
'--------------------------------------------------------------------
Session.CodePage  = 949			'한글
Response.CharSet  = "euc-kr"	'한글
Response.AddHeader "Pragma","no-cache"
Response.AddHeader "cache-control", "no-staff"
Response.Expires  = -1

comp_num = Request("comp_num")

ConnectDB DBCon, Application("DBInfo")
ConnectDB DBCon2, Application("DBInfo_FAIR")

' 입력 사업자번호 유효성 체크 > 1)기업회원 가입 차단기업으로 분류되었는지 여부 검증
strSql = "SELECT 사업자등록번호 FROM 회원가입차단기업 WITH(NOLOCK) WHERE 사업자등록번호= ?"
ReDim parameter(0)
parameter(0)	= makeParam("@사업자등록번호", adVarChar, adParamInput, 10, comp_num)
ArrRsDefault	= arrGetRsParam(DBCon, strSql, parameter, "", "")
If isArray(ArrRsDefault) And 1=2 Then	' 해당 사업자번호가 가입 차단 기업 리스트에 있을 경우 
	rtn_value = "X"	
Else	
	' 입력 사업자번호 유효성 체크 > 2)신용평가기관 제공 기업정보 테이블에 회사 정보가 존재하는지 여부 확인
    strSql2 = "SELECT A.BizRegCode, A.BizName, A.BossName, A.AddrKor, ISNULL(A.Workforce, 0), A.BizScale " &_
	          "FROM T_NICE_COMVIEW_NEW AS A WITH(NOLOCK) "&_
	          "WHERE A.BizRegCode='"& comp_num &"'"
	Rs.Open strSql2, DBCon, adOpenForwardOnly, adLockReadOnly, adCmdText
	Dim flagRs : flagRs = False 
	If Rs.eof = False And Rs.bof = False Then
		flagRs		= True 
		BizRegCode	= Rs(0)	' 사업자번호
		BizName		= Rs(1)	' 회사명
		BossName	= Rs(2)	' 대표자명
		AddrKor		= Rs(3)	' 회사주소
		Workforce	= Rs(4)	' 사원수
		BizScale	= Rs(5)	' 기업형태
	End If

	Select Case BizScale
		Case "0"
			strBizScale = "공공기관"
		Case "1"
			strBizScale = "대기업"
		Case "2"
			strBizScale = "기타"
		Case "3"
			strBizScale = "중견기업"
		Case Else 
			strBizScale = "확인불가"
	End Select
	

	' 입력 사업자번호 유효성 체크 > 3)해당 사업자번호로 기존 가입된 기업회원 정보가 있는지 체크
	strSql3 = "SELECT 사업자등록번호 FROM 회사정보 WITH(NOLOCK) WHERE 사업자등록번호= ? "
	ReDim paramchk(0)
	paramchk(0)		= makeParam("@사업자등록번호", adVarChar, adParamInput, 10, comp_num)
	ArrRsDefault2	= arrGetRsParam(DBCon2, strSql3, paramchk, "", "")
	If isArray(ArrRsDefault2) Then	' 해당 사업자번호로 가입된 정보가 존재한다면 
		cntJoin = "1"	
	Else 
		cntJoin = "0" 
	End If 




	If Not flagRs Then 
		If cntJoin = "0" Then 
			rtn_value = "I" ' 나신평 관리 테이블에 회사 정보가 없을 경우	회사정보 테이블에 항목 수기 저장
		Else 
			rtn_value = "N"	' 해당 사업자번호로 가입된 정보가 존재한다면	
		End If 
	Else 		
		If cntJoin = "0" Then 
			rtn_value = "O" ' 나신평 관리 테이블에 회사 정보가 있다면
		Else 
			rtn_value = "N"	' 해당 사업자번호로 가입된 정보가 존재한다면
		End If 		
	End If 
End If

DisconnectDB DBCon2
DisconnectDB DBCon

Response.write rtn_value&"§"

' 나신평 관리 테이블에 회사 정보가 있을 경우 회사 정보 전달
If rtn_value = "O" Then 
	Response.write "<table class='tb' cellpadding='0' cellspacing='0'>"+VBCRLF
	Response.write "<caption></caption><colgroup><col style='width:25%;'><col></colgroup><tbody>"+VBCRLF
	Response.write "<tr><th scope='col'>기업명</th><td>"&BizName&"</td></tr>"+VBCRLF
	Response.write "<tr><th scope='col'>대표자명</th><td>"&BossName&"</td></tr>"+VBCRLF
	Response.write "<tr><th scope='col'>회사주소</th><td>"&AddrKor&"</td></tr>"+VBCRLF
	Response.write "<tr><th scope='col'>사원 수</th><td>"&FormatNumber(Workforce,0)&" 명</td></tr>"+VBCRLF
	Response.write "<tr><th scope='col'>기업형태</th><td>"&strBizScale&"</td></tr>"+VBCRLF
	Response.write "</tbody></table>"+VBCRLF
End If 
%>
<OBJECT RUNAT="SERVER" PROGID="ADODB.RecordSet" ID="Rs"></OBJECT>