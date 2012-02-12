(function($){$.clock={version:"2.0.1",locale:{}};t=[];$.fn.clock=function(d){var c={it:{weekdays:["Domenica","Lunedì","Martedì","Mercoledì","Giovedì","Venerdì","Sabato"],months:["Gennaio","Febbraio","Marzo","Aprile","Maggio","Giugno","Luglio","Agosto","Settembre","Ottobre","Novembre","Dicembre"]},en:{weekdays:["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"],months:["January","February","March","April","May","June","July","August","September","October","November","December"]},es:{weekdays:["Domingo","Lunes","Martes","Miércoles","Jueves","Viernes","Sábado"],months:["Enero","Febrero","Marzo","Abril","May","junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"]},de:{weekdays:["Sonntag","Montag","Dienstag","Mittwoch","Donnerstag","Freitag","Samstag"],months:["Januar","Februar","M?rz","April","k?nnte","Juni","Juli","August","September","Oktober","November","Dezember"]},fr:{weekdays:["Dimanche","Lundi","Mardi","Mercredi","Jeudi","Vendredi","Samedi"],months:["Janvier","Février","Mars","Avril","May","Juin","Juillet","Ao?t","Septembre","Octobre","Novembre","Décembre"]},ru:{weekdays:["???????????","???????????","???????","?????","???????","???????","???????"],months:["??????","???????","????","??????","???","????","????","??????","????????","???????","??????","???????"]}};return this.each(function(){$.extend(c,$.clock.locale);d=d||{};d.timestamp=d.timestamp||"z";y=new Date().getTime();d.sysdiff=0;if(d.timestamp!="z"){d.sysdiff=d.timestamp-y}d.langSet=d.langSet||"en";d.format=d.format||((d.langSet!="en")?"24":"12");d.calendar=d.calendar||"true";if(!$(this).hasClass("jqclock")){$(this).addClass("jqclock");}var e=function(g){if(g<10){g="0"+g}return g;},f=function(j,n){var r=$(j).attr("id");if(n=="destroy"){clearTimeout(t[r]);}else{m=new Date(new Date().getTime()+n.sysdiff);var p=m.getHours(),l=m.getMinutes(),v=m.getSeconds(),u=m.getDay(),i=m.getDate(),k=m.getMonth(),q=m.getFullYear(),o="",z="",w=n.langSet;if(n.format=="12"){o=" AM";if(p>11){o=" PM"}if(p>12){p=p-12}if(p===0){p=12}}p=e(p);l=e(l);v=e(v);if(n.calendar!="false"){z=((w=="en")?"<span class='clockdate'>"+c[w].weekdays[u]+", "+c[w].months[k]+" "+i+", "+q+"</span>":"<span class='clockdate'>"+c[w].weekdays[u]+", "+i+" "+c[w].months[k]+" "+q+"</span>");}$(j).html(z+"<span class='clocktime'>"+p+":"+l+":"+v+o+"</span>");t[r]=setTimeout(function(){f($(j),n)},1000);}};f($(this),d);});};return this;})(jQuery);
$(document).ready(function(){
	$("#updatemessage").FormFace({ cid : "#txtmessage", btn : "" , left : "30" , top : "1" });
	$("#clock4").clock({"format":"24","calendar":"false"});
	$("#send_state").change(function(){
		var num = $("#send_state").val();
		if(num == 2)
		{
			$("#dDeltxt").css("display",'block')//显示表格
		}
		else
		{
			$("#dDeltxt").css('display','none');//隐藏表格
		}
	});
	$("#save_update").click(function(){
		var strnum = $("#txtid").val();
		var txtmessage = $("#updatemessage").val();
		var imgf = $("#txtimgf").attr("src");
		if(imgf == undefined)
		{
			imgf = "";	
		}
		var txtmonitor = 0;
	    if($("#txtmonitor").attr("checked"))
	    {
	    	txtmonitor = 1;
	    }
	    else
	    {
	    	txtmonitor = 0;
	    }
		var txtsendstate= $("#send_state").val();
		var clock = $("#txtclock").val();
		var strhost = window.location.host;
	    var strprotocol = window.location.protocol;
	    var strurl = strprotocol + "//" + strhost + "/messages/save_update"
        $.ajax({
        	type: 'POST',
	    	url: strurl,
	    	data: {
	    		"strid":strnum,
	    		"strmessage":txtmessage,
	    		"strimg":imgf,
	    		"send_state":txtsendstate,
	    		"clock":clock,
	    		"strtype":"updatemessage",
	    		"strmonitor":txtmonitor 
	    	},
	    	success:function(data)
	    	{
	    		//alert(data);
	    		//刷新父窗口
	    		window.opener.location.reload();
	    		//关闭窗口
	    		window.close()
	    		//location.reload();
	    	},
	    	error:function(xhr,r,e)
	    	{
	    		alert(e)
	    	}
	    });
	});
});