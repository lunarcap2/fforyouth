<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/common/common.asp"-->
<%
'--------------------------------------------------------------------
'   Comment		: ���ȸ�� ����
' 	History		: 2020-04-22, �̻��� 
'--------------------------------------------------------------------
Session.CodePage  = 949			'�ѱ�
Response.CharSet  = "euc-kr"	'�ѱ�
Response.AddHeader "Pragma","no-cache"
Response.AddHeader "cache-control", "no-staff"
Response.Expires  = -1

comp_num = Request("comp_num")

ConnectDB DBCon, Application("DBInfo")
ConnectDB DBCon2, Application("DBInfo_FAIR")

' �Է� ����ڹ�ȣ ��ȿ�� üũ > 1)���ȸ�� ���� ���ܱ������ �з��Ǿ����� ���� ����
strSql = "SELECT ����ڵ�Ϲ�ȣ FROM ȸ���������ܱ�� WITH(NOLOCK) WHERE ����ڵ�Ϲ�ȣ= ?"
ReDim parameter(0)
parameter(0)	= makeParam("@����ڵ�Ϲ�ȣ", adVarChar, adParamInput, 10, comp_num)
ArrRsDefault	= arrGetRsParam(DBCon, strSql, parameter, "", "")
If isArray(ArrRsDefault) And 1=2 Then	' �ش� ����ڹ�ȣ�� ���� ���� ��� ����Ʈ�� ���� ��� 
	rtn_value = "X"	
Else	
	' �Է� ����ڹ�ȣ ��ȿ�� üũ > 2)�ſ��򰡱�� ���� ������� ���̺� ȸ�� ������ �����ϴ��� ���� Ȯ��
    strSql2 = "SELECT A.BizRegCode, A.BizName, A.BossName, A.AddrKor, ISNULL(A.Workforce, 0), A.BizScale " &_
	          "FROM T_NICE_COMVIEW_NEW AS A WITH(NOLOCK) "&_
	          "WHERE A.BizRegCode='"& comp_num &"'"
	Rs.Open strSql2, DBCon, adOpenForwardOnly, adLockReadOnly, adCmdText
	Dim flagRs : flagRs = False 
	If Rs.eof = False And Rs.bof = False Then
		flagRs		= True 
		BizRegCode	= Rs(0)	' ����ڹ�ȣ
		BizName		= Rs(1)	' ȸ���
		BossName	= Rs(2)	' ��ǥ�ڸ�
		AddrKor		= Rs(3)	' ȸ���ּ�
		Workforce	= Rs(4)	' �����
		BizScale	= Rs(5)	' �������
	End If

	Select Case BizScale
		Case "0"
			strBizScale = "�������"
		Case "1"
			strBizScale = "����"
		Case "2"
			strBizScale = "��Ÿ"
		Case "3"
			strBizScale = "�߰߱��"
		Case Else 
			strBizScale = "Ȯ�κҰ�"
	End Select
	

	' �Է� ����ڹ�ȣ ��ȿ�� üũ > 3)�ش� ����ڹ�ȣ�� ���� ���Ե� ���ȸ�� ������ �ִ��� üũ
	strSql3 = "SELECT ����ڵ�Ϲ�ȣ FROM ȸ������ WITH(NOLOCK) WHERE ����ڵ�Ϲ�ȣ= ? "
	ReDim paramchk(0)
	paramchk(0)		= makeParam("@����ڵ�Ϲ�ȣ", adVarChar, adParamInput, 10, comp_num)
	ArrRsDefault2	= arrGetRsParam(DBCon2, strSql3, paramchk, "", "")
	If isArray(ArrRsDefault2) Then	' �ش� ����ڹ�ȣ�� ���Ե� ������ �����Ѵٸ� 
		cntJoin = "1"	
	Else 
		cntJoin = "0" 
	End If 




	If Not flagRs Then 
		If cntJoin = "0" Then 
			rtn_value = "I" ' ������ ���� ���̺� ȸ�� ������ ���� ���	ȸ������ ���̺� �׸� ���� ����
		Else 
			rtn_value = "N"	' �ش� ����ڹ�ȣ�� ���Ե� ������ �����Ѵٸ�	
		End If 
	Else 		
		If cntJoin = "0" Then 
			rtn_value = "O" ' ������ ���� ���̺� ȸ�� ������ �ִٸ�
		Else 
			rtn_value = "N"	' �ش� ����ڹ�ȣ�� ���Ե� ������ �����Ѵٸ�
		End If 		
	End If 
End If

DisconnectDB DBCon2
DisconnectDB DBCon

Response.write rtn_value&"��"

' ������ ���� ���̺� ȸ�� ������ ���� ��� ȸ�� ���� ����
If rtn_value = "O" Then 
	Response.write "<table class='tb' cellpadding='0' cellspacing='0'>"+VBCRLF
	Response.write "<caption></caption><colgroup><col style='width:25%;'><col></colgroup><tbody>"+VBCRLF
	Response.write "<tr><th scope='col'>�����</th><td>"&BizName&"</td></tr>"+VBCRLF
	Response.write "<tr><th scope='col'>��ǥ�ڸ�</th><td>"&BossName&"</td></tr>"+VBCRLF
	Response.write "<tr><th scope='col'>ȸ���ּ�</th><td>"&AddrKor&"</td></tr>"+VBCRLF
	Response.write "<tr><th scope='col'>��� ��</th><td>"&FormatNumber(Workforce,0)&" ��</td></tr>"+VBCRLF
	Response.write "<tr><th scope='col'>�������</th><td>"&strBizScale&"</td></tr>"+VBCRLF
	Response.write "</tbody></table>"+VBCRLF
End If 
%>
<OBJECT RUNAT="SERVER" PROGID="ADODB.RecordSet" ID="Rs"></OBJECT>