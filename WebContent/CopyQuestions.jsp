<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" session="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.SQLException"%>


<%@page import="in.cdac.acts.connection.DBConnector"%><html>
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
		<title>Copy Questions [ePariksha]</title>
		<script src="Js/jquery-1.9.js"></script>
		<script type="text/javascript">
			javascript:window.history.forward(1);
		</script>
		<script type="text/javascript" src="Js/CopyQuestions.js"></script>
		<!-- 
			Copy Existing questions from different courses
			Author:Prashant Bansod
			Date: 17-01-12
		 -->
	</head>
	<body>
	

	<%
		
		if(session.getAttribute("UserId")==null || session.getAttribute("UserName")==null || session.getAttribute("snSelectedModuleIdForQuestions")==null)
		{
			%>
			<jsp:forward page="index.jsp"></jsp:forward>
		<%
		}
		else
		{
			String strUserId	=session.getAttribute("UserId").toString();
			String strUserName	=session.getAttribute("UserName").toString();
			String sCourseId	=session.getAttribute("CourseId").toString();	
			/**
			 * variables for displaying user information
			 * */
			
			String sModuleIdDestination		=null;
			String selectedDestModuleName		=null;
			String sSelectedQuestionId	=	null;
			String	sScrollMenuDivPosition	=	null;
			int iIotalQuestionsUpperLabel	=	0;
			
			if(session.getAttribute("snSelectedModuleIdForQuestions")!=null)
				sModuleIdDestination	=	session.getAttribute("snSelectedModuleIdForQuestions").toString();//taken from Questions.jsp
			 
			if(session.getAttribute("snDestModuleName")!=null)
				selectedDestModuleName	=	session.getAttribute("snDestModuleName").toString();//taken from Questions.jsp
			
			if(session.getAttribute("snDestModuleExistingTotalQNos")!=null)
				iIotalQuestionsUpperLabel	=	Integer.parseInt(session.getAttribute("snDestModuleExistingTotalQNos").toString());//taken from Questions.jsp

			
			 /** for Connection */
			DBConnector dbConnector=null;			//Creating object of DBConnector class to make database connection.
			Connection connection=null;
			PreparedStatement pstmt=null;
			ResultSet result=null;
			
			/** Making connection*/
			String strDBDriverClass=session.getAttribute("DBDriverClass").toString();
			String strDBConnectionURL=session.getAttribute("DBConnectionURL").toString();
			String strDBDataBaseName=session.getAttribute("DBDataBaseName").toString();
			String strDBUserName=session.getAttribute("DBUserName").toString();
			String strDBUserPass=session.getAttribute("DBUserPass").toString();
				
			dbConnector=new DBConnector();
			connection=dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName, strDBUserName, strDBUserPass);
			
			
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
					<li><a href="ExaminerHome.jsp"><img src="images/home.png" alt="Home" title="Home" width="24" height="22" border="0" /></a></li>
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
        
      <div id="workArea"> <!-- Div Work area begins -->			
		<br/>
		<div id="header_Links" align="left" style="width:770px;margin-top:5px;">
			<div style="float:left;padding-top:5px;padding-left:5px; width: 220px">
				<img style="width:22px;height:22px;" src="images/copyQuestions.png">
				<label class="pageheader" >Copy Questions</label>
			</div>
			<div align="right" style="float:right; width: 300px;padding:4px 0px 0px 0px;">
				<a href="Questions.jsp"><img style="width:22px;height:22px;padding-right: 2px" src="images/copyQuestions.png">Back to Repository</a>
			</div>
			<div style="clear:both;"></div>
		</div>
			
			
			<fieldset class="fieldsetStyle" style="height:50px;">
			<legend style="margin:0px 0px 0px 10px;color:blue;font-size:9pt;">Copy Questions From</legend>
				<div id="divControls" style="width:750px;;height:30px;margin:5px 0px 0px 5px;">
				
				<%
					try{
						/**Fetching result set for modules starts**/
						pstmt=connection.prepareStatement("select course_Id,course_Name,course_Short_Name from ePariksha_Courses order by course_Id",
						ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);	
						result=pstmt.executeQuery();
					}
					catch(SQLException sqle){}
					String sCourseIdOptions = null,sCourseName=null,sCourseShortNames=null;
				 %>
				 <table style="width:750px;">
					 <tr>
						 <td><label class="lblstyle">Courses:</label></td>
						 <td>
						 		<select name="drpCourses" id="drpCourses" onchange="javascript:drpSelectCourse(this);" style="width: 160px;height:20px;">
									<option value="0">--Select Course--</option>
									<%while(result.next())
									{
										sCourseIdOptions = result.getString("course_Id");
										sCourseName	=	result.getString("course_Name");
										sCourseShortNames	=	result.getString("course_Short_Name");
										%><option value="<%=sCourseIdOptions.trim()%>" title="<%=sCourseName.trim()%>"><%=sCourseShortNames.trim()%></option>
								   <%}%>
								</select>
						 </td>
					 
						 <td><label class="lblstyle">Modules:</label></td>
						 <td>
						 	<select name="drpModules" id="drpModules" onchange="javascript:drpSelectModule(this);" style="width: 160px;">
									<option value="0">--Select Module--</option>
							</select>
						 </td>
					 
						 <td><label class="lblstyle">Questions limit:</label></td>
						 <td>
						 	<form id="frmSelectQuestion" name="frmSelectQuestion" action="CopyQuestions.jsp" method="post">
								<select name="drpQuestionsCriteria" id="drpQuestionsCriteria" onchange="javascript:drpSelectQuestions(this.form,this);" style="width: 160px;height:20px;">
									<option value="0">--Select Ques. limit--</option>
								</select>
							</form>
						 </td>
					 </tr>
					 
				 </table>
				
			</div>
			</fieldset>
			<fieldset class="fieldsetStyle">
				<legend style="margin:0px 0px 0px 10px;color:blue;font-size:9pt;">Copy Questions To</legend>
				<div id="divModuleInfoContainer" style="width:750px;height:25px;margin:5px 0px 0px 5px;">
					<div id="divModuleSummary" style="float:left;padding:0px 0px 0px 4px;width: 600px;">
						<label class="lblstyle">Module: </label><%=selectedDestModuleName%>
					</div>
					<div  style="float:right;margin:0px 10px 0px 0px; width: 130px;"><label class="lblstyle">Existing Questions: </label><%=iIotalQuestionsUpperLabel%></div>
					<div style="clear:both;"></div>
				</div><!-- div container of modulesinfo ends -->
			</fieldset>
			
			
			<%if(result!=null)
		 		result.close();
		 	if(pstmt!=null)	
		 		pstmt.close();
		 	%>
			
			<div style="padding-top:20px;"><img style="width:800px;height:1px;" src="images/separator.gif"></div>
		 	<div align="center" id="divOperationalMsgs" class="message_directions" style="display:none;padding:150px 0px 0px 150px;height:200px;width: 530px;" >
					Please set criteria for copying questions.
			</div>
			
				   
		 	<%/*Fetching of question begins*/
				String sQuestionsCriteria	=	request.getParameter("drpQuestionsCriteria");
				String sModuleIdToFetchQuestions	=	null;			


				if(session.getAttribute("snSelectedModuleIdOfDrp")!=null)//From CopyQuestionsAjaxOperations Servlet
				sModuleIdToFetchQuestions	=	session.getAttribute("snSelectedModuleIdOfDrp").toString();
			
		
				if(sQuestionsCriteria==null)
				{ 
				 %><div id="divOperationalServerMsgs" class="message_directions" style="padding:150px 0px 0px 250px;height:200px;width: 530px;">
						Please set criteria for copying questions.
				   </div>
					
				<%}else{%>
												



					<div id="divContainerQuestions" style="margin:10px 0px 0px 0px;" >
							<div id="div_message_operations" align="center" style="height:5px;padding:0px 0px 15px 0px;">
								 <label id="lblMessages" class="message"> 
								 <%
								 		String msg="";
										try{
											 if(session.getAttribute("snMsgQuestions")!=null)
											 {	 
												    msg=session.getAttribute("snMsgQuestions").toString();
												   session.removeAttribute("snMsgQuestions");										 
											 }
										}catch(Exception e){e.printStackTrace();}
									 %><%=msg%> 
								 </label>
						 	</div>							<%
						 		String quesId=null,question="",opt1="",opt2="",opt3="",opt4="",sActualRowNumber=null;
								int c_ans	=	0,iStartQuesLimit=0,iEndQuesLimit=0;
					
								/*Get Start & End limit of selected ques criteria*/
								String []sQuestionCriteria=null;
								sQuestionCriteria=sQuestionsCriteria.split("-");
								iStartQuesLimit=Integer.parseInt(sQuestionCriteria[0]);
								iEndQuesLimit=Integer.parseInt(sQuestionCriteria[1]);
	
								try{
								   	 String sql	="select * from"+ 
								   			 " ("+
							   					"SELECT"+ 
							   					" exam_Ques_Id,exam_Ques_Text,exam_Option1,exam_Option2,exam_Option3,exam_Option4,exam_Correct_Answer,"+
							   					"row_number() over(order by exam_Ques_Id) as rownum"+
							   				    " FROM ePariksha_Exam_Questions"+
							   					" where exam_Module_Id=?"+
							   			") tempTable"+
							   			" where rownum between "+iStartQuesLimit+" and "+iEndQuesLimit+"" ;
								   	 
								 	 pstmt=connection.prepareStatement(sql,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
								 	 pstmt.setLong(1,Long.parseLong(sModuleIdToFetchQuestions) );//
								 	 result=pstmt.executeQuery();
									%>	 	
								
								<div id="divQuestionContents" style="width:620px;float:left;margin:0px 0px 0px 3px;padding:2px;">
									<div align="left" style="padding:0px 0px 0px 4px; width: 610px;">
										<div style="float:left">
											<span>
												<img style="width:25px;height:25px;padding-top:3px;" src="images/questionsHead.png">
											</span>
											<label class="lblstyle" style="padding:5px 0px 0px 5px;">Questions</label>
										</div>
										<div style="float:right;padding:10px 83px 0px 0px;">
											<input type="checkbox" id="chkSelectAll" />
											<label for="chkSelectAll" class="lblstyle">Select All</label>
										</div>
										<div style="clear:both"></div>
									</div>
									<br><br>
									<div id="divQuestionsHolder" style="position: relative;width:620px;height:525px;overflow-y:auto;margin:0px 0px 0px 3px;">
									<%
									while(result.next())
								 	 {
										quesId	=	result.getString("exam_Ques_Id");
								 		question=result.getString("exam_Ques_Text"); 
								 		opt1=result.getString("exam_Option1");
								 		opt2=result.getString("exam_Option2");
								 		opt3=result.getString("exam_Option3");
								 		opt4=result.getString("exam_Option4");
								 		c_ans=result.getInt("exam_Correct_Answer");
								 		sActualRowNumber	=	result.getString("rownum");
								 								
									%>
									<div align="center" id="divEachQuestionHolder<%=sActualRowNumber%>" style="position: relative;border:1px dotted #1C89FF;width:585px;margin:0px 2px 20px 0px;padding:5px;"><!-- div table holder starts -->
											<table  style="padding:0px 2px 0px 0px;width: 585px;height:300px;"  cellspacing=0 cellpadding=0>
									        	<tr>
													<td align="left">
														<label class="title"><b>Q.No:</b> <%=sActualRowNumber%></label>
														<span  style="margin-left:400px">
															<input onclick="javascript:selCheckBoxOperations(this,this.value);" type="checkbox" value="<%=quesId%>" name="chkThisQuestion" id="chkThisQuestion-<%=sActualRowNumber%>" >
															<label for="chkThisQuestion-<%=sActualRowNumber%>" class="lblstyle">Add to basket</label>
														</span>	
												
														<div style="padding-top:3px;" align="justify" id="divQuesText">
													 	<%/*Formating The Question for Display*/
															int iTemp = 0;
															while (question.length() > iTemp )
															{
																switch (question.charAt(iTemp))
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
																	  %><%=question.charAt(iTemp )%><%
																}
																iTemp++;
															}%>
														</div>
												  </td>
												</tr>
												<tr>
													<td align="left">
														<br>
														<b>Choice1:</b><br>
														<div style="padding-top:3px;" class="divChoice1" align="justify">
															<%/*Formating The Options for Display*/
															iTemp = 0;
															while (opt1.length() > iTemp )
															{
															 	switch (opt1.charAt(iTemp))
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
																    %><%=opt1.charAt(iTemp )%><%
																}
																iTemp++;
															}%>
														</div>
													</td>
												</tr>
												<tr>
													<td align="left" >
														<br>
														<b>Choice2:</b><br>
														<div style="padding-top:3px;" class="divChoice2" align="justify">
															<%/*Formating The Options for Display*/
															iTemp = 0;
															while (opt2.length() > iTemp )
															{
															 	switch (opt2.charAt(iTemp))
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
																    %><%=opt2.charAt(iTemp )%><%
																}
																iTemp++;
															}%>
														</div>
														
													</td>
												</tr>
													
												    
												<tr>
													<td align="left" >
														<br>
														<b>Choice3:</b><br>
														<div style="padding-top:3px;" class="divChoice3" align="justify">
															<%/*Formating The Options for Display*/
															iTemp = 0;
															while (opt3.length() > iTemp )
															{
															 	switch (opt3.charAt(iTemp))
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
																    %><%=opt3.charAt(iTemp)%><%
																}
																iTemp++;
															}%>
														</div>
													</td>
													</tr>
													<tr>
														<td align="left">
														<br>
														<b>Choice4:</b><br>
														<div style="padding-top:3px;" class="divChoice4" align="justify">
															<%/*Formating The Options for Display*/
															iTemp = 0;
															while (opt4.length() > iTemp )
															{
															 	switch (opt4.charAt(iTemp))
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
																    %><%=opt4.charAt(iTemp)%><%
																}
																iTemp++;
															}%>
														</div>
														</td>
													</tr>
													<tr>
													    <td align="left">
													   	 <br>
														    <label class="title"><b>Correct Answer:</b> </label><%=c_ans%>
														</td>
												    </tr>	
											</table>
									</div><!-- divEachQuestionHolder ends -->	
									<%}  if(result!=null)
										 		result.close();
										 	if(pstmt!=null)	
										 		pstmt.close();
										  }
										catch(SQLException e){e.printStackTrace();}
										
						    %>
						    	</div>
							</div><!--divQuestionContents ends  -->
							<div id="divQuestionLinks" style="float:right;width:156px;height:100%;padding-right:5px;">
						 		<div align="center" style="padding:0px 0px 8px 4px;">
						 			<span><img style="width:25px;height:25px;" src="images/questionsBasket.png"></span>
						 			<label class="lblstyle" style="font-style:italic;">Questions Basket</label>
						 		</div>
						 		<div id="divSelectedQuestions" style="overflow-y:auto;width:98%;height:450px;padding:10px 0px 0px 5px;">
									<p  style="padding-top:160px;color:red">Please add questions to this basket</p>
								</div><!-- menu links ends -->
								<form action="CopyQuestions" method="post" onsubmit="return CopyQuestionsNow();">
									<input type="hidden" id="txtFinalSelQuestions" name="txtFinalSelQuestions"/>
									<span></span>
									<br>
									<input class="button" id="subCopyNow" type="submit" disabled="disabled" value="Copy Now" style="width: 147px;height:25px;margin-left:8px; ">
								</form>
								
							</div>
							<div style="clear:both;"></div>
				
				</div><!-- div container ends -->
			<%}//end else of question selected%>
			<br><br>
		</div><!--workarea ends -->
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
<%}
}
%>
</html>