<script type="text/javascript">
	//���º���
	function fn_SetParam(_gb, _apply_num, _status) {
		if ($('input:checkbox[name="chk_list"]:checked').length == 0 && _gb == "status" && _apply_num == "") {
			alert("�����ڸ� �����Ͽ� �ֽʽÿ�.");
			return;
		}
		else {
			var interviewYN = "";

			if (_apply_num == "") {
				var arr_applynum = ""

				$('input:checkbox[name="chk_list"]').each(function () {
					if (this.checked) {//checked ó���� �׸��� ��
						var arr = new Array();
						arr = this.value.split(",");

						arr_applynum += "," + arr[0];

						if (arr[3] == "Y") {
							interviewYN = "Y";
							return;
						}
					}
				});
				
				_apply_num += arr_applynum.substr(1);
			}
			
			if(interviewYN == "Y") {
				alert("���� ������ �� �����ڰ� �ֽ��ϴ�.\n���� ������ �� �������� ���´� ���� �� �� �����ϴ�.");
				return;
			}
			else {
				goStatusSelect(_gb, "2", _apply_num, "");

				if (_gb == "read" && _apply_num != "" && _status == "1") {
					goStatusSelect(_gb, "3", _apply_num, "2");
				}
				else if (_gb == "status") {
					if (!confirm("���¸� �����Ͻðڽ��ϱ�?")) {
						return;
					}

					goStatusSelect(_gb, "3", _apply_num, _status);
				}
			}
			
		}
	}

	//������ ���º���
    function goStatusSelect(_gb, _gubun, _apply_num, _status) {
        var param = {};
        param.gubun = _gubun;
        param.mode = $('#mode').val();
        param.jid = $('#jid').val();
        param.apply_num = _apply_num;
        param.status = _status;

        $.ajax({
            type: "POST",
            url: "/company/applyjob/apply_setStatus.asp",
            data: param,
            dataType: "html",
            success: function (data) {
                if (data == "0") {
                    alert("����: �����ڿ��� �����ϼ���.");
                    return false;
                } else if (data == "1") {
					if (_gb == "status") {
						alert("������ ���º����� �Ϸ�Ǿ����ϴ�.");
					}				

                    $('#frm').submit();					
                }
				/*
				else {
                    alert("���� ������ ����: �����ڿ��� �����ϼ���. code=" + data);
                    //location.reload();
                    return false;
                }
				*/
            },
            error:function(request,status,error){
				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
        });
    }

	//�̷¼� ����
	function fn_resume_view(rid, set_user_id) {		
		$("#rid").val(rid);
		$("#set_user_id").val(set_user_id);

        $('#frm_resume').attr("target", "_blank");
        $('#frm_resume').attr("action", "/company/applyjob/resumeView.asp");
        $('#frm_resume').submit();
	}
</script>
	
	<form id="frm_resume" name="frm_resume" method="post">
		<input type="hidden" id="rid" name="rid" value="">
		<input type="hidden" id="set_user_id" name="set_user_id" value="">
	</form>

	<table class="tb" summary="��ũ���� ���翡 ���� �̸�/����/����,�̷¼� ����/�������,����� �׸��� ��Ÿ�� ǥ">
		<caption>��ũ���� ����</caption>
		<colgroup>
			<col style="width:60px">
			<col style="width:300px">
			<col style="width:220px">
			<col style="width:150px">
			<col style="width:150px">
			<col style="width:210px">
			<col>
		</colgroup>
		<thead>
			<tr>
				<th><label class="checkbox off"><input class="chk" id="" name="" type="checkbox" onclick="noncheckallFnc(this, 'chk_list');"></label></th>
				<th>�̸�/����</th>
				<th>�з�/���</th>
				<th>÷��</th>
				<th>�ɻ����</th>
				<th>�������</th>
				<th>�����Ͻ�</th>
			</tr>
		</thead>
		<tbody>
		<%
		If isArray(arrRs) Then
			For i=0 To UBound(arrRs, 2)
			ConnectDB DBCon, Application("DBInfo_FAIR")
			Dim strSql, arrRsView, arrRsSchool, interviewYN, interviewConfirmYN, rsIntervConfirmYN
			strSql = "SELECT ������ȣ, �Ϸù�ȣ, �����ϰ��, �����ϸ�, �����ϸ� FROM ���ͳ��Ի���������÷�� WITH(NOLOCK) WHERE ä���Ϲ�ȣ ='"& jid &"' AND ������ȣ = '"& arrRs(14, i) &"' ORDER BY �Ϸù�ȣ"
			arrRsView = arrGetRsSql(DBCon, strSql, "", "")

			strSql = " SELECT �б���, ������, �������� FROM �̷¼��з� WHERE ��Ϲ�ȣ = '" & arrRs(2,i) & "' AND �з����� = '" & arrRs(9,i) & "' "
			arrRsSchool = arrGetRsParam(DBCon, strSql, "", "", "")
			
			strSql = " SELECT ����Ȯ������ AS ����Ȯ������ FROM ������������ WHERE ä���Ϲ�ȣ = '" & jid & "' AND �Ի�������Ϲ�ȣ = '"& arrRs(14, i) &"'"
			interviewYN = arrGetRsParam(DBCon, strSql, "", "", "")

			strSql = " SELECT isnull(����Ȯ������,'N') AS ����Ȯ������ FROM ������������ WHERE ä���Ϲ�ȣ = '" & jid & "' AND �Ի�������Ϲ�ȣ = '"& arrRs(14, i) &"'"
			interviewConfirmYN = arrGetRsParam(DBCon, strSql, "", "", "")
			If isArray(interviewConfirmYN) Then
			 	rsIntervConfirmYN = interviewConfirmYN(0, 0)
			End If 

			DisconnectDB DBCon

			'������� ����
			Dim birth_ymd
			If arrRs(6, i) = "1" Or arrRs(6, i) = "2" Then
				birth_ymd = "19" & arrRs(5, i)
			Else
				birth_ymd = "20" & arrRs(5, i)
			End If
			Dim user_age : user_age = Year(now) - Left(birth_ymd, 4) + 1

			'���ǥ��
			Dim career_str, tot_sum
			tot_sum = Abs(arrRs(11, i))

			If tot_sum = "0" Then 
				career_str = "����"
			ElseIf tot_sum > 12 Then
				career_str = "��� " & fix(tot_sum / 12) & "�� "

				If tot_sum mod 12 > 0 Then
					career_str = career_str & tot_sum mod 12 & "����"
				End If
			Else 
				career_str = "��� " & tot_sum & "����"
			End If

			'�����з�
			Dim strFinalSchool : strFinalSchool = ""
			Select Case arrRs(9, i)
				Case "3" : strFinalSchool = "����б�"
				Case "4" : strFinalSchool = "����(2,3��)"
				Case "5" : strFinalSchool = "���б�(4��)"
				Case "6" : strFinalSchool = "���п�"
			End Select

			'�հݻ���
			Dim statusNm
			Select Case arrRs(20, i)
				Case "1" : statusNm = "�ɻ��ϱ�"
				Case "2" : statusNm = "������"
				Case "3" : statusNm = "�����հ�"
				Case "4" : statusNm = "�����հ�"
				Case "5" : statusNm = "�������հ�"
			End Select
			
			'�̷¼� ��������
			Dim isopen
			Select Case arrRs(22, i)
				Case "1" : isopen = "����"
				Case "0" : isopen = "�̿���"
			End Select

			' ������� ����
			Dim final_rtn
			Select Case arrRs(27, i)
				Case "6" : final_rtn = "<p>�ܼ����</p>"
				Case "7" : final_rtn = "<p class='blue'>�߰���������</p>"
				Case "8" : final_rtn = "<p class='red'>����</p>"
				Case "9" : final_rtn = "<p>��Ÿ</p>"
				Case Else : final_rtn = ""
			End Select
		%>
			<tr>
				<td>
					<label class="checkbox off">
						<input class="chk" id="" name="chk_list" type="checkbox" value="<%=arrRs(14,i)%>,<%=arrRs(2,i)%>,<%=arrRs(3,i)%>,<% If isArray(interviewYN) Then %>Y<% End If %>">
					</label>
				</td>
				<td class="t1 tc">
					
					<div class="photoBox">
						<a href="javascript:;" <% If arrRs(18,i) = "A" And arrRs(17,i) <> "" Then %>onclick="fn_resume_view('<%=arrRs(14,i)%>', '<%=objEncrypter.Encrypt(arrRs(3,i))%>'); fn_SetParam('read', '<%=arrRs(14, i)%>', '<%=arrRs(20,i)%>');"<% End If %>>	
							<div class="photo">
								<span class="frame sprite"></span>
								<% If arrRs(13, i) <> "" Then %>
								<img src="/files/mypic/<%=arrRs(13, i)%>">
								<% End If %>
							</div>
							<div class="photo_info">
								<em class="name">
									<%=arrRs(4, i)%>
									<% If isnull(arrRs(30, i)) Then %>
									(Ż��ȸ��)
									<% End If %>
								</em>
								<p class="birth">(<span class="num"><%=Left(birth_ymd, 4)%></span>���, <span class="num"><%=user_age%></span>��)</p>
								<% If arrRs(16, i) <> "" Then %>
								<p class="job">(<%=arrRs(16, i)%>)</p>
								<% End If %>
							</div>
						</a>
					</div>
				</td>
				<td class="t2  tc">
					<div class="txtBox">
						<% If arrRs(18,i) = "A" And arrRs(17,i) <> "" Then %>
						<p><%=strFinalSchool%>&nbsp;<%=GraduatedState%></p>
						<% 
							If isArray(arrRsSchool) Then
								Dim GraduatedState
								Select Case arrRsSchool(2,0)
									Case "3" : GraduatedState = "����"
									Case "4" : GraduatedState = "����"
									Case "5" : GraduatedState = "����"
									Case "7" : GraduatedState = "����(��)"
									Case "8" : GraduatedState = "����"
								End Select
						%>
							<p><%=arrRsSchool(0,0)%>&nbsp;<%=arrRsSchool(1,0)%></p>	
						<% End If %>
						<p><%=career_str%></p>
						<% ElseIf isnull(arrRs(30, i)) = false Then %>
						<p>�ڻ�/������� �������Դϴ�.<br>÷�������� �ٿ�޾��ּ���.</p>
						<% End If %>
					</div>
				</td>
				<td class="t3 tc">
					<% If isnull(arrRs(30, i)) = False Then %>
						<% If isArray(arrRsView) Then %>
						<div class="select_box" title="÷������" style="width:130px;">
							<div class="name"><a href="#none"><span>÷������</span></a></div>
							<div class="sel">
								<ul>
									<% For ii=0 To UBound(arrRsView, 2) %>
									<li><a href="http://www2.career.co.kr/myjob/files/filedownload_apply_busan.asp?aid=<%=arrRsView(0, ii)%>&orderno=<%=arrRsView(1, ii)%>&folderpath=<%=arrRsView(2, ii)%>&filename=<%=arrRsView(3, ii)%>&orifilename=<%=arrRsView(4, ii)%>" target="_blank" onclick="fn_SetParam('read', '<%=arrRs(14, i)%>', '<%=arrRs(20,i)%>');"><%=arrRsView(4, ii)%></a></li>
									<% Next %>
								</ul>
							</div>
						</div>
						<% End If %>		
					<% End If %>
				</td>
				<td class="t4 tc">
					<% If isArray(interviewYN) Then %>
					<div class="txtBox">
						<p><%=statusNm%></p>
						<p class=<% If isopen = "����" Then %> blue <% Else %> red <% End If %>><%=isopen%></p>
					</div>
					<% ElseIf isnull(arrRs(30, i)) = false Then %>
					<div class="select_box" title="�ɻ��ϱ�" style="width:130px;">
						<div class="name"><a href="#none"><span><%=statusNm%></span></a></div>
						<div class="sel">
							<ul>
								<li><a href="#none" onclick="fn_SetParam('status', '<%=arrRs(14, i)%>', '2');">������</a></li>
								<li><a href="#none" onclick="fn_SetParam('status', '<%=arrRs(14, i)%>', '4');">�����հ�</a></li>
								<li><a href="#none" onclick="fn_SetParam('status', '<%=arrRs(14, i)%>', '5');">�������հ�</a></li>
								<li><a href="#none" onclick="fn_SetParam('status', '<%=arrRs(14, i)%>', '3');">�����հ�</a></li>
							</ul>
						</div>
					</div>

					<div class="txtBox">
						<p class=<% If isopen = "����" Then %> blue <% Else %> red <% End If %>><%=isopen%></p>
					</div>
					<% End If %>	
				</td>
				<td class="t5 tc">
					<% If interview_N = "N" Or (interview_N = "" And rsIntervConfirmYN = "N") Then %><!-- �������� Ȯ���� ����ڿ� ���ؼ��� ��� �Է� ��ư ���� -->
					<p class="data"><span>-</span></p>
					<% Else %>
					<div class="txtBox">
						<%=final_rtn%>
					</div>
					<div class="btn_area">
						<% If arrRs(27, i) <> "" Then %>
						<a href="#none;" class="btn orange2 pop" onclick="openLayer('result_interview', '<%=arrRs(14, i)%>', '<%=arrRs(25, i)%>');">�������</a>
						<% ElseIf isnull(arrRs(30, i)) = false Then %>
						<a href="#none;" class="btn orange pop" onclick="openLayer('result_interview', '<%=arrRs(14, i)%>', '<%=arrRs(25, i)%>');">����Է�</a>
						<% End If %>
					</div>
					<% End If %>
				</td>
				<td class="t6 tc">
					<% If arrRs(24, i) <> "" Or interview_N <> "N" Then %>
					<div class="txtBox">
						<p><%=arrRs(24, i)%></p>
						<p><%=getInterviewTime(arrRs(25, i))%></p>
					</div>
					<div class="btn_area">
					<% If isnull(arrRs(30, i))=False Then %><!-- Ż��ȸ�� ���� �߼� ���� -->
						<% If isnull(arrRs(27, i)) Then %>
							<%If CDate(arrRs(24, i)&" "&Left(getInterviewTime(arrRs(25, i)),5)) >= CDate(FormatDateTime(Now(), 0)) Then%>
								<a href="javaScript:;" onclick="fn_msg_resend('<%=arrRs(1, i)%>', '<%=arrRs(14, i)%>', '<%=arrRs(4, i)%>', '<%=arrRs(26, i)%>', '<%=ont_confId%>');" class="btn gray">���� <%If arrRs(26, i) <> "" Then%>��߼�<%Else%>�߼�<%End If%></a>
							<%End If%>
						<% End If %>
					<% End If %>
					</div>
					<% Else %>
					<p class="data"><span>-</span></p>
					<% End If %>
				</td>
			</tr>
		<%
			Next
		Else
		%>
			<tr>
				<td colspan="7" class="no_data">
					<% If kw <> "" Or job_part <> "" Then %>
						�˻� ����� �����ϴ�.
					<% ElseIf request.servervariables("url") = "/company/interview/list.asp" Then %>
						�����հ��� ���������� ��� �Ϸ�Ǿ����ϴ�.
					<% ElseIf TimeToCnt = 0 Or request.servervariables("url") = "/company/interview/list_interview.asp" Then %>
						�ش����� �� �ð��� ������ �����ڰ� �����ϴ�.
					<% End If %>
				</td>
			</tr>
		<%
		End If 
		%>
		</tbody>
	</table>