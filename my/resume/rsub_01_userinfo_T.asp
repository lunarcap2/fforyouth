<!--
<link href="/css/Jcrop.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="http://www4.career.co.kr/js/jquery-1.5.1.js"></script>
<script type="text/javascript" src="/js/tools.js"></script>
<script type="text/javascript" src="/js/photo_cropper.js"></script>
<script type="text/javascript" src="/js/Jcrop.js"></script>
-->

<script type="text/javascript">
	function fn_userphone_div(obj) {
		if (obj.value.length >= 12) {
			var split_val = obj.value.split('-');
			if (split_val.length == 3) {
				$(obj).prevAll("#user_cell1").val(split_val[0]);
				$(obj).prevAll("#user_cell2").val(split_val[1]);
				$(obj).prevAll("#user_cell3").val(split_val[2]);
			}
		} else {
			$(obj).prevAll("#user_cell1").val("");
			$(obj).prevAll("#user_cell2").val("");
			$(obj).prevAll("#user_cell3").val("");
		}
	}

	function fn_useremail_div(obj) {
		if (obj.value.indexOf("@") >= 0) {
			var split_val = obj.value.split('@');
			$("#email1").val(split_val[0]);
			$("#email2").val(split_val[1]);
		} else {
			$("#email1").val("");
			$("#email2").val("");
		}
	}

	function fn_userbirth_div(obj) {
		if (obj.value.length == 10) {
			var split_val = obj.value.split('.');
			$("#birthYY").val(split_val[0]);
			$("#birthMM").val(split_val[1]);
			$("#birthDD").val(split_val[2]);
			if (split_val[0] < 2000) {
				$("#jumin_code").val("1");
			} else {
				$("#jumin_code").val("3");
			}
		} else {
			$("#birthYY").val("");
			$("#birthMM").val("");
			$("#birthDD").val("");
			$("#jumin_code").val("");
		}
	}

	// 이력서 사진 삭제
	function fn_photo_del(){
		if(confirm('입사지원 완료된 지원서를 포함한\n모든 지원서에 등록된 사진이 일괄 삭제됩니다.\n등록된 지원서 사진을 삭제하시겠습니까?')) {
			var obj = document.frm_my_sub_view;
			obj.method = "post";
			obj.action = "/my/my_photo_Del.asp";
			obj.submit();
		}		
	}
</script>
<%
Dim p_birth, p_birthYY, p_birthMM, p_birthDD, p_jumin_code, p_phone, p_phone1, p_phone2, p_phone3, p_email, p_email1, p_email2, p_userName, p_address, p_userPhoto, p_userPhotoURL, p_resumeTitle, p_selfIntro
Dim p_imgbtn : p_imgbtn = "사진 등록"

If isArray(arrComm) Then

	'이력서 공통정보
	p_phone			= arrComm(8, 0)
	If p_phone <> "" Then
		p_phone1		= Split(arrComm(8, 0), "-")(0)
		p_phone2		= Split(arrComm(8, 0), "-")(1)
		p_phone3		= Split(arrComm(8, 0), "-")(2)
	End If
	p_birthYY		= arrComm(1, 0)
	p_birthMM		= arrComm(2, 0)
	p_birthDD		= arrComm(3, 0)
	p_jumin_code	= arrComm(4, 0)
	If p_jumin_code = "1" Or p_jumin_code = "2" Then
		p_birthYY = "19" & p_birthYY
	Else 
		p_birthYY = "20" & p_birthYY
	End If
	p_birth			= p_birthYY & "." & p_birthMM & "." & p_birthDD
	
	p_email			= arrComm(10, 0)
	If p_email <> "" Then
		p_email1		= Split(arrComm(10, 0), "@")(0)
		p_email2		= Split(arrComm(10, 0), "@")(1)
	End If 

	p_userName		= arrComm(0, 0)
	p_address		= arrComm(13, 0)
	'If UBound(Split(arrComm(13, 0), " / ")) > 0 Then
	'	p_address = Split(arrComm(13, 0), " / ")(0)
	'	p_address_dtl = Split(arrComm(13, 0), " / ")(1)
	'End If

	If arrComm(19, 0) <> "" Then 
		p_userPhoto = arrComm(19, 0)
		'p_userPhotoURL = "/files/mypic/" & arrComm(19, 0)
		p_userPhotoURL = "http://www2.career.co.kr/hdrive/fair/mypic/" & arrComm(19, 0)
		p_imgbtn	= "사진 수정"
	End If
