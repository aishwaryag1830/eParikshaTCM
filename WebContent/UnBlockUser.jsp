<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" session="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!-- @Author : Mritunjay Kumar Sinha
	 @Date   : 24-05-12
	 @return : it Upload Student and can unblock the blocked student like in case of browser crash   	 
 -->
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
{
	String sRoleId=null;
	 /*UserRoleId: need to by checked from loginauthentication servlet because of session names*/
	 if(session.getAttribute("UserRoleId")!=null)
		sRoleId=session.getAttribute("UserRoleId").toString();
	
	if(!sRoleId.equals("001"))
	 {%><jsp:forward page="index.jsp"></jsp:forward><%}
%>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<link rel="stylesheet" href="Css/style.css" type="text/css">
	 	<meta http-equiv="Pragma" content="no-cache"> 
		<meta http-equiv="Cache-Control" content="no-cache,no-store,must-revalidate,max-age=0">
		<meta http-equiv="Expires" content="0">
		<link rel="shortcut icon" href="images/ico.ico" />
 		<script type="text/javascript" src="Js/Unblockuser.js"></script>
		<script type="text/javascript" src="Js/randompassword.js"></script>
 		<script type="text/javascript" src="jquery-1.3.1.min.js"></script>
 		<script type="text/javascript" src="Js/modalfiles/modalDiv.js"></script>
 		<script type="text/javascript" src="Js/AdminUserMan.js"></script>
 		<link rel="stylesheet" href="Js/modalfiles/modalDiv.css" type="text/css" />
		<title>Unblock Users [ePariksha] </title>
		<script type="text/javascript">
			javascript:window.history.forward(1);
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
		String sCourseId	=	null;
		String strMessage 	= 	" ";
		
		String strUserName	=session.getAttribute("UserName").toString();
		
		try{
								 if(session.getAttribute("snMsgCandidateUnBlock")!=null)//From UpdateCentreSignAuth servlet
								 {
									 strMessage=session.getAttribute("snMsgCandidateUnBlock").toString();
									 session.removeAttribute("snMsgCandidateUnBlock");
								}
			
							  }catch(Exception e){}
							  
		if(session.getAttribute("CourseId")!=null)
			sCourseId	=	session.getAttribute("CourseId").toString();
			
		
		
			/**
			 * variables for database connections
			 * */
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
			
			if(result!=null)
				result.close();/**closing the resultset*/
				
			if(pstmt!=null)
				pstmt.close();/**closing the pstmt*/ 
			
			if(session.getAttribute("snMsgCandidateUnBlock")!=null)
			{
				strMessage = session.getAttribute("snMsgCandidateUnBlock").toString();
			}	
			/**Fetching result set for modules starts**/
				
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
        
	        <div id="workArea"> <!-- Div Work area begins --> <!-- work area begins -->
						<br/>
						
						<!-- Modal div Begins -->
						<div id="modalUploadStudInfoPage" style="top" >
						
						    <div class="modalUploadStudInfoBackground">
						    </div>
						    <div class="modalUploadStudInfoContainer" >
						        	<div class="modalUploadStudInfo" style="width:550px;height:330px;position: relative;top:-150px;left:-90px;">
								            <div class="modalUploadStudInfoTop" style="width:100%;"> 
												<table style="border-collapse: collapse; width: 100%;height:100%" cellpadding="0" cellspacing="0" >
													<tr>
													<td style="padding-left:5px;font:normal 10pt Arial;"  align="left"><b>Upload Student Data</b>
													</td>
													<td style="padding-right:5px; width: 44px;" align="right"><a href="javascript:hideViewer('modalUploadStudInfoPage');">[X]</a>
													</td>
													</tr>
												</table>
											</div>
								            
											<div align="center" style="width:100%;height:100%;" id="modalUploadStudInfoContent" class="modalUploadStudInfoBody">
													<div style="float:left;margin:45px 0px 0px 30px;">
														<a href="SampleDocs/Student_Login_Data.xls" target="_blank" style="color: #5384A8;"><img src="images/uploadStudent.png"><br/>Download Sample</a>
													</div>
													<div align="justify" style="float:right;margin:20px 40px 0px 10px;" >
															<ul>
																<li style="padding-bottom:15px;">Only Excel file is supported.</li>
																<li style="padding-bottom:15px;">Data inserted should be in format specified in sample</li>
																<li style="padding-bottom:15px;">Roll number must be of minimum seven digits.</li>
																<li style="padding-bottom:15px;">Roll number column should be formatted for <br>using only integer numbers.</li>
																
																<li style="padding-bottom:15px;">Select file to upload:</li>
															</ul>
															<form name="frmUpload" action="UploadStudData" method="Post" enctype="multipart/form-data" onsubmit="return goUploadStudData();">
																<input type="file" name="txtUploadFile" style="width: 279px; height: 24px;">
																<br/><br/>
																<input type="submit" value="Upload" name="btnSubmit" class="button">
																<input type="reset" value="Reset" name="btnCancel" class="button" >
															</form>
															
													</div>
													<div style="clear:both;"></div>
											</div><!-- Internal div of modal window -->
						        	</div>
						    </div>
						</div>
							
					<!-- Modal div Ends -->
						<!-- Modal div  Change password Begins -->
						<div id="modalChangeStudInfoPage" style="top" >
						
						    <div class="modalChangeStudInfoBackground">
						    </div>
						    <div class="modalChangeStudInfoContainer" >
						        	<div class="modalChangeStudInfo" style="width:852px;height:500px;position: relative;top:-240px;left:-209px;">
								            <div class="modalChangeStudInfoTop" style="width:100%;"> 
												<table style="border-collapse: collapse; width: 100%;height:100%" cellpadding="0" cellspacing="0" >
													<tr>
													<td style="padding-left:5px;font:normal 10pt Arial;"  align="left"><b>Edit Student Data</b>
													</td>
													<td style="padding-right:5px; width: 44px;" align="right"><a style="color:#7A7A7A;" href="javascript:hideViewer('modalChangeStudInfoPage');">[X]</a>
													</td>
													</tr>
												</table>
											</div>
								            <div id="labelMessage" style="height: 17px;width:100%;padding-top:3px;padding-bottom:2px;color:red;color:#FF0000;font-size: 12.5px;text-align:center"></div>	
											<div align="center" style="width:100%;height:100%;padding-top: 0px;" id="modalChangeStudInfoContent" class="modalChangeStudInfoBody">
		
											</div><!-- Internal div of modal window -->
						        	</div>
						    </div>
						</div>
							
					<!-- Modal div Change Password Ends -->
						
						<div id="header_Links" align="left" style="width:800px;margin-top:5px;">
									<div style="float:left;padding-top:5px;padding-left:5px;width: 220px; vertical-align: bottom;">
										<img style="height: 25px; width: 30px;vertical-align: bottom;" src="images/CandidateProfiles.png">
										<label class="pageheader">Manage Students</label>
									</div>		
									<div id="divUploadStudentData" align="right" style="float:right; width: 409px;padding:4px 0px 0px 0px;">
									<a href="javascript:showModalDiv('modalUploadStudInfoPage');"><img style="width:22px;height:22px;padding-right:3px; " src="images/uploadStudent.png"/>Student Data</a>
									<a id="StudentInfo" href="javascript:void(0);" onclick="javascript:ShowStudentInfo();"><img style="width:22px;height:22px;padding-right:3px; " src="images/uploadStudent.png"/>Edit Student/Change Password</a>
								</div>
		
						</div>
						<div style="clear:both;"></div>
								
						<div id="msgDiv" style="height: 20px;width:100%;padding-top:7px;padding-bottom:0px;color:red;color:#FF0000;font-size: 12.5px;text-align:center"><label><%=strMessage %></label></div>
							
						 <div align="center" id="divResultFilterCriteria" style="width:100%;padding:0px 0px 0px 0px;">
						 	<form id="frmBlockUSerMenu" name="frmBlockUSerMenu" action="" method="post">
									<table class="tblstyle" style="width:640px;height:40px;"  >
										<tr>
											<%	
												String sCurrentDate	=	null;
												
												pstmt=connection.prepareStatement("select to_char(now(), 'DD-MM-YYYY') as CurrentDate ",
														ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);	
													 result=pstmt.executeQuery();
													 if(result.next())
													 	sCurrentDate	=	result.getString("CurrentDate");
													
												%>
											<td class="tdblue" align="left" style="width:100px;">
												<label class="lblstyle">Date: </label>
											</td>	
											<td class="tdlightblue" align="left" style="width:160px;">	
												<span><label class="lblstyle"><%=sCurrentDate%></label></span>
											</td>
											<%
												if(result!=null)
													result.close();/**closing the resultset*/
													
												if(pstmt!=null)
													pstmt.close();/**closing the statement*/ 
										
													 pstmt=connection.prepareStatement("SELECT DISTINCT ePariksha_Modules.module_Id, ePariksha_Modules.module_Name FROM  ePariksha_Modules,ePariksha_Exam_Schedule where ePariksha_Modules.module_Id = ePariksha_Exam_Schedule.exam_Module_Id and to_char(ePariksha_Exam_Schedule.exam_Date, 'DD-MM-YYYY')=?"+ 
													 									" and ePariksha_Modules.module_Course_Id=? ",
															ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
													 	 pstmt.setString(1,sCurrentDate);
														 pstmt.setInt(2, Integer.parseInt(sCourseId));
														 result=pstmt.executeQuery();
													%>
											
											<td class="tdblue" align="left" style="width:120px">
												<label class="lblstyle">Select Module: </label>
											</td>
											<td class="tdlightblue">
													<span id="divDrpModuleHolder" style="padding:0px 0px 0px 20px; width: 161px">
														<select name="drp_module_name" id="drp_module_name" onchange="goSelectModule(this.form,this);" style="width: 160px;">
															<option value="0" selected="selected">--Modules--</option>
															<%
															String strModuleIdDrp = null;
															boolean bModulesPresent	=	false;
															while(result.next())
															{
																bModulesPresent	=	true;
																 strModuleIdDrp=result.getString("module_Id");
																String strModuleNameDrp=result.getString("module_Name");
																String strShortModuleName=null;
																	
																if(strModuleNameDrp.length()>20)
																	strShortModuleName=strModuleNameDrp.substring(0,20)+"...";
																else
																	strShortModuleName=strModuleNameDrp;
															%>
																<option value="<%=strModuleIdDrp.trim()%>" title="<%=strModuleNameDrp%>"><%=strShortModuleName%></option>
															<%}%>
													   </select>
													  <%
														if(result!=null)
															result.close();/**closing the resultset*/
															
														if(pstmt!=null)
															pstmt.close();/**closing the statement*/ 
														%>
													<input type="hidden" name="txtModuleId"  id="txtModuleId">
													<input type="hidden" name="txtModuleName" id="txtModuleName" />
													<input type="hidden" name="txtModuleDrpId" id="txtModuleDrpId"/>
													<input type="hidden"   name="txtExamDateDrpId" id="txtExamDateDrpId"/>
													<input type="hidden"  value="" name="txtExamDate" id="txtExamDate"/>
												</span>
										</td>
									 </tr>
										
								</table>
							</form>	
						</div>
						<div style="clear: both"></div>
						<br>
							<div id="divSeparator" align="center"><img src="images/separator.gif" style="width:100%;height:1px;"></div>
						
	
	<!-- DIv Result Data grid  starts-->
	
			<%
					String strModuleId=	request.getParameter("drp_module_name");
					if(bModulesPresent==false)//No modules present for this date.
					{
						%><div class="message_directions" id="div_messages_server" style="margin:57px 0px 0px 0px;text-align: center"> <!-- messages and directions -->
							No exam is scheduled for today's date.
							<script>
								if(document.getElementById('drp_module_name')!=null)
								{
									//document.getElementById('drp_module_name').disabled=true;	
								}
							</script>
						</div><%
					}
					else if(strModuleId==null)
					{%>
						<div class="message_directions" id="div_messages_server" style="margin:57px 0px 0px 0px;text-align: center"> <!-- messages and directions -->
						
						<%
						
							
							if(strModuleId==null || strModuleId.equals(null))
							{
							  %>
								Please select module
							 <%
							}
							
						%>
						</div>
					<%}	
					
					else{
						long lTotalRows	=	0;
						boolean bResultRows	=false;
						
						
						
							/**Fetching result set for modules ends**/
							try{
								/*pstmt=connection.prepareStatement("select distinct stud_PRN,stud_F_Name,"+
									"stud_M_Name,stud_L_Name from ePariksha_Student_Login,ePariksha_Exam_Schedule where"+
									" CONVERT(VARCHAR(10), ePariksha_Exam_Schedule.exam_Date, 105)=LTRIM(RTRIM(?))"+ 
									" and ePariksha_Student_Login.stud_Course_Id=LTRIM(RTRIM(?))"+
									" and ePariksha_Student_Login.stud_Login_Flag=1"+
								" order by ePariksha_Student_Login.stud_PRN",ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
								*/
								
								pstmt=connection.prepareStatement("Select ePariksha_Student_Login.stud_PRN,ePariksha_Student_Login.stud_F_Name,ePariksha_Student_Login.stud_M_Name,ePariksha_Student_Login.stud_L_Name from ePariksha_Student_Login where "+
								"ePariksha_Student_Login.stud_PRN not in (select result_Stud_PRN from ePariksha_Results where result_Module_Id = ? " +
								"and to_char(result_Exam_Date, 'DD-MM-YYYY') like to_char(now(), 'DD-MM-YYYY') ) "+
								"and ePariksha_Student_Login.stud_Login_Flag = ? and ePariksha_Student_Login.stud_Course_Id = ?"+
								" order by ePariksha_Student_Login.stud_PRN",ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
								pstmt.setLong(1, Long.parseLong(strModuleId));
								//pstmt.setString(2, sCurrentDate.trim());
								pstmt.setBoolean(2, true);
								pstmt.setInt(3, Integer.parseInt(sCourseId));					
								result=pstmt.executeQuery();	
								
								/*Fetching total number of rows to align datagrid*/
								result.last();
								lTotalRows	=	result.getRow();
	
								result.beforeFirst();
								/*Fetching total number of rows*/
		
								if(result.next())
								{
									bResultRows	=	true;
									result.beforeFirst();
								}
							}catch(Exception e){e.printStackTrace();}
							
								
						if(bResultRows){								// to check for new message
						%>	
				<!--  		<div id="div_message_operations" align="center" style="width: 545px">
							<label id="lblMainMessages" class="message"> 
								<%
								String msg	=	"";//for showing "" msg first
								try{
									 if(session.getAttribute("snMsgCandidateUnBlock")!=null)//From UpdateCentreSignAuth servlet
									 {
										 msg=session.getAttribute("snMsgCandidateUnBlock").toString();
										 session.removeAttribute("snMsgCandidateUnBlock");
									}
	
								  }catch(Exception e){}
								  
								 %> 
						 	<%=msg%>
							</label> 
						</div>
				-->
						<div id="divResultPage" style="	width: 100%;padding:0px 0px 0px 0px;">
						<div align="left" style="width: 161px;padding:0px 0px 10px 0px;margin:0px 550px 0px 10px;"><h3><b><i><u>Blocked Users</u></i></b></h3></div>
							
							<div id="div_datagrid" align="center" style="border : 1px solid #B7B7B7 ;width:700px;margin-left:50px"><!-- Div containing table starts -->
							
								<table style="background:white;color: black;width:100%;" cellpadding="1px" cellspacing="1px"><!-- Data grid starts -->
									<tr id="tblheader" style="border: 2px;border-collapse:separate;" >
										<th style="width:46px;height:15px">S.No.</th>
										<th style="width: 175px;">Candidate Id</th>
										<th style="width:433px;">Candidate Name</th>
										<!-- <th>Marks</th>
										<th>Percentage</th> -->
										<th style="width:46px;padding 0px 5px 0px 0px;">
											<input type="checkbox" onclick="selectCheckedUsers('<%=lTotalRows%>')"  name="chkSelectCandidateAll" id="chkSelectCandidateAll" style="height:14px">
										</th>
									</tr>
								</table>
	
								<div id="div_tbl" align="center" style="margin-left:0px;padding:0px;<%if(lTotalRows>20){%>overflow:auto;height:400px;<%}%>width:700px;">								
										<form name="frmUnblockUser" id="frmUnblockUser" action="BlockUnblockUser" method="post">
											<table align="center" class="tbstyle"  style="<%if(lTotalRows<=20){%>width:700px;<%}else{%>width:683px;<%}%>background:white;color: black;" cellpadding="1px" cellspacing="1px"><!-- Data grid starts -->
														
																<%
																long sNo	=	0;
																String 	strCandidateLoginId		=null;
																String 	sCandidateEmpId		=null;
					
																String 	strStudentName		=null;
																long lResultId=0;
																
																while(result.next())
																{
																		sNo++;
																		
																		strCandidateLoginId=result.getString("stud_PRN");
																		strStudentName=result.getString("stud_F_Name");
																		
																		if(result.getString("stud_M_Name")!=null)
																			strStudentName=strStudentName+" "+result.getString("stud_M_Name");
																			
																		if(result.getString("stud_L_Name")!=null)
																			strStudentName=strStudentName+" "+result.getString("stud_L_Name");
																		
																		if(strStudentName==null)
																			strStudentName	=	"<div style='padding-left:160px;'>---</div>";	
																			
																		
																	%>
																		<tr  class="<%if(sNo%2==0){%>tdlightblue<%}else{%>tdblue<%}%>">
																			<td class="simple_row" style="width:44px;text-align:center;" ><%=sNo%>.</td>
																			<td class="simple_row" style="<%if(lTotalRows<=20){%>width:173px;<%}else{%>width:177px;<%}%>text-align:center;">&nbsp;<%=strCandidateLoginId%></td>
																			<td class="simple_row" align="center" style="<%if(lTotalRows<=20){%>width:434px;<%}else{%>width:447px;<%}%>padding:0px 0px 0px 0px;text-align: justify">&nbsp;&nbsp;<%=strStudentName%></td>
																			<td class="simple_row" align="center" style="<%if(lTotalRows<=20){%>width:44px;border-right:1px solid white<%}else{%>width:30px;<%}%>padding:0px 0px 0px 0px;">
																				<input type="checkbox"  value="<%=strCandidateLoginId%>" name="chkSelectCandidate" id="chkSelectCandidate<%=sNo%>">
																			</td>
																		</tr>
																	
																<%}
												
																
																if(result!=null)
																	result.close();/**closing the resultset*/
																			
																if(pstmt!=null)
																	pstmt.close();/**closing the statement*/
																
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
																	
										</table><!-- Data grid ends -->
										</form>
									</div><!-- div inner table grid ends -->
									<table  align="center" class="" style="width:700px;height:20px;" cellspacing="0"><!-- Data grid starts -->
										<tr  id="tblheader">
												<th colspan="5" align="left" style="height: 10px;border-right:1px solid white;border-left:1px solid white;border-right:1px solid white;border-bottom:1px solid white">&nbsp;<%=sNo%><%if(sNo==1){%> Record<%}else{%> Records<%}%></th>
										</tr>
									</table>
															
							</div><!-- div datagrid ends -->	
							<br>
							<div align="center">
								<!-- <input class="button" type="button" value="Unblock" id="btnUnblock" name="btnUnblock" onclick="unblockSelectedUsers('<%=sNo%>');"> --><!-- cmt becoz function not working -->
								<input class="button" type="button" value="Reset" id="btnReset" name="btnReset" onclick="resetAll('<%=sNo%>');">
							</div>	
							
							
							
								
					</div><!-- div result page ends -->
			<br>
			
	<!-- divResultpage ends -->
			<%if(session.getAttribute("snMsgCandidateUnBlock")!=null)
			{
				session.removeAttribute("snMsgCandidateUnBlock");
			}
			}//if rows=0 ie resultset count = 0
			else{ //if rows are zero and date is selected
				%><div class="message_directions" id="div_message_no_results" style="margin:20px 0px 0px 0px;text-align:center">
					<br><br>No records found.
				</div><%
			}
			%>
		<%}//if checking both drps are selected ends %>
	
				<div class="message_directions" id="div_message_module_sel" style="margin:20px 0px 0px 0px;text-align:center;display:none;">
					<br><br>Please select module
				</div>
				
		    </div><!-- Work area ends -->
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
	<%
	{
		String strModuleDrpIdForSet = null;
		if(session.getAttribute("snModuleDrpId")!=null)
			strModuleDrpIdForSet=session.getAttribute("snModuleDrpId").toString();
	
		%>
				<script type="text/javascript">
					document.getElementById('drp_module_name').selectedIndex='<%=strModuleDrpIdForSet%>';	
					document.getElementById('txtModuleDrpId').value='<%=strModuleDrpIdForSet%>';	
					
				</script>
		<%
	}//end else if%>
<%}
}%>
<div style="clear: both;"></div>
</div>	
</body>
</html>