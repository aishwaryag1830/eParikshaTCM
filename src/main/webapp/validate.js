/*********************** DHTML date validation script ***************************************/

/**
 * @author Ritesh Dhote
 * @author Sherin Mathew
 * @date 24/05/2012
 * @description This is the java script file which validates the text on adminresultman.jsp and many other
 * jsp 
 * 
 */
	// Declaring valid date character, minimum year and maximum year
	var dt=new Date();
	var separator= "/";
	var minYear=1900;
	var maxYear=dt.getFullYear();

	function isInteger(s)
	{
		var i;
		for (i = 0; i < s.length; i++)
		{ 
			// Check that current character is a number or not.
			var c = s.charAt(i);
			if (((c < "0") || (c > "9"))) 
				return false;
		}
		// All characters are numbers.
		return true;
	}

	function stripCharsInBag(s, bag)
	{
		var i;
		var returnString = "";
		// Search through string's characters one by one.
		// If character is not in bag, append to returnString.
		for (i = 0; i < s.length; i++)
		{ 
			var c = s.charAt(i);
			if (bag.indexOf(c) == -1) 
				returnString += c;
		}
		return returnString;
	}

	function daysInFebruary (year)
	{
		// February has 29 days in any year evenly divisible by four,
		// EXCEPT for centurial years which are not also divisible by 400.
		return (((year % 4 == 0) && ( (!(year % 100 == 0)) || (year % 400 == 0))) ? 29 : 28 );
	}
	function DaysArray(n) 
	{
		for (var i = 1; i <= n; i++) 
		{
			this[i] = 31;
			if (i==4 || i==6 || i==9 || i==11)
			{
				this[i] = 30;
			}
			if (i==2) 
			{
				this[i] = 29;
			}
		} 
		return this;
	}

	function isDate(dtStr)
	{
		var daysInMonth = DaysArray(12);
		var pos1=dtStr.indexOf(separator);
		var pos2=dtStr.indexOf(separator,pos1+1);
		var strMonth=dtStr.substring(0,pos1);
		var strDay=dtStr.substring(pos1+1,pos2);
		var strYear=dtStr.substring(pos2+1);
		strYr=strYear;
		if (strDay.charAt(0)=="0" && strDay.length>1)
		{
			strDay=strDay.substring(1);
		}
		if (strMonth.charAt(0)=="0" && strMonth.length>1) 
		{
			strMonth=strMonth.substring(1);
		}
		for (var i = 1; i <= 3; i++) 
		{
			if (strYr.charAt(0)=="0" && strYr.length>1)
			{
				strYr=strYr.substring(1);
			}
		}
		var month=parseInt(strMonth);
		var day=parseInt(strDay);
		var year=parseInt(strYr);
		if (pos1==-1 || pos2==-1)
		{
			alert("The date format should be : MM/DD/YYYY");
			return false;
		}
		if (strMonth.length<1 || month<1 || month>12)
		{
			alert("Please enter a valid month");
			return false;
		}
		if (strDay.length<1 || day<1 || day>31 || (month==2 && day>daysInFebruary(year)) || day > daysInMonth[month])
		{
			alert("Please enter a valid day");
			return false;
		}
		if (strYear.length != 4 || year==0 || year<minYear || year>maxYear)
		{
			alert("Please enter a valid 4 digit year between "+minYear+" and "+maxYear);
			return false;
		}
		if (dtStr.indexOf(separator,pos2+1)!=-1 || isInteger(stripCharsInBag(dtStr, separator))==false)
		{
			alert("Please enter a valid date");
			return false;
		}
		return true;
	}
