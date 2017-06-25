<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
	<div class="h50"></div>
	<div class="wrap_footer">
		<div class="footer_left"></div>
		<div class="footer_right" id="bmp">
			<a href="#"   style="cursor: default;">	by Bitmap solution co.,ltd.  &nbsp;&nbsp;&nbsp;&nbsp; Build 1.1.590307</a>
		</div>
		<div class="clear"></div>
	</div>
	<script>
	
		$('#bmp').hover(
			function(){
				$(this).stop().animate({'margin-top':'0'},300);
			},function(){
				$(this).stop().animate({'margin-top':'16'},300);
			}
		);
	
	</script>
