/**
 * @author Sherin Mathew
 * @date 24/05/2012
 * @description This javascript validates the controls on the admin profile page 
 * */	
		

function check(e ,patt ) {  
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
			}  
			keychar = String.fromCharCode(keynum);  
			//List of special characters you want to restrict  
			//alert(patt.test(keychar));
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
		
		function checkPass(e)
		{
			var patPass = /[^#|^']/g;
			return check(e,patPass);
		}
		
		// Reset Error message
		
		function disolveDiv(divID)
		{	
			document.getElementById(divID).style.display='inline';
			if(document.getElementById(divID)!=null){
				$('#'+divID).fadeOut(2000);
			}
			//document.getElementById(divID).innerHTML= "";		
		}
		
		// Call to disolve message
		
		function killThis(divID)
		{
			
			callToFunction = "disolveDiv('"+divID+"')";
			var t=setTimeout(callToFunction,4000);
		}
		
		
		function adminChangeContact()
		{
			
			var emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
			var DOBPattern   = /^(0[1-9]|[12][0-9]|3[01])[-](0[1-9]|1[012])[-](19|20)\d\d$/;

			var NamePattern = /[A-Za-z ]+$/;
			
			var Name    = document.frmProfile.txtName.value;
			var Email 	= document.frmProfile.txtEMail.value;
			var Mno		= document.frmProfile.txtMNumber.value;
			var Gender;
			var DOB     = document.frmProfile.txtDOB.value;
			
			if(document.getElementById("idGenderM").checked)
				{
				Gender = 'Male';
				}
			else
				{
				Gender = 'Female';
				}
	
		   if(Name=="")
			{
				document.getElementById("ProfMsg").innerHTML="<div id=\"tokill\" style=\"color:red\" >"+"Please Enter Name"+"</div>";
				killThis('tokill');
				return false;
			}
		   else if(!NamePattern.test(Name))
			{
				document.getElementById("ProfMsg").innerHTML="<div id=\"tokill\" style=\"color:red\" >"+"Invalid Name"+"</div>";
				killThis('tokill');
				return false;
			}
			else if(Email=="")
				{
					document.getElementById("ProfMsg").innerHTML="<div id=\"tokill\" style=\"color:red\" >"+"Please Enter EmailID"+"</div>";
					killThis('tokill');
					return false;
				}
			else if(!emailPattern.test(Email))
				{
					document.getElementById("ProfMsg").innerHTML="<div id=\"tokill\" style=\"color:red\" >"+"Invalid EmailID"+"</div>";
					killThis('tokill');
					return false;
				}
			else if(Mno=="")
				{
					document.getElementById("ProfMsg").innerHTML="<div id=\"tokill\" style=\"color:red\" >"+"Please Enter Contact Number"+"</div>";
					killThis('tokill');
					return false;
				}
			else if(Mno.length<10)
			{
				document.getElementById("ProfMsg").innerHTML="<div id=\"tokill\" style=\"color:red\" >"+"Invalid Contact Number"+"</div>";
				killThis('tokill');
				return false;
			}
			else if(DOB=="")
			{
				document.getElementById("ProfMsg").innerHTML="<div id=\"tokill\" style=\"color:red\" >"+"Please Enter Date of Birth"+"</div>";
				killThis('tokill');
				return false;
			}
			else if(!DOBPattern.test(DOB))
			{
				document.getElementById("ProfMsg").innerHTML="<div id=\"tokill\" style=\"color:red\" >"+"Invalid Date of Birth"+"</div>";
				killThis('tokill');
				return false;
			}
			else
				{

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
				  		document.getElementById("ProfMsg").innerHTML=xmlhttp.responseText;
				  		//document.getElementById("idBtnResetPass").disabled = false;
				  		document.getElementById("liUserName").innerHTML=Name;
				  		killThis('tokill');
				  		
				    }
				  };
				xmlhttp.open("POST","AdminProfileUpdater",true);
				xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
				xmlhttp.send("eid="+Email+"&txtContactNo="+Mno+"&txtName="+Name+"&txtDOB="+DOB+"&txtGender="+Gender);
				document.frmProfile.hidName.value = Name;
				document.frmProfile.hidEmail.value = Email;
				document.frmProfile.hidContact.value = Mno;
				document.frmProfile.hidDOB.value = DOB;
				document.frmProfile.hidGender.value = Gender;
				document.getElementById("ShowGenderData").style.display="inline";
				document.getElementById("ShowGenderData").innerHTML = Gender;
				}
				goCancel();
				document.getElementById('btnCancel').disabled=true;
			
		}
		
		function admingoCancel()
		{
			document.frmProfile.txtEMail.value = PreEmail;
			document.frmProfile.txtMNumber.value = PreMno;			
			goCancel();
			document.getElementById('btnCancel').disabled=true;
			//window.location.reload();
		}
		
			
		function ChangePass()
		{
			var old			=	document.getElementById("idOldPass").value;
			var newPass 	=	document.getElementById("idNewPass").value;
			var reNewPass	=	document.getElementById("idReNewPass").value;
			
			
			if(old=="")
				{
					document.getElementById("ProfMsg").innerHTML="<div id=\"tokill\"style=\"color:red\" >"+"Enter Old Password"+"</div>";
					killThis('tokill');
					document.getElementById("idOldPass").focus();
					return false;
				}
			else if(newPass=="")
				{
					document.getElementById("ProfMsg").innerHTML="<div id=\"tokill\"style=\"color:red\" >"+"Enter New Password"+"</div>";
					killThis('tokill');					
					document.getElementById("idNewPass").focus();
					return false;
				}
			else if (reNewPass == "")
				{
					document.getElementById("ProfMsg").innerHTML="<div id=\"tokill\"style=\"color:red\" >"+"Enter Confirm Password"+"</div>";
					killThis('tokill');
					document.getElementById("idReNewPass").focus();
					return false;
				}
			else if(reNewPass!=newPass)
				{
					document.getElementById("ProfMsg").innerHTML="<div id=\"tokill\"style=\"color:red\" >"+"Enter New Password Again"+"</div>";
					killThis('tokill');
					document.getElementById("idNewPass").value ="";
					document.getElementById("idReNewPass").value ="";
					document.getElementById("idNewPass").focus();
					return false;
				
				}
			else if(newPass==old)
			{
				document.getElementById("ProfMsg").innerHTML="<div id=\"tokill\"style=\"color:red\" >"+"Enter New Password Again"+"</div>";
				killThis('tokill');
				document.getElementById("idNewPass").value ="";
				document.getElementById("idReNewPass").value ="";
				document.getElementById("idNewPass").focus();
			}
			else
				{
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
						  	
					  		document.getElementById("ProfMsg").innerHTML=xmlhttp.responseText;
					  		//document.getElementById("idBtnResetPass").disabled = false;
					  		killThis('tokill');
					  		document.getElementById("idNewPass").value ="";
							document.getElementById("idReNewPass").value ="";
							document.getElementById("idOldPass").value="";
					    }
					  };
					xmlhttp.open("POST","AdminChangePass",true);
					xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
					xmlhttp.send("oldpass="+old+"&newpass="+newPass);
					
				
				}
			
		}

