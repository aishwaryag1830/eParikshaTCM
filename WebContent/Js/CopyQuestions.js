function get_drp_selected_value_on_choice(drp,sel_choice) //so that if 0 & 2 ie----- are selected put in textbox the answer
{
	var path1 = drp;//document.getElementById('drpCourses');
	var choices = new Array;
	for (var i = 0; i < path1.options.length; i++)
		{
	    if (path1.options[sel_choice].selected)
	      choices[choices.length] = path1.options[sel_choice].value;  //.value
		}
	return choices[0];
}

function getXMLHttpRequestObject()
{
	   try{
				// Opera 8.0+, Firefox, Safari
		    	xmlHttpRequest = new XMLHttpRequest();
			} catch (e)
			{
						// Internet Explorer Browsers
						try{
							xmlHttpRequest = new ActiveXObject("Msxml2.XMLHTTP");
						} catch (e) {
										try{
											xmlHttpRequest = new ActiveXObject("Microsoft.XMLHTTP");
										} catch (e){
											// Something went wrong
											alert("Please refresh or restart browser again");
											return false;
										}
									}
			}

    return xmlHttpRequest;
}

function getModulesFromCourse(sCourseId)
{
	var xmlHttpRequest	=	getXMLHttpRequestObject();
	
	xmlHttpRequest.onreadystatechange=function()
	{
		if(xmlHttpRequest.readyState==4 && xmlHttpRequest.status==200)
		{
			responseHandlerToAddModules(xmlHttpRequest);
		}
		else 
		{
			if(document.getElementById('divOperationalMsgs')!=null)
				document.getElementById('divOperationalMsgs').style.display='block';
			
			document.getElementById('divOperationalMsgs').innerHTML	="<img style='padding-left:10px;width:40px;hieght:40px;' src='images/ajaxLoader.gif'><br>Loading...";
			
		}
	};
	params="sCourseIdAjax="+sCourseId+"&sfunctionIdentifier=1";	//1-get modules function call compulsory for calling servlet
	xmlHttpRequest.open("POST","CopyQuestionsAjaxOperations",true);
	xmlHttpRequest.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	xmlHttpRequest.setRequestHeader("Content-length", params.length);
	xmlHttpRequest.send(params);
}

function getQuestionsFromModule(sModuleId)
{
	var xmlHttpQuestions	=	getXMLHttpRequestObject();
	
	xmlHttpQuestions.onreadystatechange=function ()
	{
		if(xmlHttpQuestions.readyState==4 && xmlHttpQuestions.status==200)
		{
			responseHandlerToAddQuestions(xmlHttpQuestions);
		}
		else 
		{
			if(document.getElementById('divOperationalMsgs')!=null)
				document.getElementById('divOperationalMsgs').style.display='block';
			
			document.getElementById('divOperationalMsgs').innerHTML	="<img style='padding-left:10px;width:40px;hieght:40px;' src='images/ajaxLoader.gif'><br>Loading...";
		}
	};
	params="sModuleIdAjax="+sModuleId+"&sfunctionIdentifier=2";	//2-get questions function call compulsory for calling servlet
	xmlHttpQuestions.open("POST","CopyQuestionsAjaxOperations",true);
	xmlHttpQuestions.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	xmlHttpQuestions.setRequestHeader("Content-length", params.length);
	xmlHttpQuestions.send(params);
}


function addDrpDownOptions(drp,optnText,optnValue,optnTitle,optnId)
{
	var drpOptions=document.createElement("OPTION");
	drpOptions.text=optnText;
	drpOptions.value=optnValue;
	drpOptions.title=optnTitle;
	drpOptions.id=optnId;
	
	drp.options.add(drpOptions);
}

