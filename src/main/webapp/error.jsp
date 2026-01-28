<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" session="false" isErrorPage="true" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<%
HttpSession session=request.getSession(false);

if(session==null || session.equals(""))
{
	session.invalidate();
%>
	
<%	
}
else
{%>
	<!--
		@author Prashant Bansod
		@date 12-06-2012  
	 -->
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<link rel="stylesheet" href="Css/style.css" type="text/css">
	<title>Error [ePariksha] </title>
	<script type="text/javascript">
		javascript:window.history.forward(1);
	</script>

	
	</head>
	<body>
	
	<div id="mainBody"  align="center" >
    <div id="topArea"><!-- div Top container -->
      <table width="800px" cellspacing="0" cellpadding="0"><!-- div left banner -->
          <tr>
	            <td width="30%" align="left" valign="top" style="padding-top:3px; padding-left:5px; padding-bottom:0px;">
		            <a href="http://acts.cdac.in"><img src="images/cdac-acts_inner.png" alt="" width="120" height="30" border="0" /></a>
	            </td>
	            <td width="70%" align="right" valign="top" style="padding-top:10px;">
		            
	            </td>
            </tr>
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
        
       <div id="workArea">
       				<br>
       				<div id="divContainer">
	       				<div style="width: 463px;float:left;">
	       				   <p style="color:red;font:20pt bold;">Something went wrong...!</p> 
					        <p style="font:13pt normal;">Following reasons may have caused an error:</p>
	       					<ol style="margin:0px 0px 0px 0px;background:none;font:15pt normal;">
							       
								   <li style="margin:20px;font:12pt normal;">Session timed out.</li>
								   <li style="margin:20px;font:12pt normal ;">Requested url may be under construction.</li>
							  		<li style="margin:20px;font:12pt normal ;">Unauthorized attempt to access webpage.</li>
									<li style="margin:20px;font:12pt normal ;">Webpage is expired.</li>
							</ol>
						</div>
						<div style="float:right; margin:50px 20px 0px 0px;width: 282px;">
							<img alt="Error Occured" src="images/error.gif" style="width:230px;height:230px;">
						</div>
						<div style="clear:both;"></div>
					</div>
					<br>
					<a href="index.jsp" style="font:12pt normal;">Login Again</a>
       </div>
      
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
	<%
	
}
%>
</html>