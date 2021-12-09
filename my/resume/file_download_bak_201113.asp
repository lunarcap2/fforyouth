<%
option explicit

Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache" 
Response.Expires = -1
%>
<!--#include virtual = "/common/constant.asp"-->
<%
dim dbcon,strsql,fileRs,rid,file
dim fileid1,fileid2
fileid1 = Request("fileid1")
fileid2 = Request("fileid2")


set file = Server.CreateObject("ActiveFile.File")
file.Name = "D:\solution\"& site_title &"\files\resume\" & fileid2
Response.write "D:\solution\"& site_title &"\files\resume\" & fileid2

if not file.Exists() then
	response.write "선택하신 파일이 존재하지 않습니다."
	response.end
end if

Response.ContentType = "application/unknown"    'ContentType 를 선언합니다.
Response.Addheader "Content-Disposition", "attachment;filename=" & fileid1
File.Download

Response.End
%>