	/**
	 * @author mritunjay
	 * @param ShowCourseData
	 * @return Information about selected course can edit , update and delete modules
	 */

	function ShowCourseData(CourseData)
	{
		document.getElementById('hidCourse').value = CourseData ;
		var ScrollX,ScrollY;
		ScrollX = document.getElementById('divCourseList').scrollLeft;
		ScrollY	= document.getElementById('divCourseList').scrollTop;
		if(document.getElementById('hidScrollPositionX')!=null){
			document.getElementById('hidScrollPositionX').value = ScrollX;
			document.getElementById('hidScrollPositionY').value = ScrollY;
		}
		var frm=document.getElementById('frmShowCourseModule');
		frm.submit();	
	}
	
	/******************* for adding courses *******************************/
	
	function AddCourses()
	{
		var xmlhttp;
		var lblData;
		var strCourseName = (document.getElementById('txtCourseName').value).trim();
		var strCourseShortName = (document.getElementById('txtCourseShortName').value).trim();
		var strDate = (document.getElementById('txtCourseDate').value).trim();
		var regModuleName = /([a-zA-Z0-9\-\.\,])([\s]{0,2})([a-zA-Z0-9\-\,\.]*)$/;
		var invalidCharacter	= /[@`#%^&*<>%;!~\[\]?|()_{}:$\=\""\'']/;
		
		ScrollY	= document.getElementById('divCourseList').scrollTop;
		
		if(strCourseName.search(invalidCharacter)!=-1)
		{
			document.getElementById('lblDisplayMessage').innerHTML="Invalid character in Course name";
			document.getElementById('txtCourseName').focus();
			setTimeout("document.getElementById('lblDisplayMessage').innerHTML=''",3000);
			return false;
		}
		if(strDate.length==0)
		{
			document.getElementById('lblDisplayMessage').innerHTML="Please enter date";
			document.getElementById('txtCourseDate').focus();
			setTimeout("document.getElementById('lblDisplayMessage').innerHTML=''",3000);
			return false;
		}
		if(strCourseName.length==0)
		{
			document.getElementById('lblDisplayMessage').innerHTML="Please enter Course name";
			document.getElementById('txtCourseName').focus();
			setTimeout("document.getElementById('lblDisplayMessage').innerHTML=''",3000);
			return false;
		}
		if(regModuleName.test(strCourseName) != true)
		{
			document.getElementById('lblDisplayMessage').innerHTML="Please enter valid Course name";
			document.getElementById('txtCourseName').focus();
			setTimeout("document.getElementById('lblDisplayMessage').innerHTML=''",3000);
			return false;
		}
		for(var i=0;i<=strCourseName.length;i++)
		{	
			if(	strCourseName.charAt(i)==' ' && strCourseName.charAt(i+1)==' ' && strCourseName.charAt(i+2)==' ')
			{
				document.getElementById('lblDisplayMessage').innerHTML="Please eliminate  multiple space in Course name";
				document.getElementById('txtCourseName').focus();
				setTimeout("document.getElementById('lblDisplayMessage').innerHTML=''",3000);
				return false;
			}
		}
		if(strCourseShortName.search(invalidCharacter)!=-1)
		{
			document.getElementById('lblDisplayMessage').innerHTML="Invalid character in Course name";
			document.getElementById('txtCourseShortName').focus();
			setTimeout("document.getElementById('lblDisplayMessage').innerHTML=''",3000);
			return false;
		}
		if(strCourseShortName.length==0)
		{
			document.getElementById('lblDisplayMessage').innerHTML="Please enter Short course name";
			document.getElementById('txtCourseShortName').focus();
			setTimeout("document.getElementById('lblDisplayMessage').innerHTML=''",3000);
			return false;
		}
		if(regModuleName.test(strCourseShortName) != true)
		{
			document.getElementById('lblDisplayMessage').innerHTML="Please enter valid Short course name";
			document.getElementById('txtCourseShortName').focus();
			setTimeout("document.getElementById('lblDisplayMessage').innerHTML=''",3000);
			return false;
		}
		for(var i=0;i<=strCourseShortName.length;i++)
		{	
			if(	strCourseShortName.charAt(i)==' ' && strCourseShortName.charAt(i+1)==' ' && strCourseShortName.charAt(i+2)==' ')
			{
				document.getElementById('lblDisplayMessage').innerHTML="Please eliminate  multiple space in Short course name";
				document.getElementById('txtCourseShortName').focus();
				setTimeout("document.getElementById('lblDisplayMessage').innerHTML=''",3000);
				return false;
			}
		}
			if (window.XMLHttpRequest)
			  {
				// code for IE7+, Firefox, Chrome, Opera, Safari
				xmlhttp =new XMLHttpRequest();
			  }
			else
			  {
				// code for IE6, IE5
				xmlhttp =new ActiveXObject("Microsoft.XMLHTTP");
			  }
			var url="txtCourseName="+strCourseName+"&txtCourseShortName="+strCourseShortName+"&txtDate="+strDate;
			xmlhttp.onreadystatechange=function()
			  {
			  if (xmlhttp.readyState==4 && xmlhttp.status==200)
			    {
				  lblData = ((xmlhttp.responseXML.getElementsByTagName("newcourse")[0]).getElementsByTagName("message")[0]).firstChild.nodeValue;
				  document.getElementById('lblDisplayMessage').innerHTML = lblData;
				  if(lblData!="Data already exist" )
				   {
					  if(lblData!="Date must be greater than today's date ")
						  {
						  var divId=((xmlhttp.responseXML.getElementsByTagName("newcourse")[0]).getElementsByTagName("course")[0]).getElementsByTagName("id")[0].firstChild.nodeValue;
						  if(document.getElementById('divNoCourse')!= null){
							  	document.getElementById('divNoCourse').style.display = 'none';
						  	}
						  document.getElementById('txtCourseName').value="";
						  document.getElementById('txtCourseShortName').value="";
						  document.getElementById('txtCourseDate').value="";
					      var divCourse = document.getElementById('divCourseList');
					      var divRow = document.createElement("div");
					      divRow.setAttribute('class','CourseData');
					      divRow.setAttribute('style','width:118px;padding-left:2px');
					      divRow.setAttribute('id',divId);
					      divRow.setAttribute('title',(xmlhttp.responseXML.getElementsByTagName("newcourse")[0].getElementsByTagName("course")[0]).getElementsByTagName("title")[0].firstChild.nodeValue);
					      divRow.setAttribute('onclick', 'ShowCourseData(this.id)');
					      divRow.appendChild(document.createTextNode((xmlhttp.responseXML.getElementsByTagName("newcourse")[0].getElementsByTagName("course")[0]).getElementsByTagName("shortname")[0].firstChild.nodeValue));    
					      divCourse.appendChild(divRow);
					      document.getElementById('txtCourseName').value="";
					      document.getElementById('txtCourseShortName').value="";
					      setTimeout("document.getElementById('lblDisplayMessage').innerHTML=''",3000);
					   }else
					   {
						 
					   }
				  }else
				   {
					   document.getElementById('txtCourseName').value="";
					   document.getElementById('txtCourseShortName').value="";
					   document.getElementById('txtCourseDate').value="";
				   }
				  setTimeout("document.getElementById('lblDisplayMessage').innerHTML=''",3000);
			    }
			  };
			xmlhttp.open("POST","CreateCourses",true);
			xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
			//Add no cache header here
			xmlhttp.setRequestHeader("Content-length", url.length);
			xmlhttp.setRequestHeader("Connection", "close");
			xmlhttp.send(url);
			return true;
	}
	
	function closeAddCourses()
	{
		  document.getElementById('txtCourseName').value="";
		  document.getElementById('txtCourseShortName').value="";
		  document.getElementById('txtCourseDate').value="";
		  hideViewer('modalCreateCoursePage');
	}
	/****************** this function gives the pop window for adding courses *****************/
	
	function showAddCourse()
	{
	
		g_Start1=new JsDatePick({
			useMode:2,
			target:"txtCourseDate",
			cellColorScheme:"ocean_blue",
			dateFormat:"%d-%m-%Y",
			yearsRange:new Array(2010,2030)
		});	
	
		
		showModalDiv('modalCreateCoursePage');
	}
	
	/*************** this function used for selected course background color ***************/
	
	function ChangeColor(strColor,strScrollPositionX,strScrollPositionY)
	{	
		if(strColor!=null)
		{
	
		g_test=new JsDatePick({
			useMode:2,
			target:"txtTillDate",
			cellColorScheme:"ocean_blue",
			dateFormat:"%d-%m-%Y",
			yearsRange:new Array(2010,2030)
		});	
		/*
		g_end.setOnSelectedDelegate(function(){
			
			
			g_Sch.populateFieldWithSelectedDate();
			getOnModule();         // to display already scheduled exam for selected date
			g_Sch.closeCalendar();
			
		});	*/	
							document.getElementById(strColor).setAttribute('class','roll');
							document.getElementById(strColor).setAttribute('className','roll');
							document.getElementById(strColor).setAttribute('onclick','');	
							document.getElementById('divCourseList').scrollLeft=strScrollPositionX;
							document.getElementById('divCourseList').scrollTop=strScrollPositionY;
				}
					
	}
	
	/************************ this function used to edit course **********************/
	
	function ShowCourse()
	{
		document.getElementById('txtUpdateCourseName').readOnly = false;
		document.getElementById('txtUpdateCourseShortName').readOnly = false;
		document.getElementById('txtTillDate').disabled = false;
		document.getElementById('txtTillDate').readOnly = true;
		
		document.getElementById('txtUpdateCourseName').setAttribute('class','activeBorder' );
		document.getElementById('txtUpdateCourseShortName').setAttribute('class','activeBorder' );
		document.getElementById('txtTillDate').setAttribute('class','activeBorder' );
		
		document.getElementById('EditCourse').style.color = 'gray';
		document.getElementById('EditCourse').style.cursor = 'default';
		document.getElementById('EditCourse').setAttribute('href','javascript: void(0)');
		
		document.getElementById('CancelCourse').style.color = '#38aefe';
		document.getElementById('CancelCourse').style.cursor = 'pointer';
		document.getElementById('CancelCourse').setAttribute('href','javascript:CancelCourses();');
		//document.getElementById('CancelCourse').disabled = false;
		document.getElementById('UpdateCourse').style.color = '#38aefe';
		document.getElementById('UpdateCourse').style.cursor = 'pointer';
		document.getElementById('UpdateCourse').setAttribute('href','javascript:void(0);');
		document.getElementById('UpdateCourse').setAttribute('onclick','javascript:UpdateCourses()');
		document.getElementById('txtUpdateCourseName').readOnly = false;
		//document.getElementById('CancelCourse').disabled = false;
	}
	
	/************************** this function gives persist data after canceling edit courses  *************/
	
	function CancelCourses()
	{	
	
		document.getElementById('txtUpdateCourseName').value=document.getElementById('hidCourseName').value;;
		document.getElementById('txtUpdateCourseShortName').value=document.getElementById('hidCourseShortName').value;;
		document.getElementById('txtTillDate').value=document.getElementById('hidCourseValidTill').value;
		
		document.getElementById('txtUpdateCourseName').setAttribute('class','transparent' );
		document.getElementById('txtUpdateCourseShortName').setAttribute('class','transparent' );
		document.getElementById('txtTillDate').setAttribute('class','transparent' );
		
		document.getElementById('txtUpdateCourseName').readOnly = true;
		document.getElementById('txtUpdateCourseShortName').readOnly = true;
		document.getElementById('txtTillDate').disabled = true;
		
		document.getElementById('CancelCourse').style.color = 'gray';
		document.getElementById('CancelCourse').style.cursor = 'default';
		document.getElementById('CancelCourse').setAttribute('href','javascript: void(0)');
		
		document.getElementById('UpdateCourse').style.color = 'gray';
		document.getElementById('UpdateCourse').style.cursor = 'default';
		document.getElementById('UpdateCourse').setAttribute('href','javascript: void(0)');
		document.getElementById('UpdateCourse').setAttribute('onclick','');
		document.getElementById('EditCourse').style.color = '#38aefe';
		document.getElementById('EditCourse').setAttribute('href','javascript:ShowCourse();');
		document.getElementById('EditCourse').style.cursor = 'pointer';
	}
	
	/************ for updating the courses ************/
	
	function UpdateCourses() {
		// Topic percentage to update
		
		var strRealCourseName = (document.getElementById('txtUpdateCourseName').value).trim();
		var strCourseId  = (document.getElementById('hidCourseId').value).trim();
		var strDate = document.getElementById('txtTillDate').value;
		
		// Topic name to update
		var strShortName = (document.getElementById('txtUpdateCourseShortName').value).trim();
		
		
		var regModuleName = /([a-zA-Z0-9\-\.\,])([\s]{0,2})([a-zA-Z0-9\-\,\.]*)$/;
		var invalidCharacter	= /[@`#%^&*<>%;!~\[\]?|()_{}:$\=\""\'']/;
		
		if(strRealCourseName.search(invalidCharacter)!=-1)
		{
			document.getElementById('lblDisplay').innerHTML="Invalid character in Course name";
			document.getElementById('txtUpdateCourseName').focus();
			setTimeout("document.getElementById('lblDisplay').innerHTML=''",3000);
			return false;
		}
		if(strDate.length==0)
		{
			document.getElementById('lblDisplay').innerHTML="Please enter date";
			document.getElementById('txtTillDate').focus();
			setTimeout("document.getElementById('lblDisplayMessage').innerHTML=''",3000);
			return false;
		}
		if(strRealCourseName.length==0)
		{
			document.getElementById('lblDisplay').innerHTML="Please enter Course name";
			document.getElementById('txtUpdateCourseName').focus();
			setTimeout("document.getElementById('lblDisplay').innerHTML=''",3000);
			return false;
		}
		if(regModuleName.test(strRealCourseName) != true)
		{
			document.getElementById('lblDisplay').innerHTML="Please enter valid Course name";
			document.getElementById('txtUpdateCourseName').focus();
			setTimeout("document.getElementById('lblDisplay').innerHTML=''",3000);
			return false;
		}
		for(var i=0;i<=strRealCourseName.length;i++)
		{	
			if(	strRealCourseName.charAt(i)==' ' && strRealCourseName.charAt(i+1)==' ' && strRealCourseName.charAt(i+2)==' ')
			{
				document.getElementById('lblDisplay').innerHTML="Please eliminate  multiple space in Course name";
				document.getElementById('txtUpdateCourseName').focus();
				setTimeout("document.getElementById('lblDisplay').innerHTML=''",3000);
				return false;
			}
		}
		if(strShortName.search(invalidCharacter)!=-1)
		{
			document.getElementById('lblDisplay').innerHTML="Invalid character in Short course name";
			document.getElementById('txtUpdateCourseShortName').focus();
			setTimeout("document.getElementById('lblDisplay').innerHTML=''",3000);
			return false;
		}
		if(strShortName.length==0)
		{
			document.getElementById('lblDisplay').innerHTML="Please enter Short course name";
			document.getElementById('txtUpdateCourseShortName').focus();
			setTimeout("document.getElementById('lblDisplay').innerHTML=''",3000);
			return false;
		}
		if(regModuleName.test(strShortName) != true)
		{
			document.getElementById('lblDisplay').innerHTML="Please enter valid Short course name";
			document.getElementById('txtUpdateCourseShortName').focus();
			setTimeout("document.getElementById('lblDisplay').innerHTML=''",3000);
			return false;
		}
		for(var i=0;i<=strShortName.length;i++)
		{	
			if(	strShortName.charAt(i)==' ' && strShortName.charAt(i+1)==' ' && strShortName.charAt(i+2)==' ')
			{
				document.getElementById('lblDisplay').innerHTML="Please eliminate  multiple space in Short course name";
				document.getElementById('txtUpdateCourseShortName').focus();
				setTimeout("document.getElementById('lblDisplay').innerHTML=''",3000);
				return false;
			}
		}
		if (window.XMLHttpRequest)
		  {// code for IE7+, Firefox, Chrome, Opera, Safari
			xmlhttp =new XMLHttpRequest();
		  }
		else
		  {// code for IE6, IE5
			xmlhttp =new ActiveXObject("Microsoft.XMLHTTP");
		  }
		var url="txtCourseName="+strRealCourseName+"&txtCourseShortName="+strShortName+"&txtCourseId="+strCourseId+"&txtDate="+strDate;
			
		xmlhttp.onreadystatechange=function()
		  {
		  if (xmlhttp.readyState==4 && xmlhttp.status==200)
		    {
			  if(xmlhttp.responseXML.getElementsByTagName("Course")[0].getElementsByTagName("message")[0].firstChild.nodeValue=="Courses is updated successfully")
			  // For reflecting change on data grid
			  {
					document.getElementById('lblDisplay').innerHTML=xmlhttp.responseXML.getElementsByTagName("Course")[0].getElementsByTagName("message")[0].firstChild.nodeValue;
					document.getElementById('txtUpdateCourseName').value=strRealCourseName;
					document.getElementById('txtUpdateCourseShortName').value=strShortName;
					document.getElementById('hidCourseName').value = strRealCourseName;
					document.getElementById('txtTillDate').value=strDate;
					document.getElementById(strCourseId).setAttribute("title",strRealCourseName);
					var length = parseInt(strRealCourseName.length)*7 - 11 ;
					var TextLength = "width:"+ length +"px";
				
					if(length>150){
						document.getElementById('txtUpdateCourseName').setAttribute('style',TextLength);
						
					}else{
						document.getElementById('txtUpdateCourseName').setAttribute('style',"width:142px");
					}
					document.getElementById(strCourseId).innerHTML = strShortName;
			
					// For status message
					document.getElementById('lblDisplay').innerHTML=xmlhttp.responseXML.getElementsByTagName("Course")[0].getElementsByTagName("message")[0].firstChild.nodeValue;
					document.getElementById('txtUpdateCourseName').readOnly = true;
					document.getElementById('txtUpdateCourseShortName').readOnly = true;
					document.getElementById('txtTillDate').disabled = true;
					
					document.getElementById('txtUpdateCourseName').setAttribute('class','transparent' );
					document.getElementById('txtUpdateCourseShortName').setAttribute('class','transparent' );
					document.getElementById('txtTillDate').setAttribute('class','transparent' );
					
					document.getElementById('CancelCourse').style.color = 'gray';
					document.getElementById('CancelCourse').style.cursor = 'default';
					document.getElementById('CancelCourse').setAttribute('href','javascript: void(0)');
	
					document.getElementById('UpdateCourse').style.color = 'gray';
					document.getElementById('UpdateCourse').style.cursor = 'default';
					document.getElementById('UpdateCourse').setAttribute('href','javascript: void(0)');
					document.getElementById('UpdateCourse').setAttribute('onclick','');
					
					document.getElementById('EditCourse').style.color = '#38aefe';
					document.getElementById('EditCourse').setAttribute('href','javascript:ShowCourse();');
					document.getElementById('EditCourse').style.cursor = 'pointer';
			  }else
			  {
				    document.getElementById('lblDisplay').innerHTML=xmlhttp.responseXML.getElementsByTagName("Course")[0].getElementsByTagName("message")[0].firstChild.nodeValue;
			  }	
		     }
			  setTimeout("document.getElementById('lblDisplay').innerHTML=''",3000);
			  };
			  
			xmlhttp.open("POST","UpdateCourses",true);
			xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
			xmlhttp.setRequestHeader("Content-length", url.length);
			xmlhttp.setRequestHeader("Connection", "close");
			xmlhttp.send(url);
			return true;			
	}
	
	/******************* for adding modules to a selected course ******************/
	
	function AddModule()
	{
			var strModuleName = (document.getElementById('txtModuleName').value).trim();
			var strCourseId = (document.getElementById('hidCourseID').value).trim();
			var divLength = document.getElementById("divAllModule").getElementsByTagName("div").length;
			var count;
			var regModuleName = /([a-zA-Z0-9\-\.\,\+])([\s]{0,2})([a-zA-Z0-9\-\,\.\+]*)$/;
			var invalidCharacter	= /[@`#%^&*<>%;!~\[\]?|()_{}:$\=\""\'']/;
			if(divLength == 1){
					divLength = 0;	
			}
			count = parseInt(divLength)/4;
			count = count +1;
		
			if(strModuleName.search(invalidCharacter)!=-1)
			{
				document.getElementById('lblDisplayModuleMessage').innerHTML="Invalid character in Module name";
				document.getElementById('txtModuleName').focus();
				setTimeout("document.getElementById('lblDisplayModuleMessage').innerHTML=''",3000);
				return false;
			}
			if(strModuleName.length==0)
			{
				document.getElementById('lblDisplayModuleMessage').innerHTML="Please enter Module name";
				document.getElementById('txtModuleName').focus();
				setTimeout("document.getElementById('lblDisplayModuleMessagee').innerHTML=''",3000);
				return false;
			}
			if(regModuleName.test(strModuleName) != true)
			{
				document.getElementById('lblDisplayModuleMessage').innerHTML="Please enter valid Module name";
				document.getElementById('txtModuleName').focus();
				setTimeout("document.getElementById('lblDisplayModuleMessage').innerHTML=''",3000);
				return false;
			}
			for(var i=0;i<=strModuleName.length;i++)
			{	
				if(	strModuleName.charAt(i)==' ' && strModuleName.charAt(i+1)==' ' && strModuleName.charAt(i+2)==' ')
				{
					document.getElementById('lblDisplayModuleMessage').innerHTML="Please eliminate  multiple space in Module name";
					document.getElementById('txtModuleName').focus();
					setTimeout("document.getElementById('lblDisplayModuleMessage').innerHTML=''",3000);
					return false;
				}
			}
			for(var i=0;i<=strModuleName.length;i++)
			{
				strModuleName = strModuleName.replace("+", "%2B");
			}
			var lblData;
			if (window.XMLHttpRequest)
			  {// code for IE7+, Firefox, Chrome, Opera, Safari
				xmlhttp =new XMLHttpRequest();
			  }
			else
			  {// code for IE6, IE5
				xmlhttp =new ActiveXObject("Microsoft.XMLHTTP");
			  }
			var url="txtModuleName="+strModuleName+"&txtCourseId="+strCourseId;
			xmlhttp.onreadystatechange=function()
			  {
			  if (xmlhttp.readyState==4 && xmlhttp.status==200)
			    {
				  lblData = ((xmlhttp.responseXML.getElementsByTagName("newmodule")[0]).getElementsByTagName("message")[0]).firstChild.nodeValue;
				  document.getElementById('lblDisplayModuleMessage').innerHTML = lblData;
				 
				  if(lblData=="Module already exist")
				   {				  
					  document.getElementById('txtModuleName').value="";   
				   }else
				   { 
					   var divId =(xmlhttp.responseXML.getElementsByTagName("newmodule")[0].getElementsByTagName("Module")[0]).getElementsByTagName("id")[0].firstChild.nodeValue ;
					   
					   if(document.getElementById('divNoModule')!= null)
						{
							var removeDiv = document.getElementById('divNoModule');
							removeDiv.parentNode.removeChild(removeDiv);
							document.getElementById('drpUsers').disabled = false;
							document.getElementById('linkAddUser').setAttribute("href", "javascript:AddUser();");
							document.getElementById('linkAddUser').setAttribute("style","color:#38aefe;text-decoration:none;cursor:pointer;padding-top:5px;font-weight:normal");
						}
					   var divIdvalue = "div" +divId ;
					   var divCourse = document.getElementById('divAllModule');
					   var divRow = document.createElement("div");
					   var divTd = document.createElement("div");
					   var divTd2 = document.createElement("div");
					   var divClear = document.createElement("div");
					   var inputModuleName = document.createElement("input");
					   var hidInputModuleName = document.createElement("input");
					   var btnEdit = document.createElement("img");
					   var btnUpdate = document.createElement("img");
					   var btnCancel = document.createElement("img");
					   var btnDelete = document.createElement("img");	   
					   
					   divRow.setAttribute('id',divIdvalue); 
					   	 if(parseInt(count)%2==0){
					   		divRow.setAttribute('style','background-color:#FBF9F5');
					   	 }else
					   		 {
					   		divRow.setAttribute('style','background-color:#F2F2F2');
					   		 }
					      
					      divTd.setAttribute('style','float:left');
					      
					      inputModuleName.setAttribute('type','text');
					      inputModuleName.setAttribute('id', divId);
					      inputModuleName.setAttribute('name', divId);
					      inputModuleName.setAttribute('value',(xmlhttp.responseXML.getElementsByTagName("newmodule")[0].getElementsByTagName("Module")[0]).getElementsByTagName("name")[0].firstChild.nodeValue );
					      inputModuleName.setAttribute('class', 'transparent');
					     
					      if(parseInt(count)%2==0){
					    	  inputModuleName.setAttribute('style','width:325px;height:21px;padding-left:3px;padding-top:2px;font-size:13px;background-color:#FBF9F5');
					      }else
					      {
					    	  inputModuleName.setAttribute('style','width:325px;height:21px;padding-left:3px;padding-top:2px;font-size:13px;background-color:#F2F2F2');
					      }
					      hidInputModuleName.setAttribute('type','hidden');
					      hidInputModuleName.setAttribute('id','hid'+divId);
					      hidInputModuleName.setAttribute('name','hid'+divId);
					      hidInputModuleName.setAttribute('value',(xmlhttp.responseXML.getElementsByTagName("newmodule")[0].getElementsByTagName("Module")[0]).getElementsByTagName("name")[0].firstChild.nodeValue );
		  
					      divTd2.setAttribute('style','float:right');
					     
					      btnEdit.setAttribute('src','images/edit_blue.png');
					      btnEdit.setAttribute('id','btnEdit'+divId);
					      btnEdit.setAttribute('name','btnEdit');
					      btnEdit.setAttribute('title','Edit');
					      btnEdit.setAttribute('onclick','EditModule('+divId+')');
					      btnEdit.setAttribute('width','21px');
					      btnEdit.setAttribute('height','21px');
					      btnEdit.setAttribute('style','display:inline;cursor:pointer;margin-right:10px;padding-bottom:2px');
					      
					      btnUpdate.setAttribute('src','images/accept_new.png');
					      btnUpdate.setAttribute('id','btnUpdateModule'+divId);
					      btnUpdate.setAttribute('name','btnUpdate');
					      btnUpdate.setAttribute('title','Update');
					      btnUpdate.setAttribute('onclick','UpdateModule('+divId+','+count+')');
					      btnUpdate.setAttribute('width','21px');
					      btnUpdate.setAttribute('height','21px');
					      btnUpdate.setAttribute('style','margin-right:10px;cursor:pointer;display:none;padding-bottom:2px');
					      
					      btnCancel.setAttribute('src','images/cancel1.png');
					      btnCancel.setAttribute('id','btnCancelModule'+divId);
					      btnCancel.setAttribute('name','btnCancel');
					      btnCancel.setAttribute('title','Cancel');
					      btnCancel.setAttribute('onclick','CancelModule('+divId+','+count+')');
					      btnCancel.setAttribute('width','21px');
					      btnCancel.setAttribute('height','21px');
					      btnCancel.setAttribute('style','margin-right:10px;cursor:pointer;display:none;padding-bottom:2px');
					      
					      btnDelete.setAttribute('src','images/delete.png');
					      btnDelete.setAttribute('id','btnDelete'+divId);
					      btnDelete.setAttribute('name','btnDelete');
					      btnDelete.setAttribute('title','Delete');
					      btnDelete.setAttribute('onclick','DeleteModule('+divId+')');
					      btnDelete.setAttribute('width','20px');
					      btnDelete.setAttribute('height','20px');
					      btnDelete.setAttribute('style','margin-left:9px;margin-right:10px;cursor:pointer;padding-bottom:2px');
					      divClear.style.clear = 'both';
					      
					      divTd.appendChild(inputModuleName);
					      divTd.appendChild(hidInputModuleName);
					      divTd2.appendChild(btnEdit);
					      divTd2.appendChild(btnUpdate);
					      divTd2.appendChild(btnCancel);
					      divTd2.appendChild(btnDelete);
					      divRow.appendChild(divTd);
					      divRow.appendChild(divTd2);
					      divRow.appendChild(divClear);
					      divCourse.appendChild(divRow);
					      
					      document.getElementById('txtModuleName').value="";
						  setTimeout("document.getElementById('lblDisplayModuleMessage').innerHTML=''",3000);  
				   }   
			    }
			  };
			xmlhttp.open("POST","CreateModule",true);
			xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
			//Add no cache header here
			xmlhttp.setRequestHeader("Content-length", url.length);
			xmlhttp.setRequestHeader("Connection", "close");
			xmlhttp.send(url);
			return true;	
	}
	function closeAddModules()
	{
		  document.getElementById('txtModuleName').value="";
		  hideViewer('modalCreateModulePage');
	}
	
   /********************** Update the modules of selected course***************************/
	
	function UpdateModule(ModuleId,count)
	{
		var UpdateModuleName = (document.getElementById(ModuleId).value).trim();
		var flagExist = 0;
		var regModuleName = /([a-zA-Z0-9\-\.\,\+])([\s]{0,2})([a-zA-Z0-9\-\,\.\+]*)$/;
		var invalidCharacter	= /[@`#%^&*<>%;!~\[\]?|()_{}:$\=\""\'']/;
			
		if(UpdateModuleName.search(invalidCharacter)!=-1)
		{
			document.getElementById('labelMessage').innerHTML="Invalid character in Module name";
			document.getElementById(ModuleId).focus();
			setTimeout("document.getElementById('labelMessage').innerHTML=''",3000);
			return false;
		}
		if(UpdateModuleName.length==0)
		{
			document.getElementById('labelMessage').innerHTML="Please enter Module name";
			document.getElementById(ModuleId).focus();
			setTimeout("document.getElementById('labelMessage').innerHTML=''",3000);
			return false;
		}
		if(regModuleName.test(UpdateModuleName) != true)
		{
			document.getElementById('labelMessage').innerHTML="Please enter valid Module name";
			document.getElementById(ModuleId).focus();
			setTimeout("document.getElementById('labelMessage').innerHTML=''",3000);
			return false;
		}
		for(var i=0;i<=UpdateModuleName.length;i++)
		{	
			if(	UpdateModuleName.charAt(i)==' ' && UpdateModuleName.charAt(i+1)==' ' && UpdateModuleName.charAt(i+2)==' ')
			{
				document.getElementById('labelMessage').innerHTML="Please eliminate  multiple space in Module name";
				document.getElementById(ModuleId).focus();
				setTimeout("document.getElementById('labelMessage').innerHTML=''",3000);
				return false;
			}
		}
		for(var i=0;i<=UpdateModuleName.length;i++)
			{
				UpdateModuleName = UpdateModuleName.replace("+", "%2B");
			}
		if(flagExist == 0)
				{
						if (window.XMLHttpRequest)
						{// code for IE7+, Firefox, Chrome, Opera, Safari
							xmlhttp =new XMLHttpRequest();
						}
						else
						{// code for IE6, IE5
							xmlhttp =new ActiveXObject("Microsoft.XMLHTTP");
						}
						var url="txtModuleName="+UpdateModuleName+"&txtModuleId="+ModuleId;
						xmlhttp.onreadystatechange=function()
					    {
							if (xmlhttp.readyState==4 && xmlhttp.status==200)
							{
								var labelMessage = xmlhttp.responseXML.getElementsByTagName("Module")[0].getElementsByTagName("message")[0].firstChild.nodeValue;
								document.getElementById('labelMessage').innerHTML = labelMessage;
								for(var i=0;i<=UpdateModuleName.length;i++)
								{
									UpdateModuleName = UpdateModuleName.replace("%2B","+");
								}
								if(labelMessage == "Module is updated successfully")
								// For reflecting change on data grid
								{
									
									document.getElementById(ModuleId).value = UpdateModuleName;
									document.getElementById(ModuleId).style.border = 'none';
									document.getElementById("btnUpdateModule"+ModuleId).style.display = 'none';
									document.getElementById("btnCancelModule"+ModuleId).style.display = 'none';
									document.getElementById("btnEdit"+ModuleId).style.display = 'inline';
									if(parseInt(count)%2==0)
									{
										document.getElementById(ModuleId).style.backgroundColor = '#FBF9F5';
									}else
										{
										document.getElementById(ModuleId).style.backgroundColor = '#F2F2F2';
										}
								}else
							{
								/*document.getElementById("btnUpdateModule"+ModuleId).style.display = 'none';
								document.getElementById("btnCancelModule"+ModuleId).style.display = 'none';
								document.getElementById("btnEdit"+ModuleId).style.display = 'inline';
								document.getElementById(ModuleId).style.border = 'none';
								document.getElementById(ModuleId).style.readOnly = true;*/
							}
						}
						setTimeout("document.getElementById('labelMessage').innerHTML=''",3000);
				   };
					xmlhttp.open("POST","UpdateModules",true);
					xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
					xmlhttp.setRequestHeader("Content-length", url.length);
					xmlhttp.setRequestHeader("Connection", "close");
					xmlhttp.send(url);
					return true;	
			}else
				{	
					document.getElementById('labelMessage').innerHTML = "Module name already exist" ;
					document.getElementById("btnUpdateModule"+ModuleId).style.display = 'none';
					document.getElementById("btnCancelModule"+ModuleId).style.display = 'none';
					document.getElementById("btnEdit"+ModuleId).style.display = 'inline';
					document.getElementById(ModuleId).style.border = 'none';
				}
	}
			
		///////// for Deleting module /////////////////////////
	function DeleteModule(ModuleId)
	{
		var strCourseId = document.getElementById('hidCourseID').value;
		var DivModule =  document.getElementById('divAllModule');
		if (window.XMLHttpRequest)
		  {// code for IE7+, Firefox, Chrome, Opera, Safari
			xmlhttp =new XMLHttpRequest();
		  }
		else
		  {// code for IE6, IE5
			xmlhttp =new ActiveXObject("Microsoft.XMLHTTP");
		  }
		var url="txtModuleId="+ModuleId+"&txtCourseId="+strCourseId;
		xmlhttp.onreadystatechange=function()
		  {
		  if (xmlhttp.readyState==4 && xmlhttp.status==200)
		    {
			  var labelMessage = xmlhttp.responseXML.getElementsByTagName("Module")[0].getElementsByTagName("message")[0].firstChild.nodeValue;
			
			  document.getElementById('labelMessage').innerHTML = labelMessage;
			  if(labelMessage  == "Module is deleted successfully")
			  // For reflecting change on data grid
			  {
				 var rowToDelete = document.getElementById("div"+ModuleId);
				 rowToDelete.parentNode.removeChild(rowToDelete);	
				 var  lengthDiv = document.getElementById("divAllModule").getElementsByTagName("div").length;	
				 if(lengthDiv == 0)
				 {
					
					 var div = document.createElement("div");
					 div.setAttribute("id", "divNoModule");
					 div.setAttribute("style", "margin-left:200px;margin-top:50px;font-size:24px");
					 div.appendChild(document.createTextNode("No module found"));
					 DivModule.appendChild(div);
					 document.getElementById('drpUsers').disabled = true;
					 document.getElementById('linkAddUser').setAttribute("href", "javascript:void(0);");
					 document.getElementById('linkAddUser').setAttribute("style","color:gray;text-decoration:none;cursor:pointer;padding-top:5px;font-weight:normal");
				 }
			   }  	
		    }  
		  setTimeout("document.getElementById('labelMessage').innerHTML=''",3000);
		  }; 
			xmlhttp.open("POST","DeleteModules",true);
			xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
			xmlhttp.setRequestHeader("Content-length", url.length);
			xmlhttp.setRequestHeader("Connection", "close");
			xmlhttp.send(url);
			return true;
	}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	function EditModule(ModuleId)
	{
		var UpdateBtn ="btnUpdateModule"+ModuleId;
		var CancelBtn ="btnCancelModule"+ModuleId;
		var i ;
		var divID ;	
		var lengthDiv = document.getElementById("divAllModule").getElementsByTagName("div").length;
		if(lengthDiv == 1){
			divLength = 0;	
		}
		count = parseInt(lengthDiv)/4;
		count = parseInt(count)+1;
		
		for(i=0 ;i<lengthDiv;)
		{
			divID=document.getElementById("divAllModule").getElementsByTagName("div")[i].id;
			divID = divID.substring(3,divID.length);
			document.getElementById("btnUpdateModule"+divID).style.display = 'none';
			document.getElementById("btnCancelModule"+divID).style.display = 'none';
			document.getElementById("btnEdit"+divID).style.display = 'inline';
			document.getElementById(divID).style.border = 'none';
			if(parseInt(count)%2==0){
				document.getElementById(divID).style.backgroundColor='transparent';
		      }else
		      {
		    	document.getElementById(divID).style.backgroundColor='transparent';
		      }
				document.getElementById(divID).readOnly = true;
			i = parseInt(i)+4 ;
		}
		document.getElementById(ModuleId).readOnly = false;
		document.getElementById(ModuleId).style.border = '1px solid #B7B7B7';
		document.getElementById(ModuleId).style.backgroundColor = '#ffffff';
		
		document.getElementById("btnEdit"+ModuleId).style.display = 'none';
		document.getElementById(UpdateBtn).style.display = 'inline';
		document.getElementById(CancelBtn).style.display = 'inline';	
	}
	
	function CancelModule(ModuleId,count)
	{
		document.getElementById(ModuleId).style.border = 'none';
		if(parseInt(count)%2 == 0){
			document.getElementById(ModuleId).style.backgroundColor = '#FBF9F5';
		}else
			{
			document.getElementById(ModuleId).style.backgroundColor = '#F2F2F2';
			}
		var UpdateBtn = "btnUpdateModule"+ModuleId;
		var CancelBtn = "btnCancelModule"+ModuleId;
		document.getElementById(ModuleId).value = document.getElementById("hid"+ModuleId).value;
		document.getElementById("btnEdit"+ModuleId).style.display = 'inline';
		document.getElementById(UpdateBtn).style.display = 'none';
		document.getElementById(CancelBtn).style.display = 'none';
		document.getElementById(ModuleId).readOnly = true;		
	}
	
	/************************************  this function gives modules of a course in a pop up window   ************************************/
	function showDegrees(str)
	{
		if(str!=0)
		{
			var xmlHttpRequest;
			var drpDegreeStreams;//=document.getElementById('drpDegrees');
			
			if(document.getElementById('drpDegreeStreams')!=null)
			{
				drpDegreeStreams=document.getElementById('drpDegreeStreams');
				drpDegreeStreams.options.length=0;
			}
			if (str=="")
			  {
				  return;
			  }  
			if (window.XMLHttpRequest)
			  {// code for IE7+, Firefox, Chrome, Opera, Safari
				xmlHttpRequest=new XMLHttpRequest();
			  }
			else
			  {// code for IE6, IE5
				xmlHttpRequest=new ActiveXObject("Microsoft.XMLHTTP");
			  }
			var params="sCourseId="+str;
			//Xmlhttprequest responses...
			  xmlHttpRequest.onreadystatechange=function()
			  {  
				  if (xmlHttpRequest.readyState==4 && xmlHttpRequest.status==200)
				    {
						if(drpDegreeStreams!=null)
						{	
							drpDegreeStreams.options.length=0;
							if(xmlHttpRequest.responseText == "No modules found")
							{
								document.getElementById('drpDegreeStreams').disabled=true;
								document.getElementById('imgAjaxloadingImage').style.zIndex =-1;
								addDrpSpecializationOptions(document.getElementById('drpDegreeStreams'),'No modules found','0','0','0');
							}else
							{	
								document.getElementById('drpDegreeStreams').disabled=false;
								document.getElementById('selectedCourseId').value = str;
								responseHandler(xmlHttpRequest.responseText);
							}
						}
					}
				  if (xmlHttpRequest.readyState<4)
				   {
						document.getElementById('imgAjaxloadingImage').style.zIndex =1;//display='';	
				   }  
			  };
			    xmlHttpRequest.open("POST","CourseModuleSpecialization",true);
				xmlHttpRequest.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
				xmlHttpRequest.setRequestHeader("Content-length", params.length);
				xmlHttpRequest.setRequestHeader("Connection", "close");
				xmlHttpRequest.send(params);
		}
		  
	}
	/////////////////////////////////////////////////////////////////////////
	function responseHandler(responseTextServer)
	{
		var sDrpOptions,sDrpOptionId,sDrpValueSplitter,sDrpOptionsSplitter,sDrpOptionText,sDrpText,sDrpValue;
		sDrpOptions=responseTextServer.split(';');		
	    var drpDegreesStreams=document.getElementById('drpDegreeStreams');
	    
	    //Specialization is combined with degree with '-'
		//Degree Id is combined with :
	    //Each Specialization Name & Id is separated by comma
		//Specialization options are separated by semicolon
		for(var iCntr=0;iCntr<sDrpOptions.length-1;iCntr++)
		{
			sDrpOptionsSplitter=sDrpOptions[iCntr].split('#');
			sDrpText=sDrpOptionsSplitter[0];			
			sDrpValueSplitter=sDrpText.split(':');
			sDrpValue=sDrpValueSplitter[1];
			sDrpOptionText=sDrpValueSplitter[0];
			sDrpOptionId=sDrpOptionsSplitter[1];	
			addDrpSpecializationOptions(drpDegreesStreams,sDrpOptionText,sDrpOptionId,sDrpText,'0');//0-this drp
		}
		if(drpDegreesStreams.options.length>0)
	    	document.getElementById('imgAjaxloadingImage').style.zIndex=-1;
	
	}
	/////////////////////////////////////////////////////////////////////////
	
	function get_drp_selected_value_on_choice(drp,sel_choice) //so that if 0 & 2 ie----- are selected put in textbox the answer
	{
		var path1 = drp;//document.getElementById('drp_exam_duration');
		var choices = new Array;
		for (var i = 0; i < path1.options.length; i++)
			{
		    if (path1.options[sel_choice].selected)
		      choices[choices.length] = path1.options[sel_choice].value;  //.value
			}
		return choices[0];
	}
	/////////////////////////////////////////////////////////////////////////
	
	function get_drp_selected_id_on_choice(drp,sel_choice) //so that if 0 & 2 ie----- are selected put in textbox the answer
	{
		var path1 = drp;//document.getElementById('drp_exam_duration');
		var choices = new Array;
		for (var i = 0; i < path1.options.length; i++)
			{
		    if (path1.options[sel_choice].selected)
		      choices[choices.length] = path1.options[sel_choice].id;  //.value
			}
		return choices[0];
	}
	/////////////////////////////////////////////////////////////////////////
	
	function searchFunctionForIds(sFinalMappedValueArray,sToSearchValue)
	{
		 for(var cntrArray=0;cntrArray<sFinalMappedValueArray.length;cntrArray++)
		  {
			  if(sFinalMappedValueArray[cntrArray]==sToSearchValue)
			    return true;
		   }
		  return false;
	
	}
	/////////////////////////////////////////////////////////////////////////
	
	function contains(a, e) 
	{
		 for(var j=0;j<a.length;j++)if(a[j]==e)return true;
		 return false;
	}
	
	/////////////////////////////////////////////////////////////////////////
		
	function getArrayFromStringHavingCommas(sStringWithCommas)
	{
	  	return sStringWithCommas.split('#');
	}
	
	/////////////////////////////////////////////////////////////////////////
	
	function addDrpSpecializationOptions(drp,text,optnId,sDegreeId,drpIdentifier)
	{
		var sRunningMappedIds=document.getElementById('txtDegreesSpecMappingId').value;
		var sRunningMappedIdsArray;
		
		if(sRunningMappedIds!=null || sRunningMappedIds!='null' )
		  sRunningMappedIdsArray=getArrayFromStringHavingCommas(document.getElementById('txtDegreesSpecMappingId').value);
		
		var drpOptions=document.createElement("OPTION");
		drpOptions.text=text;
		drpOptions.value=sDegreeId;
		drpOptions.title=text;
		drpOptions.id=optnId;	
		if(sRunningMappedIdsArray!='null' || sRunningMappedIdsArray!=null || sRunningMappedIdsArray!=""  )
		 {
			if( searchFunctionForIds(sRunningMappedIdsArray,optnId) && drpIdentifier=='1')//!=-1 element found;if element is running & drp is final drp faint the colour of option
			drpOptions.style.color="#CCCCCC";
		 }
		drp.options.add(drpOptions);
	}
	
	/////////////////////////////////////////////////////////////////////////
	
	function transferToFromDrps(frm,fromDrp,toDrp)
	{
		var from = fromDrp;
		var to= toDrp;
		var frmselecttxt= document.getElementById(from)[document.getElementById(from).selectedIndex].text;
		var frmselectval= document.getElementById(from)[document.getElementById(from).selectedIndex].value;
		var frmselectId= document.getElementById(from)[document.getElementById(from).selectedIndex].id;
		
		/*******************Minimium Eligibility criteria Submit Functionality Starts************/  
		
		  var sFinalMappedIdArray=new Array();
		  var drpFinalCriteria=document.getElementById('drpFinalCriteria');
		  var drpDegreeStreams=document.getElementById('drpDegreeStreams');
	
		  for(var cntrArray=0;cntrArray<drpFinalCriteria.options.length;cntrArray++)
		  {
			  sFinalMappedIdArray[cntrArray]=drpFinalCriteria.options[cntrArray].id;  
		   }
		  sFinalMappedIdArray= sFinalMappedIdArray.sort(function sortNumber(a,b){return a - b;});
		  
		  var sToSearchData=get_drp_selected_id_on_choice(drpDegreeStreams,drpDegreeStreams.selectedIndex);
		  
		 if(! searchFunctionForIds(sFinalMappedIdArray,sToSearchData))
			{
			 addToFromDrpOptions(frm,to, frmselecttxt,frmselectId,frmselectval);	
			 removeFromDrpOptions(from);
			}
		  else
			 alert('Selected option already exists in current criteria section');  
		  
	}
	/////////////////////////////////////////////////////////////////////////
	
	function addToFromDrpOptions(frm,targetbox,text,optnID,value)
	{
		var optn = document.createElement("OPTION");
		optn.text =text;
		optn.id=optnID;
		optn.value = value;
		document.getElementById(targetbox).options.add(optn);
		
	}
	/**************Trasfer values starts********/
	
	function removeFromDrpOptions(fromDrp)
	{
		document.getElementById(fromDrp).remove(document.getElementById(fromDrp).selectedIndex);
	
	}
	/************** for removing seleted modules and send back to courses from which they exist *****************/
	
	function removeFinalCriteriaDrpOptions(from,sExistingMappedIds)
	{ 
		var sel = document.getElementById(from);
		var testCourseId = document.getElementById("selectedCourseId").value;
		var theSel = document.getElementById("drpDegreeStreams");
		var ModuleName = sel.options[sel.selectedIndex].value;
		var CourseId = sel.options[sel.selectedIndex].id;
		var CourseIDChange = CourseId.substring(0,3);
		if(CourseIDChange.trim() == testCourseId.trim())
			{
				var flag = '0';
				var i;
				var len = document.getElementById("drpDegreeStreams").length;
				for(i=0;i<len;i++)
				{
					if(theSel.options[i].id == CourseId)
					{
						flag = '1';
						break;
					}
				}
				if(flag == '0')
				{
					var myNewOption = new Option(ModuleName,ModuleName);
					myNewOption.setAttribute('id',CourseId);
					theSel.options[theSel.length] = myNewOption;
				}
			}
		var sExistingMappedIdsArray=getArrayFromStringHavingCommas(sExistingMappedIds) ;
	  	
		var selectedOptionId=get_drp_selected_id_on_choice(document.getElementById(from),document.getElementById(from).selectedIndex);
		
		if(searchFunctionForIds(sExistingMappedIdsArray,selectedOptionId)==false ) //course is not launched existing criteria can be removed
			document.getElementById(from).remove(document.getElementById(from).selectedIndex);
		else 										//Since course is launched once, existing criteria can't be removed
			alert('Since course is once launched with this criteria. This criteria cannot be removed');	
	}
	
	function transferToFromDrps(frm,fromDrp,toDrp)
	{
		var from = fromDrp;
		var to= toDrp;
		var frmselecttxt= document.getElementById(from)[document.getElementById(from).selectedIndex].text;
		var frmselectval= document.getElementById(from)[document.getElementById(from).selectedIndex].value;
		var frmselectId= document.getElementById(from)[document.getElementById(from).selectedIndex].id;
	
		/*******************Minimium Eligibility criteria Submit Functionality Starts************/   
		  var sFinalMappedIdArray=new Array();
		  var drpFinalCriteria=document.getElementById('drpFinalCriteria');
		  var drpDegreeStreams=document.getElementById('drpDegreeStreams');
	
		  for(var cntrArray=0;cntrArray<drpFinalCriteria.options.length;cntrArray++)
		  {
			  sFinalMappedIdArray[cntrArray]=drpFinalCriteria.options[cntrArray].id;
		   }
		  sFinalMappedIdArray= sFinalMappedIdArray.sort(function sortNumber(a,b){return a - b;});
		  
		  var sToSearchData=get_drp_selected_id_on_choice(drpDegreeStreams,drpDegreeStreams.selectedIndex);
		  
		 if(! searchFunctionForIds(sFinalMappedIdArray,sToSearchData))
			{
			 addToFromDrpOptions(frm,to, frmselecttxt,frmselectId,frmselectval);	
			 removeFromDrpOptions(from);
			}
		  else
			 alert('Selected option already exists in current criteria section');    
	
	}
	
	function setFinalValuesForSubmit()
	{
	  /******************* Minimum Eligibility criteria Submit Functionality Starts************/   
		
		 var sFinalMappedIdArray=new Array();
		 var sFinalMappedValueArray = new Array();
		 var drpFinalCriteria=document.getElementById('drpFinalCriteria');
		 var drpDegreeStreams=document.getElementById('drpDegreeStreams');
		 var txtExistingMappidIds=document.getElementById('txtDegreesSpecMappingId');
		 var txtExistingMappidIdsArray;
		 var arrCounter=0;
		 
		 if(txtExistingMappidIds.value!=null || txtExistingMappidIds.value!='null' || txtExistingMappidIds.value!="" )
			 txtExistingMappidIdsArray=getArrayFromStringHavingCommas(txtExistingMappidIds.value); 
		
		  for(var cntrArray=0;cntrArray<drpFinalCriteria.options.length;cntrArray++)
		  {
			  //leave existing mapped id's and add other id's in array to put in text box. 
			  if(txtExistingMappidIdsArray!=null || txtExistingMappidIdsArray!='null' || txtExistingMappidIdsArray!="" )
			  {
				  if( searchFunctionForIds(txtExistingMappidIdsArray,drpFinalCriteria.options[cntrArray].id)==false) //-1 not found then only add in array
				  {
					  sFinalMappedIdArray[arrCounter]=drpFinalCriteria.options[cntrArray].id;
					  sFinalMappedValueArray[arrCounter]=document.getElementById(drpFinalCriteria.options[cntrArray].id).value;
					  arrCounter++;
				  }
			  }
		   }
	  
		  if(drpFinalCriteria.options.length==0)
			  alert('Please select criteria or use Cancel');
		  
		  else if(sFinalMappedIdArray.length!=0)//if new criteria is added
		  {
			  addFinalCriteriaMappedIds(sFinalMappedIdArray , sFinalMappedValueArray);//Reusing function to insert value & id's in repective textboxes
			//Ajax call for update
			  getExisitingCriteriaByAjax(document.getElementById('txtMappingIdUnderDesigning').value, document.getElementById('txtMappingValuesUnderDesigning').value);
		  }
		  else //if no new criteria apart from existing is added.
		  {
			  addFinalCriteriaMappedIds(sFinalMappedIdArray);//Reusing function to insert value & id's in repective textboxes
			  getExisitingCriteriaByAjax('1',document.getElementById('txtDegreesSpecMappingId').value);//'1'-operation id;'0'-mapping ids'a are none-0
			  hideViewer('modalCourseEligibilityPage');	   
		  }
		  
	}
	/************* passing values of array for converting to string through delimiter **************/
	
	function addFinalCriteriaMappedIds(sFinalMappedValueIdPassedArray ,sFinalMappedValuePassedArray )
	{
		 var sFinalMappedValue;
		 var sFinalMappedModuleName;
		 if(sFinalMappedValueIdPassedArray.length>0)
		 {
			 sFinalMappedValue="" ;
			 sFinalMappedModuleName="";
			 for(var cntr=0;cntr<sFinalMappedValueIdPassedArray.length;cntr++)
			  {
			  	sFinalMappedValue=sFinalMappedValue + sFinalMappedValueIdPassedArray[cntr]+',';
				sFinalMappedModuleName=sFinalMappedModuleName + sFinalMappedValuePassedArray[cntr]+'@';
			   }
			  sFinalMappedValue=sFinalMappedValue.substring(0,sFinalMappedValue.length-1 );
			  sFinalMappedModuleName=sFinalMappedModuleName.substring(0,sFinalMappedModuleName.length-1 ); 
		 }
		 else
		 {	  sFinalMappedValue=null;
		 	  sFinalMappedModuleName=null;
		 }
		  document.getElementById('txtMappingIdUnderDesigning').value=sFinalMappedValue;
		  document.getElementById('txtMappingValuesUnderDesigning').value=sFinalMappedModuleName;
	
	}
	/************Ajax call to get existing eligibility criteria in Selected drpFinalCriteria And Div*****/
	
	
	function getExisitingCriteriaByAjax(sRunningMappedIds,sRunningMappedValues)
	{
		var xmlHttpRequestExistingCriteria;
		var lblData;
		var CourseId = document.getElementById('hidCourseID').value;
		document.getElementById('drpFinalCriteria').options.length=0;
		document.getElementById('drpDegreeStreams').options.length=0;
		document.getElementById('drpCourses').selectedIndex=0;
	
		var sToSendMappedIds="";
		var sDesigningMappingIds=document.getElementById('txtMappingIdUnderDesigning').value;
		var ModuleNewIds;
		if (sRunningMappedIds=="")
		  {
			  return;
		  }  
		if (window.XMLHttpRequest)
		  {// code for IE7+, Firefox, Chrome, Opera, Safari
			xmlHttpRequestExistingCriteria=new XMLHttpRequest();
		  }
		else
		  {// code for IE6, IE5
			xmlHttpRequestExistingCriteria=new ActiveXObject("Microsoft.XMLHTTP");
		  }
				//xmlHttpRequestExistingCriteria responses...
				  xmlHttpRequestExistingCriteria.onreadystatechange=function()
				  {
					  if (xmlHttpRequestExistingCriteria.readyState==4 && xmlHttpRequestExistingCriteria.status==200)
					    {
						  lblData = xmlHttpRequestExistingCriteria.responseXML.getElementsByTagName("Modules")[0].getElementsByTagName("messages")[0].firstChild.nodeValue;
						  if(lblData == "Existing module added successfully")
						  {
							  document.getElementById('lblMessage').innerHTML = lblData;
							  ModuleNewIds = xmlHttpRequestExistingCriteria.responseXML.getElementsByTagName("Modules")[0].getElementsByTagName("Ids")[0].firstChild.nodeValue;
							  responseHandlerForExistingCriteriaInFinalDrp(ModuleNewIds,sRunningMappedValues);
						  }else
						  {
							  document.getElementById('lblMessage').innerHTML = lblData;
							  setTimeout("document.getElementById('lblMessage').innerHTML='&nbsp;'",3000);
						  }
						}
				  };    
				var url="strExistingModuleIds="+sRunningMappedIds+"&strExistingModuleName="+encodeURIComponent(sRunningMappedValues)+"&strCourseId="+CourseId;
				xmlHttpRequestExistingCriteria.open("POST","FinalCriteriaFetchAndAdd",true);
				xmlHttpRequestExistingCriteria.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
				xmlHttpRequestExistingCriteria.setRequestHeader("Content-length", url.length);
				xmlHttpRequestExistingCriteria.setRequestHeader("Connection", "close");
				xmlHttpRequestExistingCriteria.send(url);
						  
	}
	/********************* handle the response of adding multiple modules and questions of that module ***********************/
	
	function responseHandlerForExistingCriteriaInFinalDrp(ModuleIds,ModuleNames)
	{
	
		var ModuleID = new Array();
		var ModuleName = new Array();
		ModuleID=ModuleIds.split(",");
		ModuleName=ModuleNames.split("@");
		
		 var divLength = document.getElementById("divAllModule").getElementsByTagName("div").length;
		 if(divLength == 1){
				divLength = 0;
				
			}
			count = parseInt(divLength)/4;
			count = count +1;
		/********** if the selected module have not any modules then hid/remove the div of no module comment ***************/
			if(document.getElementById('divNoModule')!= null)
			{
				var removeDiv = document.getElementById('divNoModule');
				removeDiv.parentNode.removeChild(removeDiv);
			}
			for(var i=0;i<ModuleID.length;i++)
			{	
				var divId = ModuleID[i];
			 	var divIdvalue = "div" +ModuleID[i] ;
			 	var divCourse = document.getElementById('divAllModule');
			 	var divRow = document.createElement("div");
			 	var divTd = document.createElement("div");
			 	var divTd2 = document.createElement("div");
			 	var divClear = document.createElement("div");
			 	var inputModuleName = document.createElement("input");
				var hidInputModuleName = document.createElement("input");
				var btnEdit = document.createElement("img");
				var btnUpdate = document.createElement("img");
				var btnCancel = document.createElement("img");
				var btnDelete = document.createElement("img");	   
		 
			      divRow.setAttribute('id',divIdvalue); 
			 	 if(parseInt(count)%2==0){
				   		divRow.setAttribute('style','background-color:#FBF9F5');
				   	 }else
				   		 {
				   		divRow.setAttribute('style','background-color:#F2F2F2');
				   		 }
			      
			      divTd.setAttribute('style','float:left');
			      
			      inputModuleName.setAttribute('type','text');
			      inputModuleName.setAttribute('id', divId);
			      inputModuleName.setAttribute('name', divId);
			      inputModuleName.setAttribute('value',ModuleName[i]);
			      inputModuleName.setAttribute('class', 'removeBorder');
			      if(parseInt(count)%2==0){
			    	  inputModuleName.setAttribute('style','width:325px;height:21px;padding-left:3px;padding-top:2px;font-size:13px;background-color:#FBF9F5');
			      }else
			      {
			    	  inputModuleName.setAttribute('style','width:325px;height:21px;padding-left:3px;padding-top:2px;font-size:13px;background-color:#F2F2F2');
			      }
			      
			      hidInputModuleName.setAttribute('type','hidden');
			      hidInputModuleName.setAttribute('id','hid'+divId);
			      hidInputModuleName.setAttribute('name','hid'+divId);
			      hidInputModuleName.setAttribute('value',ModuleName[i] );
			     
			      divTd2.setAttribute('style','float:right');
			     
			      btnEdit.setAttribute('src','images/edit_blue.png');
			      btnEdit.setAttribute('id','btnEdit'+divId);
			      btnEdit.setAttribute('name','btnEdit');
			      btnEdit.setAttribute('title','Edit');
			      btnEdit.setAttribute('onclick','EditModule('+divId+')');
			      btnEdit.setAttribute('width','21px');
			      btnEdit.setAttribute('height','21px');
			      btnEdit.setAttribute('style','display:inline;cursor:pointer;margin-right:10px;padding-bottom:2px');
			      
			      btnUpdate.setAttribute('src','images/accept_new.png');
			      btnUpdate.setAttribute('id','btnUpdateModule'+divId);
			      btnUpdate.setAttribute('name','btnUpdate');
			      btnUpdate.setAttribute('title','Update');
			      btnUpdate.setAttribute('onclick','UpdateModule('+divId+','+count+')');
			      btnUpdate.setAttribute('width','21px');
			      btnUpdate.setAttribute('height','21px');
			      btnUpdate.setAttribute('style','margin-right:10px;cursor:pointer;display:none;padding-bottom:2px');
			      
			      btnCancel.setAttribute('src','images/cancel1.png');
			      btnCancel.setAttribute('id','btnCancelModule'+divId);
			      btnCancel.setAttribute('name','btnCancel');
			      btnCancel.setAttribute('title','Cancel');
			      btnCancel.setAttribute('onclick','CancelModule('+divId+','+count+')');
			      btnCancel.setAttribute('width','21px');
			      btnCancel.setAttribute('height','21px');
			      btnCancel.setAttribute('style','margin-right:10px;cursor:pointer;display:none;padding-bottom:2px');
			      
			      btnDelete.setAttribute('src','images/delete.png');
			      btnDelete.setAttribute('id','btnDelete'+divId);
			      btnDelete.setAttribute('name','btnDelete');
			      btnDelete.setAttribute('title','Delete');
			      btnDelete.setAttribute('onclick','DeleteModule('+divId+')');
			      btnDelete.setAttribute('width','20px');
			      btnDelete.setAttribute('height','20px');
			      btnDelete.setAttribute('style','margin-left:9px;margin-right:10px;cursor:pointer;padding-bottom:2px');
			      
			      divClear.style.clear = 'both';
			      
			      divTd.appendChild(inputModuleName);
			      divTd.appendChild(hidInputModuleName);
			      divTd2.appendChild(btnEdit);
			      divTd2.appendChild(btnUpdate);
			      divTd2.appendChild(btnCancel);
			      divTd2.appendChild(btnDelete);
			      divRow.appendChild(divTd);
			      divRow.appendChild(divTd2);
			      divRow.appendChild(divClear);
			      divCourse.appendChild(divRow);
			      document.getElementById('txtModuleName').value="";
				  setTimeout("document.getElementById('lblMessage').innerHTML=''",3000);
				  count = count + 1;
		}
	
	}
	
		/***************   Ajax call to get existing eligibility criteria in Selected drpFinalCriteria And Div Ends   ************/
	
	function AddUser() {
		var iUserId = document.getElementById('drpUsers').value;
		var CourseId = document.getElementById('hidCourseID').value;
		var OldUserId = document.getElementById('hidUserId').value;
		
		if(iUserId == '0')
		{
			document.getElementById('lblMessageUser').innerHTML = "Please select user";
		}
		else
			{
				if(iUserId == OldUserId)
				{
				document.getElementById('lblMessageUser').innerHTML = "User already selected";
				}
				else
				{
					if (window.XMLHttpRequest)
					  {// code for IE7+, Firefox, Chrome, Opera, Safari
						xmlHttpRequestExistingCriteria=new XMLHttpRequest();
					  }
					else
					  {// code for IE6, IE5
						xmlHttpRequestExistingCriteria=new ActiveXObject("Microsoft.XMLHTTP");
					  }
						//xmlHttpRequestExistingCriteria responses...
					  xmlHttpRequestExistingCriteria.onreadystatechange=function()
					  {
						  if (xmlHttpRequestExistingCriteria.readyState==4 && xmlHttpRequestExistingCriteria.status==200)
						    {
							  lblData = xmlHttpRequestExistingCriteria.responseXML.getElementsByTagName("newUser")[0].getElementsByTagName("message")[0].firstChild.nodeValue;
							  if(lblData == "User alloted")
							  {
								  document.getElementById('lblMessageUser').innerHTML = lblData;
								  document.getElementById('drpUsers').value = iUserId ;
								  document.getElementById('Status_id').innerHTML = "active" ;
								  document.getElementById('hidUserId').value = iUserId;
								 
							  }else
							  {
								  document.getElementById('lblMessageUser').innerHTML = lblData;
							  }
							  setTimeout("document.getElementById('lblMessageUser').innerHTML=''",3000);
							}
					  };    
						var url="strUserId="+iUserId+"&strCourse="+CourseId+"&OldUserId="+OldUserId;
						xmlHttpRequestExistingCriteria.open("POST","AddUserToCourse",true);
						xmlHttpRequestExistingCriteria.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
						xmlHttpRequestExistingCriteria.setRequestHeader("Content-length", url.length);
						xmlHttpRequestExistingCriteria.setRequestHeader("Connection", "close");
						xmlHttpRequestExistingCriteria.send(url);
				}
	       }
	}
	
	function cancelEligibilityUpdateOperation()
	{
		document.getElementById('drpCourses').value = '0';
		document.getElementById('drpDegreeStreams').options.length = 0;
		document.getElementById('drpFinalCriteria').options.length = 0;
		
	}
	function ReplaceAdd(str)
	{
		str.replace("+", "%2B");
	}