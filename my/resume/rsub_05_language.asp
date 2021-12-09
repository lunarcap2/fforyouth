<script type="text/javascript" src="https://job3.career.co.kr/js/language_exam.js"></script>
<script type="text/javascript">
		
		/*
		$(document).ready(function () {
			//���ν��� ���� ����κ�
			var exam_seq = $('[name="language_exam_seq"]').length;
			for (i=0; i<exam_seq; i++) {
				var exam_group_val = $('[name="language_exam_seq"]').eq(i).nextAll('#language_exam_group').val();
				var exam_set_obj = $('[name="language_exam_seq"]').eq(i).nextAll('.select_down.test').children('.sel').find("a");
				exam_set_obj.eq(exam_group_val -1).click();
			}
		});
		*/

	function fn_language_reset(obj, val) {
		switch (val) {
			case '1' :
				//input hidden �ʱ�ȭ
				$(obj).parents(".ib_m_box").children("#language_exam_group").val("");
				$(obj).parents(".ib_m_box").children("#language_exam").val("");
				$(obj).parents(".ib_m_box").children("#language_year").val("");
				$(obj).parents(".ib_m_box").children("#language_month").val("");
				//input text �ʱ�ȭ
				$(obj).parents(".ib_m_box").find("#language_grade").val("");
				$(obj).parents(".ib_m_box").find("#language_date").val("");
				//select �ʱ�ȭ
				$(obj).parents(".ib_m_box").find("#language_title_exam_group").html("�ܱ����");
				$(obj).parents(".ib_m_box").find("#language_title_exam").html("���ν��� ����");
			break;

			case '2' :
				//input hidden �ʱ�ȭ
				$(obj).parents(".ib_m_box").children("#language_name").val("");
				$(obj).parents(".ib_m_box").children("#language_talk").val("");
				//select �ʱ�ȭ
				$(obj).parents(".ib_m_box").find("#language_title_name").html("�ܱ����");
				$(obj).parents(".ib_m_box").find("#language_title_talk").html("ȸȭ�ɷ�");
			break;
		};

		selectDown();//����Ʈ�� UL
	}

	function fn_language_div(obj) {
		if (obj.value.length == 7) {
			$(obj).parents(".ib_m_box").children("#language_year").val(obj.value.substr(0, 4));
			$(obj).parents(".ib_m_box").children("#language_month").val(obj.value.substr(5, 2));
		} else {
			$(obj).parents(".ib_m_box").children("#language_year").val("");
			$(obj).parents(".ib_m_box").children("#language_month").val("");
		}
	}

	// ���ν��� ���ÿ� ���� ���н��� bind
	function fn_chgLanguage(obj, val) {
		//���ν���(�����)�� �ʱ�ȭ
		$(obj).parents(".ib_m_box").children("#language_exam").val("");
		$(obj).parents(".ib_m_box").find("#language_title_exam").html("���ν��� ����");

		
		//���ν���(�����)���� ����Ʈ �� ���´� ���踮��Ʈ
		var li_html = '';
		if (trim(val)) {
			for (var i = 0; i < langex_cd1[val].length; i++) {
				li_html += '<li>'
				li_html += '<a href="javascript:;" onclick="fn_sel_value_set(this, \'language_exam\', \'' + langex_cd1[val][i] + '\')">'
				li_html += langex_nm1[val][i]
				li_html += '</a>'
				li_html += '</li>'
			}
			li_html += '<li><a href="javascript:;" onclick="fn_sel_value_set(this, \'language_exam\', \'99\')">��Ÿ</a></li>'
		}

		$(obj).parents(".ib_m_box").find("#language_exam_list").html(li_html);
		selectDown();//����Ʈ�� UL
	}

</script>

