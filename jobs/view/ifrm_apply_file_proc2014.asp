<%
	dim folderpath, upfileName, originfileName, fileSize, file_type
	folderpath = request("folderpath")
	upfileName = request("upfileName")
	originfileName = request("originfileName")
	fileSize = request("fileSize")
    file_type = request("file_type")
%>
<html>
<head>
</head>
<body>
	<script type="text/javascript">
	
		document.domain = "career.co.kr";

		if(parent) {
            var listbody = parent.$('#fileListBody');
            var listbody2 = parent.$('#fileListBody2');
            
			var fileType = "<%=file_type %>";     //parent.fileSendForm.file_type.value;
            var chkViewYN = ' style="display:block;" ';


            var curFileCount = parent.$('#fileListBody li').length;

			var html = ''
                    + '<li '+ chkViewYN+' id="li_<%=upfileName %>">\n'
                    + ' <input class="chk" type="checkbox" id="regFile" name="regFile"  style="display:none;"  checked  />\n'
                    + '	<input type="hidden" name="folderpath" value="<%=folderpath%>" />\n'
					+ '	<input type="hidden" name="upfilename" value="<%=upfileName%>" />\n'
					+ '	<input type="hidden" name="originfilename" value="<%=replace(originfileName,"'","\'")%>" />\n'
					+ '	<input type="hidden" name="filesize" value="<%=filesize%>" /></td>\n'

                    + '		<select class="select" id="regFileType" name="regFileType">\n'
					+ '			<option value="">구분</option>\n'
					+ '			<option value="A"' + (fileType=='A'?' selected':'') + '>이력서</option>\n'
					+ '			<option value="B"' + (fileType=='B'?' selected':'') + '>경력기술서</option>\n'
					+ '			<option value="C"' + (fileType=='C'?' selected':'') + '>자격증</option>\n'
					+ '			<option value="D"' + (fileType=='D'?' selected':'') + '>어학성적표</option>\n'
					+ '			<option value="E"' + (fileType=='E'?' selected':'') + '>증명서</option>\n'
					+ '			<option value="F"' + (fileType=='F'?' selected':'') + '>포트폴리오</option>\n'
					+ '			<option value="G"' + (fileType=='G'?' selected':'') + '>추천서</option>\n';

            if ( fileType == "X" || fileType == "Y")
			{
                html += '			<option value="X"' + (fileType=='X'?' selected':'') + '>자유양식</option>\n'
				html += '			<option value="Y"' + (fileType=='Y'?' selected':'') + '>자사양식</option>\n'
            }


			html += '			<option value="Z"' + (fileType=='Z'?' selected':'') + '>기타</option>\n'
					+ '		</select>\n'

					+ '	<span class="input"><%=originfileName%></span>\n'
					+ '	<a href="#" onclick="fnChkSlt(this);return false;"><img src="http://image.career.co.kr/career_new3/view/popup/btn_fileAppend.gif" alt="첨부하기22" /></a>\n'
                    + '    <button class="btn" onclick="fn_file_delete(this);" title="첨부파일 삭제" style="display:none;">첨부파일 삭제</button>\n'
					+ '</li>\n'

			listbody.append(html);



            var html2 = "";
            var tmpFileType = "";
            switch(fileType){
                case "A":{
                tmpFileType = "이력서";
                break;
                }
                case "B":{
                tmpFileType = "경력기술서";
                break;
                }
                case "C":{
                tmpFileType = "자격증";
                break;
                }
                case "D":{
                tmpFileType = "어학성적표";
                break;
                }
                case "E":{
                tmpFileType = "증명서";
                break;
                }
                case "F":{
                tmpFileType = "포트폴리오";
                break;
                }
                case "G":{
                tmpFileType = "추천서";
                break;
                }
                case "X":{
                tmpFileType = "자유양식";
                break;
                }
                case "Y":{
                tmpFileType = "자사양식";
                break;
                }
                case "Z":{
                tmpFileType = "기타";
                break;
                }
            }

			/*
            var _tmpName = "";
            html2 = "<li id='li2_<%=upfileName%>'>"
            html2 += "	<strong>"+ tmpFileType +"</strong>";
            html2 += "	<span><%=replace(originfileName,"'","\'")%>";
            html2 += "		<a href='#' onclick='fnAttRemove(this, \"" + curFileCount  + "\");return false;'><img src='http://image.career.co.kr/career_new3/view/btn_comment_delete.gif' alt='삭제' /></a>"
            html2 += "	</span>";
            html2 += "</li>";
			*/
			
			var _originfileName = "<%=replace(originfileName,"'","\'")%>";
			html2 += "<li id='li2_<%=upfileName%>'>";
			html2 += "	<p>" + _originfileName + "</p>";
			html2 += "	<p><button type='button' onclick='fnAttRemove(this, \"" + curFileCount  + "\");return false;'>삭제</button></p>";
			html2 += "</li>";


            listbody2.append(html2);
			parent.fileSendForm.reset();

            var curFileCount2 = parent.$('#fileListBody2 li').length;
            var numIfrHeight2 = 0;
            numIfrHeight2 = (curFileCount2 * 35);   // + 115;
                
                
            var numIfrHeight = 0;
            numIfrHeight = (curFileCount * 33) + numIfrHeight2;
            //parent.fnReSizeView("fileListBody");
		}
	</script>
</body>
</html>