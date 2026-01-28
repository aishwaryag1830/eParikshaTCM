<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" session="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.CallableStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Types"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="in.cdac.acts.connection.DBConnector"%>
<%@page import="in.cdac.acts.ExamModuleStatusTeller"%>
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
{
	if(session.getAttribute("UserId")==null || session.getAttribute("UserName")==null)
	{
		%>
		<jsp:forward page="index.jsp"></jsp:forward>
	<%
	}
	else
	{

	%>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<link rel="stylesheet" href="Css/style.css" type="text/css">
		<script type="text/javascript" src="Js/AdminMenu/MenuBar.js"></script>
		<script type="text/javascript" src="Js/Reports.js"></script>
		
		<script type="text/javascript">javascript:window.history.forward(1);</script>
		<title>Reports [ePariksha] </title>
		<!-- 
			View Detailed Results of selected candidate.
			Author:Prashant Bansod
			Date: 17-01-12
		 -->
	</head>
	
	<body onload="MM_swapImage('Image9','','images/index_21_a.gif',1);">
	<%
			/** for Connection */
			DBConnector dbConnector=null;			//Creating object of DBConnector class to make database connection.
			Connection connection=null;
			CallableStatement cstmt	=	null;
			ResultSet result=null;
			String sSelStudentRollNo=	null;
			String sSelExamDate		=	null;
			String sSelModuleId		=	null;
			String sStudentName		=	null;
			String sStudentRollNo	=	null;
			String courseName		=	null;
			String moduleName		=	null;
			String examDate			=	null;
			int iNoOfQuestionsExam	=	0;
			int iExamDuration		=	0;
			int iMinPassingMarks	=	0;
			String sResultDetails	=	null;				
			int iAttemptedTotalQues	=	0;
			int iMarks				=	0;
			int iPassingMarks		=	0;
			long lTimeTaken			=	0;
			String sQuesText	=	null;
			String sChoice1		=	null;
			String sChoice2		=	null;
			String sChoice3		=	null;
			String sChoice4		=	null;
			String sAttemptedAns		=	null;
			String sCorrectAnswer		=	null;//Correct ans at the time of attempt; Afterwards the ques may get edited.
			String	sFormattedTimeTaken	=	null;
			
			try
			{
					
				String strUserId	=	session.getAttribute("UserId").toString();
				String strUserName	=	session.getAttribute("UserName").toString();
				
				String sCourseId	=	null;
				
				if (session.getAttribute("CourseId") != null) {
					sCourseId	=	session.getAttribute("CourseId").toString();
				}
				
				String sRoleId	=	session.getAttribute("UserRoleId").toString();
	
				/**
					If trying to come to this page from other user redirect it to index page
				*/
				
				if(!sRoleId.equals("999"))//If trying to come to this page from other user redirect it to index page
				 {%><jsp:forward page="index.jsp"></jsp:forward><%}%>
				
			   <%  
			    
			    	
			   
				String strDBDriverClass=session.getAttribute("DBDriverClass").toString();			//reading DriverClass 
				String strDBConnectionURL=session.getAttribute("DBConnectionURL").toString();		//reading ConnectionURL
				String strDBDataBaseName=session.getAttribute("DBDataBaseName").toString();			//reading DataBase Name
				String strDBUserName=session.getAttribute("DBUserName").toString();					//reading DataBase UserNaeme
				String strDBUserPass=session.getAttribute("DBUserPass").toString();	
				
				dbConnector = new DBConnector();

				connection=dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName, strDBUserName, strDBUserPass);
	
				/*Fetching required data from ResultAdmin.jsp*/
			
				if(request.getParameter("txtSelectedRollNo")!=null)
					sSelStudentRollNo	=	request.getParameter("txtSelectedRollNo").toString();
					
				if(request.getParameter("txtSelectedExamDate")!=null)
					sSelExamDate	=	request.getParameter("txtSelectedExamDate").toString();
					
				if(request.getParameter("txtSelectedModuleId")!=null)
					sSelModuleId	=	request.getParameter("txtSelectedModuleId").toString();
	
				
				
				

				/**
				* Fetching Student and other exam details 
				**/
				cstmt	=	connection.prepareCall( "call PaperAttemptedDetails(?,?,?,?,?,?,?,?,?,?,?,?,?,?)" );
				
				cstmt.setString(1, sSelStudentRollNo);
				cstmt.setString(2, sSelExamDate);
				cstmt.setLong(3, Long.parseLong(sSelModuleId));
				cstmt.setString(4, sStudentName);
				cstmt.setString(5, sStudentRollNo);
				cstmt.setString(6, courseName);
				cstmt.setString(7, moduleName);
				cstmt.setInt(8, iNoOfQuestionsExam);
				cstmt.setInt(9, iExamDuration);
				cstmt.setInt(10, iPassingMarks);
				cstmt.setString(11, sResultDetails);
				cstmt.setInt(12, iAttemptedTotalQues);
				cstmt.setInt(13, iMarks);
				cstmt.setLong(14, lTimeTaken);

				cstmt.registerOutParameter(4, Types.VARCHAR);
				cstmt.registerOutParameter(5, Types.VARCHAR);
				cstmt.registerOutParameter(6, Types.VARCHAR);
				cstmt.registerOutParameter(7, Types.VARCHAR);
				cstmt.registerOutParameter(8, Types.INTEGER);
				cstmt.registerOutParameter(9, Types.INTEGER);
				cstmt.registerOutParameter(10, Types.INTEGER);
				cstmt.registerOutParameter(11, Types.VARCHAR);
				cstmt.registerOutParameter(12, Types.INTEGER);
				cstmt.registerOutParameter(13, Types.INTEGER);
				cstmt.registerOutParameter(14, Types.BIGINT);
				
				cstmt.execute();
				
				sStudentName		=	cstmt.getString(4);
				sStudentRollNo		=	cstmt.getString(5);
				courseName			=	cstmt.getString(6);
				moduleName			=	cstmt.getString(7);
				iNoOfQuestionsExam	=	cstmt.getInt(8);
				iExamDuration		=	cstmt.getInt(9);
				iPassingMarks		=	cstmt.getInt(10);
				sResultDetails		=	cstmt.getString(11);				
				iAttemptedTotalQues =	cstmt.getInt(12);
				iMarks				=	cstmt.getInt(13);
				lTimeTaken			=	cstmt.getLong(14);
				
				ExamModuleStatusTeller	em = new ExamModuleStatusTeller();
				sFormattedTimeTaken	=	em.getTimeInHHMMSECFormat(lTimeTaken);
				 
				 
				if(cstmt!=null)
					cstmt.close();/**closing the statement*/ 
				
					
					
				
				
			}
			catch(Exception e){e.printStackTrace();}
				
			
			
	%>
	<div id="mainBody"  align="center" >
    <div id="topArea"><!-- div Top container -->
      <table width="300px" cellspacing="0" cellpadding="0"><!-- div left banner -->
          <tr>
	            <td width="50%" align="right" valign="top" style="padding-top:10px; padding-left:5px; padding-bottom:0px;">
		            <a href="http://acts.cdac.in"><img src="images/cdac-acts_inner.png" alt="" width="120" height="35" border="0" /></a>	            </td>
	      		<td width="50%" align="left" valign="top" style="padding-top:15px;">
		            <ul>
		            	<li><img alt="ePariksha" title="ePariksha" src="images/eParikshaLogo.gif" style="width:120px;height:40px;"></li>
					</ul>
	            </td>
	      </tr>
       </table><!-- div left banner -->
    </div><!-- div Top container -->
    
   	
       
    
        
        <!-- Menu Bar Begins -->
        
        <!-- Menu Bar ends -->
        
      
      <div id="workArea"><!-- work area begins -->
	      	
			<div style="padding-top:5px;padding-left:5px; width: 600px">
						<img style="width:22px;height:22px;" src="images/reports.png">
						<label style="font:19px Courier;font-weight:bold;color:#AE0E10"><%=sStudentName%> </label><label class="pageheader">Performance Report</label>
			</div>
			
			<div id="divStudentExamDetails" style="width:810px;margin-top:20px;">
				
				<div id="divStudentDetails" style="width:48%;float:left;">
					<div style="width: 200px">
								<label class="sideheader">Student Result</label>
					</div>
					<table class="tblstyle" style="width:389px;height:300px;">
						<tr><td class="tdStudentDetailsHeader"><label class="lblstyle">Name</label></td><td class="tdStudentDetailsData"><%=sStudentName%></td></tr>
						<tr><td class="tdStudentDetailsHeader"><label class="lblstyle">Roll No.</label></td><td class="tdStudentDetailsData"><%=sStudentRollNo%></td></tr>
						<tr><td class="tdStudentDetailsHeader"><label class="lblstyle">Questions Attempted</label></td><td class="tdStudentDetailsData"><%=iAttemptedTotalQues%></td></tr>
						<tr><td class="tdStudentDetailsHeader"><label class="lblstyle">Questions Correct</label></td><td class="tdStudentDetailsData"><%=iMarks%></td></tr>
						<tr><td class="tdStudentDetailsHeader"><label class="lblstyle">Questions Incorrect</label></td><td class="tdStudentDetailsData"><%=iAttemptedTotalQues-iMarks%></td></tr>
						<tr><td class="tdStudentDetailsHeader"><label class="lblstyle">Time Taken</label></td><td class="tdStudentDetailsData"><%=sFormattedTimeTaken%></td></tr>
						<tr><td class="tdStudentDetailsHeader"><label class="lblstyle">Marks</label></td><td class="tdStudentDetailsData"><%=iMarks%></td></tr>
						<tr><td class="tdStudentDetailsHeader"><label class="lblstyle">Percentage</label></td><td class="tdStudentDetailsData"><%=new DecimalFormat("##.00").format( (((double)iMarks/iNoOfQuestionsExam)*100) )%></td></tr>
						<tr><td class="tdStudentDetailsHeader"><label class="lblstyle">Result</label></td><td class="tdStudentDetailsData"><%if(iMarks>=iPassingMarks){%>Pass<%}else{%>Fail<%}%></td></tr>						
					</table>
				</div>
				
				
				<div id="divExamDetails" style="width:48%;float:right;">
					<div style="width: 200px;">
								<label class="sideheader">Exam Details</label>
					</div>
					<table class="tblstyle" style="width:389px;height:300px;">
						<tr><td class="tdExamDetailsHeader"><label class="lblstyle">Course</label></td><td class="tdExamDetailsData"><%=courseName%></td></tr>
						<tr><td class="tdExamDetailsHeader"><label class="lblstyle">Subject</label></td><td class="tdExamDetailsData"><%=moduleName%></td></tr>
						<tr><td class="tdExamDetailsHeader"><label class="lblstyle">Exam Date</label></td><td class="tdExamDetailsData"><%=sSelExamDate%></td></tr>
						<tr><td class="tdExamDetailsHeader"><label class="lblstyle">Questions</label></td><td class="tdExamDetailsData"><%=iNoOfQuestionsExam%></td></tr>
						<tr><td class="tdExamDetailsHeader"><label class="lblstyle">Duration</label></td><td class="tdExamDetailsData"><%=iExamDuration%></td></tr>
						<tr><td class="tdExamDetailsHeader"><label class="lblstyle">Min. Marks</label></td><td class="tdExamDetailsData"><%=iPassingMarks%></td></tr>
					</table>
				</div>
				<div style="clear:both"></div>
			</div>
			<%
			try{
			/**
			* Fetching question attempted by student in the exam 
			**/
			cstmt	=	connection.prepareCall( "call getQuestion(?,?,?,?,?,?)" );
			
			cstmt.setLong(1, 0L);
			cstmt.setString(2, sQuesText);
			cstmt.setString(3, sChoice1);
			cstmt.setString(4, sChoice2);
			cstmt.setString(5, sChoice3);
			cstmt.setString(6, sChoice4);
			
			cstmt.registerOutParameter(2, Types.VARCHAR);
			cstmt.registerOutParameter(3, Types.VARCHAR);
			cstmt.registerOutParameter(4, Types.VARCHAR);
			cstmt.registerOutParameter(5, Types.VARCHAR);
			cstmt.registerOutParameter(6, Types.VARCHAR);
			  
			String sResultDetailsString[]=sResultDetails.split(",");
			String sIndividualQues[]=null;
			
			
			  
			
			%>
			<br>
			<div style="padding:5px 5px 10px 5px; width: 500px">
				<label class="sideheader">Questions Attempted</label>
			</div>
			<div id="divQuestionDetailsContainer" style="width:810px;height:500px;overflow-y:auto;"><!--divQuestionContainer begins-->
			  <%
				for(int iActualRowNumber=0;iActualRowNumber<sResultDetailsString.length;iActualRowNumber++)
				  {
					  sIndividualQues=sResultDetailsString[iActualRowNumber].split("-");//Splitting QuesId-AnswerGiven-CorrectAnswer	
					  
					  cstmt.setLong(1, Long.parseLong(sIndividualQues[0]));//variables of procedure,values
					  												//[0]: Question Id
					  cstmt.execute();
			
					  sQuesText	=	cstmt.getString(2);
					  sChoice1	=	cstmt.getString(3);
					  sChoice2	=	cstmt.getString(4);
					  sChoice3	=	cstmt.getString(5);
					  sChoice4	=	cstmt.getString(6);
					  
					  sAttemptedAns		=	sIndividualQues[1];//Ans given
					  sCorrectAnswer	=	sIndividualQues[2];//Actual Correct Ans
					  					
					%>
					<div align="left" id="divEachQuestionHolder<%=iActualRowNumber+1+""%>" style="border:1px dotted #AE0E10;width:750px;margin:2px 2px 20px 5px;padding:5px;"><!-- div table holder starts -->
										<div id="divTableHolder" style="float:left;">
											
											<table  style="padding:0px 2px 0px 0px;width: 585px;height:300px;"  cellspacing=0 cellpadding=0>
									        	<tr>
													<td align="left">
														<label class="lblstyle"><b>Q.No:</b> <%=iActualRowNumber+1+""%></label>
															
												
														<div style="padding-top:3px;" align="justify" id="divQuesText">
													 	<%/*Formating The Question for Display*/
															int iTemp = 0;
															while (sQuesText.length() > iTemp )
															{
																switch (sQuesText.charAt(iTemp))
																{      
																	case '\n':
																	%>
																		<br/>
																	<%
																		break;
																	case ' ':
																		%>
																			&nbsp;
																		<%
																		break;
																	default:
																	  %><%=sQuesText.charAt(iTemp )%><%
																}
																iTemp++;
															}%>
														</div>
												  </td>
												</tr>
												<tr>
													<td align="left">
														<br>
														<b>Choice 1:</b><br>
														<div style="padding-top:3px;" class="divChoice1" align="justify">
															<%/*Formating The Options for Display*/
															iTemp = 0;
															while (sChoice1.length() > iTemp )
															{
															 	switch (sChoice1.charAt(iTemp))
															 	{      
														     		case '\n':
															       		%>
																		<br/>
																	<%
														         		break;
														     		case ' ':
																		%>
																			&nbsp;
																		<%
																		break;
														        	default:
																    %><%=sChoice1.charAt(iTemp )%><%
																}
																iTemp++;
															}%>
														</div>
													</td>
												</tr>
												<tr>
													<td align="left" >
														<br>
														<b>Choice 2:</b><br>
														<div style="padding-top:3px;" class="divChoice2" align="justify">
															<%/*Formating The Options for Display*/
															iTemp = 0;
															while (sChoice2.length() > iTemp )
															{
															 	switch (sChoice2.charAt(iTemp))
															 	{      
														     		case '\n':
															       		%>
																		<br/>
																	<%
														         		break;
														     		case ' ':
																		%>
																			&nbsp;
																		<%
																		break;
														        	default:
																    %><%=sChoice2.charAt(iTemp )%><%
																}
																iTemp++;
															}%>
														</div>
														
													</td>
												</tr>
													
												    
												<tr>
													<td align="left" >
														<br>
														<b>Choice 3:</b><br>
														<div style="padding-top:3px;" class="divChoice3" align="justify">
															<%/*Formating The Options for Display*/
															iTemp = 0;
															while (sChoice3.length() > iTemp )
															{
															 	switch (sChoice3.charAt(iTemp))
															 	{      
														     		case '\n':
															       		%>
																		<br/>
																	<%
														         		break;
														     		case ' ':
																		%>
																			&nbsp;
																		<%
																		break;
														        	default:
																    %><%=sChoice3.charAt(iTemp)%><%
																}
																iTemp++;
															}%>
														</div>
													</td>
													</tr>
													<tr>
														<td align="left">
														<br>
														<b>Choice 4:</b><br>
														<div style="padding-top:3px;" class="divChoice4" align="justify">
															<%/*Formating The Options for Display*/
															iTemp = 0;
															while (sChoice4.length() > iTemp )
															{
															 	switch (sChoice4.charAt(iTemp))
															 	{      
														     		case '\n':
															       		%>
																		<br/>
																	<%
														         		break;
														     		case ' ':
																		%>
																			&nbsp;
																		<%
																		break;
														        	default:
																    %><%=sChoice4.charAt(iTemp)%><%
																}
																iTemp++;
															}%>
														</div>
														</td>
													</tr>
													
											</table>
										</div>
										<div id="divObservation" style="width:150px;height:300px;float:right;border-left:1px dotted #AE0E10">
											<table style="width:100%;height:100%;">
											<tr>
												<td align="center" valign="top"><p align="left"><label class="lblstyle"><b>Correct Answer:</b></label></p><label style="font-weight:bold;font:40pt Arial;color:#6ACC77"><%=sCorrectAnswer%></label></td>
											</tr>
											<tr>
												<td align="center" valign="top"><p align="left"><label class="lblstyle"><b>Attempted Answer:</b></label></p><label style="font-weight:bold;font: 40pt Arial;color:<%if(sCorrectAnswer.equals(sAttemptedAns)){%>#6ACC77<%}else{%>#82CAFF<%}%>  "><%=sAttemptedAns%></label></td>
											</tr>
											<tr>
												<td align="center" valign="top"><p align="left"><label class="lblstyle"><b>Ques. Result:</b></label></p><img alt="Ques. Result"   <%if(sAttemptedAns.equals(sCorrectAnswer)){%>src="images/correct.gif" title="This ans is correct." style="width:80px;height:48px;"<%}else{%>  src="images/wrong.gif" title="This ans is wrong."<%}%> ></td>
											</tr>
											</table>
										</div>
										<div style="clear:both;"></div>
										
					</div><!-- diveachquestion ends -->
					<br>
					
					<% }
			}catch(SQLException e){}
			%>
			</div><!-- divQuestionContainer ends -->
			<%
			 	if(cstmt!=null)
					cstmt.close();/**closing the statement*/ 
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
			<br>
			<div  id="div_instructions"  align="left">
			 	<label class="lblstyle">Note: </label>
				Questions shown here may not be identical to exam, if examiner has modified them. 
			</div> 	
		
	  </div><!-- work area ends -->
	
 		<div style="padding-top:5px;"> <!-- Div Footer begins -->
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
	</div>
	</body>
	<script language="javascript">
		document.title = "<%=sStudentName%> Performance Report [ePariksha]";
	</script>
<%
	}//end else of user id session check
} %>
</html>