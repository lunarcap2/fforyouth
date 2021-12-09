<%
Option Explicit

Response.Expires = -1

g_MenuID = "110027"
%>
<!--#include virtual = "/common/common.asp"-->
<% Call FN_LoginLimit("1")    '개인회원만 접근가능 %>
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
'적성검사 데이터 받아옴
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'적성검사 개인로그 목록
Dim ArrOATLogParams
redim ArrOATLogParams(1)
ArrOATLogParams(0) = SiteCode
ArrOATLogParams(1) = user_id

'적성검사 검사 전 목록
dim ArrOATPersonalLogBeforeList
Call getOATPersonalLogBeforeList(dbCon, ArrOATLogParams, ArrOATPersonalLogBeforeList, "", "")

'적성검사 검사 중 목록
dim ArrOATPersonalLogIngList
Call getOATPersonalLogIngList(dbCon, ArrOATLogParams, ArrOATPersonalLogIngList, "", "")

dbCon.Close
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'적성검사 데이터 가공
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Dim OATPersonalLogBefore_Count,OATPersonalLogBefore_idx
If IsArray(ArrOATPersonalLogBeforeList) = True Then
	OATPersonalLogBefore_Count = CInt(UBound(ArrOATPersonalLogBeforeList,2)) + 1
	OATPersonalLogBefore_idx = Trim(ArrOATPersonalLogBeforeList(0,0))
Else
	OATPersonalLogBefore_Count = 0
	OATPersonalLogBefore_idx = ""
End If

Dim OATPersonalLogIng_Count,OATPersonalLogIng_idx
If IsArray(ArrOATPersonalLogIngList) = True Then
	OATPersonalLogIng_Count = CInt(UBound(ArrOATPersonalLogIngList,2)) + 1
	OATPersonalLogIng_idx = Trim(ArrOATPersonalLogIngList(0,0))
Else
	OATPersonalLogIng_Count = 0
	OATPersonalLogIng_idx = ""
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
   price = 5500
Else
   price = 9900
