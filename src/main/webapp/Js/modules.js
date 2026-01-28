function frmSubmit()
{
	
	
	var frm	=	document.getElementById('frmEditModule');
	frm.action="Questions.jsp";
	frm.method="post";
	frm.submit();

}


/*Method for creating ajax request*/
function ajaxOperations(selectedModuleId)
{
	   try{
				// Opera 8.0+, Firefox, Safari
		    	xmlHttpRequest = new XMLHttpRequest();
			} catch (e)
			{
						// Internet Explorer Browsers
						try{
							xmlHttpRequest = new ActiveXObject("Msxml2.XMLHTTP");
						} catch (e) {
										try{
											xmlHttpRequest = new ActiveXObject("Microsoft.XMLHTTP");
										} catch (e){
											// Something went wrong
											alert("Please refresh or restart browser again");
											return false;
										}
									}
			}

    
		xmlHttpRequest.onreadystatechange=function ()
		{
			if(xmlHttpRequest.readyState==4 && xmlHttpRequest.status==200)
			{
				responseHandler(xmlHttpRequest);
			}
			else 
			{
				//if(document.getElementById('divCentres')!=null)
				//	document.getElementById('divCentres').innerHTML="<div style=\"margin:100px;0px;0px;0px;\"><img src=\"images/ajaxLoader.gif\" style=\"width:40px;height:40px;\"></div>"
			}
		}
		var callId='1';
		params="callId="+callId+"&ajaxSelectedModuleId="+selectedModuleId+"";		//compulsory for calling servlet
		xmlHttpRequest.open("POST","CheckOperationsAjax",true);
		xmlHttpRequest.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
		xmlHttpRequest.setRequestHeader("Content-length", params.length);
		xmlHttpRequest.send(params);
}
function responseHandler(xmlHttpRequest)
{
	var xmlHandler=xmlHttpRequest.responseXML;

	var ExamModuleScheduleIds;
	
	ExamModuleScheduleIds	=	xmlHandler.getElementsByTagName("ExamModuleScheduleIds")[0];
	
	/**
	 * If any exam is scheduled show message
	 */
	if(ExamModuleScheduleIds!=null)
	{
			if(ExamModuleScheduleIds.childNodes.length>0)
			{
				showModalDiv('modalExamCheckPage');

			}
			else
			{
				frmSubmit();
				
			}
	}
}



/*****************Add New Module begins****************/
function goAddModuleView(e)
{
	if(e==1)
	{
		//document.getElementById("add_module_back").style.display="none";
		document.getElementById("add_module").style.display="table-row";
	}
	else
	{
		//document.getElementById("add_module").style.display="none";
		//document.getElementById("add_module_back").style.display="table-row";
	}
}

/**************** Add Module page ************************/
function goAddModuleSave()
{
	var frm=document.getElementById('frmAddModule');
	if(frm.txtModuleName.value=="" || ((frm.txtModuleName.value).replace(/\s/g,""))=="") 
	{
		alert("Please Enter module name");
		frm.txtModuleName.focus();
		return false;
	}
	if(((frm.txtModuleName.value).replace(/\s/g,"")).length<5)
	{
		alert("Module name can not be less than 5 characters.");
		frm.txtModuleName.focus();
		return false;
	}
	if(!isNaN(frm.txtModuleName.value))
	{
		alert("Module name can not be numbers.");
		frm.txtModuleName.focus();
		return false;
	}
	if(!isDataCorrect(frm.txtModuleName.value,"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ()1234567890+-&.,/ "))
	{
		alert("Module name can not include special characters other than &.");
		frm.txtModuleName.focus();
		return false;
	}
	return true;
}