function responseHandlerToAddModules(xmlHttp)
{
	xmlHandler=xmlHttp.responseXML;
	var drpModules=document.getElementById('drpModules');
	
	var module;
	
	module=xmlHandler.getElementsByTagName("Modules")[0];
	
	if(module!=null)
	{
			var moduleSerialIds,moduleId,moduleName,moduleShortName;
			
			drpModules.options.length=1;
			
			if(module.childNodes.length > 0)//modules present in xml
			{
				for(var i=0; i < module.childNodes.length; i++)
				{

					moduleSerialIds = module.getElementsByTagName("moduleSerialId")[i];
					moduleId = moduleSerialIds.getElementsByTagName("moduleId")[0].childNodes[0].nodeValue;
					moduleShortName = moduleSerialIds.getElementsByTagName("moduleShortName")[0].childNodes[0].nodeValue;
					moduleName = moduleSerialIds.getElementsByTagName("moduleName")[0].childNodes[0].nodeValue;
/*Adding options*/	addDrpDownOptions(drpModules,moduleShortName,moduleId,moduleName,moduleSerialIds);			
				}
				if(drpModules.options.length>1)
				{
					drpModules.options[0].text="--Select Module--";
					drpModules.disabled=false;
					
					if(document.getElementById('divContainerQuestions')!=null)
						document.getElementById('divContainerQuestions').style.display='none';
					
					if(document.getElementById('divOperationalServerMsgs')!=null)
						document.getElementById('divOperationalServerMsgs').style.display='none';
					
					if(document.getElementById('divOperationalMsgs')!=null)
						document.getElementById('divOperationalMsgs').style.display='block';
					
					if(document.getElementById('divOperationalMsgs')!=null)
						document.getElementById('divOperationalMsgs').innerHTML="Please select module.";
					
					

				}
			}
			else	//If no modules present
			{
				if(drpModules.options.length<=1)
				{
					drpModules.options[0].text="No Modules";
					drpModules.disabled=true;
					
					if(document.getElementById('divOperationalServerMsgs')!=null)
						document.getElementById('divOperationalServerMsgs').style.display='none';
					
					if(document.getElementById('divOperationalMsgs')!=null)
						document.getElementById('divOperationalMsgs').style.display='block';
					
					if(document.getElementById('divOperationalMsgs')!=null)
							document.getElementById('divOperationalMsgs').innerHTML="No modules present in selected course.";

					document.getElementById('drpQuestionsCriteria').selectedIndex=0;
					document.getElementById('drpQuestionsCriteria').disabled=true;
	
				}
			}
	}
}
function responseHandlerToAddQuestions(xmlHttp)
{
	xmlHandler=xmlHttp.responseXML;
	var drpQuestionsCriteria=document.getElementById('drpQuestionsCriteria');
	
	var questions;
	
	questions=xmlHandler.getElementsByTagName("Questions")[0];
	if(questions!=null)
	{
			var questionSerialIds,questionCriteria;
			
			drpQuestionsCriteria.options.length=1;
			
			if(questions.childNodes.length > 0)//modules present in xml
			{
				for(var i=0; i < questions.childNodes.length; i++)
				{
					questionSerialIds = questions.getElementsByTagName("questionsSerialId")[i];
					questionCriteria = questionSerialIds.getElementsByTagName("questionValue")[0].childNodes[0].nodeValue;
/*Adding options*/	addDrpDownOptions(drpQuestionsCriteria,questionCriteria,questionCriteria,questionCriteria,questionSerialIds);			
				}
				if(drpQuestionsCriteria.options.length>1)
				{
					drpQuestionsCriteria.options[0].text="--Select Question No.s--";
					
					if(document.getElementById('divOperationalMsgs')!=null)
						document.getElementById('divOperationalMsgs').innerHTML="Please select questions limit.";

					drpQuestionsCriteria.disabled=false;
				}
			}
			else	//If no modules present
			{
				if(drpQuestionsCriteria.options.length<=1)
				{
					drpQuestionsCriteria.options[0].text="No Questions";
					document.getElementById('divOperationalMsgs').innerHTML="No questions present in selected module.";
					drpQuestionsCriteria.disabled=true;
	
				}
			}
	}
}