End IF
%>
<%
Call FN_LoginLimit("1")
%>
<% Call putTopNew("") %>
<SCRIPT LANGUAGE="JavaScript">
<!--
var price = "<%=price%>";
var user_mile = "<%=user_mile%>";
//-->
</SCRIPT>
<script language="javascript" src="/js/user/cat.js"></script>
<script language="javascript" src="/js/user/bill_sat.js"></script>
    <div id="career_container">
        <div id="career_2col_L">
            <% Call putLeft() %>
            <!--// career_left -->

            <!-- 중간 컨텐츠 -->
            <div id="career_contents">
                <!-- 상단 영역 -->
                <div id="career_tops">
                    <div id="career_tms">
 
                        <div class="my_comm_top">
                            <h4><img src="http://image.career.co.kr/career_new/my/tit_career_test02.gif" alt="커리어 적성검사" /></h4>
                        </div>
                        <div class="billing_top02 cat_test_bg">
                            <ul class="cf_txt24">
								<li>종합 인성적성검사는 <strong>조직심리 전문기관인 ORP연구소</strong>와 공동으로 제작 및 개발되었습니다.</li>
							</ul>
                            <p class="h5_resume"><img src="http://image.career.co.kr/career_new/my/tt_test02_guide.gif" alt="커리어 적성검사  [OAT]의 특징" /></p>
                            <p class="pro_consulting">
                            <img src="http://image.career.co.kr/career_new/my/img_oat_guide.gif" alt="-적성검사에는 언어, 수리, 추리, 공간지각능력 등 한 사람에게 필요한 기본적인 지적능력 들이 포함되어있으며, 각 적성영역에서 우수한 능력을 보이는 사람을 선발하는데 활용됩니다. -적성검사 결과에 따라 각 능력이 필요한 직업에 자신이 얼마나 적합한지 알 수 있습니다. -다양한 적성영역 중 가장 널리 사용되는 총6개 적성을 진단할 수 있도록 구성되었습니다." /></p>

							<!-- <p class="cf_txt21"><img src="http://image.career.co.kr/career_new/info/tt_oci_end.gif" alt="커리어 인적성검사는 2014년 1월 29일까지 서비스 되며 이후 서비스가 종료됩니다" /></p> -->
                        </div>
 
                    </div>

                    <div id="career_tr">
                        <!-- 250 배너 -->
                        <% Call putBanner() %>
                        <!-- 250 배너 -->
                    </div>
                </div>
                <!--// 상단영역 -->

                <div class="cb"></div>
                <hr />

                <!-- center -->
                <div id="center">
				<form name="frm11" method="post">
				<input type="hidden" name="chkV" value="1">
				<input type="hidden" name="svc" value="OAT">
				<input type="hidden" name="svc_gb" value="sat">
                    <div class="title_comm_info mt_15">
                        <h4 class="no_line"><img src="http://image.career.co.kr/career_new/my/tit_oat_com.gif" alt="적성검사 구성"/></h4>
                    </div>

                  <p><img src="http://image.career.co.kr/career_new/my/bg_oat_table.gif" alt=""/></p>
				  <hr />

					<div class="title_comm_info mt_25">
                        <h4 class="no_line"><img src="http://image.career.co.kr/career_new/my/tit_oat_mat.gif" alt="적성검사 방법 및 유의사항"/></h4>
                    </div>

                  <div class="test_report_box">
				  <img src="http://image.career.co.kr/career_new/my/bg_oat_mat.gif" alt=""/>
				  <p class="txt2"><span class="fs_12">※</span>검사를 진행하던 중 페이지를 끄거나 다른 페이지로 이동할 경우, <strong>현재진행중인 검사의 이전 과목까지만 저장</strong>됩니다.<br />
  &nbsp;&nbsp;-검사신청을 클릭하면 검사를 중단하셨던 과목의 1번부터 다시 시작합니다.</p>
			      </div>
				  <hr />

				<div class="title_comm_info mt_25">
					<h4 class="no_line"><img src="http://image.career.co.kr/career_new/my/tit_report_oat_info.gif" alt="적성검사 Report해석 및 활용방법"/></h4>
			    </div>

				<div class="test_report_box">
					<ol class="ol_list">
					<li class="num1">먼저 역량군별 점수 비교에서는 <strong>총 6개 적성영역(검사)에 대한 점수가 제시</strong>됩니다.</li>
					<li class="num2"><strong>그래프</strong>를 통해각 <strong>적성영역별 자신의 점수를 확인</strong>하십시오. 각 점수는 계산 공식에 의해 <strong>100점 만점으로 환산</strong>된 점수입니다.</li>
					<li class="num3">각 적성영역별 등급을 확인하고, 등급표를 통해 <strong>해당 등급이 어떤 수준을 말하는 것인지 파악</strong>하십시오.</li>
					<li class="num4">적성영역별 관련 직무표에서 각 적성영역 중 <strong>4등급 이상인 적성에 해당하는 별표에 동그라미</strong>를 그리십시오.<br />4등급 이상의 적성이 없거나 부족하다면, 6등급 이상인 적성에 해당하는 별표에 다른 표시를 하십시오.</li>
					<li class="num5">각 직무별로 보았을 때, 표시된 <strong>별표가 많은 직무가 당신에게 적합한 직무</strong>라 할 수 있습니다.</li>
					<li class="num6">강약점 분석 표를 통해 <strong>자신의 강점 적성과 약점 적성을 확인</strong>하십시오.</li>
					<li class="num7">Recommendation을 통해 <strong>약점 적성의 개발 방향을 확인</strong>하십시오. 한번 보고 잊어버리기 보다는 아무리 사소한 방법이라도 기억하고 실천해보십시오.<br />적성(능력)은 노력여하에 따라 개선/개발이 가능합니다.</li>
					</ol>
					<p class="txt1">※ 적성검사의 특성상 본 검사에 제시된 대학생 평균과 현직장인 평균 점수는 절대 기준이 될 수 없습니다. 참고로만 활용해 주십시오.</p>
					<p class="txt3"><strong>[ 적성검사 Sample ]</strong></p>
					<ul class="ques_exm">
					<li class="first">
					<dl>
					<dt><img src="http://image.career.co.kr/career_new/my/img_report_oat_ex01.gif" alt="문제예시화면" /></dt>
					<dd>[ 문제예시화면 ]</dd>
					<!--dd class="btn_sample"><a href="#"><img src="http://image.career.co.kr/career_new/button/btn_zoom_view.gif" alt="확대보기" /></a></dd-->
					</dl>
					</li>
					<li>
					<dl>
					<dt><img src="http://image.career.co.kr/career_new/my/img_report_oat_ex02.gif" alt="검사결과 샘플1" /></dt>
					<dd>[ 검사결과 샘플1 ]</dd>
					<dd class="btn_sample"><a href="#none" onclick="javascript:window.open('/my/cat/pop_oat_zoom1.asp','pop_oat_zoom1','width=752, height=563, top=100, left=200, scrollbars=no')"><img src="http://image.career.co.kr/career_new/button/btn_zoom_view.gif" alt="확대보기" /></a></dd>
					</dl>
					</li>
					<li>
					<dl>
					<dt><img src="http://image.career.co.kr/career_new/my/img_report_oat_ex03.gif" alt="검사결과 샘플2" /></dt>
					<dd>[ 검사결과 샘플2 ]</dd>
					<dd class="btn_sample"><a href="#none" onclick="javascript:window.open('/my/cat/pop_oat_zoom2.asp','pop_oat_zoom2','width=752, height=563, top=100, left=200, scrollbars=no')"><img src="http://image.career.co.kr/career_new/button/btn_zoom_view.gif" alt="확대보기" /></a></dd>
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
								<p class="txt_point">결제수단을 선택하신 후 아래 <span class="b">[적성검사 신청]</span> 버튼을 클릭해 주세요</p>
								</dd>
						</dl>
					</div>
					<!-- // 결제 -->
					<% If OATPersonalLogIng_idx <> "" Or OATPersonalLogBefore_idx <> "" Then %>
					<p class="btn_link"><a href="javascript:goOATTest('<%=OATPersonalLogBefore_idx%>','<%=OATPersonalLogIng_idx%>');"><img src="http://image.career.co.kr/career_new/button/btn_test_sup02.gif" alt="적성검사 신청" /></a></p>
					<% Else %>
					<p class="btn_link"><a href="javascript:ok_submit();"><img src="http://image.career.co.kr/career_new/button/btn_test_sup02.gif" alt="적성검사 신청" /></a></p>
					<% End If %>
				</form>

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
    <!-- 푸터 -->
   <% Call putFooter() %>
    <!--// 푸터 -->
    <hr />