package com.bitmap.security;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import com.bitmap.dbconnection.mysql.vbi.*;
import com.bitmap.dbutils.DBUtility;

public class SecurityRole {
	public static String tableName = "security_role";
	
	private String role_id = "";
	private String role_name = "";
	
	public static List<String[]> selectList(String user_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName ;
		Connection conn = DBPool.getConnection();
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		List<String[]> list = new ArrayList<String[]>();
		List<String[]> listUserRole = selectUserRole(user_id);
		while (rs.next()) {
			SecurityRole role = new SecurityRole();
			DBUtility.bindResultSet(role, rs);
			
			boolean isRole = true;
			Iterator<String[]> userRole = listUserRole.iterator();
			while (userRole.hasNext()) {
				String[] str = (String[]) userRole.next();
				if (str[0].equalsIgnoreCase(role.getRole_id())) {
					isRole = false;
					break;
				}
			}
			
			if (isRole) {
				list.add(new String[]{role.getRole_id(),role.getRole_name()});
			}
		}
		rs.close();
		conn.close();
		return list;
	}
	
	public static List<String[]> selectUserRole(String user_id) throws SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		String sql = "SELECT * FROM " + tableName + " role INNER JOIN security_user_role user_role ON role.role_id = user_role.role_id WHERE user_role.user_id = '" + user_id + "'";
		Connection conn = DBPool.getConnection();
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		List<String[]> list = new ArrayList<String[]>();
		while (rs.next()) {
			SecurityRole role = new SecurityRole();
			DBUtility.bindResultSet(role, rs);
			list.add(new String[]{role.getRole_id(),role.getRole_name()});
		}
		rs.close();
		conn.close();
		return list;
	}
	
	public String getRole_id() {
		return role_id;
	}
	public void setRole_id(String role_id) {
		this.role_id = role_id;
	}
	public String getRole_name() {
		return role_name;
	}
	public void setRole_name(String role_name) {
		this.role_name = role_name;
	}
	
	
}
