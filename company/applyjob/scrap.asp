<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/wwwconf/function/library/AES256.asp"-->
<!--#include virtual = "/wwwconf/code/code_function_jc.asp"-->
<!--#include virtual = "/wwwconf/code/code_function_ac.asp"-->
<!--#include virtual = "/inc/function/paging.asp"-->
<%
	Call FN_LoginLimit("2")    '기업회원만 접근가능
%>

<%
	Dim Page, PageSize, OrderNum, JobNum, stropt 
	
	Page		= Request("page")
	PageSize	= 5
	OrderNum	= Request("ordernum")
	JobNum		= Request("jobnum")
	
	If Page = "" Then
		Page = 1
	End If

	If OrderNum = "" Then
		OrderNum = 1
	End If

	If JobNum = "" Then
		JobNum = 0
	End If

	ConnectDB DBCon, Application("DBInfo_FAIR")	

	Dim total, totalPage, result
	ReDim param(12)	
	
	param(0) = makeParam("@Gubun", adVarChar, adParamInput, 1, "1")
	param(1) = makeParam("@BizID", adVarChar, adParamInput, 20, comid)
	param(2) = makeParam("@JobNum", adInteger, adParamInput, 4, JobNum)
	param(3) = makeParam("@ExpCode", adVarChar, adParamInput, 10, "")
	param(4) = makeParam("@School", adVarChar, adParamInput, 10, "")
	param(5) = makeParam("@JobCode", adVarChar, adParamInput, 20, "")
	param(6) = makeParam("@UserName", adVarChar, adParamInput, 20, "")
	param(7) = makeParam("@StartDate", adVarChar, adParamInput, 10, "")
	param(8) = makeParam("@EndDate", adVarChar, adParamInput, 10, "")
	param(9) = makeParam("@OrderNum", adInteger, adParamInput, 4, OrderNum)
	param(10) = makeParam("@Page", adInteger, adParamInput, 4, Page)
	param(11) = makeParam("@PageSize", adInteger, adParamInput, 4, PageSize)
	param(12) = makeParam("@TotalCnt", adInteger, adParamOutput, 1, "0")
	
	result		= arrGetRsSP(DBCon, "USP_BIZSERVICE_SCRAP_RESUME_LIST", param, "", "")
	total		= getParamOutputValue(param, "@TotalCnt")
	
	totalPage	= Fix(((total-1)/PageSize) +1)
	stropt		= ""

	DisconnectDB DBCon

	'Response.write "EXEC USP_BIZSERVICE_SCRAP_RESUME_LIST '1','"&comid&"','"&JobNum &"','','','','','','','"&OrderNum&"','"&Page&"','"&PageSize&"','' " & "<br><br><br>"
%>

<script type="text/javascript">

	$(document).ready(function () {
		//정렬 class on 설정
        var orderNum = <%=OrderNum%>;

        switch (orderNum) {
            case 1 :
				$('#sort_ul > li').eq(0).addClass('on');
				break;
            case 2 :
				$('#sort_ul > li').eq(1).addClass('on');
				break;
            case 4 :
				$('#sort_ul > li').eq(2).addClass('on');
				break;
            case 5 :
				$('#sort_ul > li').eq(3).addClass('on');
				break;
            default :
				$('#sort_ul > li').eq(0).addClass('on');
				break;
        }
	});

	function goListOrder(orderNum) {
        $("#orderNum").val(orderNum);
        $('#frm').submit();
    }

	function fn_del() {
		var chk		= $(".checkbox.on > input[name=rid]");
		var rid		= "";		

		for (i = 0; i < chk.length; i++) {
			rid = (i == 0) ? chk.eq(i).val() : rid + "," + chk.eq(i).val();
		}
        
        if (rid.length == 0) {
            alert("삭제할 인재를 선택해야 합니다.");
            return;
        }

        if (confirm("선택한 인재를 삭제 하시겠습니까?")) {
            $.ajax({
                type: "POST",
                url: "/company/applyjob/scrapDel.asp",
                data: { rid: rid },
                dataType: "html",
                success: function (data) {
                    if (data == "0") {
                        alert("인재삭제 실패: 관리자에게 문의하세요.");
                    } else if (data == "1") {
                        alert("인재삭제가 완료되었습니다.");
                        location.href = location.href;
                    } else {
                        alert("서버 데이터 오류: 관리자에게 문의하세요. code=" + data);
                    }
                },
                error: function (xhr) {
                    var status = xhr.status;
                    var responseText = xhr.responseText;
                    alert(responseText + '//');
                }
            });
        }
    }
	
	function fn_resume_view(rid, set_user_id) {
		var _frm1 = document.frm1;
		_frm1.rid.value = rid;
		_frm1.set_user_id.value = set_user_id;

		_frm1.action = '/resume/view.asp';
		_frm1.target = "_blank";
		_frm1.submit();
	}

