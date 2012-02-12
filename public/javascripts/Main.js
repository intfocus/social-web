/**
** @ jQuery Plug For :  FormFace Ver2.0
** @ Author :   Maco . Q : 9584290
** @ Mail :       Marcho@vip.qq.com
** @ Date :      2011.06.17
**/
$.fn.FormFace = function(o){
		var d = { cid : "", btn : "" , left : "50" , top : "1" };	
		var o = $.extend(d, o);
		var A = $(this);
		var Num = 39 ; //图片数量
		var Url = "../images/"
		var T;
		var L;
		
		if($(o.cid).size()<=0){
			//alert("FormFace插件提醒：未找到 "+o.cid);
			return false;
		};
		
		//替换符号为图片
		var Replace = function(){
			Code = $(o.cid).html();
			Code = Code.replace(/\[@/g, "<img src=" + Url + "");
			Code = Code.replace(/\@]/g, ".gif />");
			$(o.cid).html(Code);
		};
		
		//控制按钮器位置
		var tiPos = function(){
			T = A.offset().top;
			L = A.offset().left;
			$("#faceTitle").css("top", parseInt(T) - 22 + "px");  //按钮位置根据实际情况调整
			$("#faceTitle").css("left", parseInt(L) +parseInt(o.left) + "px");
		}
		
		Replace();
		
		//添加图标按钮及样式、控制图标按钮位置
		$("body").append("<style> #faceTitle{height:22px; width:36px; position:absolute; background:url(" + Url + "first.gif) no-repeat center center #fff;border:1px solid #aaa;border-bottom:none;'}</style><div id='faceTitle' style='cursor:pointer'></div>")
		tiPos();
		//窗口改变时自动调整位置
		$(window).resize(function(){
			tiPos();
			Pos();
		});

		//点击图标按钮
		$("#faceTitle").click(function(event){
			Con();
			Pos();
			event.stopPropagation();
			$("html").click(function(){
				$("#faceContent").hide();
			});
		});
		
		//将容器、表情插入页面
		var Con = function(){
			if($("#faceContent").size()>0){$("#faceContent").toggle(); return false; }; //阻止再次点击重复添加
			var cArr = [];
			var iArr = [];
			for (var i = 1; i <= Num; i++) {
				iArr[iArr.length] = "<a href='javascript:'><img src=" + Url + "F_"+i+".gif fn=[@F_" + i + "@] /></a>"
			};
			cArr[cArr.length] ="<style>#faceContent{width:364px; position:absolute;border:1px solid #aaa;border-top:none;z-index:9999; text-align:center;padding:3px;padding-bottom:6px;background:#fff;} #faceContent a img{float:left;cursor:pointer;margin:1px 1px; border:#cacaca 1px solid}  #faceContent a:hover img{border:1px solid #f51d69} </style>"
			cArr[cArr.length] = "<div id='faceContent'>"+iArr.join("")+"</div>";
			$("body").append(cArr.join(""));
			Click();
		};
		
		//控制弹出的表情容器位置
		var Pos = function(){
			T = A.offset().top;
			L = A.offset().left;
			$("#faceContent").css("top", parseInt(T)+parseInt(o.top) + "px");
			$("#faceContent").css("left", parseInt(L) +parseInt(o.left) + "px");
		};
		
		//表情点击
		var Click=function(){
			$("#faceContent img").click(function(){
				var V=A.val();
				A.val(V+$(this).attr("fn"));
			});
		};
		
		//Btn点击 --- 这里预留，配合程序自行修改
			$(o.btn).click(function(){
				if(A.val()==""){
					//alert("输入框不能为空")
					A.focus();
					return false;
				};
				//这里可以写ajax功能将数据传递至后台，后判断是否成功，进行下面内容				
				$(o.cid).append("<p>"+A.val()+"</p>");
				A.val("");
				Replace();
				
				var N=A.offset().top; 
				$("#faceTitle").css("top", parseInt(N) - 22 + "px");
			});

}