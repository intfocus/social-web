$(document).ready(function(){
	$("#bid").click(function(){
		strimg = $("#uploadImg");
		$.ajax({
			type: 'POST',
			url: 'http://127.0.0.1:3000/weibosw/upload',
			data: {"img":strimg },
			contentType: 'multipart/form-data',
			success:function(reqContent)
			{
				//alert("ok")
			},
			error:function(xhr,r,e)
			{
				//alert(e)
			}
		});
		alert($("#uploadImg").val());
	});
});
