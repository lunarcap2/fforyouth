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

Dim SiteCode
SiteCode = getSiteCode(Request.ServerVariables("SERVER_NAME"))

dbCon.Open Application("DBInfo")

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

'�����˻� �˻� �Ϸ� ���
dim ArrOATPersonalLogAfterList
Call getOATPersonalLogAfterList(dbCon, ArrOATLogParams, ArrOATPersonalLogAfterList, "", "")

dbCon.Close

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

Dim OATPersonalLogAfter_Count,OATPersonalLogAfter_idx
If IsArray(ArrOATPersonalLogAfterList) = True Then
	OATPersonalLogAfter_Count = CInt(UBound(ArrOATPersonalLogAfterList,2)) + 1
	OATPersonalLogAfter_idx = Trim(ArrOATPersonalLogAfterList(0,0))
Else
	OATPersonalLogAfter_Count = 0
	OATPersonalLogAfter_idx = ""
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
                        <h4 class="oci"><img src="http://image.career.co.kr/career_new/my/tit_oat_test.gif" alt="�����˻�"/></h4>
                    </div>
 
                  <p class="mt_10"><img src="http://image.career.co.kr/career_new/my/img_oat_test_start.jpg" alt="�� �˻�ð��� 115�а� ���� �˴ϴ�."/></p>
 
				  <p class="mt_25 tc"><a href="javascript:goOATTestStart('<%=OATPersonalLogBefore_idx%>','<%=OATPersonalLogIng_idx%>');"><img src="http://image.career.co.kr/career_new/button/btn_test_oat_start.gif" alt="�����˻縦 �����մϴ�."/></a></p>
				  <div class="test_report_txt">
				  <img src="http://image.career.co.kr/career_new/common/icon_point.gif" alt="" class="vm" /> ������ ��� Ǯ�� <span class="fc_red">����������</span>�� �Ѿ�� <span class="fc_red">���� ������ �ٽ� Ǯ��</span> �� �� �����ϴ�.<br /><strong>�����ϰ� �˻翡 ���Ͻñ� �ٶ��ϴ�.</strong>
				  </div>
				  <hr />
				<div class="title_comm_info mt_25">
					<h4><img src="http://image.career.co.kr/career_new/my/tit_oat_exam.gif" alt="�����˻� ���俹��"/></h4>
			    </div>
 
				<p class="mt_10"><img src="http://image.career.co.kr/career_new/my/img_oat_exam.gif" alt="�����˻� ���俹��"/></p>
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