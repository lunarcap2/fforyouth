<%
option Explicit

'------ 페이지 기본정보 셋팅.
g_MenuID = "010001"  '앞 두 숫자는 lnb 페이지명, 맨 뒤 숫자는 메뉴 이미지 파일명에 참조
g_MenuID_Navi = "0,1"  '내비게이션 값
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header.asp"-->

<%
Call FN_LoginLimit("1")    '개인회원만 접근가능
'ex)FN_LoginLimit("012")	<-- 비회원/개인회원/기업회원 허용

Dim stp     : stp = 1					'이력서 단계
Dim rid     : rid = request("rid")		'이력서 등록번호 (rid가 있으며 수정)
Dim rtype   : rtype = "T"				'이력서 구분(T:중간저장, C:완료)
Dim cflag   : cflag = request("cflag")	'신입/경력 구분. 1/8 로 현재값과 동일
Dim isBaseResume						'기본이력서
Dim isOpenResume						'이력서공개여부
Dim set_user_id '다른 사용자의 이력서를 보기위한 사용자아이디(뷰에서만 사용)
Dim apply_resume '입사지원 이력서 조회여부(기업회원 지원자관리 사용)
%>
<!--#include virtual = "/wwwconf/code/code_function.asp"-->
<!--#include virtual = "/wwwconf/code/code_function_ac.asp"-->
<!--#include virtual = "/wwwconf/code/code_function_jc.asp"-->
<!--#include virtual = "/wwwconf/code/code_function_resume.asp"-->
<!--#include virtual = "/wwwconf/code/code_resume.asp"-->

<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/wwwconf/query_lib/user/ResumeInfo.asp"-->
<!--#include virtual = "/my/resume/comm/getResumeStepDBInfo.asp"-->
<%
	Dim i, ii, seq

	'--작성중인 이력서 rid
	Dim ing_rid : ing_rid = 0
	Dim ing_rGubun
	If IsArray(arrIngResume) Then
		ing_rid = arrIngResume(0,0)
		ing_rGubun = arrIngResume(1,0)
	end If

	'--이력서 신규등록 시 : 3개이상 등록 제한 > 10개로 변경
	If rid = 0  Then
		If IsArray(arrIngResume) Then
			If iResumeCnt >= 10 And ing_rid = 0 Then
				ShowAlertMsg "이력서는 10개까지 등록이 가능합니다.", "location.replace('/my/resume_list.asp');", True
			ElseIf iResumeCnt >= 10 And ing_rid > 0 Then
				ShowAlertMsg "", "if(confirm('작성중인 이력서가 있습니다. 계속 작성하시겠습니까?')){location.replace('/my/resume/resume_regist.asp?rid="& ing_rid & "');}else{location.replace('/my/resume_list.asp');}", True
			ElseIf iResumeCnt < 10 And ing_rid > 0 Then
				ShowAlertMsg "", "if(confirm('작성중인 이력서가 있습니다. 계속 작성하시겠습니까?')){location.replace('/my/resume/resume_regist.asp?rid="& ing_rid &"');}else{location.replace('/my/resume_list.asp');}", True
			End If
		else
			If iResumeCnt >= 10 And ing_rid = 0 Then
				ShowAlertMsg "이력서는 10개까지 등록이 가능합니다.", "location.replace('/my/resume_list.asp');", True
			ElseIf iResumeCnt >= 10 And ing_rid > 0 Then
				ShowAlertMsg "", "if(confirm('작성중인 이력서가 있습니다. 계속 작성하시겠습니까?')){location.replace('"& mydir &"/resume/resume_regist.asp?rid="& ing_rid & "');}else{location.replace('"& mydir &"');}", True
			ElseIf iResumeCnt < 10 And ing_rid > 0 Then
				ShowAlertMsg "", "if(confirm('작성중인 이력서가 있습니다. 계속 작성하시겠습니까?')){location.replace('"& mydir &"/resume/resume_regist.asp?rid="& ing_rid &"');}else{location.replace('"& mydir &"/resume/resume_reg_step1.asp?flag=1&cflag=" & cflag & "');}", True
			End If
		end if
	End If

	'-- 기본이력서 값설정
	If iResumeCnt = "0" Then isBaseResume = "1"
	If rid <> 0 And IsArray(arrResume) Then isBaseResume = arrResume(1, 0) : isOpenResume = arrResume(50, 0)

%>

<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
<script type="text/javascript" src="/js/resume_renew.js"></script>

