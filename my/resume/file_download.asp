<%
'option explicit

Session.CodePage = "949"
Response.ChaRset = "EUC-KR"

Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache" 
Response.Expires = -1
%>
<!--#include virtual = "/common/constant.asp"-->
<%
Dim fileid1, fileid2
Dim downpath

fileid1 = Request("fileid1")
fileid2 = Request("fileid2")

downpath = "D:\solution\"& site_title &"\files\resume\" & fileid2
'downpath = "\\218.145.70.142\files$\files\fair\resume\" & fileid2


Set object = server.CreateObject("Scripting.FileSystemObject")

If object.FileExists(downpath)=True Then 

	Response.ContentType = "application/unknown"
	Response.AddHeader "Content-Disposition","attachment;filename=" & fileid1
	Response.AddHeader "Content-Transfer-Encoding","binary"

	Dim Stream
	Dim download
	Set Stream=Server.CreateObject("ADODB.Stream")
	Stream.Open
	Stream.Type=1
	Stream.LoadFromFile downpath
	download = Stream.Read
	Response.BinaryWrite download
	Set Stream = Nothing

Else
	Response.write "<script language='javascript'>"
	Response.write "alert('해당 파일을 찾을 수 없습니다.');"
	Response.write "history.back();"
	Response.write "</script>"
End If 
%>
