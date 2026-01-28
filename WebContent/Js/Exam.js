	function endModuleExam(id)
	{
		
		if(confirm('Do you really want to end exam ?'))
		{
			var frm=document.frmExam;
			frm.txtQNumber.value="end";
			frm.action="ExamSaveAnswer";
			frm.method="post";
			id.style.display = 'none' ;
			document.getElementById("endLoader").style.display = 'inline';
			frm.submit();
			return true;
		}
		return false;
	}
	
	function clickLink(linkID)
	{
		var frm=document.frmExam;
		frm.txtQNumber.value='';
		frm.txtQNumber.value=linkID;
		frm.action="ExamPage.jsp#Q";
		frm.method="post";
		frm.submit();
	}
	
	function submiAnswer()
	{
		var opt,frm;
		frm=document.frmExam;
		opt=frm.optRad;
		if(opt[0].checked==true || opt[1].checked==true || opt[2].checked==true || opt[3].checked==true)
		{
			frm.txtQNumber.value='';
			frm.action="ExamSaveAnswer";
			frm.method="post";
			frm.submit();
		}
		
		
	}