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
	alert("�߸��� ȣ���Դϴ�.");
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

            <!-- �߰� ������ -->
            <div id="career_contents">
                <!-- ��� ���� -->
                <div id="career_tops">
                    <div id="career_tms">
 
                        <div class="my_comm_top">
                            <h4><img src="http://image.career.co.kr/career_new/my/tit_career_test02.gif" alt="Ŀ���� �����˻�" /></h4>
                        </div>
                        <div class="billing_top02 cat_test_bg">
                            <ul class="cf_txt24">
								<li>���� �μ������˻�� <strong>�����ɸ� ��������� ORP������</strong>�� �������� ���� �� ���ߵǾ����ϴ�.</li>
							</ul>
                            <p class="h5_resume"><img src="http://image.career.co.kr/career_new/my/tt_test02_guide.gif" alt="Ŀ���� �����˻�  [OAT]�� Ư¡" /></p>
                            <p class="pro_consulting">
                            <img src="http://image.career.co.kr/career_new/my/img_oat_guide.gif" alt="-�����˻翡�� ���, ����, �߸�, ���������ɷ� �� �� ������� �ʿ��� �⺻���� �����ɷ� ���� ���ԵǾ�������, �� ������������ ����� �ɷ��� ���̴� ����� �����ϴµ� Ȱ��˴ϴ�. -�����˻� ����� ���� �� �ɷ��� �ʿ��� ������ �ڽ��� �󸶳� �������� �� �� �ֽ��ϴ�. -�پ��� �������� �� ���� �θ� ���Ǵ� ��6�� ������ ������ �� �ֵ��� �����Ǿ����ϴ�." /></p>

							<p class="cf_txt21"><img src="http://image.career.co.kr/career_new/my/tt_cat_test01.gif" alt="ä�뿡 �־ �μ������˻�� ���� �ʼ�����! ���ο��� Ŀ������ �μ������˻�� ������� �ϼ���!" /></p>
                        </div>
 
                    </div>

                    <div id="career_tr">
                        <!-- 250 ��� -->
                        <% Call putBanner() %>
                        <!-- 250 ��� -->
                    </div>
                </div>
                <!--// ��ܿ��� -->

                <div class="cb"></div>
                <hr />

                <!-- center -->
                <div id="center">
                    <div class="title_comm_info mt_15">
                         <h4 class="oci"><img src="http://image.career.co.kr/career_new/my/tit_oat_test.gif" alt="�����˻� OAT [Occupational Aptitude Test]"/></h4>
                    </div>

                  <p class="mt_10"><img src="http://image.career.co.kr/career_new/my/img_test_oat_finish.jpg" alt="�����˻簡 ��� �������ϴ�. ���迡 �����Ͻô��� ��� �����̽��ϴ�. �ϴܿ� �˻��� ���⸦ Ŭ���Ͻø� �˻� ����� ���� �� �ֽ��ϴ�."/></p>
				  <% If InStr(Request.ServerVariables("SERVER_NAME"),"old.career.co.kr") > 0 Or InStr(Request.ServerVariables("SERVER_NAME"),"job.daum.net") > 0 Then %>
					<p class="mt_25 tc"><a href="javascript:goOATResult('real','<%=idx%>');"><img src="http://image.career.co.kr/career_new/button/btn_test_result.gif" alt="�˻��� ����"/></a></p>
				  <% Else %>
					<p class="mt_25 tc"><a href="javascript:goOATResult('test','<%=idx%>');"><img src="http://image.career.co.kr/career_new/button/btn_test_result.gif" alt="�˻��� ����"/></a></p>
				  <% End If %>
				  <hr />
				<div class="title_comm_info mt_25">
					<h4 class="no_line"><img src="http://image.career.co.kr/career_new/my/tit_report_oat_info.gif" alt="�����˻� Report�ؼ� �� Ȱ����"/></h4>
			    </div>

				<div class="test_report_box">
					<ol class="ol_list">
					<li class="num1">���� �������� ���� �񱳿����� <strong>�� 6�� ��������(�˻�)�� ���� ������ ����</strong>�˴ϴ�.</li>
					<li class="num2"><strong>�׷���</strong>�� ���ذ� <strong>���������� �ڽ��� ������ Ȯ��</strong>�Ͻʽÿ�. �� ������ ��� ���Ŀ� ���� <strong>100�� �������� ȯ��</strong>�� �����Դϴ�.</li>
					<li class="num3">�� ���������� ����� Ȯ���ϰ�, ���ǥ�� ���� <strong>�ش� ����� � ������ ���ϴ� ������ �ľ�</strong>�Ͻʽÿ�.</li>
					<li class="num4">���������� ���� ����ǥ���� �� �������� �� <strong>4��� �̻��� ������ �ش��ϴ� ��ǥ�� ���׶��</strong>�� �׸��ʽÿ�.<br />4��� �̻��� ������ ���ų� �����ϴٸ�, 6��� �̻��� ������ �ش��ϴ� ��ǥ�� �ٸ� ǥ�ø� �Ͻʽÿ�.</li>
					<li class="num5">�� �������� ������ ��, ǥ�õ� <strong>��ǥ�� ���� ������ ��ſ��� ������ ����</strong>�� �� �� �ֽ��ϴ�.</li>
					<li class="num6">������ �м� ǥ�� ���� <strong>�ڽ��� ���� ������ ���� ������ Ȯ��</strong>�Ͻʽÿ�.</li>
					<li class="num7">Recommendation�� ���� <strong>���� ������ ���� ������ Ȯ��</strong>�Ͻʽÿ�. �ѹ� ���� �ؾ������ ���ٴ� �ƹ��� ����� ����̶� ����ϰ� ��õ�غ��ʽÿ�.<br />����(�ɷ�)�� ��¿��Ͽ� ���� ����/������ �����մϴ�.</li>
					</ol>
				</div>
				<hr />
				
                </div>
                <!--// center -->
            </div>
            <!--// �߰� ������ -->
        </div>
        <!--// career_2col_L -->
    </div>
    <!--// career_container -->
    <!--// �߰� -->
    <!-- Ǫ�� -->
   <% Call putFooter() %>
    <!--// Ǫ�� -->
    <hr />