<%@page import="in.cdac.acts.ExamModuleStatusTeller"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" session="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>

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
	<title>Exam Result [e-Pariksha] </title>
	<script type="text/javascript">
		javascript:window.history.forward(1);
	</script>
	<!-- 
			Student exam result to show them the results
			Author:Prashant Bansod
			Date: 17-01-12
		 -->
	</head>
	<body>
	<%
	if(session.getAttribute("UserId")==null || session.getAttribute("UserName")==null 
		|| session.getAttribute("ModuleName")==null || session.getAttribute("NumberOfQuestion")==null
		|| session.getAttribute("QuestionAttempet")==null || session.getAttribute("QuestionCorrected")==null
		)
	{
	%>
		<jsp:forward page="index.jsp"></jsp:forward>
	<%
	}
	else
	{
			String strUserId			=session.getAttribute("UserId").toString();
			String strUserName			=session.getAttribute("UserName").toString();
			String strModuleId			=session.getAttribute("ModuleId").toString();
			String strModuleName		=session.getAttribute("ModuleName").toString();
			String strNumberOfQ			=session.getAttribute("NumberOfQuestion").toString();
			String strQAttemped			=session.getAttribute("QuestionAttempet").toString();
			String strQCorrected		=session.getAttribute("QuestionCorrected").toString();
			String strPercentage		=session.getAttribute("Percentage").toString();
			
			/**
			 * variables for database connections
			 * */
			DBConnector dbConnector=null;			//Creating object of DBConnector class to make database connection.
			Connection connection=null;
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
	<%
	ExamModuleStatusTeller emst =new ExamModuleStatusTeller();
	if(emst.isResultShown(connection, strModuleId)==true) {%>
	
		<div id="header_Links" align="left" style="width:770px;margin-top:5px;">
			<div style="padding-top:5px;padding-left:5px; width: 220px">
				<img style="width:22px;height:22px;" src="images/Results.png">
				<label class="pageheader" >Result</label>
			</div>
			
		</div>
		<div id="divMainContainer" style="padding-bottom:20px;"> <!-- Div Main container -->
		<div id="divExamResult" align="center" style="float:left;margin:20px 0px 20px 20px;width:450px;height:200px;"><!-- div exam result begins -->
		
					<table  class="tblstyle" width="450px" height="200px" cellpadding="1" cellspacing="2">
						<tr>
							<td class="tdblue" align="left" style="width: 144px;height:35px;"><b>User Name</b></td>
							<td class="tdlightblue" align="left"><%=strUserName.trim()%></td>
						</tr>
						<tr>
							<td style="width: 144px;height:35px;" class="tdblue" align="left"><b>Module Name</b></td>
							<td class="tdlightblue" align="left"><%=strModuleName%></td>
						</tr>
						<tr>
							<td style="width: 144px;height:35px;" class="tdblue" align="left"><b>Total Questions</b></td>
							<td class="tdlightblue" align="left"><%=strNumberOfQ%></td>
						</tr>
						<tr>
							<td style="width: 144px;height:35px;" class="tdblue" align="left"><b>Questions Attempted</b></td>
							<td class="tdlightblue" align="left"><%=strQAttemped%></td>
						</tr>
						<tr>
							<td style="width: 144px;height:35px;" class="tdblue" align="left"><b>Correct Answers</b></td>
							<td  class="tdlightblue" align="left"><%=strQCorrected%></td>
						</tr>
						<tr>
							<td style="width: 144px;height:35px;" class="tdblue" align="left"><b>Marks Obtained</b></td>
							<td class="tdlightblue" align="left"><%=strQCorrected%></td>
						</tr>
						<tr>
							<td style="width: 144px;height:35px;" class="tdblue" align="left"><b>Percentage</b></td>
							<td class="tdlightblue" align="left"><%=strPercentage%> &#037;</td>
						</tr>
						<tr>
							
						</tr>
						
					</table>
						
			</div><!-- Div Exam Result ends -->
			
			<div id="divResultImage" style="float:right;padding:50px 20px 0px 0px;">
				<img src="images/barchart.gif" style="width:180px;height:180px;">
			</div>
			<div style="clear:both;"></div>
		</div><!-- Div Main container ends -->
		<br><br>
		<%}else{//end if of showing results %>
		<div align="center" style="margin-top:120px">
			<table>
				<tr><td><div class="message_directions" >You have completed the exam successfully. </div></td></tr>
				<tr>
					<td align="center">
						<br>
						<div style="margin: 0px;">
							<input type="button" name="btnLogout" value=" Logout " class="button"
							onclick="javascript:window.location='index.jsp'" title="Logout">
						</div>
					</td>
				</tr>
			</table>
		</div>
		<%}//end else %>
	</div><br>
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
}%>
</html>