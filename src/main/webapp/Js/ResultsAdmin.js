/**
 * @author Sherin Mathew
 * @date 24/05/2012
 * @description This javascript calls the AJAX for the ResultsAdmin page to display the 
 * results 
 * */	
		
function createxmlHttp()
{	
		var xmlDoc;
		if (window.XMLHttpRequest)
		  {// code for IE7+, Firefox, Chrome, Opera, Safari
			xmlhttp=new XMLHttpRequest();
		  }
		else if (window.ActiveXObject) 
		{ 
			try { 
				xmlhttp = new ActiveXObject("Msxml2.XMLHTTP"); 
			} 
			catch (e)
			{ 
				try{ 
					xmlhttp = new ActiveXObject("Microsoft.XMLHTTP"); 
					}	 
					catch (e){} 
			} 
		} 
	return xmlhttp;
}
/**
 * 
 * @param strCourseId
 */
function getModules(strCourseId)
{
	
	if(document.getElementById('selectCourse').selectedIndex>0)
	{
		xmlHttpCourse=createxmlHttp();
		xmlHttpCourse.open("POST","AddDatesAjax",true);
		var parameters="strCourseId="+strCourseId+"&iFlag="+1;
		xmlHttpCourse.setRequestHeader("Content-type","application/x-www-form-urlencoded");
		xmlHttpCourse.setRequestHeader("Content-length",parameters.length);
		xmlHttpCourse.setRequestHeader("Connection","close");
		xmlHttpCourse.send(parameters);
		
		xmlHttpCourse.onreadystatechange=function(){
			if(xmlHttpCourse.readyState==4 && xmlHttpCourse.status==200){
				responseHandler(xmlHttpCourse);
				document.getElementById("divInitialMessage").innerHTML='Please select module';
			}
			
			else if(xmlHttpCourse.readyState!=4 || xmlHttpCourse.status!=200){
				
				document.getElementById("divInitialMessage").innerHTML='<img alt="" src="images/ajaxLoader.gif"><br/>Loading...';
				document.getElementById('divInitialMessage').style.display='block';
				//document.getElementById('divResultDisplay').style.display='none';
			}
				
	
		}
}
	
	else
	{
		
		document.getElementById('divInitialMessage').style.display='block';
		document.getElementById('divResultDisplay').style.display='none';
		
		document.getElementById("divInitialMessage").innerHTML='Please select course';
		document.getElementById('selectModule').options.length = 1;
		document.getElementById('selectExamDate').options.length = 1;
		document.getElementById("divResultDisplay").style.visibility='hidden';
	}
	
	
}


function getExamDates(strModuleId,strUserRole)
{
	
	if(document.getElementById('selectModule').selectedIndex>0)
	{
		xmlHttpModule=createxmlHttp();
		xmlHttpModule.open("POST","AddDatesAjax",true);
		var moduleparameters="strModuleId="+strModuleId+"&iFlag="+2+"&strUserRole="+strUserRole;
		xmlHttpModule.setRequestHeader("Content-type","application/x-www-form-urlencoded");
		xmlHttpModule.setRequestHeader("Content-length",moduleparameters.length);
		xmlHttpModule.setRequestHeader("Connection","close");
		xmlHttpModule.send(moduleparameters);
		xmlHttpModule.onreadystatechange=function(){
			if(xmlHttpModule.readyState==4 && xmlHttpModule.status==200){
				
				responseHandlerforExamDates(xmlHttpModule);
				document.getElementById("divInitialMessage").innerHTML='Please select exam-date';
			}
			
			else{
				document.getElementById("divInitialMessage").innerHTML='<img alt="" src="images/ajaxLoader.gif"><br/>Loading...';
				document.getElementById('divInitialMessage').style.display='block';
				//document.getElementById('divResultDisplay').style.display='none';
			}
	}
}
	else{
			document.getElementById('divInitialMessage').style.display='block';
			document.getElementById('divResultDisplay').style.display='none';
			document.getElementById("divInitialMessage").innerHTML="Please select module";
			document.getElementById('selectExamDate').options.length = 1;
			document.frmResultMenu.selectedValue.value=document.frmResultMenu.selectModule.innerHTML;
	}
	
}



