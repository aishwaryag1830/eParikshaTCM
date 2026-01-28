<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" session="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.*" %>
<%@ page import="in.cdac.acts.connection.DBConnector" %>
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
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
		<link rel="stylesheet" href="Css/style.css" type="text/css"/>
		<script type="text/javascript" src="Js/AdminMenu/MenuBar.js"></script>
		<script type="text/javascript">javascript:window.history.forward(1);</script>
		<title>Courses [ePariksha] </title>
		<link rel="stylesheet" type="text/css" media="all" href="jsDatePick_ltr.min.css" />
		<script type="text/javascript" src="jsDatePick.min.1.3.js"></script>
		<script type="text/javascript" src="Js/Courses.js"></script>
		<script type="text/javascript" src="Js/modalfiles/modalDiv.js"></script>
		<link rel="stylesheet" href="Js/modalfiles/modalDiv.css" type="text/css" />
		<link href="CSS/calender.css" rel="stylesheet" type="text/css" />
	</head>
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
			String strUserId	=	session.getAttribute("UserId").toString();
			String strUserName	=	session.getAttribute("UserName").toString();	
			
			if (session.getAttribute("CourseId") != null) {
				sCourseId	=	session.getAttribute("CourseId").toString();
			}
			
			String sRoleId	=	session.getAttribute("UserRoleId").toString();

			/**
				If trying to come to this page from other user redirect it to index page
			*/
			
			if(!sRoleId.equals("999"))//If trying to come to this page from other user redirect it to index page
			 {%><jsp:forward page="index.jsp"></jsp:forward><%}
			 /**
				  * strForID ,iScrollPosX, iScrollPosY used for maintaining the position of scroll after selection of course
				  *
				*/
					String strForID =null;
					String iScrollPosX =null;
					String iScrollPosY =null;
					if(request.getParameter("hidCourse")!=null)
					{
						strForID = request.getParameter("hidCourse").toString();
						iScrollPosX	= request.getParameter("hidScrollPositionX");
						iScrollPosY = request.getParameter("hidScrollPositionY");	
					}
				%>
	<body onload="ChangeColor(<%=strForID%>,<%=iScrollPosX%>,<%=iScrollPosY%>);MM_swapImage('Image7','','images/index_19_a.gif',1)">
	<div id="mainBody"  align="center" >
    <div id="topArea"><!-- div Top container -->
      <table width="800px" cellspacing="0" cellpadding="0"><!-- div left banner -->
          <tr>
            <td width="30%" align="left" valign="top" style="padding-top:3px; padding-left:5px; padding-bottom:0px;">
	            <a href="http://acts.cdac.in"><img src="images/cdac-acts_inner.png" alt="" width="120" height="30" border="0" /></a>
            </td>
            <td width="70%" align="right" valign="top" style="padding-top:10px;">
	            <ul>
	            	<li><img alt="Active User" title="Active User" src="images/Profile.png" style="width:24px;height:22px;"/></li>
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
	            <td align="center" valign="middle"><a href="javascript:void(0);" style="cursor:default;"><img src="images/index_19.gif" alt="Courses" name="Image7" width="100" height="37" border="0" id="Image7" /></a></td>
	            <td align="center" valign="middle"><a href="ResultsAdmin.jsp" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image8','','images/index_20_a.gif',1)"><img src="images/index_20.gif" alt="Results" name="Image8" width="100" height="37" border="0" id="Image8" /></a></td>
	            <td align="center" valign="middle"><a href="Reports.jsp" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image9','','images/index_21_a.gif',1)"><img src="images/index_21.gif" alt="Reports" name="Image9" width="100" height="37" border="0" id="Image9" /></a></td>
	            <td align="center" valign="middle"><a href="AdminProfile.jsp" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image10','','images/index_22_a.gif',1)"><img src="images/index_22.gif" alt="Profile" name="Image10" width="100" height="37" border="0" id="Image10" /></a></td>
	            
	          </tr>
	        </table>
        </div>
        <!-- Menu Bar ends -->
        
      
      <div id="workArea"><!-- work area begins -->
      	<br/>
		<div style="float:left;padding-top:5px;padding-left:5px;width: 220px; vertical-align: bottom;">
					<img src="images/Course.png" style="vertical-align: bottom;height: 25px; width: 30px;"></img>
					<label class="pageheader" >Courses</label>
		</div>
		<div style="clear:both"></div>
		 <br/>
				<div id="HeaderCourse" style="height:12px;"><label id="lblDisplay" style="padding-top:0px;color:red;font-size:12px;font-weight:normal"></label></div>
				<div id="divContainer" style="height:400px;">
					<div id="divCourses" >
						<div class="courseHeader">
							<div style="float:left;font-weight:bold;font-size:12px;padding-left:3px">Courses</div>
							<div id="test" onclick="showAddCourse()"><span style="margin-top:4px;padding-bottom:0px"><img src="images/add.png" style="width:14px;height:14px;"/></span><span>Add&nbsp;</span></div>
							<div style="clear:both"></div>
						</div>
						
						<form id="frmShowCourseModule" action="Courses.jsp" method="post">
							<input type="hidden" name="hidCourse" id="hidCourse"></input>
							
							<div id="divCourseList" style="">
						 <%
							int iCourseExpire = 0;
							int iCount = 0;
							
							//this course id,strCourses, give the id of selected course used for further operation
							
							int iCourseId     =0;					   // for selected Course ID
							String strCourses = "";                // for selected Course name
							String strCoursesShortName = "";  	   // for selected Course Short name
							String strCoursesDate = "";			   // for selected Course valid till Date
							int courseId = 0;
							int checkNoCourse = 0;                 //checking for, if no course is 0 means not any course is created
							
							/** for Connection */
							
							DBConnector dbConnector=null;			//Creating object of DBConnector class to make database connection.
							Connection conn1=null;
							PreparedStatement pst = null;
							ResultSet rst = null;
							
							/** Making connection*/
							
							String strDBDriverClass  =session.getAttribute("DBDriverClass").toString();
							String strDBConnectionURL=session.getAttribute("DBConnectionURL").toString();
							String strDBDataBaseName =session.getAttribute("DBDataBaseName").toString();
							String strDBUserName     =session.getAttribute("DBUserName").toString();
							String strDBUserPass     =session.getAttribute("DBUserPass").toString();
							
							try{
								dbConnector=new DBConnector();
								
								/** connection established */
								conn1=dbConnector.getConnection(strDBDriverClass, strDBConnectionURL, strDBDataBaseName, strDBUserName, strDBUserPass);
							  
								/**
								 * to get the list of Course Id,Course Short IDs and Course names on left menu
								 **/
								
								pst = conn1.prepareStatement("select course_Id, course_Name, course_Short_Name from ePariksha_Courses",ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
								rst = pst.executeQuery();	
								if(rst.first()){
									checkNoCourse = 1;
									rst.beforeFirst();
								}
								while(rst.next()){ 
								iCount++;
								courseId = rst.getInt("course_Id");%>
							
							<!-- Creating a div for each courses -->
							
							<div class="CourseData" title="<%=rst.getString("course_Name")%>" id="<%=courseId%>" onclick="ShowCourseData(this.id)" <%if(iCount>17){%>style="width:118px;padding-left:2px;"<%}else{%>style="width:131;padding-left:2px;"<%}%>><%=rst.getString("course_Short_Name")%></div>
						 <%}
								rst.close();
								pst.close();
								
						%><div id="divNoCourse" <%if(checkNoCourse == 0){%>style="font-size: 16px;display:inline;color:#B27C7C;"<%}else{%>style="display:none"<%}%>><br/><br/><br/><br/><br/><br/><br/>&nbsp;No Course found</div>
						<%								
								if(request.getParameter("hidCourse")!= null){             //if start
									
									iCourseId = Integer.parseInt(request.getParameter("hidCourse").toString());
								
									pst = conn1.prepareStatement("select course_Name, course_Short_Name, to_char(course_Validtill_Date, 'DD-MM-YYYY') as course_validtill_Date from ePariksha_Courses where course_Id = ?",ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
									pst.setInt(1, Integer.parseInt(request.getParameter("hidCourse").toString()));
									rst = pst.executeQuery();
									
									while(rst.next())
									{
										strCourses = rst.getString("course_Name");
										strCoursesShortName = rst.getString("course_Short_Name");
										strCoursesDate = rst.getString("course_validtill_Date");
									}
									rst.close();
									pst.close();
										
									pst = conn1.prepareStatement("select course_Name from ePariksha_Courses where course_Id = ? and course_Validtill_Date < now()",ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
									pst.setInt(1,iCourseId);
									rst = pst.executeQuery(); 
									if(rst.first())
									{
										iCourseExpire = 1;
									}
									rst.close();
									pst.close();
							 %>		
								
								<!-- these hidden field used for selected course   -->	
									
									<input type="hidden" name="hidCourseName" id="hidCourseName" value="<%=strCourses%>" ></input>
									<input type="hidden" name="hidCourseShortName" id="hidCourseShortName" value="<%=strCoursesShortName%>"></input>
									<input type="hidden" name="hidCourseValidTill" id="hidCourseValidTill" value="<%=strCoursesDate%>"></input>
									<input type="hidden" id="hidScrollPositionX" name="hidScrollPositionX"/>
									<input type="hidden" id="hidScrollPositionY" name="hidScrollPositionY"/> 
						   
						    <% } //if closed
						    %>						
							</div>
					</form>
				</div>
			
			<!-- divCourseModule contains the information about selected course and modules which are in it -->
			<div id="divCourseModule" style="float:right;width:620px;height:360px;margin-right:10px">
				
				<%if(iCourseId!=0){ //if course is selected 
				%>
				
				<!-- selected course details -->
				
				<div id="divCourseDetail" style="width:620px;border : 0.1em solid #B7B7B7;">
					<div class="divSmallHeader" style="margin-top:1px"><label class="lblstyle">Course</label> </div>
					  <div style="width:620px">
						<form id="frmUpdateCourses" method="post">
							<table  style="width:619px;padding-left:0px"  >
								 <tr>
								 	<td class="tdblue" style="width:130px;height:28px"><label class="lblstyle">Course Name :</label></td>
								 	<td colspan="3" class="tdlightblue"height="28px"><input type="text" class="transparent" name="txtUpdateCourseName" id="txtUpdateCourseName" maxlength="74" value="<%=strCourses%>" <%if(strCourses!=null && strCourses.length()>10){%>style="width:<%=strCourses.length()*7 - 4%>px;font-size:13px;"<%}else{%>style="width:142px;"<%}%> readonly="readonly" /></td>
								 </tr>
								   <tr>
								   		<td class="tdblue" style="width:130px;padding-top:0px;height:28px"><label class="lblstyle">Course Abbreviation :</label></td>
								   		<td colspan="3"class="tdlightblue" style="padding-top:4px;height:28px"><input class="transparent" type="text" name="txtUpdateCourseShortName" id="txtUpdateCourseShortName" value="<%=strCoursesShortName%>" maxlength="20" readonly="readonly" />
								   			<input type="hidden" name="hidCourseId" id="hidCourseId" value="<%=iCourseId%>"/>
								   		</td>
								   </tr>
								   <tr><td class="tdblue" style="width:130px"><label class="lblstyle">Valid Till Date :<br/>(dd-mm-yyyy)</label></td>
								   		<td class="tdlightblue"height="26px" width="240px"><input type="text" class="transparent" name="txtTillDate1" id="txtTillDate" value="<%=strCoursesDate%>" disabled="disabled" style="color:black;forecolor:black"></input></td>
								   		<td class="tdblue" style="padding-bottom:5px;width:100px">
								   		<% String sqlQuery = null;
								   		String Status = "Active" ;
								   		 sqlQuery ="Select course_Name from ePariksha_Courses where course_Id = ? and course_Validtill_Date >= now()";
										 pst=conn1.prepareStatement(sqlQuery,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
										 pst.setInt(1,iCourseId);
										 rst=pst.executeQuery();
										 if(rst.first()){
											 Status = "Inactive";
										 }else{
											 Status = "Expired";
										 }rst.close();
										 pst.close();
										
										 sqlQuery="Select epum.user_Id,epum.user_F_Name from ePariksha_User_Master epum left join ePariksha_Courses epc on epum.user_Course_Id = epc.course_Id where  epum.user_Course_Id = ? and epc.course_Validtill_Date > now()";
										 pst=conn1.prepareStatement(sqlQuery,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
										 pst.setInt(1,iCourseId);
										 rst=pst.executeQuery();
										 if(rst.first()){
											 Status = "Active";
										 }
										 rst.close();
										 pst.close();
										 %>
										 <label class="lblstyle">Status :&nbsp;&nbsp;&nbsp;</label></td>
										 <td class="tdlightblue"><span id="Status_id" style="color:black;font-size:14px"><%=Status%></span>
										</td>
								   </tr>
								   <tr><td class="tdlightblue" colspan="4" style="padding-left:145px;height:22px">
								   			<span id="anchorOff" class="hidden" > 
												<a href="javascript:ShowCourse();" id="EditCourse" style="color:#38aefe;text-decoration:none;cursor:pointer">Edit</a>
											</span>&nbsp;&nbsp;
											<span id="anchorOff" class="hidden" > 
												<a href="javascript:CancelCourses();" id="CancelCourse" style="color:gray;text-decoration:none;cursor:default;">Cancel</a>
											</span>&nbsp;&nbsp;
											<span id="anchorOff" class="hidden" > 
												<a  onclick="javascript:UpdateCourses();" id="UpdateCourse" style="color:gray;text-decoration:none;cursor:default;" href="javascript:void(0)">Update</a>
											</span>
								   		</td>
								   </tr>		
							</table>
						 </form>
					 </div>
				</div>
				
				<div style="color:red;padding-left:190px;margin-top:3px;">&nbsp;<label id="labelMessage" style="padding-top:8px"></label></div>
				
				  <div id="divModule" <%if(iCourseExpire==1){ %>style="height:208px"<%}%>>
					<div class="divSmallHeader" >
						<div style="float:left"><label class="lblstyle">Modules</label></div>
						<div style="float:right;margin-right:10px" >
							<div onclick="javascript:showModalDiv('modalCreateModulePage');" style="float:left;cursor:pointer"><span style="margin-top:4px;padding-bottom:0px"><img src="images/add.png" style="width:14px;height:14px;"/></span><label class="lblstyle">Add Module</label></div>
							<div onclick="javascript:showModalDiv('modalCourseEligibilityPage');" style="float:right;cursor:pointer">&nbsp;&nbsp;&nbsp;<span style="margin-top:4px;padding-bottom:0px"><img src="images/add.png" style="width:14px;height:14px;"/></span><label class="lblstyle">Add existing </label></div>
						</div>
						<div style="clear:both"></div>
					</div>
					
					
					<!-- this div contain the list of modules in selcted course  -->
					
					<div id="divAllModule" <%if(iCourseExpire==1){%>style="height:186px"<%} %> >
						<%	long lModuleId = 0;
							// modules which are existed in selected course 
							int count = 0;
							pst = conn1.prepareStatement("select module_Id,module_Name from ePariksha_Modules where module_Course_Id = ?",ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
							pst.setInt(1,iCourseId);
							rst = pst.executeQuery(); 
							if(rst.first())
							{
								rst.beforeFirst();
								while(rst.next()){
									count++;
									lModuleId = rst.getLong("module_Id");%>
									<div id="div<%=lModuleId%>" <%if(count%2==0){%>style="background-color:#FBF9F5"<%}else{%>style="background-color:#F2F2F2"<%} %>>
										<div style="float:left"><input class="removeBorder" type="text" id="<%=lModuleId%>" name="<%=lModuleId%>" value="<%=rst.getString("module_Name")%>" <%if(count%2==0){%>style="width:325px;height:21px;padding-left:3px;padding-top:2px;font-size:13px;background-color:#FBF9F5"<%}else{%>style="width:325px;height:21px;padding-left:3px;padding-top:2px;font-size:13px;background-color:#F2F2F2"<%}%> maxlength="50" readonly="readonly"/><input type="hidden" id="hid<%=lModuleId%>" name="hid<%=lModuleId%>" value="<%=rst.getString("module_Name")%>"/></div>
										<div style="float:right;margin-bottom:0px;padding-top:2px">
										
											<img src="images/edit_blue.png"  id="btnEdit<%=lModuleId%>" name="btnEdit" title="Edit" onclick="EditModule(<%=lModuleId%>)" style="display:inline;cursor:pointer;width:21px;height:21px;margin-right:10px"/>
											<img src="images/accept_new.png" title="Update" id="btnUpdateModule<%=lModuleId%>" name="btnUpdateModule" onclick="UpdateModule(<%=lModuleId%>,<%=count%>)" style="cursor:pointer;width:21px;height:21px;margin-right:10px;display:none"/>
											<img src="images/cancel1.png" title="Cancel"  id="btnCancelModule<%=lModuleId%>" name="btnCancelModule"  onclick="CancelModule(<%=lModuleId%>,<%=count%>)" style="cursor:pointer;width:21px;height:21px;margin-right:10px;display:none"/>
											<img src="images/delete.png"  id="btnDelete<%=lModuleId%>" name="btnDelete<%=lModuleId%>" title="Delete"  onclick="DeleteModule(<%=lModuleId%>)" style="width:20px;height:20px;margin-left:5px;margin-right:10px;cursor:pointer"/>
										</div>
										<div style="clear:both"></div>
										
									</div>
								   <%}	
							}else{%>
							
								<!-- If no module found for selcted course -->
								<div id="divNoModule" style="margin-left:200px;margin-top:50px;font-size:24px;color:#B27C7C">No module found</div>
							<%}	rst.close();
								pst.close();
								
						%>
							
					 </div>
				   </div>
				<% if(iCourseExpire!=1){ %>
				<div style="color:red;padding-left:190px;margin-top:0px;">&nbsp;<label id="labelMessage" style="padding-top:8px"></label></div>
				
				<!--  Add user for selected course  -->
				
				<div id="divAddUser" style="width:620px;height:30px;border : 0.1em solid #B7B7B7;">
					<table style="padding:0px 0px 0px 0px;height:24px;cellspacing:1px;background-color:#ffffff"><tr><td class="tdblue" width="120px" ><label class="lblstyle" style="padding-left:2px">Assign Examiner :</label></td>
							<td width="490px" class="tdlightblue">
					<!--  divDrpUser contains the users which are free which are not alloted to any course or if course expires then user is also free -->
								<div style=""><div id="divDrpUser" style="float: left; width: 210px;padding:1px 2px 0px 0px">	
														  <select style="padding:0px 0px 0px 0px;width: 197px;font:9pt Arial" id="drpUsers" name="drpUsers" <%if(count==0){%>disabled="disabled"<%}%> >
														  	<option value="0">--Select--</option>
														  	<%	
														  		int iUser_Ids = 0;
														  		int iUser_Id = 0;
																String strFirst_Names = null;
																String sqlCourses = null;
																PreparedStatement pstmtUser = null;
																ResultSet rstUser = null;
																	
																sqlCourses="Select user_Id,user_F_Name from ePariksha_User_Master where user_Course_Id = ?";	 
																try{	
																		 pstmtUser=conn1.prepareStatement(sqlCourses,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
																		 pstmtUser.setInt(1,iCourseId);
																		 rstUser=pstmtUser.executeQuery();
																		 String strCourse_Short_Names = null;
																	  	 int iCourse_Ids = 0;
																	     while(rstUser.next())    
																	     { 
																	    	iUser_Id = rstUser.getInt("user_Id");   
																	    	strFirst_Names = rstUser.getString("user_F_Name"); 
																			 %>
																				<option title="<%=strFirst_Names%>" value="<%=iUser_Id%>" selected="selected"> <jsp:expression>strFirst_Names</jsp:expression> </option>   
																			 <% 
																	     }  
																	     rstUser.close();
																	     pstmtUser.close();
																
																	 	 sqlCourses="Select epum.user_Id,epum.user_F_Name from ePariksha_User_Master epum left join ePariksha_Courses epc on epum.user_Course_Id = epc.course_Id where  epum.user_Course_Id = 0 and epum.user_Role_Id <> '999'  and epum.user_Course_Id <> ? or epc.course_Validtill_Date < now()";
																	
																		 pstmtUser=conn1.prepareStatement(sqlCourses,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
																		 pstmtUser.setInt(1,iCourseId);
																		 rstUser=pstmtUser.executeQuery();
																	  	 
																	   	 while(rstUser.next())    
																	    	{ 
																	    	iUser_Ids = rstUser.getInt("user_Id");   
																	    	strFirst_Names = rstUser.getString("user_F_Name"); 
																			 %>
																				<option title="<%=strFirst_Names%>" value="<%=iUser_Ids%>" > <jsp:expression>strFirst_Names</jsp:expression> </option>   
																			 <% 
																	   		 }  
																	     rstUser.close();
																	     pstmtUser.close();
																	
															 		}catch(Exception e){e.printStackTrace();}
															%>
														</select>
														<input type="hidden"  id="hidUserId" value="<%=iUser_Id%>"/>
														
									 </div><div style="float:right;height:20px;width:260px;padding-top:4px">
									 		<%
															 sqlCourses="Select course_Name from ePariksha_Courses where course_Id = ? and course_Validtill_Date >= now() ";
															 pstmtUser=conn1.prepareStatement(sqlCourses,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
															 pstmtUser.setInt(1,iCourseId);
															 rstUser=pstmtUser.executeQuery();	 
														    while(rstUser.next())    
														    { 
														    	
																 %>
																 			<span style="padding-top:10px" >
																				<a id="linkAddUser" <%if(count!=0){%>href="javascript:AddUser();" style="color:#38aefe;text-decoration:none;cursor:pointer;padding-top:5px;font-weight:normal"<%}else{%>href="javascript:void(0);" style="color:gray;text-decoration:none;cursor:pointer;padding-top:5px;font-weight:normal"<%}%> >Add</a>
																			</span>
																 <% 
														    }  
														    rstUser.close();
														    pstmtUser.close(); %>
									&nbsp;&nbsp;<label id="lblMessageUser" style="color:red"></label> </div><div style="clear:both"></div></div>
									
									
					</td></tr>
				</table>
				 </div> 
				<div style="clear:both"></div>
					<%}     //if course is selected ends
					}else{%>
						<div class="message_directions" style="padding-left:150px;padding-top:160px;font-size:24px;height:214px;border : 1px solid #B7B7B7;">Select the Course from left Menu</div>
					<%}}catch(Exception e)
					{
						e.printStackTrace();
					}
					
				%>
				
			</div>
			<div style="clear:both"></div>
		</div>
		
			<!-- Add Course modal div starts -->
			
						<div id="modalCreateCoursePage" >
						    	<div class="modalCreateCommonBackground">
						    	</div>
						    	<div class="modalCreateCourseContainer">
						        	<div class="modalCreateCourse">
						            	<div class="modalCreateCourseTop"> 
										  <table style="border-collapse: collapse; width: 100%;height:100%" cellpadding="0" cellspacing="0" >
											 <tr>
											  <td style="padding-left:5px;width: 64px;" align="left"><b>Add Course</b></td>
											   <td style="padding-right:5px; width: 44px;" align="right" width="60%"><a href="javascript:closeAddCourses();">[X]</a></td>
											 </tr>
										  </table>
									    </div>
										<div id="modalCreateCourseContent" class="modalCreateCourseBody">
							               <div align="center" style="padding:0px 0px 0px 0px" id="divCentreAdmins">
											   <form action="CreateModule" method="post" id="frmCreateModule1" name="frmCreateModule1">
												 <table style="width: 340px;height:130px;padding-top:0px" >
													 <tr>
													 	 <td class="lblDisplayCl" colspan="2"  align="center" style="padding:0px 0px 0px 0px;height:18px;color:red"><label id="lblDisplayMessage">&nbsp;</label></td>
													 </tr>
													 <tr>	
														 <td style="padding-left:4px;color:#6b95b4;" align="left" width="120px" height="24px"><label class="lblstyle">Course Name :</label></td>
														 <td style="padding-right:2px;height:24px;padding-left:4px"><input class="activeborder" type="text" id="txtCourseName" name="txtCourseName" style="width:200px" maxlength="74"/></td>
													 </tr>
													 <tr>	
														 <td style="padding-left:4px;color:#6b95b4;" width="120px" align="left"><label class="lblstyle">Course Abbrevation :</label></td>
														 <td style="padding-right:2px;padding-left:4px;" align="left"><input class="activeborder" type="text" id="txtCourseShortName" name="txtCourseShortName" style="width:200px" maxlength="10"/></td>
													 </tr>
													 <tr>	
														 <td style="padding-left:4px;color:#6b95b4;" width="120px" align="left"><label class="lblstyle">Valid till Date :</label></td>
														 <td style="padding-right:2px;padding-left:4px;" align="left"><input type="text" id="txtCourseDate" name="txtCourseDate" style="width:200px;border-width:1px solid #88C1F4" readonly="readonly" maxlength="10" onchange="hideAllCal()" /></td>
													 </tr>
													 <tr>
														 <td align="center" colspan="2"><a style="cursor:pointer;color:#38aefe;text-decoration:none;font-size:14px" href="javascript:void(0);" onclick="javascript:AddCourses()">Add</a></td>
													 </tr>
												 </table>
											   </form>	
						 				   </div>
						               </div>
						          </div>
						       </div>
						</div>
						
					<!-- End Course Modal div  -->
					
					<!-- Add Module modal div starts -->
					
						<div id="modalCreateModulePage" >
						    	<div class="modalCreateCommonBackground">
						    	</div>
						    	<div class="modalCreateModuleContainer">
						        	<div class="modalCreateModule">
						            	<div class="modalCreateModuleTop"> 
										  <table style="border-collapse: collapse; width: 100%;height:100%" cellpadding="0" cellspacing="0" >
											 <tr>
											   <td style="padding-left:5px;width:64px;" align="left"><b>Add Module </b></td>
											   <td style="padding-right:5px; " align="right" width="58%"><a href="javascript:closeAddModules();">[X]</a></td>
											 </tr>
										  </table>
									    </div>
										<div id="modalCreateModuleContent" class="modalCreateModuleBody">
							               <div align="center" style="padding:0px 0px 0px 0px" id="divCentreAdmins">
											   <form action="CreateModule" method="post" id="frmCreateModule2" name="frmCreateModule2">
												 <table style="width: 330px;height:100px;padding-top:0px" >
													 <tr>
													 	 <td class="lblDisplayCl" colspan="2"  align="center" style="padding:0px 0px 0px 0px;height:18px"><label id="lblDisplayModuleMessage"></label></td>
													 </tr>
													 <tr>	
														 <td style="padding-left:4px;color:#6b95b4;" align="left"><label class="lblstyle">Module Name :</label></td>
														 <td style="padding-right:0px;"><input type="text" id="txtModuleName" name="txtModuleName" style="width:212px" maxlength="50"/><input type="hidden" id="hidCourseID" name="hidCourseID" value="<%=iCourseId%>"/></td>
													 </tr>
													 <tr>
														 <td align="center" colspan="2"><a style="cursor:pointer;color:#38aefe;text-decoration:none;font-size:14px" href="javascript:void(0);" onclick="javascript:AddModule()">Add</a></td>
													 </tr>
												 </table>
											   </form>	
						 				   </div>
						               </div>
						          </div>
						       </div>
						</div>
						
					<!-- End Course Modal div  -->
					
					
						<div id="modalCourseEligibilityPage" >
					
					    <div class="modalCourseEligibilityBackground">
					    </div>
					    <div class="modalCourseEligibilityContainer">
					        <div class="modalCourseEligibility">
					            <div class="modalCourseEligibilityTop"> 
									<table style="border-collapse: collapse; width: 100%;height:100%" cellpadding="0" cellspacing="0" >
										<tr>
										<td style="padding-left:5px;" align="left"><b>Add Existing Modules</b>
										</td>
										<td style="padding-right:5px; width: 44px;" align="right" width="60%"><a href="javascript:javascript:hideViewer('modalCourseEligibilityPage');">[X]</a>
										</td>
										</tr>
									</table>
								</div>
					            
								<div id="modalCourseEligibilityContent" class="modalCourseEligibilityBody">
						             <div align="center" style="padding:5px 0px 0px 0px" id="divMinEligibilityCriteria">
						             		<span style="color:red;height:15px"><label id="lblMessage">&nbsp;</label></span>
											 <table  style="width: 559px;height:200px" >
											 		<tr>
													  <td colspan=3 align="left">
													  <div>
													  <div style="float: left; width: 80px;color:#6b95b4;padding-top:2px" >
														<label class="lblstyle">Select Course<input type="hidden" id="selectedCourseId" ></input></label>
													  </div>
														<div id="divDrpDegrees" style="float: right; width: 289px;padding:0px 150px 0px 0px">	
														  <select style="padding:0px 0px 0px 0px;width: 197px;font:9pt Arial" id="drpCourses" name="drpCourses" onchange="showDegrees(this.value)" >
															   	<option value="0">--Select--</option>
																<%
																	String sqlCourses="Select course_Short_Name,course_Id from ePariksha_Courses";
																try{	
																		PreparedStatement pstmt_date_course_settings=conn1.prepareStatement(sqlCourses);
																		ResultSet rs_date_course_settings=pstmt_date_course_settings.executeQuery();
																		String strCourse_Short_Names = null;
																	  	int iCourse_Ids = 0;
																	    while(rs_date_course_settings.next())    
																	    { 
																	    	iCourse_Ids = rs_date_course_settings.getInt("course_Id");   
																	    	strCourse_Short_Names = rs_date_course_settings.getString("course_Short_Name"); 
																			 %>
																				<option title="<%=strCourse_Short_Names%>" value="<%=iCourse_Ids%>"> <jsp:expression>strCourse_Short_Names</jsp:expression> </option>   
																			 <% 
																	    }  
																	    rs_date_course_settings.close();
																	    pstmt_date_course_settings.close();
																		
															 		}catch(Exception e){e.printStackTrace();}
															%>
															  </select>
															  </div>
															  <div style="clear:both"></div>
															 </div>
														</td>
									                 </tr>
													 <tr >
									                     <td align="left" style="padding-top:10px" >
									                        <label class="message">*</label>
															<label class="lblstyle">Select Modules:</label>
																<img style="position: absolute; left: 120px; top: 140px;z-index:-1" id="imgAjaxloadingImage" alt="Loading" src="images/ajaxLoader.gif" />
					
																<select  style="width: 240px;height: 139px;font:9pt Arial;z-index:0" id="drpDegreeStreams" name="drpDegreeStreams" multiple="multiple"  onchange="transferToFromDrps(this.form,'drpDegreeStreams','drpFinalCriteria')"  >
																</select>
														</td>
														 <td align="left" style="padding-top:0px">
															&#62;&#62;
															
									
														</td>
														<td align="left" style="padding:10px 0px 0px 10px">
									                    	<label class="message">*</label>
															<label class="lblstyle">Current/Selected Modules:</label>
															<select style="width: 240px;height: 139px;font:9pt Arial" id="drpFinalCriteria" name="drpFinalCriteria" multiple="multiple"  onchange="removeFinalCriteriaDrpOptions('drpFinalCriteria','')">
															</select>	
									
														</td>
												 	</tr>
													<tr>
													 	<td align="center" colspan="3" style="padding-top:5px">
															<a href="#" onclick="javascript:setFinalValuesForSubmit();" id="btnSubmit" name="btnSubmit" style="color:#38aefe;text-decoration:none;font-size:14px">Add</a>&nbsp;&nbsp;
															<a href="#" onclick="javascript:cancelEligibilityUpdateOperation();" id="btnCancel" name="btnCancel" style="color:#38aefe;text-decoration:none;font-size:14px">Cancel</a>
										 					<input type="hidden"  value=""  name="txtDegreesSpecMappingId" id="txtDegreesSpecMappingId"/>
													  		<input type="hidden" value=""  name="txtMappingIdUnderDesigning" id="txtMappingIdUnderDesigning"/>
															<input type="hidden" value=""  name="txtMappingValuesUnderDesigning" id="txtMappingValuesUnderDesigning"/>
					
													  	</td>
													</tr>
													<tr>
														<td align="left" colspan="3">
															<div  id="div_instructions"  align="left">
															 <label class="message">*</label>
																To select, click any option.
															 </div> 			
														</td>
													</tr>
											 </table>
					 					 </div><!-- eligibility div ends -->
					
					
					            </div>
					        </div>
					    </div>
					</div>
					
			
		
				<!-- Paste Your code here -->
		
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
				            <td style="padding-top:15px;" align="center"  class="copyright">Copyright &copy; 2009-2014<span style="color:#A70505;">CDAC ACTS </span>All rights reserved</td>
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
