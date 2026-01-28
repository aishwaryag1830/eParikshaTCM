<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" session="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
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
	<title>Admin Home [e-Pariksha] </title>
	<script type="text/javascript">
		javascript:window.history.forward(1);
		
	</script>
	<script type="text/javascript" src="jquery-1.3.1.min.js"></script>
	<link rel="stylesheet" type="text/css" href="Js/modalfiles/modalDiv.css" />
	<script type="text/javascript" src="Js/modalfiles/modalDiv.js"></script>
	<script type="text/javascript" src="Js/Admin.js"></script>	
	<script type="text/javascript" src="Js/AdminMenu/MenuBar.js"></script>	
	<script type="text/javascript" src="validate.js"></script>
	<script></script>
	<style type="text/css">
	.imgSpace
	{
	 	text-align: center;
	 	width:60px;
	}
	.titleLabel
	{
		text-align: left;
		padding-left: 10px;
	}
	.stat
	{
		text-align: right;
	}
	.tileTable
	{
		width: 300px; 
		height: 80px;
		margin: 10px 10px 10px 10px;
	}
	.tblOuter
	{
		border:1px solid #B7B7B7;
		margin: 5px 5px 5px 5px;
	}
	
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
	
	
	
	</head>
	<body onload="MM_swapImage('Image5','','images/index_17_a.gif',1);">
	<%
		
		if(session.getAttribute("UserId")==null || session.getAttribute("UserName")==null || (session.getAttribute("UserId").toString().equals("999")))
		{
			%>
			<jsp:forward page="index.jsp"></jsp:forward>
		<%
		}
		else
		{
			String strUserId	=session.getAttribute("UserId").toString();
			String strUserName	=session.getAttribute("UserName").toString();
			/**
			 * variables for displaying user information
			 * */
			
			 String strRoleName		=null;
			 String strCourseName	=null;
			 String strEMailId		=null;
			 String strMNumber		=null;
			 String strDOB			=null;
			 String strGender		=null;
			 
			 int iUnderConCources 	=	0;
			 int iActiveCources	=	0;
			 int iInActiveCources	=	0;
			 
			 int iTotlaExaminer	=	0;
			 int iFreeExaminer	=	0;
			 int iWithCourceExaminer	=	0;
			 
			 
			 int iUnderConModule	=	0;
			 int iActiveModule	=	0;
			 int iInActiveModule	=	0;
			 
			 int iTodaysSchedule	=	0;
			 int iCondExam	=	0;
			 int iTotalStudetn	=	0;
			 
			 
			 
		
			 /** for Connection */
			DBConnector dbConnector=null;			//Creating object of DBConnector class to make database connection.
			Connection connection=null;
			PreparedStatement statement=null;
			ResultSet result=null;
			String	strQuery	=	null;
			
			/** Making connection*/
			String strDBDriverClass=session.getAttribute("DBDriverClass").toString();
			String strDBConnectionURL=session.getAttribute("DBConnectionURL").toString();
			String strDBDataBaseName=session.getAttribute("DBDataBaseName").toString();
			String strDBUserName=session.getAttribute("DBUserName").toString();
			String strDBUserPass=session.getAttribute("DBUserPass").toString();
			
			
			
			dbConnector=new DBConnector();
			
			connection=dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName, strDBUserName, strDBUserPass);
					
			/** For Cources Block **/
			
			strQuery	=	"SELECT count(course_Id) as Invalid, "+
					"(SELECT count(course_Id) FROM ePariksha_Courses where course_Validtill_Date >= current_date and course_CC_Id !=0  ) as Running, "+
					"(SELECT count(course_Id) FROM ePariksha_Courses where course_Validtill_Date >= current_date and course_CC_Id = 0  ) as  UnderCons "+
					"FROM ePariksha_Courses where course_Validtill_Date < current_date";
			
			statement	=	connection.prepareStatement(strQuery);
			result=statement.executeQuery();
			if(result.next())
			{  
				//RAISE NOTICE 'calling cs_create_job(%)', v_job_id;
				
				iInActiveCources	= result.getInt("Invalid");		// Cources with validuptoDate less Than today's date
				iActiveCources		= result.getInt("Running");		// Cources with validuptoDate greater Than today's date
				iUnderConCources	= result.getInt("UnderCons");   // Cources with validuptoDate greater Than today's date But no CC alloted
			}
			if(statement!=null)
				statement.close();/**closing the statement*/ 
			
			/** For Examiner Block **/
			
			strQuery	=	"SELECT count(user_Id) as total, "+
				"(SELECT count(user_Id) from  ePariksha_User_Master where user_Role_Id = '001' and user_Course_Id != 0) as working,"+
				"(SELECT count(user_Id) from  ePariksha_User_Master where user_Role_Id = '001' and user_Course_Id = 0) as Free from  ePariksha_User_Master where user_Role_Id = '001'";
			
			statement	=	connection.prepareStatement(strQuery);
			result=statement.executeQuery();
			if(result.next())
			{
				iTotlaExaminer	= result.getInt("total");		        // Cources with validuptoDate less Than today's date
				iWithCourceExaminer		= result.getInt("working");		// Cources with validuptoDate greater Than today's date
				iFreeExaminer	= result.getInt("Free");                // Cources with validuptoDate greater Than today's date But no CC alloted
			}
			if(statement!=null)
				statement.close();/**closing the statement*/ 				
				
				
			/** For Module Block **/
			
			strQuery	= "SELECT count(module_Id) as running, "+
				"(SELECT count(module_Id) FROM ePariksha_Modules where module_Course_Id not in (SELECT course_Id FROM ePariksha_Courses where course_Validtill_Date < current_date )) as inactive, "+
				"(SELECT count(module_Id) FROM ePariksha_Modules where module_Course_Id in (SELECT course_Id FROM ePariksha_Courses where course_Validtill_Date >= current_date and course_CC_Id = 0 )) as underCon "+
				"FROM ePariksha_Modules where module_Course_Id not in (SELECT course_Id FROM ePariksha_Courses where course_Validtill_Date >= current_date and course_CC_Id !=0 )";
			
			statement	=	connection.prepareStatement(strQuery);
			result=statement.executeQuery();
			if(result.next())
			{
				iActiveModule	= result.getInt("running");		// Cources with validuptoDate less Than today's date
				iInActiveModule		= result.getInt("inactive");		// Cources with validuptoDate greater Than today's date
				iUnderConModule	= result.getInt("underCon");   // Cources with validuptoDate greater Than today's date But no CC alloted
			}
			if(statement!=null)
				statement.close();/**closing the statement*/ 	
				
			
			/** For Schedule Block **/
			
			strQuery	=	"SELECT count(stud_PRN) as totalId,  "+
				"(SELECT count(exam_Schedule_Id) as done  FROM ePariksha_Exam_Schedule where exam_Date < current_date) as conExam, "+
				"(SELECT count(exam_Schedule_Id) as done  FROM ePariksha_Exam_Schedule where exam_Date = current_date) as todaySch  "+
				"  FROM ePariksha_Student_Login";
			
			statement	=	connection.prepareStatement(strQuery);
			result=statement.executeQuery();
			if(result.next())
			{
				iTotalStudetn	= result.getInt("totalId");		// Cources with validuptoDate less Than today's date
				iCondExam		= result.getInt("conExam");		// Cources with validuptoDate greater Than today's date
				iTodaysSchedule	= result.getInt("todaySch");   // Cources with validuptoDate greater Than today's date But no CC alloted
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
	            
	            <td align="center" valign="middle"><a href="javascript:void(0);" style="cursor:default;"><img src="images/index_17.gif" alt="Home" name="Image5" width="100" height="37" border="0" id="Image5" /></a></td>
	              <td align="center" valign="middle"><a href="AdminUserMan.jsp" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image6','','images/index_18_a.gif',1)"><img src="images/index_18.gif" alt="Users" name="Image6" width="100" height="37" border="0" id="Image6" /></a></td>
	            <td align="center" valign="middle"><a href="Courses.jsp" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image7','','images/index_19_a.gif',1)"><img src="images/index_19.gif" alt="Courses" name="Image7" width="100" height="37" border="0" id="Image7" /></a></td>
	            <td align="center" valign="middle"><a href="ResultsAdmin.jsp" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image8','','images/index_20_a.gif',1)"><img src="images/index_20.gif" alt="Results" name="Image8" width="100" height="37" border="0" id="Image8" /></a></td>
	            <td align="center" valign="middle"><a href="Reports.jsp" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image9','','images/index_21_a.gif',1)"><img src="images/index_21.gif" alt="Reports" name="Image9" width="100" height="37" border="0" id="Image9" /></a></td>
	            <td align="center" valign="middle"><a href="AdminProfile.jsp" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image10','','images/index_22_a.gif',1)"><img src="images/index_22.gif" alt="Profile" name="Image10" width="100" height="37" border="0" id="Image10" /></a></td>
	            
	          </tr>
	        </table>
        </div>
        <!-- Menu Bar ends -->
        
		<div id="workArea" style="height:350px">
		<br/>
		
		<!-- Work area Start -->

						<!-- Available Course Admin modal div starts -->
								<div id="modalAvailableCoursesPage" style="top" >
								
								    <div class="modalAvailableCoursesBackground">
								    </div>
								    <div class="modalAvailableCoursesContainer" >
								        	<div class="modalAvailableCourses" style="width:600px;height:380px;position: relative;top:-150px;left:-90px;">
										            <div class="modalAvailableCoursesTop" style="width:100%;"> 
														<table style="border-collapse: collapse; width: 100%;height:100%" cellpadding="0" cellspacing="0" >
															<tr>
															<td style="padding-left:5px;font:normal 10pt Arial;"  align="left"><b>Available Courses</b>
															</td>
															<td style="padding-right:5px; width: 44px;" align="right"><a style="color:#FFFFFF;" href="javascript:javascript:hideViewer('modalAvailableCoursesPage');">[X]</a>
															</td>
															</tr>
														</table>
													</div>
										            
													<div style="width:100%;height:100%;" id="modalAvailableCoursesContent" class="modalAvailableCoursesBody">
														<form id="frmCourses" action="SwitchRoleManagement" method="post">
																 	<input type="hidden" name="txtCourseId" id="txtCourseId">
																 	<input type="hidden" name="txtExaminerUserId" id="txtExaminerUserId">
																 	<input type="hidden" value="<%=strUserId%>" type="text" name="txtSuperAdminId" id="txtSuperAdminId">
														</form>
											             <div id="divCourses" align="center" style="margin-right:5px;width:590px;height:340px;overflow-y:auto;font:normal 10pt Arial;" >
														 </div><!-- centre admin div ends -->
													</div>
								        	</div>
								    </div>
								</div>
								
						<!-- Available Course Admin modal div Ends -->

			<div id="header_Links" align="left" style="width:800px;margin-top:5px;">
					<div style="float:left;padding-top:5px;padding-left:5px; width: 220px">
						<img style="width:22px;height:22px;" src="images/home.png">
						<label class="pageheader" >Administrator Home</label>
					</div>
					<div align="right" style="float:right; width: 300px;">
						<a href="javascript:void(0);" onclick="javascript:showModalDiv('modalAvailableCoursesPage');ajaxCoursesRetrieval();">
						<img style="width:28px;height:28px;padding-right: 2px" src="images/switchcourse.png">Switch Course</a>
					</div>
					<div style="clear:both;"></div>
				</div>

			<br>
			<div align="left" style="margin:10px 0px 0px 30px; width: 200px"><label class="sideheader">System Status</label></div>

			<table border="0" width="100%">
				<tr>
					<td align="center"> 
					
					<!-- Statistics View start  -->
					
					<table border="0" >

							<tr>
								<td>
									<!-- Courses info start -->
									<div class="tblOuter">
									<table class="tileTable" border="0">
										<tr>
											<td rowspan="3" class="imgSpace" style="" ><img src="images/Course.png" /><br><label>Courses</label> </td>
											<td class="titleLabel">Active Courses</td>
											<td class="stat"><%=iActiveCources %></td>
										</tr>
										<tr>
											<td class="titleLabel">In-Active Courses</td>
											<td class="stat"><%=iInActiveCources %></td>
										</tr>
										<tr>
											<td class="titleLabel">Courses Under Construction</td>
											<td class="stat"><%=iUnderConCources %></td>
										</tr>
									</table>
									</div>
									 <!-- Courses info end --></td>
								<td>
									<!-- Examiner info start -->
									<div class="tblOuter">
									<table class="tileTable" border="0" >
										<tr>
											<td rowspan="3" class="imgSpace"><img src="images/CandidateProfiles.png" /><br><label>Examiner</label></td>
											<td class="titleLabel">Working Examiner</td>
											<td class="stat"><%=iWithCourceExaminer %></td>
										</tr>
										<tr>
											<td class="titleLabel">Free Examiner</td>
											<td class="stat"><%=iFreeExaminer %></td>
										</tr>
										<tr>
											<td class="titleLabel">Total Examiner</td>
											<td class="stat"><%=iTotlaExaminer %></td>
										</tr>
									</table>
									</div>
									<!-- Examiner info end --></td>
							</tr>
							<tr>
								<td style="border:1ps solid gray">
									<!-- Module info start -->
									<div class="tblOuter">
									<table class="tileTable" >
										<tr>
											<td rowspan="3" class="imgSpace"><img src="images/Modules.png" /><br><label>Modules</label></td>
											<td class="titleLabel">Active Modules</td>
											<td class="stat"><%=iActiveModule %></td>
										</tr>
										<tr>
											<td class="titleLabel">In-active Modules</td>
											<td class="stat"><%=iInActiveModule %></td>
										</tr>
										<tr>
											<td class="titleLabel">Modules Under Construction</td>
											<td class="stat"><%=iUnderConModule %></td>
										</tr>
									</table> 
									</div>
									<!-- Module info end --></td>
								<td>
									<!-- Student info start -->
									<div class="tblOuter"> 
									<table class="tileTable" border="0" >
										<tr>
											<td rowspan="3" class="imgSpace"><img src="images/exam.png" /><br><label>Exam</label></td>
											<td class="titleLabel">Today's Schedule</td>
											<td class="stat"><%=iTodaysSchedule %></td>
										</tr>
										<tr>
											<td class="titleLabel">Exam Conducted</td>
											<td class="stat"><%=iCondExam %></td>
										</tr>
										<tr>
											<td class="titleLabel">Total Student</td>
											<td class="stat"><%=iTotalStudetn %></td>
										</tr>
									</table> 
									</div><!-- Student info end --></td>
							</tr>

						</table> <!-- Statistics View end  -->
					</td>
				</tr>
				<tr>
					<td> </td>
				</tr>
			</table>


			<!--  Work area End -->
		</div>
	
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
session.removeAttribute("ExamDate");
%>
</html>