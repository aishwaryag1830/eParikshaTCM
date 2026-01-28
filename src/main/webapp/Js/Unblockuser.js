/**
 * @author Prashant Bansod
 * @date 04-10-01
 * Javascript to handle unblock users
 */


function get_drp_selected_value_on_choice(sel_choice) //so that if 0 & 2 ie----- are selected put in textbox the answer
{
	var path1 = document.getElementById('drp_module_name');
	var choices = new Array;
	for (var i = 1; i < path1.options.length; i++)
		{
	    if (path1.options[sel_choice].selected)
	      choices[choices.length] = path1.options[sel_choice].value;  //.value
		}
	return choices[0];
}
function get_drp_selected_Text_on_choice(sel_choice) //so that if 0 & 2 ie----- are selected put in textbox the answer
{
	var path1 = document.getElementById('drp_module_name');
	var choices = new Array;
	for (var i = 1; i < path1.options.length; i++)
		{
	    if (path1.options[sel_choice].selected)
	      choices[choices.length] = path1.options[sel_choice].text;  //.value
		}
	return choices[0];
}


function goSelectModule(frm,drp)
{
	
	if(drp.selectedIndex>0)//>0 for cross browsers
	{
		document.getElementById('txtModuleId').value=get_drp_selected_value_on_choice(drp.selectedIndex);
		document.getElementById('txtModuleName').value=get_drp_selected_Text_on_choice(drp.selectedIndex);

		document.getElementById('txtModuleDrpId').value=drp.selectedIndex;
	//	ajaxExamDatesRetrieval(drp);
		
		
		if(document.getElementById('div_message_module_sel')!=null)
			document.getElementById('div_message_module_sel').style.display='none';
		
		 if(document.getElementById('div_message_exam_date')!=null)
			   document.getElementById('div_message_exam_date').style.display='block';
		 
		 if(document.getElementById('div_message_no_results')!=null)
				document.getElementById('div_message_no_results').style.display='none';
		
			frm.submit();
	}
	else if(drp.selectedIndex	==	0)
	{
		
		
		if(document.getElementById('div_message_exam_date')!=null)
			   document.getElementById('div_message_exam_date').style.display='none';
		 
		 if(document.getElementById('div_message_no_results')!=null)
				document.getElementById('div_message_no_results').style.display='none';
		 
			if(document.getElementById('div_message_processing')!=null)
		   		document.getElementById('div_message_processing').style.display='none';
			
			if(document.getElementById('divResultPage')!=null)
				document.getElementById('divResultPage').style.display='none';
			
			if(document.getElementById('div_messages_server')!=null)
				document.getElementById('div_messages_server').style.display='none';
		
			if(document.getElementById('div_message_module_sel')!=null)
				document.getElementById('div_message_module_sel').style.display='block';
			
			
	}	

}
function selectCheckedUsers(lTotalUsers)
{
  	if(document.getElementById('chkSelectCandidateAll')!=null)
	{	
		if(document.getElementById('chkSelectCandidateAll').checked==true)
			for(var i=1;i<=lTotalUsers;i++)
			{
				if(document.getElementById('chkSelectCandidate'.concat(i))!=null)
					document.getElementById('chkSelectCandidate'.concat(i)).checked=true;
			}
	
		if(document.getElementById('chkSelectCandidateAll').checked==false)
			for(var j=1;j<=lTotalUsers;j++)
			{
				if(document.getElementById('chkSelectCandidate'.concat(j))!=null)
					document.getElementById('chkSelectCandidate'.concat(j)).checked=false;
			}
	}
}
function isAnyIdSelected(lUsersSelected)
{
	var i	=	0;
	for(var j=1;j<=parseInt(lUsersSelected);j++)
	{
		if(document.getElementById('chkSelectCandidate'.concat(j))!=null)
		{
				if(	(document.getElementById('chkSelectCandidate'.concat(j)).checked))
					i++;
		}
	}
	if(i==0)
		return false;
	else
		return true;
}
function unblockSelectedUsers(lTotalUsers)
{
	
	if(isAnyIdSelected(lTotalUsers))
		document.getElementById('frmUnblockUser').submit();
	else
	{
		if(document.getElementById('lblMainMessages')!=null)
			document.getElementById('lblMainMessages').innerHTML="Please select any candidate record";
	}
}
function resetAll(lTotalUsers)
{
	if(document.getElementById('chkSelectCandidateAll')!=null)
		document.getElementById('chkSelectCandidateAll').checked=false;	
	
	if(document.getElementById('lblMainMessages')!=null)
		document.getElementById('lblMainMessages').innerHTML="";
	
	for(var j=1;j<=lTotalUsers;j++)
	{
		if(document.getElementById('chkSelectCandidate'.concat(j))!=null)
			document.getElementById('chkSelectCandidate'.concat(j)).checked=false;
	}
}
function ShowStudentInfo()
{
	var xmlhttp;
	var displayData;
	var showData = '';
	var showWholeData ='';
	 var totalStudent;
	showModalDiv('modalChangeStudInfoPage');
	if (window.XMLHttpRequest)
	  {// code for IE7+, Firefox, Chrome, Opera, Safari
		xmlhttp =new XMLHttpRequest();
	  }
	else
	  {// code for IE6, IE5
		xmlhttp =new ActiveXObject("Microsoft.XMLHTTP");
	  }
	xmlhttp.onreadystatechange=function()
	  {
	  if (xmlhttp.readyState==4 && xmlhttp.status==200)
	    {
		  var setNameWidth = 380;
		  var setWidth = 846;
		  var stud_Middle_Name;
		  var setCheckBox = 101;
		  var paddingForRight = 6; 
		  var setCheckWidth = 97;
		  //alert(xmlhttp.responseXML.documentElement.getElementsByTagName("Student")[0].getElementsByTagName("stud_F_Name")[0].childNodes[0].nodeValue);
		  totalStudent = xmlhttp.responseXML.getElementsByTagName("StudentInfo")[0].childNodes.length;
		 // alert(xmlhttp.responseXML.documentElement.getElementsByTagName("Student")[0].getElementsByTagName("stud_M_Name")[0].childNodes[0].nodeValue);
		
		  if(totalStudent > 12)
			  {
			  setNameWidth = 380;
			  setWidth = 829;
			  setCheckBox = 83;
			  paddingForRight = 21;
			  setCheckWidth = 79;
			  }
		  displayData = "<table class=\"tblstyleStudent\" width=\"848px\" style=\"\"><tr class=\"tblheader\" id=\"tblheader\"><th width=\"30px\">S.No.</th><th width=\"110px\">Roll No.</th><th width=\""+setNameWidth+"px\">Name</th>" +
			"<th width=\"124px\" style=\"text-algin:center\">Password</th><th width=\"100px\">Operation</th><th width=\""+setCheckWidth+"px\" style=\"text-align:center;padding-right:"+paddingForRight+"px\"><input type=\"checkbox\" onclick=\"selectCheckStudent("+totalStudent+")\"  name=\"chkSelectStudentAll\" id=\"chkSelectStudentAll\" style=\"border: 0;\"/></th></tr></table> " +
			"<div class=\"tblstyle\" style=\"overflow:auto;height:280px;width:846px;\"><table class=\"showTableData\" id=\"showTableData\" style=\"\" width=\""+setWidth+"px\">";
		    
		  for(var i=0;i<totalStudent;i++)
			  {
			  if( xmlhttp.responseXML.documentElement.getElementsByTagName("Student")[i].getElementsByTagName("stud_M_Name")[0].childNodes[0].nodeValue == '@')
				  {
				  stud_Middle_Name = ''; 
				  }else
					  {
					  stud_Middle_Name = xmlhttp.responseXML.documentElement.getElementsByTagName("Student")[i].getElementsByTagName("stud_M_Name")[0].childNodes[0].nodeValue;
					  }
			  if( xmlhttp.responseXML.documentElement.getElementsByTagName("Student")[i].getElementsByTagName("stud_L_Name")[0].childNodes[0].nodeValue == '@')
			  {
				  stud_Last_Name = '';
			  }else
				  {
				  stud_Last_Name = xmlhttp.responseXML.documentElement.getElementsByTagName("Student")[i].getElementsByTagName("stud_L_Name")[0].childNodes[0].nodeValue;
				  }
			  var stud_PRN = xmlhttp.responseXML.documentElement.getElementsByTagName("Student")[i].getElementsByTagName("stud_PRN")[0].childNodes[0].nodeValue;
			  stud_PRN = stud_PRN.toString();
			  var stud_First_Name = xmlhttp.responseXML.documentElement.getElementsByTagName("Student")[i].getElementsByTagName("stud_F_Name")[0].childNodes[0].nodeValue;
			  var stud_Pass = xmlhttp.responseXML.documentElement.getElementsByTagName("Student")[i].getElementsByTagName("stud_Pass")[0].childNodes[0].nodeValue;
			  if(stud_Middle_Name=='@')
				  {
				  stud_Middle_Name = '';
				  }
			  if(stud_Last_Name=='@')
			  {
			  stud_Middle_Name = '';
			  }
			  var increment = parseInt(parseInt(i)+parseInt(1));
			  
			showData = "<tr style=\"height:24px\"><td width=\"30px\" style=\"text-align:center\">"+increment+".</td>"+
			  	               "<td style=\"text-align:center\" width=\"110px\">"+stud_PRN+"</td>"+
			  			       "<td width=\"380px\" style=\"text-align:left\">" +
			  			          "<div id=\"divEditStudName"+increment+"\" style=\"display:none;width:380px\">" +
			  			              "<input type=\"text\"  id=\"txtFirstName"+stud_PRN+"\" style=\"width:110px\" onkeypress=\"return checkAlpha(event);\" value=\""+stud_First_Name+"\">"+
			  			              "&nbsp;<input type=\"text\"  id=\"txtMiddleName"+stud_PRN+"\" style=\"width:110px\" onkeypress=\"return checkAlpha(event);\" value=\""+stud_Middle_Name+"\">"+
			  			              "&nbsp;<input type=\"text\"  id=\"txtLastName"+stud_PRN+"\" style=\"width:110px\" onkeypress=\"return checkAlpha(event);\" value=\""+stud_Last_Name+"\">"+
			  			          "</div>" +
			  			          "<div id=\"divShowStudName"+increment+"\" style=\"display:inline;\">&nbsp;"+stud_First_Name +"&nbsp;"+stud_Middle_Name+"&nbsp;"+ stud_Last_Name +"</div>" +
			  			       "</td>" +
			  			       "<td style=\"text-align:center\" width=\"126px\">" +
			  			             "<div id=\"divEditStudPass"+increment+"\" style=\"display:none\">" +
			  			                   "<input type=\"text\" id=\"txtStudPass"+stud_PRN+"\" style=\"width:80px\" maxlength=\"10\" style=\"\" value=\""+stud_Pass +"\"/>" +
			  			             "</div>"+
			  			             "<div id=\"divShowStudPass"+increment+"\" style=\"display:inline;text-align:center\">"+ stud_Pass +"</div>" +
			  			       "</td>" +
			  			       "<td style=\"text-align:center\" width=\"100px\">" +
			  			             "<div id=\"divShowEdit"+increment+"\">" +
			  			             		"<img src=\"images/edit_user.png\" id=\""+increment+"\" onclick=\"EditStudentProfile('"+stud_PRN.toString()+"',this.id)\" style=\"height: 20px; width: 25px;vertical-align: bottom;\" ></img>" +
			  			             "</div>" +
			  			            "<div id=\"divCancelEdit"+increment+"\" style=\"display:none\">" +
			  			                  "<img id=\""+increment+"\" src=\"images/update_user.png\" style=\"height: 20px; width: 25px;vertical-align: bottom;\" onclick=\"UpdateStudentProfile('"+stud_PRN.toString()+"',this.id)\"/>&nbsp;&nbsp;" +
			  			                  "<img src=\"images/cancel-icon.png\" id=\""+increment+"\" style=\"height: 20px; width: 20px;vertical-align: bottom;\" onclick=\"CancelStudentProfile('"+stud_PRN.toString()+"',this.id)\"/>" +
			  			           "</div>"+
			  			       "</td>" +
			  			       "<td width=\""+setCheckBox+"px\" style=\"text-align:center\">" +
			  			       		"<input type=\"checkbox\"  value=\""+stud_PRN+"\" name=\"chkSelectEditCandidate\" style=\"border: 0;\" id=\"chkSelectEditCandidate"+increment+"\">"+
			  			            "<input type=\"hidden\"  id=\"hidFirstName"+stud_PRN+"\"  value=\""+stud_First_Name+"\">"+
			  			            "&nbsp;<input type=\"hidden\"  id=\"hidMiddleName"+stud_PRN+"\"  value=\""+stud_Middle_Name+"\">"+
			  			            "&nbsp;<input type=\"hidden\"  id=\"hidLastName"+stud_PRN+"\"  value=\""+stud_Last_Name+"\">"+
			  			      "</td>" +
			  			      "</tr>";
			 
			  	showWholeData = showWholeData + showData;
			  }
		  displayData = displayData + showWholeData +"</table></div><div id=\"Container\" style=\"width:800px;margin-top:25px\"><div id=\"divLeftChangePass\" style=\"float:left;width:400px\"><fieldset class=\"fieldsetPass\" style=\"height:100px;\">"+
			"<legend style=\"margin:0px 200px 0px 0px;color:blue;font-size:9pt;\">Password Management</legend>" +
			"<table style=\"width:350px;\"><tr><td><label style=\"float:left;margin-right: 10px;\" >Change Password</label><div style=\"margin-top:5px\">" +
			"&nbsp;&nbsp;&nbsp;&nbsp;<input type=\"text\"  id=\"txtPassword\" style=\"width:100px;height:18px\" maxlength=\"10\" value=\"\"><input type=\"button\" class=\"button\" value=\"Change\" id=\"btnChangeStud\" onclick=\"ChangePassword("+totalStudent+")\" /><label style=\"margin-top: 5px;\"></td></tr>" +
			"<tr><td>Randomize Password</label><input style=\"margin-top: 4px;\" type=\"button\" class=\"button\" value=\"Random\" id=\"btnpassword\" onclick=\"genearatePassword("+totalStudent+")\" /><input type=\"button\" class=\"button\" value=\"Default\" title=\"Password Set To Default\" id=\"btndefault\" onclick=\"setPasswordToDefault()\"></td></tr><tr><td>Download&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type=\"button\" class=\"button\" value=\"Download\" title=\"Download Student List\" id=\"btndownload\" onclick=\"DownloadSheet()\"></td></tr></table></div>" +
		
"</div><div id=\"divLeftChangeStatus\" style=\"float:right;width:400px\"><fieldset class=\"fieldsetPass\" style=\"height:65px;\"><legend style=\"margin:0px 220px 0px 20px;color:blue;font-size:9pt;\">Change Status</legend><div style=\"margin-top:5px\">" +
"<input type=\"button\" class=\"button\" value=\"Block\" id=\"btnBlockStud\" onclick=\"BlockUser("+totalStudent+")\" />" +
"&nbsp;<input type=\"button\" class=\"button\" value=\"Unblock\" id=\"btnUnblockStud\" onclick=\"UnBlockStudent("+totalStudent+")\" /></div></fieldset></div><div style=\"clear:both\"></div></dv>";
		  
		  document.getElementById('modalChangeStudInfoContent').innerHTML = displayData;		
		  $(".showTableData tr:even").css("background-color", "#F2F2F2");
		  $(".showTableData tr:odd").css("background-color", "#FBF9F5");
	    }else
	    	{
	    	if(document.getElementById('modalChangeStudInfoContent')!=null)
				document.getElementById('modalChangeStudInfoContent').innerHTML="<div style=\"margin:100px;0px;0px;0px;\"><img src=\"images/ajaxLoader.gif\" style=\"width:40px;height:40px;\"></div>";
	    	}
	   };
	   	xmlhttp.open("POST","ChangePassword",true);
		xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
		
		xmlhttp.send();
		return true;	
}