/** -------------------------End of 1 ----------------------------------- */	
/** -------------------------Email validation  ----------------------------------- */	
	function validemail(node)  //To check the validity of Email
	{
			var at="@";
			var dot=".";
			var str=new String();
			str=node.value;
			var lat=str.indexOf(at);
			var lstr=str.length;
			
			if(str=="")
			{
				alert("Please Enter Your E-mail ID");
				node.focus();
				return false;
			}
			if (str.indexOf(at)==-1)
			{
			   alert("Invalid E-mail ID");
			   node.focus();
			   return false;
			}
			if (str.indexOf(at)==-1 || str.indexOf(at)==0 || str.indexOf(at)==lstr)
			{
			   alert("Invalid E-mail ID");
			   node.focus();
			   return false;
			}
			if (str.indexOf(dot)==-1 || str.indexOf(dot)==0 || str.indexOf(dot)==lstr)
			{
			    alert("Invalid E-mail ID");
			    node.focus();
			    return false;
			 }
			 if (str.indexOf(at,(lat+1))!=-1)
			 {
			    alert("Invalid E-mail ID");
			    node.focus();
			    return false;
			 }
			 if (str.substring(lat-1,lat)==dot || str.substring(lat+1,lat+2)==dot)
			 {
			    alert("Invalid E-mail ID");
			    node.focus();
			    return false;
			 }
			 if (str.indexOf(dot,(lat+2))==-1)
			 {
			    alert("Invalid E-mail ID");
			    node.focus();
			    return false;
			 }
			 if (str.indexOf(" ")!=-1)
			 {
			    alert("Invalid E-mail ID");
			    node.focus();
			    return false;
			 }
 		 return true;					
	}
/** -------------------------End of Email validation  ----------------------------------- */		
	
/************** ScchduleExam Page ****************/	
	function populateTimeDuration()  //Function to fill passing year values
	{	
		var frm=document.frmSchedule;
		ClearOptions(frm.timeDuration);
		addOption(frm.timeDuration,"---Select---","000");
		for(var i=20;i<=180;i=i+5)
		{
			addOption(frm.timeDuration,i,i );
		}
	}

	function populateNoQuestion()  //Function to fill passing year values
	{	
		var frm=document.frmSchedule;
		ClearOptions(frm.selectNoOfQ);
		addOption(frm.selectNoOfQ,"---Select---","000");
		for(var i=20;i<=100;i=i+5)
		{
			addOption(frm.selectNoOfQ,i,parseInt(i));
		}
	}
	
	function ClearOptions(OptionList)   //Function to clear specialization values
	{
	    for (var x=OptionList.length; x >= 0; x--)
	    {
	      OptionList[x]=null;
	    }
	}

	function addOption(selectbox,text,value )
	{
		var optn;
		optn = document.createElement("option");
		optn.text = text;
		optn.value = value;
		selectbox.options.add(optn);
		
	}
	
	
	function setIsTimeBound(opt)
	{
		if(opt=='optNo')
		{
			document.getElementById('timeRow').style.display="none";
			document.getElementById('noTimeRow').style.display="table-row";
		}
		else
		{
			document.getElementById('noTimeRow').style.display="none";
			document.getElementById('timeRow').style.display="table-row";
		}
	}

	function validateShedule()
	{
		var frm=document.frmSchedule;
		var strModule=frm.selectModule;
		var opt=frm.optRad;
		var strTime=frm.timeDuration;
		var strNoOfQues=frm.selectNoOfQ;
		var strExamDate=frm.examDate;
		if(strModule.selectedIndex==0)
		{
			alert('Please select module.');
			strModule.focus();
			return false;
		}
		if(opt[0].checked==false && opt[1].checked==false)
		{
			alert('Please select set time bound.');
			opt[0].focus();
			return false;
		}
		if(opt[0].checked==true && strTime.selectedIndex==0)
		{
			alert('Please select select time duration.');
			strTime.focus();
			return false;
		}
		if(strNoOfQues.selectedIndex==0)
		{
			alert('Please select number of questions.');
			strNoOfQues.focus();
			return false;
		}
		if(strExamDate.value==null || strExamDate.value=="")
		{
			alert('Please enter exam date.');
			strExamDate.focus();
			return false;
		}
		if(!isDate(strExamDate.value))
		{
			strExamDate.focus();
			return false;
		}
		return true;
	
	}
	
	
	function scheduleExam()
	{
		if(validateShedule()==true)
		{
			showScheduleMsg();
		}
	}
	
	

	

	function showScheduleMsg()
	{
		var http = getHTTPObject(); // We create the XMLHTTPRequest Object
		var url = "ScheduleExam.pks"; // The server-side script
		var frm=document.frmSchedule;
		var formData ="?module="+frm.selectModule.value;
		
		if(frm.optRad[0].checked==true)
			formData=formData+"&optTimeBound=true";
		else
			formData=formData+"&optTimeBound=false";
		
		formData=formData+"&time="+frm.timeDuration.value+"&noOfQ="+frm.selectNoOfQ.value+"&date="+frm.examDate.value;
	    
		http.onreadystatechange=function()
		{
		    if (http.readyState == 4) 
		    {
		        if (http.status == 200 || http.status=='complete') 
		        {
		            var message = http.responseXML.getElementsByTagName("message")[0];
		            results = message.childNodes[0].nodeValue.split(",");
		            document.getElementById('ShowMessage').innerHTML =null;
		            document.getElementById('ShowMessage').innerHTML = "<font style='color:"+results[1]+"' class='schedule_msg'>" + results[0] + "</font>";
		            document.frmSchedule.btnCancel.click();
		        }
		        else
		        {
		        	 document.getElementById('ShowMessage').innerHTML = "<font style='color:red;' class='schedule_msg'>" + "Some error has occured while sheduling exam." + "</font>";
		         }
		    }  
		    else
		    {
		    	document.getElementById('ShowMessage').innerHTML = "<font style='color:black;' class='schedule_msg'>"+"Scheduling..."+http.readyState+"</font>";
		    	
		    }
		};
		
	    http.open("POST", url+formData, true);
	    http.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	    http.send("");
	}

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
	
