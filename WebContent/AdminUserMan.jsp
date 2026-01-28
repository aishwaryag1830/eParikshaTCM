<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="in.cdac.acts.connection.DBConnector"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" session="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

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
	<!--
	@author Ritesh Dhote
	@author Sherin Mathew
	@date 24-05-2012  
	This is the User Management page for Admin -->
	<head>
	
	
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<link rel="stylesheet" href="Css/style.css" type="text/css">
		<script type="text/javascript" src="jquery-1.3.1.min.js"></script>
		<script type="text/javascript" src="Js/AdminMenu/MenuBar.js"></script>
		<script type="text/javascript">javascript:window.history.forward(1);</script>
		<title>AdminHome [ePariksha] </title>	
	

	<script type="text/javascript" src="validate.js"></script>
	<script type="text/javascript" src="Js/updateUser.js"></script>
	
	<link rel="stylesheet" type="text/css" media="all" href="jsDatePick_ltr.min.css" />
	<script type="text/javascript" src="jsDatePick.min.1.3.js"></script>
	<script type="text/javascript" src="Js/AdminUserMan.js"></script>
	<style type="text/css">
	
	.adminFormRow 
	{
		height: 42px;
	}
	
	
	</style>
	
	</head>
	
	<body>
	<script type="text/javascript"> 
		window.onload = function(){
		g_Sch=new JsDatePick({			
			useMode:2,
			target:"idTxtDOB",
			dateFormat:"%d/%m/%Y",
			yearsRange:new Array(1950,2100),
	        limitToToday:true,
	       
		});
		MM_swapImage('Image6','','images/index_18_a.gif',1);
		};
		
	</script>
	
	<%
		
		if(session.getAttribute("UserId")==null || session.getAttribute("UserName")==null)
		{
			%>
			<jsp:forward page="index.jsp"></jsp:forward>
		<%
		}
		else
		{
			String strUserId = session.getAttribute("UserId")
							.toString();
					String strUserName = session.getAttribute("UserName")
							.toString();
					/**
					 * variables for displaying user information
					 * */

					String strCCFName = "";
					String strCCMName = "";
					String strCCLName = "";
					Long lUserID = 0l;
					String strPass = "";
					String strRoleName = "";
					String strCourseName = "None";
					String strEMailId = "";
					String strMNumber = "";
					String strDOB = "";
					String strGender = "";
					int strExaminerID = 0;

					/** for Connection */
					DBConnector dbConnector = null; //Creating object of DBConnector class to make database connection.
					Connection connection = null;
					PreparedStatement statement = null;
					ResultSet result = null;
					
					/** Making connection*/
					String strDBDriverClass = session.getAttribute(
							"DBDriverClass").toString();
					String strDBConnectionURL = session.getAttribute(
							"DBConnectionURL").toString();
					String strDBDataBaseName = session.getAttribute(
							"DBDataBaseName").toString();
					String strDBUserName = session.getAttribute("DBUserName")
							.toString();
					String strDBUserPass = session.getAttribute("DBUserPass")
							.toString();

					dbConnector = new DBConnector();
					connection = dbConnector.getConnection(strDBDriverClass,
							strDBConnectionURL, strDBDataBaseName,
							strDBUserName, strDBUserPass);
					String sRoleId	=	session.getAttribute("UserRoleId").toString();
					
						
					if (request.getParameter("selCCID") != null) {
						// To put selected examiner id in request parameter or request attribute
						
						 
							int user_course_id=0;
							
							if(request.getParameter("selCCID") != null)
							{
								strExaminerID = Integer.parseInt(request.getParameter("selCCID"));
							}
							
							else
							{
								strExaminerID = 0;
							}
							
							statement=connection.prepareStatement("select user_Course_Id from ePariksha_User_Master where user_Id=?");
							statement.setInt(1,strExaminerID);
							result=statement.executeQuery();
								while(result.next()){
								user_course_id=result.getInt("user_Course_Id");
							}
							if(result!=null)
								result.close();
							if(statement!=null)
								statement.close();
							
						String query=null;
						
						if(user_course_id==0){
							query="select user_Id,user_Password,user_F_Name,user_M_Name,user_L_Name,user_Email_Id,user_M_Number,to_char(user_DOB, 'DD/MM/YYYY') as user_DOB,user_Gender from ePariksha_User_Master where user_Id=?";
						}
						else
						{
							query="select user_Id,user_Password,user_F_Name,user_M_Name,user_L_Name,user_Email_Id,user_M_Number"
										+ " ,to_char(user_DOB, 'DD/MM/YYYY') as user_DOB,user_Gender"
										+ " ,course_Name from ePariksha_User_Master,ePariksha_Courses"
										+ " where user_Id=? and  course_Id = user_Course_Id";
						}
						statement = connection.prepareStatement(query);						
						statement.setInt(1, strExaminerID);
						result = statement.executeQuery();
						if (result.next()) {
							lUserID = result.getLong("user_Id");
							strPass = result.getString("user_Password");
							strCCFName = result.getString("user_F_Name");
							strCCMName = result.getString("user_M_Name");
												
							if(strCCMName.equalsIgnoreCase("")){
								strCCMName="  --";
							}
							strCCLName = result.getString("user_L_Name");
							strEMailId = result.getString("user_Email_Id");
							strMNumber = result.getString("user_M_Number");
							strDOB = result.getString("user_DOB");
							strGender = result.getString("user_Gender");
							if(user_course_id==0){
								strCourseName="None";
							}
							else{
							strCourseName = result.getString("course_Name");
							}
						}
						if (statement != null)
							statement.close();
						/**closing the statement*/

					}

			/**
				If trying to come to this page from other user redirect it to index page*/
			
			if(!sRoleId.equals("999"))//If trying to come to this page from other user redirect it to index page
			 {%><jsp:forward page="index.jsp"></jsp:forward>
			 <%}%>
			
		
	
	
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
	              <td align="center" valign="middle"><a href="javascript:void(0);" style="cursor:default;" ><img src="images/index_18.gif" alt="Users" name="Image6" width="100" height="37" border="0" id="Image6" /></a></td>
	            <td align="center" valign="middle"><a href="Courses.jsp" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image7','','images/index_19_a.gif',1)"><img src="images/index_19.gif" alt="Courses" name="Image7" width="100" height="37" border="0" id="Image7" /></a></td>
	            <td align="center" valign="middle"><a href="ResultsAdmin.jsp" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image8','','images/index_20_a.gif',1)"><img src="images/index_20.gif" alt="Results" name="Image8" width="100" height="37" border="0" id="Image8" /></a></td>
	            <td align="center" valign="middle"><a href="Reports.jsp" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image9','','images/index_21_a.gif',1)"><img src="images/index_21.gif" alt="Reports" name="Image9" width="100" height="37" border="0" id="Image9" /></a></td>
	            <td align="center" valign="middle"><a href="AdminProfile.jsp" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image10','','images/index_22_a.gif',1)"><img src="images/index_22.gif" alt="Profile" name="Image10" width="100" height="37" border="0" id="Image10" /></a></td>
	            
	          </tr>
	        </table>
        </div>
        <!-- Menu Bar ends -->
        
      
      <div id="workArea"><!-- work area begins -->
      	<br>
      	
		
		<div id="header_Links" align="left" style="width:800px;margin-top:5px;">
					<div style="float:left;padding-top:5px;padding-left:5px; width: 220px">
						<img style="width:22px;height:22px;" src="images/CandidateProfiles.png">
						<label class="pageheader" >User Management</label>
					</div>
					<div id="" align="right" style="float:right; width: 300px;">
						<img style="height: 25px;width: 30px" src="images/new_user.png">
						<a href="#" onclick="adminNewUser();" id="anchornewuser">New User</a>
					</div>
					<div style="clear:both;"></div>
		</div>
				
				<div id="table_outer" >
						
				<table align="center" width="100%">
					<tr><td>
					
									
					</td></tr>
					<tr><td></td></tr>
					<tr><td>	
					<form name="frmCCSelect" action="AdminUserMan.jsp" method="post">
					
					<table align="center" width="660px" border="0" id="" class="tblstyle">
								<tr>
								 
								<!--  Space holder -->
								
								<td align="left" width="165px" class="tdblue" colspan="2"><b>Select User</b></td>
								<td width="475px">								
								<table border="0" >
								<tr>
								 
								<td width="170px" class="tdlightblue" style="padding-left: 0px;">
								<select id="CCID" name="selCCID" onchange="sendCCID();">
								<option value="0">[User ID] Name</option>
								
								<%
									// To retrive presently active users to modify
											String strDisplayName = null;
											String strCourseTitle = null;
											Long lUserId = 0l;
											
											statement = connection.prepareStatement("SELECT user_Id,user_F_Name,user_M_Name,user_L_Name,user_Role_Id,user_Email_Id,user_Course_Id FROM ePariksha_User_Master where user_Role_Id not like('999') and user_Role_Id not like('000')");
															
											/*statement = connection
													.prepareStatement("SELECT user_Id,user_F_Name,user_M_Name,user_L_Name,user_Role_Id,"
															+ "user_Email_Id,course_Short_Name,course_Name FROM ePariksha_User_Master,"
															+ "ePariksha_Courses where user_Role_Id not like('999') and  course_Id = user_Course_Id");*/

											result = statement.executeQuery();
											while (result.next()) {
												strDisplayName = "";
												strCourseTitle = "";
												lUserId = result.getLong("user_ID");
												strDisplayName = "[" + lUserId + "] "
														+ result.getString("user_F_Name") + " "
														+ result.getString("user_M_Name") + " "
														+ result.getString("user_L_Name");
												/*strCourseTitle = "["
														+ result.getString("course_Short_Name") + "]"
														+ result.getString("course_Name");*/
								%>
								
								<option  value="<%=lUserId%>" ><%=strDisplayName%></option>
								
								<%
								}
									if(result!=null)
										result.close();
									if (statement != null)
										statement.close();
									
																%>
								
								
								</select>
								
								</td>
								
								<td width="225px" class="tdlightblue">
									
									<input class="button" type="button" id="idBtnResetPass" value="Reset Password" onclick="resetPass()" style="margin-left: 10px" />
								</td>
								<td width="100px" id="idResetStatus" class="tdlightblue">&nbsp;</td> 
								</tr>
								</table>
								</td></tr>
					</table>
					<div style="padding-top: 20px;"><img src="images/separator.gif" width="100%;" height="1px"></img></div>
					
					 
						</form>
					
					</td></tr>
				
					<tr><td></td></tr>
					<tr>
						<td align="center">
						<form name="frmmessages">
						<div style="height: 20px" id="IdSeMsgContainer">
							<div id="IdSeMsg"  style="color: red;height:20px;width: 630px;padding-left: 0px;" align="center">
													
							<%if(session.getAttribute("seErrorMsg")!=null){%>
							<%=session.getAttribute("seErrorMsg")%>
							<%}session.removeAttribute("seErrorMsg"); %>		
							<script type="text/javascript">
								killThis("IdSeMsg");
							</script>				
						
							</div>
						</div>
						
						</form>	
						<!-- User information table  -->
						
						
						<form name="frmProfile" action="" method="post" onsubmit="" >
						
							<div class="message_directions" style="display: block;width: 630px;height: 200px;padding-top: 120px;" id="welcomemsg">								
										Please select user
							</div>
							
							<table align="center"
								style="margin-top: 6px; margin-bottom: 10px; vertical-align: middle;display: none;"
								border="0" id="tableStyle" class="tblstyle" width="660px" height="250px" >
								
								<tr height="29px">
									<td align="left" width="180px" class="tdblue"><b>First Name</b>
									</td>
									<td align="left" width="510px" class="tdlightblue"><input type="text" id="idTxtFName" name="txtFName" 
										value="<%=strCCFName%>" maxlength="30" disabled="disabled" onkeypress="return checkAlpha(event);" style="text-decoration: none;" />
									</td>
									
								</tr>
								<tr height="29px">
									<td align="left" class="tdblue"><b>Middle Name</b>
									</td>
									<td align="left" class="tdlightblue"><input type="text" id="idTxtMName" name="txtMName"
										value="<%=strCCMName%>" maxlength="30" disabled="disabled" onkeypress="return checkAlpha(event);"/>
									</td>
									<td class="error" class="tdlightblue">  </td>
								</tr>
								<tr height="29px">
									<td align="left" class="tdblue"><b>Last Name</b>
									</td>
									<td align="left" class="tdlightblue"><input type="text" id="idTxtLname" name="txtLName" width=140
										value="<%=strCCLName%>" maxlength="30" disabled="disabled" onkeypress="return checkAlpha(event);"/>
									</td>
									<td class="error" class="tdlightblue">  </td>
								</tr>
								
								<tr height="29px">
									<td align="left" class="tdblue"><b>Date Of Birth</b>(dd/mm/yyyy)</td>
									<td align="left" class="tdlightblue">
									<input type="text" value="<%=strDOB%>" id="idTxtDOB" name="txtDOB" 
									  maxlength="10" />
									</td>
									<td class="error" class="tdlightblue">  </td>
								</tr>
								<tr height="29px">
									<td align="left" class="tdblue"><b>e-Mail ID</b>
									</td>
									<td align="left" valign="top" class="tdlightblue"> <!--<input name="txtEMail"
										readonly="readonly" type="text" value="<%=strEMailId%>"
										class="inputText_No_border"></input>-->
										<input type="text" value="<%=strEMailId%>" id="idTxtEmail" name="txtEmailId" 
										disabled="disabled" maxlength="30" onkeypress="return checkEmail(event);" />
										</td>
										<td class="error" class="tdlightblue">  </td>
								</tr>
								<tr height="29px">
									<td align="left" class="tdblue"><b>Contact No.</b>
									</td>
									<td align="left" valign="top" class="tdlightblue"><!-- <input name="txtMNumber"
										readonly="readonly" type="text" value="<%=strMNumber%>"
										maxlength="10" class="inputText_No_border"></input> -->
										<input type="text" value="<%=strMNumber%>" id="idTxtContactNo" name="txtContactNo"
										disabled="disabled" maxlength="10" onkeypress="return checkContactNo(event);" />
										</td>
									<td class="error" class="tdlightblue">  </td>
								</tr>

								<tr height="29px">
									<td align="left" class="tdblue"><b>Gender</b>
									</td>
									<td align="left" class="tdlightblue" id="fontcolorblack">
									<input id="idGenderM"  disabled="disabled" name="gender" type="radio" value="Male" <%=strGender.equals("Male")?"Checked=true":""%>/>Male
									<input id="idGenderF" disabled="disabled" name="gender" type="radio" value="Female" <%=strGender.equals("Female")?"Checked=true":""%> />Female
									
									 </td>
									 <td class="error" class="tdlightblue">  </td>
								</tr>
								<tr height="29px">
									<td align="left" class="tdblue"><b>For Course</b>
									</td>
									<td height="29px" align="left" colspan="2" class="tdlightblue"> <div id="idCourseNameBanner" ><%=strCourseName%></div>
									</td>
									
								</tr>
								<tr><td></td><td>
								
								<input type="hidden" name="hidCCID" value="<%=strExaminerID %>" />
								
								
								</td>
								<td class="error">  </td>
								</tr>
							</table>
							
						</form>
						</td>
					</tr>
					<tr>
					<td>
						
					</td>
					</tr>
					<tr align="center" >
					<td align="center" height="60px">
					<table>
					<tr align="center">
					
					<td id="">
						
						
					</td>
					<td id="saveRow"  style="display: none;">
						<input type="button" value="Save" class="button"  
						style="margin-top: 10px;margin-bottom: 20px;margin-right: 20px;" 
						onclick="adminSaveUpdate('0');" />
					</td>
					<td id="editRow" align="center" style="display: none;">
							<input type="button" id="idBtnEdit" name="btnEdit" value=" Edit " class="button"  
							title="Click to edit contact info" style="margin-top: 10px;margin-bottom: 20px;margin-right: 20px;"
							 onclick="AdminEditInfo();"/>
					</td>
					<td id="updateRow" align="center" style="display: none;">
							<input type="button" name="btnUpdate" value="Update" class="button" 
								title="Click to Update contact info"  style="margin-top: 10px;margin-bottom: 20px;margin-right: 20px;" onclick="updateUserData();"/>
							
					</td>
					<td id="cancleRow" style="display: none;">
							<input type="button" name="btnCancel" id="btnCancel" value="Cancel" class="button" title="Cancel"
								onclick="AdminCancel();" style="margin-top: 10px;margin-bottom: 20px;"/>
					</td>
					</tr>
					</table>
					
					
					
					</td>
						
					</tr>
					<tr>
						
					</tr>
				</table>
		
		
				
				<!-- end of the code -->
		
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
	</div>
	</body>
	<%
	if (request.getParameter("selCCID") != null)
	{
	
	%>
	<script type="text/javascript">
	document.getElementById('CCID').value=<%=request.getParameter("selCCID")%>;
	document.getElementById("editRow").style.display="inline";
	</script>
	<%
	}
	else if(request.getAttribute("selCCID")!=null)
	{
		
	%>
	<script type="text/javascript">
	document.getElementById('CCID').value=<%=request.getAttribute("selCCID").toString()%>;
	document.getElementById("editRow").style.display="inline";
	</script>
	<%
	}
	else{}
	
			 /* Closing the database connection on dbConnector.
			 **/
			if (dbConnector != null) {
				dbConnector.closeConnection(connection);
				dbConnector = null;
				connection = null;
			}

		}
	}
%>

<script type="text/javascript">
	var val=document.getElementById("CCID").value;	
	
	var inputArray = document.frmProfile.getElementsByTagName("input");
		if(val!=0)
			{
				document.getElementById('tableStyle').style.display="block";
				document.getElementById('welcomemsg').style.display='none';
				document.getElementById('cancleRow').style.display="inline";
			
				i=0;
			while(i<inputArray.length)
			{
			
				inputArray [i].setAttribute("class","transparent");
				inputArray [i].setAttribute("className","transparent");
				inputArray [i].style.color="black";
				inputArray [i].setAttribute("className","fontcolorblack");			
				i++;
			}
		}
		//document.getElementById('CCID').selectedIndex=0;
		
		if(document.getElementById("idBtnResetPass").disabled){
			document.getElementById('IdSeMsg').innerHTML="";
			document.getElementById('tableStyle').style.display="none";
			document.getElementById('welcomemsg').style.display="block";
			document.getElementById('editRow').style.display="none";
			document.getElementById('cancleRow').style.display="none";
		}
		
		//AdminCancel();
</script>

	

<%
	
	session.removeAttribute("ExamDate");
%>


</html>
