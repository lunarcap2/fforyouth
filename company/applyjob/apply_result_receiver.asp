<table class="tb">
	<colgroup>
		<col style="width:180px;"/>
		<col />
	</colgroup>
	<tbody>
		<tr>
			<th>통보방법</th>
			<td>
				<label class="radiobox off" for="tb1">
					<input type="radio" class="rdi" id="tb1" name="tb1_1" value="email" onclick="fn_rece_set();">
					<span>E-mail통보</span>
				</label>
				<label class="radiobox off" for="tb2">
					<input type="radio" class="rdi" id="tb2" name="tb1_1" value="sms" onclick="fn_rece_set();">
					<span>문자 통보</span>
				</label>
			</td>
		</tr>
		<tr>
			<th class="th_receiver">받는사람</th>
			<td>
				<div class="tb_recipient">
					<div class="left_sec">
						<span class="selectbox" style="width:190px">
							<span class="">받는사람</span>
							<select id="schManager" name="schManager" title="받는사람" onchange="fn_rece_set();">
								<option value="7">면접 합격</option>
								<option value="6">면접 불합격</option>
								<option value="5">서류 불합격</option>
							</select>
						</span>
					</div>
					<div class="right_sec">
						<div class="sch_box">
							<input type="text" id="kw_nm" name="name" class="txt" style="width:169px;" placeholder="이름 검색">
							<button type="button" class="sch_btn" onclick="fn_rece_set();">검색</button>
						</div>
					</div>
					<div class="tb_list">
						<div class="tb_header_bg"></div>
						<div class="tb_wrapper">
							<table class="tb">
								<thead>
									<tr class="fix_th">
										<th class="cell1">
											<span>
												<label class="checkbox off"><input class="chk" id="" name="" type="checkbox" onclick="noncheckallFnc(this, 'rece_list');"></label>
											</span>
										</th>
										<th class="cell2"><span>이름</span></th>
										<th class="cell3"><span>학교</span></th>
										<th class="cell4"><span>최종경력</span></th>
									</tr>
								</thead>
								<tbody id="receList">
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</td>
		</tr>
	</tbody>
</table>