<%
Option Explicit

Response.Expires = -1

g_MenuID = "110027"
%>
<!--#include virtual = "/common/common.asp"-->
<% Call FN_LoginLimit("1")    '����ȸ���� ���ٰ��� %>
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
'�����˻� ������ �޾ƿ�
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'�����˻� ���ηα� ���
Dim ArrOATLogParams
redim ArrOATLogParams(1)
ArrOATLogParams(0) = SiteCode
ArrOATLogParams(1) = user_id

'�����˻� �˻� �� ���
dim ArrOATPersonalLogBeforeList
Call getOATPersonalLogBeforeList(dbCon, ArrOATLogParams, ArrOATPersonalLogBeforeList, "", "")

'�����˻� �˻� �� ���
dim ArrOATPersonalLogIngList
Call getOATPersonalLogIngList(dbCon, ArrOATLogParams, ArrOATPersonalLogIngList, "", "")

dbCon.Close
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'�����˻� ������ ����
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
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
   price = 5500
Else
   price = 9900
End IF
%>
<%
Call FN_LoginLimit("1")
%>
<% Call putTopNew("") %>
<SCRIPT LANGUAGE="JavaScript">
<!--
var price = "<%=price%>";
var user_mile = "<%=user_mile%>";
//-->
</SCRIPT>
<script language="javascript" src="/js/user/cat.js"></script>
<script language="javascript" src="/js/user/bill_sat.js"></script>
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

							<!-- <p class="cf_txt21"><img src="http://image.career.co.kr/career_new/info/tt_oci_end.gif" alt="Ŀ���� �������˻�� 2014�� 1�� 29�ϱ��� ���� �Ǹ� ���� ���񽺰� ����˴ϴ�" /></p> -->
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
				<form name="frm11" method="post">
				<input type="hidden" name="chkV" value="1">
				<input type="hidden" name="svc" value="OAT">
				<input type="hidden" name="svc_gb" value="sat">
                    <div class="title_comm_info mt_15">
                        <h4 class="no_line"><img src="http://image.career.co.kr/career_new/my/tit_oat_com.gif" alt="�����˻� ����"/></h4>
                    </div>

                  <p><img src="http://image.career.co.kr/career_new/my/bg_oat_table.gif" alt=""/></p>
				  <hr />

					<div class="title_comm_info mt_25">
                        <h4 class="no_line"><img src="http://image.career.co.kr/career_new/my/tit_oat_mat.gif" alt="�����˻� ��� �� ���ǻ���"/></h4>
                    </div>

                  <div class="test_report_box">
				  <img src="http://image.career.co.kr/career_new/my/bg_oat_mat.gif" alt=""/>
				  <p class="txt2"><span class="fs_12">��</span>�˻縦 �����ϴ� �� �������� ���ų� �ٸ� �������� �̵��� ���, <strong>������������ �˻��� ���� ��������� ����</strong>�˴ϴ�.<br />
  &nbsp;&nbsp;-�˻��û�� Ŭ���ϸ� �˻縦 �ߴ��ϼ̴� ������ 1������ �ٽ� �����մϴ�.</p>
			      </div>
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
					<p class="txt1">�� �����˻��� Ư���� �� �˻翡 ���õ� ���л� ��հ� �������� ��� ������ ���� ������ �� �� �����ϴ�. ����θ� Ȱ���� �ֽʽÿ�.</p>
					<p class="txt3"><strong>[ �����˻� Sample ]</strong></p>
					<ul class="ques_exm">
					<li class="first">
					<dl>
					<dt><img src="http://image.career.co.kr/career_new/my/img_report_oat_ex01.gif" alt="��������ȭ��" /></dt>
					<dd>[ ��������ȭ�� ]</dd>
					<!--dd class="btn_sample"><a href="#"><img src="http://image.career.co.kr/career_new/button/btn_zoom_view.gif" alt="Ȯ�뺸��" /></a></dd-->
					</dl>
					</li>
					<li>
					<dl>
					<dt><img src="http://image.career.co.kr/career_new/my/img_report_oat_ex02.gif" alt="�˻��� ����1" /></dt>
					<dd>[ �˻��� ����1 ]</dd>
					<dd class="btn_sample"><a href="#none" onclick="javascript:window.open('/my/cat/pop_oat_zoom1.asp','pop_oat_zoom1','width=752, height=563, top=100, left=200, scrollbars=no')"><img src="http://image.career.co.kr/career_new/button/btn_zoom_view.gif" alt="Ȯ�뺸��" /></a></dd>
					</dl>
					</li>
					<li>
					<dl>
					<dt><img src="http://image.career.co.kr/career_new/my/img_report_oat_ex03.gif" alt="�˻��� ����2" /></dt>
					<dd>[ �˻��� ����2 ]</dd>
					<dd class="btn_sample"><a href="#none" onclick="javascript:window.open('/my/cat/pop_oat_zoom2.asp','pop_oat_zoom2','width=752, height=563, top=100, left=200, scrollbars=no')"><img src="http://image.career.co.kr/career_new/button/btn_zoom_view.gif" alt="Ȯ�뺸��" /></a></dd>
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
								<p class="txt_point">���������� �����Ͻ� �� �Ʒ� <span class="b">[�����˻� ��û]</span> ��ư�� Ŭ���� �ּ���</p>
								</dd>
						</dl>
					</div>
					<!-- // ���� -->
					<% If OATPersonalLogIng_idx <> "" Or OATPersonalLogBefore_idx <> "" Then %>
					<p class="btn_link"><a href="javascript:goOATTest('<%=OATPersonalLogBefore_idx%>','<%=OATPersonalLogIng_idx%>');"><img src="http://image.career.co.kr/career_new/button/btn_test_sup02.gif" alt="�����˻� ��û" /></a></p>
					<% Else %>
					<p class="btn_link"><a href="javascript:ok_submit();"><img src="http://image.career.co.kr/career_new/button/btn_test_sup02.gif" alt="�����˻� ��û" /></a></p>
					<% End If %>
				</form>

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
    <!-- Ǫ�� -->
   <% Call putFooter() %>
    <!--// Ǫ�� -->
    <hr />