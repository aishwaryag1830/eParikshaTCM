/**
 * @author Sherin Mathew
 * @date 24/05/2012
 * @description This javascript validates the controls on the adminuserman page also it does the operation of
 * adding new user controls displaying the messages 
 * */	
		

function adminNewUser()
	{
		// To reset dropdown info
		
		document.frmCCSelect.reset();
		document.getElementById('welcomemsg').style.display="none";
		document.getElementById('tableStyle').style.display="block";
		document.getElementById('CCID').selectedIndex=0;
		//document.getElementById('IdSeMsg').style.display="block";
				
		
		// To reset profile info
		var inputArray = document.frmProfile.getElementsByTagName("input");
		i=0;
		while(i<inputArray.length)
			{
				inputArray [i].value="";
				//alert("inputArray ["+i+"].value"+inputArray [i].value)
				i++;
			}
		document.getElementsByName("gender")[0].value="Male";
		document.getElementsByName("gender")[1].value="Female";
		document.getElementsByName("gender")[0].checked=false;
		document.getElementsByName("gender")[1].checked=false;
		//idCourseNameBanner
		document.getElementById("idCourseNameBanner").innerHTML="None";
		// To clear content
		AdminEditInfo();		
		
		document.getElementById("updateRow").style.display="none";
		document.getElementById("saveRow").style.display="inline";
		document.getElementById("cancleRow").style.display="inline";
		
		
		document.getElementById("idTxtFName").focus();
		document.getElementById('CCID').disabled=true;
		document.getElementById('idBtnResetPass').disabled=true;
		document.getElementById('IdSeMsg').innerHTML="Please fill the form below";
		killThis('IdSeMsg');
		
		
	}
	
	
	// Validate and submit user info to update
	function adminSaveUpdate(TO)
	{
		var url = "";
		if(TO=='1')
			url = "AdminUpdateExaminer";
		else
			url = "AdminAddExaminer";
		
		document.frmProfile.action=url;
		if(validateProf())
			{
				document.frmProfile.submit();
			}
	document.getElementById('CCID').disabled="false";
		
	}
	
	
	
	// Function to send selected User ID
	
	function sendCCID()
	{
		if(document.getElementById('CCID').selectedIndex>0){
		val=document.getElementById("CCID").value;		
		
		if(val!=0)
			{
				document.frmCCSelect.submit();
			}
		
			
			var inputArray = document.frmProfile.getElementsByTagName("input");
			i=0;
			while(i<inputArray.length)
			{
			
				inputArray [i].setAttribute("class","transparent");
				inputArray [i].setAttribute("className","transparent");			
				i++;
			}
			
	}
	else{
			document.getElementById('tableStyle').style.display="none";
			document.getElementById('welcomemsg').style.display='block';
			document.getElementById('idBtnEdit').style.display="none";
			document.getElementById('cancleRow').style.display="none";
	}	
	}
	
	// Enable fields
	function AdminEditInfo()
	{
		var inputArray = document.frmProfile.getElementsByTagName("input");
		i=0;
		while(i<inputArray.length)
			{
			
			inputArray [i].disabled=false;
			inputArray [i].setAttribute("class","nonTransparent");
			inputArray [i].setAttribute("className","nonTransparent");
			
			
			
			i++;
			}
		document.getElementById("editRow").style.display="none";
		document.getElementById("updateRow").style.display="table-cell";
		document.getElementById("cancleRow").style.visibility="visible";
	}
	
	// Disable fields
	function AdminCancel()
	{
		document.getElementById('IdSeMsg').style.display="block";
		document.getElementById('CCID').disabled=false;
		
		document.getElementById('idBtnResetPass').disabled=false;	
		var inputArray = document.frmProfile.getElementsByTagName("input");
		var formObject=document.frmProfile;
		var formElement=formObject.elements;
		var fieldType;
		i=0;
		
		
		if(document.getElementById('idTxtFName').disabled || document.getElementById('idTxtFName').value=="" ){
			document.getElementById("editRow").style.display="none";
			
		}
		
		
		document.getElementById("editRow").style.display="inline";
		//document.getElementById("editRow").style.display="table-cell";
		document.getElementById("updateRow").style.display="none";
		document.getElementById("saveRow").style.display="none";
		//document.getElementById("newRow").style.display="block";
		document.getElementById("cancleRow").style.display="inline";
				
		
		
		if(document.getElementById('idTxtFName').value==""){
		
			for ( var i = 0; i < formElement.length; i++) {
			
					fieldType=formElement[i].type.toLowerCase();
			
					switch(fieldType){
						case "text":
						case "password":
						formElement[i].value="";
						document.getElementById('CCID').selectedIndex=0;
						document.getElementById('idCourseNameBanner').innerHTML="";
						break;
					case "radio":
						if (formElement[i].checked)
			        	{
							formElement[i].checked = false;
							formElement[i].disabled= true;
							
			        	}
			        	break;
					default:
						break;				
				}
			
			}
		}
		
		
		val=document.getElementById("CCID").value;		
		var inputArray = document.frmProfile.getElementsByTagName("input");
		//document.getElementById('fontcolorblack').style.visibility="hidden";
			i=0;
			while(i<inputArray.length)
			{
			
				inputArray [i].setAttribute("class","transparent");
				inputArray [i].setAttribute("className","transparent");
				inputArray [i].style.color="black";
				inputArray [i].setAttribute("className","fontcolorblack");			
				i++;
			}
			
			
			if(!validateProf()){
				document.getElementById('IdSeMsg').innerHTML="";
				document.getElementById('tableStyle').style.display="none";
				document.getElementById('welcomemsg').style.display="block";
				document.getElementById('editRow').style.display="none";
				document.getElementById('cancleRow').style.display="none";
				
				
			}
			
			while(i<inputArray.length)
			{
			
			
			inputArray [i].disabled=true;
			i++;
			}
			document.getElementById("idGenderM").disabled=true;
			document.getElementById("idGenderF").disabled=true;
			
		
	}
	
	// Reset Error message
	
	function disolveDiv(divID)
	{
		$('#'+divID).fadeOut('slow', function() {document.getElementById(divID).innerHTML= "&nbsp;";});
		//document.getElementById(divID).innerHTML= "";		
	}
	
	// Call to disolve message
	
	function killThis(divID)
	{
		
		callToFunction = "disolveDiv('"+divID+"')";
		var t=setTimeout(callToFunction,4000);
		
	}
	
	// To reset pass
	function resetPass()
	{
		var xmlhttp;
		var data = document.getElementById("CCID").value;
		document.getElementById("idResetStatus").innerHTML="<div style=\"color:green\">Wait...</div>";
		document.getElementById("idBtnResetPass").disabled = true;
		
		if (window.XMLHttpRequest)
		  {// code for IE7+, Firefox, Chrome, Opera, Safari
		  xmlhttp=new XMLHttpRequest();
		  }
		else
		  {// code for IE6, IE5
		  xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
		  }
		  xmlhttp.onreadystatechange=function()
		  {
		  if (xmlhttp.readyState==4 && xmlhttp.status==200)
		    {
			  	
		  		document.getElementById("idResetStatus").innerHTML=xmlhttp.responseText;
		  		document.getElementById("idBtnResetPass").disabled = false;
		  		killThis('tokill');
		    }
		  };
		xmlhttp.open("POST","AdminResetPass",true);
		xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
		xmlhttp.send("CCID="+data);
		
		
	}
	
	
	// validation script
	
	function check(e,patt ) {  
		var keynum;  
		var keychar;  
		var numcheck;  
		
		// For Internet Explorer  
		if (window.event)  
		{  
			keynum = e.keyCode;
			
		}  
		// For Netscape/Firefox/Opera  
		else if (e.which)  
		{  
			
			keynum = e.which;
			if (!keynum && ((e.charCode || e.charCode === 0) ? e.charCode : e.keyCode)) {
				keynum = e.charCode || e.keyCode;
		    }

			
		}  
		keychar = String.fromCharCode(keynum);
		//List of special characters you want to restrict  
		
		//if (keychar.match(patt))
			if (patt.test(keychar)||e.keyCode==8||e.keyCode==46||e.keyCode==9||e.keyCode==37||e.keyCode==39)
		{  
			return true;
		//return false;  
		}  
		else {  
			return false;
		//return true;  
		}  
	}  
	
	function checkAlpha(e)
	{
		// For alphabets only
		var patApha=/[(a-z|A-Z)]/g;
		return check(e ,patApha );
	}
	
	function checkEmail(e)
	{
		// For emaild character
		var patEmail=/[a-z|A-Z|0-9|.|_|\-|@]/g;
		
		return check(e,patEmail);
	}
	
	function checkContactNo(e)
	{
		// For contact number
		var patContactNo = /[0-9]/g;
		return check(e,patContactNo);
	}
	
	function checkDate(e)
	{
		var patContactNo = /[0-9|\/|()]/g;
		return check(e,patContactNo);
	}
	
	
	
	function validateProf()
	{
		
		var Fname		= document.getElementById("idTxtFName").value;
		var Manme		= document.getElementById("idTxtMName").value;
		//alert(document.getElementById("idTxtLname").value);
		var Lname		= document.getElementById("idTxtLname").value;
		var Email		= document.getElementById("idTxtEmail").value;
		var ContactNo	= document.getElementById("idTxtContactNo").value;
		var Gender		= "";
		var DOB			= document.getElementById("idTxtDOB").value;
		var emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
		var reDate 		= /^(0?[1-9]|[12][0-9]|3[01])[\/\-](0?[1-9]|1[012])[\/\-]\d{4}$/;    // /(?:0[1-9]|[12][0-9]|3[01])\/(?:0[1-9]|1[0-2])\/(?:19|20\d{2})/;

		// Div to set error messages
		
		//alert(document.getElementById("IdSeMsg").disabled);
		try{
		if(document.getElementById("IdSeMsg").disabled){			
			document.getElementById("IdSeMsg").disabled=false;
			document.getElementById("IdSeMsg").style.visibility="visible";
			document.getElementById("IdSeMsg").style.display="block";		
		}
		}catch(err){
		alert(err.message);
		}
		var errorBanner = document.getElementById("IdSeMsg");
		$('#IdSeMsg').fadeIn('fast', function() { });//To reset error messages
		killThis('IdSeMsg');
		
		if(Fname=="")
			{
				errorBanner.innerHTML = "Please enter First Name";
				document.getElementById("idTxtFName").focus();
				return false;
			}
		else if(Lname=="")
			{
				errorBanner.innerHTML = "Please enter Last Name";
				document.getElementById("idTxtLname").focus();
				return false;
			}
		else if(Email=="")
			{
				errorBanner.innerHTML = "Please enter EmailID";
				document.getElementById("idTxtEmail").focus();
				return false;
			}
		else if(!emailPattern.test(Email))
			{
				errorBanner.innerHTML = "Please enter valid EmailID";
				document.getElementById("idTxtEmail").focus();
				return false;
			}
		else if(ContactNo == "")
			{
				errorBanner.innerHTML = "Please enter Contact Number";
				document.getElementById("idTxtContactNo").focus();
				return false;
			}
		else if(ContactNo.length < 10)
			{
				errorBanner.innerHTML = "Please enter Valid Contact Number";
				document.getElementById("idTxtContactNo").focus();
				return false;
			}
		else if( document.getElementById("idGenderM").checked == false  && document.getElementById("idGenderF").checked == false)
			{
				errorBanner.innerHTML = "Please enter Gender";
				document.getElementById("idGenderM").focus();
				return false;
			}
		else if(DOB == "")
			{
				errorBanner.innerHTML = "Please enter Date of Birth";
				document.getElementById("idTxtDOB").focus();
				return false;
			}
		else if(!reDate.test(DOB))
			{
				errorBanner.innerHTML = "Please enter Valid Date of Birth in [DD/MM/YYYY] format";
				document.getElementById("idTxtDOB").focus();
				return false;
			}
		else
		{
			
			
			return true;		
		}
		
	}
	
	