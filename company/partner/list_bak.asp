<%
option Explicit

'------ ������ �⺻���� ����.
g_MenuID = "010001"  '�� �� ���ڴ� lnb ��������, �� �� ���ڴ� �޴� �̹��� ���ϸ� ����
g_MenuID_Navi = "5,1"  '������̼� ��
%>

<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header.asp"-->

<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/inc/function/paging.asp"-->
<%
ConnectDB DBCon, Application("DBInfo")
	
	Dim page, pageSize, orderNum, totalCnt, stropt, totalPage, i, ii
	page = CInt(Request("page"))
	pageSize = CInt(Request("pageSize"))
	orderNum = CInt(Request("orderNum"))

	If page = "0" Then page = 1
	If pageSize = "0" Then pageSize = 10
	If orderNum = "0" Then orderNum = 3

	Dim schArea, schKw
	schArea = Request("schArea")
	schArea = Replace(schArea, " ", "")
	schKw = Request("schKw")
	schKw = Replace(schKw, "���»� ������� �Է����ּ���.", "")

	Dim spName, arrRs
	ReDim param(6)
	spName = "USP_HKPARTNER_COMPANY_LIST"

	param(0) = makeParam("@BizNum", adVarchar, adParamInput, 10, "")
	param(1) = makeParam("@BizName", adVarchar, adParamInput, 200, schKw)
	param(2) = makeParam("@BizArea", adVarchar, adParamInput, 2000, schArea)
	param(3) = makeParam("@OrderNum", adInteger, adParamInput, 4, orderNum)
	param(4) = makeParam("@Page", adInteger, adParamInput, 4 , page)
	param(5) = makeParam("@PageSize", adInteger, adParamInput, 4 , pageSize)
	param(6) = makeParam("@TotalCnt", adInteger, adParamOutput, 4 , 0)

	arrRs = arrGetRsSP(dbCon, spName, param, "", "")
	totalCnt = getParamOutputValue(param, "@TotalCnt")
	totalPage = (totalCnt / pageSize) + 1

	stropt = "schKw=" & schKw & "&schArea=" & schArea
	'Response.write schArea

DisconnectDB DBCon
%>
<script type="text/javascript">
	$(document).ready(function () {
		// ��ü�� ������ưó�� ����ϱ� ����
		$("input:checkbox[name='schArea']").click(function() {
			if ($("input:checkbox[name=schArea][value='']").prop("checked")) {
				$("input:checkbox[name=schArea]").prop("checked",false);
				$(this).prop("checked", true);

				checkboxFnc(); //üũ�ڽ�
			}
		});

		var r_schArea
		r_schArea = "<%=schArea%>";

		var arr	= new Array();
		arr = r_schArea.split(",");

		for (i = 0; i < arr.length; i++) {
			if (arr[i].indexOf("����") != -1) {
				arr[i] = "����,���,��õ";
			}

			$("input:checkbox[name=schArea][value='"+arr[i]+"']").prop("checked",true);
		}
		
		checkboxFnc(); //üũ�ڽ�
	});
</script>
</head>

<body>
<!-- ��� -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->

