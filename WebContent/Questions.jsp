<%@ page language="java" contentType="text/html;charset=UTF-8 "
    pageEncoding="ISO-8859-15" session="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
 
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%> 
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.SQLException"%>
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
		<script src="Js/jquery-1.9.js"></script>
		<script type="text/javascript" src="Js/questions.js"></script>
 		<script type="text/javascript" src="Js/modalfiles/modalDiv.js"></script>
 			
 		
 		<link rel="stylesheet" href="Js/modalfiles/modalDiv.css" type="text/css" />
		<title>Question Repository [ePariksha] </title>
		<script type="text/javascript">
			javascript:window.history.forward(1);
		</script>
	 	<script type="text/javascript">
      		$(function() {
       			 var moveLeft = 20;
        		 var moveDown = 10;
        
        		$('a#trigger').hover(function(e) {
          		$('div#pop-up').show();
		          //.css('top', e.pageY + moveDown)
		          //.css('left', e.pageX + moveLeft)
		          //.appendTo('body');
       		    }, function() {
          		$('div#pop-up').hide();
        		});
       		 $('a#trigger').mousemove(function(e) {
          	 $("div#pop-up").css('top', e.pageY + moveDown).css('left', e.pageX + moveLeft);
            });  
      });
    </script>
	<style>
		/* HOVER STYLES */
      div#pop-up {
        display: none;
        position: absolute;
        width: 300px;
        padding: 10px;
        background: #eeeeee;
        color: #000000;
        border: 1px solid #B7B7B7;
        font-size: 100%;
      }
	</style>
	</head>
	<body >
		 <%	if(session.getAttribute("UserId")==null || session.getAttribute("UserName")==null)
		 	{
		 %>
	  <jsp:forward page="index.jsp"></jsp:forward>
		<%
			}
			else
			{
			String sRoleId	=	session.getAttribute("UserRoleId").toString();
		
			if(!sRoleId.equals("001"))//If trying to come to this page from other user redirect it to index page
		 	{
		%>
	 <jsp:forward page="index.jsp"></jsp:forward>
		<%}
				String strUserId	=session.getAttribute("UserId").toString();
				String strUserName	=session.getAttribute("UserName").toString();
			
			/**
			 * variables for displaying user information
			 * */
			
				String sModuleId		        =   null;
				String selectedModuleName		=   null;
				String sSelectedQuestionId	    =	null;
				String sScrollMenuDivPosition	=	null;
				int iIotalQuestionsUpperLabel	=	0;
				
				/*Fetch data from UpdateModules Page then set it in session for page workings on this page only*/
				if(request.getParameter("txtSelectedModuleId")!=null && !request.getParameter("txtSelectedModuleId").equals("") )
				{
					sModuleId	=	request.getParameter("txtSelectedModuleId");
					session.setAttribute("snSelectedModuleIdForQuestions",sModuleId);
				}
				else
					sModuleId	=	session.getAttribute("snSelectedModuleIdForQuestions").toString();//taken from above condition
				 
				 /** for Connection */
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
					
				pstmt=connection.prepareStatement("select"+ 
													" (select count(exam_Ques_Id) as totalQuestions from ePariksha_Exam_Questions where exam_Module_Id=?)"+
													", (select module_Name from ePariksha_Modules where Module_Id=?) as moduleName"+
													" from ePariksha_Modules"+
													" where module_Id=?",ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
				pstmt.setLong(1, Long.parseLong(sModuleId));
				pstmt.setLong(2, Long.parseLong(sModuleId));
				pstmt.setLong(3, Long.parseLong(sModuleId));
				
				result=pstmt.executeQuery();
				if(result.next())
				{
					selectedModuleName	=	result.getString("moduleName");
					session.setAttribute("snDestModuleName",selectedModuleName);//To CopyQuestions jsp for displaying there destination Module
					iIotalQuestionsUpperLabel	=	Integer.parseInt(result.getString("totalQuestions"));
					
					session.setAttribute("snDestModuleExistingTotalQNos",iIotalQuestionsUpperLabel+"");//To CopyQuestions jsp for displaying there destination total questions in Module
					
				}
				if(result!=null)
					result.close();
				if(pstmt!=null)
					pstmt.close();
			
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
        
      <div id="workArea"> <!-- Div Work area begins -->
      			<!-- Modal div Begins -->
						<div id="modalUploadStudInfoPage" style="top" >
						
						    <div class="modalUploadStudInfoBackground">
						    </div>
						    <div class="modalUploadStudInfoContainer" >
						        	<div class="modalUploadStudInfo" style="width:550px;height:330px;position: relative;top:-150px;left:-90px;">
								            <div class="modalUploadStudInfoTop" style="width:100%;"> 
												<table style="border-collapse: collapse; width: 100%;height:100%" cellpadding="0" cellspacing="0" >
													<tr>
													<td style="padding-left:5px;font:normal 10pt Arial;"  align="left"><b>Upload Question</b>
													</td>
													<td style="padding-right:5px; width: 44px;" align="right"><a href="javascript:hideViewer('modalUploadStudInfoPage');">[X]</a>
													</td>
													</tr>
												</table>
											</div>
											<div style="width:100%;height:12px;text-align:center;padding-top:10px"><label id="lblDisplayModuleMessage"></label></div>
											<div align="center" style="width:100%;height:80%;" id="modalUploadStudInfoContent" class="modalUploadStudInfoBody">
													<div style="float:left;margin:10px 0px 0px 30px;padding-top:20px;">
														<a href="SampleDocs/Bulk_Question_Upload.xls" target="_blank" style="color: #5384A8;"><img src="images/uploadStudent.png"><br/>Download Sample</a>
													</div>
													<div align="justify" style="float:right;margin:0px 40px 0px 10px;" >
															<ul>
																<li style="padding-bottom:15px;">Only Excel file is supported.</li>
																<li style="padding-bottom:15px;">Data inserted should be in format specified in sample</li>
																<li style="padding-bottom:15px;">Question number must be in numeric.</li>
																<li style="padding-bottom:15px;">Correct Answer column should have values defined in<br> drop down values.</li>
																
																<li style="padding-bottom:15px;">Select file to upload:</li>
															</ul>
															<form name="frmUploadQuestion" action="UploadQuestionData" method="Post" enctype="multipart/form-data" onsubmit="return questionUpload();">
																<input type="file" name="txtUploadFile" id="txtUploadFile" style="width: 279px; height: 24px;">
																<br/><br/>
																<input type="hidden" name="hidModuleName" id="hidModuleName" />
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
		<br>	
		<div style="padding-top:5px;padding-left:5px; width: 220px">
					<img style="width:22px;height:22px;" src="images/copyQuestions.png">
					<label class="pageheader" >Questions Repository</label>
		</div>		
			
			<br>
			
			<div id="divModuleInfoContainer">
				<div id="divModuleSummary" style="float:left;padding:0px 0px 0px 4px;width: 660px;">
					<label class="lblstyle">Module: </label><%=selectedModuleName%>
				</div> 
				<div  style="float:right;margin:0px 5px 0px 0px; width: 120px;"><label class="lblstyle">Questions: </label><%=iIotalQuestionsUpperLabel%></div>
				<div style="clear:both;"></div>
			</div><!-- div container of modulesinfo ends -->
			
			<div id="div_message_operations" align="center" style="height:10px;">
						 <label id="lblmessages" class="message"> 
						 <%
						 		String msg="";
						 		String msgQuestionUploaded = "";
								try{
									
									if(session.getAttribute("snMsgQuestions")!=null)
									 {	 
										    msg=session.getAttribute("snMsgQuestions").toString();
										    session.removeAttribute("snMsgQuestions");										 
									 }else{
									 		if(session.getAttribute("snMsgQuestionUpload")!=null)
											{
										 		msg=session.getAttribute("snMsgQuestionUpload").toString();
										 		session.removeAttribute("snMsgQuestionUpload");
										 		if(session.getAttribute("totalQuestionUploaded")!=null){
										 		session.removeAttribute("totalQuestionUploaded");	
										 		}
										 		if(session.getAttribute("QuestionInExcel")!=null){
										 		session.removeAttribute("QuestionInExcel");	
										 		}
										 		if(session.getAttribute("QuestionInDatabase")!=null){
										 		session.removeAttribute("QuestionInDatabase");	
										 		}
										 		if(session.getAttribute("BlankQuestionInExcel")!=null){
										 		session.removeAttribute("BlankQuestionInExcel");	
										 		}
											}else{
											 	if(session.getAttribute("totalQuestionUploaded")!=null)
										 		{	 
										 			msg= "Total Questions uploaded is "+ session.getAttribute("totalQuestionUploaded").toString()+ ". <a href='#' id='trigger'>Details..</a>";
											   	 	msgQuestionUploaded="<b>Total Questions uploaded : </b>"+ session.getAttribute("totalQuestionUploaded").toString();
											    	session.removeAttribute("totalQuestionUploaded");										 
										 		}
										 	 	if(session.getAttribute("QuestionInExcel")!=null)
										 		{
										 	 		 msgQuestionUploaded = msgQuestionUploaded + "<br/><b>Question No.'s repeated in excel : </b>";
										 	 		 msgQuestionUploaded= msgQuestionUploaded + session.getAttribute("QuestionInExcel").toString();
											 	 	 session.removeAttribute("QuestionInExcel");	
										 		}
										 		if(session.getAttribute("QuestionInDatabase")!=null)
										 		{	 
										 	   		msgQuestionUploaded = msgQuestionUploaded + "<br/><b>Question No.'s already exists in database : </b>";
											   		msgQuestionUploaded= msgQuestionUploaded + session.getAttribute("QuestionInDatabase").toString();
											   		session.removeAttribute("QuestionInDatabase");										 
											 	}
										 	 	if(session.getAttribute("BlankQuestionInExcel")!=null)
										 		{	 
										 	  	 	msgQuestionUploaded = msgQuestionUploaded + "<br/><b>Question No.'s with blank cells : </b>";
											  	 	msgQuestionUploaded= msgQuestionUploaded + session.getAttribute("BlankQuestionInExcel").toString();
											  	 	session.removeAttribute("BlankQuestionInExcel");										 
										 		}
										 		if(session.getAttribute("QuestionQptionsRepeated")!=null)
										 		{	 
										 	  	 	msgQuestionUploaded = msgQuestionUploaded + "<br/><b>Question No.'s with repeated options : </b>";
											  	 	msgQuestionUploaded= msgQuestionUploaded + session.getAttribute("QuestionQptionsRepeated").toString();
											  	 	session.removeAttribute("QuestionQptionsRepeated");										 
										 		}
									 	  }
										}
								}catch(Exception e){e.printStackTrace();}
							 %><%=msg%> </label>
							  <div id="pop-up" style="text-align:left">
         						 <%=msgQuestionUploaded%>
        					</div>
					 </div>
			<div id="divContainerQuestions" style="margin:10px 0px 0px 0px;" >
				
				<div id="divQuestionLinks" style="float:left;width:184px;height:100%;">
			 		<div >
				 		<div style="font-style:italic;padding:0px 0px 8px 4px;">
				 		  	<label class="lblstyle">Questions</label>
				 		 </div>
				 	</div>
			 		<div id="divQuestionLinksElements" style="overflow-y:auto;width:98%;height:400px;padding:0px 0px 0px 5px;">
						<form action="Questions.jsp" method="post" id="frmSubmitQuestionId" name="frmSubmitQuestionId">
						
							<% int iTotalQuestions	=	0;
								pstmt=connection.prepareStatement("select exam_Ques_Id from ePariksha_Exam_Questions where exam_Module_Id=? order by exam_Ques_Id",ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
								pstmt.setLong(1, Long.parseLong(sModuleId));
								result=pstmt.executeQuery();
								while(result.next())
								{
								  %>
									<a class="" style="font-size:11pt;padding:0px 0px 0px 0px;"  href="javascript:void(0);" onclick="getSelectedQuestion(document.getElementById('frmSubmitQuestionId'),this.id)" id="<%=result.getLong("exam_Ques_Id")%>"><%=result.getRow()%></a>
								  	<input id="txtActualQuestionId<%=result.getRow()%>" name="txtActualQuestionId<%=result.getRow()%>" type="hidden" value="<%=result.getLong("exam_Ques_Id")%>">
								  	<span style="margin:0px <%if(result.getRow()<10){%>38px<%}else{%>30px<%}%> 0px 0px;padding:0px;" id="spCheckboxHolder<%=result.getRow()%>">&nbsp;</span>
								  	
								  <%
								  
									if(result.getRow()%3==0)
									{
										%><br/><br/><br/><%
									}
								  iTotalQuestions++;
								}
								if(result!=null)
									result.close();
								
								if(pstmt!=null)
									pstmt.close();/**closing the statement*/ 
							%>
							<input type="hidden" id="txtSelQuestion" name="txtSelQuestion">
							<input type="hidden" id="txtScrollYPosition" name="txtScrollYPosition"/>
						</form>
						<%if(iTotalQuestions==0){%><div style="margin:150px 0px 0px 20px;" class="message_directions">No questions</div><%}%>
					</div><!-- menu links ends -->
					
					<div align="left" style="font-style:italic;padding:10px 0px 5px 4px;"><label class="lblstyle">Modes</label></div>
					<div id="divAddQuestions">
						<input type="hidden" id="txtTotalQuestions" name="txtTotalQuestions"  value="<%=iTotalQuestions%>">
					   <label><input onclick="javascript:addQuestionMode(document.getElementById('frm_data'))" type="radio" id="rdAdd" name="rdOperations">Add</label>
					   <label><input type="radio" onclick="javascript:editQuestionMode();" id="rdEdit" name="rdOperations">Edit</label>
					   <label><input onclick="javascript:delQuestionMode(document.getElementById('frmSubmitQuestionId'),<%=iTotalQuestions%>);" type="radio" id="rdDelete" name="rdOperations">Delete</label>
						
					</div>
					<br>
					<div align="left" style="font-style:italic;padding:10px 0px 5px 4px;"><label class="lblstyle">Operations</label></div>
					 	<img style="width:25px;height:25px;padding-left:5px;" src="images/copyQuestions.png">
						<a href="CopyQuestions.jsp">Copy Questions</a><br/>
					<div style="padding-top:8px;"> 
						<div style="float:left;"><img style="width:30px;height:27px;padding-left:2px;" src="images/excel_upload.png" ></div>
						<div style="float:right;padding-top:10px;width:150px"><a href="javascript:showModalDiv('modalUploadStudInfoPage');">Upload Questions</a></div>
						<div style="clear:both"></div>
					</div>
				</div><!-- menu links holder ends -->

				<%
			 		String question="",opt1="",opt2="",opt3="",opt4="";

					int c_ans=0;

					if(request.getParameter("txtSelQuestion")!=null && !request.getParameter("txtSelQuestion").equals("") )
					{
						sSelectedQuestionId	=	request.getParameter("txtSelQuestion");
						session.setAttribute("snSelectedQuestionId",sSelectedQuestionId);
					}
					else if(session.getAttribute("snSelectedQuestionId")!=null)
					{
						sSelectedQuestionId	=	session.getAttribute("snSelectedQuestionId").toString();//taken from above condition
					}
					
					/*If question clicked First time get it by request parameter */		
					if(request.getParameter("txtScrollYPosition")!=null)
					{	
						sScrollMenuDivPosition	=	request.getParameter("txtScrollYPosition");
						session.setAttribute("snScrollMenuDivPosition",sScrollMenuDivPosition);//To maintain questions div scroll
					}
					else if(session.getAttribute("snScrollMenuDivPosition")!=null)//if session is set then use below values from session in case of edit,add questions
						sScrollMenuDivPosition	=	session.getAttribute("snScrollMenuDivPosition").toString();//To maintain questions div scroll
					

					if(sSelectedQuestionId!=null)//if no question is selected don't run query
			        {
						session.setAttribute("snModeIdentifier","Edit");//Identifies Mode:If question is selected then it is always in editing mode.

							try{
							   	 String sql="select *from ePariksha_Exam_Questions where exam_Ques_Id=?";
							 	 pstmt=connection.prepareStatement(sql,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
							 	 pstmt.setLong(1,Long.parseLong(sSelectedQuestionId) );
							 	 result=pstmt.executeQuery();
							 	 while(result.next())
							 	 {
							 		question=result.getString("exam_Ques_Text"); 
							 		opt1=result.getString("exam_Option1");
							 		opt2=result.getString("exam_Option2");
							 		opt3=result.getString("exam_Option3");
							 		opt4=result.getString("exam_Option4");
							 		c_ans=result.getInt("exam_Correct_Answer");
							 	 }
							 	 
							 	 if(result!=null)
							 		result.close();
							 	if(pstmt!=null)	
							 		pstmt.close();
							  }
							catch(SQLException e){e.printStackTrace();}
							
							
			        }
			        else
			         	session.setAttribute("snModeIdentifier","Add");//Identifies Mode:If question isnot  selected then it is always in add mode.
			         	
			        
					
				%>

				<div id="divQuestionContents" style="float:right;margin:0px 0px 0px 3px;">
						<div class="message_directions" align="center" id="divEditMsg" style="display:none;width:100%;padding:150px 0px 0px 0px"><!-- div table holder starts -->
							Please select question from left menu.
						</div>
						<div align="center" id="div_table" style="width:100%;height:100%;margin:0px 2px 20px 0px"><!-- div table holder starts -->
							   	<form name="frm_data" id="frm_data" method="post" action="" onsubmit="return false;">
										<table style="padding:0px 2px 0px 0px;height:550px;width:100%"  cellspacing=0 cellpadding=0 class="questions_style">
								        	<tr>
												<td align="left" valign="top" colspan="2" style=";padding-left:4px;" ><label class="title">Question Statement: </label></td>
											</tr>
											<tr>
											  <td colspan="2" align="center" ><textarea class="transparent" readonly="readonly" id="txtquestion" name="txtquestion"  style="height: 250px; width: 580px;resize:none;"><%=question%></textarea></td>
											</tr>
											
												<tr>
													<td colspan="1" align="left" style="width:45%;padding-left:4px;" ><label class="title">Choice1: </label></td>
													<td align="left" style="width:45%;padding-left:4px;"><label class="title">Choice2: </label></td>
												</tr>
												<tr>
													<td align="center" style="width:45%"><textarea class="transparent" readonly="readonly" id="txtoption1" name="txtoption1" style="height: 65px; width: 280px;resize:none;"><%=opt1%></textarea></td>
													<td align="center" style="width:45%"><textarea class="transparent" readonly="readonly" style="height: 61px;width: 280px;resize:none;" id="txtoption2" name="txtoption2"><%=opt2%></textarea></td>
												</tr>
											    <tr>
													<td align="left" style="width:45%;padding-left:4px;"><label class="title">Choice3: </label></td>
													<td align="left" style="width:45%;padding-left:4px;"><label class="title">Choice4: </label></td>
												</tr>
												<tr>
													<td align="center" style="width:45%"><textarea class="transparent" readonly="readonly" style="height: 61px;width: 280px;resize:none;" id="txtoption3" name="txtoption3"><%=opt3%></textarea></td>
							 					  	<td align="center" style="width:45%"><textarea class="transparent" readonly="readonly" style="height: 61px;width: 280px;resize:none;" id="txtoption4" name="txtoption4"><%=opt4%></textarea></td>
												</tr>

											    <tr>
											    <td colspan="2">
												     <table align="left">
														 <tr>
															<td align="left"><label class="title">Answer: </label></td>
															 <td>
															 <% String ans_string=null;
																			 switch(c_ans)
																			 {
																			  case 1: ans_string="Choice1";
																			          break;
																	          case 2: ans_string="Choice2";
																	         		   break;
																	          case 3: ans_string="Choice3";
																	          			break;
														          			  case 4: ans_string="Choice4";
														          			           break;
																			  default: ans_string="Ans";
																			          break;
																			 }%>
															    <input type="hidden" value="<%=c_ans%>" name="txt_ans" id="txt_ans" style="height: 18px; width: 34px;color:#969696;">
																<input class="transparent" readonly="readonly" value="<%=ans_string%>" name="txt_ans_string" id="txt_ans_string" style="height: 18px; width: 61px;color:#969696;">
																
																<select onchange="get_selectedvalue(this.value)" id="drp_ans" name="drp_ans"
																	style="width: 78px; display: none">
																	<option id="optsel">Select</option>
																	<option value="1" id="opt1">Choice1</option>
																	<option value="2" id="opt2">Choice2</option>
																	<option value="3" id="opt3">Choice3</option>
																	<option value="4" id="opt4">Choice4</option>
														
																</select>
															</td>
												    	</tr>
												    </table>
										    	 </td>
											    </tr>	
												<tr>
															<td colspan="2" align="center" >
																<input class="button" id="btn_Add" name="btn_Add" id="btn_change" type="submit"  value="Add" onclick="javascript:onUpdateAndAddOperations();document.getElementById('txtOprIdentifier').value='1'" style="width:75px;display:none;"/>
																<input class="button" type="reset"  name="btn_reset" id="btn_reset" value="Reset" style="width: 75px;display:none;">
																
																<input class="button" id="btn_change" name="btn_change" id="btn_change" type="button"  value="Edit" onclick="javascript:change(this.form);" style="width: 75px">
																<input onclick="onUpdateAndAddOperations();document.getElementById('txtOprIdentifier').value='2';" class="button" type="submit" disabled="disabled"
																	style="width:75px;" name="btn_update" id="btn_update" value="Update">
																<input class="button" type="button" id="btn_cancel" name="btn_cancel" value="Cancel" onclick="resetEditableData(this.form)" style="width: 75px;display:none;"> 
																	
																<input type="hidden"  name="txtOprIdentifier" id="txtOprIdentifier">
																<input type="hidden"  name="txtScrollYPositionQuesDiv" id="txtScrollYPositionQuesDiv">
																					  	
																<input type="hidden"  name="txt_newans" id="txt_newans">
																<input type="hidden" name="txt_q_id" id="txt_q_id" value="<%=sSelectedQuestionId%>">
															</td>
												</tr>
										</table>
								</form>
						</div><!-- div table holder ends -->						
						<div style="clear:both;"></div>
				</div>
				<div style="clear:both;"></div>
			</div><br>
		
		</div><!--  workarea ends -->
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
					
			if(session.getAttribute("snSelectedQuestionId")!=null)
			{%>
				<script>
				if(document.getElementById('<%=session.getAttribute("snSelectedQuestionId").toString()%>')!=null)
				{
					document.getElementById('<%=session.getAttribute("snSelectedQuestionId").toString()%>').style.color='white';
					document.getElementById('<%=session.getAttribute("snSelectedQuestionId").toString()%>').style.backgroundColor='#1C89FF';
					document.getElementById('<%=session.getAttribute("snSelectedQuestionId").toString()%>').setAttribute("onclick","javascript:void(0);");
					document.getElementById('txtSelQuestion').value="<%=session.getAttribute("snSelectedQuestionId").toString()%>";
				}
				</script>

				
			<%} 
			else
	        {	/*If no question is selected it is an add question mode*/
	        	%><script type="text/javascript" >
						addQuestionMode(document.getElementById('frm_data'));
						
					</script>
				<%
	        }%>
		

			<%
			/*Setting mode of operation according to the operation done.*/
			String sMode="";
			if(iTotalQuestions==0)
			{%>
				<script>
					document.getElementById('rdEdit').disabled=true;
					document.getElementById('rdDelete').disabled=true;
					document.getElementById('rdAdd').checked=true;
				</script>
				
			<%}
			if(session.getAttribute("snModeIdentifier")!=null) //from above & addquestion servlet
			 {
				sMode	=	session.getAttribute("snModeIdentifier").toString();
				if(sMode.equalsIgnoreCase("Edit"))
				{%>
					<script>document.getElementById('rdEdit').checked=true;</script>
				<%}
				if(sMode.equalsIgnoreCase("Add"))
				{%>
					<script>document.getElementById('rdAdd').checked=true;</script>
				<%}%>
			<%}%>
			
			<%//Setting scrollbar position on diff. modes
			if(sScrollMenuDivPosition!=null) {%>
				<script>document.getElementById('divQuestionLinksElements').scrollTop='<%=sScrollMenuDivPosition%>';</script>
			<%} %>
		
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
%>
</html>