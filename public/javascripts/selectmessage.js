$(document).ready(function(){
	$('input:text:first').focus();
	$("#str_sel_mes").bind('keydown',function(e){
		if(e.keyCode==13){
			
			var txtq = $("#str_sel_mes").val();
	        var filterori = $("#str_filter_ori").val();
	        var filterpic = $("#str_filter_pic").val();
			var strhost = window.location.host;
	        var strprotocol = window.location.protocol;
	        var strurl = strprotocol + "//" + strhost + "/messages/display_message"
			$.ajax({
				type: 'POST',
			    //url: 'http://192.168.186.134:3000/messages/save_update',
			    url: strurl,
			    data: {"strq":txtq,"strfilterori":filterori,"strfilterpic":filterpic },
			    contentType: 'multipart/form-data',
			    datatype: 'json',
			    success:function(data)
			    {
			    	//alert(data);
			    	$("#sel_mes").html(data);
			    },
			    error:function(xhr,r,e)
			    {
			    	//alert(e)
			    }
		    });
		}
	});
});