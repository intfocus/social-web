$(document).ready(function(){
	$("#strsave").click(function(e){
		var txttype = "userrule";
		var txtruleid = $("#strruleid").val();
	    var txtrulename = $("#strrulename").val();
	    var txtkeyword = $("#strkeyword").val();
	    var txtusername = $("#strusername").val();
	    var txtfilterori = $("#str_filter_ori").val();
		var strhost = window.location.host;
	    var strprotocol = window.location.protocol;
	    var strurl = strprotocol + "//" + strhost + "/messages/save_update"
		$.ajax({
			type: 'POST',
			//url: 'http://192.168.186.134:3000/messages/save_update',
			url: strurl,
			data: {"strtype":txttype,"strruleid":txtruleid,"strrulename":txtrulename,"strkeyword":txtkeyword,"strusername":txtusername,"filterori":txtfilterori},
			contentType: 'multipart/form-data',
			datatype: 'json',
			success:function(data)
			{
				//alert(data);
			},
			error:function(xhr,r,e)
			{
				//alert(e)
			}
		});
	});
	$("#txtruleadd").click(function(){
		var txttype = "userrule";
		var txtrulename = $("#txtrulename").val();
		var txtruleid = ""
		var strhost = window.location.host;
	    var strprotocol = window.location.protocol;
	    var strurl = strprotocol + "//" + strhost + "/messages/save_update"
		$.ajax({
			type: 'POST',
			url: strurl,
			data: {"strtype":txttype,"strruleid":txtruleid,"strrulename":txtrulename},
			contentType: 'multipart/form-data',
			datatype: 'json',
			success:function(data)
			{
				alert(data);
				var data = data.replace(/&quot;/g,"\"");
			    //var data = data.replace(/&quot;,/g,"',")
			    var dataObj=JSON.parse(data)
                //alert(dataObj.keyword);
	            alert(data);
	            $("#ruleselect").prepend("<li>规则名：</li><li>" + dataObj.rulename + "</li><li><a href='/messages/userrule_message?id=" + dataObj.id + "'>查看\修改</a></li>");
			},
			error:function(xhr,r,e)
			{
				alert("error");
				//alert(e)
			}
		});
	});
	$("#strclose").click(function(){
		$("#strruleid").val("");
		$("#strrulename").val("");
		$("#strkeyword").val("");
		$("#strusername").val("");
		$("#str_filter_ori").val(0);
		$("#strdiv").css('display','none');//隐藏表格
	});
});