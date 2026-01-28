<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" session="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>

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
{%>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<link rel="stylesheet" href="Css/style.css" type="text/css">
		<title>Student Home [ePariksha] </title>
		<script type="text/javascript" src="jquery-1.3.1.min.js"></script>
   		<link rel="stylesheet" type="text/css" href="Js/ContentSlider/contentslider.css" />
		<script type="text/javascript" src="Js/ContentSlider/contentglider.js">
		<script type="text/javascript">javascript:window.history.forward(1);</script>
		<script type="text/javascript">
		function selectModule(moduleId,sExamStatus)
		{
			var frm=document.frmModule;
			
			frm.flag.value=sExamStatus;
			
			frm.txtSelectedModuleId.value=moduleId;
			
			frm.txtSelectedModuleName.value=document.getElementById('txtModuleName'.concat(moduleId)).value;

			frm.txtSubmitSelectedTotalQuestionCount.value=document.getElementById('txtSelectedExamQuestions'.concat(moduleId)).value;

			frm.txtSubmitSelectedModuleExamDuration.value=document.getElementById('txtSelectedExamDuration'.concat(moduleId)).value;
	
			frm.submit();			
			
		}		 
		</script>
		<!-- 
			Student Home where student can select module to give exam
			Author:Prashant Bansod
			Date: 17-01-12
		 -->
	</head>
	
	<body>
	<%
		
		if(session.getAttribute("UserId")==null || session.getAttribute("UserName")==null)
		{
			%>
			<jsp:forward page="index.jsp"></jsp:forward>
		<%
		}
		else
		{
			
			
		
			String strUserId	=null;
			String strUserName	=null;
			String strCourseId	=null;
		
		
		/**
		 * variables for database connections
		 * */
		DBConnector dbConnector=null;			//Creating object of DBConnector class to make database connection.
		Connection connection=null;
		PreparedStatement statement=null;
		ResultSet result=null;
		
		if(session.getAttribute("UserId")==null || session.getAttribute("UserName")==null || session.getAttribute("CourseId")==null)
		{
		%>
			<jsp:forward page="index.jsp?lgn=2"></jsp:forward>
		<%
		}
		else
		{
			strUserId	=session.getAttribute("UserId").toString();
			strUserName	=session.getAttribute("UserName").toString();
			strCourseId	=session.getAttribute("CourseId").toString();
			
			/** Making connection*/
			String strDBDriverClass=session.getAttribute("DBDriverClass").toString();
			String strDBConnectionURL=session.getAttribute("DBConnectionURL").toString();
			String strDBDataBaseName=session.getAttribute("DBDataBaseName").toString();
			String strDBUserName=session.getAttribute("DBUserName").toString();
			String strDBUserPass=session.getAttribute("DBUserPass").toString();
				
			dbConnector=new DBConnector();
			connection=dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName, strDBUserName, strDBUserPass);
			/*Modules for which the student belongs to the course*/
			statement=connection.prepareStatement("select module_Id,module_Name from ePariksha_Student_Login,ePariksha_Modules where ePariksha_Student_Login.stud_Course_Id=ePariksha_Modules.module_Course_Id and stud_PRN=?",ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
			statement.setString(1, strUserId.trim());
			result=statement.executeQuery();
		
		}
		session.removeAttribute("NumberOfQuestion");
		session.removeAttribute("QuestionAttempet");
		session.removeAttribute("QuestionCorrected");
		session.removeAttribute("Percentage");
		session.removeAttribute("TimeDuration");
		session.removeAttribute("RequestCounter");
		
	%>
	
			
	<div id="mainBody"  align="center" >
    <div id="topArea"><!-- div Top container -->
      <table width="800px" cellspacing="0" cellpadding="0"><!-- div left banner -->
          <tr>
            <td width="30%" align="left" valign="top" style="padding-top:3px; padding-left:5px; padding-bottom:0px;">
	            <a href="http://acts.cdac.in"><img src="images/cdac-acts_inner.png" alt="" width="120" height="30" border="0" /></a>
            </td>
            <td width="70%" align="right" valign="top" style="padding-top:10px;">
	            <ul>
	            	<li><img alt="Active User" title="Active User" src="images/Profile.png" style="width:24px;height:22px;"></li>
					<li style="padding-top:5px;color:#1C89FF;"><%=strUserName%></li>
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
        
      <div id="workArea"> <!-- Div Work area begins --> <!-- work area begins -->
			<br/>
					<div style="padding-top:5px;padding-left:5px; width: 220px">
						<img style="width:22px;height:22px;" src="images/home.png">
						<label class="pageheader" >Student Home</label>
					</div>
			<br>	
		<form id="frmModule" name="frmModule" action="ExamQuestion.pks" method="post">
			<input type="hidden" id="flag" name="flag" value="">
			<input type="hidden" id="txtSelectedModuleId" name="txtSelectedModuleId" value="">
			<input type="hidden" id="txtSelectedModuleName" name="txtSelectedModuleName" value="">
			<input type="hidden" id="txtSubmitSelectedTotalQuestionCount" name="txtSubmitSelectedTotalQuestionCount" value="">
			<input type="hidden" id="txtSubmitSelectedModuleExamDuration" name="txtSubmitSelectedModuleExamDuration" value="">
			
				
		</form>
		<%

		 
		%>
		<div id="divMainContainer" style="width:800px;"><!-- Div Main Container begins -->
			<div class="glidecontenttoggler"  id="divEntryLinks" style="overflow-y:auto;width: 520px;height:320px;float:left;margin:0px 0px 0px 10px;">
				<table id="tableModuleExams" style="width: 90%;height:90%;padding-top:0px;" >
						<tr>
				<%
					ExamModuleStatusTeller emst	=	new ExamModuleStatusTeller();//this object helps to find diff status
					boolean isResultFound =	false;
					int iTotalExamsToday	=	0;

					while(result.next())
					{
						String strModuleId=result.getString("module_Id");
						String strModuleName=result.getString("module_Name");
						String strShortModuleName=null;
						
						if(strModuleName.length()>20)
							strShortModuleName=strModuleName.substring(0,20)+"...";
						else
							strShortModuleName=strModuleName;
						

							if(emst.isExamScheduledToday(connection,strModuleId)==true)	
							{	
								iTotalExamsToday++; //Counts the total number of exams today to be used in glider
								
								%><%	

									if(emst.isResultFound(connection, strModuleId, strUserId)==true)
									{	
									%>
										<td  align="center" style="width:100%;height:100%">
											<div align="center" style="width:80px;height:80px;">
												<a href=" javascript:void(0);" title="<%=strModuleName%> Exam already given" id="<%=strModuleId%>" class="toc" href="#" 
												onclick=" javascript:void(0);" style="font-size:12pt;color:grey;opacity:0.2;cursor:default;text-decoration: none;">
												<img border="0" style="text-decoration: none;width:80px;height:80px;filter: alpha(opacity=13);" src="images/books.gif"><br><%=strModuleName%></a>
												<input type="hidden" value="<%=strModuleName%>" name="txtModuleName<%=strModuleId%>" id="txtModuleName<%=strModuleId%>">
											</div>
										</td>
									<%}
									else
									{
										if(emst.isExamActive(connection,strModuleId)==true)
										{
										
										String sPaperExists = emst.getQuestionPaperStream(connection, strCourseId, strModuleId, strUserId);
										
										String totalQuestions	=	emst.getExamQuestionsOfModule(connection, strCourseId, strModuleId);
										
										String totalDurationModuleSetting	=	emst.getExamDurationOfModule(connection, strCourseId, strModuleId);

										%>
										  <td align="center" style="width:100%;height:100%">
										  	  <div align="center" style="width:80px;height:80px;">
												<a title="Click to start <%=strModuleName%> exam" id="<%=strModuleId%>" style="font-size:12pt;" class="toc" href="#" onclick=" selectModule(this.id,<%if(sPaperExists==null || sPaperExists.equals("")){%>1<%}else{ %>2<%}%>)" 
												  style="cursor:pointer" >
												<img border="0" style="text-decoration: none;width:80px;height:80px;" src="images/books.gif"><br><%=strModuleName%></a>
											  	<input type="hidden" value="<%=strModuleName%>" name="txtModuleName<%=strModuleId%>" id="txtModuleName<%=strModuleId%>">
											 	<input type="hidden" value="<%=totalQuestions%>" name="txtSelectedExamQuestions<%=strModuleId%>" id="txtSelectedExamQuestions<%=strModuleId%>">
												<input type="hidden" value="<%=totalDurationModuleSetting%>" name="txtSelectedExamDuration<%=strModuleId%>" id="txtSelectedExamDuration<%=strModuleId%>">
											 
											  </div>
										  </td>
										<%
										}
										else
											iTotalExamsToday--;
									} 
								

							}
							if(iTotalExamsToday%3==0)
							{
								%></tr><tr><%
								
							}
							else
							{
								%><%
							}
						
					}//end while
					

					%>
					</table>	
				</div>
				
				
				<script type="text/javascript">
					featuredcontentglider.init({
					gliderid: "divMenuDescriptionHolder", //ID of main glider container
					contentclass: "glidecontent", //Shared CSS class name of each glider content
					togglerid: "divEntryLinks", //ID of toggler container
					remotecontent: "", //Get gliding contents from external file on server? "filename" or "" to disable
					selected: <%=iTotalExamsToday%>, //Default selected content index (0=1st)//Removed for empty description
					persiststate: false, //Remember last content shown within browser session (true/false)?
					speed: 1000, //Glide animation duration (in milliseconds)
					direction: "leftright", //set direction of glide: "updown", "downup", "leftright", or "rightleft"
					autorotate: false, //Auto rotate contents (true/false)?
					autorotateconfig: [3000, 2] //if auto rotate enabled, set [milliseconds_btw_rotations, cycles_before_stopping]
				})
				</script>	
				<div id="divContainerProfileLinks" style="margin:0px 10px 0px 0px;height:320px;width:250px;float:right">
		    		<div id="divMenuDescriptionHolder" class="glidecontentwrapper" style="padding:0px 0px 0px 0px;width:300px;height:300px;">
	    						
								 
								<%	ResultSet rsExamDetails=null;
									String sExamDate	=	null;
									int 	sTotalQuestions	=	0;
									int 	iDuration	=	0;
									int iMinPassMarks	=	0;
									int iMarks	=	0;
									String sResult	=	null;

								
									result.beforeFirst(); //to again use result set
									
									/*Search for each exam scheduled for today depending on student*/
									while(result.next())
									{
										String strModuleId=result.getString("module_Id");
										String strModuleName=result.getString("module_Name");
										String strShortModuleName=null;

										if(strModuleName.length()>20)
											strShortModuleName=strModuleName.substring(0,20)+"...";
										else
											strShortModuleName=strModuleName;
										
										if(emst.isExamScheduledToday(connection,strModuleId))	
										{
											if(emst.isExamActive(connection,strModuleId))
											{	
												statement=connection.prepareStatement("select to_char(exam_Date, 'DD-MM-YYYY') examDate, exam_No_Of_Ques,exam_Time_Duration,exam_Min_Passing_Marks"+
																						" from ePariksha_Exam_Schedule where exam_Module_Id	=?"+
																						" and to_char(exam_Date, 'DD-MM-YYYY') = to_char(now(), 'DD-MM-YYYY')"																			
																						,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
		
												
												statement.setLong(1, Long.parseLong(strModuleId));
												
												rsExamDetails	=	statement.executeQuery();
												
												while(rsExamDetails.next())
												{
													sExamDate	=	rsExamDetails.getString("examDate");
													sTotalQuestions	=	rsExamDetails.getInt("exam_No_Of_Ques");
													//session.setAttribute("NumberOfQuestion",sTotalQuestions);
													iDuration	=	rsExamDetails.getInt("exam_Time_Duration");
													//session.setAttribute("TimeDuration",(iDuration*60*1000));
													iMinPassMarks	=	rsExamDetails.getInt("exam_Min_Passing_Marks");
													
												}
												if(rsExamDetails!=null)
													rsExamDetails.close();
												if(statement!=null)
													statement.close();/**closing the statement*/ 
												
												/*If Result found then get the result to display in glider.*/
											}	//is exam active.
		
											
											
											
											if(emst.isResultFound(connection, strModuleId, strUserId))
											{
												
												if(emst.isResultShown(connection, strModuleId))
												{
													statement=connection.prepareStatement("select result_Marks"+
															" from ePariksha_Results"+
															" where ePariksha_Results.result_Module_Id=?"+ 
															" and result_stud_PRN=TRIM(?)"+
															" and to_char(result_Exam_Date, 'DD-MM-YYYY') = to_char(now(), 'DD-MM-YYYY')"																			
															,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);

					
													statement.setLong(1, Long.parseLong(strModuleId));
													statement.setLong(2,Long.parseLong(strUserId));

													rsExamDetails	=	statement.executeQuery();
													
													while(rsExamDetails.next())
													{
														iMarks	=	rsExamDetails.getInt("result_Marks");
													}
													
												}
												
												
											}
												
												%>
												<%if(emst.isExamActive(connection,strModuleId) || emst.isResultFound(connection,strModuleId,strUserId))
												  {
												  %>
													<div class="glidecontent" >
															<div align="center"><label class="lblstyle"><%=strShortModuleName%> Exam</label></div>
															
															<ul style="font-size: 10pt;list-style-image:url('images/flyarrow.png');">
																<li style="padding:15px 0px 0px 0px;">Exam Date: <%=sExamDate%></li>
																<li style="padding:15px 0px 0px 0px;">Total Questions: <%=sTotalQuestions%> </li>
																<li style="padding:15px 0px 0px 0px;">Duration: <%=iDuration%> mins</li>
																<li style="padding:15px 0px 0px 0px;">Negative marking: N/A</li>
														
																<%if( emst.isResultFound(connection,strModuleId,strUserId) && emst.isResultShown(connection,strModuleId)  ){%>
																	<li style="padding:15px 0px 0px 0px;">Minimum passing marks: <%=iMinPassMarks%></li>
																	<li style="padding:15px 0px 0px 0px;">Marks: <%=iMarks%> </li>
																	<li style="padding:15px 0px 0px 0px;">Result: <%if(iMarks<iMinPassMarks){%>Fail<%}else{ %>Pass<%}%></li>
																<%}%>
																
															</ul>
													</div>
												<%
											}//end exam active
												
										}//end if of exam schedule
									}	
									
									
									%> 
								 <%
									if(result!=null)
										result.close();
									if(statement!=null)
										statement.close();/**closing the statement*/ 
								%>	
								 

								
								<div class="glidecontent" style="float: right; ">
									<div align="center"><label class="lblstyle">Welcome <%=strUserName%></label></div>
									<ul style="font-size: 10pt;list-style-image:url('images/flyarrow.png');">
										<li style="padding:10px 0px 0px 0px;">Mouse-over module to see instructions &amp; click to start your exam.</li>
										<li style="padding:10px 0px 0px 0px;">Exams scheduled today and allowed by examiner will be shown here.</li>
										<li style="padding:10px 0px 0px 0px;">Exams attempted will be shown in faded colour.</li>
										<li style="padding:10px 0px 0px 0px;">If browser is closed or any system problem occurs, the exam can be resumed.</li>
										
									</ul>
								</div>
								
   					 	</div>
		
					</div><!-- div divContainerProfileLinks ends -->
								<div style="clear:both;"></div>
				
					
			</div><!-- Div Main Container ends -->
		
		
		
		<br/>
			<table class="" width="100%" height="100%" cellpadding="0" cellspacing="0" >
				<tr>
					
					<td width="68%" align="left" valign="top">
					  
					  
					</td>
				</tr>
			</table>
			
		
			
	 </div><!-- work area ends -->
	<%
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
		<!-- Script to calculate all tds width for displaying modules -->
		<script type="text/javascript">
		  var tableModuleExams;
		  
		  if(document.getElementById("tableModuleExams")!=null)
		  {
				  tableModuleExams	=	document.getElementById("tableModuleExams");
				  var tds	=	tableModuleExams.getElementsByTagName("td");
				  for(var i=0;i<tds.length;i++)
				  {
					  
					  tds[i].style.width=(100/<%=iTotalExamsToday%>)+'%';
					  
					  if(tds.length>3)
					  {
					  	tds[i].style.height=(100/<%=iTotalExamsToday%>)+'%';
					  }

				  }
				
		  }
		  if(<%=iTotalExamsToday%>==0)
		  {		  		
			  document.getElementById('divMainContainer').innerHTML='<div class="message_directions" align="center" id="divEditMsg" style="width:100%;padding:150px 0px 0px 0px">'
              +'No exam is scheduled today. Please contact examiner'+'</div>';  
		  }
		  
		</script>
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
	</div>
	</body>
<%}}%>
</html>