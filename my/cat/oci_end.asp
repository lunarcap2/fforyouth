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
	function fn_goOCIResult(val) {
		location.href = "/my/cat/oci_result.asp?idx=" + val;
	}
</script>

<body id="myWrap" class="myTest">

	<!-- HEADER -->
	<div id="header-id">
		<div class="header test">
			<h1>
				<img src="http://image.career.co.kr/career_new4/my/personality_test_h1.png" alt="커리어 인성검사">
				<span><strong>- 104 </strong>(문항)</span>
			</h1>
			<p>역량기반 인성진단 검사형식으로 총 26개의 역량별 수준을 확인할 수 있습니다.</p>

		</div>
	</div><!-- #header-id -->



	<!-- CONTENTS 2017 -->
    <div id="career_container"  class="personalityTestWrap"><!-- 2017/03/02/hjyu -->
        <div id="career_contents">
			<div class="textEnd">
				<p>
					인성검사가 모두 끝났습니다.
					<span>아래 <strong>검사결과보기</strong>를 클릭하시면 회원님의 검사결과를 즉시 확인할 수 있습니다.</span>
				</p>
				<div class="btnWrap">
					<button type="submit" class="btn typeOrange" onclick="fn_goOCIResult('<%=idx%>');">검사결과 보기</button>
				</div>
			</div>
			<!-- //textEnd -->

			<dl class="testWay">
				<dt><span>인성검사</span> <em>Report</em>해석 및 활용방법</dt>
				<dd>
					<ul>
						<li>
							<em>-</em> 먼저 역량군별 점수 비교에서는 <strong>총 4개 역량군별 점수가 제시</strong>됩니다.
						</li>
						<li>
							<em>-</em> <strong>그래프</strong>를 통해서 자신의 점수가 대학생 평균, 현직장인 평균과 어떤 차이가 있는지를 파악하십시오.
						</li>
						<li>
							<em>-</em> <strong>점수표</strong>를 통해 각각의 점수를 확인하고, <strong>적합도 판정결과</strong>를 확인하십시오. (매우적합 > 적합 > 보통 > 미흡)
						</li>
						<li>
							<em>-</em> <strong>역량별 점수 비교 그래프</strong>를 통해 자신의 역량별 점수가 대학생 평균, 현직장인 평균과 어떤 차이가있는 지를 파악하십시오.
						</li>
						<li>
							<em>-</em> 세부 결과에서는 각각 제시된 역량과 역량정의를 자세희 읽어본 다음, <strong>자신의 각각 역량점수와 적합도 판정결과를 확인</strong>하십시오.
						</li>
						<li>
							<em>-</em> 각 적합도 판정결과에 따라 <strong>해당 역량에 대한 정의</strong>를 다시 한 번 읽어보고, 자신의 강점이 무엇인지, 부족한 점이 무엇인지 확인하십시오.
						</li>
					</ul>
				</dd>
			</dl>
			<!-- //testWay -->

		</div><!--#career_contents-->
    </div><!-- #career_container -->
    <!-- //CONTENTS 2016 -->

</body>