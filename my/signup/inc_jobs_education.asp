<div class="titArea">
	<h4>���� �з»���</h4>
</div><!-- .titArea -->
<div class="inputArea">
	<table class="tb">
		<colgroup>
			<col style="width:170px;"/>
			<col style="width:303px;"/>
			<col style="width:170px;"/>
			<col/>
		</colgroup>
		<tbody>
			<tr>
				<th><span>�з±���</span></th>
				<td colspan="3">
					<div class="select_box" id="univ_gubun" title="�з±���" style="width:200px;">
						<div class="name"><a href="#none"><span>�з±���</span></a></div>
						<div class="sel">
							<ul>
								<li><a href="javascript:;" onclick="fn_sel_val_set(this, 'univ_kind', '3'); fn_school_univ_kind(this, 'high');">����б�</a></li>
								<li><a href="javascript:;" onclick="fn_sel_val_set(this, 'univ_kind', '4'); fn_school_univ_kind(this, 'univ');">����(2,3��)</a></li>
								<li><a href="javascript:;" onclick="fn_sel_val_set(this, 'univ_kind', '5'); fn_school_univ_kind(this, 'univ');">���б�(4��)</a></li>
								<li><a href="javascript:;" onclick="fn_sel_val_set(this, 'univ_kind', '6'); fn_school_univ_kind(this, 'univ');">���п�</a></li>
							</ul>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<th><span>�б���</span></th>
				<td class="tb_sch">
					<div class="search_box">
						<input type="text" id="univ_name" class="txt sch" name="univ_name" placeholder="�б����� �Է��� �ּ���" onkeyup="fn_kwSearchItem(this, 'univ')" style="width:100%;" autocomplete="off">
						<div class="sch_box" style="width:285px;" id="id_sch_box" />
					</div>

				</td>
				<th><span>����</span></th>
				<td>
					<input type="text" id="univ_major" class="txt" name="univ_major" placeholder="�������� �Է��� �ּ���" style="width:100%;">
				</td>
			</tr>
			<tr>
				<th><span>���бⰣ</span></th>
				<td colspan="3">
					<input type="text" id="univ_sdate" class="txt" name="univ_sdate" placeholder="���г��" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_school_s_div(this);" onblur="chkDateType(this)" style="width:185px;">
					<em>~</em>
					<input type="text" id="univ_edate" class="txt" name="univ_edate" placeholder="�������" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_school_e_div(this);" onblur="chkDateType(this)" style="width:185px;">
				</td>
			</tr>
			<tr>
				<th><span>��������</span></th>
				<td colspan="3" class="graduated">
					<label class="radiobox off" for="graduated1">
						<input type="radio" id="graduated1" class="rdi" name="graduated" value="8">
						<span>����</span>
					</label>
					<label class="radiobox off" for="graduated2">
						<input type="radio" id="graduated2" class="rdi" name="graduated" value="7">
						<span>����(����)</span>
					</label>
					<label class="radiobox off" for="graduated3">
						<input type="radio" id="graduated3" class="rdi" name="graduated" value="3">
						<span>����</span>
					</label>
					<label class="radiobox off" for="graduated4">
						<input type="radio" id="graduated4" class="rdi" name="graduated" value="87">
						<span>����</span>
					</label>
					<label class="radiobox off" for="graduated5">
						<input type="radio" id="graduated5" class="rdi" name="graduated" value="4">
						<span>����</span>
					</label>
					<label class="radiobox off" for="graduated6">
						<input type="radio" id="graduated6" class="rdi" name="graduated" value="5">
						<span>����</span>
					</label>
					<label class="radiobox off" for="graduated7">
						<input type="radio" id="graduated7" class="rdi" name="graduated" value="88">
						<span>�������</span>
					</label>
				</td>
			</tr>
		</tbody>
	</table>
</div>