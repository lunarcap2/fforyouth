<%
option Explicit

'------ ������ �⺻���� ����.
g_MenuID = "010001"  '�� �� ���ڴ� lnb ��������, �� �� ���ڴ� �޴� �̹��� ���ϸ� ����
g_MenuID_Navi = "0,1"  '������̼� ��
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header.asp"-->

<!--#include virtual = "/wwwconf/code/code_function_ac.asp"-->
<!--#include virtual = "/wwwconf/code/code_function_jc.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/wwwconf/function/library/AES256.asp"-->
<!--#include virtual = "/inc/function/paging.asp"-->
<%
Call FN_LoginLimit("2")    '���ȸ���� ���ٰ���


ConnectDB DBCon, Application("DBInfo_FAIR")
	
	Dim page, psize, totalCnt, stropt, totalPage, i, ii
	page = CInt(Request("page"))
	psize = CInt(Request("psize"))

	If page = "0" Then page = 1
	If psize = "0" Then psize = 10

	'�̿���	    isRead 0
   ' ��ü        pid 0
   ' �ɻ���	    pid 1 �̿��� ����
   ' ������	    pid 2
   ' �����հ�    pid 3
   ' �����հ�	pid 4
   ' ���հ�	    pid 5
    '��ũ��	    pid 10

	Dim mode, jid, pid, sch_kw, sch_gb, isRead, sch_sc, sch_ex, sch_area, sch_age, chk_1, chk_2, chk_3, chk_4, so1, so2, so3
	mode     = Request("mode")
	jid		 = Request("jid")
	pid		 = Request("pid")
	sch_kw	 = Request("sch_kw")
	sch_gb	 = Request("sch_gb")
	isRead	 = Request("isRead")
	sch_sc	 = Request("sch_sc")
	sch_ex	 = Request("sch_ex")
	sch_area = Request("sch_area")
	sch_age	 = Request("sch_age")
	chk_1	 = Request("chk_1")
	chk_2	 = Request("chk_2")
	chk_3	 = Request("chk_3")
	chk_4	 = Request("chk_4")
	so1		 = Request("so1")
	so2		 = Request("so2")
	so3		 = Request("so3")

	If pid = "" Then pid = "0"
	If so1 = "" Then so1 = "������ desc, ������ȣ desc"

	'mode     = "cl"
	'jid		 = "18519875"
	'pid		 = "0"
	'sch_kw	 = ""
	'sch_gb	 = ""
	'isRead	 = ""
	'sch_sc	 = ""
	'sch_ex	 = ""
	'sch_area = ""
	'sch_age	 = ""
	'chk_1	 = ""
	'chk_2	 = ""
	'chk_3	 = ""
	'chk_4	 = ""
	'so1		 = "������ desc, ������ȣ desc"
	'so2		 = ""
	'so3		 = ""

	Dim spName, arrRs, arrRsMojip

	'ä�� �����ι�
	spName = "SELECT ��ϼ�����ȣ, �����ι��� FROM ä������ι� WITH(NOLOCK) WHERE ä���Ϲ�ȣ = " & jid
	arrRsMojip = arrGetRsSql(DBCon, spName, "", "")


	ReDim param(24)
	spName = "usp_�������_�Ի�������_���2"

	param(0)  = makeParam("@mode",			adVarchar, adParamInput, 10, mode) '--ing:����, cl:����
	param(1)  = makeParam("@jid",			adVarchar, adParamInput, 30, jid)
	param(2)  = makeParam("@pid",			adVarchar, adParamInput, 30, pid)
	param(3)  = makeParam("@sch_kw",		adVarchar, adParamInput, 30, sch_kw)
	param(4)  = makeParam("@sch_gb",		adVarchar, adParamInput, 30, sch_gb)
	param(5)  = makeParam("@isRead",		adVarchar, adParamInput, 30, isRead)
	param(6)  = makeParam("@sch_sc",		adVarchar, adParamInput, 30, sch_sc)
	param(7)  = makeParam("@sch_ex",		adVarchar, adParamInput, 30, sch_ex)
	param(8)  = makeParam("@sch_area",		adVarchar, adParamInput, 30, sch_area)
	param(9)  = makeParam("@sch_age",		adVarchar, adParamInput, 30, sch_age)
	param(10) = makeParam("@chk_1",			adVarchar, adParamInput, 30, chk_1)
	param(11) = makeParam("@chk_2",			adVarchar, adParamInput, 30, chk_2)
	param(12) = makeParam("@chk_3",			adVarchar, adParamInput, 30, chk_3)
	param(13) = makeParam("@chk_4",			adVarchar, adParamInput, 30, chk_4)
	param(14) = makeParam("@so1",			adVarchar, adParamInput, 50, so1) '������ desc, ������ȣ desc
	param(15) = makeParam("@so2",			adVarchar, adParamInput, 30, so2)
	param(16) = makeParam("@so3",			adVarchar, adParamInput, 30, so3)

	param(17) = makeParam("@PageSize",		adInteger, adParamInput, 4 , psize)
	param(18) = makeParam("@Page",			adInteger, adParamInput, 4 , page)
	param(19) = makeParam("@sch_method",	adVarchar, adParamInput, 1 , "")
	param(20) = makeParam("@formtype",		adVarchar, adParamInput, 2 , "")
	param(21) = makeParam("@TotalCount",	adInteger, adParamOutput, 4 , 0)
	param(22) = makeParam("@TotalCount1",	adInteger, adParamOutput, 4 , 0)
	param(23) = makeParam("@TotalCount2",	adInteger, adParamOutput, 4 , 0)
	param(24) = makeParam("@TotalCount3",	adInteger, adParamOutput, 4 , 0)

	arrRs = arrGetRsSP(dbCon, spName, param, "", "")
	totalCnt = getParamOutputValue(param, "@TotalCount")
	totalPage = (totalCnt / psize) + 1

	Response.write "EXEC usp_�������_�Ի�������_���2 " & "'" & mode & "', " & "'" & jid & "', " & "'" & pid & "', " & "'" & sch_kw & "', " & "'" & sch_gb & "', " & "'" & isRead & "', " & "'" & sch_sc & "', " & "'" & sch_ex & "', " & "'" & sch_area & "', " & "'" & sch_age & "', " & "'" & chk_1 & "', " & "'" & chk_2 & "', " & "'" & chk_3 & "', " & "'" & chk_4 & "', " & "'" & so1 & "', " & "'" & so2 & "', " & "'" & so3 & "', " & "'" & psize & "', " & "'" & page & "', '', '', '', '', '', ''"


