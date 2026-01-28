<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" session="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="in.cdac.acts.connection.DBConnector"%>
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
		<script type="text/javascript" src="Js/AdminMenu/MenuBar.js"></script>
		<script type="text/javascript" src="Js/Reports.js"></script>
		
		<script type="text/javascript">javascript:window.history.forward(1);</script>
		<title>Reports [ePariksha] </title>
		<!-- 
			View Detailed reports of the activity going in the system.
			Author:Prashant Bansod
			Date: 17-01-12
		 -->
	</head>
	
	<body onload="MM_swapImage('Image9','','images/index_21_a.gif',1)">
	<%
		
		if(session.getAttribute("UserId")==null || session.getAttribute("UserName")==null)
		{
			%>
			<jsp:forward page="index.jsp"></jsp:forward>
		<%
		}
		else
		{
			String sCourseId	=	null;
			long strUserId	=	Long.parseLong(session.getAttribute("UserId").toString());
			String strUserName	=	session.getAttribute("UserName").toString();
			
			if (session.getAttribute("CourseId") != null) {
				sCourseId	=	session.getAttribute("CourseId").toString();
			}
			
			String sRoleId	=	session.getAttribute("UserRoleId").toString();

			/**
				If trying to come to this page from other user redirect it to index page
			*/
			
			if(!sRoleId.equals("999"))//If trying to come to this page from other user redirect it to index page
			 {%><jsp:forward page="index.jsp"></jsp:forward><%}%>
			
		   <%  String strReportOptionId		=null;
				
				
			/*If module is already selected use session else fetch parameter*/	
			
			if(request.getParameter("txtRequestIdentifier")!=null)
			{	
				strReportOptionId	=	request.getParameter("txtRequestIdentifier");
				session.setAttribute("snSelectedReportOptionId",strReportOptionId);

			}
			else if(session.getAttribute("snSelectedReportOptionId")!=null)//from below session
				{
				strReportOptionId = session.getAttribute("snSelectedReportOptionId").toString();

				}
			 String strRoleName		=null;
			 String strCourseName	=null;
			 String strEMailId		=null;
			 long strMNumber		=0;
			 String strDOB			=null;
			 String strGender		=null;
		
			 /** for Connection */
			DBConnector dbConnector=null;			//Creating object of DBConnector class to make database connection.
			Connection connection=null;
			PreparedStatement statement=null;
			ResultSet result=null;
			
			/** Making connection*/
			String strDBDriverClass=session.getAttribute("DBDriverClass").toString();
			String strDBConnectionURL=session.getAttribute("DBConnectionURL").toString();
			String strDBDataBaseName=session.getAttribute("DBDataBaseName").toString();
			String strDBUserName=session.getAttribute("DBUserName").toString();
			String strDBUserPass=session.getAttribute("DBUserPass").toString();
				
			dbConnector=new DBConnector();
			connection=dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName, strDBUserName, strDBUserPass);
				
			statement=connection.prepareStatement("select user_Email_Id,user_M_Number"+
				" ,to_char(user_DOB, 'DD-MM-YYYY') as user_DOB,user_Gender"+
				",role_Name, course_Name from ePariksha_User_Master, ePariksha_Role_Master, ePariksha_Courses"+
				" where user_Id=? and ePariksha_User_Master.user_Role_Id=ePariksha_Role_Master.role_Id"+
				" and ePariksha_User_Master.user_Course_Id=ePariksha_Courses.course_Id");
	
			statement.setLong(1, strUserId);
			result=statement.executeQuery();
			if(result.next())
			{
				strEMailId		=result.getString("user_Email_Id");
				strMNumber		=result.getLong("user_M_Number");
				strDOB			=result.getString("user_DOB");
				strGender		=result.getString("user_Gender");
				strRoleName		=result.getString("role_Name");
				strCourseName	=result.getString("course_Name");
			}
			if(statement!=null)
				statement.close();/**closing the statement*/ 
			
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
	            <td align="center" valign="middle"><a href="ResultsAdmin.jsp" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image8','','images/index_20_a.gif',1)"><img src="images/index_20.gif" alt="Results" name="Image8" width="100" height="37" border="0" id="Image8" /></a></td>
	            <td align="center" valign="middle"><a href="javascript:void(0);" style="cursor:default;"><img src="images/index_21.gif" alt="Reports" name="Image9" width="100" height="37" border="0" id="Image9" /></a></td>
	            <td align="center" valign="middle"><a href="AdminProfile.jsp" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image10','','images/index_22_a.gif',1)"><img src="images/index_22.gif" alt="Profile" name="Image10" width="100" height="37" border="0" id="Image10" /></a></td>
	            
	          </tr>
	        </table>
        </div>
        <!-- Menu Bar ends -->
        
      
      <div id="workArea"><!-- work area begins -->
      	<br>
		<div style="padding-top:5px;padding-left:5px; width: 220px">
					<img style="width:22px;height:22px;" src="images/reports.png">
					<label class="pageheader" >Reports</label>
		</div>
			<div align="left" id="divResultFilterCriteria" style="width:100%;margin:15px 0px 0px 0px;">
										
										<form id="frmResultMenu"  name="frmResultMenu" target="iFrameReports" action="DisplayReports#toolbar=1&view=fit&navpanes=0" method="post">
											<table class="tblstyle"  style="width: 700px;height:40px;" align="center" >
												<tr>
													<td class="tdblue" align="left" style="width: 50px"><label class="lblstyle">Select Report </label></td>
													<td align="left" class="tdlightblue" style="width: 208px;padding-left:10px;">
	
														<select name="drpReports" id="drpReports" onchange="javascript:goSelectReports(this.form,this);" style="width: 207px;">
															<option value="0">--Reports--</option>
															<option value="1">1. Courses &amp; Modules</option>
															<option value="2">2. Users</option>
															<option value="3">3. Exams</option>
															<option value="4">4. Candidates</option>
															<option value="5">5. Result Details</option>
															
														</select>
														<input type="hidden" name="txtRequestIdentifier" id="txtRequestIdentifier"/>
														
													</td>
												</tr>
											</table>	
											
										</form>
								</div>
								<br>
								<div id="divSeparator" align="center"><img src="images/separator.gif" style="width:100%;height:1px;"></div>
								<br>
								<div id="divReportFrameHolder" > 
									 <iframe id="iFrameReports" name="iFrameReports" src="DisplayReports#toolbar=1&view=fit&navpanes=0" width="99%" height="570px">
									</iframe>
								</div> 	
								<br>
								<%
							if(strReportOptionId==null)
							{%>
								<div align="center" class="message_directions" id="div_messages_server" style="margin:57px 0px 0px 0px;"> <!-- messages and directions -->
								
										Please select report
										<script>
											if(document.getElementById('divReportFrameHolder')!=null)
												document.getElementById('divReportFrameHolder').style.display='none';
										</script>
								</div>
							<%}	%>
							
							
							
					
							 <div align="center" class="message_directions" id="divNoReportsSelected" style="margin:20px 0px 0px 40px;display:none">
								<br><br>Please select report
							</div>		
				<!-- Paste Your code here -->
		
	  </div><!-- work area ends -->
	<script>
			document.getElementById('drpReports').selectedIndex="<%=strReportOptionId%>";
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
<%}}
session.removeAttribute("ExamDate");
%>
</html>