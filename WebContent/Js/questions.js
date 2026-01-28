/**
 * 
 * 
 * @author Prashant Bansod
 * @date 04-10-01
 * Questions edit, add & delete operations
 */



/*To remove smart quotes of data when copied from */
function removeMSWordChars(str) {
    var myReplacements = new Array();
    var intReplacement;
    myReplacements[8216] = 39;
    myReplacements[8217] = 39;
    myReplacements[8220] = 34;
    myReplacements[8221] = 34;
    myReplacements[8212] = 45;
    var c;
    for(c=0; c<str.length; c++) {
    	var myCode = str.charCodeAt(c);
        if(myReplacements[myCode] != undefined) {
            intReplacement = myReplacements[myCode];
            str = str.substr(0,c) + String.fromCharCode(intReplacement) + str.substr(c+1);
            
        }
    }
    return str;
}


/*making trim() function compatible in IE*/
if(typeof String.prototype.trim !== 'function') 
{
	String.prototype.trim = function() 
	{
		return this.replace(/^\s+|\s+$/g, ''); 
	};
} 



/*Method for creating ajax request*/
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

function ajaxAddOperations()
{
	var xmlHttpRequest	=	getXMLHttpRequestObject();
	  
		xmlHttpRequest.onreadystatechange=function ()
		{
			if(xmlHttpRequest.readyState==4 && xmlHttpRequest.status==200)
			{}//	responseHandler(xmlHttpRequest);
			
			else 
			{
				//if(document.getElementById('divCentres')!=null)
				//	document.getElementById('divCentres').innerHTML="<div style=\"margin:100px;0px;0px;0px;\"><img src=\"images/ajaxLoader.gif\" style=\"width:40px;height:40px;\"></div>"
			}
		};
		params="";		//compulsory for calling servlet
		xmlHttpRequest.open("POST","SessionVariablesMaintain",true);
		xmlHttpRequest.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
		xmlHttpRequest.setRequestHeader("Content-length", params.length);
		xmlHttpRequest.send(params);
}
function isQuestionExistsOnAddUpdOpn(sQuestion,sOption1,sOption2,sOption3,sOption4,iCorrectAns)
{
	var xmlHttpRequest	=	getXMLHttpRequestObject();
	
	params="sQuestionText="+encodeURIComponent(sQuestion)+"&sOption1="+encodeURIComponent(sOption1)+"&sOption2="+encodeURIComponent(sOption2)+"&sOption3="+encodeURIComponent(sOption3)+"&sOption4="+encodeURIComponent(sOption4)+"&iCorrectAns="+iCorrectAns+"&sfunctionIdentifier=4";	//4-calling check function, compulsory for calling servlet
	xmlHttpRequest.open("POST","CopyQuestionsAjaxOperations",true);
	xmlHttpRequest.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	xmlHttpRequest.setRequestHeader("Content-length", params.length);
	xmlHttpRequest.send(params);
	
	
	xmlHttpRequest.onreadystatechange=function ()
	{
		if(xmlHttpRequest.readyState==4 && xmlHttpRequest.status==200)
		{
			responseHandlerQuestExistence(xmlHttpRequest);
		}		
		else 
		{
			if(document.getElementById('div_message_operations')!=null)
				document.getElementById('div_message_operations').innerHTML="<img src=\"images/ajaxLoader.gif\" style=\"width:20px;height:20px;\">";
		}
	};
	
	
	
}

function responseHandlerQuestExistence(xmlHTTPObject)
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
		document.getElementById('div_message_operations').innerHTML="Entered question already exists.";

	}
	else//If question is not found then add to selected list
	{
		finalSubmit();

	}
}

function getSelectedQuestion(frm,selectedQues)
{
	document.getElementById("txtSelQuestion").value=selectedQues;
	/*To maintain scroll position*/
	document.getElementById("txtScrollYPosition").value=document.getElementById('divQuestionLinksElements').scrollTop;

	frm.submit();
}