/************** End of ScchduleExam Page ****************/		
/************** CC Home Page ****************/	
	function goEditInfo()
	{
		
		var frm=document.frmProfile;
		
		frm.txtName.readOnly=false;
		frm.txtName.style.backgroundColor="white";
		frm.txtName.style.borderStyle="solid";
		frm.txtName.style.borderWidth="1pt";
		frm.txtName.style.borderColor="#50A8D0";
		
		frm.txtEMail.readOnly=false;
		frm.txtEMail.style.backgroundColor="white";
		frm.txtEMail.style.borderStyle="solid";
		frm.txtEMail.style.borderWidth="1pt";
		frm.txtEMail.style.borderColor="#50A8D0";
		
		frm.txtMNumber.readOnly=false;
		frm.txtMNumber.style.backgroundColor="white";
		frm.txtMNumber.style.borderStyle="solid";
		frm.txtMNumber.style.borderWidth="1pt";
		frm.txtMNumber.style.borderColor="#50A8D0";
		
		document.getElementById("ShowGenderData").style.display = 'none';
		document.getElementById("ShowGender").style.display = 'inline';
		frm.gender[0].disabled=false;
		frm.gender[1].disabled=false;
		

		frm.txtDOB.style.backgroundColor="white";
		frm.txtDOB.style.borderStyle="solid";
		frm.txtDOB.style.borderWidth="1pt";
		frm.txtDOB.style.borderColor="#50A8D0";
		
		
		document.getElementById("btnEdit").style.display="none";
		document.getElementById("btnUpdate").style.display="inline";
		document.getElementById("btnCancel").disabled=false;
		
	}

	function goCancel()
	{
		var frm=document.frmProfile;
		
		frm.txtName.readOnly=true;
		frm.txtName.style.backgroundColor="transparent";
		frm.txtName.style.borderStyle="none";
		frm.txtName.value = document.frmProfile.hidName.value;
		
		frm.txtEMail.readOnly=true;
		frm.txtEMail.style.backgroundColor="transparent";
		frm.txtEMail.style.borderStyle="none";
		frm.txtEMail.value = document.frmProfile.hidEmail.value;
		
		frm.txtMNumber.readOnly=true;
		frm.txtMNumber.style.backgroundColor="transparent";
		frm.txtMNumber.style.borderStyle="none";
		frm.txtMNumber.value = document.frmProfile.hidContact.value;
		
		
		document.getElementById("ShowGenderData").style.display = 'inline';
		
		document.getElementById("idGenderM").disabled = true;
		document.getElementById("idGenderF").disabled = true;
		
		if(document.frmProfile.hidGender.value=="Male")
			{
			document.getElementById("idGenderM").checked = true;
			}
		else
			{
			document.getElementById("idGenderF").checked = true;
			}
		document.getElementById("ShowGender").style.display = 'none';
		frm.txtDOB.readOnly=true;
		frm.txtDOB.style.backgroundColor="transparent";
		frm.txtDOB.style.borderStyle="none";
		frm.txtDOB.value = document.frmProfile.hidDOB.value;
		
		
		
		document.getElementById("btnEdit").style.display="block";
		//document.getElementById("btnEdit").style.display="table-row";
		document.getElementById("btnUpdate").style.display="none";
	}
	
	function updateContact()
	{
		var frm=document.frmProfile;
		if(!validemail(frm.txtEMail))
		{
			frm.txtEMail.focus();
			return false;
		}
		
		if(frm.txtMNumber.value=="")
		{
			alert('Please enter your mobile no.');
			frm.txtMNumber.focus();
			return false;
		}
		
		if(isNaN(frm.txtMNumber.value) || frm.txtMNumber.value==0)
		{
			alert('Invalid mobile number');
			frm.txtMNumber.focus();
			return false;
		}
		if(frm.txtMNumber.value.length<10)
		{
			alert('Mobile number should be of 10 digits.');
			frm.txtMNumber.focus();
			return false;
		}
		return true;
		
	}
