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
					+ '			<option value="">����</option>\n'
					+ '			<option value="A"' + (fileType=='A'?' selected':'') + '>�̷¼�</option>\n'
					+ '			<option value="B"' + (fileType=='B'?' selected':'') + '>��±����</option>\n'
					+ '			<option value="C"' + (fileType=='C'?' selected':'') + '>�ڰ���</option>\n'
					+ '			<option value="D"' + (fileType=='D'?' selected':'') + '>���м���ǥ</option>\n'
					+ '			<option value="E"' + (fileType=='E'?' selected':'') + '>����</option>\n'
					+ '			<option value="F"' + (fileType=='F'?' selected':'') + '>��Ʈ������</option>\n'
					+ '			<option value="G"' + (fileType=='G'?' selected':'') + '>��õ��</option>\n';

            if ( fileType == "X" || fileType == "Y")
			{
                html += '			<option value="X"' + (fileType=='X'?' selected':'') + '>�������</option>\n'
				html += '			<option value="Y"' + (fileType=='Y'?' selected':'') + '>�ڻ���</option>\n'
            }


			html += '			<option value="Z"' + (fileType=='Z'?' selected':'') + '>��Ÿ</option>\n'
					+ '		</select>\n'

					+ '	<span class="input"><%=originfileName%></span>\n'
					+ '	<a href="#" onclick="fnChkSlt(this);return false;"><img src="http://image.career.co.kr/career_new3/view/popup/btn_fileAppend.gif" alt="÷���ϱ�22" /></a>\n'
                    + '    <button class="btn" onclick="fn_file_delete(this);" title="÷������ ����" style="display:none;">÷������ ����</button>\n'
					+ '</li>\n'

			listbody.append(html);



            var html2 = "";
            var tmpFileType = "";
            switch(fileType){
                case "A":{
                tmpFileType = "�̷¼�";
                break;
                }
                case "B":{
                tmpFileType = "��±����";
                break;
                }
                case "C":{
                tmpFileType = "�ڰ���";
                break;
                }
                case "D":{
                tmpFileType = "���м���ǥ";
                break;
                }
                case "E":{
                tmpFileType = "����";
                break;
                }
                case "F":{
                tmpFileType = "��Ʈ������";
                break;
                }
                case "G":{
                tmpFileType = "��õ��";
                break;
                }
                case "X":{
                tmpFileType = "�������";
                break;
                }
                case "Y":{
                tmpFileType = "�ڻ���";
                break;
                }
                case "Z":{
                tmpFileType = "��Ÿ";
                break;
                }
            }

			/*
            var _tmpName = "";
            html2 = "<li id='li2_<%=upfileName%>'>"
            html2 += "	<strong>"+ tmpFileType +"</strong>";
            html2 += "	<span><%=replace(originfileName,"'","\'")%>";
            html2 += "		<a href='#' onclick='fnAttRemove(this, \"" + curFileCount  + "\");return false;'><img src='http://image.career.co.kr/career_new3/view/btn_comment_delete.gif' alt='����' /></a>"
            html2 += "	</span>";
            html2 += "</li>";
			*/
			
			var _originfileName = "<%=replace(originfileName,"'","\'")%>";
			html2 += "<li id='li2_<%=upfileName%>'>";
			html2 += "	<p>" + _originfileName + "</p>";
			html2 += "	<p><button type='button' onclick='fnAttRemove(this, \"" + curFileCount  + "\");return false;'>����</button></p>";
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