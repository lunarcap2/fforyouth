<%
Option Explicit
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->

<!--#include virtual = "/wwwconf/query_lib/my/CAT_Info.asp"-->
<!--#include virtual = "/wwwconf/function/my/CAT_Function.asp"-->

<link href="//old.career.co.kr/css/reset_2015.css" rel="stylesheet" type="text/css" />
<link href="//old.career.co.kr/css/comm_2016.css" rel="stylesheet" type="text/css" />
<link href="//old.career.co.kr/css/my_2017.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="//old.career.co.kr/js/my_2017.js"></script>

<%
Call FN_LoginLimit("1")

Dim SiteCode
SiteCode = getSiteCode(Request.ServerVariables("SERVER_NAME"))

Dim idx
idx = Request("idx")

If idx = "" Then
	%>
	<script language="javascript">
	alert("잘못된 호출입니다.");
	window.close();
	</script>
	<%
	response.end
End if

dbCon.Open Application("DBInfo_FAIR")

'인성검사 현재 단계
Dim ArrNowStepParams
redim ArrNowStepParams(2)
ArrNowStepParams(0) = SiteCode
ArrNowStepParams(1) = idx
ArrNowStepParams(2) = user_id

'response.write ArrNowStepParams(0) & "<br>"
'response.write ArrNowStepParams(1) & "<br>"
'response.write ArrNowStepParams(2) & "<br>"
'response.end

Dim NextManageIdx,NextPage,NextRemainTime
Dim NowStepReturnValue
NowStepReturnValue = execOCITestNowStep(dbCon, ArrNowStepParams, "", "",NextManageIdx,NextPage,NextRemainTime)

If NowStepReturnValue = "-100" Then
	%>
	<script language="javascript">
	window.onbeforeunload="";
	alert("결제 내역이 없습니다.");
	window.close();
	</script>
	<%
	response.End
ElseIf NowStepReturnValue = "-200" Then
	%>
	<script language="javascript">
	window.onbeforeunload="";
	alert("이미 검사를 완료한 항목입니다.");
	window.close();
	</script>
	<%
	response.End
ElseIf NowStepReturnValue = "-300" Then
	%>
	<script language="javascript">
	window.onbeforeunload="";
	alert("이미 검사를 완료한 항목입니다.");
	window.close();
	</script>
	<%
	response.End
End If


'Response.write NowStepReturnValue
'response.end


'인성검사 관리 진행정보
Dim ArrManageParams
redim ArrManageParams(0)
ArrManageParams(0) = NextManageIdx

dim ArrOCIManageInfo
Call getOCIManageInfo(dbCon, ArrManageParams, ArrOCIManageInfo, "", "")

dbCon.Close

Dim Manage_idx,Manage_Name,Manage_Total_Page,Manage_Total_Question,Manage_Total_Time
If IsArray(ArrOCIManageInfo) = True Then
	Manage_idx = Trim(ArrOCIManageInfo(0,0))
	Manage_Name = Trim(ArrOCIManageInfo(3,0))
	Manage_Total_Page = Trim(ArrOCIManageInfo(4,0))
	Manage_Total_Question = Trim(ArrOCIManageInfo(5,0))
	Manage_Total_Time	 = Trim(ArrOCIManageInfo(6,0))
Else
	%>
	<script language="javascript">
	window.onbeforeunload="";
	alert("진행중인 인성검사가 없습니다.");
	window.close();
	</script>
	<%
	response.end
End If
%>

<script type="text/Javascript">
var iframeids=["iframe_content"]
var iframehide="yes"

var getFFVersion=navigator.userAgent.substring(navigator.userAgent.indexOf("Firefox")).split("/")[1]
var FFextraHeight=getFFVersion>=0.1? 16 : 20 //extra height in px to add to iframe in FireFox 1.0+ browsers

