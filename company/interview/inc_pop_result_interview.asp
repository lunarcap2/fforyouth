<%
response.expires = -1
response.cachecontrol = "no-cache"
response.charset = "euc-kr"
%>

<!--include virtual = "/include/header/header.asp"-->
<!--#include virtual = "/inc/function/code_function.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->

<script type="text/javascript">
	$(document).ready(function () {
		$(".acco li a").click(function(){
			$(this).toggleClass('on');
			$(this).next().slideToggle(300);
			$(".acco li a").not(this).next().slideUp(300);
			$(".acco li a").not(this).removeClass('on');
			return false;
		});

		//비활성화 클래스명
		$(".disable").attr("readonly",true);
		$(".disable , .disable input").attr("disabled","disabled");

        var _rdi = $('.rdi').parent();
        _rdi.unbind().each(function() {
            if ($(this).find('input').is(':checked')) {
                $(this).removeClass('off').addClass('on');
            }else if ($(this).find('input').is('[disabled=disabled]'))//비활성화시킬때
			{
				//$(this).find("span").css({'color':'#a8a8a8','cursor':'default'});
				//$(this).find('input').attr('name','disable')
			} else {
                $(this).removeClass('on').addClass('off');
            }
        }).bind('click', function() {
            var _name = $(this).find('input').attr('name');
            var _radio = $('label input[name$='+_name+']');
            var _index = _radio.parent().index(this);
            _radio.each(function(index, value) {
                if (_index == index) {
                    $(this).checked = true;
                    $(this).parent().removeClass('off').addClass('on');
					if ($(this).is('[disabled=disabled]'))
					{
						$(this).parent().removeClass('on');
						$(this).find('input').is('[disabled=disabled]').attr("disabled","disabled");
					}
                } else {
                    $(this).checked = false;
                    $(this).parent().removeClass('on').addClass('off');
                }
            });
        });
        
        $('input:radio').click(function() {
            $('input:radio[name='+$(this).attr('name')+']').parent().removeClass('on');
            $(this).parent().addClass('on');
        });
	});
</script>

<%
	Dim pop_apply_num, pop_interview_time, pop_interview_day, pop_mode, pop_jid
	pop_apply_num = Request("_apply_num")
	pop_interview_time = Request("_interview_time")
	pop_interview_day = Request("_interview_day")
	pop_mode = Request("_mode")
	pop_jid = Request("_jid")

	ConnectDB DBCon, Application("DBInfo_FAIR")
	
	Dim arrRsPopInterview
	ReDim param(12)

	param(0)  = makeParam("@MODE",				adVarchar, adParamInput, 20, pop_mode)
	param(1)  = makeParam("@JOBS_ID",			adInteger, adParamInput, 4, pop_jid)
	param(2)  = makeParam("@PID",				adVarchar, adParamInput, 1, "3")
	param(3)  = makeParam("@INTERVIEW_N",		adVarchar, adParamInput, 1, "")
	param(4)  = makeParam("@INTERVIEW_DAY",		adVarchar, adParamInput, 10, pop_interview_day)
	param(5)  = makeParam("@INTERVIEW_TIME",	adVarchar, adParamInput, 2, pop_interview_time)
	param(6)  = makeParam("@INTERVIEW_RESULT",	adVarchar, adParamInput, 1, "")
	param(7)  = makeParam("@CONFIRM_YN",		adVarchar, adParamInput, 1, "")
	param(8)  = makeParam("@KW",				adVarchar, adParamInput, 100, "")
	param(9)  = makeParam("@JOB_PART",			adInteger, adParamInput, 4, "")
	param(10) = makeParam("@PAGE",				adInteger, adParamInput, 4, 1)
	param(11) = makeParam("@PAGE_SIZE",			adInteger, adParamInput, 4, 1000)
	param(12) = makeParam("@TOTAL_CNT",			adInteger, adParamOutput, 4, 0)

	arrRsPopInterview = arrGetRsSP(dbCon, "usp_기업서비스_면접배정_리스트", param, "", "")



'<!-- 결과 -->
Response.write "	<div class=""acco_area"">"
Response.write "		<p class=""date"">" & pop_interview_day & " <span>" & getInterviewTime(pop_interview_time) & "</span></p>"
Response.write "		<ul class=""acco"">"
			
