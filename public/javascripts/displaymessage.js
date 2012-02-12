$(document).ready(function(){
	$("#btnmonitor").click(function(e){
		var strtrue="";
		var strfalse="";
        $("[name='checkbox']").each(function(){
	      if($(this).attr("checked"))
	      {
            //strtrue+=$(this).val()+",";
            updatemonitor($(this).val(),1);
	      }
	      else
	      {
	      	updatemonitor($(this).val(),0);
	      }
        });
        //strtrue = strtrue.substring(0,strtrue.length-1)
		//updatemonitor(strtrue);
		//$("[name='checkbox']").each(function(){
	    //  if(!$(this).attr("checked"))
	    //  {
        //    strfalse+=$(this).val()+",";
	    //  }
        //});
        //strfalse = strfalse.substring(0,strfalse.length-1)
		//updatemonitor(strfalse);
		
		function updatemonitor(wbid,num)
		{
			var strhost = window.location.host;
	        var strprotocol = window.location.protocol;
	        var strurl = strprotocol + "//" + strhost + "/messages/save_update"
			$.ajax({
			type: 'POST',
			    url: strurl,
			    data: {"wbid":wbid,"strtype":"monitor","strnum":num },
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
		}
	});
});