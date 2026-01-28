<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" session="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Types"%>
<%@page import="java.sql.CallableStatement"%>


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
		<title>ExaminerHome [ePariksha]</title>
		<script type="text/javascript">
			javascript:window.history.forward(1);
		</script>
		<script type="text/javascript" src="jquery-1.3.1.min.js"></script>
		<script type="text/javascript" src="Js/modalfiles/modalDiv.js"></script>
		<script type="text/javascript" src="Js/Examiner.js"></script>
		<link rel="stylesheet" href="Js/modalfiles/modalDiv.css" type="text/css">
		<link rel="stylesheet" type="text/css" href="Js/ContentSlider/contentslider.css" />
		<script type="text/javascript" src="Js/ContentSlider/contentglider.js">
		/***********************************************
		* Featured Content Glider script- (c) Dynamic Drive DHTML code library (www.dynamicdrive.com)
		* Visit http://www.dynamicDrive.com for hundreds of DHTML scripts
		* This notice must stay intact for legal use
		***********************************************/
		</script>
		<!-- 
			Examiner Home is an single entry point to conduct exam.
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
			/*
			*Removing session variables used
			*/
			session.removeAttribute("snSelectedQuestionId");
		
		
			String strUserId	=	session.getAttribute("UserId").toString();
			String strUserName	=	session.getAttribute("UserName").toString();
			String sCourseId	=	session.getAttribute("CourseId").toString();
	
			String sRoleId	=	session.getAttribute("UserRoleId").toString();

			
			/**
			 * variables for displaying information
			 * */
			
			 String strCourseName	=null;
			 String strCourseShortName	=null;
			 String strCourseValidTill	=null;
			 int iTotalModules	=	0;
			 int iTotalStudents	=	0;
			 int iTotalExamsToday	=	0;
			 String strEMailId		=null;
			 String strMNumber = null;
			 long lMNumber		=0l;
			 String strPassword		=null ,sActualRoleIdAdmin="";
			 String strDefaultPassword		=	"cdac123";


		
			 /** for Connection */
			DBConnector dbConnector=null;			//Creating object of DBConnector class to make database connection.
			Connection connection=null;
			PreparedStatement statement=null;
			PreparedStatement prestmt = null;
			ResultSet result=null;
			
			/** Making connection*/
			String strDBDriverClass=session.getAttribute("DBDriverClass").toString();
			String strDBConnectionURL=session.getAttribute("DBConnectionURL").toString();
			String strDBDataBaseName=session.getAttribute("DBDataBaseName").toString();
			String strDBUserName=session.getAttribute("DBUserName").toString();
			String strDBUserPass=session.getAttribute("DBUserPass").toString();
			
			
			
			dbConnector=new DBConnector();
			connection=dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName, strDBUserName, strDBUserPass);
				
				
			/*To update the password if pasword is changed
			 Update password must be done before fetching values by procedure 
			*/	
			try{
				
				if(request.getParameter("txtOldPassword")!=null)//if password is getting changed txtoldpassword will not be a null value
				{
				
				
					String sNewPassword	=	request.getParameter("txtNewPassword");
					PreparedStatement pstmt=null;
					
					String strQuery="update ePariksha_User_Master set user_Password=TRIM(?) where user_Id=?";
					
					
					pstmt=connection.prepareStatement(strQuery);
					pstmt.setString(1,sNewPassword);
					pstmt.setLong(2, Long.parseLong(strUserId));
					
					pstmt.execute();
				}
			}catch(Exception e){}
				
			/* prestmt = connection.prepareStatement("call getCourseAndExaminerDetails(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
				
			prestmt.setInt(1, Integer.parseInt(sCourseId));
			prestmt.setLong(2, Long.parseLong(strUserId));
			prestmt.setString(3, strCourseName);
			prestmt.setString(4, strCourseShortName);
			prestmt.setString(5, strCourseValidTill);
			prestmt.setInt(6, iTotalModules);
			prestmt.setInt(7, iTotalStudents);
			prestmt.setInt(8, iTotalExamsToday);
			prestmt.setString(9, strPassword);
			prestmt.setString(10, strEMailId);
			prestmt.setLong(11, lMNumber);
			strMNumber = Long.toString(lMNumber);*/
			
			
			CallableStatement cstmtGetDetails = connection.prepareCall("call getCourseAndExaminerDetails(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
			
			cstmtGetDetails.setInt(1, Integer.parseInt(sCourseId));
			cstmtGetDetails.setLong(2, Long.parseLong(strUserId));

			cstmtGetDetails.setString(3, strCourseName);
			cstmtGetDetails.setString(4, strCourseShortName);
			cstmtGetDetails.setString(5, strCourseValidTill);
			cstmtGetDetails.setInt(6, iTotalModules);
			cstmtGetDetails.setInt(7, iTotalStudents);
			cstmtGetDetails.setInt(8, iTotalExamsToday);
			cstmtGetDetails.setString(9, strPassword);
			cstmtGetDetails.setString(10, strEMailId);
			cstmtGetDetails.setLong(11, lMNumber);
			
			cstmtGetDetails.registerOutParameter(3, Types.VARCHAR);
			cstmtGetDetails.registerOutParameter(4, Types.VARCHAR);
			cstmtGetDetails.registerOutParameter(5, Types.VARCHAR);
			cstmtGetDetails.registerOutParameter(6, Types.INTEGER);
			cstmtGetDetails.registerOutParameter(7, Types.INTEGER);
			cstmtGetDetails.registerOutParameter(8, Types.INTEGER);
			cstmtGetDetails.registerOutParameter(9, Types.VARCHAR);
			cstmtGetDetails.registerOutParameter(10, Types.VARCHAR);
			cstmtGetDetails.registerOutParameter(11, Types.BIGINT);
			
			
			/* prestmt = connection.prepareStatement("call demosp(?, ?)");
			
			prestmt.setInt(1, 10);
			prestmt.setInt(2, 5);
			//but how to read data back from the call? */
			
			
			/* CallableStatement cstmtGetDetails = connection.prepareCall("call demosp(?, ?)");
			
			cstmtGetDetails.setInt(1, 10);
			cstmtGetDetails.setInt(2, 90);
			cstmtGetDetails.registerOutParameter(2, Types.INTEGER); */
			
			
			 try{ 
				/* ResultSet rs = prestmt.executeQuery();
				while(rs.next()) {
					System.out.println("Return value access from SP : " + rs.getInt(1));
				}
			//RS is fine, but what's the use of INOUT Parameters then? */
				
				cstmtGetDetails.execute();
				//System.out.println("The value returned is : " + cstmtGetDetails.getInt(2));
				strCourseName	=	cstmtGetDetails.getString(3);
				strCourseShortName	=	cstmtGetDetails.getString(4);
				strCourseValidTill	=	cstmtGetDetails.getString(5);
				iTotalModules	=	cstmtGetDetails.getInt(6);
				iTotalStudents	=	cstmtGetDetails.getInt(7);
				iTotalExamsToday	=	cstmtGetDetails.getInt(8);
				strPassword	=	cstmtGetDetails.getString(9);
				strEMailId	=	cstmtGetDetails.getString(10);
				strMNumber	=	Long.toString(cstmtGetDetails.getLong(11));
				
								
			}
			catch(Exception e){e.printStackTrace();}
			
			if(cstmtGetDetails!=null)
				cstmtGetDetails.close();
			
			if(session.getAttribute("ActualAdminRoleId")!=null)//from SwitchRoleMgmt servlet
				sActualRoleIdAdmin	=	session.getAttribute("ActualAdminRoleId").toString();
			
			
			
		
			
	%>
	<script type="text/javascript"> 
			 
			featuredcontentglider.init({
				gliderid: "divMenuDescriptionHolder", //ID of main glider container
				contentclass: "glidecontent", //Shared CSS class name of each glider content
				togglerid: "divEntryLinks", //ID of toggler container
				remotecontent: "", //Get gliding contents from external file on server? "filename" or "" to disable
				selected: 6, //Default selected content index (0=1st)//Removed for empty description
				persiststate: false, //Remember last content shown within browser session (true/false)?
				speed: 1000, //Glide animation duration (in milliseconds)
				direction: "leftright", //set direction of glide: "updown", "downup", "leftright", or "rightleft"
				autorotate: false, //Auto rotate contents (true/false)?
				autorotateconfig: [3000, 2] //if auto rotate enabled, set [milliseconds_btw_rotations, cycles_before_stopping]
			})
			 
	</script>	
	
	
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
		<div id="header_Links" align="left" style="width:770px;margin-top:5px;">
				<div style="padding-top:5px;padding-left:5px; width: 220px">
					<img style="width:22px;height:22px;" src="images/home.png">
					<label class="pageheader" >Examiner Home</label>
				</div>
				
			</div>
			<br>	
		<div id="divMainContainer"><!-- Div Main Container begins -->
			<div  class="glidecontenttoggler"  id="divEntryLinks" style="width: 510px;height:290px;float:left;margin:20px 0px 0px 5px;">
							<table  style="width: 100%;height:100%;padding-top:0px;" >
								<tr>
									<td align="center" style="width:23%;height:23%">
										<div align="center" style="width:100%;height:100%;">
											<a class="toc" href="javascript:void(0)"><img border="0" style="text-decoration: none;" src="images/Course.png"><br>Course Info.</a>
										</div>
									</td>
									<td align="center" style="width:23%;height:23%">
										<div style="width:100%;height:100%">
											<a class="toc"  href="ModulesQuestions.jsp"><img border="0" style="text-decoration: none;" src="images/Modules.png"><br>Modules &amp; Questions</a>
											
										</div>
									</td>
									<td align="center" style="width:23%	;height:23%">
										<div style="width:100%;height:100%">
											<a class="toc" href="UnBlockUser.jsp"><img border="0" style="text-decoration: none;" src="images/CandidateProfiles.png"><br>Manage Students</a>
										</div>
									</td>
								</tr>
								<tr>
									<td align="center" style="width:23%;height:23%">
										<div style="width:100%;height:100%">
											<a class="toc" href="ScheduleExam.jsp"><img border="0" style="text-decoration: none;" src="images/exam.png"><br>Exams</a>

										</div>
									</td>
									
									<td  align="center" style="width:23%;height:23%">
										<div style="width:100%;height:100%">
											<a class="toc" href="Results.jsp"><img border="0" style="text-decoration: none;" src="images/Results.png"><br>Results</a>
										</div>
									</td>
									<td align="center" style="width:23%;height:23%">
										<div style="width:100%;height:100%">
											<a class="toc" href="javascript:void(0);"><img border="0" style="text-decoration: none;" src="images/Profile.png"/><br/>Profile</a>
										</div>
									</td>
								</tr>
								
								
							</table>
				</div>
							
				<div id="divContainerProfileLinks" style="margin:0px 5px 0px 0px;height:290px;width:250px;float:right">
		    		<div id="divMenuDescriptionHolder" class="glidecontentwrapper" style="padding:0px 0px 0px 0px;width:250px;height:290px;">
	    						
								 
								<div class="glidecontent" >
									<h4 align="center">Course Information</h4>
									<ul style="font-size: 10pt;list-style-image:url('images/flyarrow.png');">
										<li style="padding:15px 0px 0px 0px;">Course: <%=strCourseName%></li>
										<li style="padding:15px 0px 0px 0px;">Course Abbreviation: <%=strCourseShortName%></li>
										<li style="padding:15px 0px 0px 0px;">Course Valid Till: <%=strCourseValidTill%></li>
										<li style="padding:15px 0px 0px 0px;">Total Modules: <%=iTotalModules%></li>
										<li style="padding:15px 0px 0px 0px;">Total Students: <%=iTotalStudents%></li>
										<li style="padding:15px 0px 0px 0px;">Exams Today: <%=iTotalExamsToday%></li>
										
										
									</ul>
								</div>
								 
								 <div class="glidecontent" style="float: right;">
									<h4 align="center">Modules &amp; Questions</h4>
									<ul style="font-size: 10pt;list-style-image:url('images/flyarrow.png');">
										<li style="padding:15px 0px 0px 0px;">View details of modules of assigned course.</li>
										<li style="padding:15px 0px 0px 0px;">Upload,modify &amp; edit questions.</li>
										<li style="padding:15px 0px 0px 0px;">A unique feature of copying questions allows you to copy questions from other courses after searching in existing repository.</li>
									</ul>
								</div>
								
								

								<div class="glidecontent" style="float: left; ">
									<h4 align="center">Manage Students</h4>
									<ul style="font-size: 10pt;list-style-image:url('images/flyarrow.png');">
										<li style="padding:15px 0px 0px 0px;">Upload candidates data through excel file on few clicks.</li>
										<li style="padding:15px 0px 0px 0px;">Block or Unblock students for exams.</li>
										<li style="padding:15px 0px 0px 0px;">Change password for student.</li>
										<li style="padding:15px 0px 0px 0px;">Update the candidate details if mistaken for final results.</li>
									</ul>
								</div>
								 
								<div class="glidecontent" style="float: right; ">
									<h4 align="center">Exams</h4>
									<ul style="font-size: 10pt;list-style-image:url('images/flyarrow.png');">
										<li style="padding:15px 0px 0px 0px;">Schedule an exam.</li>
										<li style="padding:15px 0px 0px 0px;">Search schedule exam details on just selecting a date.</li>
										<li style="padding:15px 0px 0px 0px;">Get the total number of appeared candidates for a particular exam.</li>
									</ul>
								</div>
								
								
								 
								<div class="glidecontent" style="float: right;">
									<h4 align="center">Results</h4>
									<ul style="font-size: 10pt;list-style-image:url('images/flyarrow.png');">
										<li style="padding:15px 0px 0px 0px;">Search results for the conducted exams.</li>
										<li style="padding:15px 0px 0px 0px;">Take a print of results for displaying on notice board or to have a hard copy. </li>
									</ul>
								</div>
								<div class="glidecontent" style="float: right; ">
									<h4 align="center">My Profile</h4>
									<ul style="font-size: 10pt;list-style-image:url('images/flyarrow.png');">
										<li style="padding:10px 0px 0px 0px;">User Id: <%=strUserId%></li>
										<li style="padding:10px 0px 0px 0px;">User Name: <%=strUserName%></li>
										<li style="padding:10px 0px 0px 0px;">User Role: <%if(sActualRoleIdAdmin.equalsIgnoreCase("999")){%>Admin<%}else if(sActualRoleIdAdmin.equalsIgnoreCase("001")||sActualRoleIdAdmin.equalsIgnoreCase("")){%>Examiner<%}%></li>
										<li style="padding:10px 0px 0px 0px;">Email Id: <%=strEMailId%></li>
										<li style="padding:10px 0px 0px 0px;">Contact No.: <%=strMNumber%></li>
										<%if(!sActualRoleIdAdmin.equalsIgnoreCase("999")){%><li style="padding:10px 0px 0px 0px;"><a href="javascript:showModalDiv('modalExamCheckPage');">Change Password</a></li><%}%>
										
										
									</ul>
								</div>
								
								<div class="glidecontent" style="float: right; ">
									<h4 align="center">Welcome Examiner</h4>
									<ul style="font-size: 10pt;list-style-image:url('images/flyarrow.png');">
										<li style="padding:10px 0px 0px 0px;">Links shown on left side represents the tasks to perform.</li>
										<li style="padding:10px 0px 0px 0px;">View details of each task on simply mouse-over the links.</li>
									</ul>
								</div>
								
   					 	</div>
		
					</div><!-- div divContainerProfileLinks ends -->
								<div style="clear:both;"></div>
				
			</div><!-- Div Main Container ends -->
			<%if(!sActualRoleIdAdmin.equalsIgnoreCase("999"))//For Admin no need of changing old password
			{ %>
			<!-- Message Modal div Begins -->
								<div id="modalExamCheckPage" style="top" >
								
								    <div class="modalExamCheckBackground">
								    </div>
								    <div class="modalExamCheckContainer" >
								        	<div class="modalExamCheck" style="width:470px;height:280px;position: relative;top:-150px;left:-20px;">
										            <div class="modalExamCheckTop" style="width:100%;"> 
														<table style="border-collapse: collapse; width: 100%;height:100%" cellpadding="0" cellspacing="0" >
															<tr>
															<td style="padding-left:5px;font:normal 10pt Arial;"  align="left"><b>Change Password</b>
															</td>
															<td style="padding-right:5px; width: 44px;" align="right"><%if(!strPassword.equals(strDefaultPassword)){%><a style="color:#FFFFFF;" href="javascript:hideViewer('modalExamCheckPage');">[X]</a><%}%>
															</td>
															</tr>
														</table>
													</div>
										            
													<div align="center" style="width:100%;height:100%;" id="modalExamCheckContent" class="modalExamCheckBody">
														  <%if(strPassword.equals(strDefaultPassword)){%>
															  <p align="justify" style="width: 450px;padding:5px 0px 0px 0px; ">
															  	*For security reasons please change your password.
															  </p>
															  
														  <%}%>
														  <div id="div_message_operations" style="margin:0px 0px 0px 0px;" ></div>
														  <div id="divPasswordHolder" >
														  	  
														  	  <form id="frmChangePassword" name="frmChangePassword" action="ExaminerHome.jsp" method="post">
																  <table style="height: 118px; width: 467px;">
																  		<tr>
																  			<td rowspan="4" style="height:100px;"><img src="images/changepassword.png"/></td>
																  		</tr>
																 		<tr><td align="left" style="height:35px;"><label class="lblstyle">Old Password : </label></td>
																 			<td style="height:30px;">
																	 			<input type="password" name="txtOldPassword" id="txtOldPassword" style="width: 155px;" maxlength="20"> 
																	 			
																 			</td>
															 			</tr>
																 		<tr><td align="left" style="height:35px;"><label class="lblstyle">New Password : </label></td><td><input type="password" name="txtNewPassword" id="txtNewPassword" style="width: 155px;"  maxlength="20"> </td></tr>
																 		<tr><td align="left" style="height:35px;"><label class="lblstyle">Confirm Password : </label></td><td><input type="password" name="txtConfirmPassword" id="txtConfirmPassword" style="width: 155px;" maxlength="20"> </td></tr>
																  		<tr>
																	  		<td align="center" colspan="3" style="height:30px;">
																		  		<span style="padding-right:5px;"><a href="javascript:updatePassword(document.getElementById('frmChangePassword'));">Update</a></span>
																		  		<span><a href="javascript:resetPasswordFields();">Reset</a></span>
																	  		</td>
																  		</tr>
																  </table>
															  </form>
															  
														  </div>
													</div>
								        	</div>
								    </div>
								</div>
								
						<!-- Message Modal div Ends -->
					<%if(strPassword.equals(strDefaultPassword)){%>	<script>showModalDiv('modalExamCheckPage');</script><%}//end if password check
					
					}//if(sRoleId!="999") for Admin no need to change old passwords
					
					%>
		
		
		
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
		
		
		
			
			<br>
			</div><!-- work area ends -->
	
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
<%}}session.removeAttribute("snselectedDate");%>
</html>