</script>
</head>

<body>
<!-- 상단 -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->

<!-- 본문 -->
<div id="contents" class="sub_page">
	<div class="content glay">
		<div class="con_area">
			<div class="manage_area">
				<div class="view_box">
					<h3>스크랩한 인재</h3>
					<div class="layoutBox">
						<div class="notiArea">
							<ul>
								<li>ㆍ스크랩한 인재의 이력서는 채용을 목적으로만 활용되며, 목적이 달성되면 지체 없이 파기되어야 합니다.</li>
							</ul>
							<p>※ 채용이 아닌 영업이나 마케팅 등 기타 이외의 목적으로 사용될 경우, <em>정보통신망법 제 72조 3항에 의거 5년 이하 징역 또는 5,000만원 이하의 벌금</em>에 처해질 수 있습니다.</p>
						</div><!-- .notiArea -->
					</div>

				</div><!-- .view_box -->

				<div class="list_area">
					<div class="tlt_wrap">
						<h3>스크랩한 인재</h3><!-- 스크랩한 인재 -->
						<span class="list_number">현재<span class="number"><%=total%></span>명의 스크랩한 인재정보가 있습니다.</span>
						<ul class="sort" id="sort_ul">
							<li><a href="javascript:" onclick="goListOrder('1')">스크랩 등록일순</a></li> <!-- [D]클릭시 클래스 on 삽입 -->
							<li><a href="javascript:" onclick="goListOrder('2')">이력서 수정일순</a></li>
							<li><a href="javascript:" onclick="goListOrder('4')">학력순</a></li>
							<li><a href="javascript:" onclick="goListOrder('5')">경력순</a></li>
						</ul>
					</div><!--.titArea-->

					<div class="board_area">
						<table class="tb" summary="스크랩한 인재에 관한 이름/성별/나이,이력서 정보/요약정보,등록일 항목을 나타낸 표">
							<caption>스크랩한 공고</caption>
							<colgroup>
								<col style="width:310px">
								<col>
								<col style="width:160px">
							</colgroup>
							<thead>
								<tr>
									<th>
										<label class="checkbox off"><input class="chk" id="" name="" type="checkbox" onclick="noncheckallFnc(this, 'chk_list');"></label>
										이름/나이
									</th>
									<th>이력서 정보/요약정보</th>
									<th>등록일</th>
								</tr>
							</thead>
							<tbody>
								<%
									If total > 0 Then
										If isArray(result) Then
											Dim resume_birth_year,resume_age
											Dim tot_sum, totalyear, totmonth, resume_ec, resume_careersum
											Dim str_jc
											Dim workArea, workAreaDetail, jj, str_ac

											For i = 0 to ubound(result, 2)
												If result(5,i) <> "" Then ' 주민번호년
													If result(6,i) = "3" Or result(6,i) = "4" Or result(6,i) = "7" Or result(6,i) = "8" Then ' 주민번호성별
														resume_birth_year = "20" & result(5,i) ' 주민번호년
													Else 
														resume_birth_year = "19" & result(5,i) ' 주민번호년
													End If
										
													resume_age	= year(date) - resume_birth_year + 1
												End If

												If result(30,i) <> "0" Then ' 경력월수
													resume_ec	= "경력" 
													tot_sum		= result(30,i) * 30 ' 경력월수

													If (tot_sum / 30) > 12 Then
														totalyear = Fix((tot_sum / 30) / 12)
														totmonth = Fix((tot_sum / 30) - (totalyear) * 12)
														
														resume_careersum = "<span class='num'>" & totalyear & "</span>년 " & "<span class='num'>" & totmonth & "</span>개월 "
													Else
														resume_careersum = Round(tot_sum / 30) & "개월"
													End If
												Else
													resume_ec			= "신입"
													resume_careersum	=	""
												End If

												str_jc	= Replace(getJobTypeAll(result(32,i)),"/",", ") ' 희망직종코드전체												
												
												workArea = split(result(33,i), "|") ' 근무가능지역코드전체
												str_ac = ""

												For ii=0 To Ubound(workArea)
													workAreaDetail = split(workArea(ii), "/")

													For jj=0 To Ubound(workAreaDetail)
														If jj = 0 Then
															str_ac = str_ac & get_simple_Ac(getAcName(workAreaDetail(jj)))
														End If
													Next
													
													If ii <> Ubound(workArea)  Then
														str_ac = str_ac & ","
													Else
														str_ac = str_ac & ""
													End If
												Next

												' 중복 지역 제거
												Dim workArea_temp, array_temp, m
												workArea_temp = ""

												array_temp = Split(str_ac,",")

												For m = 0 To UBound(array_temp)
													If InStr(workArea_temp,array_temp(m)) = 0 Then
														If m =0 Then
															workArea_temp = array_temp(m)
														Else
															workArea_temp = workArea_temp & ", " & array_temp(m)
														End If
													End If
												Next
								%>
								<tr>
									<td class="t1 tc">
										<label class="checkbox off">
											<input class="chk" id="" name="chk_list" type="checkbox" value="<%=result(1,i)%>"> <!-- 등록번호 -->
											<input type="hidden" name="rid" value="<%=result(1,i)%>" /> <!--등록번호-->
										</label>
										<div class="photoBox">
											<div class="photo">
												<span class="frame sprite"></span>
												<img src="/files/mypic/<%=result(13,i)%>"> <!-- 사진파일 -->
											</div>
											<div class="photo_info">
												<em class="name"><%=result(4,i)%></em> <!-- 성명 -->												
												<p class="birth">(<span class="num"><%=resume_birth_year%></span>년생, <span class="num"><%=resume_age%></span>세)</p>
											</div>
										</div>
									</td>
									<td class="t2">
										<div class="txtBox">
											<div class="tit">
												<% If result(25,i) = 1 Then %> <!-- 이력서공개 -->
												<a href="javascript:;" onclick="fn_resume_view('<%=result(1,i)%>', '<%=objEncrypter.Encrypt(result(3,i))%>')"><%=result(12,i)%></a> <!-- 등록번호, 개인아이디, 이력서제목 -->
												<% Else %>
												<a href="javascript:alert('비공개로 전환한 인재입니다.');"><%=result(12,i)%></a> <!-- 이력서제목 -->
												<% End If %>
											</div>
											<div>
												<dl>
													<dt>경력년수 :</dt>
													<dd><%=resume_ec%>&nbsp;<%=resume_careersum%></dd>
												</dl>
												<dl>
													<dt>희망직무 :</dt>
													<dd><%=str_jc%></dd>
												</dl>
												<dl>
													<dt>최종학력 :</dt>
													<dd>
													<%
														dbCon.Open Application("DBInfo_FAIR")
														
														Dim strSql, resume_school, resume_school2, Major
														strSql = "SELECT 학교명, 전공명 FROM 이력서학력 WHERE 등록번호 = " & result(1,i) ' 등록번호

														If result(22,i) <> "" Then ' 최종학력코드
															strSql = strSql & " AND 학력종류 = " & result(22,i) ' 최종학력코드

															Select Case result(22,i) ' 최종학력코드
																Case 4
																	resume_school2 = "(2,3년제)"
																Case 5
																	resume_school2 = "(4년제)"
																Case Else
																	resume_school2 = ""
															End Select
														Else
															strSql			= strSql & " AND 순차번호 = 1"
															resume_school2	= ""
														End If
														
														Rs.Open strSql, dbCon, 0, 1
														
														If (Rs.BOF=False And Rs.EOF=False) Then
															resume_school	= Rs.Fields(0).Value															
															Major			= Rs.Fields(1).Value
														Else
															resume_school	= ""
															Major			= ""
														End If

														Response.write resume_school & resume_school2 & " " & Major

														Rs.Close
														dbCon.Close
													%>
													</dd>
												</dl>
												<dl>
													<dt>희망지역 :</dt>
													<dd><%=workArea_temp%></dd>
												</dl>
											</div>
										</div><!--.txtBox-->
									</td>
									<td class="t3 tc">
										<span class="num"><%=Replace(result(2,i),"/","-")%></span> <!-- 등록일 -->
									</td>
								</tr>
								<%		
											Next
										End If
									Else
								%>
								<tr>
									<td class="no_date" colspan="3">
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
				</div><!--/list_area -->
				<div class="option_btn">
					<button type="button" onclick="fn_del();">선택항목 삭제</button>
				</div>

				<!--페이징-->
				<% Call putPage(Page, stropt, totalPage) %>	
			</div><!-- .manage_area -->
		</div><!-- .con_area -->
	</div><!-- .content -->
</div>
<!-- //본문 -->

<!-- 하단 -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- 하단 -->

<form method="post" id="frm" name="frm" action="">
    <input type="hidden" id="page" name="page" value="" />
    <input type="hidden" id="orderNum" name="orderNum" value="" />
    <input type="hidden" id="delRids" name="delRids" value="" />
</form>

<form id="frm1" name="frm1" method="post">
	<input type="hidden" id="rid" name="rid" value="">
	<input type="hidden" id="set_user_id" name="set_user_id" value="">
</form>

</body>
</html>

<OBJECT RUNAT="SERVER" PROGID="ADODB.Connection" ID="dbCon"></OBJECT>
<OBJECT RUNAT="SERVER" PROGID="ADODB.RecordSet" ID="Rs"></OBJECT>