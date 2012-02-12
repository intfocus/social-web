$(document).ready(function(){
	$("#upload_img").click(function(){
	  $("#img").click(); 
	});
	
	$("#img").change(function(){
	  $("#uploadsubmit").submit();
	});
})