/**
* jQuery webcam
* Copyright (c) 2010, Wiriya Kosangsombat
* Date: 09/12/2010
*
* @author Wiriya Kosangsombat
* @version 1.0
*
* @see http://www.bitmapsolution.com
**/

(function ($) {
	var webcam = {
			width: 320,
			height: 240,
			
			btn_show: 'ถ่ายรูปใหม่',
			btn_snap: 'ถ่ายรูป',
			btn_config: 'ตั้งค่ากล้อง',
			div_img: 'div_img',
			
			ie: !!navigator.userAgent.match(/MSIE/),
			protocol: 'http',
			
			swf_url: '../js/webcam.swf',
			shutter_url: '../js/shutter.mp3',
			upload_url: '',
			redirect_url: '',
			
			loaded: false,
			quality: 100,
			shutter_sound: true,
			callback: null,
			stealth: false
	};
	
	window.webcam = webcam;
	
	$.fn.webcam = function(opts){
		if (typeof opts === "object") {
			for (var ndx in webcam) {
				if (typeof opts[ndx] !== "undefined") {
					webcam[ndx] = opts[ndx];
				}
			}
		}
		
		var html = '<div id="div_btn_show_webcam_" class="s400 center txt_center m_top5"><input type="button" id="btn_show_webcam_" class="btn_box" value="' + webcam.btn_show + '"></div><div id="div_webcam_" class="hide center">';
		var flashvars = 'shutter_enabled=' + (webcam.shutter_sound ? 1 : 0) + 
			'&shutter_url=' + escape(webcam.shutter_url) + 
			'&width=' + webcam.width + 
			'&height=' + webcam.height + 
			'&server_width=' + webcam.width + 
			'&server_height=' + webcam.height;
		
		if (webcam.ie) {
			html += '<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="'+webcam.protocol+'://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,0,0" width="'+webcam.width+'" height="'+webcam.height+'" id="webcam_movie" align="middle"><param name="allowScriptAccess" value="always" /><param name="allowFullScreen" value="false" /><param name="movie" value="'+webcam.swf_url+'" /><param name="loop" value="false" /><param name="menu" value="false" /><param name="quality" value="best" /><param name="bgcolor" value="#ffffff" /><param name="flashvars" value="'+flashvars+'"/></object>';
		}
		else {
			html += '<embed id="webcam_movie" src="'+webcam.swf_url+'" loop="false" menu="false" quality="best" bgcolor="#ffffff" width="'+webcam.width+'" height="'+webcam.height+'" name="webcam_movie" align="middle" allowScriptAccess="always" allowFullScreen="false" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" flashvars="'+flashvars+'" />';
		}
		html += '<div class="s400 center txt_center m_top5"><input type="button" id="webcam_snap" value="' + webcam.btn_snap + '" class="btn_box"><input type=button id="webcam_config" value="' + webcam.btn_config + '" class="btn_box m_left5"></div>';
		html += '</div>';
		
		this.append(html);
		
		$('#btn_show_webcam_').live('click', function(){
			$('#' + webcam.div_img).fadeOut(500);
			$('#div_btn_show_webcam_').fadeOut(500).queue(function(){$('#div_webcam_').show();$(this).dequeue();});
		});
		
		var cam = document.getElementById('webcam_movie');
		
		$('#webcam_snap').live('click', function(){
			cam._snap(webcam.upload_url,webcam.quality,webcam.shutter_sound ? 1 : 0,webcam.stealth ? 1 : 0 );
			if (webcam.redirect_url) {
				setTimeout('window.location="' + webcam.redirect_url +'"',1500);
			}
		});
		
		$('#webcam_config').live('click', function(){
			cam._configure('camera');
		});
		
		/*
		$('#btn_show_webcam_').click(function(){
			$('#' + webcam.div_img).fadeOut(500);
			$('#div_btn_show_webcam_').fadeOut(500).queue(function(){$('#div_webcam_').show();$(this).dequeue();});
		});
		
		var cam = document.getElementById('webcam_movie');
		
		$('#webcam_snap').click(function(){
			cam._snap(webcam.upload_url,webcam.quality,webcam.shutter_sound ? 1 : 0,webcam.stealth ? 1 : 0 );
			if (webcam.redirect_url) {
				setTimeout('window.location="' + webcam.redirect_url +'"',1500);
			}
		});
		
		$('#webcam_config').click(function(){
			cam._configure('camera');
		});
		*/
	};
})(jQuery);