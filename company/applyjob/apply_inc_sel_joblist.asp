<%
ConnectDB DBCon, Application("DBInfo_FAIR")

	Dim strStmt, arrRsJoblist(1)
	strStmt = ""
	strStmt = strStmt & " SELECT 등록번호, 모집내용제목 FROM 채용정보 WITH(NOLOCK)"
	strStmt = strStmt & " WHERE 회사아이디 = '"& comid &"'"
	strStmt = strStmt & " ORDER BY 등록번호 DESC"
	arrRsJoblist(0) = arrGetRsSql(DBCon, strStmt, "", "")

	strStmt = ""
	strStmt = strStmt & " SELECT 등록번호, 모집내용제목 FROM 마감채용정보 WITH(NOLOCK)"
	strStmt = strStmt & " WHERE 회사아이디 = '"& comid &"'"
	strStmt = strStmt & " ORDER BY 등록번호 DESC"
	arrRsJoblist(1) = arrGetRsSql(DBCon, strStmt, "", "")

	Dim str_jobState, str_jobTitle
	If isArray(arrRsJoblist(0)) Then
		For i=0 To Ubound(arrRsJoblist(0), 2)		
			If CSng(jid) = CSng(arrRsJoblist(0)(0, i)) And mode = "ing" Then 
				str_jobState = "진행중"
				str_jobTitle = arrRsJoblist(0)(1, i)
			End If 
		Next
	End If 
	If isArray(arrRsJoblist(1)) Then
		For i=0 To Ubound(arrRsJoblist(1), 2)
			If Csng(jid) = Csng(arrRsJoblist(1)(0, i)) Then 
				str_jobState = "마감"
				str_jobTitle = arrRsJoblist(1)(1, i)
			End If 
		Next
	End If


	Dim arrRsApplyCnt
	ReDim param(3)
	spName = "USP_BIZSERVICE_APPLY_CNT"
	param(0) = makeParam("@mode", adVarchar, adParamInput, 10, mode)
	param(1) = makeParam("@comid", adVarchar, adParamInput, 20, comid)
	param(2) = makeParam("@jid", adInteger, adParamInput, 4, jid)

	arrRsApplyCnt = arrGetRsSP(dbCon, spName, param, "", "")

	Dim total_cnt, not_open_cnt, before_cnt, ing_cnt, papers_cnt, final_cnt, failure_cnt
	total_cnt		= arrRsApplyCnt(0, 0)
	not_open_cnt	= arrRsApplyCnt(2, 0)
	before_cnt		= arrRsApplyCnt(8, 0)
	ing_cnt			= arrRsApplyCnt(9, 0)
	papers_cnt		= arrRsApplyCnt(10, 0)
	final_cnt		= arrRsApplyCnt(11, 0)
	failure_cnt		= arrRsApplyCnt(12, 0)

	'0:TOTAL_CNT(전체입사지원개수)
	'1:TODAY_CNT(오늘입사지원수)
	'2:NOT_OPEN_CNT(미열람수)
	'3:ONLINE_CNT(온라인입사지원수)
	'4:EMAIL_CNT(이메일입사지원수)
	'5:CAREER_CNT(커리어양식입사지원수)
	'6:FREE_CNT(자유양식입사지원수)
	'7:COMPANY_CNT(자사양식입사지원수)
	'8:BEFORE_CNT(심사전)
	'9:ING_CNT(심사중)
	'10:PAPERS_CNT(서류합격)
	'11:FINAL_CNT(최종합격)
	'12:FAILURE_CNT(불합격)
	'13:FILLTER_CNT(필터링)

