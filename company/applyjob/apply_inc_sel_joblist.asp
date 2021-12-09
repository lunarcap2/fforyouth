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

	Dim str_jobState, str_jobTitle
	If isArray(arrRsJoblist(0)) Then
		For i=0 To Ubound(arrRsJoblist(0), 2)		
			If CSng(jid) = CSng(arrRsJoblist(0)(0, i)) And mode = "ing" Then 
				str_jobState = "������"
				str_jobTitle = arrRsJoblist(0)(1, i)
			End If 
		Next
	End If 
	If isArray(arrRsJoblist(1)) Then
		For i=0 To Ubound(arrRsJoblist(1), 2)
			If Csng(jid) = Csng(arrRsJoblist(1)(0, i)) Then 
				str_jobState = "����"
				str_jobTitle = arrRsJoblist(1)(1, i)
			End If 
		Next
	End If


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
	'11:FINAL_CNT(�����հ�)
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


	//ä������ ����/����
    function fn_jobpost_modify(mode, jid) {
        var url = "<%=g_members_wk%>/biz/jobpost/jobpost_modify_fair?jid=" + jid + "&mode=" + mode + "&site_code=<%=site_code%>";
        location.href = url;
    }

	//ä������ ����
    function fn_jobpost_end(mode, jid) {
        if (mode != "ing") {
            alert("������ �� ���� ������ ä����� �Դϴ�.");
            return;
        }
        if (!confirm("�ش� ���� �����Ͻðڽ��ϱ�?")) {
            return;
        }

        var param = {};
        param.mode = mode;
        param.jid = jid;

        $.ajax({
            type: "POST",
            url: "/company/applyjob/jobpostEnd.asp",
            data: param,
            dataType: "html",
            success: function (data) {
                var rtn_data = data.split("|");
                if (rtn_data[0] == "0") {
                    alert(rtn_data[1]);
                    return false;
                } else if (rtn_data[0] == "1") {
                    alert("�ش� ������ ������ �Ϸ�Ǿ����ϴ�.");
					//location.reload();
					location.href = "/company/applyjob/whole.asp";
                } else {
                    alert("���� ������ ����: �����ڿ��� �����ϼ���. code=" + data);
                    location.reload();
                }
            },
            error: function (xhr) {
                var status = xhr.status;
                var responseText = xhr.responseText;
                alert(responseText + '//');
            }
        });
    }

    //ä������ ����
    function fn_jobpost_del(mode, jid) {
        if (!confirm("�ش� ���� �����Ͻðڽ��ϱ�?")) {
            return;
        }

        var param = {};
        param.mode = mode;
        param.jid = jid;

        $.ajax({
            type: "POST",
            url: "/company/applyjob/jobpostDel.asp",
            data: param,
            dataType: "html",
            success: function (data) {
                if (data == "0") {
                    alert("���� ���� ����: �����ڿ��� �����ϼ���.");
                    return false;
                } else if (data == "1") {
                    alert("�ش� ������ ������ �Ϸ�Ǿ����ϴ�.");
                    //location.reload();
					location.href = "/company/applyjob/whole.asp";
                } else {
                    alert("���� ������ ����: �����ڿ��� �����ϼ���. code=" + data);
                    location.reload();
                }
            },
            error: function (xhr) {
                var status = xhr.status;
                var responseText = xhr.responseText;
                alert(responseText + '//');
            }
        });
    }

