<%
Option Explicit

g_MenuID = "110027"
%>
<!--#include virtual = "/common/common.asp"-->
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
'�μ��˻� ������ �޾ƿ�
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'�μ��˻� ���ηα� ���
Dim ArrOCILogParams
redim ArrOCILogParams(1)
ArrOCILogParams(0) = SiteCode
ArrOCILogParams(1) = user_id

'�μ��˻� �˻� �� ���
dim ArrOCIPersonalLogBeforeList
Call getOCIPersonalLogBeforeList(dbCon, ArrOCILogParams, ArrOCIPersonalLogBeforeList, "", "")

'�μ��˻� �˻� �� ���
dim ArrOCIPersonalLogIngList
Call getOCIPersonalLogIngList(dbCon, ArrOCILogParams, ArrOCIPersonalLogIngList, "", "")

dbCon.Close
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'�μ��˻� ������ ����
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Dim OCIPersonalLogBefore_Count,OCIPersonalLogBefore_idx
If IsArray(ArrOCIPersonalLogBeforeList) = True Then
	OCIPersonalLogBefore_Count = CInt(UBound(ArrOCIPersonalLogBeforeList,2)) + 1
	OCIPersonalLogBefore_idx = Trim(ArrOCIPersonalLogBeforeList(0,0))
Else
	OCIPersonalLogBefore_Count = 0
	OCIPersonalLogBefore_idx = ""
End If

Dim OCIPersonalLogIng_Count,OCIPersonalLogIng_idx
If IsArray(ArrOCIPersonalLogIngList) = True Then
	OCIPersonalLogIng_Count = CInt(UBound(ArrOCIPersonalLogIngList,2)) + 1
	OCIPersonalLogIng_idx = Trim(ArrOCIPersonalLogIngList(0,0))
Else
	OCIPersonalLogIng_Count = 0
	OCIPersonalLogIng_idx = ""
End If
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'����
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
   price = 4400
Else
   price = 7700
End IF
%>
    <hr />
