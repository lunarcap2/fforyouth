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
	alert("�߸��� ȣ���Դϴ�.");
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
				<img src="http://image.career.co.kr/career_new4/my/personality_test_h1.png" alt="Ŀ���� �μ��˻�">
				<span><strong>- 104 </strong>(����)</span>
			</h1>
			<p>������� �μ����� �˻��������� �� 26���� ������ ������ Ȯ���� �� �ֽ��ϴ�.</p>

		</div>
	</div><!-- #header-id -->



	<!-- CONTENTS 2017 -->
    <div id="career_container"  class="personalityTestWrap"><!-- 2017/03/02/hjyu -->
        <div id="career_contents">
			<div class="textEnd">
				<p>
					�μ��˻簡 ��� �������ϴ�.
					<span>�Ʒ� <strong>�˻�������</strong>�� Ŭ���Ͻø� ȸ������ �˻����� ��� Ȯ���� �� �ֽ��ϴ�.</span>
				</p>
				<div class="btnWrap">
					<button type="submit" class="btn typeOrange" onclick="fn_goOCIResult('<%=idx%>');">�˻��� ����</button>
				</div>
			</div>
			<!-- //textEnd -->

			<dl class="testWay">
				<dt><span>�μ��˻�</span> <em>Report</em>�ؼ� �� Ȱ����</dt>
				<dd>
					<ul>
						<li>
							<em>-</em> ���� �������� ���� �񱳿����� <strong>�� 4�� �������� ������ ����</strong>�˴ϴ�.
						</li>
						<li>
							<em>-</em> <strong>�׷���</strong>�� ���ؼ� �ڽ��� ������ ���л� ���, �������� ��հ� � ���̰� �ִ����� �ľ��Ͻʽÿ�.
						</li>
						<li>
							<em>-</em> <strong>����ǥ</strong>�� ���� ������ ������ Ȯ���ϰ�, <strong>���յ� �������</strong>�� Ȯ���Ͻʽÿ�. (�ſ����� > ���� > ���� > ����)
						</li>
						<li>
							<em>-</em> <strong>������ ���� �� �׷���</strong>�� ���� �ڽ��� ������ ������ ���л� ���, �������� ��հ� � ���̰��ִ� ���� �ľ��Ͻʽÿ�.
						</li>
						<li>
							<em>-</em> ���� ��������� ���� ���õ� ������ �������Ǹ� �ڼ��� �о ����, <strong>�ڽ��� ���� ���������� ���յ� ��������� Ȯ��</strong>�Ͻʽÿ�.
						</li>
						<li>
							<em>-</em> �� ���յ� ��������� ���� <strong>�ش� ������ ���� ����</strong>�� �ٽ� �� �� �о��, �ڽ��� ������ ��������, ������ ���� �������� Ȯ���Ͻʽÿ�.
						</li>
					</ul>
				</dd>
			</dl>
			<!-- //testWay -->

		</div><!--#career_contents-->
    </div><!-- #career_container -->
    <!-- //CONTENTS 2016 -->

</body>