function get_selectedvalue(value)
{
	document.getElementById('txt_ans').value=value;	
}

var dataArray=new Array(6);
function setTextAreaData(frm_data)
{
		dataArray[0]=frm_data.txtquestion.value;
		dataArray[1]=frm_data.txtoption1.value;
		dataArray[2]=frm_data.txtoption2.value;
		dataArray[3]=frm_data.txtoption3.value;
		dataArray[4]=frm_data.txtoption4.value;
		dataArray[5]=frm_data.drp_ans.selectedIndex;
}
function getTextAreaData(getValue)
{
	return dataArray[getValue];
}
function resetQuestionLink()
{
	
	var anchorId;
	//If question is selected then only do the following
	if(document.getElementById("txtSelQuestion")!=null && document.getElementById("txtSelQuestion").value.length!=0)
	{
		anchorId	=	document.getElementById("txtSelQuestion").value;
		document.getElementById(anchorId).style.color='#1C89FF';
		document.getElementById(anchorId).setAttribute("onclick", "javascript:getSelectedQuestion(document.getElementById('frmSubmitQuestionId'),"+anchorId+")");
		document.getElementById(anchorId).style.backgroundColor="white";
	}
	$("#divQuestionLinksElements").scrollTop(0);
}
function addQuestionMode(frm_data)
{
	
	ajaxAddOperations();		//session varaiables management
	resetDeleteOptions();	//Setting checkboxes etc.
	resetQuestionLink();	//Reset hyperlink color & functionality on other operation
	
	/*For maintaining scroll position on server trip*/
	document.getElementById("txtScrollYPositionQuesDiv").value=document.getElementById('divQuestionLinksElements').scrollHeight;

	
	if(document.getElementById("div_table")!=null)
		document.getElementById("div_table").style.display="";
	
	if(document.getElementById("divEditMsg")!=null)
		document.getElementById("divEditMsg").style.display="none";
	
	
	for(var i=0;i<frm_data.length;i++)  
	{
		if(frm_data.elements[i].type=="textarea")
		{
			frm_data.elements[i].setAttribute('class','nonTransparent');
			frm_data.elements[i].setAttribute('className','nonTransparent');

			frm_data.elements[i].value="";
			frm_data.elements[i].readOnly=false;
		}
	}
	
	  document.getElementById('txt_ans_string').style.display='none';
	  document.getElementById('drp_ans').style.display='block';
	  document.getElementById('drp_ans').selectedIndex=0;
	  
	  document.getElementById('btn_Add').style.display="";
	  document.getElementById('btn_reset').style.display="";

	  document.getElementById('btn_change').style.display='none';
	  document.getElementById('btn_cancel').style.display='none';
	  document.getElementById('btn_update').style.display='none';
}
function editQuestionMode()
{
	
	document.getElementById("div_table").style.display="none";
	document.getElementById("divEditMsg").innerHTML="<div class=\"message_directions\" style=\"padding-top:100px;\">" +
														"Please select question from left menu."
													+"</div>";
	document.getElementById("divEditMsg").style.display="";
	/*For maintaining scroll position on server trip*/

	
	resetDeleteOptions();	//Setting checkboxes etc.
	resetQuestionLink();	//Reset hyperlink color & functionality on other operation
	
}


function finalSubmit()
{
	var frmIdentifier	=	document.getElementById('txtOprIdentifier').value;
	var frm	=	document.getElementById('frm_data');
	
	var frmActionName="";
	if(frmIdentifier=="1")
		frmActionName="AddQuestion";
	else if(frmIdentifier=="2")
		frmActionName="UpdateQuestion";
	
	/*
	 *Removing MS Word Type Characters before form submission. 
	 * */
	document.getElementById('txtquestion').value=removeMSWordChars(document.getElementById('txtquestion').value);
	document.getElementById('txtoption1').value=removeMSWordChars(document.getElementById('txtoption1').value);
	document.getElementById('txtoption2').value=removeMSWordChars(document.getElementById('txtoption2').value);
	document.getElementById('txtoption3').value=removeMSWordChars(document.getElementById('txtoption3').value);
	document.getElementById('txtoption4').value=removeMSWordChars(document.getElementById('txtoption4').value);
		
	frm.action=frmActionName;
	frm.submit();
}

