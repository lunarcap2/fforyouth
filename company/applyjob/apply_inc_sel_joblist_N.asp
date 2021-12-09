<%
ConnectDB DBCon, Application("DBInfo_FAIR")

	Dim strStmt, arrRsJoblist(1)
	strStmt = ""
	strStmt = strStmt & " SELECT ��Ϲ�ȣ, ������������ FROM ä������ WITH(NOLOCK)"
	strStmt = strStmt & " WHERE ȸ����̵� = '"& comid &"'"
	strStmt = strStmt & " ORDER BY ��Ϲ�ȣ DESC"
	arrRsJoblist(0) = arrGetRsSql(DBCon, strStmt, "", "")

	strStmt = ""
	strStmt = strStmt & " SELECT ��Ϲ�ȣ, ������������ FROM ����ä������ WITH(NOLOCK)"
	strStmt = strStmt & " WHERE ȸ����̵� = '"& comid &"'"
	strStmt = strStmt & " ORDER BY ��Ϲ�ȣ DESC"
	arrRsJoblist(1) = arrGetRsSql(DBCon, strStmt, "", "")

	Dim arrRsApplyCnt
	ReDim param(3)
	spName = "USP_BIZSERVICE_APPLY_CNT"
	param(0) = makeParam("@mode", adVarchar, adParamInput, 10, mode)
	param(1) = makeParam("@comid", adVarchar, adParamInput, 20, comid)
	param(2) = makeParam("@jid", adInteger, adParamInput, 4, jid)

	arrRsApplyCnt = arrGetRsSP(dbCon, spName, param, "", "")

	Dim total_cnt, not_open_cnt, before_cnt, ing_cnt, papers_cnt, final_cnt, failure_cnt
	total_cnt		= arrRsApplyCnt(0, 0)
	not_open_cnt	= arrRsApplyCnt(2, 0)
	before_cnt		= arrRsApplyCnt(8, 0)
	ing_cnt			= arrRsApplyCnt(9, 0)
	papers_cnt		= arrRsApplyCnt(10, 0)
	final_cnt		= arrRsApplyCnt(11, 0)
	failure_cnt		= arrRsApplyCnt(12, 0)

	'0:TOTAL_CNT(��ü�Ի���������)
	'1:TODAY_CNT(�����Ի�������)
	'2:NOT_OPEN_CNT(�̿�����)
	'3:ONLINE_CNT(�¶����Ի�������)
	'4:EMAIL_CNT(�̸����Ի�������)
	'5:CAREER_CNT(Ŀ�������Ի�������)
	'6:FREE_CNT(��������Ի�������)
	'7:COMPANY_CNT(�ڻ����Ի�������)
	'8:BEFORE_CNT(�ɻ���)
	'9:ING_CNT(�ɻ���)
	'10:PAPERS_CNT(�����հ�)
	'11:FINAL_CNT(�����հ�) > ���⼭�� �����հ����� ���
	'12:FAILURE_CNT(���հ�)
	'13:FILLTER_CNT(���͸�)

DisconnectDB DBCon
%>

<script type="text/javascript">
	function goApplySel(mode, jid, pid) {
        $("#mode_sub").val(mode);
        $("#jid_sub").val(jid);
        $("#pid_sub").val(pid);

        $('#frm_sub').attr('action', '<%=Request.ServerVariables("PATH_INFO")%>');
        $('#frm_sub').submit();
    }
</script>

<form id="frm_sub" name="frm_sub" method="post" action="">
	<input type="hidden" id="mode_sub" name="mode" value="" />
	<input type="hidden" id="jid_sub" name="jid" value="" />
	<input type="hidden" id="pid_sub" name="pid" value="" />
</form>

