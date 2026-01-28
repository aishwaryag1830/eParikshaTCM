/**
 * @author Prashant Bansod
 * @date 04-10-01
 * Simple script to deal with selection of reports
 */

function get_drp_selected_value_on_choice(sel_choice) //so that if 0 & 2 ie----- are selected put in textbox the answer
{
	var path1 = document.getElementById('drpReports');
	var choices = new Array;
	for (var i = 1; i < path1.options.length; i++)
		{
	    if (path1.options[sel_choice].selected)
	      choices[choices.length] = path1.options[sel_choice].value;  //.value
		}
	return choices[0];
}


function goSelectReports(frm,drp)
{
	
	if(drp.selectedIndex>0)//>0 for cross browsers
	{
		document.getElementById('txtRequestIdentifier').value=get_drp_selected_value_on_choice(drp.selectedIndex);
				
		if(document.getElementById('divReportFrameHolder')!=null)
			document.getElementById('divReportFrameHolder').style.display='block';
		
		 if(document.getElementById('divNoReportsSelected')!=null)
				document.getElementById('divNoReportsSelected').style.display='none';
		 
		 if(document.getElementById('div_messages_server')!=null)
				document.getElementById('div_messages_server').style.display='none';
			
		 frm.submit();
	}
	else if(drp.selectedIndex	==	0)
	{
		if(document.getElementById('divNoReportsSelected')!=null)
			document.getElementById('divNoReportsSelected').style.display='block';
		
		if(document.getElementById('divReportFrameHolder')!=null)
			document.getElementById('divReportFrameHolder').style.display='none';
		
	}	
	
}
	