<div class="input_box" id ="resume5">
	<p class="ib_tit">�ܱ���</p>
	<div id="language_sel_option" style="display:none;">
	<% Call putCodeToatagOption("getLanguageCode", 1, 99, "1", "fn_sel_value_set", "language_name") %>
	</div>
	<div class="ib_list add4">	
		<%
		If isArray(arrLanguageUse) Then 'ȸȭ�ɷ�
			For i=0 To UBound(arrLanguageUse, 2)
			Dim language_talk_nm
			Select Case arrLanguageUse(2, i)
				Case "1" : language_talk_nm = "��"
				Case "2" : language_talk_nm = "��"
				Case "3" : language_talk_nm = "��"
			End Select
		%>
		<div class="ib_move non">
			<div class="deleteBox">����</div>
			<div class="ib_m_box">
				<div class="select_down"  style="width:200px;" title="����">
					<div class="name"><a href="javaScript:;"><span>ȸȭ�ɷ�</span></a></div>
					<div class="sel">
						<ul>
							<li><a href="javaScript:;" class="skill" onclick="fn_language_reset(this, '1')">ȸȭ�ɷ�</a></li>
							<li><a href="javaScript:;" class="test" onclick="fn_language_reset(this, '2')">���ν���</a></li>
						</ul>
					</div>
				</div>

				<!-- ȸȭ�ɷ� -->
				<input type="hidden" id="language_name" name="language_name" value="<%=arrLanguageUse(1, i)%>" />
				<input type="hidden" id="language_talk" name="language_talk" value="<%=arrLanguageUse(2, i)%>" />
				<input type="hidden" id="language_read" name="language_read" value="" />
				<input type="hidden" id="language_write" name="language_write" value="" />

				<div class="select_down skill" style="width:250px;" title="�ܱ����">
					<div class="name"><a href="javaScript:;"><span id="language_title_name"><%=getLanguageCode(arrLanguageUse(1, i))%></span></a></div>
					<div class="sel">
						<ul>
							<% '/wwwconf/code/code_function.asp, /wwwconf/code/codeToHtml.asp %>
							<% Call putCodeToatagOption("getLanguageCode", 1, 99, "1", "fn_sel_value_set", "language_name") %>
						</ul>
					</div>
				</div>
				<div class="select_down skill" style="width:276px;" title="ȸȭ�ɷ�">
					<div class="name"><a href="javaScript:;"><span id="language_title_talk"><%=language_talk_nm%></span></a></div>
					<div class="sel">
						<ul>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_talk', '1');">��</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_talk', '2');">��</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_talk', '3');">��</a></li>
						</ul>
					</div>
				</div>
				<!-- //ȸȭ�ɷ� -->

				<!-- ���ν��� -->
				<input type="hidden" id="language_exam_group" name="language_exam_group" value="" />
				<input type="hidden" id="language_exam" name="language_exam" value="" />
				<input type="hidden" id="language_year" name="language_year" value="" />
				<input type="hidden" id="language_month" name="language_month" value="" />

				<input type="hidden" id="language_exam_etc" name="language_exam_etc" value="" />
				<input type="hidden" id="language_grade_opic" name="language_grade_opic" value="" />

				<div class="select_down test"  style="width:250px; display:none;" title="�ܱ����">
					<div class="name"><a href="javaScript:;"><span id="language_title_exam_group">�ܱ����</span></a></div>
					<div class="sel">
						<ul>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam_group', '1'); fn_chgLanguage(this, '1');">����</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam_group', '2'); fn_chgLanguage(this, '2');">�Ϻ���</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam_group', '3'); fn_chgLanguage(this, '3');">�߱���</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam_group', '4'); fn_chgLanguage(this, '4');">��������</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam_group', '5'); fn_chgLanguage(this, '5');">���Ͼ�</a></li>
						</ul>
					</div>
				</div>
				<div class="con_add test" style="display: none;">
					<div class="ca_input">
						<div class="select_down" style="width:370px;" title="���ν��� ����">
							<div class="name"><a href="javaScript:;"><span id="language_title_exam">���ν��� ����</span></a></div>
							<div class="sel">
								<ul id="language_exam_list">
									<!-- <li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam', '1');">����</a></li> -->
								</ul>
							</div>
						</div>
						<input type="text" id="language_grade" name="language_grade" class="txt" placeholder="����/��" maxlength="10" style="width:370px;">
						<input type="text" id="language_date" name="language_date" class="txt last" placeholder="�������� (ex. 2020.03)" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_language_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:360px;">
					</div>
				</div>
				<!-- <button type="button" name="���н��� �߰�" class="add_test">���н��� �߰�</button> -->
				<!-- //���ν��� -->
			</div>
		</div>
		<%
			Next
		End If

		If isArray(arrLanguageExam) Then '���ν���
			For i=0 To UBound(arrLanguageExam, 2)
			Dim language_exam_group_nm, language_exam_nm
			Select Case arrLanguageExam(1, i)
				Case "1" : language_exam_group_nm = "����"
				Case "2" : language_exam_group_nm = "�Ϻ���"
				Case "3" : language_exam_group_nm = "�߱���"
				Case "4" : language_exam_group_nm = "��������"
				Case "5" : language_exam_group_nm = "���Ͼ�"
			End Select

			language_exam_nm = getLanguageExamCodeNm(arrLanguageExam(2, i))

			Dim language_date
			If isDate(arrLanguageExam(4, i) & "-" & arrLanguageExam(5, i)) Then language_date = arrLanguageExam(4, i) & "." & arrLanguageExam(5, i)
		%>
		<div class="ib_move non">
			<div class="deleteBox">����</div>
			<div class="ib_m_box">
				<div class="select_down"  style="width:200px;" title="����">
					<div class="name"><a href="javaScript:;"><span>���ν���</span></a></div>
					<div class="sel">
						<ul>
							<li><a href="javaScript:;" class="skill" onclick="fn_language_reset(this, '1')">ȸȭ�ɷ�</a></li>
							<li><a href="javaScript:;" class="test" id="language_test_click" onclick="fn_language_reset(this, '2')">���ν���</a></li>
						</ul>
					</div>
				</div>

				<!-- ȸȭ�ɷ� -->
				<input type="hidden" id="language_name" name="language_name" value="" />
				<input type="hidden" id="language_talk" name="language_talk" value="" />
				<input type="hidden" id="language_read" name="language_read" value="" />
				<input type="hidden" id="language_write" name="language_write" value="" />

				<div class="select_down skill" style="width:250px; display:none;" title="�ܱ����">
					<div class="name"><a href="javaScript:;"><span id="language_title_name">�ܱ����</span></a></div>
					<div class="sel">
						<ul>
							<% '/wwwconf/code/code_function.asp, /wwwconf/code/codeToHtml.asp %>
							<% Call putCodeToatagOption("getLanguageCode", 1, 99, "1", "fn_sel_value_set", "language_name") %>
						</ul>
					</div>
				</div>
				<div class="select_down skill" style="width:276px; display:none;" title="ȸȭ�ɷ�">
					<div class="name"><a href="javaScript:;"><span id="language_title_talk">ȸȭ�ɷ�</span></a></div>
					<div class="sel">
						<ul>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_talk', '1');">��</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_talk', '2');">��</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_talk', '3');">��</a></li>
						</ul>
					</div>
				</div>
				<!-- //ȸȭ�ɷ� -->

				<!-- ���ν��� -->
				<input type="hidden" id="language_exam_seq" name="language_exam_seq" value="<%=arrLanguageExam(0, i)%>" />
				<input type="hidden" id="language_exam_group" name="language_exam_group" value="<%=arrLanguageExam(1, i)%>" />
				<input type="hidden" id="language_exam" name="language_exam" value="<%=arrLanguageExam(2, i)%>" />
				<input type="hidden" id="language_year" name="language_year" value="<%=arrLanguageExam(4, i)%>" />
				<input type="hidden" id="language_month" name="language_month" value="<%=arrLanguageExam(5, i)%>" />

				<input type="hidden" id="language_exam_etc" name="language_exam_etc" value="<%=arrLanguageExam(6,i)%>" />
				<input type="hidden" id="language_grade_opic" name="language_grade_opic" value="" />

				<div class="select_down test" id="select_down_language_exam" style="width:250px;" title="�ܱ����">
					<div class="name"><a href="javaScript:;"><span id="language_title_exam_group"><%=language_exam_group_nm%></span></a></div>
					<div class="sel">
						<ul>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam_group', '1'); fn_chgLanguage(this, '1');">����</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam_group', '2'); fn_chgLanguage(this, '2');">�Ϻ���</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam_group', '3'); fn_chgLanguage(this, '3');">�߱���</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam_group', '4'); fn_chgLanguage(this, '4');">��������</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam_group', '5'); fn_chgLanguage(this, '5');">���Ͼ�</a></li>
						</ul>
					</div>
				</div>
				<div class="con_add test">
					<div class="ca_input">
						<div class="select_down" style="width:370px;" title="���ν��� ����">
							<div class="name"><a href="javaScript:;"><span id="language_title_exam"><%=language_exam_nm%></span></a></div>
							<div class="sel">
								<ul id="language_exam_list">
									<!-- <li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam', '1');">����</a></li> -->
								</ul>
							</div>
						</div>
						<input type="text" id="language_grade" name="language_grade" class="txt" placeholder="����/��" value="<%=arrLanguageExam(3, i)%>" maxlength="10" style="width:370px;">
						<input type="text" id="language_date" name="language_date" class="txt last" placeholder="�������� (ex. 2020.03)" value="<%=language_date%>" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_language_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:360px;">
					</div>
				</div>
				<!-- <button type="button" name="���н��� �߰�" class="add_test">���н��� �߰�</button> -->
				<!-- //���ν��� -->
			</div>
		</div>
		<%
			Next
		End If

		If isArray(arrLanguageUse) = False And isArray(arrLanguageExam) = False Then
		%>
		<div class="ib_move non">
			<div class="deleteBox">����</div>
			<div class="ib_m_box">
				<div class="select_down"  style="width:200px;" title="����">
					<div class="name"><a href="javaScript:;"><span>����</span></a></div>
					<div class="sel">
						<ul>
							<li><a href="javaScript:;" class="skill" onclick="fn_language_reset(this, '1')">ȸȭ�ɷ�</a></li>
							<li><a href="javaScript:;" class="test" onclick="fn_language_reset(this, '2')">���ν���</a></li>
						</ul>
					</div>
				</div>

				<!-- ȸȭ�ɷ� -->
				<input type="hidden" id="language_name" name="language_name" value="" />
				<input type="hidden" id="language_talk" name="language_talk" value="" />
				<input type="hidden" id="language_read" name="language_read" value="" />
				<input type="hidden" id="language_write" name="language_write" value="" />

				<div class="select_down skill" style="width:250px;" title="�ܱ����">
					<div class="name"><a href="javaScript:;"><span id="language_title_name">�ܱ����</span></a></div>
					<div class="sel">
						<ul id="language_sel_option">
							<% '/wwwconf/code/code_function.asp, /wwwconf/code/codeToHtml.asp %>
							<% Call putCodeToatagOption("getLanguageCode", 1, 99, "1", "fn_sel_value_set", "language_name") %>
						</ul>
					</div>
				</div>
				<div class="select_down skill" style="width:276px;" title="ȸȭ�ɷ�">
					<div class="name"><a href="javaScript:;"><span id="language_title_talk">ȸȭ�ɷ�</span></a></div>
					<div class="sel">
						<ul>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_talk', '1');">��</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_talk', '2');">��</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_talk', '3');">��</a></li>
						</ul>
					</div>
				</div>
				<!-- //ȸȭ�ɷ� -->

				<!-- ���ν��� -->
				<input type="hidden" id="language_exam_group" name="language_exam_group" value="" />
				<input type="hidden" id="language_exam" name="language_exam" value="" />
				<input type="hidden" id="language_year" name="language_year" value="" />
				<input type="hidden" id="language_month" name="language_month" value="" />

				<input type="hidden" id="language_exam_etc" name="language_exam_etc" value="" />
				<input type="hidden" id="language_grade_opic" name="language_grade_opic" value="" />

				<div class="select_down test"  style="width:250px; display:none;" title="�ܱ����">
					<div class="name"><a href="javaScript:;"><span id="language_title_exam_group">�ܱ����</span></a></div>
					<div class="sel">
						<ul>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam_group', '1'); fn_chgLanguage(this, '1');">����</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam_group', '2'); fn_chgLanguage(this, '2');">�Ϻ���</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam_group', '3'); fn_chgLanguage(this, '3');">�߱���</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam_group', '4'); fn_chgLanguage(this, '4');">��������</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam_group', '5'); fn_chgLanguage(this, '5');">���Ͼ�</a></li>
						</ul>
					</div>
				</div>
				<div class="con_add test" style="display: none;">
					<div class="ca_input">
						<div class="select_down" style="width:370px;" title="���ν��� ����">
							<div class="name"><a href="javaScript:;"><span id="language_title_exam">���ν��� ����</span></a></div>
							<div class="sel">
								<ul id="language_exam_list">
									<!-- <li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam', '1');">����</a></li> -->
								</ul>
							</div>
						</div>
						<input type="text" id="language_grade" name="language_grade" class="txt" placeholder="����/��" maxlength="10" style="width:370px;">
						<input type="text" id="language_date" name="language_date" class="txt last" placeholder="�������� (ex. 2020.03)" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_language_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:360px;">
					</div>
				</div>
				<!-- <button type="button" name="���н��� �߰�" class="add_test">���н��� �߰�</button> -->
				<!-- //���ν��� -->
			</div>
		</div>
		<%
		End If 
		%>
	</div>

	<div class="add_box">
		<button type="button" class="addItem r4">�߰��ϱ�</button>
	</div>
</div><!-- �ܱ��� -->