<script type="text/javascript">
	$(document).ready(function () {
		var arrBase = '<%=isArray(arrBase)%>';
		//이력서 등록시
		if ($("#rid").val() == "0" && arrBase == "False") {

			$("#resume4").hide();
			$("#rnb_toggle4").addClass("off");

			$("#resume5").hide();
			$("#rnb_toggle5").addClass("off");

			$("#resume6").hide();
			$("#rnb_toggle6").addClass("off");

			$("#resume7").hide();
			$("#rnb_toggle7").addClass("off");

			$("#resume8").hide();
			$("#rnb_toggle8").addClass("off");

			$("#resume9").hide();
			$("#rnb_toggle9").addClass("off");

			$("#resume10").hide();
			$("#rnb_toggle10").addClass("off");

			$("#resume11").hide();
			$("#rnb_toggle11").addClass("off");

			//$("#resume13").hide();
			//$("#rnb_toggle13").addClass("off");
		} else {
			var arrActivity =		'<%=isArray(arrActivity)%>';
			var arrLanguageUse =	'<%=isArray(arrLanguageUse)%>';
			var arrLanguageExam	=	'<%=isArray(arrLanguageExam)%>';
			var arrLicense =		'<%=isArray(arrLicense)%>';
			var arrPrize =			'<%=isArray(arrPrize)%>';
			var arrAcademy =		'<%=isArray(arrAcademy)%>';
			var arrAbroad =			'<%=isArray(arrAbroad)%>';
			var arrPersonal =		'<%=isArray(arrPersonal)%>';
			var arrMilitary =		'<%=isArray(arrMilitary)%>';
			var arrEmpSupport =		'<%=isArray(arrEmpSupport)%>';
			var arrPortfolio =		'<%=isArray(arrPortfolio)%>';
			var arrEssay =			'<%=isArray(arrEssay)%>';


			if (arrActivity == "False") {
				$("#resume4").hide();
				$("#rnb_toggle4").addClass("off");
			}

			if (arrLanguageUse == "False" && arrLanguageExam == "False") {
				$("#resume5").hide();
				$("#rnb_toggle5").addClass("off");
			}

			if (arrLicense == "False") {
				$("#resume6").hide();
				$("#rnb_toggle6").addClass("off");
			}

			if (arrPrize == "False") {
				$("#resume7").hide();
				$("#rnb_toggle7").addClass("off");
			}

			if (arrAcademy == "False") {
				$("#resume8").hide();
				$("#rnb_toggle8").addClass("off");
			}

			if (arrAbroad == "False") {
				$("#resume9").hide();
				$("#rnb_toggle9").addClass("off");
			}

			if (arrPersonal == "False" && arrMilitary == "False" && arrEmpSupport == "False") {
				$("#resume10").hide();
				$("#rnb_toggle10").addClass("off");
			}

			if (arrPortfolio == "False") {
				$("#resume11").hide();
				$("#rnb_toggle11").addClass("off");
			}

			/*
			if (arrEssay == "False") {
				$("#resume13").hide();
				$("#rnb_toggle13").addClass("off");
			}
			*/
		}

	});
</script>

</head>

<body id="info">
<!-- 상단 -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->