<!-- ���� -->
<div id="contents" class="sub_page">
	<div class="sub_visual partner">
		<div class="visual_area">
			<h2><img src="../../images/company/h2_partner.png" alt="���»�"></h2>
		</div>
	</div>
	<div class="content">
		<div class="con_box">
			<div class="partner_area">
				<form id="frm" name="frm" method="get">

				<div class="areaArea">
					<ul>
						<li>
							<label class="checkbox" for="schArea1">
								<input type="checkbox" id="schArea1" class="chk" name="schArea" value="">
									<span>��ü</span>
							</label>
						</li>
						<li>
							<label class="checkbox off" for="schArea2">
								<input type="checkbox" id="schArea2" class="chk" name="schArea" value="����,���,��õ">
									<span>����.���.��õ</span>
							</label>
						</li>
						<li>
							<label class="checkbox off" for="schArea3">
								<input type="checkbox" id="schArea3" class="chk" name="schArea" value="�λ�">
									<span>�λ�</span>
							</label>
						</li>
						<li>
							<label class="checkbox off" for="schArea4">
								<input type="checkbox" id="schArea4" class="chk" name="schArea" value="�뱸">
									<span>�뱸</span>
							</label>
						</li>
						<li>
							<label class="checkbox off" for="schArea5">
								<input type="checkbox" id="schArea5" class="chk" name="schArea" value="����">
									<span>����</span>
							</label>
						</li>
						<li>
							<label class="checkbox off" for="schArea6">
								<input type="checkbox" id="schArea6" class="chk" name="schArea" value="����">
									<span>����</span>
							</label>
						</li>
						<li>
							<label class="checkbox off" for="schArea7">
								<input type="checkbox" id="schArea7" class="chk" name="schArea" value="���">
									<span>���</span>
							</label>
						</li>
						<li>
							<label class="checkbox off" for="schArea8">
								<input type="checkbox" id="schArea8" class="chk" name="schArea" value="����">
									<span>����</span>
							</label>
						</li>
						<li>
							<label class="checkbox off" for="schArea9">
								<input type="checkbox" id="schArea9" class="chk" name="schArea" value="����">
									<span>������</span>
							</label>
						</li>
						<li>
							<label class="checkbox off" for="schArea10">
								<input type="checkbox" id="schArea10" class="chk" name="schArea" value="�泲">
									<span>��󳲵�</span>
							</label>
						</li>
						<li>
							<label class="checkbox off" for="schArea11">
								<input type="checkbox" id="schArea11" class="chk" name="schArea" value="���">
									<span>���ϵ�</span>
							</label>
						</li>
						<li>
							<label class="checkbox off" for="schArea12">
								<input type="checkbox" id="schArea12" class="chk" name="schArea" value="����">
									<span>���󳲵�<span>
							</label>
						</li>
						<li>
							<label class="checkbox off" for="schArea13">
								<input type="checkbox" id="schArea13" class="chk" name="schArea" value="����">
									<span>����ϵ�</span>
							</label>
						</li>
						<li>
							<label class="checkbox off" for="schArea14">
								<input type="checkbox" id="schArea14" class="chk" name="schArea" value="�泲">
									<span>��û����</span>
							</label>
						</li>
						<li>
							<label class="checkbox off" for="schArea15">
								<input type="checkbox" id="schArea15" class="chk" name="schArea" value="���">
									<span>��û�ϵ�</span>
							</label>
						</li>
						<li>
							<label class="checkbox off" for="schArea16">
								<input type="checkbox" id="schArea16" class="chk" name="schArea" value="����">
									<span>���ֵ�</span>
							</label>
						</li>
					</ul>
				</div>

				<div class="searchArea">
					<div class="searchInner">
						<div class="fl">
							<p class="total">�� <span><%=FormatNumber(totalCnt, 0)%></span>���� ���»� ������ �ֽ��ϴ�.</p>
						</div><!--.fl-->

						<div class="fr">
							<div class="searchBox">
								<div class="inp">
									<input class="txt value" id="schKw" name="schKw" type="text" default="���»� ������� �Է����ּ���." value="<%=schKw%>" style="width:465px;">
									<button type="button" class="btn typegray" onclick="document.frm.submit();"><strong>�˻�</strong></button>
								</div><!-- .inp -->
							</div><!-- .searchBox -->
						</div><!--.fr-->

					</div><!--.searchInner-->
				</div><!-- //searchArea--->

				</form>

				<div class="list_area">
					<ul>
					<%
					If isArray(arrRs) Then 
						For i=0 To UBound(arrRs, 2)
						Dim bizGubun : bizGubun = ""
						Dim bizIPO : bizIPO = ""

						If arrRs(21, i) = "Y" Then bizGubun = "����è�Ǿ�"
						If arrRs(20, i) = "Y" Then bizGubun = "���ұ��"
						If arrRs(19, i) = "Y" Then bizGubun = "�߰߱��"

						Select Case arrRs(18, i)
							Case "1" : bizGubun = "����"
							Case "2" : bizGubun = "�����"
							Case "3" : bizGubun = "������"
						End Select

						Select Case arrRs(5, i)
							Case "10" : bizIPO = "�ڽ���"
							Case "21" : bizIPO = "�ڽ���"
							Case "30" : bizIPO = "�ܰ�"
						End Select
						
						'10=����
						'15=�������
						'20=���
						'21=�ڽ���
						'23=�ڽ��ڰ���, 
						'30=�ܰ�
						'40=�Ϲ�
						'50=�߼�
						'60=����
						'70=�����, 
						'91=������պ�
						'92=���
						'93=û��
						'99=��Ÿ

						Dim intSales_CY : intSales_CY = ""
						intSales_CY = getCompanyMoney_Text(CCur(arrRs(15, i)))
					%>
						<li>
							<div class="info_box">
								<div class="la_logo">
									<div class="logo_box">
										<div class="logo">
											<% If arrRs(17, i) <> "" Then %>
											<a href="./view.asp?bizNum=<%=arrRs(1, i)%>"><img src="<%=arrRs(17, i)%>" alt="���»� ȸ�� �ΰ�"></a>
											<% End If %>
										</div>
									</div>
								</div>
								<div class="la_info">
									<div class="tit">
										<p><a href="./view.asp?bizNum=<%=arrRs(1, i)%>"><%=arrRs(2, i)%></a></p>
										<div class="company_icon">
											<% If bizGubun <> "" Then %>
											<em class="icon i-middle on"><%=bizGubun%></em>
											<% End If %>
											<% If bizIPO <> "" Then %>
											<em class="icon i-kosdaq on"><%=bizIPO%></em>
											<% End If %>
										</div>
									</div>
									<dl>
										<dt>�����⵵ :</dt>
										<dd><%=Left(arrRs(4, i), 4)%>�� / �������� : <%=arrRs(7, i)%>��</dd>
										<dt>����� :</dt>
										<dd><%=intSales_CY%> (<%=year(date)-1%>�� ����)</dd>
										<dt>�ֿ��� :</dt>
										<dd><%=arrRs(8, i)%></dd>
									</dl>
								</div>
							</div>
						</li>
					<%
						Next
					End if
					%>
					</ul>
				</div><!-- //list_area -->

				<!--����¡-->
				<% Call putPage(Page, stropt, totalPage) %>

			</div>
		</div>
	</div><!-- .content -->
</div>
<!-- //���� -->

<!-- �ϴ� -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- �ϴ� -->
</body>
</html>