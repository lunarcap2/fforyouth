<!DOCTYPE html>
<html lang="ko">
    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
    <meta name="author" content="희망을 전하는 취업포털 커리어 old.career.co.kr" />
    <meta name="copyright" content="희망을 전하는 취업포털 커리어 old.career.co.kr" />
    <meta property="og:type" content="website" />
    <meta http-equiv="imagetoolbar" content="no" />
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <meta property="og:image" content="http://imgs.career.co.kr/service/kangso.jpg" />
    <meta property="og:image:type" content="image/jpeg">
    <meta property="og:image:width" content="300">
    <meta property="og:image:height" content="300">
    <meta property="og:title" content="커리어 - 국내 최대 중견강소기업 채용정보"/>
    <title>커리어 - 국내 최대 중견강소기업 채용정보</title>
    <meta name="description" content="구인, 구직, 구인검색, 구직검색, 취업정보, 채용정보, 구직정보, 구인정보, 취업가이드, 경력관리, 커리어, CAEEER, Career, 헤드헌팅, 파견.대행, 아웃소싱, 인재파견, 채용대행, 교육과정, 교육정보, 취업박람회, 채용박람회, 박람회, 기업정보, 상세기업정보, 취업뉴스, 해외취업, 아르바이트, 알바, 이력서, 대학전산망"/>
    <meta name="Keywords" content="커리어, career, career.co.kr, CAREER, zjfldj, 취업, 사람, 구인, 구직, 구직정보, 구인정보, 이력서 , resume, dlfurtj, 아르바이트, 알바, alba, dkfmqkdlxm, dkfqk, 헤드헌팅, 서치펌, 고용, 고용정보, 취업정보, 취업뉴스, 취업 뉴스, 취업속보, 취업 속보, 공채속보, 공채 속보, 공채, 취업포털, 채용포털, 채용, 채용정보, 취업사이트, 구직사이트, 구인사이트, 인터넷채용시스템, 인터넷취업시스템, 고용정보, 취업교육, 대기업, 중견기업, 중소기업, 일반기업, 일자리, 벤처기업, 워크, work, 잡, job, 재취업, 여성취업, cnldjq, rndls, rnwlr, 전직, 재취업, 정보통신취업, it취업, 임원, ceo, 리쿠르트,  리크루트, 헤드헌팅 파견.대행, 아웃소싱, 인재파견, 채용대행, 위탁도급, 파견임시, 취업박람회, 채용박람회, 일자리박람회, 박람회, 취업교육, 취업교육센터, 교육, 교육과정, 교육정보, 교육기관, 외국계기업, 외국인업체, 외국인기업, 자원봉사, 프리랜서, 취업상담실, 해외취업, 취업성공, 성공취업, joblink, jobsns, jobfair, work, recruit, saram, tkfka, pay, cnldjq, zjfldj"/>
	
	<!-- 공통 CSS -->
    <link href="http://old.career.co.kr/css/jquery-ui.css" rel="stylesheet" type="text/css" />
	<link href="http://old.career.co.kr/css/reset_2015.css" rel="stylesheet" type="text/css" />
	<link href="../css/comm_2016.css" rel="stylesheet" type="text/css" /><!-- 수정 2018.03.28 파일은 적용후 루트경로에도 적용부탁드립니다. -->
    <!--// 공통 CSS -->

    <!-- 개인회원 CSS -->
	<link href="css/reference_2016.css" rel="stylesheet" type="text/css" />
    <!--// 개인회원 CSS -->
</head>

<body>
	<div class="popImg">
	<% Dim gubun
	gubun = request("gubun") 
	
	If gubun = "1" Then %>
		<img src="http://image.career.co.kr/career_new4/common/img_oci_zoom01.jpg" alt="인성검사 예시1">

	<% ElseIf gubun = "2" Then  %>
		<img src="http://image.career.co.kr/career_new4/common/img_oci_zoom02.jpg" alt="인성검사 예시2">

	<% ElseIf gubun = "3" Then  %>
		<img src="http://image.career.co.kr/career_new4/common/img_oat_zoom01.jpg" alt="적성검사 예시1">
	
	<% ElseIf gubun = "4" Then  %>
		<img src="http://image.career.co.kr/career_new4/common/img_oat_zoom02.jpg" alt="적성검사 예시2">

	<% End If  %>
	</div>
</body>
</html>
