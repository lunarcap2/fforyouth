<%
Option Explicit

Response.Expires = -1

g_MenuID = "110027"
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/function/common/fn_gnb.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/wwwconf/query_lib/my/CAT_Info.asp"-->
<!--#include virtual = "/wwwconf/function/my/CAT_Function.asp"-->

<!--#include virtual="/wwwconf/code/code_function.asp"-->
<!--#include virtual="/wwwconf/code/code_function_ac.asp"-->
<!--#include virtual="/wwwconf/code/code_function_jc.asp"-->
<!--#include virtual= "/wwwconf/code/codeToHtml.asp"-->
<%
Call FN_LoginLimit("1")

Dim SiteCode
SiteCode = getSiteCode(Request.ServerVariables("SERVER_NAME"))

dbCon.Open Application("DBInfo")

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

'적성검사 검사 완료 목록
dim ArrOATPersonalLogAfterList
Call getOATPersonalLogAfterList(dbCon, ArrOATLogParams, ArrOATPersonalLogAfterList, "", "")

dbCon.Close

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

Dim OATPersonalLogAfter_Count,OATPersonalLogAfter_idx
If IsArray(ArrOATPersonalLogAfterList) = True Then
	OATPersonalLogAfter_Count = CInt(UBound(ArrOATPersonalLogAfterList,2)) + 1
	OATPersonalLogAfter_idx = Trim(ArrOATPersonalLogAfterList(0,0))
Else
	OATPersonalLogAfter_Count = 0
	OATPersonalLogAfter_idx = ""
End If
%>
<% Call putTopNew("") %>
<script language="javascript" src="/js/user/cat.js"></script>
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

							<p class="cf_txt21"><img src="http://image.career.co.kr/career_new/my/tt_cat_test01.gif" alt="채용에 있어서 인성적성검사는 이제 필수사항! 새로워진 커리어의 인성적성검사로 성공취업 하세요!" /></p>
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
                    <div class="title_comm_info mt_15">
                        <h4 class="oci"><img src="http://image.career.co.kr/career_new/my/tit_oat_test.gif" alt="적성검사"/></h4>
                    </div>
 
                  <p class="mt_10"><img src="http://image.career.co.kr/career_new/my/img_oat_test_start.jpg" alt="총 검사시간은 115분간 진행 됩니다."/></p>
 
				  <p class="mt_25 tc"><a href="javascript:goOATTestStart('<%=OATPersonalLogBefore_idx%>','<%=OATPersonalLogIng_idx%>');"><img src="http://image.career.co.kr/career_new/button/btn_test_oat_start.gif" alt="적성검사를 시작합니다."/></a></p>
				  <div class="test_report_txt">
				  <img src="http://image.career.co.kr/career_new/common/icon_point.gif" alt="" class="vm" /> 문제를 모두 풀고 <span class="fc_red">다음페이지</span>로 넘어가면 <span class="fc_red">이전 문제는 다시 풀이</span> 할 수 없습니다.<br /><strong>신중하게 검사에 응하시기 바랍니다.</strong>
				  </div>
				  <hr />
				<div class="title_comm_info mt_25">
					<h4><img src="http://image.career.co.kr/career_new/my/tit_oat_exam.gif" alt="적성검사 응답예시"/></h4>
			    </div>
 
				<p class="mt_10"><img src="http://image.career.co.kr/career_new/my/img_oat_exam.gif" alt="적성검사 응답예시"/></p>
				<hr />
				
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