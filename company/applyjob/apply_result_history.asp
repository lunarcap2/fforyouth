<!--#include virtual = "/common/common.asp"-->
<!--include virtual = "/include/header/header.asp"-->

<link rel="stylesheet" type="text/css" href="/css/reset.css?<%=publishUpdateDt%>" />
<link rel="stylesheet" type="text/css" href="/css/busan_sub.css?<%=publishUpdateDt%>" />

<!--#include virtual = "/wwwconf/code/code_function_ac.asp"-->
<!--#include virtual = "/wwwconf/code/code_function_jc.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/wwwconf/function/library/AES256.asp"-->
<!--#include virtual = "/inc/function/paging.asp"-->

<%
	ConnectDB DBCon, Application("DBInfo_FAIR")
	
	Dim jid, Page, PageSize, stropt
	
	jid			= Request("jid")
	Page		= Request("page")
	PageSize	= 5

	If Page = "" Then
		Page = 1
	End If

	Dim total, totalPage, result
	ReDim param(3)

	param(0) = makeParam("@jid",		adVarchar, adParamInput, 30, jid)
	param(1) = makeParam("@Page",		adInteger, adParamInput, 4 , Page)
	param(2) = makeParam("@PageSize",	adInteger, adParamInput, 4 , PageSize)
	param(3) = makeParam("@TotalCount",	adInteger, adParamOutput, 4 , 0)
	
	result		= arrGetRsSP(DBCon, "USP_APPLY_RECEIVER_NOTI_HISTORY", param, "", "")
	total		= getParamOutputValue(param, "@TotalCount")

	totalPage	= Fix(((total-1)/PageSize) +1)
	stropt		= "jid=" & jid

	DisconnectDB DBCon
%>

<div id="tc2" class="tab_content">
	<div class="tb_area">
		<table class="tb tc">
			<colgroup>
				<col style="width:175px;"/>
				<col style="width:188px;"/>
				<col style="width:210px;"/>
				<col style="width:145px;"/>
				<col />
			</colgroup>
			<thead>
				<tr>
					<th>이름</th>
					<th>통보 내용</th>
					<th>전송날짜</th>
					<th>통보방식</th>
					<th>상태</th>
				</tr>
			</thead>
			<tbody>
				<%
					If isArray(result) Then
						For i = 0 to ubound(result, 2)
				%>
				<tr>
					<td><%=result(1,i)%></td>
					<td><%=result(2,i)%></td>
					<td><%=result(3,i)%></td>
					<td><%=result(4,i)%></td>
					<td><%=result(5,i)%></td>
				</tr>
				<%
						Next
					Else
				%>
				<tr>
					<td class="no_date" colspan="5">
						<div class="none_list">
							데이터가 없습니다.
						</div>
					</td>
				</tr>
				<%
					End If
				%>
			</tbody>
		</table>
	</div>

	<!--페이징-->
	<% Call putPage(page, stropt, totalPage) %>
</div>	