function onUpdateAndAddOperations()
{
		
		var sQuestion	=	removeMSWordChars(document.getElementById('txtquestion').value.trim());
		var sOption1	=	removeMSWordChars(document.getElementById('txtoption1').value.trim());
		var sOption2	=	removeMSWordChars(document.getElementById('txtoption2').value.trim());
		var sOption3	=	removeMSWordChars(document.getElementById('txtoption3').value.trim());
		var sOption4	=	removeMSWordChars(document.getElementById('txtoption4').value.trim());
		var iCorrectAnswer = document.getElementById('drp_ans').options[document.getElementById('drp_ans').selectedIndex].value;
		
		
		if( validateFormEntries(document.getElementById('frm_data')) )//Check all validations if fine then call ajax for checking question duplication
			isQuestionExistsOnAddUpdOpn(sQuestion,sOption1,sOption2,sOption3,sOption4,iCorrectAnswer) ;				
	
}

/****************************************Jquery Handling of elements********************/
/**
 * Function to select all the questions for delete operation.
 */


function selectAllQuestions()
{
	
	var chkelementArray	=	$("[name=chkQuestions]");
	var timeToSroll	=	(chkelementArray.length)*25; 
	
	if($("#chkSelectAll").is(":checked"))  //If select all is checked
	{
		$("#chkSelectAll").attr('disabled',true);
		for(var i=0;i<chkelementArray.length;i++)
		{
			if(chkelementArray[i].checked==false)	
				chkelementArray[i].click();					
		}			
		
		
		var maxHeightDivQuestionHolder	=	document.getElementById("divQuestionLinksElements").scrollHeight;

		$("#divQuestionLinksElements").stop().animate(
				{scrollTop:maxHeightDivQuestionHolder},timeToSroll,'linear',function(){$("#chkSelectAll").attr('disabled',false);}
				);
		
   }
	else
	{
		$("#divQuestionLinksElements").stop().animate(
				{scrollTop:0},timeToSroll);
		
		for(var i=0;i<chkelementArray.length;i++)
		{
			if(chkelementArray[i].checked==true)
				chkelementArray[i].click();
		}			
		
	}
}


function delQuestionMode(frmQuestions,totalSpans)
{
	var txtActualQuestionIdValue;

	for(var i=1;i<=totalSpans;i++)  
	{
		txtActualQuestionIdValue	=	document.getElementById('txtActualQuestionId'.concat(i)).value;
		document.getElementById('spCheckboxHolder'.concat(i)).innerHTML="<input  value="+txtActualQuestionIdValue+" name=\"chkQuestions\" style=\"width:13px;height:13px;\" type=\"checkbox\">";
		
		if(i<10)
		{	
			document.getElementById('spCheckboxHolder'.concat(i)).style.marginRight="18px";
			if(i%3==0)
				document.getElementById('spCheckboxHolder'.concat(i)).innerHTML=document.getElementById('spCheckboxHolder'.concat(i)).innerHTML+"<br\>";
		}
		else
		{
			document.getElementById('spCheckboxHolder'.concat(i)).style.marginRight="10px";
			if(i%3==0)
				document.getElementById('spCheckboxHolder'.concat(i)).innerHTML=document.getElementById('spCheckboxHolder'.concat(i)).innerHTML+"<br\>";
		}
	}
	
	document.getElementById("div_table").style.display="none";
	document.getElementById("divEditMsg").innerHTML="<div class=\"message_directions\" style=\"padding-top:100px;\">" +
														"Please select questions from left menu.</div>"+
														"<br>"+
														"<div style='width:200px'>"+
															"<div style='float:left;margin-right:20px;'>"+
													 			"<input onclick='selectAllQuestions();' type=\"checkbox\" name=\"chkSelectAll\" id=\"chkSelectAll\" />"+
																"<label for=\"chkSelectAll\" class=\"lblstyle\">Select All</label>"+
															"</div>"+
															"<div style='float:right'>" +
																"<input id='btnDelete' class=\"button\" onclick=\"javascript:executeDeleteOpn(document.getElementById('frmSubmitQuestionId'))\" type=\"button\" value=\"Delete\" />"+
															 "</div>"+
															 "<div style='clear:both'></div>"+
														"<div>";
													
	document.getElementById("divEditMsg").style.display="block";
	resetQuestionLink();	//Reset hyperlink color & functionality on other operation

	
}


