<%
Option Explicit

g_MenuID = "110027"
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/function/common/fn_gnb.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/wwwconf/query_lib/my/CAT_Info.asp"-->
<!--#include virtual = "/wwwconf/function/my/CAT_Function.asp"-->
<!--#include virtual="/wwwconf/code/code_function.asp"-->
<!--#include virtual = "/wwwconf/query_lib/user/SelectMyIntroInfo.asp"-->

<!--#include virtual="/wwwconf/code/code_function.asp"-->
<!--#include virtual="/wwwconf/code/code_function_ac.asp"-->
<!--#include virtual="/wwwconf/code/code_function_jc.asp"-->
<!--#include virtual= "/wwwconf/code/codeToHtml.asp"-->
<OBJECT RUNAT="SERVER" PROGID="ADODB.RecordSet" ID="Rs"></OBJECT>  
<%
Dim SiteCode
SiteCode = getSiteCode(Request.ServerVariables("SERVER_NAME"))

dbCon.Open Application("DBInfo")

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'인성검사 데이터 받아옴
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'인성검사 개인로그 목록
Dim ArrOCILogParams
redim ArrOCILogParams(1)
ArrOCILogParams(0) = SiteCode
ArrOCILogParams(1) = user_id

'인성검사 검사 전 목록
dim ArrOCIPersonalLogBeforeList
Call getOCIPersonalLogBeforeList(dbCon, ArrOCILogParams, ArrOCIPersonalLogBeforeList, "", "")

'인성검사 검사 중 목록
dim ArrOCIPersonalLogIngList
Call getOCIPersonalLogIngList(dbCon, ArrOCILogParams, ArrOCIPersonalLogIngList, "", "")

dbCon.Close
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'인성검사 데이터 가공
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Dim OCIPersonalLogBefore_Count,OCIPersonalLogBefore_idx
If IsArray(ArrOCIPersonalLogBeforeList) = True Then
	OCIPersonalLogBefore_Count = CInt(UBound(ArrOCIPersonalLogBeforeList,2)) + 1
	OCIPersonalLogBefore_idx = Trim(ArrOCIPersonalLogBeforeList(0,0))
Else
	OCIPersonalLogBefore_Count = 0
	OCIPersonalLogBefore_idx = ""
End If

Dim OCIPersonalLogIng_Count,OCIPersonalLogIng_idx
If IsArray(ArrOCIPersonalLogIngList) = True Then
	OCIPersonalLogIng_Count = CInt(UBound(ArrOCIPersonalLogIngList,2)) + 1
	OCIPersonalLogIng_idx = Trim(ArrOCIPersonalLogIngList(0,0))
Else
	OCIPersonalLogIng_Count = 0
	OCIPersonalLogIng_idx = ""
End If
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'결제
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
ConnectDB DBCon, Application("DBInfo")

Dim strSql
Dim arrgetUserIntroList
Dim ArrRs, i
Dim RecordCount, RsCount
Dim user_mile
Dim price

arrgetUserIntroList = getMyIntroList(DBCon, user_id)
RecordCount = arrgetUserIntroList(0)
RsCount = arrgetUserIntroList(1)
ArrRs   = arrgetUserIntroList(2)

user_mile = getMyInfo(DBCon, user_id)

DisConnectDB DBCon

If Date >= "2010-05-11" And Date <= "2010-06-03" Then
   price = 4400
Else
   price = 7700
End IF
%>
    <hr />