function resizeCaller() {
    var dyniframe=new Array()
    for (i=0; i<iframeids.length; i++) {
		if (document.getElementById)
	        resizeIframe(iframeids[i])
		if ((document.all || document.getElementById) && iframehide=="no") {
			var tempobj=document.all? document.all[iframeids[i]] : document.getElementById(iframeids[i])
			tempobj.style.display="block"
        }
    }
}

function resizeIframe(frameid){
    var currentfr=document.getElementById(frameid)
    if (currentfr && !window.opera){
        currentfr.style.display="block"
    if (currentfr.contentDocument && currentfr.contentDocument.body.offsetHeight) //ns6 syntax
        currentfr.height = currentfr.contentDocument.body.offsetHeight+FFextraHeight;
    else if (currentfr.Document && currentfr.Document.body.scrollHeight) //ie5+ syntax
        currentfr.height = currentfr.Document.body.scrollHeight;
    if (currentfr.addEventListener)
        currentfr.addEventListener("load", readjustIframe, false)
    else if (currentfr.attachEvent){
        currentfr.detachEvent("onload", readjustIframe) // Bug fix line
        currentfr.attachEvent("onload", readjustIframe)
        }
    }
}

function readjustIframe(loadevt) {
    var crossevt=(window.event)? event : loadevt
    var iframeroot=(crossevt.currentTarget)? crossevt.currentTarget : crossevt.srcElement
    if (iframeroot)
        resizeIframe(iframeroot.id);
}

function loadintoIframe(iframeid, url){
    if (document.getElementById)
        document.getElementById(iframeid).src=url
    }
    if (window.addEventListener)
        window.addEventListener("load", resizeCaller, false)
    else if (window.attachEvent)
        window.attachEvent("onload", resizeCaller)
    else
        window.onload=resizeCaller

//Window Event
if (window.addEventListener)
{
	window.addEventListener("load", resizeCaller, false);
}
else if (window.attachEvent)
{
	window.attachEvent("onload", resizeCaller);
}
else
{
	window.onload=resizeCaller;
}

//남은 시간 계산
<%
'페이지 진행 중일때
if NextRemainTime <> "" then
	%>
	var countdownfrom = parseInt("<%=NextRemainTime%>") + 1;
	<%
else
	%>
	var countdownfrom = parseInt("<%=Manage_Total_Time%>") + 1;
	<%
end if
%>
//var currentsecond = 5;
var currentsecond=countdownfrom;

function ChangeTotalTimeInit()
{
	document.getElementById('TotalTime').innerHTML=countdownfrom;
	document.getElementById('RemainTime').value=countdownfrom;
	ChangeTotalTime();
}

var onStopTime = 0
function fnStopTime(val)
{
	if (val == "on")
	{
		onStopTime = 1
	}
	else if (val == "off")
	{
		onStopTime = 0
		ChangeTotalTime();
	}
}


