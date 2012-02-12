$(document).ready(function(){
	$("#strselectbutton").click(function(e){
		var strhost = window.location.host;
	    var strprotocol = window.location.protocol;
	    var strurl = strprotocol + "//" + strhost + "/messages/test_message"
		$.ajax({
			type: 'POST',
			//url: 'http://192.168.186.134:3000/messages/save_update',
			url: strurl,
			data: {},
			contentType: 'multipart/form-data',
			datatype: 'json',
			success:function(data)
			{
				//var data = data.replace(/&quot;/g,"\"");
				//var data = data.replace(/&quot;,/g,"',")
				//var dataObj=JSON.parse(data)
                //alert(dataObj.keyword);
                //$("#strkeyword").val(dataObj.keyword);
                //$("#str_filter_ori").val(dataObj.filterori);
			},
			error:function(xhr,r,e)
			{
				//alert(e)
			}
		});
	});
});