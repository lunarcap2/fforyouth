<div class="titArea">
	<h4>최종 학력사항</h4>
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
				<th><span>학력구분</span></th>
				<td colspan="3">
					<div class="select_box" id="univ_gubun" title="학력구분" style="width:200px;">
						<div class="name"><a href="#none"><span>학력구분</span></a></div>
						<div class="sel">
							<ul>
								<li><a href="javascript:;" onclick="fn_sel_val_set(this, 'univ_kind', '3'); fn_school_univ_kind(this, 'high');">고등학교</a></li>
								<li><a href="javascript:;" onclick="fn_sel_val_set(this, 'univ_kind', '4'); fn_school_univ_kind(this, 'univ');">대학(2,3년)</a></li>
								<li><a href="javascript:;" onclick="fn_sel_val_set(this, 'univ_kind', '5'); fn_school_univ_kind(this, 'univ');">대학교(4년)</a></li>
								<li><a href="javascript:;" onclick="fn_sel_val_set(this, 'univ_kind', '6'); fn_school_univ_kind(this, 'univ');">대학원</a></li>
							</ul>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<th><span>학교명</span></th>
				<td class="tb_sch">
					<div class="search_box">
						<input type="text" id="univ_name" class="txt sch" name="univ_name" placeholder="학교명을 입력해 주세요" onkeyup="fn_kwSearchItem(this, 'univ')" style="width:100%;" autocomplete="off">
						<div class="sch_box" style="width:285px;" id="id_sch_box" />
					</div>

				</td>
				<th><span>전공</span></th>
				<td>
					<input type="text" id="univ_major" class="txt" name="univ_major" placeholder="전공명을 입력해 주세요" style="width:100%;">
				</td>
			</tr>
			<tr>
				<th><span>재학기간</span></th>
				<td colspan="3">
					<input type="text" id="univ_sdate" class="txt" name="univ_sdate" placeholder="입학년월" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_school_s_div(this);" onblur="chkDateType(this)" style="width:185px;">
					<em>~</em>
					<input type="text" id="univ_edate" class="txt" name="univ_edate" placeholder="졸업년월" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_school_e_div(this);" onblur="chkDateType(this)" style="width:185px;">
				</td>
			</tr>
			<tr>
				<th><span>졸업구분</span></th>
				<td colspan="3" class="graduated">
					<label class="radiobox off" for="graduated1">
						<input type="radio" id="graduated1" class="rdi" name="graduated" value="8">
						<span>졸업</span>
					</label>
					<label class="radiobox off" for="graduated2">
						<input type="radio" id="graduated2" class="rdi" name="graduated" value="7">
						<span>졸업(예정)</span>
					</label>
					<label class="radiobox off" for="graduated3">
						<input type="radio" id="graduated3" class="rdi" name="graduated" value="3">
						<span>재학</span>
					</label>
					<label class="radiobox off" for="graduated4">
						<input type="radio" id="graduated4" class="rdi" name="graduated" value="87">
						<span>수료</span>
					</label>
					<label class="radiobox off" for="graduated5">
						<input type="radio" id="graduated5" class="rdi" name="graduated" value="4">
						<span>휴학</span>
					</label>
					<label class="radiobox off" for="graduated6">
						<input type="radio" id="graduated6" class="rdi" name="graduated" value="5">
						<span>중퇴</span>
					</label>
					<label class="radiobox off" for="graduated7">
						<input type="radio" id="graduated7" class="rdi" name="graduated" value="88">
						<span>검정고시</span>
					</label>
				</td>
			</tr>
		</tbody>
	</table>
</div>