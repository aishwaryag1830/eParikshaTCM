function DownloadSheet() 
{
	
	 //make the AJAX request, dataType is set to json
	 //meaning we are expecting JSON data in response from the server
	 $.ajax({
	     type: "POST",
	     url: "RandomPassword",
	     data: {id:'download'},
	     dataType: 'text',
	     
	     //if received a response from the server
	     success: function(data) {
	    	 var obj = eval ("("+data+")");
	    	 var root = location.href;
	    	   	 
	    	 var last=root.lastIndexOf("/");
	    	
	    	 root=root.substring(0,last);
	    	 
	    
	    	 window.open(root+'/'+obj.filepath);   
	    	 
	    	 
	    	 
	     },
	     
	     //If there was no resonse from the server
	     error: function(jqXHR, textStatus, errorThrown){},
	     
	     //capture the request before it was sent to server
	     beforeSend: function(jqXHR, settings){
	     	
	     },
	     
	     //this is called after the response or error functions are finsihed
	     //so that we can take some action
	     complete: function(jqXHR, textStatus){
	     	
	     	
	     }
	 
	 });        
  

}


function setPasswordToDefault()
{
	
 console.log("1");
	/*$(document).ready(function() {
	    $('#defaultbutton').click(function() {*/
	        $.ajax({
	        		
	        		url : "SetToDefault",
	        		type: "post",
	        		success: function(data){
	        			 ShowStudentInfo();
	        			 document.getElementById("labelMessage").innerHTML = "Passwords are changed successfully.Please  download file";
						//alert(data);					
					},
	        		error: function(data){
						alert(data);	
	        		}
	        });
	/*    });
	});*/

}


function genearatePassword(no)
{

	

	
	var r=confirm("This operation will generate random passwords for all students");
	if (r==false)
	  {
	  
	  }
	else
	  {
	 

	
	
	var dataString=no;
	
	
 
 //make the AJAX request, dataType is set to json
 //meaning we are expecting JSON data in response from the server
 $.ajax({
     type: "POST",
     url: "RandomPassword",
     data: {id:dataString},
     dataType: 'text',
     
     //if received a response from the server
     success: function(data) {
    	 /*
    	  * check the response send
    	  * by servlet ScheduleExam.jav
    	  * if(true)then 
    	  * 	allow to schedule the exam
    	  * else
    	  * 	deny
    	  * 
    	  * 
    	  * */
    	
    	
    	 var obj = eval ("(" + data + ")");
    	 
    	 
    	 if(obj.status==true){
    
    		 
    	 document.getElementById("labelMessage").innerHTML = "Passwords are changed successfully.Please  download file";
    			 
    	 
    	
    	 var root = location.href;
    	   	 
    	 var last=root.lastIndexOf("/");
    	
    	 root=root.substring(0,last);
    	 
    	
    	 window.open(root+'/'+obj.filepath); 
    	 
    	// window.location.reload(true);
    	 }
    	 else
    		 {
    		 $('#msgPass').html("Something went wrong.Please try again");
    		 }
    	// setTimeout(function(){ $('#msgPass').html("");},5000);
     },
     
     //If there was no resonse from the server
     error: function(jqXHR, textStatus, errorThrown){},
     
     //capture the request before it was sent to server
     beforeSend: function(jqXHR, settings){
     	
     },
     
     //this is called after the response or error functions are finsihed
     //so that we can take some action
     complete: function(jqXHR, textStatus){
     	
    	 ShowStudentInfo();
     }
 
 });        

}
}