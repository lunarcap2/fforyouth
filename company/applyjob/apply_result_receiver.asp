<table class="tb">
	<colgroup>
		<col style="width:180px;"/>
		<col />
	</colgroup>
	<tbody>
		<tr>
			<th>�뺸���</th>
			<td>
				<label class="radiobox off" for="tb1">
					<input type="radio" class="rdi" id="tb1" name="tb1_1" value="email" onclick="fn_rece_set();">
					<span>E-mail�뺸</span>
				</label>
				<label class="radiobox off" for="tb2">
					<input type="radio" class="rdi" id="tb2" name="tb1_1" value="sms" onclick="fn_rece_set();">
					<span>���� �뺸</span>
				</label>
			</td>
		</tr>
		<tr>
			<th class="th_receiver">�޴»��</th>
			<td>
				<div class="tb_recipient">
					<div class="left_sec">
						<span class="selectbox" style="width:190px">
							<span class="">�޴»��</span>
							<select id="schManager" name="schManager" title="�޴»��" onchange="fn_rece_set();">
								<option value="7">���� �հ�</option>
								<option value="6">���� ���հ�</option>
								<option value="5">���� ���հ�</option>
							</select>
						</span>
					</div>
					<div class="right_sec">
						<div class="sch_box">
							<input type="text" id="kw_nm" name="name" class="txt" style="width:169px;" placeholder="�̸� �˻�">
							<button type="button" class="sch_btn" onclick="fn_rece_set();">�˻�</button>
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
										<th class="cell2"><span>�̸�</span></th>
										<th class="cell3"><span>�б�</span></th>
										<th class="cell4"><span>�������</span></th>
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