/**
 * Finding if atleast one question has to be selected for deletion
 * @return
 */
function isAnyQuestionSelected()
{
	var arr	=	document.getElementsByName("chkQuestions");
	
	for(var i=0;i<arr.length;i++)
	{
		if(arr[i].checked	==	true)
		{	
			return true;
		}
		
	}
	
	return false;
}
function executeDeleteOpn(frm)
{
	if(isAnyQuestionSelected())
	{
			frm.action="DeleteQuestions";
			if(confirm('Selected question(s) will be deleted. Continue?')==true)
				frm.submit();
			document.getElementById("txtScrollYPosition").value=document.getElementById('divQuestionLinksElements').scrollTop;
	}
	else
		alert('Please select atleast one question to delete.');
}
function resetDeleteOptions()
{
	var totalQuestions	=	document.getElementById("txtTotalQuestions").value;
	
	for(var i=1;i<=totalQuestions;i++)  
	{
		document.getElementById('spCheckboxHolder'.concat(i)).innerHTML="&nbsp;";
		
		if(i<10)
		{	
			document.getElementById('spCheckboxHolder'.concat(i)).style.marginRight="38px";
			
		}
		else
			document.getElementById('spCheckboxHolder'.concat(i)).style.marginRight="30px";
	}
}


function change(frm_data)
{
	resetDeleteOptions();
	setTextAreaData(frm_data);
    

	for(var i=0;i<frm_data.length;i++)  
	{
		if(frm_data.elements[i].type=="textarea")
		{
			frm_data.elements[i].setAttribute('class','nonTransparent');
			frm_data.elements[i].setAttribute('className','nonTransparent');

			frm_data.elements[i].value=getTextAreaData(i);
			frm_data.elements[i].readOnly=false;
		}
	}
  document.getElementById('txt_ans_string').style.display='none';
  document.getElementById('drp_ans').style.display="";
  document.getElementById("txtquestion").focus();

  document.getElementById('btn_change').style.display='none';
  document.getElementById('btn_cancel').style.display='';
  document.getElementById('btn_update').disabled=false;
  document.getElementById('btn_reset').disabled=false;

  document.getElementById('drp_ans').selectedIndex=document.getElementById('txt_ans').value;
}