<SCRIPT LANGUAGE="JavaScript">
<!--
var price = "<%=price%>";
var user_mile = "<%=user_mile%>";
//-->
</SCRIPT>
<script language="javascript" src="/js/user/cat.js"></script>
<script language="javascript" src="/js/user/bill_sat.js"></script>
    <!-- �߰� -->
    <div id="career_container">
        <div id="career_2col_L">

			<!-- �߰� ������ -->
            <div id="career_contents">
                <!-- ��� ���� -->
                <div id="career_tops">
                    <div id="career_tms">
 
                        <div class="my_comm_top">
                            <h4><img src="http://image.career.co.kr/career_new/my/tit_career_test.gif" alt="Ŀ���� �μ��˻�" /></h4>
                        </div>
                        <div class="billing_top02 cat_test_bg">
                            <ul class="cf_txt24">
								<li>���� �μ������˻�� <strong>�����ɸ� ��������� ORP������</strong>�� �������� ���� �� ���ߵǾ����ϴ�.</li>
							</ul>
                            <p class="h5_resume"><img src="http://image.career.co.kr/career_new/my/tt_test_guide.gif" alt="Ŀ���� �μ��˻� [OCI]�� Ư¡" /></p>
                            <p class="pro_consulting">
                            <img src="http://image.career.co.kr/career_new/my/img_oci_guide.gif" alt="-�μ��˻翡�� �� ������ �����, �̷�����, ������ȭ �� ���� �μ��� �󸶳� �������� �����ݴϴ�. -�μ������� ������ ������ ������� ���Ͽ� ���� ��/������ ������ Ȯ���� �� �ֽ��ϴ�.-�μ��˻�� ���� ������� �� ����������� ���� ����ϰ� �ִ� ��������� �μ� ���ܰ˻������� ����ϰ� ������, �� 26���� ������ ������ Ȯ���� �� �ֽ��ϴ�." /></p>

							<!-- <p class="cf_txt20"><img src="http://image.career.co.kr/career_new/info/tt_oci_end.gif" alt="Ŀ���� �������˻�� 2014�� 1�� 29�ϱ��� ���� �Ǹ� ���� ���񽺰� ����˴ϴ�" /></p> -->
                        </div>
 
                    </div>
                </div>
                <!--// ��ܿ��� -->

                <div class="cb"></div>
                <hr />

                <!-- center -->
                <div id="center">
				<form name="frm11" method="post">
				<input type="hidden" name="chkV" value="1">
				<input type="hidden" name="svc" value="OCI">
				<input type="hidden" name="svc_gb" value="sat">
                    <div class="title_comm_info mt_15">
                        <h4 class="no_line"><img src="http://image.career.co.kr/career_new/my/tit_oci_com.gif" alt="�μ��˻� ����"/></h4>
                    </div>

                  <p><img src="http://image.career.co.kr/career_new/my/bg_oci_table.gif" alt=""/></p>
				  <hr />

					<div class="title_comm_info mt_25">
                        <h4 class="no_line"><img src="http://image.career.co.kr/career_new/my/tit_oci_mat.gif" alt="�μ��˻� ��� �� ���ǻ���"/></h4>
                    </div>

                  <div class="test_report_box">
				  <img src="http://image.career.co.kr/career_new/my/bg_oci_mat.gif" alt=""/>
				  <p class="txt2"><span class="fs_12">��</span>�˻縦 �����ϴ� �� �������� ���ų� �ٸ� �������� �̵��� ���, <strong>������������ �˻��������� ���������������� ����</strong>�˴ϴ�.<br />
  &nbsp;&nbsp;-�˻��û�� Ŭ���ϸ� �˻縦 �ߴ��ϼ̴� �������� ù��° �������� �ٽ� ���۵˴ϴ�.</p>
			      </div>
				  <hr />

				<div class="title_comm_info mt_25">
					<h4 class="no_line"><img src="http://image.career.co.kr/career_new/my/tit_report_info.gif" alt="�μ��˻� Report�ؼ� �� Ȱ����"/></h4>
			    </div>

				<div class="test_report_box">
					<ol class="ol_list">
					<li class="num1">���� �������� ���� �񱳿����� <strong>�� 4�� �������� ������ ����</strong>�˴ϴ�.</li>
					<li class="num2"><strong>�׷���</strong>�� ���ؼ� �ڽ��� ������ ���л� ���, �������� ��հ� � ���̰� �ִ� ���� �ľ��Ͻʽÿ�.</li>
					<li class="num3"><strong>����ǥ</strong>�� ���� ������ ������ Ȯ���ϰ�, <strong>���յ� �������</strong>�� Ȯ���Ͻʽÿ�. (�ſ����� > ���� > ���� > ����)</li>
					<li class="num4"><strong>������ ���� �� �׷���</strong>�� ���� �ڽ��� ������ ������ ���л� ���, �������� ��հ� � ���̰� �ִ� ���� �ľ��Ͻʽÿ�.</li>
					<li class="num5">���� ��������� ���� ���õ� ������ �������Ǹ� �ڼ��� �о ����, <strong>�ڽ��� ���� ���������� ���յ� ��������� Ȯ��</strong>�Ͻʽÿ�.</li>
					<li class="num6">�� ���յ� ��������� ���� <strong>�ش� ������ ���� ����</strong>�� �ٽ� �� �� �о��, �ڽ��� ������ ��������, ������ ���� �������� Ȯ���Ͻʽÿ�.</li>
					</ol>
					<p class="txt1">�� �μ��˻��� Ư���� �� �˻翡 ���õ� ���л� ��հ� �������� ��� ������ ���� ������ �� �� �����ϴ�. ����θ� Ȱ���� �ֽʽÿ�.</p>
					<p class="txt3"><strong>[ �μ��˻� Sample ]</strong></p>
					<ul class="ques_exm">
					<li class="first">
					<dl>
					<dt><img src="http://image.career.co.kr/career_new/my/img_report_oci_ex01.gif" alt="��������ȭ�� " /></dt>
					<dd>[ ��������ȭ�� ]</dd>
					<!--dd class="btn_sample"><a href="#"><img src="http://image.career.co.kr/career_new/button/btn_zoom_view.gif" alt="Ȯ�뺸��" /></a></dd-->
					</dl>
					</li>
					<li>
					<dl>
					<dt><img src="http://image.career.co.kr/career_new/my/img_report_oci_ex02.gif" alt="�˻��� ����1 " /></dt>
					<dd>[ �˻��� ����1 ]</dd>
					<dd class="btn_sample"><a href="#none" onclick="javascript:window.open('/my/cat/pop_oci_zoom1.asp','pop_oci_zoom1','width=752, height=563, top=100, left=200, scrollbars=no')"><img src="http://image.career.co.kr/career_new/button/btn_zoom_view.gif" alt="Ȯ�뺸��" /></a></dd>
					</dl>
					</li>
					<li>
					<dl>
					<dt><img src="http://image.career.co.kr/career_new/my/img_report_oci_ex03.gif" alt="�˻��� ����2" /></dt>
					<dd>[ �˻��� ����2 ]</dd>
					<dd class="btn_sample"><a href="#none" onclick="javascript:window.open('/my/cat/pop_oci_zoom2.asp','pop_oci_zoom2','width=752, height=563, top=100, left=200, scrollbars=no')"><img src="http://image.career.co.kr/career_new/button/btn_zoom_view.gif" alt="Ȯ�뺸��" /></a></dd>
					</dl>
					</li>
					</ul>
				</div>
				<hr />
				<!-- ���� -->
					<div class="payment_s payment payment_top">
						<dl class="appl">
							<dt><img src="http://image.career.co.kr/career_new/company/product/img_application_tit.gif" alt="�� ��û�ݾ�" /><strong><span id="display_amt1"><%=FormatNumber(price, 0)%></span></strong><img src="http://image.career.co.kr/career_new/company/product/img_won.gif" alt="��" /></dt>
							<dd class="end"><strong class="point">����Ʈ</strong><input type="text" id="" name="amt_point" style="width:98px;text-align:right;" onfocus="onFocus(this)" onblur="onBlur(this);pointChk();" onKeyUp="point_Cal();" class="inputOff" /><input type="hidden" name="amt_point2"><span class="mlr_5_18">��</span>������ ����Ʈ : <span class="acc"><%=formatnumber(user_mile,0)%></span>�� <span class="fc_acc">(100�� ������ ��� ����)</span><input type="checkbox" name="pointYN" id="au" class="chk_md" onclick="chk_Point(this);"/><label for="au">����Ʈ�θ� �����ϱ�</label></dd>
						</dl>
						<dl class="sum">
							<dt><img src="http://image.career.co.kr/career_new/company/product/img_payment_tit.gif" alt="�� �����ݾ�" /><input type="hidden" name="amt" value="<%=price%>"><input type="hidden" name="amt2" value="<%=price%>"><input type="hidden" name="amt3" value="<%=price%>"><strong><span id="display_amt2"><%=FormatNumber(price, 0)%></span></strong><img src="http://image.career.co.kr/career_new/company/product/img_won.gif" alt="��" /><img src="http://image.career.co.kr/career_new/company/product/img_tex.gif" alt="�ΰ��� ����" class="ml_6"/></dt>
							<dd class="acc"><strong class="point">�������� ����Ʈ</strong> : <input type="hidden" name="plus_point" value="0"><strong class="won"><span id="display_point">0</span></strong>��</dd>
							<dd class="acc02">
							<ul class="method">
							    <li><span class="ie6_gap"><input type="radio" id="hp" name="billtype" value="7" /><label for="hp">�޴���</label></span></li>
								<li><span class="ie6_gap"><input type="radio" id="cd" name="billtype" value="1" /><label for="cd">ī�����</label></span></li>
								<li><span class="ie6_gap"><input type="radio" id="at" name="billtype" value="6" /><label for="at">�ǽð� ������ü<input type="radio" id="po" name="billtype" value="4" style="display:none;"/><input type="hidden" name="billtype2"></label></span></li>
								<li><a href="javascript:canselbill();"><img src="http://image.career.co.kr/career_new/button/btn_blu_cancel.gif" alt="���" /></a></li>
								<li><span class="mt_2"><a href="javascript:openwin('/my/billing/payment_guide.asp', 'bill', 580,700);"><img src="http://image.career.co.kr/career_new/company/product/btn_pay_guide.gif" alt="�������ܺ� �ȳ�" /></a></span></li>
							</ul>
								<p class="txt_point">���������� �����Ͻ� �� �Ʒ� <span class="b">[�μ��˻� ��û]</span> ��ư�� Ŭ���� �ּ���</p>
								</dd>
						</dl>
					</div>
					<!-- // ���� -->
					<% If OCIPersonalLogIng_idx <> "" Or OCIPersonalLogBefore_idx <> "" Then %>
					<p class="btn_link"><a href="javascript:goOCITest('<%=OCIPersonalLogBefore_idx%>','<%=OCIPersonalLogIng_idx%>');"><img src="http://image.career.co.kr/career_new/button/btn_test_sup.gif" alt="�μ��˻� ��û" /></a></p>
					<% else %>
					<p class="btn_link"><a href="javascript:ok_submit();"><img src="http://image.career.co.kr/career_new/button/btn_test_sup.gif" alt="�μ��˻� ��û" /></a></p>
					<% End If %>
				</form>
				<SCRIPT LANGUAGE="JavaScript">
				<!--
					sum_price();
				//-->
				</SCRIPT>


					<!--<p class="mt_25"><img src="http://image.career.co.kr/career_new/info/img_oci_end.gif" alt="Ŀ���� �μ������˻� ���� �ȳ� - Ŀ���� �μ������˻� ���ް� ����Ǿ� 1�� 28�� ���� ���� �˴ϴ� �̿��� �̴ּ����� �е鲲 ���� ��Ź �帳�ϴ�" /></p>-->

                </div>
                <!--// center -->
            </div>
            <!--// �߰� ������ -->
        </div>
        <!--// career_2col_L -->
    </div>
    <!--// career_container -->
    <!--// �߰� -->