Else

	'개인회원정보
	p_phone			= arrUser(7, 0)
	If p_phone <> "" Then
		p_phone1		= Split(arrUser(7, 0), "-")(0)
		p_phone2		= Split(arrUser(7, 0), "-")(1)
		p_phone3		= Split(arrUser(7, 0), "-")(2)
	End If

	p_email			= arrUser(8, 0)
	If p_email <> "" Then
		p_email1		= Split(arrUser(8, 0), "@")(0)
		p_email2		= Split(arrUser(8, 0), "@")(1)
	End If
	
	Response.write arrUser(1,0) & "<br>"
	If arrUser(1,0) <> "" Then
		p_birthYY		= Left(arrUser(1,0),2)
		p_birthMM		= Mid(arrUser(1,0),3,2)
		p_birthDD		= Right(arrUser(1,0),2)
		p_jumin_code	= arrUser(2,0)

		If p_jumin_code = "1" Or p_jumin_code = "2" Then
			p_birthYY = "19" & p_birthYY
		Else 
			p_birthYY = "20" & p_birthYY
		End If

		p_birth			= p_birthYY & "." & p_birthMM & "." & p_birthDD

		Response.write p_birthYY & "<br>"
		Response.write p_birthMM & "<br>"
		Response.write p_birthDD & "<br>"
		Response.write p_jumin_code
	End If
	
	p_userName		= arrUser(0, 0)
	p_address		= arrUser(10, 0)
	If arrUser(11, 0) <> "" Then 
		p_userPhoto = arrUser(11, 0)
		'p_userPhotoURL = "/files/mypic/" & arrUser(11, 0)
		p_userPhotoURL = "http://www2.career.co.kr/hdrive/fair/mypic/" & arrUser(11, 0)
		p_imgbtn	= "사진 수정"
	End If
End If

If isArray(arrResume) Then 
	If rid <> 0 Then p_resumeTitle = arrResume(2, 0)
	p_selfIntro = arrResume(32, 0)
End If 
%>
<div class="input_box" id ="resume1">
	
	<input type="hidden" id="user_photo" name="user_photo" value="<%=Replace(p_userPhoto, "/files/mypic/", "")%>">
	<input type="hidden" id="birthYY" name="birthYY" value="<%=p_birthYY%>">
	<input type="hidden" id="birthMM" name="birthMM" value="<%=p_birthMM%>">
	<input type="hidden" id="birthDD" name="birthDD" value="<%=p_birthDD%>">
	<input type="hidden" id="jumin_code" name="jumin_code" value="<%=p_jumin_code%>">
	<input type="hidden" id="user_cell1" name="user_cell1" value="<%=p_phone1%>">
	<input type="hidden" id="user_cell2" name="user_cell2" value="<%=p_phone2%>">
	<input type="hidden" id="user_cell3" name="user_cell3" value="<%=p_phone3%>">
	<input type="hidden" id="email1" name="email1" value="<%=p_email1%>">
	<input type="hidden" id="email2" name="email2" value="<%=p_email2%>">
	<!-- <input type="hidden" id="resume_title" name="resume_title" value="<%=p_userName%>님의 이력서입니다."> -->
	<input type="hidden" id="address" name="address" value="<%=p_address%>">

	<div class="img_box">
		<span><img src="<%=p_userPhotoURL%>"></span>
		<button name="사진 등록 버튼" type="button" class="btn blue" onclick="window.open('/my/resume/photo_write_new.asp', 'myPhoto', 'width=605,height=765');"><%=p_imgbtn%></button>
	<%If arrUser(11, 0) <> "" Then%>	
		<button name="사진 삭제 버튼" type="button" class="btn gray" onclick="fn_photo_del();">사진 삭제</button>
	<%End If%>
	</div>
	
	<input type="text" id="resume_title" name="resume_title" class="txt" placeholder="이력서 제목을 입력해주세요" value="<%=p_resumeTitle%>" style="width:1080px;">
	<input type="text" id="userName" name="userName" maxlength="15" class="txt" placeholder="이름을 입력해주세요" value="<%=p_userName%>" style="width:535px;">	
	<input type="text" name="user_cell" class="txt" placeholder="연락처를 입력해주세요" value="<%=p_phone%>" onkeyup="numCheck(this, 'int'); changePhoneType(this); fn_userphone_div(this);" maxlength="13" style="width:535px;">	
	<input type="text" name="birth" class="txt" placeholder="생년월일을 입력해주세요 (ex. YYYYMMDD)" value="<%=p_birth%>" onkeyup="numCheck(this, 'int'); changeBirthType(this); fn_userbirth_div(this);" maxlength="10" style="width:535px;">	
	<input type="text" name="email" class="txt" placeholder="E-mail 주소를 입력해주세요" value="<%=p_email%>" onkeyup="fn_useremail_div(this);" maxlength="50" style="width:535px;">	
	<input type="text" id="address_main" name="address_main" class="txt" placeholder="주소를 입력해주세요" value="<%=p_address%>" onclick="openPostCode('','address', 'address_main');" style="width:1080px;" readonly>
	<!-- <input type="text" id="address_dtl" name="address_dtl" class="txt" placeholder="상세 주소를 입력해주세요." value="" style="width:100%;"> -->
	<textarea class="resume_tt" name="self_intro" placeholder="인사담당자의 눈길을 끌 수 있는 간략한 자기소개를 작성해보세요 (5줄 이내로 권장)"><%=p_selfIntro%></textarea>

</div>