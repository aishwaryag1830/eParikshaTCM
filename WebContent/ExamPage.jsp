<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" session="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>

<%@page import="in.cdac.acts.connection.DBConnector"%><html>
<%
response.setHeader("Cache-Control", "no-cache"); // HTTP 1.1 
response.setHeader("Pragma", "no-cache"); // HTTP 1.0 
response.setDateHeader("Expires", 0); // Proxies.


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
	<META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">
	<META HTTP-EQUIV="PRAGMA" CONTENT="NO-CACHE">
	<META HTTP-EQUIV="EXPIRES" CONTENT="0">

	<title>ExamPage [ePariksha]</title>
	<link href="Css/style.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript">
		javascript:window.history.forward(1);
	</script>
	<script type="text/javascript" src="validate.js"></script>
	<script type="text/javascript" src="Js/Exam.js"></script>
	<!-- 
			Student exam page
			Author:Prashant Bansod
			Date: 17-01-12
		 -->
	
		 
	</head>
	<%
	if(session.getAttribute("QuestionPaperStream")==null || session.getAttribute("UserId")==null || session.getAttribute("UserName")==null 
		|| session.getAttribute("ModuleId")==null || session.getAttribute("ModuleName")==null )
	{
	%>
		<jsp:forward page="index.jsp"></jsp:forward>
	<%
	}
	else
	{	
		String strQuestionPaper =null;
		String strUserId		=null;
		String strUserName		=null;
		String strModuleId		=null;
		String strModuleName	=null;
		int iNoOfQuestions		=0;
		
		
		
		strQuestionPaper 	=session.getAttribute("QuestionPaperStream").toString();/*fetching Question Paper Stream From ExamQuestion servlet*/
		strUserId			=session.getAttribute("UserId").toString();				/*fetching User Id From Session*/
		strUserName			=session.getAttribute("UserName").toString();			/*fetching User Name From Session*/
		strModuleId			=session.getAttribute("ModuleId").toString();		/*fetching Sub Module ID From Session*/
		strModuleName		=session.getAttribute("ModuleName").toString();
		
		if(session.getAttribute("NumberOfQuestion")!=null)
			iNoOfQuestions		=Integer.parseInt(session.getAttribute("NumberOfQuestion").toString());
		
		/**
		 * variables for database connections
		 * */
		DBConnector dbConnector=null;			//Creating object of DBConnector class to make database connection.
		Connection connection=null;
		PreparedStatement statement=null;
		ResultSet result=null;
		
		int iQuestionNumber  	=0;
		String strQuestionNumber=null;
		String strQuestionId	=null;
		String strQuestion		=null;
		String strOption1		=null;
		String strOption2		=null;
		String strOption3		=null;
		String strOption4		=null;
		String strCorrectAnswer	=null;
		String strAnswerGiven	=null;
		
	
		
		if(session.getAttribute("QuestionNumber")!=null)
			iQuestionNumber=Integer.parseInt(session.getAttribute("QuestionNumber").toString());
		else
			iQuestionNumber=0;
				
		if(request.getParameter("txtQNumber")!=null)
			strQuestionNumber=request.getParameter("txtQNumber");
		
		if(strQuestionNumber!=null && !strQuestionNumber.equals(""))
		{
			session.setAttribute("QuestionNumber",strQuestionNumber);
			iQuestionNumber=Integer.parseInt(strQuestionNumber);
		}
		%>
	<%! public String getQuestionId(String strStream,int iIndex)
		{
			String []sQuestionIdOnIndex;
			sQuestionIdOnIndex	=	strStream.split(",");
			return sQuestionIdOnIndex[iIndex-1];
		}
	%>
	<%
	

		strQuestionId=getQuestionId(strQuestionPaper,iQuestionNumber);
				
		session.setAttribute("QuestionId",strQuestionId);
		
		/** Making connection*/
		String strDBDriverClass=session.getAttribute("DBDriverClass").toString();
		String strDBConnectionURL=session.getAttribute("DBConnectionURL").toString();
		String strDBDataBaseName=session.getAttribute("DBDataBaseName").toString();
		String strDBUserName=session.getAttribute("DBUserName").toString();
		String strDBUserPass=session.getAttribute("DBUserPass").toString();
			
		dbConnector=new DBConnector();
		connection=dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName, strDBUserName, strDBUserPass);
		
		statement=connection.prepareStatement("select TRIM(exam_Ques_Text)as ques,TRIM(exam_Option1) as opt1"+
			      ",TRIM(exam_Option2) as opt2,TRIM(exam_Option3) as opt3"+
			     " ,TRIM(exam_Option4) as opt4,exam_Correct_Answer from ePariksha_Exam_Questions where exam_Ques_Id=? and exam_Module_Id =?",
				ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
		statement.setLong(1, Long.parseLong(strQuestionId));
		statement.setLong(2, Long.parseLong(strModuleId));
		result=statement.executeQuery();
		if(result.next())
		{
			
			strQuestion		=result.getString("ques");
			strOption1		=result.getString("opt1");
			strOption2		=result.getString("opt2");
			strOption3		=result.getString("opt3");
			strOption4		=result.getString("opt4");
			strCorrectAnswer=result.getString("exam_Correct_Answer");
		}
		if(statement!=null)
			statement.close();
		
		session.setAttribute("CorrectAnswer",strCorrectAnswer);
		
		statement=connection.prepareStatement("Select exam_Answer_Given from ePariksha_Exam_Mapping where exam_Ques_Id=? and exam_Module_Id=? and exam_Stud_PRN=TRIM(?)");
		statement.setLong(1, Long.parseLong(strQuestionId));
		statement.setLong(2, Long.parseLong(strModuleId));
		statement.setString(3, strUserId);
		
		result=statement.executeQuery();
		if(result.next())
		{
			strAnswerGiven=result.getString("exam_Answer_Given");
		}
		if(statement!=null)
			statement.close();
	%>
	
	<script type="text/javascript">
		setInterval("showTimeRemaining()",1000);
	</script>
	<body onload="showTimeRemaining();">	
	
	
	
	
	
	<div id="mainBody"  align="center">
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
		<div style="padding-bottom:5px;">
		    <div style="float:left;padding-top:5px;padding-left:5px; width: 664px">
				<div style="float:left;width:508px;padding-top:8px;"><img style="width:22px;height:22px;" src="images/exam.png">
						<label class="pageheader" ><%=strModuleName.trim()%> Exam</label>
				</div>	
				<div style="float:right;width:156px">
					<div  style="float:left;width:86px">
						<div style="float:left;height:10px;width:10px;background-color:#1C89FF;margin-top:15px"></div>
						<div style="float:right;margin-top:12px">Unattempted&nbsp;</div>
						<div style="clear:both"></div> 
					</div>
					<div  style="float:right;width:69px">
						<div style="float:left;height:10px;width:10px;background-color:#A70505;margin-top:15px"></div>
						<div style="float:right;margin-top:12px">Attempted </div>
						<div style="clear:both"></div> 
					</div>
					<div style="clear:both"></div> 
				</div>
				<div style="clear:both"></div> 
			</div>
			<div style="float:right;margin-top:10px;" title="Time Remaining">
				<div style="width:93px">
					<div style="float:left;margin-right:5px; width: 30px;height:30px;"><img style="width: 30px;height:30px;" src="images/clock.png"></div>
					<div style="float:right;margin-top:7px;width: 58px;color:#1C89FF" id="time">no time</div>
					<div style="clear:both;"></div>
				</div>
				
			</div>
			<div style="clear:both;"></div>
		</div>	
			
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td><div id="Q"></div></td></tr>
			<tr>
				<td>								
					<div id="divSeparator" style="margin:0px 0px 5px 0px;" align="center"><img src="images/separator.gif" style="width:100%;height:1px;"></div>
				</td>
			</tr>
			<tr>
				<td>
					<table width="100%" cellpadding="0" cellspacing="0">
						<tr>
							<%
							for(int iTemp=1;iTemp<=iNoOfQuestions;iTemp++)
							{
								String strLinkColor=null;
								String strAnswerTest=null;
								String strColor=null;
								String strTitle=null;
								long lQIdTest=0;
								if(getQuestionId(strQuestionPaper,iTemp)!=null)
									lQIdTest=Long.parseLong(getQuestionId(strQuestionPaper,iTemp).trim());
								
							
								statement=connection.prepareStatement("Select exam_Answer_Given from ePariksha_Exam_Mapping where exam_Ques_Id=? and exam_Module_Id=? and exam_Stud_PRN=TRIM(?)");
								statement.setLong(1, lQIdTest);
								statement.setLong(2, Long.parseLong(strModuleId));
								statement.setString(3, strUserId);
								result=statement.executeQuery();
								if(result.next())
								{
									strAnswerTest=result.getString("exam_Answer_Given");
								}
								if(statement!=null)
									statement.close();
								
								if(strAnswerTest!=null && !strAnswerTest.equals(""))
								{
									strColor="#A70505";
									strTitle="Attempted";
								}
								else
								{
									strColor="#1C89FF";
									strTitle="Unattempted";
								}
								
								if(iQuestionNumber==iTemp)
								{
									if(strAnswerTest!=null && !strAnswerTest.equals(""))
									{
										strLinkColor="#A70505";
									}
									else
										strLinkColor="#1C89FF";
									
									strColor="white";
								}
								else
									strLinkColor="white";
								
								
							%>
							<td align="center">
								<a href="javascript:void(0);" onclick="<%if(iQuestionNumber!=iTemp){%>clickLink('<%=iTemp%>')<%}else{%>javascript:void(0);<%}%>" id="link<%=iTemp%>"
								class="<%if(iNoOfQuestions<100){%>ques_link_module_less_100<%} else if(iNoOfQuestions==100){%>ques_link_module_equal_100<%}else{%>ques_link_module_greater_100<%}%>"
								style="font-size:11pt;font-weight:bold;color:<%=strColor%>;background-color: <%=strLinkColor%>;<%if(iQuestionNumber==iTemp){%>cursor:default;text-decoration:none;<%}%>" title="<%=strTitle%>"><%=iTemp%>
							</a>
							</td>
						<%
						if(iTemp%25==0 || iTemp==iNoOfQuestions)
						{%>
						</tr>
						<tr>
						<%}
						}
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
						</tr>
					</table>
				</td>
			</tr>
			<tr><td>					
				<div id="divSeparatorQLinkDown" style="margin:5px 0px 5px 0px;" align="center"><img src="images/separator.gif" style="width:100%;height:1px;"></div>
			</td></tr>
			<tr>
				<td align="left">
					<div id="opt_ques_exp_message" style="margin:0px 0px 5px 5px;">
						<label class="lblstyle">Question No: <%=iQuestionNumber%></label>
						
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div id="ques_text">
						<%/*Formating The Question for Display*/
						int iTemp = 0;
						while (strQuestion.length() > iTemp )
						{
							switch (strQuestion.charAt(iTemp))
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
								  %><%=strQuestion.charAt(iTemp )%><%
							}
							iTemp++;
						}%>
					</div>
				</td>
			</tr>
			<tr><td>				
			<div id="divQLinkDown" style="margin:0px 0px 5px 0px;" align="center"><img src="images/separator.gif" style="width:100%;height:1px;"></div>
			</td></tr>
			<tr>
				<td>
				<form name="frmExam" action="" method="post">
					<table width="100%" cellpadding="0" cellspacing="0">
						<tr valign="top">
							<td align="left" id="opt" width="100%"><div style="margin:0px 0px 5px 5px;" id="opt_ques_exp_message"><label class="lblstyle">Options:</label></div></td>
						</tr>
						<tr>
							<td align="left" style="padding-left:20px;">
								<div id="divOpt1" style="cursor:default;margin-bottom:5px;" onclick="javascript:document.frmExam.Option1.checked='true';submiAnswer();">
									 <input type="radio"  name="optRad" style="float:left;" id="Option1" value="1">
										<div class="ques_opt">
										<%/*Formating The Options for Display*/
										iTemp = 0;
										while (strOption1.length() > iTemp )
										{
										 	switch (strOption1.charAt(iTemp))
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
											    %><%=strOption1.charAt(iTemp )%><%
											}
											iTemp++;
										}%>
										</div>
								</div>
							</td>
						</tr>
						
						<tr>
							<td align="left" style="padding-left:20px;">
								<div id="divOpt2" style="cursor:default;margin-bottom:5px;" onclick="javascript:document.frmExam.Option2.checked='true';submiAnswer();">
									<input type="radio" name="optRad" style="float:left;" id="Option2" value="2">
											<div class="ques_opt">
										<%/*Formating The Options for Display*/
										iTemp = 0;
										while (strOption2.length() > iTemp )
										{
										 	switch (strOption2.charAt(iTemp))
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
											    %><%=strOption2.charAt(iTemp )%><%
											}
											iTemp++;
										}%>
										</div>
								</div>
							</td>
						</tr>
						<tr>
							<td align="left" style="padding-left:20px;">
								<div id="divOpt3" style="cursor:default;margin-bottom:5px;" onclick="javascript:document.frmExam.Option3.checked='true';submiAnswer();">
									<input type="radio" name="optRad" style="float:left;" id="Option3" value="3">
											<div class="ques_opt">
										<%/*Formating The Options for Display*/
										iTemp = 0;
										while (strOption3.length() > iTemp )
										{
										 	switch (strOption3.charAt(iTemp))
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
											    %><%=strOption3.charAt(iTemp )%><%
											}
											iTemp++;
										}%>
										</div>
								</div>
							</td>
						</tr>
						<tr>
							<td align="left" style="padding-left:20px;">
								<div id="divOpt4" style="cursor:default;margin-bottom:5px;" onclick="javascript:document.frmExam.Option4.checked='true';submiAnswer();">
									    <input type="radio"  name="optRad" style="float:left;" id="Option4" value="4">
										<div class="ques_opt">
										<%/*Formating The Options for Display*/
										iTemp = 0;
										while (strOption4.length() > iTemp )
										{
										 	switch (strOption4.charAt(iTemp))
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
											    %><%=strOption4.charAt(iTemp )%><%
											}
											iTemp++;
										}%>
										</div>
								</div>
								<input  type="hidden" name="txtQNumber" id="txtQNumber" value="" >
								<input type="hidden" name="txtNoOfQues" id="txtNoOfQues" value="<%=iNoOfQuestions%>">
							</td>
						</tr>
						<tr><td>				
							<div id="divOptionLinkDown" style="margin:5px 0px 0px 0px;" align="center"><img src="images/separator.gif" style="width:100%;height:1px;"></div>
						</td></tr>
						<tr>
							<td align="center" style="padding-top: 5px;padding-bottom: 5px;">
								<div id="divButtonHolder" style="margin-top:10px;">	
									<div style="float:left;margin-left:5px;">
										
										<input <% if(iQuestionNumber==1){%>disabled="disabled"<%}%> type="button" value="&lt;&lt; Prev " name="btnPrevious" class="button" title="Go to Previous Question" style="margin-right: 50px;"  onclick="clickLink('<%=iQuestionNumber-1%>');">
										 
										<input <% if(iQuestionNumber==iNoOfQuestions){%>disabled="disabled"<%}%> type="button" value="Next &gt;&gt;" name="btnNext" class="button" title="Go to Next Question" style="margin-right: 50px;" onclick="clickLink('<%=iQuestionNumber+1%>');">
									</div>
									<div style="float:right;margin-right:5px;">
										<input type="button"  value=" End Exam" name="btnEnd" class="button" title="End your Exam" onclick="return endModuleExam(this);">
										<span id="endLoader" style="display:none;"><img src="images/ajaxLoader.gif" alt="ajax" style="width:20px;height:18px;"/></span>
									</div>
									<div style="clear:both;"></div>
								</div>
							</td>
						</tr>
					</table>
				  </form>
				</td>
			</tr>
		</table>
	</div><!-- workarea ends -->
	<div id="dropin" style="text-align:center;position:absolute;visibility:hidden;left:300px;
		top:200px;width:400px;height:250px;background-color:white;border-style: solid;border-width: 1px;border-color: gray;">
		<div style="color:gray;margin-top: 100px;font: 18px,Verdana;text-decoration: blink;font-weight: bold;">Your time is Over</div><br>
		<input type="button" class="button" onclick="dismissbox();return false" value="Ok ">
		<br>
	</div>
	<script type="text/javascript">
		document.frmExam.txtQNumber.value="<%=iQuestionNumber%>";
		<%
		if(!(strAnswerGiven==null || strAnswerGiven.equals("")))
		{
			int iRadSelected=Integer.parseInt(strAnswerGiven)-1;
		%>
			var opt=document.frmExam.optRad;
			opt[<%=iRadSelected%>].checked=true;
		<%}
		%>
		/*To avoid already selected radio button to be selected again*/
		if(document.getElementById('Option1').checked)
		{
			document.getElementById('Option1').onclick=function(){"javascript:void(0)";};
			document.getElementById('divOpt1').onclick=function(){"javascript:void(0)";};
			
		}
		else if(document.getElementById('Option2').checked)
		{
			document.getElementById('Option2').onclick=function(){"javascript:void(0)";};
			document.getElementById('divOpt2').onclick=function(){"javascript:void(0)";};
			
		}
		else if(document.getElementById('Option3').checked)
		{
			document.getElementById('Option3').onclick=function(){"javascript:void(0)";};
			document.getElementById('divOpt3').onclick=function(){"javascript:void(0)";};
			
		}
		else if(document.getElementById('Option4').checked)
		{
			document.getElementById('Option4').onclick=function(){"javascript:void(0)";};
			document.getElementById('divOpt4').onclick=function(){"javascript:void(0)";};

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
<%
	}
}
%>
</html>