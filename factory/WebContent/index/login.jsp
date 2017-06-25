<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script type="text/javascript">
	var $msg = $('.msg');
	var $user = $('#user_name');
	var $password = $('#password');
	
	$('#btnLogin').click(function(){
		login();
	});
	
	$password.keypress(function(e){
		if (e.keyCode == 13) {
			login();
		}
	});
	
	function login(){
		if ($user.val() == '') {
			$msg.text('Please insert User name!').show();
			$user.focus();
		} else if($password.val() == ''){
			$msg.text('Please insert Password!').show();
			$password.focus();
		} else {
			
			var sendData = $('#loginForm').serialize();
			ajax_load();
			$.post('LoginServlet', sendData, function(data){
				ajax_remove();
				if (data.status == "success") {
					$msg.text('Login Success.').show().delay(300).queue(function(){window.location = 'index.jsp'; $(this).dequeue();});
				} else {
					$msg.text('User or Password invalid!').show();
					$password.val('').focus();
				}
			},'json');
		}
	}
</script>

<div style="text-align: center;">
	<form id="loginForm" style="margin: 0;padding: 0;">
		<div class="s250 center txt_center" style="margin-bottom: 10px;"><h3>Login</h3></div>
		<div class="s250 center" style="margin-bottom: 5px;"><div class="s70 left">User</div><div class="s10 left">:</div>
			<div class="s120 left">
				<input type="text" autocomplete="off" name="user_name" id="user_name" class="txt_box s120 input_focus"></div><div class="clear"></div>
		</div>
		<div class="s250 center" style="margin-bottom: 5px;"><div class="s70 left">Password</div><div class="s10 left">:</div>
			<div class="s120 left"><input type="password" name="password" id="password" class="txt_box s120"></div><div class="clear"></div>
		</div>
		<div class="s250 center txt_center" style="margin-bottom: 10px;">
			<input type="button" id="btnLogin" value=" Login " class="btn_box">
			<input type="reset" onclick="tb_remove();" value="Cancel" class="btn_box">
		</div>
		
		<div class="msg" style="color: #ff0000;"></div>
	
	</form>
</div>