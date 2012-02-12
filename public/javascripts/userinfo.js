$(document).ready(function(){
	var txtyear = new Date().getFullYear();
	var txtmonth = parseInt(new Date().getMonth(),10)+1
	var txtday = new Date().getDate();
	//alert(parseInt(new Date().getMonth(),10)+1) 
    for(y = txtyear; y>=1900; y--)
	{
		$("#Date_Year").append("<option label='" + y + "' value='" + y + "'>" + y + "</option>");		
	};
	$("#Date_Year").prepend("<option value='0'>请选择</option>");
	for(m = 1; m<=12; m++)
	{
		m = "0"+m;
        m = m.substring(m.length-2) 
		$("#Date_Month").append("<option label='" + m + "' value='" + m + "'>" + m + "</option>")
	};
	$("#Date_Month").prepend("<option value='0'>请选择</option>");
	var maxday = 0;
	switch(txtmonth)
	{
		case(txtmonth=1):
		maxday = 31;
		break;
		case(txtmonth=2):
		if(txtyear%4==0)
	    {
	    	maxday = 29;	
	    }
	    else
	    {
	    	maxday = 28;
	    }
		break;
		case(txtmonth=3):
		maxday = 31;
		break;
		case(txtmonth=4):
		maxday = 30;
		break;
        case(txtmonth=5):
        maxday = 31;
		break;
		case(txtmonth=6):
		maxday = 30;
		break;
        case(txtmonth=7):
        maxday = 31;
		break;
        case(txtmonth=8):
        maxday = 31;
		break;
		case(txtmonth=9):
		maxday = 30;
		break;
        case(txtmonth=10):
        maxday = 31;
		break;
		case(txtmonth=11):
		maxday = 30;
		break;
        case(txtmonth=12):
        maxday = 31;
		break;
	};
	for(d=1; d<=maxday; d++)
	{
		d = "0"+d;
        d = d.substring(d.length-2)
		$("#Date_Day").append("<option label='" + d + "' value='" + d + "'>" + d + "</option>")
	};
	$("#Date_Day").prepend("<option value='0'>请选择</option>");
	txtmonth = "0"+txtmonth;
    txtmonth = txtmonth.substring(txtmonth.length-2)
	$("#Date_Month").val(txtmonth);
	txtday = "0"+txtday;
    txtday = txtday.substring(txtday.length-2)
	$("#Date_Day").val(txtday);
	var strhost = window.location.host;
	var strprotocol = window.location.protocol;
	var strurl = strprotocol + "//" + strhost + "/home/selected_display"
	var strcode = 0
	$.ajax({
		type: 'POST',
		url: strurl,
		data: {"type":"province"},
		contentType: 'multipart/form-data',
		datatype: 'json',
		success:function(data)
		{
			var data = data.replace(/&quot;/g,"\"");
			//var data = data.replace(/&quot;,/g,"',")
			var dataObj=JSON.parse(data)
            //alert(dataObj.keyword);
            
            for(p=0; p<dataObj.length; p++)
	        {
	        	$("#province").append("<option label='" + dataObj[p].Code + "' value='" + dataObj[p].Code + "'>" + dataObj[p].Name + "</option>")
	        };
            strcode=$("#province").val();
            if(selcity(strcode,""))
            {
            	
            }                 
		},
		error:function(xhr,r,e)
		{
			alert(e)
		}
	});
	$.ajax({
		type: 'POST',
		url: strurl,
		data: {"type":"userinfo"},
		contentType: 'multipart/form-data',
		datatype: 'json',
		success:function(data)
		{
			data = $.trim(data);//去除空格
			if(data == "null")
			{
				$("#nickname").val("");
                $("#txtuserid").val("");
                $("#realname").val("");
                $("#pub_name_option").val("0")
                $("#man").attr("checked", false);
                $("#woman").attr("checked", false);
                $("#pub_birthday_option").val("0");
                $("#blog").val("");
                $("#pub_blog").val("0");
                $("#email").val($("#useremail").html());
                $("#pub_email_option").val("0");
                $("#qq").val("");
                $("#pub_qq_option").val("0");
                $("#msn").val("");
                $("#pub_msn_option").val("0");
                $("#mydesc").val("");
			}
			else
			{
				var data = data.replace(/&quot;/g,"\"");
			    //var data = data.replace(/&quot;,/g,"',")
			    var dataObj=JSON.parse(data);
                $("#nickname").val(dataObj.nick_name);
                $("#txtuserid").val(dataObj.id);
                $("#realname").val(dataObj.real_name);
                $("#pub_name_option").val(dataObj.name_option);
                while($("#province").html() == null)
                {
                	
                }
                $("#province").val(dataObj.province);
                //alert(dataObj.city);
                if(dataObj.gender==1)
                {
                	$("#man").attr("checked", true);
                }
                else
                {
                	$("#woman").attr("checked", true);	
                }
                $("#pub_birthday_option").val(dataObj.birthday_option);
                $("#blog").val(dataObj.blog)
                $("#pub_blog").val(dataObj.blog_option);
                if(dataObj.email == null || dataObj.email == "")
                {
                	$("#favorite_email").html($("#useremail").html());
                }
                else
                {
                	$("#favorite_email").html(dataObj.email);
                }
                $("#pub_email_option").val(dataObj.email_option);
                $("#qq").val(dataObj.qq);
                $("#pub_qq_option").val(dataObj.qq_option);
                $("#msn").val(dataObj.msn);
                $("#pub_msn_option").val(dataObj.msn_option);
                $("#mydesc").val(dataObj.mydesc);
                $("#Date_Year").val(dataObj.Date_Year);
                datamonth = "0"+dataObj.Date_Month;
                datamonth = datamonth.substring(datamonth.length-2)
	            $("#Date_Month").val(datamonth);
	            datamonth = parseInt(datamonth,10);
	            datayear = dataObj.Date_Year;
	            numday(datayear,datamonth);
	            dataday = "0"+dataObj.Date_Day;
                dataday = dataday.substring(dataday.length-2)
	            $("#Date_Day").val(dataday);
	            //selcity(dataObj.province)
	            $("#city").empty();
	            if(selcity(dataObj.province,dataObj.city))
	            {
	            	while($("#city").html() == null)
	            	{
                	}
                	//alert("OK");
	            	//$("#city").val(dataObj.city);
	            }
           }
		},
		error:function(xhr,r,e)
		{
			alert(e)
		}
	});
	$("#submit").click(function(e){
		var strhost = window.location.host;
	    var strprotocol = window.location.protocol;
	    var strurl = strprotocol + "//" + strhost + "/home/save_update"
		$.ajax({
			type: 'POST',
			url: strurl,
			data: {
				"nickname":$("#nickname").val(),
                "realname":$("#realname").val(),
                "pub_name_option":$("#pub_name_option").val(),
                "province":$("#province").val(),
                "city":$("#city").val(),
                "gender":0,
                "Date_Year":$("#Date_Year").val(),
                "Date_Month":$("#Date_Month").val(),
                "Date_Day":$("#Date_Day").val(),
                "pub_birthday_option":$("#pub_birthday_option").val(),
                "blog":$("#blog").val(),
                "pub_blog":$("#pub_blog").val(),
                "favorite_email":"",
                "pub_email_option":$("#pub_email_option").val(),
                "qq":$("#qq").val(),
                "red_qq":$("#red_qq").val(),
                "msn":$("#msn").val(),
                "pub_msn_option":$("#pub_msn_option").val(),
                "mydesc":$("#mydesc").val()
			},
			contentType: 'multipart/form-data',
			datatype: 'json',
			success:function(data)
			{
				alert("ok")
			},
			error:function(xhr,r,e)
			{
				alert(e)
			}
		});
	});
	
	$('#Date_Month').change(function(){
		var chamonth = $("#Date_Month").val();
		var chayear = $("#Date_Year").val();
		chamonth = parseInt(chamonth,10);
		numday(chayear,chamonth)
	});
	
	$("#province").change(function(){
		var chaprovince = $("#province").val();
		$("#city").empty();
		selcity(chaprovince,"")		
	});
	
	function numday(stryear,strmonth)
	{
		var chaday = 0;
		switch(strmonth)
	    {
	    	case(strmonth=1):
	    	chaday = 31;
	    	break;
	    	case(strmonth=2):
	    	if(stryear%4==0)
	        {
	        	chaday = 29;	
	        }
	        else
	        {
	        	chaday = 28;
	        }
	    	break;
	    	case(strmonth=3):
	    	chaday = 31;
	    	break;
	    	case(strmonth=4):
	    	chaday = 30;
	    	break;
            case(strmonth=5):
            chaday = 31;
	    	break;
	    	case(strmonth=6):
	    	chaday = 30;
	    	break;
            case(strmonth=7):
            chaday = 31;
	    	break;
            case(strmonth=8):
            chaday = 31;
	    	break;
	    	case(strmonth=9):
	    	chaday = 30;
	    	break;
            case(strmonth=10):
            chaday = 31;
	    	break;
	    	case(strmonth=11):
	    	chaday = 30;
	    	break;
            case(strmonth=12):
            chaday = 31;
	    	break;
	    };
	    $("#Date_Day").empty();
	    for(d=1; d<=chaday; d++)
	    {
	    	d = "0"+d;
            d = d.substring(d.length-2)
	    	$("#Date_Day").append("<option label='" + d + "' value='" + d + "'>" + d + "</option>")
	    };
	    $("#Date_Day").prepend("<option value='0'>请选择</option>");
	};
	
	function selcity(strcode,citycode)
	{
		$("#city").empty();
		$.ajax({
	    	type: 'POST',
	    	url: strurl,
	    	data: {"type":"city","code":strcode},
	    	contentType: 'multipart/form-data',
	    	datatype: 'json',
	    	success:function(data)
	    	{
	    		var data = data.replace(/&quot;/g,"\"");
	    		//var data = data.replace(/&quot;,/g,"',")
	    		var dataObj=JSON.parse(data)
                //alert(dataObj.keyword);
                
                for(p=0; p<dataObj.length; p++)
	            {
	            	$("#city").append("<option label='" + dataObj[p].Code + "' value='" + dataObj[p].Code + "'>" + dataObj[p].Name + "</option>")
	            };
	            $("#city").val(citycode);
	            //$("#city").val("");
	    	},
	    	error:function(xhr,r,e)
	    	{
	    		alert(e);
	    	}
	    });
	    
	    return true;
	}
});