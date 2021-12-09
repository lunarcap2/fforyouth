<%
Option Explicit
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->

<!--#include virtual = "/wwwconf/query_lib/my/CAT_Info.asp"-->
<!--#include virtual = "/wwwconf/function/my/CAT_Function.asp"-->
<%
Call FN_LoginLimit("1")

dim idx
idx = Trim(Request("idx"))

If idx = "" Then
	%>
	<script language="javascript">
	alert("잘못된 호출입니다.");
	window.close();
	</script>
	<%
	response.End
End If
%>

<link href="//old.career.co.kr/css/comm_2016.css" rel="stylesheet" type="text/css" />
<link href="//old.career.co.kr/css/my_2017.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="/js/my_2017.js"></script>
<script type="text/javascript" src="//old.career.co.kr/js/user/cat.js"></script>

<script type="text/javascript">
	function fn_goOATResult(val) {
		location.href = "/my/cat/oat_result.asp?idx=" + val;
	}
</script>

<body id="myWrap" class="myTest">

	<!-- HEADER -->
	<div id="header-id">
		<div class="header test">
			<h1>
				<img src="http://image.career.co.kr/career_new4/my/aptitude_test_h1.png" alt="커리어 적성검사">
				<span><strong>- 108 </strong>(문항)</span>
			</h1>
			<p>총 6개 적성을 진단할 수 있으며 자기 적성의 강/약점을 확인할 수 있습니다.</p>

		</div>
	</div><!-- #header-id -->



	<!-- CONTENTS 2017 -->
    <div id="career_container"  class="personalityTestWrap"><!-- 2017/03/02/hjyu -->
        <div id="career_contents">
			<div class="textEnd">
				<p>
					적성검사가 모두 끝났습니다.
					<span>아래 <strong>검사결과보기</strong>를 클릭하시면 회원님의 검사결과를 즉시 확인할 수 있습니다.</span>
				</p>
				<div class="btnWrap">
					<button type="submit" class="btn typeOrange" onclick="fn_goOATResult('<%=idx%>');">검사결과 보기</button>
				</div>
			</div>
			<!-- //textEnd -->

			<dl class="testWay">
				<dt><span>적성검사</span> <em>Report</em>해석 및 활용방법</dt>
				<dd>
					<ul>
						<li>
							<em>-</em> 먼저 역량군별 점수 비교에서는 <strong>총 6개 적성영역(검사)에 대한 점수가 제시</strong>됩니다.
						</li>
						<li>
							<em>-</em> <strong>그래프</strong>를 통해각 <strong>적성영역별 자신의 점수를 확인</strong>하십시오. 각 점수는 계산 공식에 의해 <strong>100점 만점으로 환산</strong>된 점수입니다.
						</li>
						<li>
							<em>-</em> 각 적성영역별 등급을 확인하고, 등급표를 통해 <strong>해당 등급이 어떤 수준을 말하는 것인지 파악</strong>하십시오.
						</li>
						<li>
							<em>-</em> 적성영역별 관리 직무표에서 각 적성영역 중 <strong>4등급 이상인 적성에 해당하는 별표에 동그라미</strong>를 그리십시오. 4등급 이상의 적성이 없거나 부족하다면,  6등급 이상인 적성에 해당하는 별표에 다른 표시를 하십시오.
						</li>
					 
						<li><em>-</em> 각 직무별로 보았을 때, 표시된 <strong>별표가 많은 직무가 당신에게 적합한 직무</strong>라 할 수 있습니다.</li>
						<li><em>-</em> 강약점 분석 표를 통해 <strong>자신의 강점 적성과 약점 적성을 확인</strong>하십시오.</li>
						<li><em>-</em> Recommendation을 통해 <strong>약점 적성의 개발 방향을 확인</strong>하십시오. 한번 보고 잊어버리기 보다는 아무리 사소한 방법이라도 기억하고 실천해보십시오.
					  작성(능력)은 노력여하에 따라 개선/개발이 가능합니다.</li>
					  </ul>
				</dd>
			</dl>
			<!-- //testWay -->

		</div><!--#career_contents-->
    </div><!-- #career_container -->
    <!-- //CONTENTS 2016 -->

</body>