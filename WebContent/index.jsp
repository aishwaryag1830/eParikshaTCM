<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" session="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
HttpSession session=request.getSession(true);
%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" >
	<link rel="stylesheet" href="Css/style.css" type="text/css">
	<title>ePariksha : Analyse your Knowledge</title>
	<script type="text/javascript">
		javascript:window.history.forward(1);
	</script>
	<script type="text/javascript" src="Js/index.js"></script>
	<script type="text/javascript" src="Js/AdminMenu/MenuBar.js"></script>
	<script type="text/javascript" src="jquery-1.3.1.min.js"></script>	
	

</head>
<body onload="javascript:document.frmLogin.txtUserId.focus();">
<%
String strFlag=null;
	if(session.getAttribute("sLoginFlag")!=null)
		strFlag=session.getAttribute("sLoginFlag").toString(); 
	
	if(session!=null)
	{
		session.invalidate();
	}

StringBuilder strUserLoginStatus=new StringBuilder();;
if(strFlag!=null && strFlag.equals("1"))
{
	strUserLoginStatus.append("Invalid User ID/Password");
}
else if(strFlag!=null && strFlag.equals("2"))
{
	strUserLoginStatus.append("Your session has expired.");
}
else if(strFlag!=null && strFlag.equals("3"))
{
	strUserLoginStatus.append("You have already logged in");
}
else if(strFlag!=null && strFlag.equals("4"))
{
	strUserLoginStatus.append("No Course assigned.Contact Admin");
}

%>
<noscript>
	<br></br>
	<h2>Your browser does not support JavaScript or it is disabled.<br>Please enable the JavaScript
		first and reload the page.</h2>
</noscript>	
				<%
				if(strFlag!=null && strFlag.equals("2"))
				{%>
					<script type="text/javascript">
						document.getElementById("tbl_Login").style.display="none";
						document.getElementById("tbl_session").style.display="inline";
					</script>
				<%}
				else
				{
				%>	<script type="text/javascript">
					if(document.frmLogin!=null)
						document.frmLogin.txtUserId.focus();
					</script>
				<%}%>
				
		
