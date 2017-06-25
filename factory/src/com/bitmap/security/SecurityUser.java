package com.bitmap.security;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.bitmap.dbconnection.mysql.vbi.*;
import com.bitmap.dbutils.DBUtility;

public class SecurityUser {
	private static String tableName	= "security_user";
	private static String[] keys = {"user_id"};
	
	String user_id = "";
	String user_name = "";
	String password = "";
	String active = "";
	boolean login = false;
	
	public static SecurityUser login(Connection conn, SecurityUser entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		entity.setActive("true");
		boolean is = DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"user_name", "password","active"});
		entity.setUILogin(is);
		return entity;
	}
	
	public static SecurityUser select(String user_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		SecurityUser entity = new SecurityUser();
		entity.setUser_id(user_id);
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"user_id"});
		entity.setPassword("");
		conn.close();
		return entity;
	}
	
	public static SecurityUser select(String user_id, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		SecurityUser entity = new SecurityUser();
		entity.setUser_id(user_id);
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"user_id"});
		entity.setPassword("");
		return entity;
	}
	
	public static void insert(SecurityUser entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setActive("true");
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	public static void updateUserPassword(SecurityUser entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		if (check(entity.getUser_id(), conn)) {
			DBUtility.updateToDB(conn, tableName, entity, new String[]{"user_name","password"}, keys);
		} else {
			entity.setActive("true");
			DBUtility.insertToDB(conn, tableName, entity);
		}
		conn.close();
	}
	
	private static boolean check(String user_id, Connection conn) throws SQLException{
		boolean has = false;
		String sql = "SELECT user_id FROM " + tableName + " WHERE user_id='" + user_id + "'";
		ResultSet rs = conn.createStatement().executeQuery(sql);
		if (rs.next()) {
			has = true;
		}
		rs.close();
		return has;
	}
	
	public static void updateActive(SecurityUser entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"active"}, keys);
		conn.close();
	}
	
	public boolean isLogin(){
		return login;
	}
	public void setUILogin(boolean bl){
		this.login = bl;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getUser_name() {
		return user_name;
	}
	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getActive() {
		return active;
	}
	public void setActive(String active) {
		this.active = active;
	}
	
	
}