function drpSelectCourse(drp)
{
	var sCourseId	=	get_drp_selected_value_on_choice(drp,drp.selectedIndex);
	
	if(drp.selectedIndex>0)
	{
		/*Remove old values from modules & questions drop down*/
		document.getElementById('drpModules').selectedIndex=0;
		document.getElementById('drpModules').options.length=1;
		
		document.getElementById('drpQuestionsCriteria').selectedIndex=0;
		document.getElementById('drpQuestionsCriteria').options.length=1;
		
		/*Get modules for selected course*/
		getModulesFromCourse(sCourseId);
		
		if(document.getElementById('divContainerQuestions')!=null)
			document.getElementById('divContainerQuestions').style.display='none';
		
		if(document.getElementById('divOperationalServerMsgs')!=null)
			document.getElementById('divOperationalServerMsgs').style.display='none';
		
		if(document.getElementById('divOperationalMsgs')!=null)
			document.getElementById('divOperationalMsgs').style.display='none';
	}
	
	if(drp.selectedIndex==0)
	{	
		if(document.getElementById('divOperationalMsgs')!=null)
			document.getElementById('divOperationalMsgs').innerHTML="Please select course.";
				
		document.getElementById('drpModules').selectedIndex=0;
		document.getElementById('drpModules').options.length=1;
		
		document.getElementById('drpQuestionsCriteria').selectedIndex=0;
		document.getElementById('drpQuestionsCriteria').options.length=1;

	}
}
function drpSelectModule(drp)
{
	var sModuleId	=	get_drp_selected_value_on_choice(drp,drp.selectedIndex);
	
	if(drp.selectedIndex>0)
		getQuestionsFromModule(sModuleId);
	
	if(drp.selectedIndex==0)
	{	
		if(document.getElementById('divOperationalMsgs')!=null)
			document.getElementById('divOperationalMsgs').innerHTML="Please select module.";
		
		document.getElementById('drpQuestionsCriteria').selectedIndex=0;
		document.getElementById('drpQuestionsCriteria').options.length=1;
	}
}
function drpSelectQuestions(frm,drp)
{
	frm.submit();
}
/******************Fetching of question criteria depending on course & module ends*********************/





/******************Functionality to check selected question is already present or not begins********************/
/*index Of function for Array in IE*/
Array.prototype.indexOf = function(obj, start) 
{      
	for (var i = (start || 0), j = this.length; i < j; i++) 
	{    
		if (this[i] === obj) { return i; }      
	}      return -1; 
};

function sortArrayAscending(num1,num2)
{
	return num1 - num2;
}



var arrSelQuestLinks	=	new Array();//Global array that holds values & increase or shrinks accordingly
var arrSelQuestActualIds	=	new Array();//Global array to hold actual question ids for copying

function prepareQuestPool(QNo,QActualId)
{
	arrSelQuestLinks.push(QNo);
	arrSelQuestActualIds.push(QActualId);
	
	
}
function removeQuestFromPool(sQNoToRemove,sActualQuestId)
{
	
	if(arrSelQuestLinks.indexOf(sQNoToRemove)!=-1)
		arrSelQuestLinks.splice(arrSelQuestLinks.indexOf(sQNoToRemove),1);//1-index;1-how many elements to be removed
	
	if(arrSelQuestActualIds.indexOf(sActualQuestId)!=-1)
		arrSelQuestActualIds.splice(arrSelQuestActualIds.indexOf(sActualQuestId),1);//1-index;1-how many elements to be removed
	
	
}
/**
 * To Scroll to the question on clicking the question number
 * **/

