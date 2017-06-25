<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<% 
String ChkSession = securProfile.getPersonal().getPer_id();
if(ChkSession.equalsIgnoreCase("")){
%>
<script type="text/javascript">
window.location="../index/index.jsp";
</script>
<%
}
 
%>