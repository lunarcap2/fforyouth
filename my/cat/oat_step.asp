<%
Option Explicit

Response.Expires = -1
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
	alert("�߸��� ȣ���Դϴ�.");
	location.href="default.asp";
	</script>
	<%
	response.End
End If

'���ηα� ���� ��ȸ
Dim ArrOATLogParams
redim ArrOATLogParams(1)
ArrOATLogParams(0) = idx
ArrOATLogParams(1) = user_id

dbCon.Open Application("DBInfo_FAIR")

dim ArrOATPersonalLogInfo
Call getOATPersonalLogInfo(dbCon, ArrOATLogParams, ArrOATPersonalLogInfo, "", "")

dbCon.Close

If IsArray(ArrOATPersonalLogInfo) = False Then
	%>
	<script language="javascript">
	alert("�߸��� ȣ���Դϴ�.");
	location.href="default.asp";
	</script>
	<%
	response.End
End If


Dim stepNum, stepInfo
If IsArray(ArrOATPersonalLogInfo) = True Then
	stepNum = Trim(ArrOATPersonalLogInfo(6,0))
	If stepNum = "0" Or stepNum = "10" Then
		stepInfo = 1
	ElseIf stepNum = "11" Or stepNum = "20" Then
		stepInfo = 2
	ElseIf stepNum = "21" Or stepNum = "30" Then
		stepInfo = 3
	ElseIf stepNum = "31" Or stepNum = "40" Then
		stepInfo = 4
	ElseIf stepNum = "41" Or stepNum = "50" Then
		stepInfo = 5
	ElseIf stepNum = "51" Or stepNum = "60" Then
		stepInfo = 6
	End If
End If
%>

<link href="//old.career.co.kr/css/reset_2015.css" rel="stylesheet" type="text/css" />
<link href="//old.career.co.kr/css/comm_2016.css" rel="stylesheet" type="text/css" />
<link href="//old.career.co.kr/css/my_2017.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="//old.career.co.kr/js/my_2017.js"></script>
<script type="text/javascript" src="//old.career.co.kr/js/user/cat.js"></script>

