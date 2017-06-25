var tb_pathToImage = "../images/loading/loadingAnimation.gif";
$(document).ready(function(){   
	imgLoader = new Image();// preload image
	imgLoader.src = tb_pathToImage;
});

function form_load(obj){
	var div = $(obj);
	var position = div.position();
	var left = position.left;
	var top = position.top;
	
	var w = div.outerWidth();
	var h = div.outerHeight();
	
	if(document.getElementById("form_overlay") === null){
		$("body").append("<div id='form_overlay'></div><div id='form_window'></div>");
	}
	$('#form_overlay').css({top:top,left:left,width:w,height:h});
	
	if(tb_detectMacXFF()){
		$("#form_overlay").addClass("form_overlayMacFFBGHack");//use png overlay so hide flash
	}else{
		$("#form_overlay").addClass("form_overlayBG");//use background and opacity
	}
	var caption = "Loading...";
	if(caption===null){caption="";}
	$("body").append("<div id='form_load'><img src='"+imgLoader.src+"' /></div>");//add loader to the page
	
	$('#form_load').css({top:top+(parseInt(h)/2),left:left+((parseInt(w)/2)-104)});
	$('#form_load').show();//show loader
}

function form_remove(){
	$("#form_imageOff").unbind("click");
	$("#form_closeWindowButton").unbind("click");
	$("#form_window").fadeOut("fast",function(){$('#form_window,#form_overlay,#form_HideSelect').trigger("unload").unbind().remove();});
	$("#form_load").remove();
	if (typeof document.body.style.maxHeight == "undefined") {//if IE 6
		$("body","html").css({height: "auto", width: "auto"});
		$("html").css("overflow","");
	}
	document.onkeydown = "";
	document.onkeyup = "";
	return false;
}

function ajax_load(){
	if (typeof document.body.style.maxHeight === "undefined") {//if IE 6
		$("body","html").css({height: "100%", width: "100%"});
		$("html").css("overflow","hidden");
		if (document.getElementById("Ajax_HideSelect") === null) {//iframe to hide select elements in ie6
			$("body").append("<iframe id='Ajax_HideSelect'></iframe><div id='Ajax_overlay'></div><div id='Ajax_window'></div>");
		}
	}else{//all others
		if(document.getElementById("Ajax_overlay") === null){
			$("body").append("<div id='Ajax_overlay'></div><div id='Ajax_window'></div>");
		}
	}
	
	if(tb_detectMacXFF()){
		$("#Ajax_overlay").addClass("Ajax_overlayMacFFBGHack");//use png overlay so hide flash
	}else{
		$("#Ajax_overlay").addClass("Ajax_overlayBG");//use background and opacity
	}
	var caption = "Loading...";
	if(caption===null){caption="";}
	$("body").append("<div id='Ajax_load'><img src='"+imgLoader.src+"' /></div>");//add loader to the page
	$('#Ajax_load').show();//show loader
}

function ajax_remove() {
 	$("#Ajax_imageOff").unbind("click");
	$("#Ajax_closeWindowButton").unbind("click");
	$("#Ajax_window").fadeOut("fast",function(){$('#Ajax_window,#Ajax_overlay,#Ajax_HideSelect').trigger("unload").unbind().remove();});
	$("#Ajax_load").remove();
	if (typeof document.body.style.maxHeight == "undefined") {//if IE 6
		$("body","html").css({height: "auto", width: "auto"});
		$("html").css("overflow","");
	}
	document.onkeydown = "";
	document.onkeyup = "";
	return false;
}


function tb_load(){
	if (typeof document.body.style.maxHeight === "undefined") {//if IE 6
		$("body","html").css({height: "100%", width: "100%"});
		$("html").css("overflow","hidden");
		if (document.getElementById("TB_HideSelect") === null) {//iframe to hide select elements in ie6
			$("body").append("<iframe id='TB_HideSelect'></iframe><div id='TB_overlay'></div><div id='TB_window'></div>");
		}
	}else{//all others
		if(document.getElementById("TB_overlay") === null){
			$("body").append("<div id='TB_overlay'></div><div id='TB_window'></div>");
		}
	}
	
	if(tb_detectMacXFF()){
		$("#TB_overlay").addClass("TB_overlayMacFFBGHack");//use png overlay so hide flash
	}else{
		$("#TB_overlay").addClass("TB_overlayBG");//use background and opacity
	}
	var caption = "Loading...";
	if(caption===null){caption="";}
	$("body").append("<div id='TB_load'><img src='"+imgLoader.src+"' /></div>");//add loader to the page
	$('#TB_load').show();//show loader
}

function tb_remove() {
 	$("#TB_imageOff").unbind("click");
	$("#TB_closeWindowButton").unbind("click");
	$("#TB_window").fadeOut("fast",function(){$('#TB_window,#TB_overlay,#TB_HideSelect').trigger("unload").unbind().remove();});
	$("#TB_load").remove();
	if (typeof document.body.style.maxHeight == "undefined") {//if IE 6
		$("body","html").css({height: "auto", width: "auto"});
		$("html").css("overflow","");
	}
	document.onkeydown = "";
	document.onkeyup = "";
	return false;
}

function tb_detectMacXFF() {
	var userAgent = navigator.userAgent.toLowerCase();
	if (userAgent.indexOf('mac') != -1 && userAgent.indexOf('firefox')!=-1) {
		return true;
	}
}
	