<SCRIPT LANGUAGE="JavaScript">
<!--
var price = "<%=price%>";
var user_mile = "<%=user_mile%>";
//-->
</SCRIPT>
<script language="javascript" src="/js/user/cat.js"></script>
<script language="javascript" src="/js/user/bill_sat.js"></script>
    <!-- 중간 -->
    <div id="career_container">
        <div id="career_2col_L">

			<!-- 중간 컨텐츠 -->
            <div id="career_contents">
                <!-- 상단 영역 -->
                <div id="career_tops">
                    <div id="career_tms">
 
                        <div class="my_comm_top">
                            <h4><img src="http://image.career.co.kr/career_new/my/tit_career_test.gif" alt="커리어 인성검사" /></h4>
                        </div>
                        <div class="billing_top02 cat_test_bg">
                            <ul class="cf_txt24">
								<li>종합 인성적성검사는 <strong>조직심리 전문기관인 ORP연구소</strong>와 공동으로 제작 및 개발되었습니다.</li>
							</ul>
                            <p class="h5_resume"><img src="http://image.career.co.kr/career_new/my/tt_test_guide.gif" alt="커리어 인성검사 [OCI]의 특징" /></p>
                            <p class="pro_consulting">
                            <img src="http://image.career.co.kr/career_new/my/img_oci_guide.gif" alt="-인성검사에는 한 조직의 인재상, 미래비전, 조직문화 등 나의 인성이 얼마나 적합한지 보여줍니다. -인성역량별 점수와 조직의 인재상을 비교하여 나의 강/약점의 역량을 확인할 수 있습니다.-인성검사는 국내 여러기업 및 공공기관에서 현재 사용하고 있는 역량기반의 인성 진단검사형식을 사용하고 있으며, 총 26개의 역량별 수준을 확인할 수 있습니다." /></p>

							<!-- <p class="cf_txt20"><img src="http://image.career.co.kr/career_new/info/tt_oci_end.gif" alt="커리어 인적성검사는 2014년 1월 29일까지 서비스 되며 이후 서비스가 종료됩니다" /></p> -->
                        </div>
 
                    </div>
                </div>
                <!--// 상단영역 -->

                <div class="cb"></div>
                <hr />

                <!-- center -->
                <div id="center">
				<form name="frm11" method="post">
				<input type="hidden" name="chkV" value="1">
				<input type="hidden" name="svc" value="OCI">
				<input type="hidden" name="svc_gb" value="sat">
                    <div class="title_comm_info mt_15">
                        <h4 class="no_line"><img src="http://image.career.co.kr/career_new/my/tit_oci_com.gif" alt="인성검사 구성"/></h4>
                    </div>

                  <p><img src="http://image.career.co.kr/career_new/my/bg_oci_table.gif" alt=""/></p>
				  <hr />

					<div class="title_comm_info mt_25">
                        <h4 class="no_line"><img src="http://image.career.co.kr/career_new/my/tit_oci_mat.gif" alt="인성검사 방법 및 유의사항"/></h4>
                    </div>

                  <div class="test_report_box">
				  <img src="http://image.career.co.kr/career_new/my/bg_oci_mat.gif" alt=""/>
				  <p class="txt2"><span class="fs_12">※</span>검사를 진행하던 중 페이지를 끄거나 다른 페이지로 이동할 경우, <strong>현재진행중인 검사페이지의 이전페이지까지만 저장</strong>됩니다.<br />
  &nbsp;&nbsp;-검사신청을 클릭하면 검사를 중단하셨던 페이지의 첫번째 문제부터 다시 시작됩니다.</p>
			      </div>
				  <hr />

				<div class="title_comm_info mt_25">
					<h4 class="no_line"><img src="http://image.career.co.kr/career_new/my/tit_report_info.gif" alt="인성검사 Report해석 및 활용방법"/></h4>
			    </div>

				<div class="test_report_box">
					<ol class="ol_list">
					<li class="num1">먼저 역량군별 점수 비교에서는 <strong>총 4개 역량군별 점수가 제시</strong>됩니다.</li>
					<li class="num2"><strong>그래프</strong>를 통해서 자신의 점수가 대학생 평균, 현직장인 평균과 어떤 차이가 있는 지를 파악하십시오.</li>
					<li class="num3"><strong>점수표</strong>를 통해 각각의 점수를 확인하고, <strong>적합도 판정결과</strong>를 확인하십시오. (매우적합 > 적합 > 보통 > 미흡)</li>
					<li class="num4"><strong>역량별 점수 비교 그래프</strong>를 통해 자신의 역량별 점수가 대학생 평균, 현직장인 평균과 어떤 차이가 있는 지를 파악하십시오.</li>
					<li class="num5">세부 결과에서는 각각 제시된 역량과 역량정의를 자세히 읽어본 다음, <strong>자신의 각각 역량점수와 적합도 판정결과를 확인</strong>하십시오.</li>
					<li class="num6">각 적합도 판정결과에 따라 <strong>해당 역량에 대한 정의</strong>를 다시 한 번 읽어보고, 자신의 강점이 무엇인지, 부족한 점이 무엇인지 확인하십시오.</li>
					</ol>
					<p class="txt1">※ 인성검사의 특성상 본 검사에 제시된 대학생 평균과 현직장인 평균 점수는 절대 기준이 될 수 없습니다. 참고로만 활용해 주십시오.</p>
					<p class="txt3"><strong>[ 인성검사 Sample ]</strong></p>
					<ul class="ques_exm">
					<li class="first">
					<dl>
					<dt><img src="http://image.career.co.kr/career_new/my/img_report_oci_ex01.gif" alt="문제예시화면 " /></dt>
					<dd>[ 문제예시화면 ]</dd>
					<!--dd class="btn_sample"><a href="#"><img src="http://image.career.co.kr/career_new/button/btn_zoom_view.gif" alt="확대보기" /></a></dd-->
					</dl>
					</li>
					<li>
					<dl>
					<dt><img src="http://image.career.co.kr/career_new/my/img_report_oci_ex02.gif" alt="검사결과 샘플1 " /></dt>
					<dd>[ 검사결과 샘플1 ]</dd>
					<dd class="btn_sample"><a href="#none" onclick="javascript:window.open('/my/cat/pop_oci_zoom1.asp','pop_oci_zoom1','width=752, height=563, top=100, left=200, scrollbars=no')"><img src="http://image.career.co.kr/career_new/button/btn_zoom_view.gif" alt="확대보기" /></a></dd>
					</dl>
					</li>
					<li>
					<dl>
					<dt><img src="http://image.career.co.kr/career_new/my/img_report_oci_ex03.gif" alt="검사결과 샘플2" /></dt>
					<dd>[ 검사결과 샘플2 ]</dd>
					<dd class="btn_sample"><a href="#none" onclick="javascript:window.open('/my/cat/pop_oci_zoom2.asp','pop_oci_zoom2','width=752, height=563, top=100, left=200, scrollbars=no')"><img src="http://image.career.co.kr/career_new/button/btn_zoom_view.gif" alt="확대보기" /></a></dd>
					</dl>
					</li>
					</ul>
				</div>
				<hr />
				<!-- 결제 -->
					<div class="payment_s payment payment_top">
						<dl class="appl">
							<dt><img src="http://image.career.co.kr/career_new/company/product/img_application_tit.gif" alt="총 신청금액" /><strong><span id="display_amt1"><%=FormatNumber(price, 0)%></span></strong><img src="http://image.career.co.kr/career_new/company/product/img_won.gif" alt="원" /></dt>
							<dd class="end"><strong class="point">포인트</strong><input type="text" id="" name="amt_point" style="width:98px;text-align:right;" onfocus="onFocus(this)" onblur="onBlur(this);pointChk();" onKeyUp="point_Cal();" class="inputOff" /><input type="hidden" name="amt_point2"><span class="mlr_5_18">원</span>적립된 포인트 : <span class="acc"><%=formatnumber(user_mile,0)%></span>원 <span class="fc_acc">(100원 단위로 사용 가능)</span><input type="checkbox" name="pointYN" id="au" class="chk_md" onclick="chk_Point(this);"/><label for="au">포인트로만 결제하기</label></dd>
						</dl>
						<dl class="sum">
							<dt><img src="http://image.career.co.kr/career_new/company/product/img_payment_tit.gif" alt="총 결제금액" /><input type="hidden" name="amt" value="<%=price%>"><input type="hidden" name="amt2" value="<%=price%>"><input type="hidden" name="amt3" value="<%=price%>"><strong><span id="display_amt2"><%=FormatNumber(price, 0)%></span></strong><img src="http://image.career.co.kr/career_new/company/product/img_won.gif" alt="원" /><img src="http://image.career.co.kr/career_new/company/product/img_tex.gif" alt="부가세 포함" class="ml_6"/></dt>
							<dd class="acc"><strong class="point">적립예정 포인트</strong> : <input type="hidden" name="plus_point" value="0"><strong class="won"><span id="display_point">0</span></strong>원</dd>
							<dd class="acc02">
							<ul class="method">
							    <li><span class="ie6_gap"><input type="radio" id="hp" name="billtype" value="7" /><label for="hp">휴대폰</label></span></li>
								<li><span class="ie6_gap"><input type="radio" id="cd" name="billtype" value="1" /><label for="cd">카드결제</label></span></li>
								<li><span class="ie6_gap"><input type="radio" id="at" name="billtype" value="6" /><label for="at">실시간 계좌이체<input type="radio" id="po" name="billtype" value="4" style="display:none;"/><input type="hidden" name="billtype2"></label></span></li>
								<li><a href="javascript:canselbill();"><img src="http://image.career.co.kr/career_new/button/btn_blu_cancel.gif" alt="취소" /></a></li>
								<li><span class="mt_2"><a href="javascript:openwin('/my/billing/payment_guide.asp', 'bill', 580,700);"><img src="http://image.career.co.kr/career_new/company/product/btn_pay_guide.gif" alt="결제수단별 안내" /></a></span></li>
							</ul>
								<p class="txt_point">결제수단을 선택하신 후 아래 <span class="b">[인성검사 신청]</span> 버튼을 클릭해 주세요</p>
								</dd>
						</dl>
					</div>
					<!-- // 결제 -->
					<% If OCIPersonalLogIng_idx <> "" Or OCIPersonalLogBefore_idx <> "" Then %>
					<p class="btn_link"><a href="javascript:goOCITest('<%=OCIPersonalLogBefore_idx%>','<%=OCIPersonalLogIng_idx%>');"><img src="http://image.career.co.kr/career_new/button/btn_test_sup.gif" alt="인성검사 신청" /></a></p>
					<% else %>
					<p class="btn_link"><a href="javascript:ok_submit();"><img src="http://image.career.co.kr/career_new/button/btn_test_sup.gif" alt="인성검사 신청" /></a></p>
					<% End If %>
				</form>
				<SCRIPT LANGUAGE="JavaScript">
				<!--
					sum_price();
				//-->
				</SCRIPT>


					<!--<p class="mt_25"><img src="http://image.career.co.kr/career_new/info/img_oci_end.gif" alt="커리어 인성적성검사 종료 안내 - 커리어 인성적성검사 제휴가 종료되어 1월 28일 까지 서비스 됩니다 이용해 주셨던많은 분들께 양해 부탁 드립니다" /></p>-->

                </div>
                <!--// center -->
            </div>
            <!--// 중간 컨텐츠 -->
        </div>
        <!--// career_2col_L -->
    </div>
    <!--// career_container -->
    <!--// 중간 -->