/**
 * @author Sherin Mathew
 * @date 24/05/2012
 * @description This javascript calls a AJAX for the updating the user info from AdminUserMan page
 * */	
		

function getHTTPObject() 
	{
	    var xmlhttp;
	    if (window.XMLHttpRequest)
	    {
	    	// code for IE7+, Firefox, Chrome, Opera, Safari
	 		xmlhttp=new XMLHttpRequest();
	    } 
	    else if (window.ActiveXObject) 
	    {
	    	// code for IE6, IE5
	  		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	    }
	    return xmlhttp;
	}

function updateUserData(){
	
	var http = getHTTPObject();// We create the XMLHTTPRequest Object
	if(validateProf()){
	var strFName=document.getElementById('idTxtFName').value;
	var strMName="";
	if((document.getElementById('idTxtMName').value).trim()=="--"){
		strMName="";
	}
	else{
		strMName=document.getElementById('idTxtMName').value;
	}
	var strLName =document.getElementById('idTxtLname').value;
	var strDOB	 =document.getElementById('idTxtDOB').value;
	var strGender=document.frmProfile.elements['gender'];
	var strGenderValue="";
	for ( var i = 0; i < strGender.length; i++) {
		if(strGender[i].checked){
			strGenderValue=strGender[i].value;
			
		}
	}
	
	var strEMailId=document.getElementById('idTxtEmail').value;
	var strMNumber=document.getElementById('idTxtContactNo').value;
	var strUserId=document.getElementById('CCID').value;
	var parameters="strFName="+strFName+"&strMName="+strMName+"&strLName="+strLName+"&strDOB="+strDOB+"&strGender="+strGenderValue+"&strEMailId="+strEMailId+"&strMNumber="+strMNumber+"&strUserId="+strUserId;
	http.open("POST","AdminUpdateExaminer", true);
    http.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    http.send(parameters);
	
	http.onreadystatechange=function()
	{
	    if (http.readyState == 4) 
	    {
	   		if (http.status == 200 || http.status=='complete')
	   		{
	   			var result=http.responseText;
	   			document.getElementById('IdSeMsg').innerHTML=result;
	   			killThis('IdSeMsg');
	   			
	   			/*---------------------------------------------------*/
	   			
	   			
	   			/*----------------------------------------------*/
	   		}
			
	    }
	};
	
	document.getElementById("idGenderM").disabled=true;
	document.getElementById("idGenderF").disabled=true;
	document.getElementById("editRow").style.display="inline";
	document.getElementById("updateRow").style.display="none";
	var inputArray = document.frmProfile.getElementsByTagName("input");
		i=0;
		while(i<inputArray.length)
			{
			
			inputArray [i].disabled=true;
			inputArray [i].setAttribute("class","transparent");
			inputArray [i].setAttribute("className","transparent");
			
			
			
			i++;
			}
	}
}


