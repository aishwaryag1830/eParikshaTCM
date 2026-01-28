/**
 * @author Sherin Mathew
 * @date 24/05/2012
 * @description This javascript calls the AJAX on the page to display the result
 * of the selected module and selected date 
 * */	
		

function goSelectModule(str,strUserRole)
		{
					//Creating the AJAX code
					
					if(document.getElementById('selectModule').selectedIndex>0){
						
						var xmlDoc;
						if (window.XMLHttpRequest)
						{// code for IE7+, Firefox, Chrome, Opera, Safari
							xmlhttp=new XMLHttpRequest();
						}
						else if (window.ActiveXObject) 
						{ 
							try { 
								xmlhttp = new ActiveXObject("Msxml2.XMLHTTP"); 
							} 
							catch (e)
							{ 
								try{ 
									xmlhttp = new ActiveXObject("Microsoft.XMLHTTP"); 
									}	 
									catch (e){} 
							} 
						} 
					
					
						xmlhttp.open("POST","AddDatesAjax",true);
						var parameters	=	"strModuleId="+str+"&iFlag="+2+"&strUserRole="+strUserRole;
						xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
						xmlhttp.setRequestHeader("Content-length", parameters.length);
						xmlhttp.setRequestHeader("Connection", "close");
						xmlhttp.send(parameters);	
						
						xmlhttp.onreadystatechange = function() { 
						
							if (xmlhttp.readyState == 4 && xmlhttp.status==200)
							{ // readyState, see below 
								
								responseHandler(xmlhttp);
							} 
							else{
								document.getElementById("divInitialMessage").innerHTML='<img alt="" src="images/ajaxLoader.gif"><br/>Loading...';
								document.getElementById('divInitialMessage').style.display='block';
								document.getElementById('divResultDisplay').style.display='none';
							}
								
							
							}
						}
					
		
		
	
					else
					{
						
						document.getElementById('divInitialMessage').style.display='block';
						document.getElementById('divResultDisplay').style.display='none';
												
						document.getElementById("divInitialMessage").innerHTML		=	'Please select module';
						document.getElementById('selectExamDate').options.length 	= 	1;
						document.getElementById('selectModule').selectedIndex		=	0;
					}
			
	
		
		
					function responseHandler(xmlHttp)
					{
						var j,k;
						xmlDoc	=	xmlHttp.responseXML;
						var valuesexamdates=xmlDoc.getElementsByTagName("examdates")[0];
						var exam=valuesexamdates.getElementsByTagName("examdate");
						var examdatesValue;
						var dateName;
						var examlength;
						document.getElementById('selectExamDate').options.length = 1;
						
						for(j=0;j<exam.length;j++){
							examlength=exam[j].getElementsByTagName('date').length;
				
							for(k=0;k<examlength;k++){
								examdatesValue=exam[j].getElementsByTagName('date')[k].childNodes[0].nodeValue;
							}
							document.getElementById('selectExamDate').options[j+1]=new Option(examdatesValue,examdatesValue+"");
						}
			
				
				
						document.getElementById('txtModuleName').value=document.getElementById('selectModule').options[document.getElementById('selectModule').selectedIndex].text;
						if(document.getElementById('selectExamDate').options.length>1){
							document.getElementById("divInitialMessage").innerHTML='Please select date';
						}
					}
		}

		
		