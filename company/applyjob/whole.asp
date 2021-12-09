<OBJECT RUNAT="SERVER" PROGID="ADODB.RecordSet" ID="Rs"></OBJECT>
<%
'--------------------------------------------------------------------
'   Comment		: 기업회원 > 채용공고 관리
' 	History		: 2020-05-18, 이샛별 
'---------------------------------------------------------------------

'option Explicit

'------ 페이지 기본정보 셋팅.
g_MenuID		= "010001"  ' 앞 두 숫자는 lnb 페이지명, 맨 뒤 숫자는 메뉴 이미지 파일명에 참조
g_MenuID_Navi	= "0,1"		' 내비게이션 값
%>
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/inc/function/paging.asp"-->
<!--#include virtual = "/include/header/header.asp"-->
<%
Call FN_LoginLimit("2")    '기업회원만 접근가능


Dim hireStat : hireStat = Request("hireStat")	' 채용정보 리스트 호출 구분자(total: 전체, ing: 진행, cl: 마감, keep: 장기보관)

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

	' 기업회원 정보 호출
	Dim strSql, BizName, BossName, ZipCode, AddrKor, BizScale, Workforce, BizHomePage, CreateDate, GoodsName, BizRegCode, BizLogoUrl, strBizHomePage, strBizScale, strCreateDate 
    strSql = "SELECT TOP 1 회사명, 대표자성명, 우편번호, 주소, 형태, isnull(사원수, 0), 홈페이지, 설립연도, 주요사업내용, 사업자등록번호, 로고URL " &_
	          "FROM 회사정보 WITH(NOLOCK) "&_
	          "WHERE 회사아이디='"& comid &"'"
	Rs.Open strSql, DBCon, adOpenForwardOnly, adLockReadOnly, adCmdText
	Dim flagRs : flagRs = False 
	If Rs.eof = False And Rs.bof = False Then
		flagRs		= True 
		BizName		= Rs(0)		' 회사명
		BossName	= Rs(1)		' 대표자명
		ZipCode		= Rs(2)		' 우편번호
		AddrKor		= Rs(3)		' 회사주소
		BizScale	= Rs(4)		' 기업형태
		Workforce	= Rs(5)		' 사원수
		BizHomePage	= Rs(6)		' 회사홈페이지
		CreateDate	= Rs(7)		' 회사설립일
		GoodsName	= Rs(8)		' 주요사업내용
		BizRegCode	= Rs(9)		' 사업자번호
		BizLogoUrl	= Rs(10)	' 기업 로고 이미지
	End If	

	' 홈페이지 URL 경로 체크
	If InStr(BizHomePage,"http")>0 Then
		strBizHomePage	= BizHomePage
	Else
		strBizHomePage	= "http://"& BizHomePage
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
		Case "4"
			strBizScale = "중소기업"
		Case "5"
			strBizScale = "강소기업"
		Case "6"
			strBizScale = "일반기업"
		Case Else 
			strBizScale = "확인불가"
	End Select


	If Len(CreateDate)>0 Then 
		strCreateDate = Left(CreateDate,4)&"."&Mid(CreateDate,5,2)&"."&Right(CreateDate,2)
	End If



	' 해당 기업회원이 등록한 채용 정보 카운트 호출(전체, 진행, 마감, 장기보관)
	Dim SpName1, spJobsCnt_Total, spJobsCnt_Ing, spJobsCnt_End, spJobsCnt_Old, SpName2  
	SpName1="USP_BIZSERVICE_JOBS_CNT"
		Dim param(4)
		param(0)=makeParam("@BIZ_ID", adVarChar, adParamInput, 20, comid)
		param(1)=makeParam("@TOTAL_JOBS_CNT", adInteger, adParamOutput, 4, 0)
		param(2)=makeParam("@ING_JOBS_CNT", adInteger, adParamOutput, 4, 0)
		param(3)=makeParam("@END_JOBS_CNT", adInteger, adParamOutput, 4, 0)
		param(4)=makeParam("@OLD_JOBS_CNT", adInteger, adParamOutput, 4, 0)

		Call execSP(DBCon, SpName1, param, "", "")

		spJobsCnt_Total	= getParamOutputValue(param, "@TOTAL_JOBS_CNT")	' 전체
		spJobsCnt_Ing	= getParamOutputValue(param, "@ING_JOBS_CNT")	' 진행
		spJobsCnt_End	= getParamOutputValue(param, "@END_JOBS_CNT")	' 마감
		spJobsCnt_Old	= getParamOutputValue(param, "@OLD_JOBS_CNT")	' 장기보관




	' 해당 기업회원이 등록한 채용 정보 리스트 호출(전체, 진행, 마감)
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
	/*주소검색 시작*/
	function openPostCode() {
		new daum.Postcode({
			oncomplete: function (data) {
				// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

				// 도로명 주소의 노출 규칙에 따라 주소를 조합한다.
				// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
				var fullRoadAddr = data.roadAddress; // 도로명 주소 변수
				var extraRoadAddr = ''; // 도로명 조합형 주소 변수

				// 법정동명이 있을 경우 추가한다. (법정리는 제외)
				// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
				if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
					extraRoadAddr += data.bname;
				}
				// 건물명이 있고, 공동주택일 경우 추가한다.
				if (data.buildingName !== '' && data.apartment === 'Y') {
					extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
				}
				// 도로명, 지번 조합형 주소가 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
				if (extraRoadAddr !== '') {
					extraRoadAddr = ' (' + extraRoadAddr + ')';
				}
				// 도로명, 지번 주소의 유무에 따라 해당 조합형 주소를 추가한다.
				if (fullRoadAddr !== '') {
					fullRoadAddr += extraRoadAddr;
				}

				// 우편번호와 주소 정보를 해당 필드에 넣는다.
				document.getElementById('hidZipCode').value		= data.zonecode; //5자리 신주소 우편번호
				document.getElementById('txtCompAddr').value	= fullRoadAddr;
				$("#htmTdCompAddrArea").html("기존 주소");
				$("#CompAddrEdit").html(fullRoadAddr);
				$("#CompAddrEditArea").show();
			}
		}).open({popupName: 'postcodePopup'});
	}
	/*주소검색 끝*/

	// 기업정보 주소 변경 값 유효성 체크
	function fn_sumbit_Addr(){
		var txtCompAddrDetail = $("#txtCompAddrDetail").val();

		if(txtCompAddrDetail=="회사 상세주소"){
			txtCompAddrDetail="";
		}

		if(txtCompAddrDetail==""){
			alert("회사 상세주소 정보를 입력해 주세요.");
			$("#txtCompAddrDetail").focus();
			return;
		}
		
		var obj=document.frm_addr;
		if(confirm('입력하신 내용으로 회사 주소를 변경 하시겠습니까?')) {
			obj.method			= "post";
			obj.EditType.value	= "addr";
			obj.action = "company_addr_proc.asp";
			obj.submit();
		}
	}

	// 기업정보 변경 입력 값 유효성 체크
	function fn_sumbit(){
		var txtBossName		= $("#txtBossName").val();	
		//var txtCreateDate	= $("#txtCreateDate").val();
		var txtEmpCnt		= $("#txtEmpCnt").val();
		var txtHomePage		= $("#txtHomePage").val();
		var txtBizInfo		= $("#txtBizInfo").val();

		var chkVal			= $("#chkLogoDel").is(":checked");	// 기업 로고 삭제 여부
		if (chkVal == false){
			$("#hidLogoDelYn").val("N");
		}else{
			$("#hidLogoDelYn").val("Y");
		}	

		if(txtBossName==""){
			alert("대표자명을 입력해 주세요.");
			$("#txtBossName").focus();
			return;
		}
		
		/*
		if(txtCreateDate=="“-” 생략 연월일순 날짜 입력 (yyyymmdd)"){
			txtCreateDate="";
		}

		if(txtCreateDate==""){
			alert("설립일을 입력해 주세요.");
			$("#txtCreateDate").focus();
			return;
		}else{
			//문자가 날짜형이 맞는지 체크
			if (txtCreateDate.length<8){
				alert("정확한 날짜를 입력해 주세요.\n(ex: 창립일자 = 2002년 1월 3일 → 20020103)");
				return false;
			}

			var rxDatePattern	= /^(\d{4})(\d{1,2})(\d{1,2})$/;		// Declare Regex                  
			var dtArray			= txtCreateDate.match(rxDatePattern);	// is format OK?

			//Checks for yyyymmdd format.
			dtYear	= dtArray[1];
			dtMonth = dtArray[2];
			dtDay	= dtArray[3];

			var today = new Date();
			var year  = today.getFullYear(); // 현재연도
			var month = today.getMonth()+1;  // 현재월

			if (dtYear < 1900 || dtYear > year){
				alert("설립연도가 유효하지 않습니다.\n(1900~"+year+"년도 사이의 숫자만 입력 가능)");
				return false;
			}
			
			if (dtYear == year && dtMonth > month){
				alert("현재일자보다 미래의 날짜로 설립일자가 입력되었습니다.\n다시 확인해 주세요.");
				return false;
			}
		
			if (dtMonth < 1 || dtMonth > 12){
				alert("설립월이 유효하지 않습니다.");
				return false;
			}

			if (dtDay < 1 || dtDay > 31){
				alert("설립일이 유효하지 않습니다.");
				return false;
			}
			
			if (dtMonth == 2) {
				var isleap = (dtYear % 4 == 0 && (dtYear % 100 != 0 || dtYear % 400 == 0));
				if (dtDay > 29 || (dtDay == 29 && !isleap)){
					alert(dtYear+"년 2월의 마지막 날짜는 28일 입니다.");
					return false;
				}
			}

		}
		*/

		if(txtEmpCnt==""){
			alert("사원수를 입력해 주세요.");
			$("#txtEmpCnt").focus();
			return;
		}

		if(txtHomePage==""){
			alert("홈페이지 주소를 입력해 주세요.");
			$("#txtHomePage").focus();
			return;
		}

		if(txtBizInfo=="") {
			alert('주요 사업내용을 입력해 주세요.');
			$("#txtBizInfo").focus();
			return;
		}

		var obj=document.frm_popup;
		if(confirm('입력하신 내용으로 기업정보를 변경 하시겠습니까?')) {
			obj.method = "post";
			obj.action = "company_info_proc.asp";
			obj.submit();
		}

	}

	// 기업정보 팝업 종료
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

			/*if(txtCreateDate == "“-” 생략 연월일순 날짜 입력 (yyyymmdd)"){
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
				if(confirm('기업정보 항목 중 수정된 내용이 있습니다.\n입력한 내용을 취소 하시겠습니까?')) {
					alert("취소되었습니다.");	
					location.reload();
				}
			}else{
				$('.popup, .pop_dim').hide();
			}

		});
	});

	// 상태별 채용정보 조회
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

	// 1개월, 3개월, 6개월 기간 버튼
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
				
		// 종료일은 시작일 이전 날짜 선택하지 못하도록 비활성화
		$("#schEndDate").datepicker("option", "minDate", startDate);
		
		// 시작일은 종료일 이후 날짜 선택하지 못하도록 비활성화
		$("#schStartDate").datepicker("option", "maxDate", endDate);
	}*/	

	// 날짜 검색
    function fn_search() {
        if ($("#schStartDate").val() != "" || $("#schEndDate").val()) {
            if ($("#schStartDate").val() == "") {
                alert("시작일을 선택해 주세요.");
				$("#schStartDate").focus();
                return false;
            }

            if ($("#schEndDate").val() == "") {
                alert("종료일을 선택해 주세요.");
				$("#schEndDate").focus();
                return false;
            }

            if ($("#schStartDate").val().replace("-", "") > $("#schEndDate").val().replace("-", "")) {
                alert("시작일이 종료일보다 이전 날짜로 지정되었습니다.\n다시 선택해 주세요.");
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

	// 검색 초기화
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

	//채용정보 수정/복사
    function fn_jobpost_modify(mode, jid) {
        var url = "<%=g_members_wk%>/biz/jobpost/jobpost_modify_fair?jid=" + jid + "&mode=" + mode + "&site_code=<%=site_code%>";
        location.href = url;
    }

	//채용정보 마감
    function fn_jobpost_end(mode, jid) {
        if (mode != "ing") {
            alert("마감할 수 없는 상태의 채용공고 입니다.");
            return;
        }
        if (!confirm("해당 공고를 마감하시겠습니까?")) {
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
                    alert("해당 공고의 마감이 완료되었습니다.");
                    location.reload();
                } else {
                    alert("서버 데이터 오류: 관리자에게 문의하세요. code=" + data);
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

    //채용정보 삭제
    function fn_jobpost_del(mode, jid) {
        if (!confirm("해당 공고를 삭제하시겠습니까?")) {
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
                    alert("공고 삭제 실패: 관리자에게 문의하세요.");
                    return false;
                } else if (data == "1") {
                    alert("해당 공고의 삭제가 완료되었습니다.");
                    location.reload();
                } else {
                    alert("서버 데이터 오류: 관리자에게 문의하세요. code=" + data);
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

<!-- 상단 -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->
<!-- //상단 -->


<!-- 본문 -->
<div id="contents" class="sub_page">

	<div class="content glay">
		<div class="con_area">
			<div class="jobs_area">

				<a class="btn_modi pop" href="javascript:void(0);">기업정보 수정</a>

				<div class="tlt_wrap">
					<h3>기업정보</h3>
				</div>
				<div class="table_row_type1" style="margin-top:17px;">

				<form method="post" name="frm_addr">
				<input type="hidden" name="EditType" id="EditType" value="" />
				<input type="hidden" name="compId" id="compId" value="<%=comid%>" />
				<input type="hidden" name="BizNum" id="BizNum" value="<%=BizRegCode%>" />
					<table cellpadding="0" cellspacing="0" summary="기업정보 테이블">
						<caption>기업정보 테이블</caption>
						<colgroup>
							<col style="width:15%;" />
							<col style="width:35%;" />
							<col style="width:15%;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">기업명</th>
								<td><%=BizName%></td>
								<th scope="row">대표자</th>
								<td><%=BossName%></td>
							</tr>
							<tr>
								<!--
								<th scope="row">설립일</th>
								<td><%If Len(CreateDate)>0 Then%><%=strCreateDate%><%Else Response.write "-" End If%></td>
								-->
								<th scope="row">사원수</th>
								<td><%=FormatNumber(Workforce,0)%> 명</td>
								<th scope="row">기업형태</th>
								<td><%=strBizScale%></td>
							</tr>
							<tr>								
								<th scope="row">홈페이지</th>
								<td>
								<%If Len(BizHomePage)>0 Then%>
									<a class="link" href="<%=strBizHomePage%>" target="_blank" title="새창으로 열림"><%=strBizHomePage%></a>
								<%Else Response.write "-" End If%>
								</td>
								<th scope="row">기업로고</th>
								<td>
								<%If isnull(BizLogoUrl)=False And BizLogoUrl<>"" Then%>
									<img src="/files/company/<%=BizLogoUrl%>">
								<%End If%>
								</td>
							</tr>
							<tr>
								<th scope="row" id="htmTdCompAddrArea">주소</th>
								<td colspan="3" class="address">
									<a class="btn_address" onclick="openPostCode(); return false;" style="cursor:pointer">주소 검색</a>
									<span><%=AddrKor%></span> 
								</td>
							</tr>
							<tr id="CompAddrEditArea" style="display:none;height:100px;">
								<th scope="row" style="color:#ff3366;">변경 주소</th>
								<td colspan="3" class="address">
									<a class="btn_address moti" onclick="fn_sumbit_Addr(); return false;" style="cursor:pointer;">주소 수정</a>
									<input type="hidden" id="hidZipCode" name="hidZipCode" value="" />	
									<input type="hidden" id="txtCompAddr" name="txtCompAddr" value="" />
									<span id="CompAddrEdit"></span> 																
									<div class="address_detail">
										<input type="text" id="txtCompAddrDetail" name="txtCompAddrDetail" maxlength="100" style="ime-mode:active;" placeholder="회사 상세주소">
										<a id="layer_close" class="moti_cansel" style="cursor:pointer">[ X ]</a>
									</div>									
								</td>
							</tr>
							<tr>
								<th scope="row">주요 사업내용</th>
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
					<table cellpadding="0" cellspacing="0" summary="기업정보 테이블">
						<caption></caption>
						<colgroup>
							<col style="width:33%;">
							<col style="width:33%;">
							<col style="width:33%;">
							<!-- <col /> -->
						</colgroup>
						<thead>
							<tr>
								<th scope="col">전체 채용정보</th>
								<th scope="col">진행중</th>
								<th scope="col">채용마감</th>
								<!-- <th scope="col">장기보관</th> -->
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
						<li>- 채용공고 게재기간은 접수시작일로부터 최대 90일까지 입니다.</li>
						<!-- <li>- 동시 게재는 최대 10개 까지만 가능합니다.</li> -->
						<li>- 마감된 채용공고는 게재종료 후 90일간 마감 리스트에서 확인 가능합니다.   <!-- (1년간 장기보관을 원하시면 ‘보관’ 버튼 클릭!) --></li>
						<li>- 지원자는 입사지원일로부터 90일간<!-- , 스크랩한 인재는 스크랩일로부터 90일간 --> 확인 가능합니다.</li>
					</ul>
					<div class="btn_wrap">
						<a class="btn_regi" href="<%=g_members_wk%>/biz/jobpost/step_fair?site_code=<%=site_code%>&site_gubun=E"><span>채용공고 등록하기</span></a>
					</div>
				</div>

				<div class="step_area">
					<ul>
						<li>01. 지원서류 검토 : 지원자의 이력서를 검토 후 서류합격/불합격 유무를 결정합니다.</li>
						<li>02. 서류합격 : 지원자 목록의 심사상태를 서류합격으로 변경해 주어야만 서류 합격상태가 됩니다.</li>
						<li>03. 면접배정 : 화상면접 시간 배정은 서류합격자를 대상으로만 가능하고, 일시는 인사담당자님이 정할 수 있습니다.</li>
						<li>04. 배정완료 : 배정이 완료되면, 면접방이 자동으로 생성되고 자동으로 생성됩니다.</li>
						<li>05. 정보수정 : 면접배정 정보는 “면접자 배정수정＂버튼 클릭 시 일정수정이 가능합니다. (단, 알림 문자를 구직자에게 발송 시 수정 불가)</li>
					</ul>
				</div>

<%
Dim strHireType, strHireTypeDetail
Select Case hireStat
	Case "total" :
		strHireType			= "전체"
		strHireTypeDetail	= "전체"
	Case "ing" :
		strHireType			= "진행중"
		strHireTypeDetail	= "진행중인"
	Case "cl" :
		strHireType			= "마감"
		strHireTypeDetail	= "마감된"
	Case "keep" :
		strHireType			= "장기보관"
		strHireTypeDetail	= "장기간 보관중인"
End Select 
%>
			<a name="hirelist">
				<div class="tlt_wrap">
					<h3 id="txt"><%=strHireType%> 채용정보</h3>
					<span class="list_number"><span class="number"><%=FormatNumber(totalCount,0)%></span>건의 <%=strHireTypeDetail%> 채용정보가 있습니다.</span>
				</div>
			</a>

				<!-- // 검색창 -->
				<div class="searchArea">
						<div class="searchInner">
							<div class="fl">
								<dl>
									<dt class="blind">조회기간 설정 :</dt>
									<dd>
										<!-- <ul class="monthSort">
											<li><button type="button" class="round" name="dateType" id="dateType1" onclick="setSearchDate('1m')">1개월</button></li>
											<li><button type="button" class="round" name="dateType" id="dateType2" onclick="setSearchDate('3m')">3개월</button></li>
											<li><button type="button" class="round" name="dateType" id="dateType3" onclick="setSearchDate('6m')">6개월</button></li>
										</ul> --><!-- .monthSort -->
										<div class="datePick">
											<span>
												<input id="schStartDate" name="schStartDate" class="datepicker inpType" type="text" title="검색 시작일 선택" onclick="useDatePicker('#schStartDate');" value="<%=schStartDate%>" readOnly>
												<button type="button" class="btncalendar dateclick" onclick="useDatePicker('#schStartDate');">날짜선택</button>
											</span>
											<span class="hyphen">~</span>
											<span>
												<input id="schEndDate" name="schEndDate" class="datepicker inpType" type="text" title="검색 종료일 선택" onclick="useDatePicker('#schEndDate');" value="<%=schEndDate%>" readOnly>
												<button type="button" class="btncalendar dateclick" onclick="useDatePicker('#schEndDate');">날짜선택</button>
											</span>
											<button type="button" class="btn reset" onclick="dateReset();">초기화</button>
										</div><!--.datePick-->
									</dd>
								</dl>
							</div><!--.fl-->

							<div class="fr">
								<div class="searchBox">
									<!-- <span class="selectbox" style="width:165px">
										<span>담당자별</span>
										<select id="schManager" name="schManager" title="담당자별 선택" selected="selected">
											<option value="">담당자별</option>
											<option value="채용담당자">채용담당자</option>
										</select>
									</span> --><!-- .selectbox -->

									<div>
										<input class="txt" id="schKeyword" name="schKeyword" type="text" placeholder="채용공고 제목, 업종ㆍ직종 키워드 입력" value="<%=schKeyword%>" style="width:377px;">
										<button type="button" class="btn typegray" onclick="fn_search();"><strong>검색</strong></button>
										<!-- <button type="button" class="btn typegray" onclick="fn_reset();"><strong>초기화</strong></button> -->
									</div>
								</div><!-- .searchBox -->
							</div><!--.fr-->

						</div><!--.searchInner-->
					</form>
				</div>
				<!-- 검색창 // -->

				<!-- // 리스트 -->
				<div class="boardArea">
					<table class="tbX" cellpadding="0" cellspacing="0" summary="채용정보에 관한 항목을 나타낸 표">
						<caption>채용정보 목록</caption>
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
		gubun			= Trim(arrList(0,i))	' 채용공고 상태 구분자(ing : 진행, cl: 마감)
		seq				= Trim(arrList(1,i))	' 등록번호	
		title			= Trim(arrList(2,i))	' 채용공고 제목
		regDate			= Trim(arrList(3,i))	' 등록일자
		modDate			= Trim(arrList(4,i))	' 수정일자
		closeDate		= Trim(arrList(5,i))	' 접수마감일자	
		closeType		= Trim(arrList(6,i))	' 접수마감종류	
		hitCnt			= Trim(arrList(7,i))	' 조회수
		applyCnt_online	= Trim(arrList(8,i))	' 온라인 입사지원 수
		regdate2		= Trim(arrList(9,i))	' 최초등록일(연월일)
		regType			= Trim(arrList(10,i))	' 등록유형
		reportNum		= Trim(arrList(11,i))	' 보고서채용등록번호
		applyCnt_today	= Trim(arrList(12,i))	' 오늘 입사지원 수
		rcpProcess		= Trim(arrList(13,i))	' 접수방법				
		delDate			= Trim(arrList(14,i))	' 삭제예정일
		contLen			= Trim(arrList(15,i))	' 업무내용길이
		ocpCode			= Trim(arrList(16,i))	' 직종코드
		managerNm		= Trim(arrList(17,i))	' 담당자명
		unreadCnt		= Trim(arrList(18,i))	' 미열람수
		keepStat		= Trim(arrList(19,i))	' 보관여부
		deadline		= Trim(arrList(20,i))	' 강제마감일자

		
		Select Case closeType
			Case "1" :
				If IsNull(closeDate) Then 
					strCloseDt = FormatDateTime(deadline, 2)
				Else 
					strCloseDt = FormatDateTime(closeDate, 2)
				End If 
			Case "2" : 
				strCloseDt = "채용 시 마감"
			Case "3" :
				strCloseDt = "상시채용"
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

		'0:TOTAL_CNT(전체입사지원개수)
		'1:TODAY_CNT(오늘입사지원수)
		'2:NOT_OPEN_CNT(미열람수)
		'3:ONLINE_CNT(온라인입사지원수)
		'4:EMAIL_CNT(이메일입사지원수)
		'5:CAREER_CNT(커리어양식입사지원수)
		'6:FREE_CNT(자유양식입사지원수)
		'7:COMPANY_CNT(자사양식입사지원수)
		'8:BEFORE_CNT(심사전)
		'9:ING_CNT(심사중)
		'10:PAPERS_CNT(서류합격)
		'11:FINAL_CNT(최종합격)
		'12:FAILURE_CNT(불합격)
		'13:FILLTER_CNT(필터링)
%>
							<tr>
								<td class="t1">
									<div class="txtBox">
										<div class="tit">
											<a href="/jobs/view.asp?id_num=<%=seq%>" target="_blank"><strong><%=title%></strong></a>
										</div><!-- .tit -->
										<div>
											<dl>
												<dt>게재기간 :</dt>
												<dd><span class="num"><%=FormatDateTime(regDate, 2)%> ~ <%=strCloseDt%></span></dd>
												<dt>담당자 :</dt>
												<dd><%=managerNm%></dd>
											</dl>
										</div>
												
										<div class="noti">
									<%If gubun="ing" Then%>	
											<span class="fc_blu09">→ 채용중</span>
									<%Else%>		
											<span class="fc_ora06">→ 채용마감</span>
									<%End If%>
										</div><!-- .noti -->

									</div><!-- .txtBox -->
								</td>
								<td class="t2">
									<div class="infoBox hire">
										<ul class="info1">
											<li>
												<dl>
													<dt>전체 지원자</dt>
													<dd><a href="javascript:void(0);" onclick="goApply('<%=gubun%>', '<%=seq%>', '0');"><strong class="num fc_gra3"><%=total_cnt%></strong></a></dd>
												</dl>
											</li>
											<li>
												<dl>
													<dt>미열람</dt>
													<dd><a href="javascript:void(0);" onclick="goApply('<%=gubun%>', '<%=seq%>', '1');"><strong class="num fc_ora04"><%=not_open_cnt%></strong></a></dd>
												</dl>
											</li>
											<li>
												<dl>
													<dt>심사중</dt>
													<dd><a href="javascript:void(0);" onclick="goApply('<%=gubun%>', '<%=seq%>', '2');"><strong class="num fc_blu09"><%=ING_CNT%></strong></a></dd>
												</dl>
											</li>
											<li>
												<dl>
													<dt>서류합격</dt>
													<dd><a href="javascript:void(0);" onclick="goApply('<%=gubun%>', '<%=seq%>', '3');"><strong class="num"><%=PAPERS_CNT%></strong></a></dd>
												</dl>
											</li>
											<li>
												<dl>
													<dt>불합격</dt>
													<dd><a href="javascript:void(0);" onclick="goApply('<%=gubun%>', '<%=seq%>', '5');""><strong class="num"><%=FAILURE_CNT%></strong></a></dd>
												</dl>
											</li>
										</ul><!-- .info1 -->

										<ul class="info2">
											<!--
											<li>
												<a href="javascript:void(0);" onclick="alert('준비 중 입니다.');">지원자 통계</a>
											</li>
											-->
											<li>
												<a href="javascript:void(0);" class="toggle">공고관리</a><!-- [D] 클릭시 툴팁박스 생성 -->
												<div class="tooltipArea">
													<div class="box">
														<ul>
															<li><a href="/jobs/view.asp?id_num=<%=seq%>" target="_blank">보기</a></li>
														<%If gubun = "ing" Then%>
															<li><a href="javascript:void(0);" onclick="fn_jobpost_modify('EDIT', '<%=seq%>')">수정</a></li>
														<%End If%>
															<li><a href="javascript:void(0);" onclick="fn_jobpost_modify('LOAD', '<%=seq%>')">복사</a></li>
														<%If gubun = "ing" Then%>
															<li><a href="javascript:void(0);" onclick="fn_jobpost_end('<%=gubun%>', '<%=seq%>')">마감</a></li>
														<%End If%>
															<li><a href="javascript:void(0);" onclick="fn_jobpost_del('<%=gubun%>', '<%=seq%>')">삭제</a></li>
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
			strRslt = "진행중인"
		ElseIf hireStat="cl" Then  
			strRslt = "마감된"		
		End If 
	Else 
		strRslt = "해당 키워드로 검색된"				
	End If 

	Response.write "<tr><td colspan='2'><div class='none_list'>"&strRslt&" 채용공고가 없습니다.</div></td></tr>"+VBCRLF
End If 
%>
						</tbody>
					</table>
				</div>
				<!-- 리스트 // -->

				<%Call putPage(page, stropt, totalPage)%>
</form>
		

			</div>
		</div>
	</div><!-- .content -->

</div>
<!-- //본문 -->

<!-- 기업정보 수정 팝업 -->
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
			<h3>기업정보 수정</h3>
			<a href="javaScript:;" class="layer_close" id="layer_close">&#215;</a>	
		</div>
		<div class="pop_con">
			<div class="pop_tb">
				<table cellpadding="0" cellspacing="0" summary="기업정보 수정 테이블">
				<caption>기업정보 수정 테이블</caption>
					<colgroup>
						<col style="width:25%;" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">기업명</th>
							<td style="text-align: left;"><%=BizName%></td>
						</tr>
						<tr>
							<th scope="row">대표자</th>
							<td><input class="txt" type="text" id="txtBossName" name="txtBossName" maxlength="30" style="ime-mode:active;" value="<%=BossName%>" /></td>
						</tr>
						<!--
						<tr>
							<th scope="row">설립일</th>
							<td>							
								<input class="txt" type="text" id="txtCreateDate" name="txtCreateDate" maxlength="8" placeholder="“-” 생략 연월일순 날짜 입력 (yyyymmdd)" onkeyup="removeChar(event)" onkeydown="return onlyNumber(event)" <%If Len(CreateDate)>0 Then%>value="<%=CreateDate%>"<%End If%> />
							</td>
						</tr>
						-->
						<tr>
							<th scope="row">기업형태</th>
							<td>
								<span class="selectbox" style="width:100%;">
									<span class="">선택</span>
									<select id="selBizScale" name="selBizScale">
										<option value="1" <%=Func_SelectBox(BizScale,"1")%>>대기업</option>
										<option value="3" <%=Func_SelectBox(BizScale,"3")%>>중견기업</option>
										<option value="5" <%=Func_SelectBox(BizScale,"5")%>>강소기업</option>
										<option value="4" <%=Func_SelectBox(BizScale,"4")%>>중소기업</option>										
										<option value="6" <%=Func_SelectBox(BizScale,"6")%>>일반기업</option>										
										<option value="2" <%=Func_SelectBox(BizScale,"2")%>>기타</option>
									</select>
								</span>
							</td>
						</tr>
						<tr>
							<th scope="row">사원수</th>
							<td><input class="txt" type="text" id="txtEmpCnt" name="txtEmpCnt" maxlength="8" onkeyup="removeChar(event)" onkeydown="return onlyNumber(event)" value="<%=FormatNumber(Workforce,0)%>" /></td>
						</tr>
						<tr>
							<th scope="row">홈페이지</th>
							<td>
								<input class="txt" type="text" id="txtHomePage" name="txtHomePage" maxlength="200" style="ime-mode:disabled;" value="<%=BizHomePage%>" />
							</td>
						</tr>
						<tr>
							<th scope="row">주요 사업내용</th>
							<td><input class="txt" type="text" id="txtBizInfo" name="txtBizInfo" maxlength="100" style="ime-mode:active;" value="<%=GoodsName%>" /></td>
						</tr>
						<tr>
							<th>기업 로고</th>
							<td>
								<div class="filebox"> 
									<label for="file">파일 찾기</label> 
									<input type="file" id="file" name="uploadLogoFile"> 

									<input class="upload-name" value="업로드할 기업 로고 파일을 선택해 주세요.">
									<p>
										* 로고 확장자는 (jpg, gif, png) 파일만 등록 가능합니다.<br>
										* 로고 이미지는 205px * 23px 사이즈를 권장합니다.<br>
										* 로고 이미지 용량은 5MB 이내로 제한됩니다.  
									</p>
								</div>
								<script>
								$(document).ready(function(){ 
									var fileTarget = $('#file'); 
										fileTarget.on('change', function(){ // 값이 변경되면
									var cur=$(".filebox input[type='file']").val();
										$(".upload-name").val(cur);
									}); 
								}); 
								</script>
							<%If isnull(BizLogoUrl)=False And BizLogoUrl<>"" Then%>
								<div align="left">
									<img src="/files/company/<%=BizLogoUrl%>">
									<input type="checkbox" id="chkLogoDel" name="chkLogoDel" value="Y"><span style="font-size:9pt;vertical-align:16px;padding-left:3px;">기존 기업 로고 이미지 삭제</span>
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
				<a href="javaScript:void(0);" onclick="fn_sumbit();" class="btn blue">기업정보 수정</a>
				<a id="btn_stop" href="javaScript:void(0);" class="btn gray">취소</a>
			</div>
		</div>
	</div>				
</div>
</form>
<!-- //기업정보 수정 팝업 -->


<!-- 하단 -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- //하단 -->

</body>
</html>
<script type="text/javascript">
<!--
	// 팝업 종료 시 입력값 초기화
	$("#layer_close").click(function () {
		location.reload();
	});
//-->
</script>
<%
DisconnectDB DBCon



'========================================================
' 두 인수의 값이 같다면 selected 반환
'========================================================
Function Func_SelectBox(v1, v2)

	If Trim(v1) = Trim(v2) Then 
		Func_SelectBox = "selected"
	Else 
		Func_SelectBox = ""
	End If 

End Function
%>