function setSelectedHyperlinksInDiv(arrFinalSelQuest,arrFinalSelQuestActualIds)
{
	
	var divHyperLinkSection	=	document.getElementById('divSelectedQuestions').innerHTML;

	var linkVisibleNo	=0,linkVisibleNoForSpan=0;
	
	divHyperLinkSection	="";
	
	arrFinalSelQuest.sort(sortArrayAscending);
	
	arrFinalSelQuestActualIds.sort(sortArrayAscending);
	
	for(var i=0;i<arrFinalSelQuest.length;i++)
	{
	
			linkVisibleNoForSpan	=	arrFinalSelQuest[i];//Holding number for calculation.

			divHyperLinkSection	=	divHyperLinkSection	+	
			"<a onclick='javascript:void(0)' href='#divEachQuestionHolder"+arrFinalSelQuest[i]+"'>"+arrFinalSelQuest[i]+"</a>";
			
			if((i+1)%3!=0)//If line is not changed & it's not last 3rd element then give space.
			{
				divHyperLinkSection	=	divHyperLinkSection+"<span style='margin:0px 0px 0px 35px;' id='spLinkSpacer"+linkVisibleNoForSpan+"'>&nbsp;</span>";
			}
			
			if((i+1)%3==0)//links count:i+1 to take first element as 1; since index started from zero.
			{
				divHyperLinkSection=	divHyperLinkSection	+'<br/><br/><br/>';
			}
			
			
			
	}//end for
	
	document.getElementById('divSelectedQuestions').innerHTML=divHyperLinkSection;//First elements has to created before applying margin by javascript

	for(var counter=0;counter<arrFinalSelQuest.length;counter++)
	{
		linkVisibleNo	=	arrFinalSelQuest[counter];//Holding number for calculation.

		/*if(linkVisibleNo<10)//first link could be 3 digit also so margin is giving acc to this link no not be link counts
			if(document.getElementById('spLinkSpacer'.concat(linkVisibleNo))!=null)
					document.getElementById('spLinkSpacer'.concat(linkVisibleNo)).style.margin="0px 18px";
		*/	
		 if(linkVisibleNo>=10)//If link no is >=10 
			if(document.getElementById('spLinkSpacer'.concat(linkVisibleNo))!=null)
				document.getElementById('spLinkSpacer'.concat(linkVisibleNo)).style.margin="0px 0px 0px 28px";
		 
		 if(linkVisibleNo>=100)
				if(document.getElementById('spLinkSpacer'.concat(linkVisibleNo))!=null)
					document.getElementById('spLinkSpacer'.concat(linkVisibleNo)).style.margin="0px 0px 0px 22px";
		 
		 if(linkVisibleNo>=1000)
				if(document.getElementById('spLinkSpacer'.concat(linkVisibleNo))!=null)
					document.getElementById('spLinkSpacer'.concat(linkVisibleNo)).style.margin="0px 0px 0px 15px";
		
	}
	
	/*Holding array of actual ques ids*/
	if(document.getElementById('txtFinalSelQuestions')!=null)
		document.getElementById('txtFinalSelQuestions').value=arrFinalSelQuestActualIds.toString();;
		
	if(arrFinalSelQuest.length>0)
		document.getElementById('subCopyNow').disabled=false;
	else
	{
		document.getElementById('divSelectedQuestions').innerHTML="<p style='padding-top:160px;color:red'>Please add questions to this basket</p>";

		document.getElementById('subCopyNow').disabled=true;
	}


}

function isQuestionAlreadyExists(chkBox,selectedQuestion)
{
	var xmlHTTPQuestCheck	=	getXMLHttpRequestObject();
	document.getElementById('lblMessages').innerHTML="";
	//$("#lblMessages").fadeOut(500);
	xmlHTTPQuestCheck.onreadystatechange=function ()
	{
		if(xmlHTTPQuestCheck.readyState==4 && xmlHTTPQuestCheck.status==200)
		{
			responseHandlerQuestExistence(chkBox,xmlHTTPQuestCheck);
			
		}
		else 
		{
			if(xmlHTTPQuestCheck.readyState==0)
				alert('Server Error:Unable to process request');
			
		}
	};
	params="sSelectedQuestionId="+selectedQuestion+"&sfunctionIdentifier=3";	//3-Check this question existence in module where it is to be copied 
	xmlHTTPQuestCheck.open("POST","CopyQuestionsAjaxOperations",true);
	xmlHTTPQuestCheck.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	xmlHTTPQuestCheck.setRequestHeader("Content-length", params.length);
	xmlHTTPQuestCheck.send(params);

}
function responseHandlerQuestExistence(chkBox,xmlHTTPObject)
{
	
	xmlResponseQuestCheck	=	xmlHTTPObject.responseXML;
	
	var questExistenceParent,isThisQuestionExists=null;
	
	questExistenceParent=xmlResponseQuestCheck.getElementsByTagName("QuestionExistence")[0];
	
	if(questExistenceParent!=null)
	{
			if(questExistenceParent.childNodes.length > 0)//modules present in xml
			{
				isThisQuestionExists=questExistenceParent.getElementsByTagName("isThisQuestExists")[0].childNodes[0].nodeValue;
			}
	}
	if(isThisQuestionExists=='true')//If Question exists;As true is string in xml
	{
		document.getElementById('lblMessages').innerHTML="Selected question already exists in module.";
		chkBox.checked=false;
		
		
	}
	else//If question is not found then add to selected list
	{
		
		var chkBoxIdHavingQNo	=	chkBox.id.split('-')[1];
		
		prepareQuestPool(chkBoxIdHavingQNo,chkBox.value);

		/*Note:Array is correct here only do not change function's call place.
		 * arrSelQuesLinks is not giving exact values may be due to ajax response
		 */
		 
		setSelectedHyperlinksInDiv(arrSelQuestLinks,arrSelQuestActualIds);//arrSelQuestLinks:gloabal array that holds values & increase or shrinks accordingly

		jQuery("#lblMessages").html("");
	}
}
function selCheckBoxOperations(chkBox,selectedQuestion)
{
	if(chkBox.checked)//if checkbox is checked then only send requests else don't waste call
	{
		isQuestionAlreadyExists(chkBox,selectedQuestion);

	}
	
	if(!chkBox.checked)//if checkbox is checked then only send requests else don't waste call
	{
		var chkBoxIdHavingQNo	=	chkBox.id.split('-')[1];
		
		removeQuestFromPool(chkBoxIdHavingQNo,selectedQuestion);
		
		setSelectedHyperlinksInDiv(arrSelQuestLinks,arrSelQuestActualIds);
		
	}

	
}

