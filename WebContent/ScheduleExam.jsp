
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" session="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<!-- @Author : Mritunjay , Asha 
	 @Date   : 24-05-12
	 @return : scheduled exam and exam id of exam	 
 -->
 
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>

<%@page import="java.text.SimpleDateFormat"%>
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
{
	//----- create todays date for validation
		Date date = new Date();
		// Keep the MM upper case
		DateFormat df = new SimpleDateFormat("dd-MM-yyyy");
		String formattedDate = df.format(date);
%>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<link rel="stylesheet" href="Css/style.css" type="text/css">
		<link rel="shortcut icon" href="images/favicon.ico" >
		<link rel="icon" type="image/gif" href="images/animated_favicon1.gif" >
		<link rel="apple-touch-icon" href="images/apple-touch-icon.png" >
		<link href="CSS/calender.css" rel="stylesheet" type="text/css" />
		<link rel="stylesheet" type="text/css" media="all" href="jsDatePick_ltr.min.css" />
		<script type="text/javascript" src="jsDatePick.min.1.3.js"></script>
		<title>Schedule Exam [ePariksha]</title>
		<script type="text/javascript">javascript:window.history.forward(1);</script>
			<script type="text/javascript">
	var persistStatus = 0;
	var persistResult = 0;
		function clear()
		{
			document.getElementById("msgDiv").innerHTML="";	
		}
	
	var allowUpdate=1;
		function UpdateExam(ttarget)
		{
			var todayEdited 	=	"<%=formattedDate.trim()%>"; // Today's date
			var upSchedate		=document.getElementById("idExmDate"+ttarget).value;
			var ExamStatus 		=document.getElementById("optExamStatus"+ttarget).value;
			var ExamResult 		=document.getElementById("optExamResult"+ttarget).value;
			var MinPassingMarks =document.getElementById("idMinPassingMark"+ttarget).value;
		
			
			if(compareDates(todayEdited,upSchedate))
			{
				document.getElementById("msgDiv").innerHTML="Exam schedule date before "+todayEdited+" is not allowed";
				return false;
			}
			else if(document.getElementById("idDuration"+ttarget).value==0)
			{
				document.getElementById("msgDiv").innerHTML="Please enter exam duration";
				return false;
			}
			else if(document.getElementById("idQuestion"+ttarget).value==0)
			{
				document.getElementById("msgDiv").innerHTML="Please enter number of questions";
				return false;
			}
			
			else if(document.getElementById("idQuestion"+ttarget).value=='')
			{
				document.getElementById("msgDiv").innerHTML="Please enter number of questions";
				return false;
			}
			else if(document.getElementById("idDuration"+ttarget).value==0)
			{
				document.getElementById("msgDiv").innerHTML="Please enter exam duration";
				return false;
			}
			else if(document.getElementById("idDuration"+ttarget).value=='')
			{
				document.getElementById("msgDiv").innerHTML="Please enter exam duration";
				return false;
			}
			else if(document.getElementById("idMinPassingMark"+ttarget).value=='')
			{
				document.getElementById("msgDiv").innerHTML="Please enter Min. Passing Marks";
				document.getElementById("idMinPassingMark"+ttarget).focus();
				return false;
			}
			else if(parseInt(MinPassingMarks)>parseInt(document.getElementById("idQuestion"+ttarget).value))
			{
				document.getElementById("msgDiv").innerHTML="Min. Passing Marks cannot be greater than Question number";
				document.getElementById("idMinPassingMark"+ttarget).focus();
				return false;
			}
			else if(document.getElementById("optExamStatus"+ttarget).value=='000')
			{
				document.getElementById("msgDiv").innerHTML="Please Select Exam Status";
				return false;
			}
			else if(document.getElementById("optExamResult"+ttarget).value=='000')
			{
				document.getElementById("msgDiv").innerHTML="Please Select Exam Show Result";
				return false;
			}
			else
			{
			var confirm_value = confirm("Are you sure you want to update the schedule?");
			  if(confirm_value== true)
			  {	
				    document.getElementById("idExmDate"+ttarget).setAttribute('class' , 'transparent');
					document.getElementById("idExmDate"+ttarget).readOnly=true;
				
					document.getElementById("idDuration"+ttarget).setAttribute('class' , 'transparent');
					document.getElementById("idDuration"+ttarget).readOnly=true;
					document.getElementById("idQuestion"+ttarget).setAttribute('class' , 'transparent');
					document.getElementById("idQuestion"+ttarget).readOnly=true;
					document.getElementById("idMinPassingMark"+ttarget).setAttribute('class' , 'transparent');
					document.getElementById("idMinPassingMark"+ttarget).readOnly=false;
					//document.getElementById("chCert"+prevEdited).setAttribute('class' , 'Transparent');
						
			if(allowUpdate==ttarget)
			{
				var xmlhttp;
				
				var UpScheDate=document.getElementById("idExmDate"+ttarget).value;
				
				var UpDuration=document.getElementById('idDuration'+ttarget).value;
				var UpQuestion=document.getElementById('idQuestion'+ttarget).value;
				
				var UpExamAndModID=document.getElementById('idExamAndModID'+ttarget).value;
				
				var url= "UpdateSchedule?schdate="+UpScheDate+"&duration="+UpDuration+"&questions="+UpQuestion+"&examAndmodID="+UpExamAndModID+"&ExamStatus="+ExamStatus+"&ExamResult="+ExamResult+"&MinPassingMarks="+MinPassingMarks;
			
				if (window.XMLHttpRequest)
					
				  {		// code for IE7+, Firefox, Chrome, Opera, Safari 
				  		xmlhttp=new XMLHttpRequest();
				  }
				else
				  {		// code for IE6, IE5
				 		 xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
				  }

				xmlhttp.onreadystatechange=function()
				{
					
					if (xmlhttp.readyState==4 && xmlhttp.status==200)
				    {
						
						if(xmlhttp.responseText!="")// if data is present 
						 {
							var updatedMsg=(xmlhttp.responseXML.getElementsByTagName("ResponseMessage")[0]).getElementsByTagName("message")[0].firstChild.nodeValue;
							if(updatedMsg=="Question Bank insufficient")
								{
								  	document.getElementById("idExmDate"+ttarget).setAttribute('class' , 'nontransparent');
									document.getElementById("idExmDate"+ttarget).readOnly=false;
								
									document.getElementById("idDuration"+ttarget).setAttribute('class' , 'nontransparent');
									document.getElementById("idDuration"+ttarget).readOnly=false;
									
									document.getElementById("idQuestion"+ttarget).setAttribute('class' , 'nontransparent');
									document.getElementById("idQuestion"+ttarget).readOnly=false;
									
									document.getElementById("idMinPassingMark"+ttarget).setAttribute('class' , 'nonTransparent');
									document.getElementById("idMinPassingMark"+ttarget).readOnly=false;
									
									document.getElementById("divUpdate"+ttarget).style.backgroundImage="url(images/update.png)";
									document.getElementById("divEdit"+ttarget).style.backgroundImage="url(images/cancel-icon.png)";
									document.getElementById("divEdit"+ttarget).title = "cancel"  ;
									
								}
							else
								{
								document.getElementById("divHidExamResult"+ttarget).style.display= "none";
								document.getElementById("divHidExamStatus"+ttarget).style.display= "none";
								document.getElementById("divShowExamResult"+ttarget).style.display= "inline";
								document.getElementById("divShowExamStatus"+ttarget).style.display= "inline";
								
								document.getElementById("divShowExamResult"+ttarget).innerHTML = ExamResult;
								document.getElementById("divShowExamStatus"+ttarget).innerHTML = ExamStatus;
								document.getElementById("divEdit"+ttarget).style.backgroundImage="url(images/edit.png)";
								document.getElementById("divUpdate"+ttarget).style.backgroundImage="url(images/updateGray.png)";
								document.getElementById("divUpdate"+ttarget).setAttribute("onclick" , "javascrpt:void(0);");
								document.getElementById("divEdit"+ttarget).title = "edit"  ;
								document.getElementById("divEdit"+ttarget).setAttribute("onclick" , "EditExam('"+ttarget+"');");
								}
							document.getElementById("msgDiv").innerHTML=(xmlhttp.responseXML.getElementsByTagName("ResponseMessage")[0]).getElementsByTagName("message")[0].firstChild.nodeValue;
							setTimeout("clear()",5000);
						 }
						else
						{
							document.getElementById("msgDiv").innerHTML="Exam can not updated";
							document.getElementById("divUpdate"+ttarget).removeAttribute("onclick" , "");
							document.getElementById("divUpdate"+ttarget).style.backgroundImage="url(images/updateGray.png)";
							setTimeout("clear()",5000);
						}
						
				    }// if(xmlhttp.readystate)ends here 
				};//readystatechange function end here
				
				xmlhttp.open("GET",url,true);
				xmlhttp.send();
			}else
			{
			}
			return true;
		 }
		}
		}
	
	</script>
	<script type="text/javascript">
	
	/* this is for editing exam schedules(calender display) on edit console */
	var prevEdited=0;
	function EditExam(ttarget)
	{	
		
	allowUpdate=ttarget;
	
	if(prevEdited==0)
	{
		document.getElementById("divUpdate"+ttarget).setAttribute("onclick" , "UpdateExam('"+ttarget+"');");
		//document.getElementById("divUpdate"+prevEdited).setAttribute("onclick" , "");
	}
	else
	{
		if(prevEdited!=ttarget)
		{
			//alert("divUpdate"+ttarget);
			document.getElementById("divUpdate"+ttarget).setAttribute("onclick" , "UpdateExam('"+ttarget+"');");
			document.getElementById("divUpdate"+prevEdited).style.backgroundImage="url(images/updateGray.png)";
			document.getElementById("divUpdate"+prevEdited).setAttribute("onclick" , "");
			document.getElementById("divEdit"+prevEdited).style.backgroundImage="url(images/edit.png)";
			document.getElementById("divEdit"+prevEdited).title = "edit"  ;
			document.getElementById("divEdit"+prevEdited).setAttribute("onclick" , "EditExam('"+prevEdited+"');");
			document.getElementById("idExmDate"+prevEdited).setAttribute('class' , 'transparent');
			document.getElementById("idExmDate"+prevEdited).readOnly=true;
			document.getElementById("idDuration"+prevEdited).setAttribute('class' , 'transparent');
			document.getElementById("idDuration"+prevEdited).readOnly=true;
			document.getElementById("idQuestion"+prevEdited).setAttribute('class' , 'transparent');
			document.getElementById("idQuestion"+prevEdited).readOnly=true;
			document.getElementById("idMinPassingMark"+prevEdited).setAttribute('class' , 'transparent');
			document.getElementById("idMinPassingMark"+prevEdited).readOnly=true;
			document.getElementById("divShowExamResult"+prevEdited).style.display= "inline";
			document.getElementById("divShowExamStatus"+prevEdited).style.display= "inline";
			document.getElementById("divHidExamResult"+prevEdited).style.display= "none";
			document.getElementById("divHidExamStatus"+prevEdited).style.display= "none";
			
			//document.getElementById("chCert"+prevEdited).setAttribute('class' , 'Transparent');
			
			//document.getElementById(prevEdited).disabled=true;
			
		}
		
	}
	prevEdited=ttarget;
	
	var ScheDate  		= "idExmDate"+ttarget;	
	var iduration		="idDuration"+ttarget; 
	var iquestion		="idQuestion"+ttarget;
	var iExamAndModID	="idExamAndModID"+ttarget;
	

	var UpdateEn="divUpdate"+ttarget;
	document.getElementById("divUpdate"+ttarget).setAttribute("onclick" , "UpdateExam('"+ttarget+"');");
	document.getElementById("divEdit"+ttarget).style.backgroundImage="url(images/cancel-icon.png)";
	document.getElementById("divEdit"+ttarget).title = "cancel"  ;
	document.getElementById("divEdit"+ttarget).setAttribute("onclick","CancelEdit('"+ttarget+"')");
	
	document.getElementById(UpdateEn).style.backgroundImage="url(images/update.png)";
	var tiExamAndModID = new Array();
	
	tiExamAndModID = document.getElementById(iExamAndModID).value.split(',');
	
	g_upScheDate=new JsDatePick({
		useMode:2,
		target:ScheDate,
		
		dateFormat:"%d-%m-%Y",
		yearsRange:new Array(2010,2030 )
		
	});
	document.getElementById(ScheDate).setAttribute('class' , 'nonTransparent');

	document.getElementById(iduration).setAttribute('class' , 'nonTransparent');
	document.getElementById(iduration).readOnly=false;
	document.getElementById(iquestion).setAttribute('class' , 'nonTransparent');
	document.getElementById(iquestion).readOnly=false;
	document.getElementById("idMinPassingMark"+ttarget).setAttribute('class' , 'nonTransparent');
	document.getElementById("idMinPassingMark"+ttarget).readOnly=false;
	document.getElementById("divShowExamResult"+ttarget).style.display= "none";
	document.getElementById("divShowExamStatus"+ttarget).style.display= "none";
	document.getElementById("divHidExamResult"+ttarget).style.display= "inline";
	document.getElementById("divHidExamStatus"+ttarget).style.display= "inline";
	
	}
	
	function CancelEdit(ttarget) {
		document.getElementById("divUpdate"+ttarget).setAttribute("onclick" ,"javascript:void(0);");
		document.getElementById("divUpdate"+ttarget).style.backgroundImage="url(images/updateGray.png)";
		document.getElementById("idExmDate"+ttarget).setAttribute('class' , 'transparent');
		document.getElementById("idExmDate"+ttarget).readOnly=true;
		document.getElementById("idDuration"+ttarget).setAttribute('class' , 'transparent');
		document.getElementById("idDuration"+ttarget).readOnly=true;
		document.getElementById("idQuestion"+ttarget).setAttribute('class' , 'transparent');
		document.getElementById("idQuestion"+ttarget).readOnly=true;
		document.getElementById("idMinPassingMark"+ttarget).setAttribute('class' , 'transparent');
		document.getElementById("idMinPassingMark"+ttarget).readOnly=true;
		document.getElementById("divEdit"+ttarget).title="edit";
		document.getElementById("divEdit"+ttarget).style.backgroundImage="url(images/edit.png)";
		document.getElementById("divEdit"+ttarget).setAttribute("onclick" , "EditExam('"+ttarget+"');");
		
		document.getElementById("divShowExamResult"+ttarget).style.display= "inline";
		document.getElementById("divShowExamStatus"+ttarget).style.display= "inline";
		document.getElementById("divHidExamResult"+ttarget).style.display= "none";
		document.getElementById("divHidExamStatus"+ttarget).style.display= "none";
		if(persistStatus==1)
		{
			document.getElementById("optExamStatus"+ttarget).value= "Active";
		}else
		{
			document.getElementById("optExamStatus"+ttarget).value= "Inactive";
		}
		if(persistResult==1)
		{
			document.getElementById("optExamResult"+ttarget).value= "Yes";
		}else
		{
			document.getElementById("optExamResult"+ttarget).value= "No";
		}
	}
	
	</script>
	<script type="text/javascript">
	
	/*this is for exam schedule(calender display) on main */
	window.onload = function(){
		g_Sch=new JsDatePick({
			useMode:2,
			target:"idScheDate",
			dateFormat:"%d-%m-%Y",
			yearsRange:new Array(2010,2030)
			
		});

		g_Sch.setOnSelectedDelegate(function(){
			
			
			g_Sch.populateFieldWithSelectedDate();
			getOnModule();         // to display already scheduled exam for selected date
		//	g_Sch.closeCalendar();
			
		});	
	};
	function hideAllCal()
	{
		// alert(g_Sch.flag_aDayWasSelected);
		
	} 

	
	
	function RemoveExam(ttarget)
	{
		var confirm_value = confirm("Are you sure you want to remove the schedule?");
		var date = document.getElementById('idScheDate').value;
		if(confirm_value== true)
		  {
			var xmlhttp;
			var ReExamAndModID=document.getElementById('idExamAndModID'+ttarget).value;
			var url= "RemoveSchedule?reSche="+ReExamAndModID;

			if (window.XMLHttpRequest)
				
			  {		// code for IE7+, Firefox, Chrome, Opera, Safari 
			  		xmlhttp=new XMLHttpRequest();
			  }
			else
			  {		// code for IE6, IE5
			 		 xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
			  }

			xmlhttp.onreadystatechange=function()
			{
				if (xmlhttp.readyState==4 && xmlhttp.status==200)
			    {
					if(xmlhttp.responseText!="")// if data is present 
					 {
						 var toDeleteTable=document.getElementById("wrkArea").getElementsByTagName("TR");
						 
					if(toDeleteTable.length==3)
					{
						document.getElementById("divNotApplicable").style.display="none";
						document.getElementById("wrkArea").parentNode.removeChild(document.getElementById("wrkArea"));
						document.getElementById("lbltestMsg").innerHTML = " ";
						var divRow = document.createElement("div");
						divRow.setAttribute('class','message_directions');
						divRow.setAttribute('style','padding-top: 40px;padding-bottom: 10px;');
						divRow.appendChild(document.createTextNode("No Schedule for "+date));
						document.getElementById("idToWork").appendChild(divRow);
						
					}else
					{
					
						var toDelete=document.getElementById("idExamTR"+ttarget);
						
						toDelete.parentNode.removeChild(toDelete);
					}
						document.getElementById("msgDiv").innerHTML=(xmlhttp.responseXML.getElementsByTagName("ResponseMessage")[0]).getElementsByTagName("message")[0].firstChild.nodeValue;
					 }
					else
					{
						document.getElementById("msgDiv").innerHTML="Exam can not removed";
					}
					
					setTimeout("clear()",5000);
			    }// if(xmlhttp.readystate)ends here 
			    
			};//readystatechange function end here
				xmlhttp.open("GET",url,true);
				xmlhttp.send();
			  return true;
		  }else
		  {
			  return false;
		  }
	}

	</script>
	<script type="text/javascript">
	 	
	function getOnModule()
	{
		document.getElementById("testMsg").innerHTML =" ";	
		var idDate = document.getElementById("idScheDate").value;
		var modId  = document.getElementById("idModuleID").value;
	
	var url= "ModuleExamFinder?idr="+idDate;

		if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
				xmlhttp = new XMLHttpRequest();
		
			} else {// code for IE6, IE5
				xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
			}
			xmlhttp.onreadystatechange = function() {
				if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
					
					var toWrite="";
					var j=1;
					var temp = new Array();
					temp = xmlhttp.responseText.split('@');//
					
					toWrite = "<table  id=\"wrkArea\" align=\"Center\" style=\"background-color:#FFFFFF;font-family:arial;font-size:9pt;width:785px;margin-left:15px;margin-bottom: 20px;border:1pt solid #B7B7B7;cellspacing:1\">";
					toWrite =toWrite + "<tr style=\"background-color:#DDD;\">";
					toWrite =toWrite + "<th width=\"18px\" height=\"18px\"; align=\"Center\" style=\"color: #7A7A7A\">No</th>";
					toWrite =toWrite + "<th width=\"179px\" align=\"Center\" style=\"color: #7A7A7A\">Module Name</th>";
					
					toWrite =toWrite + "<th width=\"69px\" align=\"Center\" style=\"color: #7A7A7A\">Exam Date</th>";
					
					
					toWrite =toWrite + "<th width=\"40px\" align=\"Center\" style=\"color: #7A7A7A\">Duration</th>";
					toWrite =toWrite + "<th width=\"40px\" align=\"Center\" style=\"color: #7A7A7A\">Question</th>";		
					toWrite =toWrite + "<th width=\"80px\" align=\"Center\" style=\"color: #7A7A7A\">Status</th>";
					toWrite =toWrite + "<th width=\"80px\" align=\"Center\" style=\"color: #7A7A7A\">Show Result</th>";
					toWrite =toWrite + "<th width=\"58px\" align=\"Center\" style=\"color: #7A7A7A\">Min.Marks</th>";
					toWrite =toWrite + "<th width=\"64px\" align=\"Center\" style=\"color: #7A7A7A\">Operations</th>";
					
					toWrite =toWrite + "</tr>";
					if(xmlhttp.responseText!="ACTS")
					{
						document.getElementById("testMsg").innerHTML ='<label id="lbltestMsg" class="lblstyle" style="margin-left:15px">Scheduled Exams</label>';
					for(var i=0;i<temp.length;i=i+10)
						{
							
							var bckColor;
							
							if(j%2==0)
							{
								bckColor="#F2F2F2";
								
							}
							else
							{
								bckColor="#FBF9F5";
								
							}
							
							toWrite =toWrite + "<tr id=\"idExamTR"+(j+1)+"\" style=\"background-color: "+bckColor+";height:24px;\">";
							toWrite =toWrite + "<td width=\"18px\" align=\"Center\">"+j+++"</td>";
							toWrite =toWrite + "<td width=\"179px\" align=\"left\" style=\"color: #2F4F4F\">"+temp[i]+"</td>";
							//i++;
							//j++; // for serial number
							toWrite =toWrite + "<td width=\"69px\" align=\"Center\">" + 
							" <input type=\"text\" style=\"width:67px;height:13px;color: #2F4F4F\" class=\"transparent\" id=\"idExmDate"+j+"\" readonly=\"readonly\"  value=\""+temp[i+1]+"\"></td>";
							
							
							
							toWrite =toWrite + "<td width=\"40px\" align=\"Center\" style=\"color: #724E38\">" + 
							" <input type=\"text\" style=\"width:20px;height:13px;color: #2F4F4F\" class=\"transparent\" id=\"idDuration"+j+"\" readonly=\"readonly\"  value=\""+temp[i+2]+"\"></td>";
							
							toWrite =toWrite + "<td width=\"40px\" align=\"Center\" style=\"color: #724E38\">" + 
							" <input type=\"text\" style=\"width:20px;height:13px;color: #2F4F4F\" class=\"transparent\" id=\"idQuestion"+j+"\" readonly=\"readonly\"  value=\""+temp[i+3]+"\"></td>";
							
							if(temp[i+4]=='Active')
							{	persistStatus = 1;
								toWrite =toWrite + "<td width=\"80px\" align=\"Center\" style=\"color: #724E38\"><div id=\"divShowExamStatus"+j+"\">" +temp[i+4]+"</div><div id=\"divHidExamStatus"+j+"\" style=\"display:none\"><select name=\"optExamStatus"+j+"\" id=\"optExamStatus"+j+"\" style=\"width: 80px;\">"+
								"<option value=\"000\">--Select--</option><option value=\"Active\" selected>Active</option><option value=\"Inactive\">Inactive</option></select></div></td>";
							}else
							{
								toWrite =toWrite + "<td width=\"80px\" align=\"Center\" style=\"color: #724E38\"><div id=\"divShowExamStatus"+j+"\">" +temp[i+4]+"</div><div id=\"divHidExamStatus"+j+"\" style=\"display:none\"><select name=\"optExamStatus"+j+"\" id=\"optExamStatus"+j+"\" style=\"width: 80px;\">"+
								"<option value=\"000\">--Select--</option><option value=\"Active\" >Active</option><option value=\"Inactive\" selected>Inactive</option></select></div></td>";
							}
							if(temp[i+5]=='Yes')
							{
								persistResult = 1;
								toWrite =toWrite + "<td width=\"80px\" align=\"Center\" style=\"color: #724E38\"><div id=\"divShowExamResult"+j+"\">" +temp[i+5]+"</div><div id=\"divHidExamResult"+j+"\" style=\"display:none\"><select name=\"optExamResult"+j+"\" id=\"optExamResult"+j+"\" style=\"width: 80px;\">"+
								"<option value=\"000\">--Select--</option><option value=\"Yes\" selected>Yes</option><option value=\"No\">No</option></select></div></td>";
							}else
							{
								toWrite =toWrite + "<td width=\"80px\" align=\"Center\" style=\"color: #724E38\"><div id=\"divShowExamResult"+j+"\">" +temp[i+5]+"</div><div id=\"divHidExamResult"+j+"\" style=\"display:none\"><select name=\"optExamResult"+j+"\" id=\"optExamResult"+j+"\" style=\"width: 80px;\">"+
								"<option value=\"000\">--Select--</option><option value=\"Yes\" >Yes</option><option value=\"No\" selected>No</option></select></div></td>";
							}
							toWrite =toWrite + "<td width=\"58px\" align=\"Center\" style=\"color: #724E38\">" + 
							" <input type=\"text\" style=\"width:20px;height:13px;color: #2F4F4F\" class=\"transparent\" id=\"idMinPassingMark"+j+"\" readonly=\"readonly\"  value=\""+temp[i+6]+"\"></td>";
							
							toWrite =toWrite + "<td width=\"64px\" align=\"Center\" style=\"color: #2F4F4F\">";

							
						  
							/* this is when exam schedule date is equal to today's date and
							 * results are present then don't allow to edit update and remove 
							 * the exam.
							 * */
							 
							if(temp[i+9]==1)
							{
								/*
								toWrite =toWrite + "<div id=\"divEdit"+j+"\"  title=\"edit\" style=\"background-image:url(images/editGray.png) ;width:15px;height:15px;float:left;margin-left:6px;\"></div> " +
								" <div id=\"divUpdate"+j+"\"  title=\"update\" style=\"background-image:url(images/updateGray.png) ;width:15px;height:15px;float:left;margin-left:8px;\"></div> " +
								" <div id=\"\"  title=\"delete\" style=\"background-image:url(images/removeGray.png) ;width:15px;height:15px;float:left;margin-left:8px;\"></div>";
								*/
								toWrite =toWrite + "<div id=\"NotApplicable\">N.A.*</div>";
							}
							/* this is when scheduled exam date is same as today's (server) 
							 * date and results are not present than can edit, update or
							 *  remove the exam 
							 * */
							else if(temp[i+9]==0)
							{
								
								toWrite =toWrite + "<div id=\"divEdit"+j+"\" title=\"edit\" onclick=\"EditExam('"+j+"');\"  style=\"background-image:url(images/edit.png) ;width:15px;height:15px;float:left;margin-left:6px;\"></div> " +
							" <div id=\"divUpdate"+j+"\"  title=\"update\" style=\"background-image:url(images/updateGray.png) ;width:15px;height:15px;float:left;margin-left:8px;\"></div> " +
							" <div id=\"\" title=\"delete\" onclick=\"RemoveExam('"+j+"')\" style=\"background-image:url(images/remove.png) ;width:15px;height:15px;float:left;margin-left:8px;\"></div>";
							
							}
							/*this is when exam schedule date is not equal to today's date 
							 * and no results are present then don't allow to edit or update 
							 * allow only to remove the exam i.e. 2 is to remove*/
							else if(temp[i+9]==2)
							{
								
								toWrite =toWrite + "<div id=\"divEdit"+j+"\"  title=\"edit\" onclick=\"EditExam('"+j+"');\" style=\"background-image:url(images/edit.png) ;width:15px;height:15px;float:left;margin-left:6px;\"></div> " +
								" <div id=\"divUpdate"+j+"\" title=\"update\" style=\"background-image:url(images/updateGray.png) ;width:15px;height:15px;float:left;margin-left:8px;\"></div> " +
								" <div id=\"\" title=\"delete\" onclick=\"RemoveExam('"+j+"')\" style=\"background-image:url(images/remove.png) ;width:15px;height:15px;float:left;margin-left:8px;\"></div>";
							}
							else
							{
								toWrite =toWrite + "<div id=\"NotApplicable\">N.A.*</div>";
								/*
								toWrite =toWrite + "<div id=\"divEdit"+j+"\" title=\"edit\" style=\"background-image:url(images/editGray.png) ;width:15px;height:15px;float:left;margin-left:6px;\"></div> " +
								" <div id=\"divUpdate"+j+"\" title=\"update\" style=\"background-image:url(images/updateGray.png) ;width:15px;height:15px;float:left;margin-left:8px;\"></div> " +
								" <div id=\"\" onclick=\"\" title=\"delete\" style=\"background-image:url(images/removeGray.png) ;width:15px;height:15px;float:left;margin-left:8px;\"></div>";
								*/
							}
							toWrite =toWrite + "<input type=\"hidden\" id=\"idExamAndModID"+j+"\" value=\""+temp[i+7]+","+temp[i+8]+"\">";/*i+8=Module ID and i+9=Exam ID*/
							toWrite =toWrite + "</td>";
							toWrite =toWrite + "</tr>";
							
						} //here for loop ends
					toWrite =toWrite + "<tr style=\"background-color:#DDD;\">";
					toWrite =toWrite + "<th width=\"18px\" height=\"18px\" align=\"Center\"></th>";
					toWrite =toWrite + "<th width=\"179px\" align=\"Center\"></th>";
					toWrite =toWrite + "<th width=\"69px\" align=\"Center\"></th>";
					
					toWrite =toWrite + "<th width=\"40px\" align=\"Center\"></th>";
					toWrite =toWrite + "<th width=\"40px\" align=\"Center\"></th>";
					toWrite =toWrite + "<th width=\"80px\" align=\"Center\"></th>";
					toWrite =toWrite + "<th width=\"80px\" align=\"Center\"></th>";
					toWrite =toWrite + "<th width=\"58px\" align=\"Center\"></th>";
					toWrite =toWrite + "<th width=\"64px\" align=\"Center\"></th>";
					toWrite =toWrite + "</tr>";
					toWrite =toWrite + "</table>";
					toWrite =toWrite + "<div id=\"divNotApplicable\" style=\"text-align:left;margin-left:20px\"><label class=\"lbltestMsg\" ><b>Note : </b>&nbsp;If exam is running or completed, exam editing operations will not be applicable.</label><br/><br/><\div>";
					}
					else
					{//
						toWrite = "";
						toWrite =toWrite + "<div class=\"message_directions\" style=\"padding-top:40px;padding-bottom: 40px;\">No Schedule for "+idDate+"</div>";
					
					}
						
						document.getElementById("idToWork").innerHTML = toWrite;
					
				}
			};
			xmlhttp.open("GET", url, true);
			xmlhttp.send();
		}

	
	
	</script>
	<script type="text/javascript">
	function ClearForm()
	{
		document.getElementById("msgDiv").innerHTML="";
		document.getElementById("idScheDate").value='';
		document.getElementById("idModuleID").selectedIndex =0;
		
		document.getElementById("idDuration").value='';
		document.getElementById("idTotQ").value='';
		document.getElementById("txtPassingMark").value='';
		document.getElementById("rdExamStatusActive").checked='checked';
		document.getElementById("rdExamResultNo").checked='checked';
		document.getElementById("wrkArea").style.display='none';
		
		var divRow = document.createElement("div");
		divRow.setAttribute('class','message_directions');
		divRow.setAttribute('style','padding-top: 10px;padding-bottom: 20px;');
		divRow.appendChild(document.createTextNode("Please select exam date for scheduled exams "));
		document.getElementById("idToWork").appendChild(divRow);
		document.getElementById("divNotApplicable").style.display="none";
		document.getElementById("lbltestMsg").innerHTML = "&nbsp;" ;
		
		//document.getElementById("idhdModIdChk").value='';
	
	}
	function compareDates (value1, value2) {
		var date1, date2;
		var month1, month2;
		var year1, year2;
		var startDate=new Date();
		var endDate = new Date();
		date1 = value1.substring (0, value1.indexOf ("-"));
		month1 = value1.substring (value1.indexOf ("-")+1, value1.lastIndexOf ("-"));
		year1 = value1.substring (value1.lastIndexOf ("-")+1, value1.length);
		startDate.setFullYear(year1,month1-1,date1);

		date2 = value2.substring (0, value2.indexOf ("-"));
		month2= value2.substring (value2.indexOf ("-")+1, value2.lastIndexOf ("-"));
		year2 = value2.substring (value2.lastIndexOf ("-")+1, value2.length);
		endDate.setFullYear(year2,month2-1,date2);

		if (startDate > endDate) 
			{
				return true;
			}
		else 
			{
			    return false;
			}
		}
	
	function isNumberKey(evt)
    {
       var charCode = (evt.which) ? evt.which : event.keyCode ;
       if (charCode > 31 && (charCode < 48 || charCode > 57))
          return false;

       return true;
    }


	function CopyValue()
	{		
		var today 	=	"<%=formattedDate.trim()%>" ;   // Today's date
		var schdDate=document.getElementById("idScheDate").value;
	    
		var iDur	= document.getElementById("idDuration").value;
		var iTques	= document.getElementById("idTotQ").value;
		var iPassingMarks = document.getElementById("txtPassingMark").value;
		if(document.getElementById("idScheDate").value=='')
		{
			document.getElementById("msgDiv").innerHTML="Please select DATE";			
			return false;
		}
		else if(compareDates(today,schdDate))
		{
			document.getElementById("msgDiv").innerHTML="Exam schedule date before "+today+" is not allowed";
			return false;
		}
		else if(document.getElementById("idModuleID").selectedIndex==0)
		{
			document.getElementById("msgDiv").innerHTML="Please select Module";
			return false;
		}
		else if(iTques==0)
		{
			document.getElementById("msgDiv").innerHTML="Please enter number of questions";
			return false;
		}
		else if(document.getElementById("idTotQ").value=='')
		{
			document.getElementById("msgDiv").innerHTML="Please enter number of questions";
			return false;
		}
	else if(document.getElementById("idDuration").value=='')
		{
			document.getElementById("msgDiv").innerHTML="Please enter exam duration";
			return false;
		}
	else if(iDur==0)
		{
			document.getElementById("msgDiv").innerHTML="Please enter exam duration";
			return false;
		}
	else if(parseInt(iPassingMarks) > parseInt(iTques))
		{
			document.getElementById("msgDiv").innerHTML="Passing Mark cannot be greater than Question number";
			document.getElementById("txtPassingMark").focus();
			return false;
		}
		else if(iPassingMarks == '')
		{
			document.getElementById("msgDiv").innerHTML="Please enter minimum passing marks";
			document.getElementById("txtPassingMark").focus();
			return false;
		}
		else
		{
			document.getElementById("idHDdate").value 		= document.getElementById("idScheDate").value;
			document.getElementById("idHModuleID").value 	= document.getElementById("idModuleID").value;
			
			document.getElementById("idHExamDur").value		= document.getElementById("idDuration").value;
			document.getElementById("idHExamQ").value		= document.getElementById("idTotQ").value;
			document.getElementById("hidPassingMark").value	= document.getElementById("txtPassingMark").value;
			if(document.getElementsByName("rdExamStatus")[0].checked==true)
			{
				
				document.getElementById("hidExamStatus").value = "Active" ;
			}else
			{
				document.getElementById("hidExamStatus").value = "Inactive" ;
			}
			if(document.getElementsByName("rdExamResult")[0].checked==true)
			{
				document.getElementById("hidExamResult").value = "Yes" ;
			}else
			{
				document.getElementById("hidExamResult").value = "No" ;
			}
			// document.getElementById("hidExamStatus").value	= document.getElementsById("rdExamStatus").checked;
			// document.getElementById("hidExamResult").value	= document.getElementsById("rdExamResult").checked;
			
		
			
			var tempModID=document.getElementById("idHModuleID").value;
			
			//return false;
		}
		setTimeout("clear()",5000);
		return true;
	}
		
	function existSchedule()
	{
		
		if(document.getElementById("idModuleID").selectedIndex==0)
		{
			document.getElementById("msgDiv").innerHTML="Please select Module";
			
		}
		else
		{
			
			document.getElementById("idHExistDate").value=document.getElementById("idScheDate").value;
			document.frmExistingExam.submit();
			
		}
	}

	</script>
	</head>
	
	<body>
	<%
		if(session.getAttribute("UserId")==null || session.getAttribute("UserName")==null || session.getAttribute("CourseId")==null)
		{
		%>
			<jsp:forward page="index.jsp"></jsp:forward>
		<%
		}
		else
		{
			String strUserId	=session.getAttribute("UserId").toString();
		 	String strUserName	=session.getAttribute("UserName").toString();
		 	String strCourseId	=session.getAttribute("CourseId").toString();
		 	String sExaminerId	=	null;
		 	String strInvalidScheduleDate	=null;
		 	
		 	/*Fetching examiner id for gathering course related information*/
			if(session.getAttribute("sActualExaminerId")!=null)
			{
				sExaminerId	=	session.getAttribute("sActualExaminerId").toString();
			}
			else//if examiner logins ie no switch course then
			{
				sExaminerId	=	strUserId;
			}
		 	
		 	
		 	/**
			 * variables for database connections
			 * */
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
			
			statement=connection.prepareStatement("select module_Id,module_Name from ePariksha_Courses,ePariksha_Modules,"+
				"ePariksha_User_Master where ePariksha_Courses.course_Id=ePariksha_User_Master.user_Course_Id "+
				"and ePariksha_Modules.module_Course_Id=ePariksha_Courses.course_Id "+
				"and ePariksha_Courses.course_CC_Id=ePariksha_User_Master.user_Id and user_Id=?",
				ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
			
			
			statement.setInt(1, Integer.parseInt(sExaminerId));// for switch course & for main examiner also.
			result=statement.executeQuery();
		
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
					<div style="float:left;padding-top:5px;padding-left:5px;width: 220px; vertical-align: bottom;">
						<img style="width:22px;height:22px;vertical-align: bottom;" src="images/exam.png">
						<label class="pageheader" >Exam Schedule</label>
					</div>	
			</div>
			<div style="clear:both"></div>	
			<br>
			
			<table width="100%" cellspacing="0">
				<tr>
					<td align="left">
					<div>
						
						<div id="msgDiv" style="height: 10px;width:100%;padding-top:0px;padding-bottom:6px;color:red;color:#FF0000;font-size: 12.5px;float:right;text-align:center">
				
				<%if(session.getAttribute("fg")!=null)
					{
					if(session.getAttribute("fg").toString().trim().equals("1"))
					{
					%>
					Exam Already Scheduled
					<%
					}
					if(session.getAttribute("fg").toString().trim().equals("2"))
					{
					%>
					Exam Scheduled
					<%
					}
					if(session.getAttribute("fg").toString().trim().equals("3"))
					{
					%>
					Question Bank is insufficient
					<%
					}session.removeAttribute("fg");
					} %>
				</div>
			</div>
				</td>
				</tr>
				
				<tr >
					<td valign="top" style="padding-bottom: 5px;padding-top: 2px;padding-left: 25px;">
					
							<table class="table_white" style="width:765px;border: #B7B7B7 1pt solid;">
								<tr style="height:25px">
								<td width="180px;" class="tdblue "><label class="lblstyle">Date(dd-mm-yyyy) :</label></td>
									<td width="180px;" class="tdlightblue " style="padding-left:5px">
										<!-- calendar attaches to existing form element -->
							<input type="text" id="idScheDate" name="testinput"  readonly="readonly" value="" style="width: 150px;" onchange="hideAllCal();"/>
									</td>
									<td width="160px;" class="tdblue "><label class="lblstyle">Exam Module :</label></td>
									<td width="180px;" class="tdlightblue " style="padding-left:5px">
									<select name="ModuleId" id="idModuleID" style="width: 155px;">
					    			<option value="000">--Modules--</option>
											<%
											int i=1; // this is for index
											while(result.next())
											{
												String strModuleId=result.getString("module_Id");
												String strModuleName=result.getString("module_Name");
												String strShortModuleName=null;
												
												if(strModuleName.length()>20)
													strShortModuleName=strModuleName.substring(0,20)+"...";
												else
													strShortModuleName=strModuleName;
											%>
											<option value="<%=strModuleId%>" title="<%=strModuleName%>"><%=strShortModuleName%></option>
											<%}%>
									</select>
										<%
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
									</td>
									
								</tr>
								<tr style="height:25px">
									<td width="180px;" class="tdblue "><label class="lblstyle">Number Of Questions :</label></td>
									<td width="180px;" class="tdlightblue " style="padding-left:5px">
										<input type="text" id="idTotQ" name="txtTotQ"  style="width: 150px;" onkeypress="return isNumberKey(event)" >
									</td>
									<!--  <td width="180px;">Is Time Bound</td>
									<td width="180px;">:
										<label for="optYes"><input type="radio" name="optRad" id="optYes" value="true"
											onclick="setIsTimeBound('optYes');">Yes</label>
										<label for="optNo" style="margin-left: 10px;"><input type="radio" name="optRad" id="optNo"
											  value="false" onclick="setIsTimeBound('optNo');">No</label>
									</td>-->
								
								
									<td width="200px" class="tdblue "><label class="lblstyle">Time Duration(In Minutes) :</label></td>
									<td class="tdlightblue " style="padding-left:5px">
										<input type="text" id="idDuration" name="txtDuration"  style="width: 150px;" onkeypress="return isNumberKey(event)" >
									</td>
								</tr>
								<tr style="height:25px">
									<td width="200px" class="tdblue " style="height:22px"><label class="lblstyle">Minimum Passing Marks :</label></td>
									<td class="tdlightblue" style="padding-left:5px">
										<input type="text" id="txtPassingMark" name="txtPassingMark"  style="width: 150px;" maxlength="5" onkeypress="return isNumberKey(event)">
									</td>										
									<td width="200px" class="tdblue " style="height:22px"><label class="lblstyle">Status :</label></td>
									<td class="tdlightblue" style="padding-left:5px">
										<input type="radio" id="rdExamStatusActive" name="rdExamStatus" value="Active" checked><label class="lblstyle" >Active</label>
										<input type="radio" id="rdExamStatusInactive" name="rdExamStatus" value="Inactive"><label class="lblstyle">Inactive</label>
									</td>
									
								</tr>
								<tr style="height:25px">										
									<td width="200px" class="tdblue " style="height:22px"><label class="lblstyle">Show Result :</label></td>
									<td class="tdlightblue" style="padding-left:5px" colspan="3">
										<input type="radio" id="rdExamResultYes" name="rdExamResult" value="Yes"><label class="lblstyle" >Yes</label>
										<input type="radio" id="rdExamResultNo" name="rdExamResult" value="No" checked><label class="lblstyle">No</label>
									</td>
								</tr>
								
							
								<tr class="tdlightblue ">
									<td colspan="4" style="padding-top:5px;padding-bottom: 10px;">
									<center>
									<form name="frmScheduleExam" action="ScheduleExam" method="Post" onsubmit="return CopyValue()">
										<input type="hidden" id="idHDdate" name="txtDate" value="">
										<input type="hidden" id="idHModuleID" name="txtModule" value="">
										<input type="hidden" id="idHExamDur" name="txtExamDur" value="">
										<input type="hidden" id="idHExamQ" name="txtExamQ" value="">
										<input type="hidden" id="hidExamStatus" name="hidExamStatus" value="">
										<input type="hidden" id="hidExamResult" name="hidExamResult" value="">
										<input type="hidden" id="hidPassingMark" name="hidPassingMark" value="">
										<input class="button" type="Submit" value="Schedule">&nbsp;&nbsp;<input class="button" type="Reset" value="Reset" onclick="ClearForm();">
										<input type="hidden" value="" id="editable"/>
									</form>	
										
									</center>
									</td>
							   </tr>
							  
							</table>
							
						</td>
					</tr>
				</table>
			<br>
								<div id="divSeparator" align="center"><img src="images/separator.gif" style="width:100%;height:1px;"></div>
								<br>
			<table style="width: 100%">
				<tr>
					<td align="left">
						<div id="testMsg"><label id="lbltestMsg" class="lblstyle" style="margin-left:15px;"></label></div>
						<br>
				</td>
				</tr>
				<tr style="">
					<td align="center" height="20px">
						<div id="idToWork" style="text-align: center;min-height:90px" >
					<div  id="divShowMessage" class="message_directions" style="padding-top: 30px;padding-bottom: 20px;">
							Please select exam date for scheduled exams
					</div>
				</div>
				
					</td>
				</tr>
			</table>
			
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
<%}}%>
</html>