function responseHandler(xmlHttpCourse){
	var i,j;
	xmlDoc	=	xmlHttpCourse.responseXML;
	var modules=xmlDoc.getElementsByTagName("modules")[0];
	var moduleSerialNo=modules.getElementsByTagName("moduleSerialNo");
	var modulelength;
	var moduleName;
	var valuemoduleID;
	
	
	document.getElementById('selectModule').options.length = 1;
	
	for(i=0;i<moduleSerialNo.length;i++){
		modulelength=moduleSerialNo[i].getElementsByTagName('modulename').length;
		
		for(j=0;j<modulelength;j++)
			{
				moduleName=moduleSerialNo[i].getElementsByTagName('modulename')[j].childNodes[0].nodeValue;
				valuemoduleID=moduleSerialNo[i].getElementsByTagName('moduleId')[j].childNodes[0].nodeValue;
				
			}
		document.getElementById('selectModule').options[i+1]= new Option(moduleName,valuemoduleID+"");
		
	}
	

}
var k;
var strmodulename;
function responseHandlerforExamDates(xmlHttpModule){
	
	xmlDocc	=	xmlHttpModule.responseXML;
	
	var valuesexamdates=xmlDocc.getElementsByTagName("examdates")[0];
	var exam=valuesexamdates.getElementsByTagName("examdate");
	
	
	var examdatesValue;
	var dateName;
	var examlength;
	
	document.getElementById('selectExamDate').options.length = 1;
	
	for(j=0;j<exam.length;j++){
		examlength=exam[j].getElementsByTagName('date').length;
		
		for(k=0;k<examlength;k++){
		examdatesValue=exam[j].getElementsByTagName('date')[k].childNodes[0].nodeValue;
		}
		
			
		document.getElementById('selectExamDate').options[j+1]= new Option(examdatesValue,examdatesValue+"");
	}
	document.getElementById('txtModuleName').value=document.getElementById('selectModule').options[document.getElementById('selectModule').selectedIndex].text;
	strmodulename=document.getElementById('txtModuleName').value;
	//var test=document.getElementById('selectedValue').value;
	//alert(test);
}

function retainValues(){
		
	
}





	function printPage()													//This Function will Display the page as it is viewed in print preview mode
	{
		
		document.getElementById("body_main_banner").style.display="none";
		document.getElementById("footerNew").style.display="none";
		document.getElementById("divSeparator").style.display="none";
		document.getElementById("printRow").style.display="none";
		document.getElementById("print_Banner").style.display="block";
		document.getElementById("header_msg").style.display="none";
		document.getElementById("cancelRow").style.display="block";
		//document.getElementById("header_Links").style.display="none";
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
		document.getElementById("footerNew").style.display="none";
		document.getElementById("divSeparator").style.display="block";
		document.getElementById("printRow").style.display="block";
		document.getElementById("print_Banner").style.display="none";
		document.getElementById("header_msg").style.display="block";
		document.getElementById("cancelRow").style.display="none";
		//document.getElementById("header_Links").style.display="block";
		if(document.getElementById("paggingRow"))
			document.getElementById("paggingRow").style.display="block";
		document.getElementById("divTableHolder").style.display="block";
		document.getElementById("divPrintBack").style.display="none";
	}
	
	function fetchResult(){
	if(document.getElementById('selectExamDate').selectedIndex>0){
		document.frmResultMenu.submit();
		}
	else{
		
		document.getElementById('divInitialMessage').style.display='block';
		document.getElementById('divResultDisplay').style.display='none';
		document.getElementById("divInitialMessage").innerHTML="Please select exam-date";
	}
	}

	function getNextPage(iPageNo)				//This Function will help user to browse to the different page number as it is displayed on the page
	{
		
		var frm=document.frmResult;
		var iPageSize=parseInt(frm.txtPageSize.value);				
		var iTemp=parseInt(iPageNo)*iPageSize;				
		frm.txtPageStart.value=iTemp;
		frm.txtPageEnd.value=iTemp+iPageSize;
		frm.txtPageId.value=parseInt(iPageNo)+1;
		frm.action="ResultsAdmin.jsp";
		frm.method="post";
		frm.submit();
	}
	
	function submitFrmResultDetail(studId)
	{
		document.getElementById('txtSelectedRollNo').value=studId;
		document.getElementById('frmResultDetail').submit();
		
	}