DisconnectDB DBCon
%>

<script type="text/javascript">

	$(document).ready(function () {

		//�����ι� selbox ����
        var sel_sch_gb = "<%=sch_gb%>";
        $("#sel_mojip").val(sel_sch_gb).attr("selected", "selected");

        //���� selbox ����
        var sel_sort = "<%=so1%>";
        $("#sel_sort").val(sel_sort).attr("selected", "selected");

        //������������ selbox ����
        var sel_psize = "<%=psize%>";
        $("#sel_psize").val(sel_psize).attr("selected", "selected");
    });

	//�˻�
    function goSearch() {
        fn_kwReset();
		$('#frm').attr("target", null);
        $('#frm').attr("action", "/company/applyjob/apply.asp");
        $('#frm').submit();
    }

	//�˻��� default �ʱ�ȭ
    function fn_kwReset() {
        var obj = $('#sch_kw');
        if (obj.val() == obj.attr('default'))
            obj.val("");
    }

	//������������ ����
    function goSelPsize(value) {
        fn_kwReset();
        $("#psize").val(value);
        $('#frm').attr("target", null);
        $('#frm').attr("action", "/company/applyjob/apply.asp");
        $('#frm').submit();
    }

	//ä������ι� ����
    function goMojip(value) {
        fn_kwReset();
        $("#sch_gb").val(value);
        $('#frm').attr("target", null);
        $('#frm').attr("action", "/company/applyjob/apply.asp");
        $('#frm').submit();
    }

    //���� ����
    function goSort(value) {
        fn_kwReset();
        $("#so1").val(value);
        $('#frm').attr("target", null);
        $('#frm').attr("action", "/company/applyjob/apply.asp");
        $('#frm').submit();
    }

	//��ܸ޴�(��ü,������,�����հ� ��...)
    function goApply(pid) {
        fn_kwReset();
        $("#pid").val(pid);

        $("#so1").val("");
        $("#sch_kw").val("");

        $('#frm').attr("target", null);
        $('#frm').attr("action", "/company/applyjob/apply.asp");
        $('#frm').submit();
    }

	//������ ����
    function goDelete() {
        if ($('input:checkbox[name="apply_num"]:checked').length == 0) {
            alert("�����ڸ� �����Ͽ� �ֽʽÿ�.");
            return;
        }
        if (!confirm("���� �����Ͻðڽ��ϱ�?")) {
            return;
        }

        var apply_num = "";
        $('input:checkbox[name="apply_num"]').each(function () {
            if (this.checked) {//checked ó���� �׸��� ��
                apply_num += "," + this.value;
            }
        });

        var param = {};
        param.gubun = "1";
        param.mode = $('#mode').val();
        param.jid = $('#jid').val();
        param.apply_num = apply_num.substr(1);

        $.ajax({
            type: "POST",
            url: "apply_setStatus.asp",
            data: param,
            dataType: "html",
            success: function (data) {
                if (data == "0") {
                    alert("������ ���� ����: �����ڿ��� �����ϼ���.");
                    return false;
                } else if (data == "3") {
                    alert("������ ������ �Ϸ�Ǿ����ϴ�.");
                    fn_kwReset();
                    $("#pid").val(status);
					$('#frm').attr("target", null);
                    $('#frm').attr("action", "/company/applyjob/apply.asp");
                    $('#frm').submit();
                } else {
                    alert("���� ������ ����: �����ڿ��� �����ϼ���. code=" + data);
                    return false;
                }
            },
            error: function (xhr) {
                var status = xhr.status;
                var responseText = xhr.responseText;
                alert(responseText + '//');
            }
        });
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
            url: "apply_setStatus.asp",
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
					fn_kwReset();					
                    $("#pid").val(status);
					$('#frm').attr("target", null);
                    $('#frm').attr("action", "/company/applyjob/apply.asp");
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
	
	//���º���
	function fn_SetParam(_gb, _apply_num, _status) {
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

	function fn_resume_view(rid, set_user_id) {
		
		$("#rid").val(rid);
		$("#set_user_id").val(set_user_id);

        $('#frm').attr("target", "_blank");
        $('#frm').attr("action", "./resumeView.asp");
        $('#frm').submit();
	}

	//��������
    function makeexcel() {
        fn_kwReset();
        var str_action = "/company/applyjob/excel_download.asp";
		$('#frm').attr("target", null);
        $('#frm').attr("action", str_action);
        $('#frm').submit();
    }	

</script>
</head>
<body>

<!-- ��� -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->
<!-- //��� -->


<!-- CONTENTS 2017 -->
<div id="career_container" class="appliCantWrap typeRnb"><!-- [D]��ü ä����� ������ Ŭ���� appliCantWrap ���� -->

    <div id="career_contents">
        <div class="contentsInn">
            <h2 class="blind">������ ����</h2>

            <!--#include file = "./apply_inc_sel_joblist.asp"-->

            <div class="layoutBox">
                <div class="titArea">
                    <h3>������ ����Ʈ</h3>
                    <span class="txt"> <strong class="num"><%=totalCnt%></strong>���� ������ ������ �ֽ��ϴ�.</span>
                </div><!--.titArea-->
                
                <form method="post" id="frm" name="frm" action="">
                    <input type="hidden" id="mode" name="mode" value="<%=mode%>" />
                    <input type="hidden" id="jid" name="jid" value="<%=jid%>" />
                    <input type="hidden" id="pid" name="pid" value="<%=pid%>" />
                    <input type="hidden" id="page" name="page" value="<%=page%>" />
                    <input type="hidden" id="psize" name="psize" value="<%=psize%>" />
                    <input type="hidden" id="so1" name="so1" value="<%=so1%>" />
					<input type="hidden" id="sch_gb" name="sch_gb" value="<%=sch_gb%>" />

                    <input type="hidden" id="rid" name="rid" value="" /> <!-- ����������� -->
                    <input type="hidden" id="apply_num_view" name="apply_num_view" value="" /> <!-- ����������� -->
                    <input type="hidden" id="apply_date_view" name="apply_date_view" value="" /> <!-- ����������� -->
					<input type="hidden" id="set_user_id" name="set_user_id" value="" /> <!-- ����������� -->
                    
                    <input type="hidden" id="rtype" name="rtype" value="" />
                    <input type="hidden" id="apply_num" name="apply_num" value="" />
                    <input type="hidden" id="gubun" name="gubun" value="" />
                    <input type="hidden" id="status" name="status" value="" />

                    <div class="searchArea">
                        <div class="searchInner">
                            <div class="fl">
                                <div class="inp">
                                    <button type="button" class="btn typeWhite" onclick="goDelete();">����</button>
                                </div>
                            </div><!--.fl-->
                            <div class="fr">
                                <div class="searchBox">
                                    <div class="inp">
										
										<% If isArray(arrRsMojip) Then %>
										<span class="selectbox" style="width:130px">
                                            <span>�����ι�</span>
                                            <select id="sel_mojip" title="�����ι�" onchange="goMojip(this.value)">
                                                <option value="">�����ι� ����</option>
												<% For i=0 To UBound(arrRsMojip, 2) %>
												<option value="<%=arrRsMojip(0, i)%>"><%=arrRsMojip(1, i)%></option>
												<% Next %>
                                            </select>
                                        </span><!-- .selectbox -->
										<% End If %>

                                        <span class="selectbox" style="width:119px">
                                            <span>����</span>
                                            <select id="sel_sort" title="���� ����" onchange="goSort(this.value)">
                                                <option value="������ desc, ������ȣ desc">�����ϡ�</option>
												<option value="������, ������ȣ desc">�����ϡ�</option>
                                                <option value="��¿��� desc, ������ȣ desc">��¡�</option>
                                                <option value="��¿���, ������ȣ desc">��¡�</option>
                                                <option value="�����з��ڵ� desc, ������ȣ desc">�з¡�</option>
                                                <option value="�����з��ڵ�, ������ȣ desc">�з¡�</option>
                                                <option value="������� desc, ������ȣ desc">���������</option>
                                                <option value="�������, ������ȣ desc">���������</option>
                                            </select>
                                        </span><!-- .selectbox -->
                                        <input class="txt value" id="sch_kw" name="sch_kw" type="text" default="�̸��� �Է��ϼ���." value="<%=sch_kw%>" style="width:229px;">
                                        <button type="button" class="btn typeBlack" onclick="goSearch()"><strong>�˻�</strong></button>
                                    </div><!-- .inp -->
                                </div><!-- .searchBox -->
                            </div><!--.fr-->
                        </div><!--.searchInner-->
                    </div><!-- .searchArea -->

                    <div class="boardArea">
                        <table class="tb" summary="�����ڿ� ���� �̸�/����/����,�̷¼� ����/�������,����/�̿���/,������/���� �׸��� ��Ÿ�� ǥ">
                            <caption>��ũ���� ���� ���</caption>
                            <colgroup>
                                <col width="160">
                                <col width="*">
                                <col width="105">
                                <col width="122">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th><div><label class="checkbox off"><input type="checkbox" class="chk" name="" onclick="noncheckallFnc(this, 'apply_num');"></label>�̸�/����</div></th>
                                    <th><div>�̷¼� ����/�������</div></th>
                                    <th><div>������/����</div></th>
                                    <th><div>����/����</div></th>
                                </tr>
                            </thead>
                            <tbody>
								<%
								If isArray(arrRs) Then 
								For i=0 To UBound(arrRs, 2)
								
								ConnectDB DBCon, Application("DBInfo_FAIR")
								Dim strSql, arrRsView
								strSql = "SELECT ������ȣ, �Ϸù�ȣ, �����ϰ��, �����ϸ�, �����ϸ� FROM ���ͳ��Ի���������÷�� WITH(NOLOCK) WHERE ä���Ϲ�ȣ ='"& jid &"' AND ������ȣ = '"& arrRs(34, i) &"' ORDER BY �Ϸù�ȣ"
								arrRsView = arrGetRsSql(DBCon, strSql, "", "")
								DisconnectDB DBCon

								'�����ι�
								Dim strMojip : strMojip = ""
								If arrRs(52, i) <> "" Then strMojip = "["& arrRs(52, i) &"]"

								'�հݻ���
								Dim statusNm
								Select Case arrRs(29, i)
									Case "1" : statusNm = "�ɻ���"
									Case "2" : statusNm = "������"
									Case "3" : statusNm = "�����հ�"
									Case "4" : statusNm = "�����հ�"
									Case "5" : statusNm = "���հ�"
								End Select 

								'�̷¼� ��������
								Dim isopen
								Select Case arrRs(31, i)
									Case "1" : isopen = "����"
									Case "0" : isopen = "�̿���"
								End Select

								'���� / ����
								Dim birth_ymd, birth_age
								If arrRs(3, i) = "1" Or arrRs(3, i) = "2" Then 
									birth_ymd = "19" & Left(arrRs(2, i), 2)
									birth_age = Left(Date(), 4) - birth_ymd + 1
								ElseIf arrRs(3, i) = "3" Or arrRs(3, i) = "4" Then 
									birth_ymd = "20" & Left(arrRs(2, i), 2)
									birth_age = Left(Date(), 4) - birth_ymd + 1
								End If

								'���ǥ��
								Dim career_str, tot_sum
								tot_sum = Abs(arrRs(12, i))

								If tot_sum = "0" Then 
									career_str = "����"
								ElseIf tot_sum > 12 Then
									career_str = fix(tot_sum / 12) & "�� " & tot_sum mod 12 & "����"
								Else 
									career_str = tot_sum & "����"
								End If

								' �������
								Dim strjc
								If arrRs(10, i) <> "" Then
									strjc = Replace(getJobTypeAll(arrRs(10, i)),"/",",")
								End If
								
								' �����з�
								Dim strFinalSchool
								Select Case arrRs(9, i)
									Case "3" : strFinalSchool = "����б�"
									Case "4" : strFinalSchool = "����(2,3��)"
									Case "5" : strFinalSchool = "���б�(4��)"
									Case "6" : strFinalSchool = "���п�"
								End Select 

								' �������
								Dim workArea, workAreaDetail, jj, strArea
								If arrRs(15, i) <> "" Then									
									workArea = split(arrRs(15, i), "|") 

									For ii=0 To Ubound(workArea)
										workAreaDetail = split(workArea(ii), "/")

										For jj=0 To Ubound(workAreaDetail)
											If jj = 0 Then
												strArea = strArea & get_simple_Ac(getAcName(workAreaDetail(jj)))
											End If
										Next
										
										If ii <> Ubound(workArea)  Then
											strArea = strArea & ","
										Else
											strArea = strArea & ""
										End If
									Next

									' �ߺ� ���� ����
									Dim workArea_temp, array_temp, m
									workArea_temp = ""

									array_temp = Split(strArea,",")

									For m = 0 To UBound(array_temp)
										If InStr(workArea_temp,array_temp(m)) = 0 Then
											If m =0 Then
												workArea_temp = array_temp(m)
											Else
												workArea_temp = workArea_temp & ", " & array_temp(m)
											End If
										End If
									Next
								End If

								%>
								<tr>
									<td class="t1">
										<div class="photoBox">
											<div class="inner">
												<div class="photo">
													<span class="frame sprite"></span>
													<img src="/files/mypic/<%=arrRs(24, i)%>" alt="" />
												</div>
												<em class="name"><%=arrRs(0, i)%></em>
												<p class="birth">(<span class="num"><%=birth_ymd%></span>���, <span class="num"><%=birth_age%></span>��)</p>
											</div>
											<label class="checkbox off"><input type="checkbox" class="chk" name="apply_num" value="<%=arrRs(50,i)%>"></label>
										</div>
									</td>
									<td class="t2">
										<div class="txtBox">
											<div class="tit">
												<% If arrRs(48,i) = "A" And arrRs(23,i) <> "" Then %>
												<a href="javascript:;" onclick="fn_resume_view('<%=arrRs(1,i)%>', '<%=objEncrypter.Encrypt(arrRs(51,i))%>'); fn_SetParam('read', '<%=arrRs(34, i)%>', '<%=arrRs(29,i)%>');"><strong><%=strMojip%><%=arrRs(23,i)%></strong></a>
												<% Else %>
												<a><strong><%=strMojip%><%=arrRs(49,i)%></strong></a>
												<% End If %>
											</div>
											<div>
												<dl>
													<dt>��³�� :</dt>
													<dd><%=career_str%></dd>
												</dl>
												<dl>
													<dt>������� :</dt>
													<dd><%=strjc%></dd>
												</dl>
												<dl>
													<dt>�����з� :</dt>
													<dd><%=strFinalSchool%></dd>
												</dl>
												<dl>
													<dt>������� :</dt>
													<dd><%=workArea_temp%></dd>
												</dl>
											</div>
										</div><!--.txtBox-->
									</td>
									<td class="t3 tc">
										<span class="num"><%=arrRs(30, i)%></span>
										<p class="sizeUp fc_black"><%=isopen%></p>
									</td>
									<td class="t4 tc">
										<div class="btnBox">
											<div class="tooltipArea type1 select">
												<button type="button" class="tooltipBtn"><span><%=statusNm%></span></button>
												<div class="box">
													<ul>
														<li><a href="javascript:void(0);" onclick="fn_SetParam('status', '<%=arrRs(34, i)%>', '2')">������</a></li>
														<li><a href="javascript:void(0);" onclick="fn_SetParam('status', '<%=arrRs(34, i)%>', '3')">�����հ�</a></li>
														<li><a href="javascript:void(0);" onclick="fn_SetParam('status', '<%=arrRs(34, i)%>', '4')">�����հ�</a></li>
														<li><a href="javascript:void(0);" onclick="fn_SetParam('status', '<%=arrRs(34, i)%>', '5')">���հ�</a></li>
													</ul>
												</div><!-- .box -->
											</div><!-- .tooltipArea -->

											<% If isArray(arrRsView) Then %>
											<div class="tooltipArea type1 select">
												<button type="button" class="btn typeWhite save"><span>��������</span></button>
												<div class="box">
													<ul>
														<% For ii=0 To UBound(arrRsView, 2) %>
														<li><a href="http://www2.career.co.kr/myjob/files/filedownload_apply_hkpartner.asp?aid=<%=arrRsView(0, ii)%>&orderno=<%=arrRsView(1, ii)%>&folderpath=<%=arrRsView(2, ii)%>&filename=<%=arrRsView(3, ii)%>&orifilename=<%=arrRsView(4, ii)%>" target="_blank" onclick="fn_SetParam('read', '<%=arrRs(34, i)%>', '<%=arrRs(29,i)%>');"><%=arrRsView(4, ii)%></a></li>
														<% Next %>
													</ul>
												</div><!-- .box -->
											</div><!-- .tooltipArea -->
											<% End If %>

										</div>
									</td>
								</tr>
								<%
								Next
								Else
								%>
								<tr>
									<td colspan="4">
										<div class="noData">
											<!--[D]������ �������-->
											<p>�ش���� �����ڰ� �����ϴ�.</p>
										</div><!-- .noData -->
									</td>
								</tr>
								<%
								End If
								%>
                            </tbody>
                        </table>
                    </div><!--.boardArea-->

                    <div class="setArea">
                        <div class="fl">
                            <button type="button" class="btn typeWhite save" onclick="makeexcel()"><span>��������</span></button>
                        </div><!-- .fl -->
                        <div class="fr">
                            <span class="selectbox" style="width:137px">
                                <span>10���� ����</span>
                                <select id="sel_psize" title="���� ����" onchange="goSelPsize(this.value)">
                                    <option value="10">10���� ����</option>
                                    <option value="15">15���� ����</option>
                                    <option value="20">20���� ����</option>
                                    <option value="30">30���� ����</option>
                                </select>
                            </span><!-- .selectbox -->
                        </div>
                    </div><!-- .setArea -->

                </form>
				
				<!--����¡-->
				<% Call putPage(page, stropt, totalPage) %>

            </div><!-- .layoutBox -->

        </div><!-- .contentsInn -->
    </div><!-- #career_contents -->
</div><!-- #career_container -->
<!-- CONTENTS 2017 -->


<!-- �ϴ� -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- //�ϴ� -->

</body>
</html>