</script>
			<form id="frm_sub" name="frm_sub" method="post" action="">
				<input type="hidden" id="mode_sub" name="mode" value="" />
				<input type="hidden" id="jid_sub" name="jid" value="" />
				<input type="hidden" id="pid_sub" name="pid" value="" />
			</form>

			<div class="layoutBox bdr">
				<div class="selRecruitArea">
					<div class="lt mulSelBox">
						<a href="javascript:" class="tit"><span><%=str_jobState%></span> <em><%=str_jobTitle%></em></a>
						<div id="mulSelBox" class="multiSelect">
							<% If isArray(arrRsJoblist(0)) Then %>
							<dl>
								<dt>�������� ä�����</dt>
								<% For i=0 To UBound(arrRsJoblist(0), 2) %>
								<dd><a href="javascript:" class="ing" onclick="goApplySel('ing', '<%=arrRsJoblist(0)(0, i)%>', '0')"><%=arrRsJoblist(0)(1, i)%></a></dd>
								<% Next %>
							</dl><!--.deth2-->
							<% End If %>

							<% If isArray(arrRsJoblist(1)) Then %>
							<dl>
								<dt>������ ä�����</dt>
								<% For i=0 To UBound(arrRsJoblist(1), 2) %>
								<dd><a href="javascript:" class="end" onclick="goApplySel('cl', '<%=arrRsJoblist(1)(0, i)%>', '0')"><%=arrRsJoblist(1)(1, i)%></a></dd>
								<% Next %>
							</dl><!--.deth2-->
							<% End If %>
						</div><!-- .multiSelect -->
					</div><!-- .mulSelBox -->

					<ul class="rt">
						<li><a href="/jobs/view.asp?id_num=<%=jid%>">������</a></li>
						<li>
							<a href="javascript:" class="toggle">�������</a>
							<div class="tooltipArea">
								<div class="box">
									<ul>
										<% If mode = "ing" Then %>
										<li><a href="javascript:" onclick="fn_jobpost_modify('EDIT', '<%=jid%>')">����</a></li>
										<li><a href="javascript:" onclick="fn_jobpost_modify('LOAD', '<%=jid%>')">����</a></li>
										<li><a href="javascript:" onclick="fn_jobpost_end('ing', '<%=jid%>')">����</a></li>
										<li><a href="javascript:" onclick="fn_jobpost_del('ing', '<%=jid%>')">����</a></li>
										<% ElseIf mode = "cl" Then %>
										<li><a href="javascript:" onclick="fn_jobpost_modify('LOAD', '<%=jid%>')">����</a></li>
										<li><a href="javascript:" onclick="fn_jobpost_del('cl', '<%=jid%>')">����</a></li>
										<% End If %>
									</ul>
								</div><!-- .box -->
							</div>
						</li>
					</ul><!-- .rt -->
				</div><!-- .selRecruitArea -->

                <div class="currentArea">
                    <ul class="spl6">
                        <!-- 2017/09/25/hjyu ��ũ�߰� -->
                        <li>
                            <dl>
                                <dt>��ü ������</dt>
                                <dd><a href="javascript:" onclick="goApply('0')"><em<%If pid="0" Then%> class="fc_blu05"<%End If%>><%=total_cnt%></em></a></dd>
                            </dl>
                        </li>
                        <li>
                            <dl>
                                <dt>�̿���</dt>
                                <dd><a href="javascript:" onclick="goApply('1')"><em<%If pid="1" Then%> class="fc_blu05"<%End If%>><%=not_open_cnt%></em></a></dd>
                            </dl>
                        </li>
                        <li>
                            <dl>
                                <dt>������</dt>
                                <dd><a href="javascript:" onclick="goApply('2')"><em<%If pid="2" Then%> class="fc_blu05"<%End If%>><%=ing_cnt%></em></a></dd>
                            </dl>
                        </li>
                        <li>
                            <dl>
                                <dt>�����հ�</dt>
                                <dd><a href="javascript:" onclick="goApply('3')"><em<%If pid="3" Then%> class="fc_blu05"<%End If%>><%=papers_cnt%></em></a></dd>
                            </dl>
                        </li>
                        <li>
                            <dl>
                                <dt>�����հ�</dt>
                                <dd><a href="javascript:" onclick="goApply('4')"><em<%If pid="4" Then%> class="fc_blu05"<%End If%>><%=final_cnt%></em></a></dd>
                            </dl>
                        </li>
                        <li>
                            <dl>
                                <dt>���հ�</dt>
                                <dd><a href="javascript:" onclick="goApply('5')"><em<%If pid="5" Then%> class="fc_blu05"<%End If%>><%=failure_cnt%></em></a></dd>
                            </dl>
                        </li>
                    </ul>
                </div><!-- .currentArea -->

                <div class="notiArea">
                    <ul>
                        <li>��ä����� ����Ⱓ�� <strong>���������Ϸκ��� �ִ� 90�ϱ���</strong>�Դϴ�.</li>
						<!--
                        <li>�����ð���� �ִ� 5������ ����. �ʰ� ��ϵ� ����� ������ ����ߡ� ���°� �Ǹ�, <strong>���Ἥ�� ��û �ÿ��� �ʰ��Ͽ� ���� ����</strong>�մϴ�.</li>
                        <li>����� �� ä������ <strong>��������</strong>�ϱ��� �����Ǹ�, ���� �Ⱓ ���� �� �ڵ� ���� �˴ϴ�. ��, �����Ⱓ�� <strong>���� ����Ϸκ��� �ִ� 30��</strong>�� �ʰ� �� �� �����ϴ�.</li>
						-->
                        <li>�������� ä������ <strong>�������� �� 90�ϰ�</strong> ���� ����Ʈ���� Ȯ�� �����մϴ�. <!--(1�Ⱓ ��⺸���� ���Ͻø� �������� ��ư Ŭ��!)--></li>
                        <li>�������ڴ� <strong>�Ի������Ϸκ��� 90�ϰ�</strong><!-- , <strong>��ũ���� ����� ��ũ���Ϸκ��� 90�ϰ�</strong> --> Ȯ�� �����մϴ�.</li>
                    </ul>
                </div><!-- .notiArea -->
            </div><!-- .layoutBox bdr -->