DisconnectDB DBCon
%>
<script type="text/javascript">
	function goApplySel(mode, jid, pid) {
        $("#mode_sub").val(mode);
        $("#jid_sub").val(jid);
        $("#pid_sub").val(pid);

        $('#frm_sub').attr('action', '<%=Request.ServerVariables("PATH_INFO")%>');
        $('#frm_sub').submit();
    }


	//채용정보 수정/복사
    function fn_jobpost_modify(mode, jid) {
        var url = "<%=g_members_wk%>/biz/jobpost/jobpost_modify_fair?jid=" + jid + "&mode=" + mode + "&site_code=<%=site_code%>";
        location.href = url;
    }

	//채용정보 마감
    function fn_jobpost_end(mode, jid) {
        if (mode != "ing") {
            alert("마감할 수 없는 상태의 채용공고 입니다.");
            return;
        }
        if (!confirm("해당 공고를 마감하시겠습니까?")) {
            return;
        }

        var param = {};
        param.mode = mode;
        param.jid = jid;

        $.ajax({
            type: "POST",
            url: "/company/applyjob/jobpostEnd.asp",
            data: param,
            dataType: "html",
            success: function (data) {
                var rtn_data = data.split("|");
                if (rtn_data[0] == "0") {
                    alert(rtn_data[1]);
                    return false;
                } else if (rtn_data[0] == "1") {
                    alert("해당 공고의 마감이 완료되었습니다.");
					//location.reload();
					location.href = "/company/applyjob/whole.asp";
                } else {
                    alert("서버 데이터 오류: 관리자에게 문의하세요. code=" + data);
                    location.reload();
                }
            },
            error: function (xhr) {
                var status = xhr.status;
                var responseText = xhr.responseText;
                alert(responseText + '//');
            }
        });
    }

    //채용정보 삭제
    function fn_jobpost_del(mode, jid) {
        if (!confirm("해당 공고를 삭제하시겠습니까?")) {
            return;
        }

        var param = {};
        param.mode = mode;
        param.jid = jid;

        $.ajax({
            type: "POST",
            url: "/company/applyjob/jobpostDel.asp",
            data: param,
            dataType: "html",
            success: function (data) {
                if (data == "0") {
                    alert("공고 삭제 실패: 관리자에게 문의하세요.");
                    return false;
                } else if (data == "1") {
                    alert("해당 공고의 삭제가 완료되었습니다.");
                    //location.reload();
					location.href = "/company/applyjob/whole.asp";
                } else {
                    alert("서버 데이터 오류: 관리자에게 문의하세요. code=" + data);
                    location.reload();
                }
            },
            error: function (xhr) {
                var status = xhr.status;
                var responseText = xhr.responseText;
                alert(responseText + '//');
            }
        });
    }

