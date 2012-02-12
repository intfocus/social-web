$(document).ready(function(){
	$("#butsend").click(function(e){
		var txtwbid = $("#wbid").val();
		var txtrepost = $("#txtrepost").val();
		var txttype = $("#typetxt").val();
		var strhost = window.location.host;
	    var strprotocol = window.location.protocol;
	    var strurl = strprotocol + "//" + strhost + "/messages/repost_message"
		alert(txttype);
		$.ajax({
			type: 'POST',
			    url: strurl,
			    data: {"wbid":txtwbid,"repost":txtrepost,"type":txttype },
			    contentType: 'multipart/form-data',
			    datatype: 'json',
			    success:function(data)
			    {
			    	alert(data);
			    },
			    error:function(xhr,r,e)
			    {
			    	alert(e)
			    }
		    });
	});
});