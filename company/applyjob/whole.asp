<OBJECT RUNAT="SERVER" PROGID="ADODB.RecordSet" ID="Rs"></OBJECT>
<%
'--------------------------------------------------------------------
'   Comment		: ���ȸ�� > ä����� ����
' 	History		: 2020-05-18, �̻��� 
'---------------------------------------------------------------------

'option Explicit

'------ ������ �⺻���� ����.
g_MenuID		= "010001"  ' �� �� ���ڴ� lnb ��������, �� �� ���ڴ� �޴� �̹��� ���ϸ� ����
g_MenuID_Navi	= "0,1"		' ������̼� ��
%>
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/inc/function/paging.asp"-->
<!--#include virtual = "/include/header/header.asp"-->
<%
Call FN_LoginLimit("2")    '���ȸ���� ���ٰ���


Dim hireStat : hireStat = Request("hireStat")	' ä������ ����Ʈ ȣ�� ������(total: ��ü, ing: ����, cl: ����, keep: ��⺸��)

If Len(hireStat)=0 Then 
	hireStat = "total"
End If 


Dim page, pageSize, schStartDate, schEndDate, schKeyword, stropt
page			= CInt(Request("page"))
pageSize		= CInt(Request("pageSize"))
schStartDate	= Request("schStartDate")
schEndDate		= Request("schEndDate")
schKeyword		= Request("schKeyword")

If schKeyword="undefined" Then
	schKeyword = ""
Else 
	schKeyword = schKeyword
End If 


If page=0 Then page = 1
pageSize = 10

stropt = "hireStat="& hireStat &"&schStartDate="& schStartDate &"&schEndDate="& schEndDate &"&schKeyword="& server.URLEncode(schKeyword)&"#hirelist"


ConnectDB DBCon, Application("DBInfo_FAIR")


If comid <> "" Then 

	' ���ȸ�� ���� ȣ��
	Dim strSql, BizName, BossName, ZipCode, AddrKor, BizScale, Workforce, BizHomePage, CreateDate, GoodsName, BizRegCode, BizLogoUrl, strBizHomePage, strBizScale, strCreateDate 
    strSql = "SELECT TOP 1 ȸ���, ��ǥ�ڼ���, �����ȣ, �ּ�, ����, isnull(�����, 0), Ȩ������, ��������, �ֿ�������, ����ڵ�Ϲ�ȣ, �ΰ�URL " &_
	          "FROM ȸ������ WITH(NOLOCK) "&_
	          "WHERE ȸ����̵�='"& comid &"'"
	Rs.Open strSql, DBCon, adOpenForwardOnly, adLockReadOnly, adCmdText
	Dim flagRs : flagRs = False 
	If Rs.eof = False And Rs.bof = False Then
		flagRs		= True 
		BizName		= Rs(0)		' ȸ���
		BossName	= Rs(1)		' ��ǥ�ڸ�
		ZipCode		= Rs(2)		' �����ȣ
		AddrKor		= Rs(3)		' ȸ���ּ�
		BizScale	= Rs(4)		' �������
		Workforce	= Rs(5)		' �����
		BizHomePage	= Rs(6)		' ȸ��Ȩ������
		CreateDate	= Rs(7)		' ȸ�缳����
		GoodsName	= Rs(8)		' �ֿ�������
		BizRegCode	= Rs(9)		' ����ڹ�ȣ
		BizLogoUrl	= Rs(10)	' ��� �ΰ� �̹���
	End If	

	' Ȩ������ URL ��� üũ
	If InStr(BizHomePage,"http")>0 Then
		strBizHomePage	= BizHomePage
	Else
		strBizHomePage	= "http://"& BizHomePage
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
		Case "4"
			strBizScale = "�߼ұ��"
		Case "5"
			strBizScale = "���ұ��"
		Case "6"
			strBizScale = "�Ϲݱ��"
		Case Else 
			strBizScale = "Ȯ�κҰ�"
	End Select


	If Len(CreateDate)>0 Then 
		strCreateDate = Left(CreateDate,4)&"."&Mid(CreateDate,5,2)&"."&Right(CreateDate,2)
	End If



	' �ش� ���ȸ���� ����� ä�� ���� ī��Ʈ ȣ��(��ü, ����, ����, ��⺸��)
	Dim SpName1, spJobsCnt_Total, spJobsCnt_Ing, spJobsCnt_End, spJobsCnt_Old, SpName2  
	SpName1="USP_BIZSERVICE_JOBS_CNT"
		Dim param(4)
		param(0)=makeParam("@BIZ_ID", adVarChar, adParamInput, 20, comid)
		param(1)=makeParam("@TOTAL_JOBS_CNT", adInteger, adParamOutput, 4, 0)
		param(2)=makeParam("@ING_JOBS_CNT", adInteger, adParamOutput, 4, 0)
		param(3)=makeParam("@END_JOBS_CNT", adInteger, adParamOutput, 4, 0)
		param(4)=makeParam("@OLD_JOBS_CNT", adInteger, adParamOutput, 4, 0)

		Call execSP(DBCon, SpName1, param, "", "")

		spJobsCnt_Total	= getParamOutputValue(param, "@TOTAL_JOBS_CNT")	' ��ü
		spJobsCnt_Ing	= getParamOutputValue(param, "@ING_JOBS_CNT")	' ����
		spJobsCnt_End	= getParamOutputValue(param, "@END_JOBS_CNT")	' ����
		spJobsCnt_Old	= getParamOutputValue(param, "@OLD_JOBS_CNT")	' ��⺸��




	' �ش� ���ȸ���� ����� ä�� ���� ����Ʈ ȣ��(��ü, ����, ����)
