document.write("<script language='javascript' src='Js/AdminMenu/MenuBar.js' ></script>");

/**
 * @author Prashant Bansod
 * @date 04-10-01
 * Login validations
 */

function submitOnEnter(e)
{
		
            var ENTER_KEY = 13;
            var code = "";
      
            if (window.event) // IE
            {
                code = e.keyCode;
            }
            else if (e.which) // Netscape/Firefox/Opera
            {
                code = e.which;
            }
            
            if (code == ENTER_KEY) 
            {
            	MM_swapImage('Image6','','images/login_a.gif',1);
            	setTimeout('goLogin()',200);
            	
            }
 }

	function goLogin()
	{
		var frm=document.frmLogin;
		if(frm.txtUserId.value==""||frm.txtPassword.value=="")
		{
			document.getElementById("lblLogin").style.display='inline';
			document.getElementById('lblLogin').innerHTML='';
			document.getElementById('lblLogin').innerHTML="Please Enter your User ID/Password";
			MM_swapImgRestore();
			frm.txtUserId.focus();
			$('#lblLogin').fadeOut(2000);
			
		}
		else if(isNaN(frm.txtUserId.value))
		{
			document.getElementById("lblLogin").style.display='inline';
			document.getElementById('lblLogin').innerHTML='';
			document.getElementById('lblLogin').innerHTML="User ID should be digits only";
			MM_swapImgRestore();
			frm.txtUserId.value="";
			frm.txtPassword.value="";
			frm.txtUserId.focus();	
			$('#lblLogin').fadeOut(2000, function() {document.getElementById('lblLogin').innerHTML= '';});
		}
		else	
		frm.submit();
	}