<body id="myWrap" class="myTest">

	<!-- HEADER -->
	<div id="header-id">
		<div class="header test">
			<h1>
				<img src="http://image.career.co.kr/career_new4/my/aptitude_test_h1.png" alt="Ŀ���� �����˻�">
				<span><strong>- 108 </strong>(����)</span>
			</h1>
			<p>�� 6�� ������ ������ �� ������ �ڱ� ������ ��/������ Ȯ���� �� �ֽ��ϴ�.</p>

		</div>
	</div><!-- #header-id -->
	<!--// HEADER -->

	<!-- CONTENTS 2017 -->
    <div id="career_container"  class="aptitudeTestWrap"><!-- 2017/03/02/hjyu -->

        <div id="career_contents">
			<div class="titArea ready">
				<h2>
					<% Select case stepInfo %>
					<% Case 1 %> <em class="round">STEP. 1</em>�������<span>(Verbal Comprehension)</span>
					<% Case 2 %> <em class="round">STEP. 2</em>����߸�<span>(Verbal Reasoning)</span>
					<% Case 3 %> <em class="round">STEP. 3</em>�ڷ��ؼ�<span>(Data Analyzing)</span>
					<% Case 4 %> <em class="round">STEP. 4</em>�����߸�<span>(Quantitative Reasoning)</span>
					<% Case 5 %> <em class="round">STEP. 5</em>������<span>(Numerical Operation)</span>
					<% Case 6 %> <em class="round">STEP. 6</em>��������<span>(Special Perception)</span>
					<% End Select %>
				</h2>

				<div class="testItemBox">
					<ul>
						<li <% If stepInfo = 1 Then %>class="on"<% End If %>>
							<em class="round">�������</em>
							<p class="value"><strong class="num">20</strong> (��)</p>
						</li>
						<li <% If stepInfo = 2 Then %>class="on"<% End If %>>
							<em class="round">����߸�</em>
							<p class="value"><strong class="num">20</strong> (��)</p>
						</li>
						<li <% If stepInfo = 3 Then %>class="on"<% End If %>>
							<em class="round">�ڷ��ؼ�</em>
							<p class="value"><strong class="num">20</strong> (��)</p>
						</li>
						<li <% If stepInfo = 4 Then %>class="on"<% End If %>>
							<em class="round">�����߸�</em>
							<p class="value"><strong class="num">20</strong> (��)</p>
						</li>
						<li <% If stepInfo = 5 Then %>class="on"<% End If %>>
							<em class="round">������</em>
							<p class="value"><strong class="num">20</strong> (��)</p>
						</li>
						<li <% If stepInfo = 6 Then %>class="on"<% End If %>>
							<em class="round">��������</em>
							<p class="value"><strong class="num">20</strong> (��)</p>
						</li>
						<li class="equals">
							<em class="round">�Ѱ˻�ð�</em>
							<p class="value"><strong class="num">115</strong> (��)</p>
						</li>
					</ul>
				</div>
				<!-- //testItemBox -->
			</div>
			<!-- //titArea -->
			
			<div class="timeName">
				<p>
				<% Select case stepInfo %>
					<% Case 1 %>
						�����˻� ù �ð��� <strong>�������</strong>�Դϴ�.
						<span>������ ������ ���� �ܰ�� �Ѿ �� �ٷ� �Ѿ�� ���ð�, ��� ��ȣ���� �Ͻ� �Ŀ� �����ܰ� �׽�Ʈ�� �����ϼ���.</span>
					<% Case 2 %>
						�̹� �ð��� <strong>����߸�</strong>�Դϴ�.
						<span>������ ������ ���� �ܰ�� �Ѿ �� �ٷ� �Ѿ�� ���ð�, ��� ��ȣ���� �Ͻ� �Ŀ� �����ܰ� �׽�Ʈ�� �����ϼ���.</span>
					<% Case 3 %>
						�̹� �ð��� <strong>�ڷ��ؼ�</strong>�Դϴ�.
						<span>������ ������ ���� �ܰ�� �Ѿ �� �ٷ� �Ѿ�� ���ð�, ��� ��ȣ���� �Ͻ� �Ŀ� �����ܰ� �׽�Ʈ�� �����ϼ���.</span>
					<% Case 4 %>
						�̹� �ð��� <strong>�����߸�</strong>�Դϴ�.
						<span>������ ������ ���� �ܰ�� �Ѿ �� �ٷ� �Ѿ�� ���ð�, ��� ��ȣ���� �Ͻ� �Ŀ� �����ܰ� �׽�Ʈ�� �����ϼ���.</span>
					<% Case 5 %>
						�̹� �ð��� <strong>������</strong>�Դϴ�.
						<span>������ ������ ���� �ܰ�� �Ѿ �� �ٷ� �Ѿ�� ���ð�, ��� ��ȣ���� �Ͻ� �Ŀ� �����ܰ� �׽�Ʈ�� �����ϼ���.</span>
					<% Case 6 %>
						�̹� �ð��� <strong>��������</strong>�Դϴ�.
						<span>������ �ð��� ��ŭ ������ �̸� �ŵ� �� �ֵ��� �ּ��� ���Ͻñ� �ٶ��ϴ�. ���� Ǯ�� ħ���ϰ� �����ϼ���.</span>
				<% End Select %>
				</p>
				<div class="btnWrap">
					<button type="submit" class="btn typeOrange" onclick="javascript:location.href='oat_frame.asp?idx=<%=idx%>'">�˻� �����ϱ�</button>
				</div>
			</div>
			<div class="testCare">
				<p>
					�� ������ ��� Ǯ�� ������������ �Ѿ�� <strong>���� ������ �ٽ� Ǯ�� �� �� �����ϴ�.</strong>
					<span>�����ϰ� �˻翡 ���Ͻñ� �ٶ��ϴ�.</span>
				</p>
			</div>

		</div><!--#career_contents-->
    </div><!-- #career_container -->
    <!-- //CONTENTS 2016 -->

</body>