<script type="text/javascript">
	
	//첨부파일 저장
	function fn_portfolio_upload(obj) {
		/*
		$대상.index()
		$대상.index($대상)
		$대상.index(대상DOM)
		index 값 구하는 방법에는 3가지 종류가 있다.
		index() 메서드를 이용하면 노드가 위치한 인덱스 값을 알 수 있습니다.
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

	//첨부파일 저장완료시
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
	
	//첨부파일 삭제
	function fn_file_del(obj, file_seq) {
		var pre_file = $(obj).prevAll(".filebox").children("#pf_upload_file").val();
		$('#del_file_name').val(pre_file);
		$('#del_file_seq').val(file_seq);
		$('#filedelForm').submit();
	}

</script>

<div class="input_box" id ="resume11">
	<p class="ib_tit">포트폴리오</p>
	<div class="ib_list add_portfolio">
		<div class="ib_move non">
			<!-- <div class="deleteBox">삭제</div> -->
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
						<button type="button" class="btn_remove">삭제</button>
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
						<button type="button" class="btn_remove">삭제</button>
					</div>
				<% End If %>

				</div>
				<button type="button" class="ib_add_btn url">URL 추가</button>

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
							<span>찾아보기</span>
							<input type="hidden" id="portfolio_type2" name="portfolio_type2" value="1" />
							<input type="hidden" id="pf_origin_file" name="pf_origin_file" value="<%=arrPortfolio(3, i)%>" />
							<input type="hidden" id="pf_upload_file" name="pf_upload_file" value="<%=arrPortfolio(4, i)%>" />
							<input type="text" class="txt" name="pf_file_name" disabled="disabled" style="width:605px;" value="<%=arrPortfolio(3, i)%>">
							<input type="text" class="txt file" id="portfolio_file_upload" name="portfolio_file_upload" onclick="fn_portfolio_upload(this);">
						</span>
						<button type="button" class="btn_remove" onclick="fn_file_del(this, '<%=arrPortfolio(0, i)%>');">삭제</button>
					</div>
				<%
						End If
					Next
				End If
				%>

				<% If seq = 0 Then %>
					<div>
						<span class="filebox">
							<span>찾아보기</span>
							<input type="hidden" id="portfolio_type2" name="portfolio_type2" value="1" />
							<input type="hidden" id="pf_origin_file" name="pf_origin_file" value="" />
							<input type="hidden" id="pf_upload_file" name="pf_upload_file" value="" />
							<input type="text" class="txt" name="pf_file_name" disabled="disabled" style="width:605px;" value="">
							<input type="text" class="txt file" id="portfolio_file_upload" name="portfolio_file_upload" onclick="fn_portfolio_upload(this);">
						</span>
						<button type="button" class="btn_remove" onclick="fn_file_del(this, '');">삭제</button>
					</div>
				<% End If %>

				</div>
				<button type="button" class="ib_add_btn file">파일추가</button>
			</div>
		</div>
	</div>
</div><!-- 포트폴리오 -->