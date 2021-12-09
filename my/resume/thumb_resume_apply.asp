<object runat="server" progid="ADODB.Connection" id="dbCon"></object>
<%
	Option Explicit

	Response.CacheControl = "no-cache"
	Response.AddHeader "Pragma", "no-cache"
	Response.Expires = -1
	Response.Charset = "euc-kr"
%>
<!--#include virtual = "/common/constant.asp"-->
<%
	Dim datepath, sourcepath
	datepath = Left(replace(FormatDateTime(Now(), 2),"-",""), 6)
	sourcepath = "D:\solution\"& site_title &"\files\resume\" & datepath & "\"

	dim targetpath : targetpath = "D:\solution\"& site_title &"\files\mypic\"

	dim tfolder: tfolder = formatdatetime(date,2)
	tfolder=left(replace(tfolder,"-",""),6)
	targetpath= targetpath & tfolder & "\"

	Dim fso
	set fso = server.CreateObject("Scripting.FileSystemObject")
	If Not fso.FolderExists(targetpath) Then fso.CreateFolder targetpath End If
	
	dim x1, y1, x2, y2, orgnWidth, orgnHeight, dispWidth, dispHeight, cropWidth, cropHeight, oldimgpath, uid, curDomain
	x1 = request("x1")
	y1 = request("y1")
	x2 = request("x2")
	y2 = request("y2")
	orgnWidth = request("orgnWidth")
	orgnHeight = request("orgnHeight")
	dispWidth = request("dispWidth")
	dispHeight = request("dispHeight")
	cropWidth = request("cropWidth")
	cropHeight = request("cropHeight")
	oldimgpath = request("oldimgpath")
	uid = request("uid")
	curDomain = request("curDomain")
	
	' cropWidth = 132 : cropHeight = 172	' �̷¼� ��������� ����
	
	if uid="" then
		response.write "<script type='text/javascript'>" & vbcrlf &_
			"	alert('�� ���񽺸� �̿��ϱ� ���ؼ��� ����ȸ�� �α����� �ʿ��մϴ�.\n�α��� �� �̿��� �ֽñ� �ٶ��ϴ�.');" & vbcrlf &_
			"</script>"
		response.end
	end if
	
	if x1="" or y1="" or x2="" or y2="" or orgnWidth="" or orgnHeight="" or dispWidth="" or dispHeight="" or cropWidth="" or cropHeight="" or oldimgpath="" then
		response.write "<script type='text/javascript'>" & vbcrlf &_
			"	alert('���� ������ Ȯ������ �ʽ��ϴ�.');" & vbcrlf &_
			"</script>"
		response.end
	end if
	
	dim nx1, ny1, nx2, ny2	' ���� ��ǥ��
	nx1 = cint((orgnWidth / dispWidth) * x1)
	ny1 = cint((orgnHeight / dispHeight) * y1)
	nx2 = cint((orgnWidth / dispWidth) * x2)
	ny2 = cint((orgnHeight / dispHeight) * y2)

	Randomize()
	dim randomno : randomno = Int(10000* Rnd())
	randomno = right("0000"&randomno,5)
	dim newFileName : newFileName = replace(replace(uid,"_wk",""),"_dm","") & ".jpg"
	
	On Error Resume Next

	dim resizer
	set resizer = Server.CreateObject("ASPPhotoResizer.Resize")

	resizer.LoadFromFile sourcepath & oldimgpath
	resizer.JPGQuality = 100
	resizer.CropImage nx1, ny1, nx2, ny2
	resizer.ResizeImage cropWidth, cropHeight
	resizer.SaveToFile targetpath & newFileName

	set resizer = Nothing

	'���Ϻ��� �� �������� ����
	If fso.FileExists(sourcepath & oldimgpath) Then fso.DeleteFile sourcepath & oldimgpath

	if Err.Number > 0 then
		response.write "<script type='text/javascript'>" & vbcrlf &_
			"	alert('���� ó�� ���� ������ �߻��Ͽ����ϴ�.\n�����̴� gif ������ �������� �����Ƿ� ������ �ٽ� �� �� Ȯ�����ֽñ� �ٶ��ϴ�.');" & vbcrlf &_
			"</script>"
		Response.end
	end if
	
	dim strsql, str, strDBCon
	
	strDBCon = "DBInfo_FAIR"
	
	strsql = "UPDATE ����ȸ������ SET �������� = '" & tfolder & "/" & newFileName & "'"
	strsql = strsql & " WHERE ���ξ��̵� = '" & uid & "'"
	strsql = strsql & " ; UPDATE �̷¼� SET �������� = '1', ��������='" & tfolder & "/" & newFileName & "'"
	strsql = strsql & " WHERE ���ξ��̵� = '" & uid & "'"
	strsql = strsql & " ; UPDATE �̷¼��������� SET �������� = '1', ��������='" & tfolder & "/" & newFileName & "'"
	strsql = strsql & " WHERE ���ξ��̵� = '" & uid & "'"

	dbCon.Open Application(strDBCon)
	dbCon.Execute (strsql)
	dbCon.Close
	
	Dim SetPhotoPath
	SetPhotoPath = "http://" & Request.ServerVariables("SERVER_NAME") & "/files/mypic/" & tfolder & "/" & newFileName

	Call setCookie(site_code & "WKP_F", "photo", "career.co.kr", SetPhotoPath)
	
	response.write "<script type='text/javascript'>" & vbcrlf &_
		"try { " & vbcrlf
	response.write "	top.fn_resume_apply_after('" & tfolder & "/" & newFileName & "');" & vbcrlf &_
		"} catch(e) { alert(e.description); }" & vbcrlf &_
		"</script>"
	response.end
%>