function ChangeTotalTime()
{
	if (onStopTime == 0)
	{
		if (currentsecond!=0)
		{
			currentsecond-=1
			var viewsecond = (currentsecond - parseInt(currentsecond/60)*60);
			if(viewsecond < 10)
			{
				document.getElementById('TotalTime').innerHTML=parseInt(currentsecond/60) + ":0" + viewsecond;
			}
			else
			{
				document.getElementById('TotalTime').innerHTML=parseInt(currentsecond/60) + ":" + viewsecond;
			}
			document.getElementById('RemainTime').value = document.getElementById('RemainTime').value - 1;
		}
		else
		{
			alert("과목 시험시간이 종료되었습니다.");
			
			window.frames.iframe_content.goNextPageFail();
			
			//iframe_content.goNextPageFail();

			//iframe_content.document.getElementById('isFail').value = "1";
			//iframe_content.document.getElementById('RemainTime').value = "0";
			//iframe_content.document.getElementById('Page').value = "<%=Manage_Total_Page%>";
			//iframe_content.document.form1.submit();
			return;
		}
		setTimeout("ChangeTotalTime()",1000);
	}
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

			<div class="timeArea">
				<ul>
					<li><p>검사시간을 꼭 준수하시기 바랍니다.</p></li>
					<li><p>시험시간 : </p><span id="TotalTime">59:12</span>
						<button class="btnStop" type="submit" onclick="layerOpen('layerFile'); fnStopTime('on');">stop</button>
						<button class="btnPlay" type="submit" onclick="fnStopTime('off');">play</button>
					</li>
				</ul>
			</div>
		</div>
	</div><!-- #header-id -->
	<!--// HEADER -->
    <!-- CONTENTS 2017 -->
    <div id="career_container"  class="personalityTestWrap"><!-- 2017/03/02/hjyu -->

        <!-- RNB -->
        <div id="rnb" class="rnbWrap test">
			<div class="testSel">
				<dl class="rnbSel">
					<dt>- 점수예시 -</dt>
					<dd>① 전혀 그렇지 못하다.</dd>                    
					<dd>② 그렇지 못하다.</dd>
					<dd>③ 조금 그렇지 못하다.</dd>
					<dd>④ 약간 그렇다.</dd>
					<dd>⑤ 그렇다.</dd>
					<dd>⑥ 매우 그렇다.</dd>
				</dl>
				<a href="javascript:;" class="btnTop"><img src="http://image.career.co.kr/career_new4/my/page_top.png" alt="top버튼"></a>
			</div>
		</div>
        <!--// RNB -->

        <div id="career_contents">
			
			<p class="testMent">
				각 질문을 잘 읽고 평소 본인이 얼마나 그러한지의 정도를 <span><em>1</em>점(전혀 그렇지 않다)</span>
				에서 <span><em>6</em>점(매우 그렇다)</span>사이에서 선택해 주십시오.<br> 질문에 너무 오랜시간 고민하기 보다는 바로 떠오르는 생각에 따라 솔직하게 응답해 주십시오.
			</p> 

			<div class="ExampleArea">
				<dl class="Example">
					<dt>점수예시 : </dt>
					<dd>① 전혀 그렇지 못하다.</dd>                    
					<dd>② 그렇지 못하다.</dd>
					<dd>③ 조금 그렇지 못하다.</dd>
					<dd>④ 약간 그렇다.</dd>
					<dd>⑤ 그렇다.</dd>
					<dd>⑥ 매우 그렇다.</dd>
				<dl>
			</div>
			<!-- ExampleArea -->

			<!-- 문제 영역 -->
			<input type="hidden" id="RemainTime" name="RemainTime" value="">
			<iframe id="iframe_content" name="iframe_content" src="oci_question.asp?idx=<%=idx%>" width="100%" frameborder="0" scrolling="no" title="인성검사 OCI"></iframe>
			<script>ChangeTotalTimeInit();</script>
			<!--// 문제 영역 -->

		</div><!--#career_contents-->
    </div><!-- #career_container -->
    <!-- //CONTENTS 2016 -->
    <!-- FOOTER 2015 - 전체공통 -->
    <div class="footer-wrap" id="footer-id">
	</div><!-- .footer-wrap -->
    <!-- //FOOTER 2015 -->

	<!-- 일시정지 레이어팝업 -->
	<div class="layerPop test">
		<div id="layerFile" class="popWrap coupon">
			<div class="inner">
				<div class="popHead">
				</div><!-- .popHead -->
				<div class="popCon">
					<div class="popTest">
						<p>진행중이던 검사가 일시정지 되었습니다.</p>
						<button class="closeBtn" onclick="fnStopTime('off');">다시시작</button>
					</div>
				</div><!-- .popCon -->
			</div><!-- .inner -->
		</div><!--.popWrap-->
		<span class="dim"></span><!--.dim-->
	</div><!-- .layerPop -->
	<!--// 일시정지 레이어팝업 -->

</body>