function  resetAllStudents(lTotalUsers){
	if(document.getElementById('chkSelectStudentAll')!=null)
		document.getElementById('chkSelectStudentAll').checked=false;	
	
	for(var j=1;j<=lTotalUsers;j++)
	{
		if(document.getElementById('chkSelectEditCandidate'.concat(j))!=null)
			document.getElementById('chkSelectEditCandidate'.concat(j)).checked=false;
	}
}
function  ChangePassword(totalStudent){
	var StudentIds = giveCheckStudent(totalStudent);  
	var strPassword = document.getElementById("txtPassword").value;
	if(strPassword=="")
	{
	 document.getElementById("labelMessage").innerHTML = "Please enter password";
	 setTimeout("document.getElementById('labelMessage').innerHTML=''",4000);
	 document.getElementById("txtPassword").focus();
	 return false;
	}
	if(StudentIds=="")
		{
		document.getElementById("labelMessage").innerHTML = "Please select student";
		setTimeout("document.getElementById('labelMessage').innerHTML=''",4000);
		 return false;
		}
	else{
		var url = "StudentIds="+StudentIds+"&strPassword="+strPassword;
		if (window.XMLHttpRequest)
		  {// code for IE7+, Firefox, Chrome, Opera, Safari
			xmlhttp =new XMLHttpRequest();
		  }
		else
		  {// code for IE6, IE5
			xmlhttp =new ActiveXObject("Microsoft.XMLHTTP");
		  }
		xmlhttp.onreadystatechange=function()
		  {
		  if (xmlhttp.readyState==4 && xmlhttp.status==200)
		    {
			  setChangePassword(totalStudent);
			  resetAllStudents(totalStudent);
			  document.getElementById("txtPassword").value="";
			  document.getElementById("labelMessage").innerHTML = "Selected students password changed";
			  setTimeout("document.getElementById('labelMessage').innerHTML=''",4000);
		    }
		   };
			xmlhttp.open("POST","ChangeStudentPassword",true);
			xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
			xmlhttp.setRequestHeader("Connection", "close");
			xmlhttp.send(url);
			return true;  
	}
}
function setChangePassword(totalStudentValue)
{
	 names = document.getElementsByName("chkSelectEditCandidate");
	 var strPassword = document.getElementById("txtPassword").value;
			for(var i = 0; i < totalStudentValue; i++){
				var increment = parseInt(parseInt(i)+parseInt(1));
				if(names[i].checked) {
					document.getElementById('divShowStudPass'+increment).innerHTML = strPassword;
					document.getElementById('txtStudPass'+names[i].value).value = strPassword;
				}
			}
}
function  BlockUser(totalStudent){
	var StudentIds = giveCheckStudent(totalStudent);
	
	if(StudentIds=="")
		{
		document.getElementById("labelMessage").innerHTML = "Please select student";
		setTimeout("document.getElementById('labelMessage').innerHTML=''",4000);
		 return false;
		}
	else{
		var url = "StudentIds="+StudentIds;
		if (window.XMLHttpRequest)
		  {// code for IE7+, Firefox, Chrome, Opera, Safari
			xmlhttp =new XMLHttpRequest();
		  }
		else
		  {// code for IE6, IE5
			xmlhttp =new ActiveXObject("Microsoft.XMLHTTP");
		  }
		xmlhttp.onreadystatechange=function()
		  {
		  if (xmlhttp.readyState==4 && xmlhttp.status==200)
		    {
			  resetAllStudents(totalStudent);
			  document.getElementById("labelMessage").innerHTML = "Selected students blocked successfully";
			  setTimeout("document.getElementById('labelMessage').innerHTML=''",4000);
		    }
		   };
			xmlhttp.open("POST","BlockStudent",true);
			xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
			xmlhttp.setRequestHeader("Connection", "close");
			xmlhttp.send(url);
			return true;  
	}
}
function  UnBlockStudent(totalStudent){
	var StudentIds = giveCheckStudent(totalStudent);  
	if(StudentIds=="")
		{
		document.getElementById("labelMessage").innerHTML = "Please select student";
		setTimeout("document.getElementById('labelMessage').innerHTML=''",4000);
		 return false;
		}
	else{
		var url = "StudentIds="+StudentIds+"&StudentStatus=unblock";
		if (window.XMLHttpRequest)
		  {// code for IE7+, Firefox, Chrome, Opera, Safari
			xmlhttp =new XMLHttpRequest();
		  }
		else
		  {// code for IE6, IE5
			xmlhttp =new ActiveXObject("Microsoft.XMLHTTP");
		  }
		xmlhttp.onreadystatechange=function()
		  {
		  if (xmlhttp.readyState==4 && xmlhttp.status==200)
		    {
			  document.getElementById("labelMessage").innerHTML = "Selected students Unblocked successfully";
			  resetAllStudents(totalStudent);
			  setTimeout("document.getElementById('labelMessage').innerHTML=''",4000);
		    }
		   };
			xmlhttp.open("POST","BlockStudent",true);
			xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
			xmlhttp.setRequestHeader("Connection", "close");
			xmlhttp.send(url);
			return true;  
	}
}
function giveCheckStudent(totalStudentValue)
{
	 names = document.getElementsByName("chkSelectEditCandidate");
		var namelist = "";
			for(var i = 0; i < totalStudentValue; i++){
				if(names[i].checked) {
					namelist += "'"+ names[i].value + "'" + ",";
				}
			}
		if(namelist == "") {
			return namelist;
		} else { 
			return namelist;
		}
}
function selectCheckStudent(lTotalUsers)
{
	if(document.getElementById('chkSelectStudentAll')!=null)
	{	if(document.getElementById('chkSelectStudentAll').checked==true)
			for(var i=1;i<=lTotalUsers;i++)
			{
				if(document.getElementById('chkSelectEditCandidate'.concat(i))!=null)
					document.getElementById('chkSelectEditCandidate'.concat(i)).checked=true;
			}
	
		if(document.getElementById('chkSelectStudentAll').checked==false)
			for(var j=1;j<=lTotalUsers;j++)
			{
				if(document.getElementById('chkSelectEditCandidate'.concat(j))!=null)
					document.getElementById('chkSelectEditCandidate'.concat(j)).checked=false;
			}
	}
}

