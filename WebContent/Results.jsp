<%@page import="com.Reports.Excel.Result"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" session="false"%>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
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
<!--
	@author Sherin Mathew
	@date 24-05-2012  
	This is the home page of Admin -->
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<link rel="stylesheet" href="Css/style.css" type="text/css">
	<title>ResultPage [ePariksha]</title>
	<link rel="shortcut icon" href="images/favicon.ico" >
   	<link rel="icon" type="image/gif" href="images/animated_favicon1.gif" >
   	<link rel="apple-touch-icon" href="images/apple-touch-icon.png" >
	<script type="text/javascript">
		javascript:window.history.forward(1);
	</script>
	<script type="text/javascript" src="jquery-1.3.1.min.js"></script>
	<link rel="stylesheet" type="text/css" href="cc_slidemenu.css" />
	<script type="text/javascript" src="Js/modalfiles/modalDiv.js"></script>
	<script type="text/javascript" src="Js/Results.js"></script>
	<script type="text/javascript" src="cc_slidemenu.js"></script>
	<script type="text/javascript" src="validate.js"></script>
	<link rel="stylesheet" href="Js/modalfiles/modalDiv.css" type="text/css">
	<link rel="stylesheet" type="text/css" href="Js/ContentSlider/contentslider.css" />
	<script type="text/javascript" src="Js/ContentSlider/contentglider.js">
	/***********************************************
	* Featured Content Glider script- (c) Dynamic Drive DHTML code library (www.dynamicdrive.com)
	* Visit http://www.dynamicDrive.com for hundreds of DHTML scripts
	* This notice must stay intact for legal use
	***********************************************/
	
	</script>
	<script type="text/javascript">
			function printPage()													//This Function will Display the page as it is viewed in print preview mode
			{
				
				document.getElementById("body_main_banner").style.display="none";
				document.getElementById("printRow").style.display="none";
				document.getElementById("print_Banner").style.display="block";
				document.getElementById("header_msg").style.display="none";
				document.getElementById("cancelRow").style.display="block";
				document.getElementById("divSeparator").style.display="none";
				document.getElementById("header_Links").style.display="none";
				if(document.getElementById("paggingRow"))
					document.getElementById("paggingRow").style.display="none";
				document.getElementById("divTableHolder").style.display="none";
				document.getElementById("divPrintBack").style.display="block";
				
			}
			
			function closePrintPreview(iPageNo){
				
				var frm=document.frmResult;
				var iPageSize=parseInt(frm.txtPageSize.value);
				var iTemp=parseInt(iPageNo)*iPageSize;
				frm.txtPageStart.value=iTemp;
				frm.txtPageEnd.value=iTemp+iPageSize;
				frm.txtPageId.value=parseInt(iPageNo)+1;
				document.getElementById("body_main_banner").style.display="block";
				
				document.getElementById("printRow").style.display="block";
				document.getElementById("print_Banner").style.display="none";
				document.getElementById("header_msg").style.display="block";
				document.getElementById("divSeparator").style.display="block";
				document.getElementById("cancelRow").style.display="none";
				document.getElementById("header_Links").style.display="block";
				if(document.getElementById("paggingRow"))
					document.getElementById("paggingRow").style.display="block";
				document.getElementById("divTableHolder").style.display="block";
				document.getElementById("divPrintBack").style.display="none";
			}
		</script>
		<script type="text/javascript">
			function getNextPage(iPageNo)				//This Function will help user to browse to the different page number as it is displayed on the page
			{	
				var frm=document.frmResult;
				var iPageSize=parseInt(frm.txtPageSize.value);
				var iTemp=parseInt(iPageNo)*iPageSize;
				frm.txtPageStart.value=iTemp;
				frm.txtPageEnd.value=iTemp+iPageSize;
				frm.txtPageId.value=parseInt(iPageNo)+1;
				frm.action="Results.jsp";
				frm.method="post";
				frm.submit();
			}
		</script>
	
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
			String strUserId	=	session.getAttribute("UserId").toString();
			String strUserName	=	session.getAttribute("UserName").toString();
			String sCourseId	=	session.getAttribute("CourseId").toString();
	
			String sRoleId		=	session.getAttribute("UserRoleId").toString();
			

			
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
			 String strMNumber		=null;
			 long lMNumber = 0l;
			 String strPassword		=null ,sActualRoleIdAdmin="";
			 String strDefaultPassword		=	"cdac123";


		
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
			String strModuleId		=	null;
			String strModuleName	=	null;
			String strExamDate		=	null;	
			String sExaminerId	=null;
			String sActualAdminRoleId="";
			/*To update the password if pasword is changed
			 Update password must be done before fetching values by procedure 
			*/	
			try{
				
				
				/*Fetching examiner id for gathering course related information*/
			if(session.getAttribute("sActualExaminerId")!=null)
			{
				sExaminerId	=	session.getAttribute("sActualExaminerId").toString();
			}
			else//if examiner logins ie no switch course then
			{
				sExaminerId	=	strUserId;
			}
				
			if(session.getAttribute("ActualAdminRoleId")!=null)
			{
				sActualAdminRoleId	=	session.getAttribute("ActualAdminRoleId").toString();
			}
				
				if(request.getParameter("txtOldPassword")!=null)//if password is getting changed txtoldpassword will not be a null value
				{
				
				
					String sNewPassword	=	request.getParameter("txtNewPassword");
					PreparedStatement pstmt=null;
					
					String strQuery="update ePariksha_User_Master set user_Password=TRIM(?) where user_Id=?";
					
					
					pstmt=connection.prepareStatement(strQuery);
					pstmt.setString(1,sNewPassword);
					pstmt.setLong(2, Long.parseLong(strUserId));
					
					
					if(pstmt.executeUpdate()==1)
					 System.out.println("updated");
					
					
				}
			}catch(Exception e){}
				
			
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
			
			try{
				
				cstmtGetDetails.execute();
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
					<li style="padding-top:5px;color:#1C89FF"><%=strUserName%></li>
					<li><a href="ExaminerHome.jsp"><img src="images/home.png" alt="Home" title="Home" width="24" height="22" border="0" /></a></li>
					<li><a href="index.jsp"><img src="images/logout.png" alt="Logout" title="Logout" width="24" height="22" border="0" /></a></li>
	            </ul>
            </td>
       </table><!-- div left banner -->
    </div><!-- div Top container --><!-- End of Top Area div-->
    
    
   	<div style="width:800px"><!-- Div Banner Area begins-->
        <div  align="left" style="background-color:#A70505">&nbsp;</div>
        <div  style="border-left:#CBCBCB 1px solid;width:800px;"> <!-- Div inner banner holder -->
	          <img src="images/topbanner.gif" width=800px; height=150px;></img>
         </div><!-- Div inner banner holder -->
       </div><!-- Div Banner Area ends-->
       
       <div id="bannerFooter"> <!--Div bannerFooter begins-->
       	<img src="images/belowbanner.png" width=800px; height=25px;/>
     </div> <!--Div bannerFooter ends-->
     </div><!-- end of body_main_banner -->
     
     <!-- -------------------- -->
     
     
     <!-- ----------------------- -->
     
     
     <!--------------------------------------------------------new code------------------------------------------------------------------>	
 		
 		<div id="workArea" ><!-- Workarea div begins -->
	<br/>
	<%
				/** Making connection*/
						
			dbConnector					=	new DBConnector();
			connection					=	dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName, strDBUserName, strDBUserPass);
			/**************************************new code************************************************************/
			connection					=	dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName, strDBUserName, strDBUserPass);
			
			statement					=	connection.prepareStatement("select distinct result_Module_Id,module_Name from ePariksha_Results,ePariksha_Modules"+
											",ePariksha_Courses	where ePariksha_Results.result_Module_Id=ePariksha_Modules.module_Id"+
											" and ePariksha_Modules.module_Course_Id=ePariksha_Courses.course_Id and course_CC_Id=?",ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
			statement.setInt(1, Integer.parseInt(sExaminerId));
			result						=	statement.executeQuery();
			
			/***************************************end of new code*******************************************************************/			
			/*statement					=	connection.prepareStatement("select distinct result_Module_Id,module_Name from ePariksha_Results,ePariksha_Modules"+
											",ePariksha_Courses	where ePariksha_Results.result_Module_Id=ePariksha_Modules.module_Id"+
											" and ePariksha_Modules.module_Course_Id=ePariksha_Courses.course_Id and course_CC_Id=RTRIM(?)",ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
			statement.setString(1,sExaminerId.trim());
			result						=	statement.executeQuery();*/ 
			
			
		 %>
	<div style="padding-top:5px;padding-left:5px; width: 220px" id="header_Links">
		<img style="width:22px;height:22px;" src="images/Results.png">
		<label class="pageheader" >Results</label>
	</div>
	
	<div id="divTableHolder" style="height: 80px; width: 660px;margin-left:50px; border-color: #9df;">
	
	
	<br>
		<form name="frmResultMenu" action="Results" method="post">
								
						<table class="tblstyle"  align="left"  style="width: 660px;height:40px; margin-left: 0px;margin-top: 15px;">
						
							<tr>
								<td class="tdblue"  style="margin-left: 10px;"> <label class="lblstyle" style="padding-right: 5px;">Modules</label> 
								<select id="selectModule" name="selectModule" onchange="goSelectModule(this.value,'<%=sRoleId%>');" style="width: 160px;">
										<option value="0" selected="selected">--Select Module--</option>
										<jsp:scriptlet>
										//This While Loop will fetch the data in the Select Module Select Control on the page
											while(result.next())
											{
												strModuleId=result.getString("result_Module_Id");
												strModuleName=result.getString("module_Name");
												String strShortModuleName=null;													
												if(strModuleName.length()>20)
													strShortModuleName=strModuleName.substring(0,20)+"...";
												else
													strShortModuleName=strModuleName;
										 </jsp:scriptlet>
										<option value="<%=strModuleId.trim()%>" title="<%=strModuleName%>"><jsp:expression>strShortModuleName</jsp:expression></option>
									<jsp:scriptlet>}</jsp:scriptlet>
								</select></td>
								
								<td class="tdlightblue" style="margin-right: 10px;">
									<label class="lblstyle" style="padding-right: 5px;">Exam Dates(dd-mm-yyyy)</label>
									<select name="selectExamDate" id="selectExamDate" style="width: 160px;" onchange=" document.frmResultMenu.submit();">
										<option value="0">--Select Exam Date--</option>
											<%!Map<Integer,String> mapmodulelist=null;
												ArrayList<String> arrdate=null;
											 %>
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
					<div style="width: 500px;"><img alt="" src="images/separator.gif" width="1px"></div>
					<input type="hidden" name="txtModuleName"  id="txtModuleName"><!-- This Hidden Field is used  the fetch the selected module nameso as to be used on the Page  -->
					<input type="hidden" name="txtExamDateId"  id="txtExamDateId" value="">
				
				</form>
		
	</div>
	<div style="padding-top: 20px;" id="divSeparator">
		<img width="100%;" height="1px" src="images/separator.gif"/>
	</div>
	
	
	
	<% 
		
				final int iPageSize	=	35;	//The variable which allows minimum of 35 records on the page at a time
				int iResultCount	=	0;
				int iStart			=	0;
				int iEnd			=	0;
				int iPageId			=	0;
				
				
				strCourseName	=	null;
				String strCentreCName	=	null;	
				String strSelectedDate	=	null;
				String strModuleInWords	=	null;

				if(request.getParameter("selectExamDate")!=	null){
					strSelectedDate	=	request.getParameter("selectExamDate");
					session.setAttribute("snselectedDate",strSelectedDate);
				}
				else 	if(session.getAttribute("snselectedDate")!=null)
					strSelectedDate	=	session.getAttribute("snselectedDate").toString();
				
				if(strSelectedDate!=	null){
				
					if(request.getParameter("selectModule")!=	null)
						strModuleId	=	request.getParameter("selectModule");
					else if(session.getAttribute("ModuleId")!=	null)
						strModuleId	=	session.getAttribute("ModuleId").toString();
						
						
					
					if(request.getParameter("selectExamDate")!=	null){
						strExamDate	=	request.getParameter("selectExamDate");
									
					}	
					else if(session.getAttribute("snselectedDate")!=null)
						strExamDate	=	session.getAttribute("snselectedDate").toString();
					
					
					
					if(request.getParameter("selectModule")!=	null)
						strModuleName	=	request.getParameter("selectModule");
					else if(session.getAttribute("ModuleName")!=	null)
						strModuleName	=	session.getAttribute("ModuleName").toString();
						session.setAttribute("ModuleId",strModuleId);
						//session.setAttribute("ExamDate",strExamDate);
						session.setAttribute("ModuleName",strModuleName);
						
						if(request.getParameter("txtModuleName")	!=	null){
						strModuleInWords	=	request.getParameter("txtModuleName").toString();
						session.setAttribute("strModuleInWords",strModuleInWords);
						}
						else if(session.getAttribute("strModuleInWords")	!=	null)
						strModuleInWords	=	session.getAttribute("strModuleInWords").toString();
							
			
			
			if(request.getParameter("txtPageStart")!=	null)
				iStart	=	Integer.parseInt(request.getParameter("txtPageStart"));
			else
				iStart	=	0;
			if(request.getParameter("txtPageEnd")!=	null)
				iEnd	=	Integer.parseInt(request.getParameter("txtPageEnd"));
			else
				iEnd	=	iPageSize;
			if(request.getParameter("txtPageId")!=	null)
				iPageId	=	Integer.parseInt(request.getParameter("txtPageId"));
			else
				iPageId	=	1;
				
			}
	
	%>
	
	 
	
	
	
	<div id="divInitialMessage" style="height: 300px;padding-top: 200px;padding-left:300px" class="message_directions">
	</div>
	

			
	<div id="divResultDisplay" style="clear: both;" ><!-- Result div -->
	<%
	
		if(request.getParameter("txtPageStart")!=null)
		iStart=Integer.parseInt(request.getParameter("txtPageStart"));
		
		if(request.getParameter("txtPageEnd")!=null)
		iEnd=Integer.parseInt(request.getParameter("txtPageEnd"));
		
		if(request.getParameter("txtPageId")!=null)
		iPageId=Integer.parseInt(request.getParameter("txtPageId"));
		
		int passingMarks=0;
		
		if(strExamDate!=	null){ 
	%>
		<script type="text/javascript">document.getElementById('divInitialMessage').style.display='none';</script>
	<%	/*To fetch short details of the course begins*/
						statement	=	connection.prepareStatement("select course_Short_Name ,user_F_Name,user_M_Name,user_L_Name"+
										 " from ePariksha_Courses,ePariksha_User_Master where "+
										 "ePariksha_Courses.course_Centre_Coordinator=ePariksha_User_Master.user_Id"+
										 " and course_Id=?",ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
						statement.setInt(1, Integer.parseInt(sCourseId));
						result	=	statement.executeQuery();
					if(result.next())
					{
						strCourseName	=	result.getString("course_Short_Name");
						strCentreCName	=	result.getString("user_F_Name");
						if(result.getString("user_M_Name")!=	null)
							strCentreCName	=	strCentreCName+" "+result.getString("user_M_Name");
						if(result.getString("user_L_Name")!=	null)
							strCentreCName	=	strCentreCName+" "+result.getString("user_L_Name");
					}
						session.setAttribute("snCourseName",strCourseName);
					
					if(result	!=	null)
						result.close();/**closing the result*/ 
						
					if(statement	!=	null)
						statement.close();/**closing the statement*/ 
						
					/*Below is the code to fetch minimum marks to be passed*/	
					statement = connection.prepareStatement("select exam_Min_Passing_Marks from ePariksha_Exam_Schedule where exam_Course_Id=? and exam_Module_Id=? and to_char(exam_Date, 'DD-MM-YYYY')=TRIM(?)",ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
					statement.setInt(1, Integer.parseInt(sCourseId));
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
			
				statement	=	connection.prepareStatement("select distinct result_Stud_PRN,result_Marks,result_Percentage,stud_F_Name,"+
								"stud_M_Name,stud_L_Name from ePariksha_Results,ePariksha_Student_Login where "+
								"result_Course_Id=? and result_Module_Id=? and ePariksha_Student_Login.stud_Course_Id="+
								"ePariksha_Results.result_Course_Id	and ePariksha_Student_Login.stud_PRN="+
								"ePariksha_Results.result_Stud_PRN	and to_char(result_Exam_Date, 'DD-MM-YYYY') like"+ 
								" to_char(?::date, 'DD-MM-YYYY') order by result_Stud_PRN",ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
				statement.setInt(1, Integer.parseInt(sCourseId));
				statement.setLong(2, Long.parseLong(strModuleId));
				statement.setString(3, strExamDate);
				result	=	statement.executeQuery();
				boolean t	=	result.last();
				
				iResultCount	=	result.getRow();
				List<Result> list=new ArrayList<Result>();
				Result resultobj=new Result();
				int sNo	=	iStart;
				String strResultRemark="";
				result.beforeFirst();
				/**************************************************************************************************************/
				while(result.next()){
					sNo++;
					String 	strStudentPRN		=	null;
					String 	strStudentName		=	null;
					int		iStudentMarks		=	0;
					float  	fStudentPercentage	=	0;
					strStudentPRN	=	result.getString("result_Stud_PRN");
					iStudentMarks	=	result.getInt("result_Marks");
					fStudentPercentage=	result.getFloat("result_Percentage");
					
					strStudentName	=	result.getString("stud_F_Name");
					if(result.getString("stud_M_Name")!=null)
						strStudentName	=	strStudentName+" "+result.getString("stud_M_Name");
					if(result.getString("stud_L_Name")!=null)
						strStudentName	=	strStudentName+" "+result.getString("stud_L_Name");
					
					if(iStudentMarks>=passingMarks)
						strResultRemark	=	"Pass";
					else
						strResultRemark	=	"Fail";
	
	
	
					resultobj=new Result(sNo,strStudentPRN.toString(),strStudentName,iStudentMarks,fStudentPercentage,strResultRemark);
					list.add(resultobj);
								
				}
				
				session.setAttribute("resultlist",list);
				
					
				/*To fetch result  ends*/
		%>
		
		<%if(iResultCount	!=	0)								// to check for new message
		{%>
	
					<div align="center" id="header_msg" style="margin-top: 10px;margin-left: 50px;margin-right: 90px;">
						<b><font  size="5"><%=strCourseName%> Results</font></b>
							<%		/* String strModuleInWords	=	null;
									if(request.getParameter("txtModuleName")	!=	null){
									strModuleInWords	=	request.getParameter("txtModuleName").toString();
									session.setAttribute("strModuleInWords",strModuleInWords);
									}
									else if(session.getAttribute("strModuleInWords")	!=	null)
									strModuleInWords	=	session.getAttribute("strModuleInWords").toString(); */
							
										
						 %>
							 <br/>
						 
						 <div style="width:300px;margin-top: 10px;;"><label class="lblstyle" style="font-size: 15px;margin-top:20px">Subject:	</label>
							 <label class="lblstyle" style="padding-left: 2px;"><%=strModuleInWords%></label><br/></div>
						 <div style=" margin-top: 10px;margin-bottom: 10px;"><b><label class="lblstyle" style="font-size: 15px;">Exam Date:	</label></b>
						 	<label class="lblstyle" style="padding-left: 2px;"><%=strExamDate%></label></div>	
					</div>
					<div id="divSeparator" style="padding-top: 10px;padding-bottom: 10px;'">
						
					</div>
						
								
								<table  height="100%" width="100%" >
									<tr style="display: none;width: 100%;" id="print_Banner" align="center">
									
										<td>
											<div>
												<font style="font-size: 27px;"><b><%=strCourseName%> Results</b></font><br/>
												<div style="padding-top: 10px;"><b>Subject:	<%=strModuleInWords%></b></div>
												<div style="padding-top: 10px;"><b>Exam Date:	<%=strExamDate%></b></div>
											</div>
										</td>
										
									</tr>
									<tr id="cancelRow" style="display: none;">
										<td colspan="3">
										
										</td>
									
									</tr>
									<tr>
							<td colspan="3" valign="top">
								<table  cellspacing="0" id="tblResult"  class="tblstyle" style="width: 660px;margin-left: 50px;" >
									<tr id="tblheader">
										<th style="border-left: 2px;border-left-color: black;height: 20px;" class="simple_row">S.No.</th>
										<th class="simple_row" style="height: 20px;" >PRN No.</th>
										<th class="simple_row" style="height: 20px;">User Name</th>
										<th class="simple_row" style="height: 20px;">Marks</th>
										<th class="simple_row" style="height: 20px;">Percentage</th>
										<th class="simple_row" style="height: 20px;">Result</th>
									</tr>
								<%
												
									sNo	=	iStart;
									result.first();
									for(int iTempItr=0;iTempItr<iEnd;iTempItr++)				
									{
										
										if(iTempItr>=iStart)
										{
											sNo++;
											String 	strStudentPRN		=	null;
											String 	strStudentName		=	null;
											int		iStudentMarks		=	0;
											float  	fStudentPercentage	=	0;
											strStudentPRN	=	result.getString("result_Stud_PRN");
											iStudentMarks	=	result.getInt("result_Marks");
											fStudentPercentage=	result.getFloat("result_Percentage");
											
											strStudentName	=	result.getString("stud_F_Name");
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
											<td align="center" width="" style="width: 10px;height: 20px; "><%=sNo%></td>
											<td align="center" style="width: 30px;height: 20px; "><%=strStudentPRN%></td>
											<td align="left" style="width: 200px;height: 20px;padding-left: 10px; "><%=strStudentName%></td>
											<td align="center" style="width: 10px;height: 20px; "><%=iStudentMarks%></td>
											<td align="center" style="width: 2px;height: 20px; "><%=fStudentPercentage%></td>
											<td align="center" style="width: 10px;height: 20px; "><%=strResultRemark%></td>
										</tr>
									<%		
											
											}
											
											if(iTempItr==iResultCount-1)
												break;
											result.next();
										}//end for
										int iPassStudents	=	0;
										
										if(result!=null)
											result.close();/**closing the result*/ 
										
										if(statement!=null)
											statement.close();/**closing the statement*/ 
										
										
										if(iResultCount==sNo)
										{
											
											
											statement	=	connection.prepareStatement("select count(distinct result_Stud_PRN)	from ePariksha_Results "+
															"where to_char(result_Exam_Date, 'DD-MM-YYYY') like"+ 
															" to_char(?::date, 'DD-MM-YYYY') and result_Module_Id=?"+
															" and result_Course_Id=?	and result_Marks>=?");
												statement.setString(1, strExamDate);
												statement.setLong(2, Long.parseLong(strModuleId));
												statement.setInt(3, Integer.parseInt(sCourseId));
												statement.setFloat(4, passingMarks);
												result=statement.executeQuery();
												if(result.next())
												{
													iPassStudents	=	result.getInt(1);
													
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
							<% 					
								/*******************************Code Position***************************************************/
											
										
								
															
																		
							
						
							
							/*------------------------------------------------------------------------------------*/
								
								%>
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
								if(dbConnector	!=	null)
								{
									dbConnector.closeConnection(connection);
									dbConnector	=	null;
									connection	=	null;
								}
								
									session.setAttribute("passstudcount", iPassStudents);
								%>	
										
								</table>
								<%if(iResultCount==sNo){%>
								<!--  Export to excel feature -->
								<div id="divHrefResultExcelExport" style="padding-left: 350px;padding-top:20px">
									<a href="ResultExcelExport"><!--Export to Excel--></a>
								</div>
								
								<%}%>
								
								</td>
										
						<tr>
							<td colspan="3" style="padding-left: 50px;">
								
								<%if(!sActualAdminRoleId.equals("999")){%>
								<div style="float: left;margin-top: 80px;font: 10pt Arial;"><%=strUserName%><br> Examiner </div><%}%>
								<div style="float: right;margin-top: 80px;font: 10pt Arial;margin-right: 80px;"><%=strCentreCName%><br> Administrator </div>
							</td>
						</tr>
						<tr>
							<td colspan="3"><form name="frmResult" method="post" action="">
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
								iPageCount=iResultCount/iPageSize;
								iRemender=iResultCount%iPageSize;
								if(iRemender!=0)
									iPageCount=iPageCount+1;
								String strPageLink=null;
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
							<a href="javascript:window.print();" style="height:10px;font: 10pt Arial"><img src="images/control_printer.png" style="border-style: none; height: 15px; width: 19px;"> Print</a>
							<a href="javascript:void(0);" style="height:10px;font: 10pt Arial" onclick="closePrintPreview(document.frmResult.txtPageNo.value);" >Back</a>
						</div>
						<div id="printRow">
							
							<img src="images/printPreview.png" style="height: 21px; width: 18px; "></img>
							<a href="javascript:void(0);" onclick="printPage();" style="font: Arial">Print Preview</a>
						
						</div>
					</center>
					<div id="divForClear" style="clear: both;"></div>
					
					
		<%}else{//If resultcount is not zero ends ie no results present%>
		
		<div id="divServerMessages" style="height: 300px;padding-top: 200px;padding-left:300px" class="message_directions">
			No records found
		
		</div>
		<%} %>
		
		
		
	</div><!-- div resultdisplay ends -->
	
	<script>
			//var CourseObject=document.getElementById('selectCourse');
			var ModuleObject=document.getElementById('selectModule');
			var ExamDateObject=document.getElementById('selectExamDate');
			
			
			for ( var j = 0; j < ModuleObject.length; j++) {
					if(ModuleObject.options[j].value==<%=session.getAttribute("adddattesajaxsnmoduleid")%>){
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
		
		
	<%}else{//end if of checking date %>
	
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
	 	
	 	
			if(strValidExamDate==null)
			{
	 		%>
				 <script type="text/javascript">
				 	document.getElementById('divInitialMessage').innerHTML	=	'Please select module';
				 	document.getElementById('divInitialMessage').visbility	=	'visible';
				 </script>
	 		<%}
			 else if(strModuleIdServlet!=null && strValidExamDate!=null) {
			  %>
			  <script type="text/javascript">
			  	 	
			  		document.getElementById('divInitialMessage').style.display	=	'none';
			  </script>
			  <%}//session.removeAttribute("ExamDate"); %>
	
	</div><!-- workarea div ends -->
 		
 		
 	<!-------------------------------------------------------end of the new code---------------------------------------------------->
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
	<script>
		document.getElementById('txtModuleName').value=document.getElementById('selectModule').options[document.getElementById('selectModule').selectedIndex].title;
		/*Below code will make sure that if the module is not selected then examdate dop down should not contain any values inside them*/
		
		/*Below line of code wil make sure that if the date is not selected it will dispaly the appropriate message to the user*/
		
	</script>
	</body>
<%}}%>
</html>