/************** End of CC Home Page ****************/	
/*******************Exam Page timer and pop up*****************/
	var ie=document.all;
	var dom=document.getElementById;
	var ns4=document.layers;
	var calunits=document.layers? "" : "px";

	var bouncelimit=32 ;//(must be divisible by 8)
	var direction="up";

	function initbox()
	{
		if (!dom&&!ie&&!ns4)
		return
		crossobj=(dom)?document.getElementById("dropin").style : ie? document.all.dropin : document.dropin;
		scroll_top=(ie)? truebody().scrollTop : window.pageYOffset;
		crossobj.top=scroll_top-250+calunits;
		crossobj.visibility=(dom||ie)? "visible" : "show";
		dropstart=setInterval("dropin()",50);
		setTimeout('dismissbox()',5000);
	}

	function dropin()
	{
		scroll_top=(ie)? truebody().scrollTop : window.pageYOffset;
		if (parseInt(crossobj.top)<100+scroll_top)
		{
			crossobj.top=parseInt(crossobj.top)+40+calunits;
		}
		else
		{
			clearInterval(dropstart);
			///bouncestart=setInterval("bouncein()",50);
		}
	}

	function bouncein()
	{
		crossobj.top=parseInt(crossobj.top)-bouncelimit+calunits;
		if (bouncelimit<0)
			bouncelimit+=8;
		
		bouncelimit=bouncelimit*-1;
		if (bouncelimit==0)
		{
			clearInterval(bouncestart);
		}
	}

	function dismissbox()
	{
		if (window.bouncestart)
		{
			clearInterval(bouncestart);
		}
		crossobj.visibility="hidden";
		document.frmExam.txtQNumber.value="end";
		document.frmExam.action="ExamSaveAnswer";
		document.frmExam.method="post";
		document.frmExam.submit();
	}

	function truebody()
	{
		return (document.compatMode!="BackCompat")? document.documentElement : document.body;
	}
	
	function showTimeRemaining()
	{
		var xmlhttp=null;
		xmlhttp=getHTTPObject();
		xmlhttp.onreadystatechange=function()
		{
			if (xmlhttp.readyState == 4) 
		    {
		        if (xmlhttp.status == 200 || xmlhttp.status=='complete') 
		        {
		            var message = xmlhttp.responseXML.getElementsByTagName("message")[0];
		            results = message.childNodes[0].nodeValue.split(",");
		            document.getElementById("time").innerHTML=null;
		            document.getElementById("time").innerHTML= results[0];
		            
					if(results[1]<=11000)
					{	
						document.getElementById("time").style.textDecoration="blink";
						document.getElementById("time").style.color="red";
					}
				  	if(results[1]<=0 && document.getElementById("dropin").style.visibility=="hidden")
			     	{
				  		initbox();
			        }
		        }
		    }  
		};
		xmlhttp.open("POST", "ExamTimeCalculation.pks", true);
		xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
		xmlhttp.send("");
	
	}
	
	
/*******************End Exam Page timer and pop up*****************/


	