function EditStudentProfile(id,obj)
{
	hideDisplay(id,obj);	
}

function hideDisplay(id,obj)
{
	var lengthDiv = document.getElementById("showTableData").rows.length;
	if(giveCheckStudent(lengthDiv)!= ""){
		document.getElementById("labelMessage").innerHTML = "Please uncheck the students";
		setTimeout("document.getElementById('labelMessage').innerHTML=''",4000);
		return false;
	}
		
	var i ;
	for(i=1 ;i<=lengthDiv; ++i)
	{
		document.getElementById("divEditStudName"+i).style.display='none';
		document.getElementById("divShowStudName"+i).style.display='inline';
		document.getElementById("divShowEdit"+i).style.display='inline';
		document.getElementById("divCancelEdit"+i).style.display='none';
		document.getElementById("divEditStudPass"+i).style.display='none';
		document.getElementById("divShowStudPass"+i).style.display='inline';
		
	}
	document.getElementById("divEditStudName"+obj).style.display='inline';
	document.getElementById("divShowStudName"+obj).style.display='none';
	document.getElementById("divCancelEdit"+obj).style.display='inline';
	document.getElementById("divShowEdit"+obj).style.display='none';
	document.getElementById("divEditStudPass"+obj).style.display='inline';
	document.getElementById("divShowStudPass"+obj).style.display='none';
}

