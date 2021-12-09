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

dim idx
idx = Trim(Request("idx"))

If idx = "" Then
	%>
	<script language="javascript">
	alert("잘못된 호출입니다.");
	location.href="default.asp";
	</script>
	<%
	response.End
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
                         <h4 class="oci"><img src="http://image.career.co.kr/career_new/my/tit_oat_test.gif" alt="적성검사 OAT [Occupational Aptitude Test]"/></h4>
                    </div>

                  <p class="mt_10"><img src="http://image.career.co.kr/career_new/my/img_test_oat_finish.jpg" alt="적성검사가 모두 끝났습니다. 시험에 응시하시느라 고생 많으셨습니다. 하단에 검사결과 보기를 클릭하시면 검사 결과를 보실 수 있습니다."/></p>
				  <% If InStr(Request.ServerVariables("SERVER_NAME"),"old.career.co.kr") > 0 Or InStr(Request.ServerVariables("SERVER_NAME"),"job.daum.net") > 0 Then %>
					<p class="mt_25 tc"><a href="javascript:goOATResult('real','<%=idx%>');"><img src="http://image.career.co.kr/career_new/button/btn_test_result.gif" alt="검사결과 보기"/></a></p>
				  <% Else %>
					<p class="mt_25 tc"><a href="javascript:goOATResult('test','<%=idx%>');"><img src="http://image.career.co.kr/career_new/button/btn_test_result.gif" alt="검사결과 보기"/></a></p>
				  <% End If %>
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
				</div>
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