<!-- 본문 -->
<div id="contents" class="sub_page resume">

	<!-- 이력서 항목 Rnb -->
	<div class="rnb_wrap" id="quick">
		<div class="rnb">
			<div class="rnb_box">
				<div class="rnb_con resume">
					<h5>이력서 항목</h5>
					<ul class="rr_ul">
						<li><span class="button reqir" type="button">프로필</span></li>
						<li><span class="button reqir" type="button">학력</span></li>
						<li><span class="button reqir" type="button">경력</span></li>
						<li class="rnb_toggle"><button type="button" id="rnb_toggle4">인턴. 대외활동</button></li>
						<li class="rnb_toggle"><button type="button" id="rnb_toggle5">외국어</button></li>
						<li class="rnb_toggle"><button type="button" id="rnb_toggle6">자격증</button></li>
						<li class="rnb_toggle"><button type="button" id="rnb_toggle7">수상</button></li>
						<li class="rnb_toggle"><button type="button" id="rnb_toggle8">교육</button></li>
						<li class="rnb_toggle"><button type="button" id="rnb_toggle9">해외경험</button></li>
						<li class="rnb_toggle"><button type="button" id="rnb_toggle10">취업우대항목</button></li>
						<li class="rnb_toggle"><button type="button" id="rnb_toggle11">포트폴리오</button></li>
						<li><span class="button reqir" type="button">희망근무조건</span></li>
						<li><span class="button reqir" type="button">자기소개서</span></li>
					</ul>
					<div class="btn_area ruseme">
						<button type="button" onclick="fn_resume_save_preview();">미리보기</button>
						<button type="button" onclick="fn_resume_save_imsi();">임시저장</button>
						<button type="button" onclick="fn_resume_save();">이력서 저장</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- //이력서 항목 Rnb -->

	<div class="content glay">
		<div class="con_area">

			<!-- ☆ 이력서 등록 참고용 버튼 추가:S -->
			<!--
			<script>
				$(document).ready(function(){
					$('.fnDialogResumeInfoButton').click(function(){ //이력서 충실도 팝업
						$('[data-layerpop="dialogResumeInfo"]').cmmLocLaypop({
							parentAddClass: 'tp3 dialogResumeInfo',
							title: '이력서 충실도',
							useBottomArea:false,
							width: 660
						});
					});
					// $('.fnDialogResumeSampButton').click(function(){ //이력서 작성 샘플 팝업
					// 	$('[data-layerpop="dialogResumeSamp"]').cmmLocLaypop({
					// 		parentAddClass: 'tp3',
					// 		title: '이력서 작성 샘플',
					// 		width: 700
					// 	});
					// });
				});
			</script>
			<div class="resumeInBtnsWrap MB20">
				<div class="innerWrap TXTR">
					<a href="javascript:;" class="btnss blue outline lg ML10 inbg MINWIDTH200 FONT16 fnDialogResumeInfoButton">이력서 충실도란?</a>
					<a href="javascript:alert('온라인 이력서 샘플은 준비중 입니다.');" class="btnss blue outline lg ML10 inbg MINWIDTH200 FONT16 fnDialogResumeSampButton">이력서 작성 샘플</a>
				</div>
			</div>
			-->
			<!-- ☆ 이력서 등록 참고용 버튼 추가:E -->


			<form id="frm1" name="frm1" method="post">
			<input type="hidden" id="rid" name="rid" value="<%=rid%>" />
			<input type="hidden" name="rtype" value="<%=rtype%>" />
			<input type="hidden" name="cflag" value="<%=cflag%>" />
			<input type="hidden" name="step" value="<%=stp%>" />
			<input type="hidden" name="rGubun" value="<%=rGubun%>" />
			<input type="hidden" name="resumeIsComplete" value="" />
			<input type="hidden" name="isBaseResume" value="<%=isBaseResume%>" />

			<!--#include file = "./rsub_01_userinfo.asp"-->
			<!--#include file = "./rsub_02_school_tt.asp"-->
			<!--#include file = "./rsub_03_career.asp"-->
			<!--#include file = "./rsub_04_activity.asp"-->
			<!--#include file = "./rsub_05_language.asp"-->
			<!--#include file = "./rsub_06_license.asp"-->
			<!--#include file = "./rsub_07_awards.asp"-->
			<!--#include file = "./rsub_08_education.asp"-->
			<!--#include file = "./rsub_09_overseas.asp"-->
			<!--#include file = "./rsub_10_preferential.asp"-->
			<!--#include file = "./rsub_11_portfolio.asp"-->
			<!--#include file = "./rsub_12_desire.asp"-->
			<!--#include file = "./rsub_13_introduce.asp"-->

			<% If isBaseResume = "1" Then %>
			<!-- ☆ 현재 작성된 이력서를 공개하세요. :S -->
			<div class="input_box" id="resume10">
				<div class="ib_tit colorGry3" style="padding-bottom: 13px;">
					현재 작성된 이력서를 공개하세요.
					<div class="FONT16 MT10">이력서를 공개하면 지원하지 않아도 참여기업 인사담당자의 검토 후 면접제의를 받으실 수 있습니다.</div>
					<div class="FLOATR" style="margin-top: -20px;">
						<label class="radiobox">
							<input type="radio" class="rdi" name="resume_openis" value="1" <%If isOpenResume = "1" Then%>checked<%End if%>>
							<span class="FONT15">이력서 공개</span>
						</label>
						<label class="radiobox">
							<input type="radio" class="rdi" name="resume_openis" value="0" <%If isOpenResume = "0" Then%>checked<%End if%>>
							<span class="FONT15">이력서 비공개</span>
						</label>
					</div>
				</div>

			</div>
			<!-- ☆ 현재 작성된 이력서를 공개하세요. :E -->
			<% End If %>

			<div class="btn_area">
				<a href="javascript:" class="btn resume" onclick="fn_resume_save();">이력서 저장</a>
			</div>

			</form>
		</div><!-- .con_area -->
	</div><!-- .content -->