</script>
			<form id="frm_sub" name="frm_sub" method="post" action="">
				<input type="hidden" id="mode_sub" name="mode" value="" />
				<input type="hidden" id="jid_sub" name="jid" value="" />
				<input type="hidden" id="pid_sub" name="pid" value="" />
			</form>

			<div class="layoutBox bdr">
				<div class="selRecruitArea">
					<div class="lt mulSelBox">
						<a href="javascript:" class="tit"><span><%=str_jobState%></span> <em><%=str_jobTitle%></em></a>
						<div id="mulSelBox" class="multiSelect">
							<% If isArray(arrRsJoblist(0)) Then %>
							<dl>
								<dt>진행중인 채용공고</dt>
								<% For i=0 To UBound(arrRsJoblist(0), 2) %>
								<dd><a href="javascript:" class="ing" onclick="goApplySel('ing', '<%=arrRsJoblist(0)(0, i)%>', '0')"><%=arrRsJoblist(0)(1, i)%></a></dd>
								<% Next %>
							</dl><!--.deth2-->
							<% End If %>

							<% If isArray(arrRsJoblist(1)) Then %>
							<dl>
								<dt>마감된 채용공고</dt>
								<% For i=0 To UBound(arrRsJoblist(1), 2) %>
								<dd><a href="javascript:" class="end" onclick="goApplySel('cl', '<%=arrRsJoblist(1)(0, i)%>', '0')"><%=arrRsJoblist(1)(1, i)%></a></dd>
								<% Next %>
							</dl><!--.deth2-->
							<% End If %>
						</div><!-- .multiSelect -->
					</div><!-- .mulSelBox -->

					<ul class="rt">
						<li><a href="/jobs/view.asp?id_num=<%=jid%>">공고보기</a></li>
						<li>
							<a href="javascript:" class="toggle">공고관리</a>
							<div class="tooltipArea">
								<div class="box">
									<ul>
										<% If mode = "ing" Then %>
										<li><a href="javascript:" onclick="fn_jobpost_modify('EDIT', '<%=jid%>')">수정</a></li>
										<li><a href="javascript:" onclick="fn_jobpost_modify('LOAD', '<%=jid%>')">복사</a></li>
										<li><a href="javascript:" onclick="fn_jobpost_end('ing', '<%=jid%>')">마감</a></li>
										<li><a href="javascript:" onclick="fn_jobpost_del('ing', '<%=jid%>')">삭제</a></li>
										<% ElseIf mode = "cl" Then %>
										<li><a href="javascript:" onclick="fn_jobpost_modify('LOAD', '<%=jid%>')">복사</a></li>
										<li><a href="javascript:" onclick="fn_jobpost_del('cl', '<%=jid%>')">삭제</a></li>
										<% End If %>
									</ul>
								</div><!-- .box -->
							</div>
						</li>
					</ul><!-- .rt -->
				</div><!-- .selRecruitArea -->

                <div class="currentArea">
                    <ul class="spl6">
                        <!-- 2017/09/25/hjyu 링크추가 -->
                        <li>
                            <dl>
                                <dt>전체 지원자</dt>
                                <dd><a href="javascript:" onclick="goApply('0')"><em<%If pid="0" Then%> class="fc_blu05"<%End If%>><%=total_cnt%></em></a></dd>
                            </dl>
                        </li>
                        <li>
                            <dl>
                                <dt>미열람</dt>
                                <dd><a href="javascript:" onclick="goApply('1')"><em<%If pid="1" Then%> class="fc_blu05"<%End If%>><%=not_open_cnt%></em></a></dd>
                            </dl>
                        </li>
                        <li>
                            <dl>
                                <dt>검토중</dt>
                                <dd><a href="javascript:" onclick="goApply('2')"><em<%If pid="2" Then%> class="fc_blu05"<%End If%>><%=ing_cnt%></em></a></dd>
                            </dl>
                        </li>
                        <li>
                            <dl>
                                <dt>서류합격</dt>
                                <dd><a href="javascript:" onclick="goApply('3')"><em<%If pid="3" Then%> class="fc_blu05"<%End If%>><%=papers_cnt%></em></a></dd>
                            </dl>
                        </li>
                        <li>
                            <dl>
                                <dt>최종합격</dt>
                                <dd><a href="javascript:" onclick="goApply('4')"><em<%If pid="4" Then%> class="fc_blu05"<%End If%>><%=final_cnt%></em></a></dd>
                            </dl>
                        </li>
                        <li>
                            <dl>
                                <dt>불합격</dt>
                                <dd><a href="javascript:" onclick="goApply('5')"><em<%If pid="5" Then%> class="fc_blu05"<%End If%>><%=failure_cnt%></em></a></dd>
                            </dl>
                        </li>
                    </ul>
                </div><!-- .currentArea -->

                <div class="notiArea">
                    <ul>
                        <li>ㆍ채용공고 게재기간은 <strong>접수시작일로부터 최대 90일까지</strong>입니다.</li>
						<!--
                        <li>ㆍ동시게재는 최대 5개까지 가능. 초과 등록된 공고는 ‘게재 대기중’ 상태가 되며, <strong>유료서비스 신청 시에는 초과하여 게재 가능</strong>합니다.</li>
                        <li>ㆍ대기 중 채용공고는 <strong>접수마감</strong>일까지 보관되며, 보관 기간 만료 시 자동 삭제 됩니다. 단, 보관기간은 <strong>공고 등록일로부터 최대 30일</strong>을 초과 할 수 없습니다.</li>
						-->
                        <li>ㆍ마감된 채용공고는 <strong>게재종료 후 90일간</strong> 마감 리스트에서 확인 가능합니다. <!--(1년간 장기보관을 원하시면 ‘보관’ 버튼 클릭!)--></li>
                        <li>ㆍ지원자는 <strong>입사지원일로부터 90일간</strong><!-- , <strong>스크랩한 인재는 스크랩일로부터 90일간</strong> --> 확인 가능합니다.</li>
                    </ul>
                </div><!-- .notiArea -->
            </div><!-- .layoutBox bdr -->