function goShowUpdate()
{
		document.getElementById("update_module_update").style.display="none";
		document.getElementById("update_module_edit").style.display="table-row";
		var index= document.getElementById("txtNoOfModule").value;
		if(index>1)
		{
			for(var i=0;i<index;i=i+1)
			{
				
				document.getElementById("txtModule"+i).readOnly="readonly";
				document.getElementById("txtModule"+i).style.backgroundColor="transparent";
				document.getElementById("txtModule"+i).style.fontWeight="";
			}
		}
		else
		{
		
			document.getElementById("txtModule0").readOnly="readonly";
			document.getElementById("txtModule0").style.backgroundColor="transparent";
			document.getElementById("txtModule0").style.fontWeight="";
		}
}
function goSelectModule()
{
	var frm,optModule,index,flag;
	frm=document.frmEditModule;
	index= frm.txtNoOfModule.value;
	optModule=frm.optModule;
	flag=-1;
	if(index>1)
	{
		for(var i=0;i<index;i=i+1)
		{
			if(optModule[i].checked==true)//len or index works same
			{
				flag=i;
				break;
			}
		}
	}
	else
	{
		if(optModule.checked==true)
			flag=0;
	}
	return flag;
}
function goEditModule(e)
{
	var optIndex=goSelectModule();

	if(optIndex>=0)
	{
		document.getElementById("update_module_edit").style.display="none";
		document.getElementById("update_module_update").style.display="table-row";
		document.getElementById("txtModule"+optIndex).readOnly="";
		document.getElementById("txtModule"+optIndex).style.backgroundColor="#FFF8C6";
		document.getElementById("txtModule"+optIndex).style.fontWeight="bold";
		document.getElementById("txtModule"+optIndex).focus();
	}
	else
	{
		alert("Please select a module to edit.");
	}
	
}
function goUpdateModule()
{
	var optIndex=goSelectModule();
	if(optIndex>=0)
	{
		var strModule=document.getElementById("txtModule"+optIndex);
		if(strModule.value=="" || ((strModule.value).replace(/\s/g,""))=="") 
		{
			alert("Please Enter module name");
			strModule.focus();
			return false;
		}
		if(((strModule.value).replace(/\s/g,"")).length<5)
		{
			alert("Module name can not be less than 5 characters.");
			strModule.focus();
			return false;
		}
		if(!isNaN(strModule.value))
		{
			alert("Module name can not be numbers.");
			strModule.focus();
			return false;
		}
		if(!isDataCorrect(strModule.value,"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ()1234567890+-&.,/ "))
		{
			alert("Module name can not include special characters other than &.");
			strModule.focus();
			return false;
		}
	}
	else
	{
		alert("Please select a module to edit/update.");
		return false;
	}
	document.getElementById("txtModuleIndex").value=optIndex;
	return true;
}






function goDeleteModule()
{
var optIndex=goSelectModule();
if(optIndex>=0)
{
	if(confirm("Are you sure to delete this module?")==true)
	{
		document.getElementById("txtModuleIndex").value=optIndex;
		document.frmEditModule.action="DeleteModule.pks";
		document.frmEditModule.method="post";
		document.frmEditModule.submit();
	}
}
else
{
	alert("Please select a module to delete.");
}
}







function goAddModuleSaveTest(lLastModuleId)
{
	if(goAddModuleSave()==true)
		showAddModuleMsg(lLastModuleId);
}


function isDataCorrect(strSource,strFormat)  //Common function for validating contents
{
	var iIterator,ilength;
	ilength=strSource.length;
	if(ilength==0)
	{
		return false;
	}
	for(iIterator=0;iIterator<ilength;iIterator++)
	{
		var val=strSource.charAt(iIterator);
		if(strFormat.indexOf(val)==-1)
		{
			return false;
		}
	}
	return true;
}