</div>
<!-- //본문 -->


<!-- 하단 -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- 하단 -->

<iframe id="procFrame" name="procFrame" style="position:absolute; top:0; left:0; width:0;height:0;border:0;" frameborder="0" src="about:blank"></iframe>
<form id="fileUploadForm" name="fileUploadForm" method="post" enctype="multipart/form-data" target="procFrame" action="./file_upload.asp" onsubmit="return false;">
	<span style="display:none;">
	<input type="file" id="uploadFile" name="uploadFile" onchange="javascript:document.fileUploadForm.submit();">
	</span>
	<input type="hidden" id="file_index" name="file_index" value="">
	<input type="hidden" id="pre_file_name" name="pre_file_name" value="">
</form>
<form id="filedelForm" name="filedelForm" method="post" target="procFrame" action="./file_del.asp">
	<input type="hidden" id="del_resume_no" name="del_resume_no" value="<%=rid%>">
	<input type="hidden" id="del_file_name" name="del_file_name" value="">
	<input type="hidden" id="del_file_seq" name="del_file_seq" value="">
</form>

<!-- 이력서 사진 삭제 -->
<form id="frm_my_sub_view" name="frm_my_sub_view" method="post">
<input type="hidden" id="hid_myPhoto" name="hid_myPhoto" value="<%=arrUser(11, 0)%>">
</form>



<!-- ☆  이력서 충실도 팝업 :S -->
<div class="cmm_layerpop" data-layerpop="dialogResumeInfo">
	<div class="diTip">
		<div class="tit">이력서 충실도 장점</div>
		<div class="cmmLst indent indent10 MT10">
			<div class="cmmtp"><span class="cmmDots w3"></span>충실도 %가 올라갈 수록 이력서의 질도 함께 올라갑니다.</div>
			<div class="cmmtp"><span class="cmmDots w3"></span>이력서의 질이 좋으면 서류검토 단계에서 인사담당자에게 좋은 평가를 줄 수 있습니다.</div>
			<div class="cmmtp"><span class="cmmDots w3"></span>충실도가 높을 수록 인재정보에 노출된 내 이력서를 본 인사담당자에게서 연락 받을 수 있는 가능성이 높아집니다.</div>
		</div>
		<div class="tit MT30">충실도 가점 배분</div>
		<div class="tb">
			<table>
				<colgroup>
					<col width="30%"/>
					<col width="20%"/>
					<col width="*"/>
				</colgroup>
				<thead>
					<tr>
						<th>이력서 항목</th>
						<th>충실도</th>
						<th>조건</th>
					</tr>
				</thead>
				<tbody>

					<tr>
						<td>학력사항</td>
						<td>10%</td>
						<td>1건 이상 입력, 고졸 검정고시 선택 시 부여</td>
					</tr>
					<tr>
						<td>경력사항</td>
						<td>10%</td>
						<td>1건 이상 입력, 신입은 자동 부여</td>
					</tr>
					<tr>
						<td>인턴,대외활동</td>
						<td>10%</td>
						<td>1건 이상 입력</td>
					</tr>
					<tr>
						<td>외국어</td>
						<td>10%</td>
						<td>1건 이상 입력</td>
					</tr>
					<tr>
						<td>자격증</td>
						<td>10%</td>
						<td>1건 이상 입력</td>
					</tr>
					<tr>
						<td>교육이수</td>
						<td>10%</td>
						<td>1건 이상 입력</td>
					</tr>
					<tr>
						<td>희망근무조건</td>
						<td>10%</td>
						<td>직무, 희망근무지 입력 시</td>
					</tr>
					<tr>
						<td>자기소개서</td>
						<td>30%</td>
						<td>
							단 200자 이내 시 10% 적용<br />
						    400자 이상 ~ 600자 이내 20% 적용<br />
						    800자 이상 30% 적용<br /><br />
						</td>
					</tr>
				</tbody>
			</table>
		</div>

	</div>
</div>
<!-- ☆  이력서 충실도 팝업 :E -->

<!-- ☆  이력서 충실도 팝업 :S -->
<div class="cmm_layerpop" data-layerpop="dialogResumeSamp">
	온라인 이력서 샘플은 준비중 입니다.
</div>
<!-- ☆  이력서 충실도 팝업 :E -->


</body>
</html>