If hireStat="total" Then 
	SpName2="USP_BIZSERVICE_JOBS_LIST_TOT"
Else 
	SpName2="USP_BIZSERVICE_JOBS_LIST"
End If
	Set cmd = Server.CreateObject("ADODB.Command")
	With cmd
		.ActiveConnection	= DBCon
		.CommandText		= SpName2
		.CommandType		= adCmdStoredProc
		.Parameters.Append .CreateParameter("@NowPage",adInteger,adParamInput,4, page)
		.Parameters.Append .CreateParameter("@PageSize",adInteger,adParamInput,4,pageSize)
		.Parameters.Append .CreateParameter("@SDate",adVarChar,adParamInput, 10, schStartDate)
		.Parameters.Append .CreateParameter("@EDate",adVarChar,adParamInput, 10, schEndDate)
		.Parameters.Append .CreateParameter("@ComID",adVarChar,adParamInput, 20, comid)
If hireStat<>"total" Then 
		.Parameters.Append .CreateParameter("@ListType",adVarChar,adParamInput, 8, hireStat)
End If
		.Parameters.Append .CreateParameter("@SchKw",adVarChar,adParamInput, 50, schKeyword)
		.Parameters.Append .CreateParameter("@TotalCnt",adInteger,adParamOutput)
		.Parameters.Append .CreateParameter("@TotalPage",adInteger,adParamOutput)
		.Execute
		totalCount			= .Parameters("@TotalCnt").value
		totalPage			= .Parameters("@TotalPage").value
		Set iRs = .Execute
	End With
	Set cmd = Nothing
	If Not iRs.EOF Then
		arrList	= iRs.GetRows()
	Else
		arrList = Null
	End if
	Set iRs = Nothing