function showAddModuleMsg(lLastModuleId)
{
	var http = getHTTPObject(); // We create the XMLHTTPRequest Object
	var url = "AddModule.pks"; // The server-side script
	var formData ="?txtModuleName="+ escape((document.frmAddModule.txtModuleName.value)).replace(/\+/g, '%2B');
	http.onreadystatechange=function()
	{
	    if (http.readyState == 4) 
	    {
	   		if (http.status == 200 || http.status=='complete')
	   			parseMessages(http.responseXML,lLastModuleId);
	   		else
	    	{
	   			document.getElementById('ShowMessage').innerHTML = "<font style='color:red;' class='schedule_msg'>" + "Some error has occured while Adding module." + "</font>";
	      	}
	    }  
	    else
	    {
	    		document.getElementById('ShowMessage').innerHTML =null; 
	    		document.getElementById('ShowMessage').innerHTML = "<font style='color:black;' class='schedule_msg'>"+"Processing ..."+http.readyState+"</font>";
	    }
	};
	http.open("POST", url+formData, true);
    http.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    http.send();
}

 function parseMessages(responseXML,lLastModuleId)
 {
	var addModuleOutput = responseXML.getElementsByTagName("addModuleOutput")[0];
	if(addModuleOutput.childNodes.length > 0)
    {
    
    	var message;
    	var messageCode = addModuleOutput.getElementsByTagName("message")[0];
    	var messageColor ="#FF4500";
    	if((messageCode.childNodes[0].nodeValue)==0 || (messageCode.childNodes[0].nodeValue)=='0')
    	{
    		var moduleSNo = addModuleOutput.getElementsByTagName("moduleSNo")[0];
    		if(moduleSNo.childNodes[0].nodeValue==1)
    		{
    			var new_div=document.createElement("div");
    			new_div.style.minHeight="180px";
    			new_div.style.minWidth="340px";
    			new_div.style.maxWidth="600px";
    			var one_module=document.getElementById('one_add_module');
    			var tbl     = document.createElement("table");
    			tbl.setAttribute("border", "1pt");
    			tbl.setAttribute("cellpadding", "0");
    			tbl.setAttribute("cellspacing", "2");
    			tbl.setAttribute("id", "add_module_table");
    		    var tblBody = document.createElement("tbody");
    		    var newTR = document.createElement('tr');
    		    var newTD = document.createElement('th');
    		    newTD.setAttribute("align", "center");
    			newTD.innerHTML = "<div style='width: 40px;'>S.No.</div>";
    		    newTR.appendChild (newTD);
    		    var newTDModule = document.createElement('th');
    		    newTDModule.setAttribute("align", "center");
    		    newTDModule.innerHTML = "<div style='width: 300px;'>Module Name</div>";
    		    newTR.appendChild (newTDModule);
    		    tblBody.appendChild(newTR);
    		    tbl.appendChild(tblBody);
    		    new_div.appendChild(tbl);
    		    one_module.appendChild(new_div);
    		    document.getElementById('no_module').style.display="none";
    		}
    		
    		var moduleName =addModuleOutput.getElementsByTagName("moduleName")[0];
    		addNewRow(lLastModuleId,moduleSNo.childNodes[0].nodeValue, (moduleName.childNodes[0].nodeValue).replace("#38;",'&'));
    		message="New module added to the course successfully.";
    		messageColor ="#008B8B";
    		document.frmAddModule.btnCancel.click();
    	}
    	else if((messageCode.childNodes[0].nodeValue)==1 || (messageCode.childNodes[0].nodeValue)=='1')
    	{
    		message="Module with the this name is already in the course.";
    	}
    	else if((messageCode.childNodes[0].nodeValue)==2 || (messageCode.childNodes[0].nodeValue)=='2')
    	{
    		message="Error! module could not be added.";
    	}
    	else if((messageCode.childNodes[0].nodeValue)==11 || (messageCode.childNodes[0].nodeValue)=='11')
    		message="Error occured due to invalid session.";
    	
    	document.getElementById('ShowMessage').innerHTML =null;
    	document.getElementById('ShowMessage').innerHTML = "<font style='color:"+messageColor+";' class='schedule_msg'>" + message + "</font>";
    	
   } 
   else 
   {
		document.getElementById('ShowMessage').innerHTML =null;
    	document.getElementById('ShowMessage').innerHTML = "<font style='color:red;' class='schedule_msg'>" + "No output is produced." + "</font>";     
   }
    
}

function addNewRow(lLastModuleId,strSNo,strModulename)
{ 
		lLastModuleId=parseInt(lLastModuleId)+parseInt("1");//For new module id
		var myTable = document.getElementById("add_module_table");
		var tBody = document.getElementById("add_module_table_tbody");
		var newTR = document.createElement("tr");
		var newTD = document.createElement("td");
		newTD.innerHTML = "<div style='padding-left: 5px;'>"+strSNo+".</div>";
		newTR.appendChild(newTD);
		
		strSNo	=	strSNo-1; //Using srNo for adding text box for module names

		var newTDMName = document.createElement('td');
		newTDMName.align="left";
		newTDMName.innerHTML = "<div style='max-width: 450px;'>" +
									"<input type=\"text\" name='txtModule"+strSNo+"' id='txtModule"+strSNo+"' readOnly='readonly' "+
									" value="+strModulename+" maxlength='60' "+ 
									" style='width: 99%;padding-left: 5px;' class='inputText_No_border'>"+	
								"</div>";
		newTR.appendChild(newTDMName);
		
		
		var newTDEdit = document.createElement('td');
		newTDEdit.align="left";
		newTDEdit.innerHTML = "<input onclick=\" javascript:document.getElementById('optModule"+strSNo+"').checked='checked';goShowUpdate();goEditModule(0);\" " +
								" type='radio' name='optModule' id='optModule"+strSNo+"' value="+lLastModuleId+"> " +
								"<span style='padding-left:20px;'>" +
										"<img onclick=\"javascript:document.getElementById('txtSelectedModuleId').value=this.id;ajaxOperations(this.id);\" id="+lLastModuleId+" " +
										"src='images/questions.png'/>"+
								"</span>" ;
										
		
		newTR.appendChild (newTDEdit);
		tBody.appendChild(newTR);

		document.getElementById('txtNoOfModule').value=parseInt(document.getElementById('txtNoOfModule').value)+parseInt('1');

}
//                 End of add new module
/*****************Add New Module ends****************/