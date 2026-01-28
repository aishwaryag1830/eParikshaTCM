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
	<!--
	@author Ritesh Dhote
	@author Sherin Mathew
	@date 24-05-2012  
	This is the Profile page of Admin -->
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<link rel="stylesheet" href="Css/style.css" type="text/css">
		<title>AdminProfile [ePariksha] </title>
		<script type="text/javascript">
			javascript:window.history.forward(1);
		</script>
		<script type="text/javascript" src="validate.js"></script>
		<script type="text/javascript" src="Js/AdminProfile.js"></script>
		<script type="text/javascript" src="Js/AdminMenu/MenuBar.js"></script>
		<script type="text/javascript" src="jquery-1.3.1.min.js"></script>	
		<link rel="stylesheet" type="text/css" media="all" href="jsDatePick_ltr.min.css" />
		<script type="text/javascript" src="jsDatePick.min.1.3.js"></script>
		<style type="text/css">
		.ErMsg
		{
		height :20px;
		color	: red;
		font-size: 12px;
		}
		</style>
			
	</head>
	<body onload="MM_swapImage('Image10','','images/index_22_a.gif',1);">
	<script type="text/javascript"> 
		window.onload = function(){
		g_Sch=new JsDatePick({			
			useMode:2,
			target:"idtxtDOB",
			dateFormat:"%d-%m-%Y",
			yearsRange:new Array(1950,2100),
	        limitToToday:true,    
		});
		};
		
	</script>
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
					
			statement=connection.prepareStatement( "select user_Email_Id,user_M_Number"+
				" ,to_char(user_DOB, 'DD-MM-YYYY') as user_DOB,user_Gender"+
				" from ePariksha_User_Master"+
				" where user_Id=? and ePariksha_User_Master.user_Role_Id='999'");
	
			statement.setLong(1, Long.parseLong(strUserId));
			result=statement.executeQuery();
			if(result.next())
			{
				strEMailId = result.getString("user_Email_Id");
				strMNumber = result.getLong("user_M_Number");
				strDOB = result.getString("user_DOB");
				strGender = result.getString("user_Gender");
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
						<li id="liUserName" style="padding-top:5px;color: #1C89FF;"><%=strUserName%></li>
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
        <!-- Menu Bar Begins -->
        <div align="left" style="margin-left:25px;">
	 
	        <table width="600px" border="0" cellspacing="0" cellpadding="0">
	          <tr>
	            
	            <td align="center" valign="middle"><a href="AdminHome.jsp" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image5','','images/index_17_a.gif',1)"><img src="images/index_17.gif" alt="Home" name="Image5" width="100" height="37" border="0" id="Image5" /></a></td>
	              <td align="center" valign="middle"><a href="AdminUserMan.jsp" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image6','','images/index_18_a.gif',1)"><img src="images/index_18.gif" alt="Users" name="Image6" width="100" height="37" border="0" id="Image6" /></a></td>
	            <td align="center" valign="middle"><a href="Courses.jsp" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image7','','images/index_19_a.gif',1)"><img src="images/index_19.gif" alt="Courses" name="Image7" width="100" height="37" border="0" id="Image7" /></a></td>
	            <td align="center" valign="middle"><a href="ResultsAdmin.jsp" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image8','','images/index_20_a.gif',1)"><img src="images/index_20.gif" alt="Results" name="Image8" width="100" height="37" border="0" id="Image8" /></a></td>
	            <td align="center" valign="middle"><a href="Reports.jsp" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image9','','images/index_21_a.gif',1)"><img src="images/index_21.gif" alt="Reports" name="Image9" width="100" height="37" border="0" id="Image9" /></a></td>
	            <td align="center" valign="middle"><a href="AdminProfile.jsp" style="cursor:default;"><img src="images/index_22.gif" alt="Profile" name="Image10" width="100" height="37" border="0" id="Image10" /></a></td>
	            
	          </tr>
	        </table>
        </div>
        <!-- Menu Bar ends -->
        
      
      <div id="workArea"><!-- work area begins -->
      	
		<div style="padding-top:10px;padding-left:5px; width: 220px">
					<img style="width:22px;height:22px;" src="images/Profile.png">
					<label class="pageheader" >Profile</label>					
		</div>	
		
			<form name="frmProfile" action="#" method="post" onsubmit="return updateContact();">
				<div id="ProfMsg" style="margin-left: 200px;margin-right: 200px;height: 20px;" align="center" class="ErMsg">
				<div id="tokill" style="color: red; display: none;float: left;">&nbsp;</div>
				<div id="tokillpass" style="color: red; display: none;">&nbsp;</div>
				</div>
				<table width="100%">
					<tr valign="top">
						<td>
						 <table width="100%">
						 	<tr valign="top">
						 		<td width="55%" style="border-right: 1px solid #BA3C3C">
						 <table align="center" style="margin-top: 0px;margin-bottom: 0px;" width="90%" class="tblstyle">
								
								<tr id="tblheader" style="text-align: left;" height="25px">
									<td colspan="2" >
										<label class="lblstyle" style="padding-left: 5px;float: left;">Profile</label>
									</td>
								</tr>	
								<tr height="25px">
									<td align="left" height="10px" class="tdblue" style="padding-left: 5px;" width="40%"><label class="lblstyle">User Id</label></td>
									<td align="left" height="10px" class="tdlightblue"><%=strUserId%></td>
								</tr>
								<tr  height="25px">
									<td align="left" height="20px" style="padding-left: 5px;" class="tdblue">
										<label class="lblstyle">Name</label></td>
									<td align="left" class="tdlightblue" height="20px"><input  name="txtName"  readonly="readonly" type="text" value="<%=strUserName%>"  class="inputText_No_border" maxlength="40"></input></td>
								</tr>
								<tr height="25px">
									<td align="left" style="padding-left: 5px;" class="tdblue"><label class="lblstyle">e-Mail ID</label></td>
									<td align="left" valign="top" class="tdlightblue">
										<input  name="txtEMail"  readonly="readonly" type="text" value="<%=strEMailId%>" onkeypress="return checkEmail(event);" class="inputText_No_border" maxlength="80"></input>
									</td>
								</tr>
								<tr height="25px">
									<td align="left" style="padding-left: 5px;" class="tdblue"><label class="lblstyle">Contact No.</label></td>
									<td align="left" valign="top" class="tdlightblue"> 
										<input name="txtMNumber" readonly="readonly" type="text" value="<%=strMNumber%>" onkeypress="return checkContactNo(event);" maxlength="10" class="inputText_No_border"></input>
									</td>
								</tr>
								
								<tr  height="25px"><td align="left" class="tdblue" style="padding-left: 5px;"><label class="lblstyle">Gender</label></td><td align="left" class="tdlightblue"> 
									<div id="ShowGender" style="display:none">Male<input id="idGenderM"  disabled="disabled" name="gender" type="radio" value="Male" <%=strGender.equalsIgnoreCase("Male")?"Checked":""%>/>
									Female<input id="idGenderF" disabled="disabled" name="gender" type="radio" value="Female" <%=strGender.equalsIgnoreCase("Female")?"Checked":""%> />	</div>
									<div id="ShowGenderData" style="display:inline;color:#2F4F4F;padding-left:1px"><%=strGender%></div>
								</td></tr>
								
								<tr  height="25px"><td align="left" style="padding-left: 5px;" class="tdblue"><label class="lblstyle">Date Of Birth<br/>(DD-MM-YYYY)</label></td>
								<td align="left" class="tdlightblue"><input  name="txtDOB" id="idtxtDOB" readonly="readonly" type="text" class="inputText_No_border" value="<%=strDOB%>"  maxlength="10"></input></td></tr>
								
								<tr>									
								</tr>							
							</table>
							
							<div style="margin-left: 20px;margin-right: 20px;height: 50px;padding-left: 90px;" align="center" id="editRow">
								<input type="button" name="btnUpdate" id="btnUpdate" value="Update" class="button" 
									title="Click to Update contact info"  style="float:left; margin-top: 10px;margin-bottom: 20px;display: none;" onclick="adminChangeContact()">
								<input type="button" name="btnEdit" id="btnEdit" value=" Edit " class="button" 
										title="Click to edit contact info" style=" margin-top: 10px;margin-bottom: 20px;float:left; display: block" onclick="goEditInfo();"></input>
								<input type="button" name="btnCancel" id="btnCancel" value="Cancel" disabled="disabled" class="button" title="Cancel"
									onclick="admingoCancel();" style="margin-left: 0px;margin-top: 10px;margin-bottom: 20px;display: inline;float: left;margin-left:10px;"></input>															
								<input type="hidden" name="hidName" value="<%=strUserName%>"/>
								<input type="hidden" name="hidEmail" value="<%=strEMailId%>"/>
								<input type="hidden" name="hidContact" value="<%=strMNumber%>"/>
								<input type="hidden" name="hidGender" value="<%=strGender%>"/>
								<input type="hidden" name="hidDOB" value="<%=strDOB%>"/>
							</div>			
							</td><td width="50%">
							<table align="center" style="margin-top: 0px;margin-bottom: 10px;" width="90%" class="tblstyle">
																					
								<tr id="tblheader" style="text-align: left;">
								<td colspan="2"><label class="lblstyle" style="padding-left: 5px;">Security</label></td>
								</tr>
															
								<tr height="25px">
									<td align="left" style="padding-left:5px;" class="tdblue">
										<label class="lblstyle">Present Password</label>
									</td>
									<td align="left" class="tdlightblue"> <input onkeypress="return checkPass(event)" id="idOldPass" type="password" name="txtPass" style="margin-left: 5px;" /></td></tr>
								<tr height="25px"><td align="left" style="padding-left:5px;" class="tdblue"><label class="lblstyle">New Password</label></td><td align="left" class="tdlightblue"> <input onkeypress="return checkPass(event)" id="idNewPass" type="password" name="txtRePass" style="margin-left: 5px;"/></td></tr>
								<tr height="25px"><td align="left" style="padding-left:5px;" class="tdblue"><label class="lblstyle">Re-Enter Password</label></td><td align="left" class="tdlightblue"> <input id="idReNewPass" type="password" name="txtRePass" style="margin-left: 5px;" /></td></tr>
								<tr height="25px">
								<td style="padding-top: 20px;"></td>
								</tr>
							</table>
							<div style="margin-left: 20px;margin-right: 20px;" align="center">
								<input type="button" onclick="ChangePass()" class="button" value="Save" />
								<input class="button" type="reset" value="Clear" style="margin-left: 7px;">
							</div>

							</td></tr></table>
						</td>
					</tr>
					
					
				</table>
			</form>
		</div><!-- work area ENDS -->
	<script type="text/javascript">
	var PreEmail 	= document.frmProfile.txtEMail.value;
	var PreMno		= document.frmProfile.txtMNumber.value;
	
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
<%}
}
session.removeAttribute("ExamDate");
%>
</html>