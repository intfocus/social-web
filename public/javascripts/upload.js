(function($){$.clock={version:"2.0.1",locale:{}};t=[];$.fn.clock=function(d){var c={it:{weekdays:["Domenica","Lunedì","Martedì","Mercoledì","Giovedì","Venerdì","Sabato"],months:["Gennaio","Febbraio","Marzo","Aprile","Maggio","Giugno","Luglio","Agosto","Settembre","Ottobre","Novembre","Dicembre"]},en:{weekdays:["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"],months:["January","February","March","April","May","June","July","August","September","October","November","December"]},es:{weekdays:["Domingo","Lunes","Martes","Miércoles","Jueves","Viernes","Sábado"],months:["Enero","Febrero","Marzo","Abril","May","junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"]},de:{weekdays:["Sonntag","Montag","Dienstag","Mittwoch","Donnerstag","Freitag","Samstag"],months:["Januar","Februar","M?rz","April","k?nnte","Juni","Juli","August","September","Oktober","November","Dezember"]},fr:{weekdays:["Dimanche","Lundi","Mardi","Mercredi","Jeudi","Vendredi","Samedi"],months:["Janvier","Février","Mars","Avril","May","Juin","Juillet","Ao?t","Septembre","Octobre","Novembre","Décembre"]},ru:{weekdays:["???????????","???????????","???????","?????","???????","???????","???????"],months:["??????","???????","????","??????","???","????","????","??????","????????","???????","??????","???????"]}};return this.each(function(){$.extend(c,$.clock.locale);d=d||{};d.timestamp=d.timestamp||"z";y=new Date().getTime();d.sysdiff=0;if(d.timestamp!="z"){d.sysdiff=d.timestamp-y}d.langSet=d.langSet||"en";d.format=d.format||((d.langSet!="en")?"24":"12");d.calendar=d.calendar||"true";if(!$(this).hasClass("jqclock")){$(this).addClass("jqclock");}var e=function(g){if(g<10){g="0"+g}return g;},f=function(j,n){var r=$(j).attr("id");if(n=="destroy"){clearTimeout(t[r]);}else{m=new Date(new Date().getTime()+n.sysdiff);var p=m.getHours(),l=m.getMinutes(),v=m.getSeconds(),u=m.getDay(),i=m.getDate(),k=m.getMonth(),q=m.getFullYear(),o="",z="",w=n.langSet;if(n.format=="12"){o=" AM";if(p>11){o=" PM"}if(p>12){p=p-12}if(p===0){p=12}}p=e(p);l=e(l);v=e(v);if(n.calendar!="false"){z=((w=="en")?"<span class='clockdate'>"+c[w].weekdays[u]+", "+c[w].months[k]+" "+i+", "+q+"</span>":"<span class='clockdate'>"+c[w].weekdays[u]+", "+i+" "+c[w].months[k]+" "+q+"</span>");}$(j).html(z+"<span class='clocktime'>"+p+":"+l+":"+v+o+"</span>");t[r]=setTimeout(function(){f($(j),n)},1000);}};f($(this),d);});};return this;})(jQuery);
$(document).ready(function(){
  $("#clock4").clock({"format":"24","calendar":"false"});
  $("#uploadmess").keypress(function(e){
    if(e.keyCode==13){
      var clock = $("#txtclock").val();
  	  //var myDate = new Date(new Date().getTime()+1000*60*parseInt(clock));
	  var txtmessage = $("#uploadmess").val();
	  var imgfile = $("#imagefile").html();
	  var send_state = $("#send_state").val();
	  var txtimage = "";
	  var txtmonitor = 0;
	  if($("#txtmonitor").attr("checked"))
	  {
	  	txtmonitor = 1;
	  }
	  else
	  {
	  	txtmonitor = 0;
	  }
	  var strhost = window.location.host;
	  var strprotocol = window.location.protocol;
	  var strurl = strprotocol + "//" + strhost + "/messages/save_update"
	  $.ajax({
			type: 'POST',
			//url: 'http://192.168.186.134:3000/messages/save_update',
			url: strurl,
			data: {
				"strmes":txtmessage,
				"strimg":imgfile,
				"strupt":"",
				"clock":clock,
				"send_state":send_state,
				"strtype":"savemessage",
				"strmonitor":txtmonitor 
			},
			contentType: 'multipart/form-data',
			datatype: 'json',
			success:function(data)
			{
				//alert(data);
				location.reload();
			},
			error:function(xhr,r,e)
			{
				//alert(e)
			}
		});
	  //alert("文字个数" + txtmessage.length);  
      e.preventDefault();//屏蔽enter对系统作用。按后增加\r\n等换行
      $("#uploadmess").attr("value",''); //清空
      //$("#te").attr("value",'11'); //填充内容
	  //var str1 = "<div><ul><li><input type='checkbox' name='checkbox' checked='true' id='123'></li><li>";
	  //str1 += "<div class='feed-content' id='eventReply' rel='pl:'><p class='feed-main'>"
	  //txtmessage = txtmessage.replace(/\[@/g, '<img src=/images/');
	  //txtmessage = txtmessage.replace(/\@]/g, '.gif />');
	  //str1 += txtmessage;
	  //str1 += "</p></div></li>";
	  //if(imgfile != "")
	  //{
	  //	str1 += "<li><div>"
		//str1 += "<img width='50' height='50' src='/"+ imgfile + "' />";
		//str1 += "</div></li>"
	  //}
	  //str1 += "<li><div>"
	  //var _mozi=['上午发送','下午发送','晚上发送','客户定义发送','不发送'];
	  //str1 += "<select id='selectTest' name='selectTest'>";
	  //$.each(_mozi,function(key,val){
	  //	if(key == "1")
	  //	{
	  //		str1 += "<option selected = 'true' value='" + key + "'>" + val + "</option>";
	  //	}
	  //	else
	  //	{
	  //		str1 += "<option value='" + key + "'>" + val + "</option>";
	  //	}
      //});
      //str1 += "</select>"
      //str1 += "</div></li><li><div>"
      //alert(myDate.toLocaleString());
      //str1 += "<p>" + myDate.toLocaleString(); + "</p>"
      //str1 += "</div></li>"
	  //str1 += "</ul></div>";
	  //
      //$("#txtmessage").html($("#txtmessage").html() + str1);
    }
  });
  $("#uploadmess").FormFace({ cid : "#txtmessage", btn : "" , left : "30" , top : "1" });
  $("#cb_all").click(function(){
		if($(this).attr("checked"))
		{
			$("[name='checkbox']").attr("checked",'true');//全选
		}
		else
		{
			$("[name='checkbox']").removeAttr("checked");//取消全选
		}
        
    });
  $("#btn5").click(function(){
    var str="";
    $("[name='checkbox']").each(function(){
	  if($(this).attr("checked"))
	  {
        str+=$(this).val()+",";
	  }
    });
    str = str.substring(0,str.length-1)
    //alert(str);
    var strhost = window.location.host;
	var strprotocol = window.location.protocol;
	var strurl = strprotocol + "//" + strhost + "/messages/save_update"
    $.ajax({
			type: 'POST',
			//url: 'http://192.168.186.134:3000/messages/save_update',
			url: strurl,
			data: {"strid":str,"strtype":"deletemessage"},
			success:function(data)
			{
				//alert(data);
				location.reload();
			},
			error:function(xhr,r,e)
			{
				//alert(e)
			}
		});
  });
}); 