function UpdateStudentProfile(id,obj)
{
	var firstName ;
	var middleName;
	var lastName;
	var studPass;
	firstName = document.getElementById("txtFirstName"+id).value;
	middleName = document.getElementById("txtMiddleName"+id).value;
	lastName = document.getElementById("txtLastName"+id).value;
	studPass = document.getElementById("txtStudPass"+id).value;
	
	var url;
	url = "firstName="+firstName+"&middleName="+middleName+"&lastName="+lastName+"&studPass="+studPass+"&studId="+id;
	if (window.XMLHttpRequest)
	  {// code for IE7+, Firefox, Chrome, Opera, Safari
		xmlhttp =new XMLHttpRequest();
	  }
	else
	  {// code for IE6, IE5
		xmlhttp =new ActiveXObject("Microsoft.XMLHTTP");
	  }
	xmlhttp.onreadystatechange=function()
	  {
	  if (xmlhttp.readyState==4 && xmlhttp.status==200)
	    {
		  var labelMessage = xmlhttp.responseXML.getElementsByTagName("Student")[0].getElementsByTagName("message")[0].firstChild.nodeValue;
			document.getElementById("labelMessage").innerHTML = labelMessage ;
		    document.getElementById("divCancelEdit"+obj).style.display='none';
			document.getElementById("divShowEdit"+obj).style.display='inline';
			document.getElementById("divEditStudPass"+obj).style.display='none';
			document.getElementById("divShowStudPass"+obj).style.display='inline';
			document.getElementById("divEditStudName"+obj).style.display='none';
			document.getElementById("divShowStudName"+obj).style.display='inline';
			if(middleName=='')
			{
				document.getElementById("divShowStudName"+obj).innerHTML = firstName + "&nbsp;" + lastName;
			}else
				{
				document.getElementById("divShowStudName"+obj).innerHTML = firstName+"&nbsp;"+middleName+"&nbsp;"+lastName;
				}
			document.getElementById("divShowStudPass"+obj).innerHTML = studPass ;
			document.getElementById("hidFirstName"+id).value = firstName;
			document.getElementById("hidMiddleName"+id).value = middleName;
			document.getElementById("hidLastName"+id).value = lastName;
			setTimeout("document.getElementById('labelMessage').innerHTML=''",4000);	
	    }
	  };
	    xmlhttp.open("POST","UpdateStudentInfo",true);
	    xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
		xmlhttp.setRequestHeader("Content-length", url.length);
		xmlhttp.setRequestHeader("Connection", "close");
		xmlhttp.send(url);
		return true;
	
}

function CancelStudentProfile(id,obj)
{
	var test = 	document.getElementById("divShowStudPass"+obj).innerHTML;
	document.getElementById("txtStudPass"+id).value = test;
	document.getElementById("divEditStudName"+obj).style.display='none';
	document.getElementById("divShowStudName"+obj).style.display='inline';
	document.getElementById("divCancelEdit"+obj).style.display='none';
	document.getElementById("divShowEdit"+obj).style.display='inline';
	document.getElementById("divEditStudPass"+obj).style.display='none';
	document.getElementById("divShowStudPass"+obj).style.display='inline';
	document.getElementById("txtFirstName"+id).value = document.getElementById("hidFirstName"+id).value;
	document.getElementById("txtMiddleName"+id).value = document.getElementById("hidMiddleName"+id).value;
	document.getElementById("txtLastName"+id).value = document.getElementById("hidLastName"+id).value;
	
}