If isArray(arrRsPopInterview) Then 
	For i = 0 to ubound(arrRsPopInterview, 2)
	
	'생년월일 나이
	Dim birth_ymd
	If arrRsPopInterview(6, i) = "1" Or arrRsPopInterview(6, i) = "2" Then
		birth_ymd = "19" & arrRsPopInterview(5, i)
	Else
		birth_ymd = "20" & arrRsPopInterview(5, i)
	End If
	Dim user_age : user_age = Year(now) - Left(birth_ymd, 4) + 1

	'경력표기
	Dim career_str, tot_sum
	tot_sum = Abs(arrRsPopInterview(11, i))

	If tot_sum = "0" Then 
		career_str = "신입"
	ElseIf tot_sum > 12 Then
		career_str = "경력 " & fix(tot_sum / 12) & "년 " & tot_sum mod 12 & "개월"
	Else 
		career_str = "경력 " & tot_sum & "개월"
	End If
	
	Dim arrRsSchool : arrRsSchool = ""
	strSql = " SELECT 학교명, 졸업구분 FROM 이력서학력 WHERE 등록번호 = '" & arrRsPopInterview(2,i) & "' AND 학력종류 = '" & arrRsPopInterview(9,i) & "' "
	arrRsSchool = arrGetRsParam(dbCon, strSql, "", "", "")

	If isArray(arrRsSchool) Then
		'최종학력
		Dim strFinalSchool : strFinalSchool = ""
		Select Case arrRsPopInterview(9, i)
			Case "3" : strFinalSchool = "고등학교"
			Case "4" : strFinalSchool = "대학(2,3년)"
			Case "5" : strFinalSchool = "대학교(4년)"
			Case "6" : strFinalSchool = "대학원"
		End Select

		Dim GraduatedState, Education
		Select Case arrRsSchool(1,0)
			Case "3" : GraduatedState = "재학"
			Case "4" : GraduatedState = "휴학"
			Case "5" : GraduatedState = "중퇴"
			Case "7" : GraduatedState = "졸업(예)"
			Case "8" : GraduatedState = "졸업"
		End Select

		Education = "  ㅣ  " & arrRsSchool(0,0) & "&nbsp;" & strFinalSchool & "&nbsp;" & GraduatedState & "  ㅣ  " & career_str
	Else
		Education = "  ㅣ  " & career_str
	End If
	
	Dim chk1:chk1 = ""
	Dim chk2:chk2 = ""
	Dim chk3:chk3 = ""
	Dim chk4:chk4 = ""
	If arrRsPopInterview(27,i) Then
		Select Case arrRsPopInterview(27,i)
			Case "6" : chk1 = "checked"
			Case "7" : chk2 = "checked"
			Case "8" : chk3 = "checked"
			Case "9" : chk4 = "checked"
		End Select
	End If

	'라디오의 id값 개별로 설정하기 위해 사용
	Dim num

Response.write "			<li>" 
Response.write "				<a href=""#none"">" & arrRsPopInterview(4,i) & "(" & Left(birth_ymd, 4) & "년생, " & user_age & "세)" & Education & "</a>"
If CInt(pop_apply_num) = CInt(arrRsPopInterview(14,i)) Then
Response.write "				<div class=""acco_txt"" style=""display:block;"">"
Else
Response.write "				<div class=""acco_txt"">"
End If
Response.write "					<input type=""hidden"" value=""" & arrRsPopInterview(14,i) & """/>"
Response.write "					<div class=""chk_area"">"
Response.write "						<label class=""radiobox off"" for=""acco_chk" & CInt(num) & """>"
Response.write "							<input type=""radio"" class=""rdi"" id=""acco_chk" & CInt(num) & """ name=""achk" & i & """ value=""6""" & chk1 & ">"
Response.write "							<span>단순상담</span>"
Response.write "						</label>"
	num = num + 1
Response.write "						<label class=""radiobox off"" for=""acco_chk" & CInt(num) & """>"
Response.write "							<input type=""radio"" class=""rdi"" id=""acco_chk" & CInt(num) & """ name=""achk" & i & """ value=""7""" & chk2 & ">"
Response.write "							<span>추가전형 진행</span>"
Response.write "						</label>"
	num = num + 1
Response.write "						<label class=""radiobox off"" for=""acco_chk" & CInt(num) & """>"
Response.write "							<input type=""radio"" class=""rdi"" id=""acco_chk" & CInt(num) & """ name=""achk" & i & """ value=""8""" & chk3 & ">"
Response.write "							<span>면접불참</span>"
Response.write "						</label>"
	num = num + 1
Response.write "						<label class=""radiobox off"" for=""acco_chk" & CInt(num) & """>"
Response.write "							<input type=""radio"" class=""rdi"" id=""acco_chk" & CInt(num) & """ name=""achk" & i & """ value=""9""" & chk4 & ">"
Response.write "							<span>기타</span>"
Response.write "						</label>"
	num = num + 1
Response.write "					</div>"
Response.write "					<textarea>" & arrRsPopInterview(28,i) & "</textarea>"
Response.write "				</div>"
Response.write "			</li>"
	Next
End If 
Response.write "		</ul>"
Response.write "	</div>"
'<!-- 결과 -->

	DisconnectDB DBCon
%>