function CopyQuestionsNow()
{
	
	var answer	=	confirm(arrSelQuestLinks.length+" questions will be copied to the module.Continue?");
	if(answer)
		return true;
	else
		return false;
	
	return false;
}


/******************Functionality to check selected question is already present or not ends********************/

/*******************************Script for Select All questions begins*******************/
/**
 * To scroll down both divs with animation functionality
 */
function scrollQuestionsDivsDown(chkelementArray)
{
	var maxHeightDivQuestionHolder	=	document.getElementById("divQuestionsHolder").scrollHeight;
	var maxHeightQuesNoDiv			=	document.getElementById("divSelectedQuestions").scrollHeight;
	
	var timeToSroll	=	(chkelementArray.length)*100+1000; 
	
	jQuery("#divQuestionsHolder").stop().animate(
			{scrollTop:maxHeightDivQuestionHolder},timeToSroll,'linear',function(){jQuery("#chkSelectAll").attr('disabled',false);}
			);
	
	jQuery("#divSelectedQuestions").stop().animate(
			{scrollTop:maxHeightQuesNoDiv},timeToSroll*2,'linear');
}

/**
 * To scroll divQuestionsHolder up with animation functionality
 */
function scrollQuestionsDivsUp()
{	
	jQuery("#divQuestionsHolder").stop().animate(
			{scrollTop:0},'slow'
			);	
}

/**
 * handler function for checkbox select all click
 * Takes care of proper selection of all questions.
 * @param chkelementArray
 */
function chkSelectAllClick(chkelementArray)
{
	var chkelementArray	=	jQuery("[name=chkThisQuestion]");
		
		if(jQuery("#chkSelectAll").is(":checked"))  //If select all is checked
		{
			jQuery("#chkSelectAll").attr('disabled',true);
			for(var i=0;i<chkelementArray.length;i++)
			{
				if(chkelementArray[i].checked==false)	
					chkelementArray[i].click();					
			}			
			scrollQuestionsDivsDown(chkelementArray);			
	   }
		else
		{
			jQuery("#divQuestionsHolder").stop();
			for(var i=0;i<chkelementArray.length;i++)
			{
				if(chkelementArray[i].checked==true)
					chkelementArray[i].click();
			}			
			if(jQuery('#txtFinalSelQuestions')!=null)
				jQuery('#txtFinalSelQuestions').val("");
			
			scrollQuestionsDivsUp();
		}
	
}

function selectAllQuestionsFunctionality()
{
	jQuery("#chkSelectAll").click(chkSelectAllClick);
}
jQuery(document).ready(selectAllQuestionsFunctionality);

/***************************************Script for Select All questions ends***********************/