function resetEditableData(frm_rows)
{	
	for(var i=0;i<frm_rows.length;i++)  
	{
		if(frm_rows.elements[i].type=="textarea")
		{
			frm_rows.elements[i].setAttribute('class','transparent');
			frm_rows.elements[i].setAttribute('className','transparent');

			frm_rows.elements[i].value=getTextAreaData(i);
			frm_rows.elements[i].readOnly=true;
		}
	}

	document.getElementById('txt_ans_string').style.display="";
	document.getElementById('drp_ans').style.display="none";

	frm_rows.elements['btn_change'].style.display="";
	frm_rows.elements['btn_cancel'].style.display='none';
	frm_rows.elements['btn_update'].disabled="disabled";
	frm_rows.elements['btn_reset'].disabled="disabled";

}
/***********************Validations**********************/
function isAnyOptionIdentical(sOption1,sOption2,sOption3,sOption4)
{
 	if(sOption1==sOption2 ||sOption1==sOption3||sOption1==sOption4 )
 		return true;
 	else if(sOption2==sOption1||sOption2==sOption3||sOption2==sOption4 )
 		return true;
 	else if(sOption3==sOption1 ||sOption3==sOption2|| sOption3==sOption4)
 		return true;
 	else if(sOption4==sOption1||sOption4==sOption2||sOption4==sOption3)
 		return true;
 	return false;
}
function validateFormEntries(frm)
{
	var txtquestion=frm.txtquestion.value.trim();
	var txtoption1=frm.txtoption1.value.trim();
	var txtoption2=frm.txtoption2.value.trim();
	var txtoption3=frm.txtoption3.value.trim();
	var txtoption4=frm.txtoption4.value.trim();
    var drp_ans=frm.drp_ans.selectedIndex;
	    
   if( txtquestion.length==0 )
	{
	   document.getElementById('div_message_operations').innerHTML="Please enter question";
	   frm.txtquestion.focus();
	   return false;
	}
	else if(/\S/.test(txtquestion)==false)
	{

		 document.getElementById('div_message_operations').innerHTML="Please enter question";
		
		   frm.txtquestion.focus();
		   return false;
	}

	if( txtoption1.length==0 )
	{
		 document.getElementById('div_message_operations').innerHTML="Please enter choice 1";
	   frm.txtoption1.focus();
	   return false;
	}
	else if(/\S/.test(txtoption1)==false )
	{
		 document.getElementById('div_message_operations').innerHTML="Please enter choice 1";
		   frm.txtoption1.focus();
		   return false;
		}
	if(txtoption2.length==0 )
	{
		 document.getElementById('div_message_operations').innerHTML="Please enter choice 2";
	   frm.txtoption2.focus();
	   return false;
	}
	else if(/\S/.test(txtoption2)==false )
	{
		 document.getElementById('div_message_operations').innerHTML="Please enter choice 2";
		   frm.txtoption2.focus();
		   return false;
		}
	if( txtoption3.length==0 )
	{
		 document.getElementById('div_message_operations').innerHTML="Please enter choice 3";
	   frm.txtoption3.focus();
	   return false;
	}
	else if(/\S/.test(txtoption3)==false )
	{
		 document.getElementById('div_message_operations').innerHTML="Please enter choice 3";
		   frm.txtoption3.focus();
		   return false;
		}
	if( txtoption4.length==0 )
	{
		 document.getElementById('div_message_operations').innerHTML="Please enter choice 4";
	   frm.txtoption4.focus();
	   return false;
	}
	else if(/\S/.test(txtoption4)==false )
	{
		 document.getElementById('div_message_operations').innerHTML="Please enter choice 4";
		   frm.txtoption4.focus();
		   return false;
		}
	if(isAnyOptionIdentical(txtoption1,txtoption2,txtoption3,txtoption4))
	{	
		 document.getElementById('div_message_operations').innerHTML="Please use different choice values";
		frm.txtoption1.focus();
		return false;//if any option is identical return false to avoid submit
	}
   
	if( drp_ans==0 )
	{
		 document.getElementById('div_message_operations').innerHTML="Please select choice for answer";
	   frm.drp_ans.focus();
	   return false;
	}
	
	
	
	return true;
}
//////////////////////////////////// Mritunjay Sinha : Question Upload ////////////////////////////

function questionUpload() {
		 
	 var filePath = document.getElementById("txtUploadFile").value;
	 if(filePath.substring(filePath.lastIndexOf("."), parseInt(parseInt(filePath.length)+1))== ".xls")
		 {
		 return true;
		 }else
			 {
			document.getElementById("lblDisplayModuleMessage").innerHTML = "Please upload Excel file in .xls format only";
			setTimeout("document.getElementById('lblDisplayModuleMessage').innerHTML=\"\"", 4000);
			return false;
			 }	 
}



