<script type="text/javascript">
	
	//÷������ ����
	function fn_portfolio_upload(obj) {
		/*
		$���.index()
		$���.index($���)
		$���.index(���DOM)
		index �� ���ϴ� ������� 3���� ������ �ִ�.
		index() �޼��带 �̿��ϸ� ��尡 ��ġ�� �ε��� ���� �� �� �ֽ��ϴ�.
		*/
		
		var file_index = $("input[name='portfolio_file_upload']").index($(obj));
		var pre_file = $(obj).prevAll("#pf_upload_file").val();

		$('#file_index').val(file_index);
		$('#pre_file_name').val(pre_file);

//		$('#fileUploadForm').attr('accept-charset', 'utf-8');
		document.charset = "euc-kr";
		$('#fileUploadForm').attr('accept-charset', 'euc-kr');
		$('#uploadFile').click();
	}

	//÷������ ����Ϸ��
	function fn_portfolio_upload_result(_result, _index, _origin_file, _upload_file, pop_msg) {
		if (_result == "1") {
			$("input[name='pf_file_name']").eq(_index).val(_origin_file);
			$("input[name='pf_origin_file']").eq(_index).val(_origin_file);
			$("input[name='pf_upload_file']").eq(_index).val(_upload_file);
		} else {
			//$("input[name='pf_file_name']").eq(_index).val("");
			//$("input[name='pf_origin_file']").eq(_index).val("");
			//$("input[name='pf_upload_file']").eq(_index).val("");
			alert(pop_msg);
		}
	}
	
	//÷������ ����
	function fn_file_del(obj, file_seq) {
		var pre_file = $(obj).prevAll(".filebox").children("#pf_upload_file").val();
		$('#del_file_name').val(pre_file);
		$('#del_file_seq').val(file_seq);
		$('#filedelForm').submit();
	}

</script>

<div class="input_box" id ="resume11">
	<p class="ib_tit">��Ʈ������</p>
	<div class="ib_list add_portfolio">
		<div class="ib_move non">
			<!-- <div class="deleteBox">����</div> -->
			<div class="ib_m_box">

				<div class="ib_add url">
				<%
				seq = 0
				If isArray(arrPortfolio) Then
					For i=0 To UBound(arrPortfolio, 2)
						If arrPortfolio(1, i) = "1" Then
						seq = seq + 1
				%>
					<div>
						<input type="hidden" id="portfolio_type1" name="portfolio_type1" value="1" />
						<input type="text" id="pf_url_addr" name="pf_url_addr" class="txt" placeholder="" value="<%=arrPortfolio(2, i)%>" style="width:605px;">
						<button type="button" class="btn_remove">����</button>
					</div>
				<%
						End If
					Next
				End If
				%>

				<% If seq = 0 Then %>
					<div>
						<input type="hidden" id="portfolio_type1" name="portfolio_type1" value="1" />
						<input type="text" id="pf_url_addr" name="pf_url_addr" class="txt" placeholder="" value="" style="width:605px;">
						<button type="button" class="btn_remove">����</button>
					</div>
				<% End If %>

				</div>
				<button type="button" class="ib_add_btn url">URL �߰�</button>

				<div class="ib_add file">
				<%
				seq = 0
				If isArray(arrPortfolio) Then
					For i=0 To UBound(arrPortfolio, 2)
						If arrPortfolio(1, i) = "2" Then
						seq = seq + 1
				%>
					<div>
						<span class="filebox">
							<span>ã�ƺ���</span>
							<input type="hidden" id="portfolio_type2" name="portfolio_type2" value="1" />
							<input type="hidden" id="pf_origin_file" name="pf_origin_file" value="<%=arrPortfolio(3, i)%>" />
							<input type="hidden" id="pf_upload_file" name="pf_upload_file" value="<%=arrPortfolio(4, i)%>" />
							<input type="text" class="txt" name="pf_file_name" disabled="disabled" style="width:605px;" value="<%=arrPortfolio(3, i)%>">
							<input type="text" class="txt file" id="portfolio_file_upload" name="portfolio_file_upload" onclick="fn_portfolio_upload(this);">
						</span>
						<button type="button" class="btn_remove" onclick="fn_file_del(this, '<%=arrPortfolio(0, i)%>');">����</button>
					</div>
				<%
						End If
					Next
				End If
				%>

				<% If seq = 0 Then %>
					<div>
						<span class="filebox">
							<span>ã�ƺ���</span>
							<input type="hidden" id="portfolio_type2" name="portfolio_type2" value="1" />
							<input type="hidden" id="pf_origin_file" name="pf_origin_file" value="" />
							<input type="hidden" id="pf_upload_file" name="pf_upload_file" value="" />
							<input type="text" class="txt" name="pf_file_name" disabled="disabled" style="width:605px;" value="">
							<input type="text" class="txt file" id="portfolio_file_upload" name="portfolio_file_upload" onclick="fn_portfolio_upload(this);">
						</span>
						<button type="button" class="btn_remove" onclick="fn_file_del(this, '');">����</button>
					</div>
				<% End If %>

				</div>
				<button type="button" class="ib_add_btn file">�����߰�</button>
			</div>
		</div>
	</div>
</div><!-- ��Ʈ������ -->