<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="in.cdac.acts.connection.DBConnector"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" session="false"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<%
HttpSession session=request.getSession(false);
if(session==null || session.equals(""))
{
%>
	<jsp:forward page="index.jsp?lgn=2"></jsp:forward>
<%	
}
else
{%>
<!--
	@author Prashant Bansod
	@author Ritesh Dhote
	@author Sherin Mathew
	@date 24-05-2012  
	This is the page where admin can see the results -->
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<link rel="stylesheet" href="Css/style.css" type="text/css">
		<script type="text/javascript" src="Js/AdminMenu/MenuBar.js"></script>
		<script type="text/javascript">javascript:window.history.forward(1);</script>
		<script type="text/javascript" src="Js/ResultsAdmin.js"></script>
		
		<style type="text/css">
			.headerTitle
			{
				font-style: italic;
			    font-weight: bold;
			    height: 30px;
			    padding-top: 5px;
			    text-align: left;
			    width: 774px;
			}
		</style>
		
		<title>AdminResults [ePariksha] </title>
	</head>
	
	<body onload="MM_swapImage('Image8','','images/index_20_a.gif',1)">
	<%
		
		if(session.getAttribute("UserId")==null || session.getAttribute("UserName")==null)
		{
			%>
			<jsp:forward page="index.jsp"></jsp:forward>
		<%
		}
		else
		{
				String strCourseId	=	null;
				
				String strUserId	=	session.getAttribute("UserId").toString();
				String strUserName	=	session.getAttribute("UserName").toString();
				
				if (session.getAttribute("CourseId") != null) {
					strCourseId	=	session.getAttribute("CourseId").toString();
				}
				
				String sRoleId		=	session.getAttribute("UserRoleId").toString();
				String strModuleId	=	null;
				String strModuleName=	null;
				String strExamDate	=	null;
				String strCourseName=	null;
				String strShortCourseName=null;
				String selectedCourseId	=	null;
				
				
				
				/**
			 * variables for database connections
			 * */
			DBConnector dbConnector		=	null;			//Creating object of DBConnector class to make database connection.
			Connection connection		=	null;
			PreparedStatement statement =	null;
			ResultSet result			=	null;
			int status					=	0;
				if(request.getParameter("status")!=null)
					status=Integer.parseInt(request.getParameter("status"));
				
				/*if(session.getAttribute("ExamDate")!=null){
				//if(session.getAttribute("ExamDate")!=null && status!=1)
					//session.removeAttribute("ExamDate");
				}*/	
			

			/**
				If trying to come to this page from other user redirect it to index page
			*/
			
			if(!sRoleId.equals("999"))//If trying to come to this page from other user redirect it to index page
			 {%><jsp:forward page="index.jsp"></jsp:forward><%}%>
			
		
	
	
	<div id="mainBody"  align="center" >
	<div id="body_main_banner">
    <div id="topArea"><!-- div Top container -->
      <table width="800px" cellspacing="0" cellpadding="0"><!-- div left banner -->
          <tr>
	            <td width="30%" align="left" valign="top" style="padding-top:3px; padding-left:5px; padding-bottom:0px;">
		            <a href="http://acts.cdac.in"><img src="images/cdac-acts_inner.png" alt="" width="120" height="30" border="0" /></a>
	            </td>
	            <td width="70%" align="right" valign="top" style="padding-top:10px;">
		            <ul>
		            	<li><img alt="Active User" title="Active User" src="images/Profile.png" style="width:24px;height:22px;"></li>
						<li style="padding-top:5px;color: #1C89FF;"><%=strUserName%></li>
						<li><a href="index.jsp"><img src="images/logout.png" alt="Logout" title="Logout" width="24" height="22" border="0" /></a></li>
		            </ul>
	            </td>
            </tr>
       </table><!-- div left banner -->
    </div><!-- div Top container -->
    
   	<div style="width:800px"><!-- Div Banner Area begins-->
        <div  align="left" style="background-color:#A70505">&nbsp;</div>
        <div  style="border-left:#CBCBCB 1px solid;width:800px;"> <!-- Div inner banner holder -->
	          <img src="images/topbanner.gif" width=800px; height=150px;></img>
         </div><!-- Div inner banner holder -->
     </div><!-- Div Banner Area ends-->
       
     <div id="bannerFooter"> <!--Div bannerFooter begins-->
       	<img src="images/belowbanner.png" width=800px; height=25px;/>
     </div> <!--Div bannerFooter ends-->
     
        
        <!-- Menu Bar Begins -->
        <div align="left" style="margin-left:25px;">
	 
	        <table width="600px" border="0" cellspacing="0" cellpadding="0">
	          <tr>
	            
	            <td align="center" valign="middle"><a href="AdminHome.jsp" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image5','','images/index_17_a.gif',1)"><img src="images/index_17.gif" alt="Home" name="Image5" width="100" height="37" border="0" id="Image5" /></a></td>
	              <td align="center" valign="middle"><a href="AdminUserMan.jsp" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image6','','images/index_18_a.gif',1)"><img src="images/index_18.gif" alt="Users" name="Image6" width="100" height="37" border="0" id="Image6" /></a></td>
	            <td align="center" valign="middle"><a href="Courses.jsp" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image7','','images/index_19_a.gif',1)"><img src="images/index_19.gif" alt="Courses" name="Image7" width="100" height="37" border="0" id="Image7" /></a></td>
	            <td align="center" valign="middle"><a href="javascript:void(0);" style="cursor:default;"><img src="images/index_20.gif" alt="Results" name="Image8" width="100" height="37" border="0" id="Image8" /></a></td>
	            <td align="center" valign="middle"><a href="Reports.jsp" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image9','','images/index_21_a.gif',1)"><img src="images/index_21.gif" alt="Reports" name="Image9" width="100" height="37" border="0" id="Image9" /></a></td>
	            <td align="center" valign="middle"><a href="AdminProfile.jsp" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image10','','images/index_22_a.gif',1)"><img src="images/index_22.gif" alt="Profile" name="Image10" width="100" height="37" border="0" id="Image10" /></a></td>
	            
	          </tr>
	        </table>
        </div>
        <!-- Menu Bar ends -->
    	</div>
 <!-- ---------------------------------------------------------------------------------------------------------------- -->     
     		<div id="workArea" ><!-- Workarea div begins -->
		
		<br/>
	<%
				/** Making connection*/
			String strDBDriverClass=session.getAttribute("DBDriverClass").toString();
			String strDBConnectionURL=session.getAttribute("DBConnectionURL").toString();
			String strDBDataBaseName=session.getAttribute("DBDataBaseName").toString();
			String strDBUserName=session.getAttribute("DBUserName").toString();
			String strDBUserPass=session.getAttribute("DBUserPass").toString();
			if(session.getAttribute("snmodulenamelist")!=null){
				Map<Integer,String> modulenamelist=(Map<Integer,String>)session.getAttribute("snmodulenamelist");
			}
			dbConnector=new DBConnector();
			connection=dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName, strDBUserName, strDBUserPass);
			statement=connection.prepareStatement("select distinct result_Course_Id,course_Name,course_Short_Name from ePariksha_Results,ePariksha_Modules,ePariksha_Courses where ePariksha_Results.result_Course_Id=ePariksha_Courses.course_Id and ePariksha_Modules.module_Course_Id=ePariksha_Courses.course_Id",ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
			result=statement.executeQuery();
		 %>
	
	<div id="divTableHolder" style="height: 110px; width: 798px;">
	
	<div style="padding-top:5px;padding-left:5px; width: 220px;padding-bottom:15px;" id="header_Links">
		<img style="width:22px;height:22px;" src="images/Results.png">
		<label class="pageheader" >Results</label>
	</div>
	
		<form name="frmResultMenu" action="ResultAdmin" method="post">
								
						<table class="tblstyle"  align="left"  style="width: 660px;height:60px; margin-left: 50px;margin-top: 0px;">
							<tr>								
								<td class="tdblue" style="width: 44px; ">
									<label class="lblstyle" style="padding-right: 5px;">Courses</label>
								 <td class="tdlightblue">
									 <select id="selectCourse" name="selectCourse" onchange="getModules(this.value);" style="width: 160px;text-align: left;">
										<option value="selectcourse" selected="selected">--Select Course--</option>
								<jsp:scriptlet>
										//This While Loop will fetch the data in the Select Module Select Control on the page
											while(result.next())
											{
													selectedCourseId=result.getString("result_Course_Id");
													strShortCourseName=result.getString("course_Short_Name");
													strCourseName=result.getString("course_Name");
																										
											</jsp:scriptlet>
											<option value="<%=selectedCourseId.trim()%>" title="<%=strCourseName%>"><jsp:expression>strShortCourseName</jsp:expression></option>
											<jsp:scriptlet>}</jsp:scriptlet> 
										
								</select></td>
								<td class="tdlightblue" colspan="2">
								</td>
								
										
							</tr>
							<tr>
								<td style="margin-left: 10px;" class="tdblue"> <label class="lblstyle" style="padding-right: 5px;">Modules</label></td> 
								<td class="tdlightblue"><select id="selectModule" name="selectModule" onchange="getExamDates(this.value,999);" style="width: 160px;text-align: left;">
										<option value="0" selected="selected">--Select Module--</option>
										<%!Map<Integer,String> mapmodulelist=null;
											ArrayList<String> arrdate=null;
										 %>
								<%
								
								if(request.getAttribute("reqmapmodulelist")!=null){
									
									mapmodulelist=(HashMap<Integer,String>)request.getAttribute("reqmapmodulelist");
									session.setAttribute("sessmapmodulelist",mapmodulelist);
								}
								if(session.getAttribute("sessmapmodulelist")!=null){
									mapmodulelist= (HashMap<Integer,String>) session.getAttribute("sessmapmodulelist");
									
								}
								
								request.setAttribute("reqmaplistofmodule", mapmodulelist);
								 %>					
								<c:forEach var="selmodulefill" items="${reqmaplistofmodule}">
									<option id="${selmodulefill.key}" value="${selmodulefill.key}">${selmodulefill.value}</option>						
								</c:forEach>
								
								
								</select></td>
								
								<td style="margin-right: 10px; width: 166px" class="tdblue">
									<label class="lblstyle" style="padding-right: 5px;text-align: right;">Exam Dates (dd-mm-yyyy)</label></td>
									<td class="tdlightblue"><select name="selectExamDate" id="selectExamDate" style="width: 160px;text-align: left;" onchange="fetchResult();">
										<option value="0" id="0">--Select Exam Date--</option>
										<%
											if(request.getAttribute("reqarrlstexamdatelist")!=null){
												
												arrdate=(ArrayList<String>)request.getAttribute("reqarrlstexamdatelist");
												session.setAttribute("sessarrlist",arrdate);
											}
											if(session.getAttribute("sessarrlist")!=null){
												arrdate= (ArrayList<String>) session.getAttribute("sessarrlist");
												
											}
											
											request.setAttribute("reqarrlistofdate", arrdate);
											
										 %>
								<c:forEach var="selexamdatesfill" items="${reqarrlistofdate}">
									<option id="${selexamdatesfill}">${selexamdatesfill}</option>						
								</c:forEach>										
									</select>
								</td>
								
							</tr>
						
					</table>
					
					<input type="hidden" name="txtModuleName"  id="txtModuleName" value=""><!-- This Hidden Field is used  the fetch the selected module name -->
					<input type="hidden" name="txtCourseId"  id="txtCourseId" value="">
					<input type="hidden" name="txtModuleId"  id="txtModuleID" value="">
					<input type="hidden" name="txtExamDateId"  id="txtExamDateId" value="">
								
						
					
					<input type="hidden" name="selectedValue" id="selectedValue" value="<%=request.getAttribute("reqSelectedCourse")%>"/>
					
					
				</form>
		
	</div>
	<div style="padding-top: 20px;" id="divSeparator">
		<img width="100%;" height="1px" src="images/separator.gif">
	</div>
	
	
	
	<% 
		
				final int iPageSize=35;	//The variable which allows minimum of 35 records on the page at a time
				int iResultCount=0;
				int iStart=0;
				int iEnd=0;
				int iPageId=0;
				
				strUserId			=	session.getAttribute("UserId").toString();
				strUserName			=	session.getAttribute("UserName").toString();
				
				if (session.getAttribute("CourseId") != null) {
					strCourseId	=	session.getAttribute("CourseId").toString();
				}
								
				String strCentreCName	=	null;	
				String strSelectedDate	=	null;
				String paramCourseId	=	null;
				String ccoordinator	=	null;
				if(session.getAttribute("paramCourseId")!=null)
					paramCourseId=session.getAttribute("paramCourseId").toString();
					
				if(request.getParameter("selectExamDate")!=null)
					strSelectedDate	=	request.getParameter("selectExamDate");
				else if(session.getAttribute("ExamDate")!=null)
					strSelectedDate	= session.getAttribute("ExamDate").toString();
					else
					{
						if(session.getAttribute("snExamDateSelected")!=null)
						strSelectedDate=session.getAttribute("snExamDateSelected").toString();
					}
				
				if(strSelectedDate!=null){
				
					if(request.getParameter("selectModule")!=null)
						strModuleId	=	request.getParameter("selectModule");
					else if(session.getAttribute("ModuleId")!=null)
						strModuleId	=	session.getAttribute("ModuleId").toString();
					if(request.getParameter("selectExamDate")!=null)
						strExamDate		=request.getParameter("selectExamDate");					
					else if(session.getAttribute("ExamDate")!=null)
						strExamDate=session.getAttribute("ExamDate").toString();					 				
					
						
					if(request.getParameter("selectModule")!=null)
						strModuleName	=request.getParameter("selectModule");
					else if(session.getAttribute("ModuleName")!=null)
						strModuleName=session.getAttribute("ModuleName").toString();
						session.setAttribute("ModuleId",strModuleId);
						session.setAttribute("ExamDate",strExamDate);
						session.setAttribute("ModuleName",strModuleName);
															
						if(request.getParameter("txtPageStart")!=null)
							iStart=Integer.parseInt(request.getParameter("txtPageStart"));
						else{
								if(request.getAttribute("ipageStartValue")!=null)
								iStart=(Integer)request.getAttribute("ipageStartValue");
								else
								iStart=0;
							}
						if(request.getParameter("txtPageEnd")!=null)
							iEnd=Integer.parseInt(request.getParameter("txtPageEnd"));
						else{
								if(request.getAttribute("ipageEndValue")!=null)
								iEnd=(Integer)request.getAttribute("ipageEndValue");
								else
								iEnd=iPageSize;
								
							}
						if(request.getParameter("txtPageId")!=null)
							iPageId=Integer.parseInt(request.getParameter("txtPageId"));
						else
						{
							if(request.getAttribute("ipageId")!=null)
							iPageId=(Integer)request.getAttribute("ipageId");
							else
							iPageId=1;
						}
				
					}
					
	
	%>
	
	
	
	
	<div id="divInitialMessage" style="height: 300px;padding-top: 200px;padding-left: 300px;" class="message_directions">
	</div>
	

			
	
	<%
		if(request.getParameter("txtPageStart")!=null)
		iStart=Integer.parseInt(request.getParameter("txtPageStart"));
		
		if(request.getParameter("txtPageEnd")!=null)
		iEnd=Integer.parseInt(request.getParameter("txtPageEnd"));
		
		if(request.getParameter("txtPageId")!=null)
		iPageId=Integer.parseInt(request.getParameter("txtPageId"));
		
		int passingMarks=0;
		if(strExamDate!=null){
			
	%>
	<script type="text/javascript">document.getElementById('divInitialMessage').style.display='none';</script>
	<%	/*To fetch short details of the course begins*/
						statement	=	connection.prepareStatement("select course_Short_Name ,user_F_Name,user_M_Name,user_L_Name"+
										 " from ePariksha_Courses,ePariksha_User_Master where "+
										 "ePariksha_Courses.course_Centre_Coordinator=ePariksha_User_Master.user_Id"+
										 " and course_Id=?",ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
						
						statement.setInt(1, Integer.parseInt(paramCourseId));
						result	=	statement.executeQuery();
					if(result.next())
					{
						
						strCourseName	=	result.getString("course_Short_Name");
						strCentreCName	=	result.getString("user_F_Name");
						if(result.getString("user_M_Name")!=null)
							strCentreCName=strCentreCName+" "+result.getString("user_M_Name");
						if(result.getString("user_L_Name")!=null)
							strCentreCName	=	strCentreCName+" "+result.getString("user_L_Name");
					}
					session.setAttribute("snCourseName",strCourseName);
					
					if(result!=null)
						result.close();/**closing the result*/ 
						
					if(statement!=null)
						statement.close();/**closing the statement*/
						
						
					statement = connection.prepareStatement("select exam_Min_Passing_Marks from ePariksha_Exam_Schedule where exam_Course_Id=? and exam_Module_Id=? and to_char(exam_Date, 'DD-MM-YYYY')=TRIM(?)",ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
					statement.setInt(1, Integer.parseInt(paramCourseId));
					statement.setLong(2, Long.parseLong(strModuleId));
					statement.setString(3, strExamDate);
					result=statement.executeQuery();
					if(result.next()){
						passingMarks=result.getInt("exam_Min_Passing_Marks");
					}
					
					if(result!=null)
						result.close();/**closing the result*/ 
						
					if(statement!=null)
						statement.close();/**closing the statement*/
						
						
						
					
					/*To fetch short details of the course ends*/
					
					/*To fetch result  begins*/
	
					statement=connection.prepareStatement("select distinct result_Stud_PRN,result_Marks,result_Percentage,stud_F_Name,stud_M_Name,stud_L_Name from ePariksha_Results,ePariksha_Student_Login where result_Course_Id=? and result_Module_Id=? and ePariksha_Student_Login.stud_Course_Id=ePariksha_Results.result_Course_Id	and ePariksha_Student_Login.stud_PRN=ePariksha_Results.result_Stud_PRN	and to_char(result_Exam_Date, 'DD-MM-YYYY') like to_char(?::date, 'DD-MM-YYYY') order by result_Stud_PRN",ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
					statement.setInt(1, Integer.parseInt(paramCourseId));
					statement.setLong(2, Long.parseLong(strModuleId));
					statement.setString(3, strExamDate);
								
					result	=	statement.executeQuery();	
					result.last();
					iResultCount=result.getRow();
					
				
				/*To fetch result  ends*/
		%>
	
			<div id="divResultDisplay" style="clear: both;">
		<%if(iResultCount!=0){// to check for new message%>
			
					<div align="center" id="header_msg" style="padding-top: 10px;">
					<b><font  size="5"><%=strCourseName%> Results</font></b>
					<%String strModuleInWords	=	null;
						if(request.getParameter("txtModuleName")!=null){
						strModuleInWords=request.getParameter("txtModuleName").toString();
						session.setAttribute("strModuleInWords",strModuleInWords);
						}
						else if(session.getAttribute("strModuleInWords")!=null)
							strModuleInWords=session.getAttribute("strModuleInWords").toString();								
						 %>			 
						 <br/>
						 
						 <div style="width:300px;margin-top: 10px;;"><label class="lblstyle" style="font-size: 15px;margin-top:20px">Subject:	</label>
							 <label class="lblstyle" style="padding-left: 2px;"><%=strModuleInWords%></label><br/></div>
						 <div style=" margin-top: 10px;margin-bottom: 10px;"><b><label class="lblstyle" style="font-size: 15px;">Exam Date:	</label></b>
						 	<label class="lblstyle" style="padding-left: 2px;"><%=strExamDate%></label></div>	
					</div>
						
						
								<script type="text/javascript">
									
									document.getElementById("divResultDisplay").style.display='block';
								</script>
							
								<table  height="90px" width="660px" >
									<tr id="print_Banner" align="center" style="display: none;">
										
										<td>
											<div>
												<div align="center"><font style="font-size: 27px;"><b><%=strCourseName%> Results</b></font></div>
												<div style="padding-top: 10px"><b>Subject: <%=strModuleInWords%></b></div>
												<div style="padding-top: 10px"><b>Exam Date:	<%=strExamDate%></b></div>
											</div>
										</td>
										
									</tr>
									<tr id="cancelRow" style="display: none;">
										<td colspan="3">
										
										</td>
									
									</tr>
									<tr>
							<td colspan="3" valign="top">
								<table align="center"  cellspacing="0" id="tblResult"  class="tblstyle" style="width: 660px;margin-left: 50px;" >
									<tr id="tblheader" >
										<th style="border-left: 2px;border-left-color: black;height: 3px;" class="simple_row">S.No.</th>
										<th class="simple_row" style="height: 20px;" >PRN No.</th>
										<th class="simple_row" style="height: 20px;">User Name</th>
										<th class="simple_row" style="height: 20px;">Marks</th>
										<th class="simple_row" style="height: 20px;">Percentage</th>
										<th class="simple_row" style="height: 20px;">Result</th>
										<th class="simple_row" style="height: 20px;">Details</th>
										
									</tr>
								<%
									int sNo=iStart;
									
									String strResultRemark="";
									result.first();
									for(int iTempItr=0;iTempItr<iEnd;iTempItr++)				
									{
										
										if(iTempItr>=iStart)
										{
											sNo++;
											String 	strStudentPRN	=	null;
											String 	strStudentName	=	null;
											int		iStudentMarks	=	0;
											float  	fStudentPercentage	=	0;
											strStudentPRN	=	result.getString("result_Stud_PRN");
											iStudentMarks	=	result.getInt("result_Marks");
											fStudentPercentage=	result.getFloat("result_Percentage");
											
											strStudentName=result.getString("stud_F_Name");
											if(result.getString("stud_M_Name")!=null)
												strStudentName	=	strStudentName+" "+result.getString("stud_M_Name");
											if(result.getString("stud_L_Name")!=null)
												strStudentName	=	strStudentName+" "+result.getString("stud_L_Name");
											
											if(iStudentMarks>=passingMarks)
												strResultRemark	=	"Pass";
											else
												strResultRemark	=	"Fail";
												
												
											
										%>
										<tr class="<%if((sNo%2)==0){%>even<%}else{ %>odd<%} %>">
											<td style="width: 10px;height: 20px;text-align: center; "><%=sNo%></td>
											<td style="width: 30px;height: 20px;text-align: center; "><%=strStudentPRN%></td>
											<td align="left" style="width: 200px;height: 20px;padding-left: 10px; "><%=strStudentName%></td>
											<td style="width: 10px;height: 20px;text-align: center; " align="center"><%=iStudentMarks%></td>
											<td style="width: 2px;height: 20px;text-align: center; " align="center"><%=fStudentPercentage%></td>
											<td style="width: 10px;height: 20px;text-align: center; " align="center"><%=strResultRemark%></td>
											<td style="width: 10px;height: 20px;text-align: center; " align="center">
												<a id="<%=strStudentPRN%>" href="javascript:void(0)" onclick="javascript:submitFrmResultDetail(this.id)"><img src="images/Details.png"></a>
											</td>
										</tr>
									<%}
											if(iTempItr==iResultCount-1)
												break;
											result.next();
										}
										int iPassStudents=0;
										if(iResultCount==sNo)
										{
											String CourseID=null;
											if(session.getAttribute("paramCourseId")!=null)
												CourseID=session.getAttribute("paramCourseId").toString();
											
											if(statement!=null)
												statement.close();/**closing the statement*/ 
							/**************************Code Position****************************************/					
												
														
														
											
												statement	=	connection.prepareStatement("select count(distinct result_Stud_PRN) as totalcount from ePariksha_Results where to_char(result_Exam_Date, 'DD-MM-YYYY')=TRIM(?) and result_Module_Id=? and result_Course_Id=? and result_Marks>=?");
												
												statement.setString(1, strExamDate);
												statement.setLong(2, Long.parseLong(strModuleId));
												statement.setInt(3, Integer.parseInt(CourseID));
												statement.setFloat(4, passingMarks);
												result	=	statement.executeQuery();
												if(result.next())
												{
													
													iPassStudents=result.getInt(1);
													
													
												}
												if(result!=null)
													result.close();/**closing the result*/ 
													
												if(statement!=null)
													statement.close();/**closing the statement*/ 
													
													statement = connection.prepareStatement("select exam_Min_Passing_Marks from ePariksha_Exam_Schedule where exam_Course_Id=? and exam_Module_Id=? and to_char(exam_Date, 'DD-MM-YYYY')=TRIM(?)",ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
													statement.setInt(1, Integer.parseInt(paramCourseId));
													statement.setLong(2, Long.parseLong(strModuleId));
													statement.setString(3, strExamDate);
													result=statement.executeQuery();
													if(result.next()){
														passingMarks=result.getInt("exam_Min_Passing_Marks");
													}
													
													if(result!=null)
														result.close();/**closing the result*/ 
														
													if(statement!=null)
														statement.close();/**closing the statement*/								
																							
												
								%>
										
									<tr>
										<td colspan="6" align="left">
											<table align="center">
												<tr class="simple_row"><td><label class="lblstyle">Total Student</label></td><td>:&nbsp;&nbsp;<%=sNo%></td></tr><!-- Data Which Displays how many Students appeared for the exam -->
												<tr class="simple_row"><td><label class="lblstyle">Pass Student</label></td><td>:&nbsp;&nbsp;<%=iPassStudents%></td></tr><!-- Data which shows the number of passed Students -->
												<tr class="simple_row"><td><label class="lblstyle">Fail Student</label></td><td>:&nbsp;&nbsp;<font style="color: red;font-size: 11px"><%=(sNo-iPassStudents)%></font></td></tr><!-- Number of failed Students -->
												<tr class="simple_row">
													<td>
														<label class="lblstyle">Min.Passing Marks</label>
													</td>
													<td>:&nbsp;&nbsp;<%=passingMarks %></td>
												</tr>
											</table>
										</td>
									</tr>
								<%}
								/**
								 * Closing the database connection on dbConnector.
								 **/
								if(dbConnector!=null)
								{
									dbConnector.closeConnection(connection);
									dbConnector=null;
									connection=null;
								}
								%>			
								</table>
						
						
						<tr>
							<td colspan="3" style="padding-left: 90px;">
							
								
								<div style="float: right;margin-top: 80px;font: 10pt Arial;margin-right: 0px;"><%= strCentreCName%><br> Administrator </div>
							</td>
						</tr>
						<tr>
							<td colspan="3">
							<form target="_blank" id="frmResultDetail" name="frmResultDetail" method="post" action="PerformanceReport.jsp">
								<input type="hidden" id="txtSelectedRollNo" name="txtSelectedRollNo">
								<input type="hidden" id="txtSelectedModuleId" name="txtSelectedModuleId" value="<%=strModuleId%>">
								<input type="hidden" id="txtSelectedExamDate" name="txtSelectedExamDate" value="<%=strExamDate%>">
							</form>
							<form name="frmResult" method="post" action="">
									<input type="hidden" value="" name="txtPageStart">
									<input type="hidden" value="" name="txtPageEnd">
									<input type="hidden" value="" name="txtPageId">
									<input type="hidden" value="<%=iPageSize%>" name="txtPageSize" id="txtPageSize">
									<input type="hidden" value="<%=iPageId-1%>" name="txtPageNo" id="txtPageNo">
								</form>
							</td>
						</tr>
						<%
							if(iResultCount>iPageSize)
							{
								int iPageLink=0,iPageCount=0,iRemender=0;
								iPageCount	=	iResultCount/iPageSize;
								iRemender	=	iResultCount%iPageSize;
								if(iRemender!=0)
									iPageCount	=	iPageCount+1;
								String strPageLink	=	null;
							%>
								<tr id="paggingRow" >
									<td colspan="3" align="center" width="600%"> 
										<%
										for(iPageLink=1;iPageLink<=iPageCount;iPageLink++)
										{
											if(iPageLink==1 && iPageId!=iPageLink)
												strPageLink="<< ";
											else if(iPageLink==iPageCount && iPageId!=iPageCount)
												strPageLink=" >>";
											else 
												strPageLink=""+iPageLink;
											
											if((iPageLink==iPageId))
											{%>
												<b><%=strPageLink%></b>
											<%
											}
											else
											{
											%>
												<a class="page_link" onclick="getNextPage(<%=iPageLink-1%>);" ><%=strPageLink%></a>
											<%
											}
											%>
										<%	
										}
									%>
									</td>
								</tr>
							<%}%>		
					</table>
				
					
					<center>	
						<div id="divPrintBack" style="display: none;">
							<a href="javascript:window.print();" style="height:10px;font: 10pt Arial"><img src="images/control_printer.png" style="border-style: none; height: 15px; width: 19px;">Print</a>
							<a href="javascript:void(0);" style="height:10px;font: 10pt Arial" onclick="closePrintPreview(document.frmResult.txtPageNo.value);" >Back</a>
						</div>
						<div id="printRow">
							<div id="divprintpreviewcontainer" style="margin-left: 200px;margin-right: 200px;">
								<img src="images/printPreview.png" style="height: 17px; width: 18px; "></img>
								<a href="javascript:void(0);" onclick="printPage();" style="font: Arial;vertical-align: top;height: 18px; width: 98px;">Print Preview</a>
							</div>
						
						</div>
					</center>
					<div id="divForClear" style="clear: both;"></div>
					<div id="footerNew" style="clear: both;padding-bottom: 10px;display: none;">
						Powered by C-DAC , ACTS , PUNE
					</div>
					
			<%}else{//If resultcount is not zero ends ie no results present%>
		
			<div id="divServerMessages" style="height: 300px;padding-top: 200px;padding-left:300px" class="message_directions">
				No records found
			
			</div>
		<%} %>	
		
	</div><!-- div resultdisplay ends -->
	
	<script>
			var CourseObject=document.getElementById('selectCourse');
			var ModuleObject=document.getElementById('selectModule');
			var ExamDateObject=document.getElementById('selectExamDate');
			
			<%	
				String courseid=null;
				if(request.getParameter("selectCourse")!=null){
					courseid=request.getParameter("selectCourse");
				request.setAttribute("rqselcourse",courseid);
				}
				
			%>
			
			
			for ( var i = 0; i < CourseObject.length; i++) {
				
				if(CourseObject.options[i].value==<%=session.getAttribute("paramCourseId")%>){
					CourseObject.selectedIndex=i;
				}
			}
			
			for ( var j = 0; j < ModuleObject.length; j++) {
				if(ModuleObject.options[j].id==<%=session.getAttribute("adddattesajaxsnmoduleid")%>){
					ModuleObject.selectedIndex=j;
				}
			}
			var arraytostoreDate=new Array();
			
			
			var selectedExamDateinString=new String("<%=strExamDate%>");
					
			for ( var k = 0; k < ExamDateObject.length; k++) {
					
					if(ExamDateObject.options[k].id==selectedExamDateinString){
					ExamDateObject.selectedIndex=k;
				}
			}
			
			
		</script>
	
	<%
	}else{//end if of checking date %>
	
	<%} %>	
		
	 <%
	 //Scriplet Which is managing the divInitialMessage 
	 //Which tells what message to be displayed on respective events
	 	String strModuleIdServlet=null;
	 	String strValidExamDate=null;
	 	
	 	if(session.getAttribute("snModuleIdServlet")!=null)
	 		strModuleIdServlet=session.getAttribute("snModuleIdServlet").toString();
	 	
	 	if(session.getAttribute("ExamDate")!=null)
	 		strValidExamDate=session.getAttribute("ExamDate").toString();
	 	else
	 		if(request.getParameter("selectExamDate")!=null)
	 			strValidExamDate=request.getParameter("selectExamDate").toString();
	 			
	 		//session.removeAttribute("ExamDate");
	 		
			/*below condition check if the examdate is null */
			
			
			if(strValidExamDate==null)
			{
	 %>
			 <script type="text/javascript">
			 	document.getElementById('divInitialMessage').innerHTML='Please select course ';
			 	//document.getElementById('divResultDisplay').style.display='block';
			 </script>
	 <%}
			 else if(strModuleIdServlet!=null && strValidExamDate!=null) {
			  %>
			  <script type="text/javascript">
			  	 	
			  		document.getElementById('divInitialMessage').style.display='none';
			  		
			  </script>
			  <%} %>
	
		</div><!-- workarea div ends -->
<!-- ---------------------------------------------------------------------------------------------------------------- -->
	
 		<div> <!-- Div Footer begins -->
	  	<table>
	  		<tr>
			    <td align="left" valign="top">
				    <table width="800" border="0" align="center" cellpadding="0" cellspacing="0">
				      <tr>
				        <td width="13" align="left" valign="top"><img src="images/index_87.gif" width="13" height="42" alt="" /></td>
				        <td align="left" valign="top" style="background-image:url(images/index_88.gif); background-repeat:repeat-x;">
				        <table width="100%" border="0" cellspacing="0" cellpadding="0">
				          <tr>
				            <td style="padding-top:15px;" align="center"  class="copyright">Copyright &copy; 2009-2014 <span style="color:#A70505;">CDAC ACTS </span>All rights reserved</td>
				          </tr>
				        </table></td>
				        <td width="15" align="right" valign="top"><img src="images/index_91.gif" width="15" height="42" alt="" /></td>
				      </tr>
				    </table>
			    </td>
		    </tr>
	    </table>
	   </div> <!-- Div Footer ends -->
	   </div> <!-- div main body ends -->
	   
	   <script type="text/javascript">
	   document.getElementById('txtModuleName').value=document.getElementById('selectModule').options[document.getElementById('selectModule').selectedIndex].text;
	  	   	
	   </script>
	
	</body>
<%}}%>
</html>