End If 
%>
<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
<script type="text/javascript">
<!--
	/*�ּҰ˻� ����*/
	function openPostCode() {
		new daum.Postcode({
			oncomplete: function (data) {
				// �˾����� �˻���� �׸��� Ŭ�������� ������ �ڵ带 �ۼ��ϴ� �κ�.

				// ���θ� �ּ��� ���� ��Ģ�� ���� �ּҸ� �����Ѵ�.
				// �������� ������ ���� ���� ��쿣 ����('')���� �����Ƿ�, �̸� �����Ͽ� �б� �Ѵ�.
				var fullRoadAddr = data.roadAddress; // ���θ� �ּ� ����
				var extraRoadAddr = ''; // ���θ� ������ �ּ� ����

				// ���������� ���� ��� �߰��Ѵ�. (�������� ����)
				// �������� ��� ������ ���ڰ� "��/��/��"�� ������.
				if (data.bname !== '' && /[��|��|��]$/g.test(data.bname)) {
					extraRoadAddr += data.bname;
				}
				// �ǹ����� �ְ�, ���������� ��� �߰��Ѵ�.
				if (data.buildingName !== '' && data.apartment === 'Y') {
					extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
				}
				// ���θ�, ���� ������ �ּҰ� ���� ���, ��ȣ���� �߰��� ���� ���ڿ��� �����.
				if (extraRoadAddr !== '') {
					extraRoadAddr = ' (' + extraRoadAddr + ')';
				}
				// ���θ�, ���� �ּ��� ������ ���� �ش� ������ �ּҸ� �߰��Ѵ�.
				if (fullRoadAddr !== '') {
					fullRoadAddr += extraRoadAddr;
				}

				// �����ȣ�� �ּ� ������ �ش� �ʵ忡 �ִ´�.
				document.getElementById('hidZipCode').value		= data.zonecode; //5�ڸ� ���ּ� �����ȣ
				document.getElementById('txtCompAddr').value	= fullRoadAddr;
				$("#htmTdCompAddrArea").html("���� �ּ�");
				$("#CompAddrEdit").html(fullRoadAddr);
				$("#CompAddrEditArea").show();
			}
		}).open({popupName: 'postcodePopup'});
	}
	/*�ּҰ˻� ��*/

	// ������� �ּ� ���� �� ��ȿ�� üũ
	function fn_sumbit_Addr(){
		var txtCompAddrDetail = $("#txtCompAddrDetail").val();

		if(txtCompAddrDetail=="ȸ�� ���ּ�"){
			txtCompAddrDetail="";
		}

		if(txtCompAddrDetail==""){
			alert("ȸ�� ���ּ� ������ �Է��� �ּ���.");
			$("#txtCompAddrDetail").focus();
			return;
		}
		
		var obj=document.frm_addr;
		if(confirm('�Է��Ͻ� �������� ȸ�� �ּҸ� ���� �Ͻðڽ��ϱ�?')) {
			obj.method			= "post";
			obj.EditType.value	= "addr";
			obj.action = "company_addr_proc.asp";
			obj.submit();
		}
	}

	// ������� ���� �Է� �� ��ȿ�� üũ
	function fn_sumbit(){
		var txtBossName		= $("#txtBossName").val();	
		//var txtCreateDate	= $("#txtCreateDate").val();
		var txtEmpCnt		= $("#txtEmpCnt").val();
		var txtHomePage		= $("#txtHomePage").val();
		var txtBizInfo		= $("#txtBizInfo").val();

		var chkVal			= $("#chkLogoDel").is(":checked");	// ��� �ΰ� ���� ����
		if (chkVal == false){
			$("#hidLogoDelYn").val("N");
		}else{
			$("#hidLogoDelYn").val("Y");
		}	

		if(txtBossName==""){
			alert("��ǥ�ڸ��� �Է��� �ּ���.");
			$("#txtBossName").focus();
			return;
		}
		
		/*
		if(txtCreateDate=="��-�� ���� �����ϼ� ��¥ �Է� (yyyymmdd)"){
			txtCreateDate="";
		}

		if(txtCreateDate==""){
			alert("�������� �Է��� �ּ���.");
			$("#txtCreateDate").focus();
			return;
		}else{
			//���ڰ� ��¥���� �´��� üũ
			if (txtCreateDate.length<8){
				alert("��Ȯ�� ��¥�� �Է��� �ּ���.\n(ex: â������ = 2002�� 1�� 3�� �� 20020103)");
				return false;
			}

			var rxDatePattern	= /^(\d{4})(\d{1,2})(\d{1,2})$/;		// Declare Regex                  
			var dtArray			= txtCreateDate.match(rxDatePattern);	// is format OK?

			//Checks for yyyymmdd format.
			dtYear	= dtArray[1];
			dtMonth = dtArray[2];
			dtDay	= dtArray[3];

			var today = new Date();
			var year  = today.getFullYear(); // ���翬��
			var month = today.getMonth()+1;  // �����

			if (dtYear < 1900 || dtYear > year){
				alert("���������� ��ȿ���� �ʽ��ϴ�.\n(1900~"+year+"�⵵ ������ ���ڸ� �Է� ����)");
				return false;
			}
			
			if (dtYear == year && dtMonth > month){
				alert("�������ں��� �̷��� ��¥�� �������ڰ� �ԷµǾ����ϴ�.\n�ٽ� Ȯ���� �ּ���.");
				return false;
			}
		
			if (dtMonth < 1 || dtMonth > 12){
				alert("�������� ��ȿ���� �ʽ��ϴ�.");
				return false;
			}

			if (dtDay < 1 || dtDay > 31){
				alert("�������� ��ȿ���� �ʽ��ϴ�.");
				return false;
			}
			
			if (dtMonth == 2) {
				var isleap = (dtYear % 4 == 0 && (dtYear % 100 != 0 || dtYear % 400 == 0));
				if (dtDay > 29 || (dtDay == 29 && !isleap)){
					alert(dtYear+"�� 2���� ������ ��¥�� 28�� �Դϴ�.");
					return false;
				}
			}

		}
		*/

		if(txtEmpCnt==""){
			alert("������� �Է��� �ּ���.");
			$("#txtEmpCnt").focus();
			return;
		}

		if(txtHomePage==""){
			alert("Ȩ������ �ּҸ� �Է��� �ּ���.");
			$("#txtHomePage").focus();
			return;
		}

		if(txtBizInfo=="") {
			alert('�ֿ� ��������� �Է��� �ּ���.');
			$("#txtBizInfo").focus();
			return;
		}

		var obj=document.frm_popup;
		if(confirm('�Է��Ͻ� �������� ��������� ���� �Ͻðڽ��ϱ�?')) {
			obj.method = "post";
			obj.action = "company_info_proc.asp";
			obj.submit();
		}

	}

	// ������� �˾� ����
	$(document).ready( function(){
		$("#btn_stop").click( function(e) {

			var chk = false;
			var txtBossName		= $("#txtBossName").val();	
			var txtCreateDate	= $("#txtCreateDate").val();
			var txtEmpCnt		= $("#txtEmpCnt").val();
			var txtHomePage		= $("#txtHomePage").val();
			var txtBizInfo		= $("#txtBizInfo").val();
			var selBizScale		= $("#selBizScale").val();
			
			oriEmpCnt = parseInt(txtEmpCnt.replace(/,/g,""));

			if (txtBossName != "<%=BossName%>") {
				chk = true;
			}

			/*if(txtCreateDate == "��-�� ���� �����ϼ� ��¥ �Է� (yyyymmdd)"){
				txtCreateDate = "";
			}

			if (txtCreateDate != "<%=CreateDate%>") {
				chk = true;
			}*/

			if (oriEmpCnt != "<%=Workforce%>") {
				chk = true;
			}

			if (txtHomePage != "<%=BizHomePage%>") {
				chk = true;
			}

			if (txtBizInfo != "<%=GoodsName%>") {
				chk = true;
			}

			if (selBizScale != "<%=BizScale%>") {
				chk = true;
			}

			if(chk){		
				if(confirm('������� �׸� �� ������ ������ �ֽ��ϴ�.\n�Է��� ������ ��� �Ͻðڽ��ϱ�?')) {
					alert("��ҵǾ����ϴ�.");	
					location.reload();
				}
			}else{
				$('.popup, .pop_dim').hide();
			}

		});
	});

	// ���º� ä������ ��ȸ
	function fn_hireAnnounce(v){
		if(v!=""){
			var obj = document.frm_list;
			obj.method				= "post";
			obj.hireStat.value		= v;
			obj.schStartDate.value	= "";
			obj.schEndDate.value	= "";
			obj.schKeyword.value	= "";
			obj.action				= "whole.asp#hirebox";
			obj.submit();
		}
	}

	// 1����, 3����, 6���� �Ⱓ ��ư