<div class="applicant_area">
	<h3>������ ����</h3>
	<div class="list_area">
		<ul>
			<% Dim jid_NM :jid_NM = "" %>
			<% If isArray(arrRsJoblist(0)) Then %>
				<% For i=0 To UBound(arrRsJoblist(0), 2) %>
				<li class=<% If CInt(arrRsJoblist(0)(0, i)) = CInt(jid) Then %> "on" <% End If %>>
					<div class="info click">
						<span>������</span>
						<p><%=arrRsJoblist(0)(1, i)%></p>
						<div class="btn_area">
							<a href="/jobs/view.asp?id_num=<%=arrRsJoblist(0)(0, i)%>" class="btn orange" target="_blank">������</a>
							<a href="javascript:goApplySel('ing', '<%=arrRsJoblist(0)(0, i)%>', '0');" class="btn gray">�������</a>
						</div>
					</div>
				</li>
				<%	
					If CInt(arrRsJoblist(0)(0, i)) = CInt(jid) Then
						jid_NM = arrRsJoblist(0)(1, i)
					End If
				%>
				<% Next %>
			<% End If %>
			<% If isArray(arrRsJoblist(1)) Then %>
				<% For i=0 To UBound(arrRsJoblist(1), 2) %>
				<li class=<% If CInt(arrRsJoblist(1)(0, i)) = CInt(jid) Then %> "on" <% End If %>>
					<div class="info click">
						<span>����</span>
						<p><%=arrRsJoblist(1)(1, i)%></p>
						<div class="btn_area">
							<a href="/jobs/view.asp?id_num=<%=arrRsJoblist(1)(0, i)%>" class="btn orange" target="_blank">������</a>
							<a href="javascript:goApplySel('cl', '<%=arrRsJoblist(1)(0, i)%>', '0');" class="btn gray">�������</a>
						</div>
					</div>
				</li>
				<%	
					If CInt(arrRsJoblist(1)(0, i)) = CInt(jid) Then
						jid_NM = arrRsJoblist(1)(1, i)
					End If
				%>
				<% Next %>
			<% End If %>
		</ul><!--//.list_area-->
	</div>

	<div class="tb_area">
		<p>����� ä������ ������ ������ �ڶ�ȸ ���� �� 1������ Ȯ���� �����մϴ�.</p>
		<table class="tb">
			<caption>��ũ���� ����</caption>
			<colgroup>
				<col style="width:178px;'">
				<col style="width:178px;'">
				<col style="width:178px;'">
				<col style="width:178px;'">
				<col style="width:178px;'">
				<col>
			</colgroup>
			<thead>
				<tr>
					<th>��ü ������</th>
					<th>�̿���</th>
					<th>������</th>
					<th>�����հ�</th>
					<th>�������հ�</th>
					<th>�����հ�</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td><a href="javascript:;" onclick="goApply('0')" <%If pid="0" Then%>class="blue"<%End If%>><%=total_cnt%></a></td>
					<td><a href="javascript:;" onclick="goApply('1')" <%If pid="1" Then%>class="blue"<%End If%>><%=not_open_cnt%></a></td>
					<td><a href="javascript:;" onclick="goApply('2')" <%If pid="2" Then%>class="blue"<%End If%>><%=ing_cnt%></a></td>
					<td><a href="javascript:;" onclick="goApply('4')" <%If pid="4" Then%>class="blue"<%End If%>><%=final_cnt%></a></td>
					<td><a href="javascript:;" onclick="goApply('5')" <%If pid="5" Then%>class="blue"<%End If%>><%=failure_cnt%></a></td>
					<td><a href="javascript:;" onclick="goApply('3')" <%If pid="3" Then%>class="blue"<%End If%>><%=papers_cnt%></a></td>
				</tr>
			</tbody>
		</table>
		<a href="<% If PAPERS_CNT > 0 Then %>/company/interview/list.asp?mode=<%=mode%>&jid=<%=jid%>&pid=3<% Else %>javascript:alert('�����հ��ڰ� ������ ������ ������� �ʽ��ϴ�.');<% End If %>" class="btn blue">����<br>Interview</a>
	</div>
</div><!-- //.applicant_area -->