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
	alert("�߸��� ȣ���Դϴ�.");
	window.close();
	</script>
	<%
	response.end
End if

dbCon.Open Application("DBInfo_FAIR")

'�����˻� ���� �ܰ�
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
NowStepReturnValue = execOATTestNowStep(dbCon, ArrNowStepParams, "", "",NextManageIdx,NextPage,NextRemainTime)

If NowStepReturnValue = "-100" Then
	%>
	<script language="javascript">
	alert("���� ������ �����ϴ�.");
	window.close();
	</script>
	<%
	response.End
ElseIf NowStepReturnValue = "-200" Then
	%>
	<script language="javascript">
	alert("�̹� �˻縦 �Ϸ��� �׸��Դϴ�.");
	window.close();
	</script>
	<%
	response.End
ElseIf NowStepReturnValue = "-300" Then
	%>
	<script language="javascript">
	alert("�̹� �˻縦 �Ϸ��� �׸��Դϴ�.");
	window.close();
	</script>
	<%
	response.End
End If

'�����˻� ���� ��������
Dim ArrManageParams
redim ArrManageParams(0)
ArrManageParams(0) = NextManageIdx

dim ArrOATManageInfo
Call getOATManageInfo(dbCon, ArrManageParams, ArrOATManageInfo, "", "")

dbCon.Close

Dim Manage_idx,Manage_Name,Manage_Total_Page,Manage_Total_Question,Manage_Total_Time
If IsArray(ArrOATManageInfo) = True Then
	Manage_idx = Trim(ArrOATManageInfo(0,0))
	Manage_Name = Trim(ArrOATManageInfo(3,0))
	Manage_Total_Page = Trim(ArrOATManageInfo(4,0))
	Manage_Total_Question = Trim(ArrOATManageInfo(5,0))
	Manage_Total_Time	 = Trim(ArrOATManageInfo(6,0))
Else
	%>
	<script language="javascript">
	alert("�������� �����˻簡 �����ϴ�.");
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
		if (document.getElementById) {
			resizeIframe(iframeids[i])
		}

		if ((document.all || document.getElementById) && iframehide=="no") {
			var tempobj=document.all? document.all[iframeids[i]] : document.getElementById(iframeids[i])
			tempobj.style.display="block"
        }
    }
}

function resizeIframe(frameid) {
    var currentfr=document.getElementById(frameid);
    if (currentfr && !window.opera) {
        currentfr.style.display="block"
		if (currentfr.contentDocument && currentfr.contentDocument.body.offsetHeight) { //ns6 syntax
	        currentfr.height = currentfr.contentDocument.body.offsetHeight+FFextraHeight;
		}
		else if (currentfr.Document && currentfr.Document.body.scrollHeight) { //ie5+ syntax
			currentfr.height = currentfr.Document.body.scrollHeight;
		}

	    if (currentfr.addEventListener) {
	        currentfr.addEventListener("load", readjustIframe, false)
		}
	    else if (currentfr.attachEvent) {
		    currentfr.detachEvent("onload", readjustIframe) // Bug fix line
			currentfr.attachEvent("onload", readjustIframe)
        }
		document.body.scrollTop = 0;
		document.documentElement.scrollTop = 0;
    }
}

function readjustIframe(loadevt) {
    var crossevt=(window.event)? event : loadevt
    var iframeroot=(crossevt.currentTarget)? crossevt.currentTarget : crossevt.srcElement
    if (iframeroot)
        resizeIframe(iframeroot.id);
}

function loadintoIframe(iframeid, url)
{
	if (document.getElementById)
	{
		document.getElementById(iframeid).src=url
	}
}

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


//���� �ð� ���
<%
'������ ���� ���϶�
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
			alert("���� ����ð��� ����Ǿ����ϴ�.");
			window.frames.iframe_content.goNextPageFail();
			
			//iframe_content.goNextPageFail();
			/*
			iframe_content.document.getElementById('isFail').value = "1";
			iframe_content.document.getElementById('RemainTime').value = "0";
			iframe_content.document.getElementById('Page').value = "<%=Manage_Total_Page%>";
			iframe_content.document.form1.submit();
			*/
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
				<img src="http://image.career.co.kr/career_new4/my/aptitude_test_h1.png" alt="Ŀ���� �����˻�">
				<span><strong>- 108 </strong>(����)</span>
			</h1>
			<p>�� 6�� ������ ������ �� ������ �ڱ� ������ ��/������ Ȯ���� �� �ֽ��ϴ�.</p>

			<div class="timeArea">
				<ul>
					<li><p>�˻�ð��� �� �ؼ��Ͻñ� �ٶ��ϴ�.</p></li>
					<li><p>����ð� : </p><span id="TotalTime">59:12</span>
						<button class="btnStop" type="submit" onclick="layerOpen('layerFile');fnStopTime('on');">stop</button>
						<button class="btnPlay" type="submit" onclick="fnStopTime('off');">play</button>
					</li>
				</ul>
			</div>
		</div>
	</div><!-- #header-id -->
	<!--// HEADER -->

	<!-- ���� ���� -->
	<input type="hidden" id="RemainTime" name="RemainTime" value="" />
	<iframe id="iframe_content" name="iframe_content" src="oat_question.asp?idx=<%=idx%>" width="100%" frameborder="0" scrolling="no" title="�����˻� OAT"></iframe>
	<script>ChangeTotalTimeInit();</script>
	<!--// ���� ���� -->

</body>

	<!-- �Ͻ����� ���̾��˾� -->
	<div class="layerPop test">
		<div id="layerFile" class="popWrap coupon">
			<div class="inner">
				<div class="popHead">
				</div><!-- .popHead -->
				<div class="popCon">
					<div class="popTest">
						<p>�������̴� �˻簡 �Ͻ����� �Ǿ����ϴ�.</p>
						<button class="closeBtn" onclick="fnStopTime('off');">�ٽý���</button>
					</div>
				</div><!-- .popCon -->
			</div><!-- .inner -->
		</div><!--.popWrap-->
		<span class="dim"></span><!--.dim-->
	</div><!-- .layerPop -->
	<!--// �Ͻ����� ���̾��˾� -->