/*	function setSearchDate(start){
		var num		= start.substring(0,1);
		var str		= start.substring(1,2);	
		var today	= new Date();

		//var year = today.getFullYear();
		//var month = today.getMonth() + 1;
		//var day = today.getDate();
		
		var endDate = $.datepicker.formatDate('yy-mm-dd', today);
		$('#schEndDate').val(endDate);
		
		if(str == 'd'){
			today.setDate(today.getDate() - num);
		}else if (str == 'w'){
			today.setDate(today.getDate() - (num*7));
		}else if (str == 'm'){
			today.setMonth(today.getMonth() - num);
			today.setDate(today.getDate() + 1);
		}

		var startDate = $.datepicker.formatDate('yy-mm-dd', today);
		$('#schStartDate').val(startDate);
				
		// �������� ������ ���� ��¥ �������� ���ϵ��� ��Ȱ��ȭ
		$("#schEndDate").datepicker("option", "minDate", startDate);
		
		// �������� ������ ���� ��¥ �������� ���ϵ��� ��Ȱ��ȭ
		$("#schStartDate").datepicker("option", "maxDate", endDate);
	}*/	

	// ��¥ �˻�
    function fn_search() {
        if ($("#schStartDate").val() != "" || $("#schEndDate").val()) {
            if ($("#schStartDate").val() == "") {
                alert("�������� ������ �ּ���.");
				$("#schStartDate").focus();
                return false;
            }

            if ($("#schEndDate").val() == "") {
                alert("�������� ������ �ּ���.");
				$("#schEndDate").focus();
                return false;
            }

            if ($("#schStartDate").val().replace("-", "") > $("#schEndDate").val().replace("-", "")) {
                alert("�������� �����Ϻ��� ���� ��¥�� �����Ǿ����ϴ�.\n�ٽ� ������ �ּ���.");
				$("#schStartDate").focus();
                return false;
            }
        }

		var obj = document.frm_list;
		obj.method			= "post";
		obj.hireStat.value	= "<%=hireStat%>";
		obj.action			= "whole.asp#hirelist";
		obj.submit();

    }

	// �˻� �ʱ�ȭ
    function fn_reset() {
			var obj = document.frm_list;
			obj.method				= "post";
			obj.hireStat.value		= "<%=hireStat%>";
			obj.schStartDate.value	= "";
			obj.schEndDate.value	= "";
			obj.schKeyword.value	= "";
			obj.action				= "whole.asp#hirelist";
			obj.submit();		
	}


	function onlyNumber(event){
		event = event || window.event;
		var keyID = (event.which) ? event.which : event.keyCode;
		if ( (keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
			return;
		else
			return false;
	}

	function removeChar(event) {
		event = event || window.event;
		var keyID = (event.which) ? event.which : event.keyCode;
		if ( keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
			return;
		else
			event.target.value = event.target.value.replace(/[^0-9]/g, "");
	}


	function goApply(mode, jid, pid) {
		var url = "/company/applyjob/apply.asp?mode=" + mode + "&jid=" + jid + "&pid=" + pid
		location.href = url;
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
                    location.reload();
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
                    location.reload();
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
//-->
</script>
</head>
<body>

<!-- ��� -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->
<!-- //��� -->


<!-- ���� -->
<div id="contents" class="sub_page">

	<div class="content glay">
		<div class="con_area">
			<div class="jobs_area">

				<a class="btn_modi pop" href="javascript:void(0);">������� ����</a>

				<div class="tlt_wrap">
					<h3>�������</h3>
				</div>
				<div class="table_row_type1" style="margin-top:17px;">

				<form method="post" name="frm_addr">
				<input type="hidden" name="EditType" id="EditType" value="" />
				<input type="hidden" name="compId" id="compId" value="<%=comid%>" />
				<input type="hidden" name="BizNum" id="BizNum" value="<%=BizRegCode%>" />
					<table cellpadding="0" cellspacing="0" summary="������� ���̺�">
						<caption>������� ���̺�</caption>
						<colgroup>
							<col style="width:15%;" />
							<col style="width:35%;" />
							<col style="width:15%;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">�����</th>
								<td><%=BizName%></td>
								<th scope="row">��ǥ��</th>
								<td><%=BossName%></td>
							</tr>
							<tr>
								<!--
								<th scope="row">������</th>
								<td><%If Len(CreateDate)>0 Then%><%=strCreateDate%><%Else Response.write "-" End If%></td>
								-->
								<th scope="row">�����</th>
								<td><%=FormatNumber(Workforce,0)%> ��</td>
								<th scope="row">�������</th>
								<td><%=strBizScale%></td>
							</tr>
							<tr>								
								<th scope="row">Ȩ������</th>
								<td>
								<%If Len(BizHomePage)>0 Then%>
									<a class="link" href="<%=strBizHomePage%>" target="_blank" title="��â���� ����"><%=strBizHomePage%></a>
								<%Else Response.write "-" End If%>
								</td>
								<th scope="row">����ΰ�</th>
								<td>
								<%If isnull(BizLogoUrl)=False And BizLogoUrl<>"" Then%>
									<img src="/files/company/<%=BizLogoUrl%>">
								<%End If%>
								</td>
							</tr>
							<tr>
								<th scope="row" id="htmTdCompAddrArea">�ּ�</th>
								<td colspan="3" class="address">
									<a class="btn_address" onclick="openPostCode(); return false;" style="cursor:pointer">�ּ� �˻�</a>
									<span><%=AddrKor%></span> 
								</td>
							</tr>
							<tr id="CompAddrEditArea" style="display:none;height:100px;">
								<th scope="row" style="color:#ff3366;">���� �ּ�</th>
								<td colspan="3" class="address">
									<a class="btn_address moti" onclick="fn_sumbit_Addr(); return false;" style="cursor:pointer;">�ּ� ����</a>
									<input type="hidden" id="hidZipCode" name="hidZipCode" value="" />	
									<input type="hidden" id="txtCompAddr" name="txtCompAddr" value="" />
									<span id="CompAddrEdit"></span> 																
									<div class="address_detail">
										<input type="text" id="txtCompAddrDetail" name="txtCompAddrDetail" maxlength="100" style="ime-mode:active;" placeholder="ȸ�� ���ּ�">
										<a id="layer_close" class="moti_cansel" style="cursor:pointer">[ X ]</a>
									</div>									
								</td>
							</tr>
							<tr>
								<th scope="row">�ֿ� �������</th>
								<td colspan="3"><%If Len(GoodsName)>0 Then%><%=GoodsName%><%Else Response.write "-" End If%></td>
							</tr>
						</tbody>
					</table>
				</form>
				</div>


<form method="post" id="frm_list" name="frm_list" action="">
<input type="hidden" id="hireStat" name="hireStat" value="<%=hireStat%>" />
			<a name="hirebox">
				<div class="table_col_type1" style="margin-top:17px;">
					<table cellpadding="0" cellspacing="0" summary="������� ���̺�">
						<caption></caption>
						<colgroup>
							<col style="width:33%;">
							<col style="width:33%;">
							<col style="width:33%;">
							<!-- <col /> -->
						</colgroup>
						<thead>
							<tr>
								<th scope="col">��ü ä������</th>
								<th scope="col">������</th>
								<th scope="col">ä�븶��</th>
								<!-- <th scope="col">��⺸��</th> -->
							</tr>
						</thead>
						<tbody>
							<tr>
								<td <%If hireStat="total" Then%>class="fc_blu"<%End If%>><a href="javascript:fn_hireAnnounce('total');"><%=FormatNumber(spJobsCnt_Total,0)%></a></td>
								<td <%If hireStat="ing" Then%>class="fc_blu"<%End If%>><a href="javascript:fn_hireAnnounce('ing');"><%=FormatNumber(spJobsCnt_Ing,0)%></a></td>
								<td <%If hireStat="cl" Then%>class="fc_blu"<%End If%>><a href="javascript:fn_hireAnnounce('cl');"><%=FormatNumber(spJobsCnt_End,0)%></a></td>
								<!-- <td <%'If hireStat="keep" Then%>class="fc_blu"<%'End If%>><a href="javascript:fn_hireAnnounce('keep');"><%'=FormatNumber(spJobsCnt_Old,0)%></a></td> -->
							</tr>
						</tbody>
					</table>
				</div>
			</a>
				
				<div class="jobs_txt">
					<ul>
						<li>- ä����� ����Ⱓ�� ���������Ϸκ��� �ִ� 90�ϱ��� �Դϴ�.</li>
						<!-- <li>- ���� ����� �ִ� 10�� ������ �����մϴ�.</li> -->
						<li>- ������ ä������ �������� �� 90�ϰ� ���� ����Ʈ���� Ȯ�� �����մϴ�.   <!-- (1�Ⱓ ��⺸���� ���Ͻø� �������� ��ư Ŭ��!) --></li>
						<li>- �����ڴ� �Ի������Ϸκ��� 90�ϰ�<!-- , ��ũ���� ����� ��ũ���Ϸκ��� 90�ϰ� --> Ȯ�� �����մϴ�.</li>
					</ul>
					<div class="btn_wrap">
						<a class="btn_regi" href="<%=g_members_wk%>/biz/jobpost/step_fair?site_code=<%=site_code%>&site_gubun=E"><span>ä����� ����ϱ�</span></a>
					</div>
				</div>

				<div class="step_area">
					<ul>
						<li>01. �������� ���� : �������� �̷¼��� ���� �� �����հ�/���հ� ������ �����մϴ�.</li>
						<li>02. �����հ� : ������ ����� �ɻ���¸� �����հ����� ������ �־�߸� ���� �հݻ��°� �˴ϴ�.</li>
						<li>03. �������� : ȭ����� �ð� ������ �����հ��ڸ� ������θ� �����ϰ�, �Ͻô� �λ����ڴ��� ���� �� �ֽ��ϴ�.</li>
						<li>04. �����Ϸ� : ������ �Ϸ�Ǹ�, �������� �ڵ����� �����ǰ� �ڵ����� �����˴ϴ�.</li>
						<li>05. �������� : �������� ������ �������� ������������ư Ŭ�� �� ���������� �����մϴ�. (��, �˸� ���ڸ� �����ڿ��� �߼� �� ���� �Ұ�)</li>
					</ul>
				</div>

<%
Dim strHireType, strHireTypeDetail
Select Case hireStat
	Case "total" :
		strHireType			= "��ü"
		strHireTypeDetail	= "��ü"
	Case "ing" :
		strHireType			= "������"
		strHireTypeDetail	= "��������"
	Case "cl" :
		strHireType			= "����"
		strHireTypeDetail	= "������"
	Case "keep" :
		strHireType			= "��⺸��"
		strHireTypeDetail	= "��Ⱓ ��������"
End Select 
%>
			<a name="hirelist">
				<div class="tlt_wrap">
					<h3 id="txt"><%=strHireType%> ä������</h3>
					<span class="list_number"><span class="number"><%=FormatNumber(totalCount,0)%></span>���� <%=strHireTypeDetail%> ä�������� �ֽ��ϴ�.</span>
				</div>
			</a>

				<!-- // �˻�â -->
				<div class="searchArea">
						<div class="searchInner">
							<div class="fl">
								<dl>
									<dt class="blind">��ȸ�Ⱓ ���� :</dt>
									<dd>
										<!-- <ul class="monthSort">
											<li><button type="button" class="round" name="dateType" id="dateType1" onclick="setSearchDate('1m')">1����</button></li>
											<li><button type="button" class="round" name="dateType" id="dateType2" onclick="setSearchDate('3m')">3����</button></li>
											<li><button type="button" class="round" name="dateType" id="dateType3" onclick="setSearchDate('6m')">6����</button></li>
										</ul> --><!-- .monthSort -->
										<div class="datePick">
											<span>
												<input id="schStartDate" name="schStartDate" class="datepicker inpType" type="text" title="�˻� ������ ����" onclick="useDatePicker('#schStartDate');" value="<%=schStartDate%>" readOnly>
												<button type="button" class="btncalendar dateclick" onclick="useDatePicker('#schStartDate');">��¥����</button>
											</span>
											<span class="hyphen">~</span>
											<span>
												<input id="schEndDate" name="schEndDate" class="datepicker inpType" type="text" title="�˻� ������ ����" onclick="useDatePicker('#schEndDate');" value="<%=schEndDate%>" readOnly>
												<button type="button" class="btncalendar dateclick" onclick="useDatePicker('#schEndDate');">��¥����</button>
											</span>
											<button type="button" class="btn reset" onclick="dateReset();">�ʱ�ȭ</button>
										</div><!--.datePick-->
									</dd>
								</dl>
							</div><!--.fl-->

							<div class="fr">
								<div class="searchBox">
									<!-- <span class="selectbox" style="width:165px">
										<span>����ں�</span>
										<select id="schManager" name="schManager" title="����ں� ����" selected="selected">
											<option value="">����ں�</option>
											<option value="ä������">ä������</option>
										</select>
									</span> --><!-- .selectbox -->

									<div>
										<input class="txt" id="schKeyword" name="schKeyword" type="text" placeholder="ä����� ����, ���������� Ű���� �Է�" value="<%=schKeyword%>" style="width:377px;">
										<button type="button" class="btn typegray" onclick="fn_search();"><strong>�˻�</strong></button>
										<!-- <button type="button" class="btn typegray" onclick="fn_reset();"><strong>�ʱ�ȭ</strong></button> -->
									</div>
								</div><!-- .searchBox -->
							</div><!--.fr-->

						</div><!--.searchInner-->
					</form>
				</div>
				<!-- �˻�â // -->

				<!-- // ����Ʈ -->
				<div class="boardArea">
					<table class="tbX" cellpadding="0" cellspacing="0" summary="ä�������� ���� �׸��� ��Ÿ�� ǥ">
						<caption>ä������ ���</caption>
						<colgroup>
							<col width="530">
							<col width="*">
						</colgroup>
						<tbody>
<%
If IsArray(arrList) Then
	Dim arrRsApplyCnt
	Dim reParam(2)
	Dim total_cnt, not_open_cnt, before_cnt, ing_cnt, papers_cnt, final_cnt, failure_cnt

	For i = LBound(arrList,2) To UBound(arrList,2)
		gubun			= Trim(arrList(0,i))	' ä����� ���� ������(ing : ����, cl: ����)
		seq				= Trim(arrList(1,i))	' ��Ϲ�ȣ	
		title			= Trim(arrList(2,i))	' ä����� ����
		regDate			= Trim(arrList(3,i))	' �������
		modDate			= Trim(arrList(4,i))	' ��������
		closeDate		= Trim(arrList(5,i))	' ������������	
		closeType		= Trim(arrList(6,i))	' ������������	
		hitCnt			= Trim(arrList(7,i))	' ��ȸ��
		applyCnt_online	= Trim(arrList(8,i))	' �¶��� �Ի����� ��
		regdate2		= Trim(arrList(9,i))	' ���ʵ����(������)
		regType			= Trim(arrList(10,i))	' �������
		reportNum		= Trim(arrList(11,i))	' ����ä���Ϲ�ȣ
		applyCnt_today	= Trim(arrList(12,i))	' ���� �Ի����� ��
		rcpProcess		= Trim(arrList(13,i))	' �������				
		delDate			= Trim(arrList(14,i))	' ����������
		contLen			= Trim(arrList(15,i))	' �����������
		ocpCode			= Trim(arrList(16,i))	' �����ڵ�
		managerNm		= Trim(arrList(17,i))	' ����ڸ�
		unreadCnt		= Trim(arrList(18,i))	' �̿�����
		keepStat		= Trim(arrList(19,i))	' ��������
		deadline		= Trim(arrList(20,i))	' ������������

		
		Select Case closeType
			Case "1" :
				If IsNull(closeDate) Then 
					strCloseDt = FormatDateTime(deadline, 2)
				Else 
					strCloseDt = FormatDateTime(closeDate, 2)
				End If 
			Case "2" : 
				strCloseDt = "ä�� �� ����"
			Case "3" :
				strCloseDt = "���ä��"
		End Select
		
		spName = "USP_BIZSERVICE_APPLY_CNT"
		reParam(0) = makeParam("@mode", adVarchar, adParamInput, 10, gubun)
		reParam(1) = makeParam("@comid", adVarchar, adParamInput, 20, comid)
		reParam(2) = makeParam("@jid", adInteger, adParamInput, 4, seq)

		arrRsApplyCnt = arrGetRsSP(dbCon, spName, reParam, "", "")
		
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
%>
							<tr>
								<td class="t1">
									<div class="txtBox">
										<div class="tit">
											<a href="/jobs/view.asp?id_num=<%=seq%>" target="_blank"><strong><%=title%></strong></a>
										</div><!-- .tit -->
										<div>
											<dl>
												<dt>����Ⱓ :</dt>
												<dd><span class="num"><%=FormatDateTime(regDate, 2)%> ~ <%=strCloseDt%></span></dd>
												<dt>����� :</dt>
												<dd><%=managerNm%></dd>
											</dl>
										</div>
												
										<div class="noti">
									<%If gubun="ing" Then%>	
											<span class="fc_blu09">�� ä����</span>
									<%Else%>		
											<span class="fc_ora06">�� ä�븶��</span>
									<%End If%>
										</div><!-- .noti -->

									</div><!-- .txtBox -->
								</td>
								<td class="t2">
									<div class="infoBox hire">
										<ul class="info1">
											<li>
												<dl>
													<dt>��ü ������</dt>
													<dd><a href="javascript:void(0);" onclick="goApply('<%=gubun%>', '<%=seq%>', '0');"><strong class="num fc_gra3"><%=total_cnt%></strong></a></dd>
												</dl>
											</li>
											<li>
												<dl>
													<dt>�̿���</dt>
													<dd><a href="javascript:void(0);" onclick="goApply('<%=gubun%>', '<%=seq%>', '1');"><strong class="num fc_ora04"><%=not_open_cnt%></strong></a></dd>
												</dl>
											</li>
											<li>
												<dl>
													<dt>�ɻ���</dt>
													<dd><a href="javascript:void(0);" onclick="goApply('<%=gubun%>', '<%=seq%>', '2');"><strong class="num fc_blu09"><%=ING_CNT%></strong></a></dd>
												</dl>
											</li>
											<li>
												<dl>
													<dt>�����հ�</dt>
													<dd><a href="javascript:void(0);" onclick="goApply('<%=gubun%>', '<%=seq%>', '3');"><strong class="num"><%=PAPERS_CNT%></strong></a></dd>
												</dl>
											</li>
											<li>
												<dl>
													<dt>���հ�</dt>
													<dd><a href="javascript:void(0);" onclick="goApply('<%=gubun%>', '<%=seq%>', '5');""><strong class="num"><%=FAILURE_CNT%></strong></a></dd>
												</dl>
											</li>
										</ul><!-- .info1 -->

										<ul class="info2">
											<!--
											<li>
												<a href="javascript:void(0);" onclick="alert('�غ� �� �Դϴ�.');">������ ���</a>
											</li>
											-->
											<li>
												<a href="javascript:void(0);" class="toggle">�������</a><!-- [D] Ŭ���� �����ڽ� ���� -->
												<div class="tooltipArea">
													<div class="box">
														<ul>
															<li><a href="/jobs/view.asp?id_num=<%=seq%>" target="_blank">����</a></li>
														<%If gubun = "ing" Then%>
															<li><a href="javascript:void(0);" onclick="fn_jobpost_modify('EDIT', '<%=seq%>')">����</a></li>
														<%End If%>
															<li><a href="javascript:void(0);" onclick="fn_jobpost_modify('LOAD', '<%=seq%>')">����</a></li>
														<%If gubun = "ing" Then%>
															<li><a href="javascript:void(0);" onclick="fn_jobpost_end('<%=gubun%>', '<%=seq%>')">����</a></li>
														<%End If%>
															<li><a href="javascript:void(0);" onclick="fn_jobpost_del('<%=gubun%>', '<%=seq%>')">����</a></li>
														</ul>
													</div><!-- .box -->
												</div>
											</li>
										</ul><!-- .info2 -->

									</div><!-- .infoBox -->
								</td>
							</tr>
<%
	Next
Else

	If schStartDate="" And schEndDate="" And schKeyword="" Then 
		If hireStat="ing" Then 
			strRslt = "��������"
		ElseIf hireStat="cl" Then  
			strRslt = "������"		
		End If 
	Else 
		strRslt = "�ش� Ű����� �˻���"				
	End If 

	Response.write "<tr><td colspan='2'><div class='none_list'>"&strRslt&" ä����� �����ϴ�.</div></td></tr>"+VBCRLF
End If 
%>
						</tbody>
					</table>
				</div>
				<!-- ����Ʈ // -->

				<%Call putPage(page, stropt, totalPage)%>
</form>
		

			</div>
		</div>
	</div><!-- .content -->

</div>
<!-- //���� -->

<!-- ������� ���� �˾� -->
<form method="post" name="frm_popup" enctype="multipart/form-data">
<input type="hidden" name="companyId" id="companyId" value="<%=comid%>" />
<input type="hidden" name="BizNumber" id="BizNumber" value="<%=BizRegCode%>" />
<input type="hidden" name="BizCreateDate" id="BizCreateDate" value="<%=CreateDate%>" />
<input type="hidden" name="hid_logoUrl" id="hid_logoUrl" value="<%=BizLogoUrl%>" />
<input type="hidden" name="hidLogoDelYn" id="hidLogoDelYn" value="" />
<div class="pop_dim"></div>
<div class="popup">
	<div class="pop_wrap">
		<div class="pop_head">
			<h3>������� ����</h3>
			<a href="javaScript:;" class="layer_close" id="layer_close">&#215;</a>	
		</div>
		<div class="pop_con">
			<div class="pop_tb">
				<table cellpadding="0" cellspacing="0" summary="������� ���� ���̺�">
				<caption>������� ���� ���̺�</caption>
					<colgroup>
						<col style="width:25%;" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">�����</th>
							<td style="text-align: left;"><%=BizName%></td>
						</tr>
						<tr>
							<th scope="row">��ǥ��</th>
							<td><input class="txt" type="text" id="txtBossName" name="txtBossName" maxlength="30" style="ime-mode:active;" value="<%=BossName%>" /></td>
						</tr>
						<!--
						<tr>
							<th scope="row">������</th>
							<td>							
								<input class="txt" type="text" id="txtCreateDate" name="txtCreateDate" maxlength="8" placeholder="��-�� ���� �����ϼ� ��¥ �Է� (yyyymmdd)" onkeyup="removeChar(event)" onkeydown="return onlyNumber(event)" <%If Len(CreateDate)>0 Then%>value="<%=CreateDate%>"<%End If%> />
							</td>
						</tr>
						-->
						<tr>
							<th scope="row">�������</th>
							<td>
								<span class="selectbox" style="width:100%;">
									<span class="">����</span>
									<select id="selBizScale" name="selBizScale">
										<option value="1" <%=Func_SelectBox(BizScale,"1")%>>����</option>
										<option value="3" <%=Func_SelectBox(BizScale,"3")%>>�߰߱��</option>
										<option value="5" <%=Func_SelectBox(BizScale,"5")%>>���ұ��</option>
										<option value="4" <%=Func_SelectBox(BizScale,"4")%>>�߼ұ��</option>										
										<option value="6" <%=Func_SelectBox(BizScale,"6")%>>�Ϲݱ��</option>										
										<option value="2" <%=Func_SelectBox(BizScale,"2")%>>��Ÿ</option>
									</select>
								</span>
							</td>
						</tr>
						<tr>
							<th scope="row">�����</th>
							<td><input class="txt" type="text" id="txtEmpCnt" name="txtEmpCnt" maxlength="8" onkeyup="removeChar(event)" onkeydown="return onlyNumber(event)" value="<%=FormatNumber(Workforce,0)%>" /></td>
						</tr>
						<tr>
							<th scope="row">Ȩ������</th>
							<td>
								<input class="txt" type="text" id="txtHomePage" name="txtHomePage" maxlength="200" style="ime-mode:disabled;" value="<%=BizHomePage%>" />
							</td>
						</tr>
						<tr>
							<th scope="row">�ֿ� �������</th>
							<td><input class="txt" type="text" id="txtBizInfo" name="txtBizInfo" maxlength="100" style="ime-mode:active;" value="<%=GoodsName%>" /></td>
						</tr>
						<tr>
							<th>��� �ΰ�</th>
							<td>
								<div class="filebox"> 
									<label for="file">���� ã��</label> 
									<input type="file" id="file" name="uploadLogoFile"> 

									<input class="upload-name" value="���ε��� ��� �ΰ� ������ ������ �ּ���.">
									<p>
										* �ΰ� Ȯ���ڴ� (jpg, gif, png) ���ϸ� ��� �����մϴ�.<br>
										* �ΰ� �̹����� 205px * 23px ����� �����մϴ�.<br>
										* �ΰ� �̹��� �뷮�� 5MB �̳��� ���ѵ˴ϴ�.  
									</p>
								</div>
								<script>
								$(document).ready(function(){ 
									var fileTarget = $('#file'); 
										fileTarget.on('change', function(){ // ���� ����Ǹ�
									var cur=$(".filebox input[type='file']").val();
										$(".upload-name").val(cur);
									}); 
								}); 
								</script>
							<%If isnull(BizLogoUrl)=False And BizLogoUrl<>"" Then%>
								<div align="left">
									<img src="/files/company/<%=BizLogoUrl%>">
									<input type="checkbox" id="chkLogoDel" name="chkLogoDel" value="Y"><span style="font-size:9pt;vertical-align:16px;padding-left:3px;">���� ��� �ΰ� �̹��� ����</span>
								</div> 
							<%End If%>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		<div class="pop_footer">
			<div class="btn_area">
				<a href="javaScript:void(0);" onclick="fn_sumbit();" class="btn blue">������� ����</a>
				<a id="btn_stop" href="javaScript:void(0);" class="btn gray">���</a>
			</div>
		</div>
	</div>				
</div>
</form>
<!-- //������� ���� �˾� -->


<!-- �ϴ� -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- //�ϴ� -->

</body>
</html>
<script type="text/javascript">
<!--
	// �˾� ���� �� �Է°� �ʱ�ȭ
	$("#layer_close").click(function () {
		location.reload();
	});
//-->
</script>
<%
DisconnectDB DBCon



'========================================================
' �� �μ��� ���� ���ٸ� selected ��ȯ
'========================================================
Function Func_SelectBox(v1, v2)

	If Trim(v1) = Trim(v2) Then 
		Func_SelectBox = "selected"
	Else 
		Func_SelectBox = ""
	End If 

End Function
%>