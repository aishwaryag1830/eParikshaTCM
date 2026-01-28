
function isDataInvalid(strSource)  //Common function for validating contents
{
	var strFormat=/[#\'']/;
	var blankSpaces=/\s{1,}/;
	
	if(strSource.search(strFormat)!=-1) //==-1 character found
		return 1; //character exists in string
	if(strSource.search(blankSpaces)!=-1)
     		return 2;
    
	if(strSource.indexOf(" ")==0)
 		return 3;

	if(strSource.indexOf(" ")==(strSource.length)-1)
 		return 4;

	return 5;

}
function showDataValidMessage(msgFlag,labelName)
{
	if(msgFlag==1) 
	 {
		 document.getElementById('div_message_operations').innerHTML="Invalid character in "+labelName;
			return false;
	 }
	else if(msgFlag==2) 
	 {
		document.getElementById('div_message_operations').innerHTML="Please remove blank space from "+labelName;
		 return false;
	 }
	else if(msgFlag==3) 
	 {
		document.getElementById('div_message_operations').innerHTML="Please eliminate initial space in "+labelName;
		 return false;
	 }
	else if(msgFlag==4)
	{
		document.getElementById('div_message_operations').innerHTML="Please eliminate end space in "+labelName;
		 return false;
	 }
	return true;
}

 


function comparePasswords(existingPd)
{
	var isPdSame = false;
	jQuery.ajax({
				url:"ComparePassword",
				type:"post",
				dataType:"json",
				data:{existingPd:existingPd},
				async:false,
				success: function(JSONData){
											if(Object.keys(JSONData).length>0)
											{
												isPdSame	=	 JSONData.msg;
											}
											
										},
				error:function(){
									alert('Connection problem. Try Later.');
								}
			});	

	return isPdSame;
}


function validateChangePassForm(frm)
{
	var txtOldPassword		=	frm.elements["txtOldPassword"];
	var txtNewPassword		=	frm.elements["txtNewPassword"];
	var txtConfirmPassword	=	frm.elements["txtConfirmPassword"];
	
	
	var idataValidOldPassword=isDataInvalid(txtOldPassword.value);
	var idataValidNewPassword=isDataInvalid(txtNewPassword.value);

	
	/*************Old PAssword Validation begins******************/
	if(txtOldPassword.value.length==0) //use length property for blank values not " "
	{
		  document.getElementById('div_message_operations').innerHTML="Old password cannot be blank";
	     txtOldPassword.focus();
	     return false; 
     }	
	else if(comparePasswords(txtOldPassword.value)!=true)
		{
		 document.getElementById('div_message_operations').innerHTML="Old password is not correct";
	     txtOldPassword.focus();
	     return false; 
			
		}
	
	
	 else if(showDataValidMessage(idataValidOldPassword,"Old Password")==false)  //show data validation message for old password
	  {
		 txtOldPassword.focus();
		  return false;		//some error so don't proceed
	  }
	/*************Old Password Validation Ends******************/
	
	if(txtOldPassword.value==txtNewPassword.value)
	{
		document.getElementById('div_message_operations').innerHTML="Old Password &amp; New Password must have different values";
		return false;
	}
	
 
	/*************New Password Validation begins******************/
	if(txtNewPassword.value.length==0) //use length property for blank values not " "
	{
		  document.getElementById('div_message_operations').innerHTML="New password cannot be blank";
		  txtNewPassword.focus();
	     return false; 
     }	
	else if(txtNewPassword.value.length<4) //use length property for blank values not " "
	{
		  document.getElementById('div_message_operations').innerHTML="New password must have atleast 4 characters";
		  txtNewPassword.focus();
	     return false; 
     }
	 else if(showDataValidMessage(idataValidNewPassword,"New Password")==false)  //show data validation message for old password
	  {
		 txtNewPassword.focus();
		  return false;		//some error so don't proceed
	  }
	/*************New Password Validation Ends******************/
	 
	if(txtNewPassword.value!=txtConfirmPassword.value)
	{
		document.getElementById('div_message_operations').innerHTML="New Password &amp; Confirm Password must have identical values";
		return false;
	}
	
	return true;
}



function updatePassword(frm)
{
	
	if(validateChangePassForm(frm))//IF properly validated then submit form
		frm.submit();
}


function resetPasswordFields()
{
	document.getElementById('txtOldPassword').value="";
	document.getElementById('txtNewPassword').value="";
	document.getElementById('txtConfirmPassword').value="";

}