<div id="mainBody"  align="center" >
    
	<table width="800px" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
  <tr>
    <td align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="48%" align="left" valign="top" style="padding-top:4px; padding-bottom:4px;"><a href="index.html" target="_blank"><img src="images/cdac-acts.png" alt="" width="300" height="70" border="0" /></a></td>
            <td width="52%" align="left" valign="top" style="padding-left:164px; padding-top:52px;"><table width="40%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td align="left" valign="top" style="padding-right:35px;"></td>
                  <td align="left" valign="top" style="padding-right:33px;"></td>
                  <td align="left" valign="top"></td>
                </tr>
            </table></td>
          </tr>
        </table>
        </td>
      </tr>
      <tr>
        <td align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          
        </table>
        </td>
      </tr>

    </table></td>
  </tr>
  <tr>
    <td align="left" valign="top"><table width="800" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td height="4" align="left" valign="top" bgcolor="#A70505">&nbsp;</td>
      </tr>
      <tr>
        <td align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0" style="border-left:#CBCBCB 1px solid;">
          <tr>
            <td colspan=4>
             <img src="images/topbanner.gif" width=800px; height=150px;/>
            </td>
            
          </tr>
        </table></td>
      </tr>
      <tr>
        <td align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="15" align="left" valign="top"><img src="images/index_38.gif" width="15" height="139" alt="" /></td>
            <td align="left" valign="top" style="background-image:url(images/index_40.gif); background-repeat:repeat-x;"><table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td align="left" valign="top" style="padding-top:14px; padding-left:32px;"><img src="images/index_44.gif" width="229" height="23" alt="" /></td>
                  </tr>
                  <tr>
                    <td align="left" valign="top" style="padding-top:19px; padding-left:37px; padding-right:18px;" class="welcome"><span style="color:#FF9999; font-weight:bold;">
							ePariksha is an online examination initiative of CDAC ACTS. </span>
                     <br /><br />
                     </td>
                  </tr>
                </table></td>
                <td align="right" valign="top" style="padding-top:24px; padding-right:10px;"><img src="images/welcome.gif" width="101" height="110" alt="" /></td>
              </tr>
            </table></td>
          </tr>
        </table></td>
      </tr>
      <tr>
        <td align="left" valign="top" style="padding-top:30px;"><table width="800" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="467" align="left" valign="top"><table width="96%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="20%" align="left" valign="top"><img src="images/ability.gif" width="85" height="89" alt="" /></td>
                        <td width="80%" align="left" valign="top" style="padding-top:37px; padding-left:11px;"><img src="images/index_65.gif" width="142" height="26" alt="" /></td>
                      </tr>
                    </table></td>
                  </tr>
                  <tr>
                    <td align="left" valign="top" class="text" style="padding-top:21px;"><span style="color:#A70505; font-weight:bold;">CDAC </span> has set up the Advanced Computing Training School (ACTS) to meet the ever-increasing skilled manpower requirements of the IT industry as well as supplement its intellectual resource base for cutting edge research and development.<br />
                      <br /> 
                      
                      <a href="http://cdac.in/index.aspx?id=acts" target="_blank">read more</a></td>
                  </tr>
                </table></td>
              </tr>
              <tr>
                <td align="left" valign="top" style="padding-top:20px;"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="66%" align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td align="left" valign="top"><img src="images/index_76.gif" width="143" height="20" alt="" /></td>
                      </tr>
                      <tr>
                        <td align="left" valign="top" class="text" style="padding-top:20px; padding-bottom:30px;"><span style="color:#A70505; font-weight:bold;">CDAC ACTS</span> provide training in various post graduate technical courses &amp; develops several solutions for delivering high level education. 
						<br /><br />
						<a href="http://cdac.in/index.aspx?id=acts" target="_blank">read more</a></td>
                      </tr>
                    </table></td>
                    <td width="34%" align="right" valign="top" style="padding-left:50px; padding-top: 20px;"><img src="images/ourwork.gif" width="100" height="96" alt="" /></td>
                  </tr>
                </table></td>
              </tr>
            </table></td>
            <td width="256" align="left" valign="top"><table width="256" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td align="left" valign="top">
                <table width="256" height="200px;" border="0" cellpadding="0" cellspacing="0" bgcolor="#F2F2F2">
                  <tr>
                    <td align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="12" align="left" valign="top"><img src="images/index_56.gif" width="12" height="32" alt="" /></td>
                        <td align="left" valign="top" style="background-image:url(images/index_59.gif); padding-top:8px; padding-left:7px;"><img src="images/index_62.gif" width="100" height="23" alt="" /></td>
                        <td width="12" align="left" valign="top"><img src="images/index_60.gif" width="12" height="32" alt="" /></td>
                      </tr>
                    </table></td>
                  </tr>
                  <tr>
                    <td align="left" valign="top" style="padding-left:14px; padding-right:20px;">
		                <!-- Login form --> 
		                 <form name="frmLogin" onkeydown="submitOnEnter(event);" id="frmLogin" method="post" action="LoginAuthentication.pks"  accept-charset="UTF-8">
		                    <table width="256px"  height="190px;"  cellspacing="0" cellpadding="0">
		                     
									<tr align="center">
										<td colspan="2"><div style="height:20px;;font-size: 14px; color: #A83B3E;font-family:corier;" id="login_status"><div id="lblLogin"><%=strUserLoginStatus%></div></div></td>
									</tr>
									<tr >
										<td align="left" style="padding-left: 25px;"><label class="lblstyle">User ID</label></td>
										<td><input type="text" name="txtUserId" maxlength="15" style="width: 140px;"></td>
									</tr>
									<tr >
										<td align="left" style="padding-left: 25px;"><label class="lblstyle">Password</label></td>
										<td><input type="password" name="txtPassword"  maxlength="20" style="width: 140px;"></td>
									</tr>
									<tr>
										<td align="center" colspan="2">
											<a href="javascript:void(0);" onclick="goLogin();" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image6','','images/login_a.gif',1)"><img src="images/login.gif" alt="Users" name="Image6" width="100" height="33" border="0" id="Image6" /></a>
										</td>
									</tr>
		                    </table>
		                    
		                 </form>
                    </td>
                  </tr>
                </table>
                
                
                </td>
              </tr>
              <tr>
                <td align="left" valign="top" style="padding-top:30px; padding-bottom:20px;">
                
                	<!--below image-->
                </td>
              </tr>
            </table></td>
          </tr>
        </table></td>
      </tr>
    </table></td>
  </tr>
  <tr>
    <td align="left" valign="top"><table width="800" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td width="13" align="left" valign="top"><img src="images/index_87.gif" width="13" height="62" alt="" /></td>
        <td align="left" valign="top" style="background-image:url(images/index_88.gif); background-repeat:repeat-x;"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
				<td style="padding-top:15px;" align="center"  class="copyright">Copyright &copy; 2009-2014 <span style="color:#A70505;">CDAC ACTS </span>All rights reserved</td>
          </tr>
        </table></td>
        <td width="15" align="right" valign="top"><img src="images/index_91.gif" width="15" height="62" alt="" /></td>
      </tr>
    </table></td>
  </tr>
</table>

</div><!-- div Mainbody ends -->
</body>
</html>