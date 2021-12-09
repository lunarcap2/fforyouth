<script type="text/javascript">
	//상태변경
	function fn_SetParam(_gb, _apply_num, _status) {
		if ($('input:checkbox[name="chk_list"]:checked').length == 0 && _gb == "status" && _apply_num == "") {
			alert("지원자를 선택하여 주십시오.");
			return;
		}
		else {
			var interviewYN = "";

			if (_apply_num == "") {
				var arr_applynum = ""

				$('input:checkbox[name="chk_list"]').each(function () {
					if (this.checked) {//checked 처리된 항목의 값
						var arr = new Array();
						arr = this.value.split(",");

						arr_applynum += "," + arr[0];

						if (arr[3] == "Y") {
							interviewYN = "Y";
							return;
						}
					}
				});
				
				_apply_num += arr_applynum.substr(1);
			}
			
			if(interviewYN == "Y") {
				alert("면접 배정을 한 지원자가 있습니다.\n면접 배정을 한 지원자의 상태는 변경 할 수 없습니다.");
				return;
			}
			else {
				goStatusSelect(_gb, "2", _apply_num, "");

				if (_gb == "read" && _apply_num != "" && _status == "1") {
					goStatusSelect(_gb, "3", _apply_num, "2");
				}
				else if (_gb == "status") {
					if (!confirm("상태를 변경하시겠습니까?")) {
						return;
					}

					goStatusSelect(_gb, "3", _apply_num, _status);
				}
			}
			
		}
	}

	//지원자 상태변경
    function goStatusSelect(_gb, _gubun, _apply_num, _status) {
        var param = {};
        param.gubun = _gubun;
        param.mode = $('#mode').val();
        param.jid = $('#jid').val();
        param.apply_num = _apply_num;
        param.status = _status;

        $.ajax({
            type: "POST",
            url: "/company/applyjob/apply_setStatus.asp",
            data: param,
            dataType: "html",
            success: function (data) {
                if (data == "0") {
                    alert("실패: 관리자에게 문의하세요.");
                    return false;
                } else if (data == "1") {
					if (_gb == "status") {
						alert("지원자 상태변경이 완료되었습니다.");
					}				

                    $('#frm').submit();					
                }
				/*
				else {
                    alert("서버 데이터 오류: 관리자에게 문의하세요. code=" + data);
                    //location.reload();
                    return false;
                }
				*/
            },
            error:function(request,status,error){
				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
        });
    }

	//이력서 보기
	function fn_resume_view(rid, set_user_id) {		
		$("#rid").val(rid);
		$("#set_user_id").val(set_user_id);

        $('#frm_resume').attr("target", "_blank");
        $('#frm_resume').attr("action", "/company/applyjob/resumeView.asp");
        $('#frm_resume').submit();
	}
</script>
	
	<form id="frm_resume" name="frm_resume" method="post">
		<input type="hidden" id="rid" name="rid" value="">
		<input type="hidden" id="set_user_id" name="set_user_id" value="">
	</form>

	<table class="tb" summary="스크랩한 인재에 관한 이름/성별/나이,이력서 정보/요약정보,등록일 항목을 나타낸 표">
		<caption>스크랩한 공고</caption>
		<colgroup>
			<col style="width:60px">
			<col style="width:300px">
			<col style="width:220px">
			<col style="width:150px">
			<col style="width:150px">
			<col style="width:210px">
			<col>
		</colgroup>
		<thead>
			<tr>
				<th><label class="checkbox off"><input class="chk" id="" name="" type="checkbox" onclick="noncheckallFnc(this, 'chk_list');"></label></th>
				<th>이름/나이</th>
				<th>학력/경력</th>
				<th>첨부</th>
				<th>심사상태</th>
				<th>면접결과</th>
				<th>면접일시</th>
			</tr>
		</thead>
		<tbody>
		<%
		If isArray(arrRs) Then
			For i=0 To UBound(arrRs, 2)
			ConnectDB DBCon, Application("DBInfo_FAIR")
			Dim strSql, arrRsView, arrRsSchool, interviewYN, interviewConfirmYN, rsIntervConfirmYN
			strSql = "SELECT 지원번호, 일련번호, 업파일경로, 업파일명, 실파일명 FROM 인터넷입사지원파일첨부 WITH(NOLOCK) WHERE 채용등록번호 ='"& jid &"' AND 지원번호 = '"& arrRs(14, i) &"' ORDER BY 일련번호"
			arrRsView = arrGetRsSql(DBCon, strSql, "", "")

			strSql = " SELECT 학교명, 전공명, 졸업구분 FROM 이력서학력 WHERE 등록번호 = '" & arrRs(2,i) & "' AND 학력종류 = '" & arrRs(9,i) & "' "
			arrRsSchool = arrGetRsParam(DBCon, strSql, "", "", "")
			
			strSql = " SELECT 면접확정여부 AS 면접확정여부 FROM 면접배정정보 WHERE 채용등록번호 = '" & jid & "' AND 입사지원등록번호 = '"& arrRs(14, i) &"'"
			interviewYN = arrGetRsParam(DBCon, strSql, "", "", "")

			strSql = " SELECT isnull(면접확정여부,'N') AS 면접확정여부 FROM 면접배정정보 WHERE 채용등록번호 = '" & jid & "' AND 입사지원등록번호 = '"& arrRs(14, i) &"'"
			interviewConfirmYN = arrGetRsParam(DBCon, strSql, "", "", "")
			If isArray(interviewConfirmYN) Then
			 	rsIntervConfirmYN = interviewConfirmYN(0, 0)
			End If 

			DisconnectDB DBCon

			'생년월일 나이
			Dim birth_ymd
			If arrRs(6, i) = "1" Or arrRs(6, i) = "2" Then
				birth_ymd = "19" & arrRs(5, i)
			Else
				birth_ymd = "20" & arrRs(5, i)
			End If
			Dim user_age : user_age = Year(now) - Left(birth_ymd, 4) + 1

			'경력표기
			Dim career_str, tot_sum
			tot_sum = Abs(arrRs(11, i))

			If tot_sum = "0" Then 
				career_str = "신입"
			ElseIf tot_sum > 12 Then
				career_str = "경력 " & fix(tot_sum / 12) & "년 "

				If tot_sum mod 12 > 0 Then
					career_str = career_str & tot_sum mod 12 & "개월"
				End If
			Else 
				career_str = "경력 " & tot_sum & "개월"
			End If

			'최종학력
			Dim strFinalSchool : strFinalSchool = ""
			Select Case arrRs(9, i)
				Case "3" : strFinalSchool = "고등학교"
				Case "4" : strFinalSchool = "대학(2,3년)"
				Case "5" : strFinalSchool = "대학교(4년)"
				Case "6" : strFinalSchool = "대학원"
			End Select

			'합격상태
			Dim statusNm
			Select Case arrRs(20, i)
				Case "1" : statusNm = "심사하기"
				Case "2" : statusNm = "검토중"
				Case "3" : statusNm = "서류합격"
				Case "4" : statusNm = "예비합격"
				Case "5" : statusNm = "서류불합격"
			End Select
			
			'이력서 열람여부
			Dim isopen
			Select Case arrRs(22, i)
				Case "1" : isopen = "열람"
				Case "0" : isopen = "미열람"
			End Select

			' 면접결과 상태
			Dim final_rtn
			Select Case arrRs(27, i)
				Case "6" : final_rtn = "<p>단순상담</p>"
				Case "7" : final_rtn = "<p class='blue'>추가전형진행</p>"
				Case "8" : final_rtn = "<p class='red'>불참</p>"
				Case "9" : final_rtn = "<p>기타</p>"
				Case Else : final_rtn = ""
			End Select
		%>
			<tr>
				<td>
					<label class="checkbox off">
						<input class="chk" id="" name="chk_list" type="checkbox" value="<%=arrRs(14,i)%>,<%=arrRs(2,i)%>,<%=arrRs(3,i)%>,<% If isArray(interviewYN) Then %>Y<% End If %>">
					</label>
				</td>
				<td class="t1 tc">
					
					<div class="photoBox">
						<a href="javascript:;" <% If arrRs(18,i) = "A" And arrRs(17,i) <> "" Then %>onclick="fn_resume_view('<%=arrRs(14,i)%>', '<%=objEncrypter.Encrypt(arrRs(3,i))%>'); fn_SetParam('read', '<%=arrRs(14, i)%>', '<%=arrRs(20,i)%>');"<% End If %>>	
							<div class="photo">
								<span class="frame sprite"></span>
								<% If arrRs(13, i) <> "" Then %>
								<img src="/files/mypic/<%=arrRs(13, i)%>">
								<% End If %>
							</div>
							<div class="photo_info">
								<em class="name">
									<%=arrRs(4, i)%>
									<% If isnull(arrRs(30, i)) Then %>
									(탈퇴회원)
									<% End If %>
								</em>
								<p class="birth">(<span class="num"><%=Left(birth_ymd, 4)%></span>년생, <span class="num"><%=user_age%></span>세)</p>
								<% If arrRs(16, i) <> "" Then %>
								<p class="job">(<%=arrRs(16, i)%>)</p>
								<% End If %>
							</div>
						</a>
					</div>
				</td>
				<td class="t2  tc">
					<div class="txtBox">
						<% If arrRs(18,i) = "A" And arrRs(17,i) <> "" Then %>
						<p><%=strFinalSchool%>&nbsp;<%=GraduatedState%></p>
						<% 
							If isArray(arrRsSchool) Then
								Dim GraduatedState
								Select Case arrRsSchool(2,0)
									Case "3" : GraduatedState = "재학"
									Case "4" : GraduatedState = "휴학"
									Case "5" : GraduatedState = "중퇴"
									Case "7" : GraduatedState = "졸업(예)"
									Case "8" : GraduatedState = "졸업"
								End Select
						%>
							<p><%=arrRsSchool(0,0)%>&nbsp;<%=arrRsSchool(1,0)%></p>	
						<% End If %>
						<p><%=career_str%></p>
						<% ElseIf isnull(arrRs(30, i)) = false Then %>
						<p>자사/자유양식 지원자입니다.<br>첨부파일을 다운받아주세요.</p>
						<% End If %>
					</div>
				</td>
				<td class="t3 tc">
					<% If isnull(arrRs(30, i)) = False Then %>
						<% If isArray(arrRsView) Then %>
						<div class="select_box" title="첨부파일" style="width:130px;">
							<div class="name"><a href="#none"><span>첨부파일</span></a></div>
							<div class="sel">
								<ul>
									<% For ii=0 To UBound(arrRsView, 2) %>
									<li><a href="http://www2.career.co.kr/myjob/files/filedownload_apply_busan.asp?aid=<%=arrRsView(0, ii)%>&orderno=<%=arrRsView(1, ii)%>&folderpath=<%=arrRsView(2, ii)%>&filename=<%=arrRsView(3, ii)%>&orifilename=<%=arrRsView(4, ii)%>" target="_blank" onclick="fn_SetParam('read', '<%=arrRs(14, i)%>', '<%=arrRs(20,i)%>');"><%=arrRsView(4, ii)%></a></li>
									<% Next %>
								</ul>
							</div>
						</div>
						<% End If %>		
					<% End If %>
				</td>
				<td class="t4 tc">
					<% If isArray(interviewYN) Then %>
					<div class="txtBox">
						<p><%=statusNm%></p>
						<p class=<% If isopen = "열람" Then %> blue <% Else %> red <% End If %>><%=isopen%></p>
					</div>
					<% ElseIf isnull(arrRs(30, i)) = false Then %>
					<div class="select_box" title="심사하기" style="width:130px;">
						<div class="name"><a href="#none"><span><%=statusNm%></span></a></div>
						<div class="sel">
							<ul>
								<li><a href="#none" onclick="fn_SetParam('status', '<%=arrRs(14, i)%>', '2');">검토중</a></li>
								<li><a href="#none" onclick="fn_SetParam('status', '<%=arrRs(14, i)%>', '4');">예비합격</a></li>
								<li><a href="#none" onclick="fn_SetParam('status', '<%=arrRs(14, i)%>', '5');">서류불합격</a></li>
								<li><a href="#none" onclick="fn_SetParam('status', '<%=arrRs(14, i)%>', '3');">서류합격</a></li>
							</ul>
						</div>
					</div>

					<div class="txtBox">
						<p class=<% If isopen = "열람" Then %> blue <% Else %> red <% End If %>><%=isopen%></p>
					</div>
					<% End If %>	
				</td>
				<td class="t5 tc">
					<% If interview_N = "N" Or (interview_N = "" And rsIntervConfirmYN = "N") Then %><!-- 면접배정 확정된 대상자에 대해서만 결과 입력 버튼 노출 -->
					<p class="data"><span>-</span></p>
					<% Else %>
					<div class="txtBox">
						<%=final_rtn%>
					</div>
					<div class="btn_area">
						<% If arrRs(27, i) <> "" Then %>
						<a href="#none;" class="btn orange2 pop" onclick="openLayer('result_interview', '<%=arrRs(14, i)%>', '<%=arrRs(25, i)%>');">결과수정</a>
						<% ElseIf isnull(arrRs(30, i)) = false Then %>
						<a href="#none;" class="btn orange pop" onclick="openLayer('result_interview', '<%=arrRs(14, i)%>', '<%=arrRs(25, i)%>');">결과입력</a>
						<% End If %>
					</div>
					<% End If %>
				</td>
				<td class="t6 tc">
					<% If arrRs(24, i) <> "" Or interview_N <> "N" Then %>
					<div class="txtBox">
						<p><%=arrRs(24, i)%></p>
						<p><%=getInterviewTime(arrRs(25, i))%></p>
					</div>
					<div class="btn_area">
					<% If isnull(arrRs(30, i))=False Then %><!-- 탈퇴회원 문자 발송 제외 -->
						<% If isnull(arrRs(27, i)) Then %>
							<%If CDate(arrRs(24, i)&" "&Left(getInterviewTime(arrRs(25, i)),5)) >= CDate(FormatDateTime(Now(), 0)) Then%>
								<a href="javaScript:;" onclick="fn_msg_resend('<%=arrRs(1, i)%>', '<%=arrRs(14, i)%>', '<%=arrRs(4, i)%>', '<%=arrRs(26, i)%>', '<%=ont_confId%>');" class="btn gray">문자 <%If arrRs(26, i) <> "" Then%>재발송<%Else%>발송<%End If%></a>
							<%End If%>
						<% End If %>
					<% End If %>
					</div>
					<% Else %>
					<p class="data"><span>-</span></p>
					<% End If %>
				</td>
			</tr>
		<%
			Next
		Else
		%>
			<tr>
				<td colspan="7" class="no_data">
					<% If kw <> "" Or job_part <> "" Then %>
						검색 결과가 없습니다.
					<% ElseIf request.servervariables("url") = "/company/interview/list.asp" Then %>
						서류합격자 면접배정이 모두 완료되었습니다.
					<% ElseIf TimeToCnt = 0 Or request.servervariables("url") = "/company/interview/list_interview.asp" Then %>
						해당일자 및 시간에 배정된 면접자가 없습니다.
					<% End If %>
				</td>
			</tr>
		<%
		End If 
		%>
		</tbody>
	</table>