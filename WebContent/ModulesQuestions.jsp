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
	@author Sherin Mathew
	@date 24-05-2012  
	This is the page of for displaying module information -->
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<link rel="stylesheet" href="Css/style.css" type="text/css">
	<title>ModulePage [ePariksha] </title>
   	<script type="text/javascript" src="validate.js"></script>
	<script type="text/javascript" src="Js/modules.js"></script>
	<link rel="stylesheet" href="Js/modalfiles/modalDiv.css" type="text/css">
	<script type="text/javascript" src="Js/modalfiles/modalDiv.js"></script>

	<script type="text/javascript">
		javascript:window.history.forward(1);
	</script>
	<script type="text/javascript">
		function goAddModuleView(e)
		{
			if(e==1)
			{
				document.getElementById("add_module_back").style.display="none";
				document.getElementById("add_module").style.display="table-row";
			}
			else
			{
				document.getElementById("add_module").style.display="none";
				document.getElementById("add_module_back").style.display="table-row";
			}
		}
	</script>
	</head>

	<%
		
		if(session.getAttribute("UserId")==null || session.getAttribute("UserName")==null || session.getAttribute("CourseId")==null)
		{
		%>
			<jsp:forward page="index.jsp"></jsp:forward>
		<%
		}
		else
		{
			String strUserId			=session.getAttribute("UserId").toString();
			String strUserName			=session.getAttribute("UserName").toString();
			String strCourseId			=session.getAttribute("CourseId").toString();
			String sExaminerId			=null;
			String strCourseName		=null;
			
			/*Fetching examiner id for gathering course related information*/
			if(session.getAttribute("sActualExaminerId")!=null)
			{
				sExaminerId	=	session.getAttribute("sActualExaminerId").toString();
			}
			else//if examiner logins ie no switch course then
			{
				sExaminerId	=	strUserId;
			}
			
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
			
			
			
			
			statement=connection.prepareStatement("select course_Name from ePariksha_Courses where course_Id=? and course_CC_Id=?");
			statement.setInt(1, Integer.parseInt(strCourseId));
			statement.setInt(2, Integer.parseInt(sExaminerId));//Examiner id is used to fetch the correct course info based on examiner not Admin
			result=statement.executeQuery();
			if(result.next())
				strCourseName=result.getString("course_Name");
			if(statement!=null)
				statement.close();/**closing the statement*/ 
				
			
			
		%>
			
<body>
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
      <div id="header_Links" align="left" style="width:770px;margin-top:5px;">
				
				<div style="padding-top:5px;padding-left:5px; width: 220px">
					<img style="width:22px;height:22px;" src="images/Modules.png">
					<label class="pageheader" >Modules Information</label>
				</div>
					
		</div>
			<!-- Message Modal div Begins d-->
								<div id="modalExamCheckPage" style="top" >
								
								    <div class="modalExamCheckBackground">
								    </div>
								    <div class="modalExamCheckContainer" >
								        	<div class="modalExamCheck" style="width:550px;height:300px;position: relative;top:-150px;left:-90px;">
										            <div class="modalExamCheckTop" style="width:100%;"> 
														<table style="border-collapse: collapse; width: 100%;height:100%" cellpadding="0" cellspacing="0" >
															<tr>
															<td style="padding-left:5px;font:normal 10pt Arial;"  align="left"><b>Message</b>
															</td>
															<td style="padding-right:5px; width: 44px;" align="right"><a style="color:#FFFFFF;" href="javascript:hideViewer('modalExamCheckPage');">[X]</a>
															</td>
															</tr>
														</table>
													</div>
										            
													<div align="center" style="width:100%;height:100%;" id="modalExamCheckContent" class="modalExamCheckBody">
														 <br><img align="middle" src="images/stop.png" >
														 
														 <div class="message_directions" align="justify" style="width:500px;overflow-y:auto;font:normal 15pt Arial;" id="divCentres">
														 	This is found that the exam is scheduled for today.
														 	<br>Modifying question repository can disturb the exam. 
														 	<br>Do you still want to continue?
														</div>
													 	<br><input class="button" type="button" value="Yes" onclick="javascript:frmSubmit();">
													 	<input class="button" type="button" value="No" onclick="javascript:hideViewer('modalExamCheckPage');">
													</div>
								        	</div>
								    </div>
								</div><!-- Message Modal div Ends -->
			
			
			<br>
			
			<div>
					<div style="margin: 10px 0px 0px 10px; width: 670px;float: left; " ><label class="lblstyle">Course :  </label> <%=strCourseName%></div>
					<div id="divNumberOfModules" style="float: right;width: 110px;margin:10px 3px 0px 0px;" ></div>
					<div style="clear: both;"></div>
			</div>
			
			<div style="width: 750px;height: 10px;margin-top: 15px;">
				<img alt="" src="images/separator.gif" style="width: 800px;height: 1px;">
			
			</div>
				<form id="frmEditModule"  name="frmEditModule" action="UpdateModule.pks" method="post">
				
						
									<div style="font-size: 24px;font-weight: bolder;"></div>
							
						
							
									<div id="ShowMessage" style="height:8px"></div>
									
						
						<%
					
						
							statement=connection.prepareStatement("select module_Id,module_Name from ePariksha_Modules where module_Course_Id=?",
									ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
							statement.setInt(1, Integer.parseInt(strCourseId));
							result=statement.executeQuery();
							
							
							result.last();
							int iNoOfModule=result.getRow();
							result.first();
							result.previous();
						%>
						<%!
							private int getTotalNumberofQuestions(String strCourseId,String module_id,Connection connection)
							{
																	int numberOfRows=0;
								
									try{
									/** for Connection */
																	
									PreparedStatement statement=null;
									ResultSet result=null;
									statement=connection.prepareStatement("select count(exam_Ques_Id)  as cnt from ePariksha_Exam_Questions where exam_Course_Id=? and exam_Module_Id=? ",
									ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
									statement.setInt(1, Integer.parseInt(strCourseId));
									statement.setLong(2, Long.parseLong(module_id));									
									result=statement.executeQuery();
									while(result.next()){
										numberOfRows=result.getInt("cnt");
										
									}
									
									}
									catch(Exception e){
										e.printStackTrace();
									}
								return numberOfRows;	
														
							}
						
						
						 %>
						
							<%if(iNoOfModule>0)
							{ %>
						
								<div style="min-height: 180px;min-width: 340px; max-width: 641px; width: 641px" >
									<table align="center"  cellspacing="0" id="add_module_table" class="tblstyle" style="margin-left: 80px;width: 641px;">
										<tr id="tblheader" style="height: 20px;">
											<th align="center"  style="height: 2px; width: 10px"><div style="width: 35px;">S.No.</div></th>
											<th align="center"  style="height: 3px;"><div style="width: 250px;">Modules</div></th>
											<th align="center"  style="height: 3px;"width="80px">Total Questions</th>
											<th align="center"  style="height: 3px; width: 80px">Ques. Repository</th>
										</tr>
										<%
										int iSNo=1;
										int numberOfQuestions;
										while(result.next())
										{
											numberOfQuestions=getTotalNumberofQuestions(strCourseId.trim(),result.getString("module_Id").trim(),connection);
										%>
										<tr class="<%if((iSNo%2)==0){%>even<%}else{ %>odd<%} %>">
											<td class="simple_row"  style="width: 35px;height: 24px;" align="center"><div style="padding-left: 5px;"><%=iSNo++%>.</div></td>
											<td class="simple_row" align="left" style="width: 200px; ">
												
											
												<div style="padding-left: 5px;max-width: 450px;">
													<%=result.getString("module_Name")%>
												</div>
											</td>
											<td class="simple_row" style="width: 10px; " align="center">
											<%=numberOfQuestions %>
											</td>
											<td class="simple_row" style="width: 51px; " align="center">
												<img onclick="javascript:document.getElementById('txtSelectedModuleId').value=this.id;ajaxOperations(this.id);" id="<%=result.getString("module_Id")%>" src="images/questions.png" onmouseover="this.style.cursor='pointer';"  style="height: 24px; width: 23px; " title="Go to Questions Repository"/>
											</td>
										</tr>
										<%}
										if(statement!=null)
											statement.close();
									
										%>
									</table>
									<script type="text/javascript">
										document.getElementById('divNumberOfModules').innerHTML="<label class='lblstyle'>Total modules  :  </label>"+<%=iSNo-1%>;
									</script>
									<input type="hidden" id="txtSelectedModuleId" name="txtSelectedModuleId">
														
								</div>
								<br/>
							
							<%}
							else
							{%>
							
								<div style="height: 150px;padding-top: 80px;" align="center" class="message_directions">
									No module information found
								</div>
							
							<%}
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
						
					</form>
				</div><!-- workarea ends -->
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