package com.bitmap.bean.hr;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;

public class Division {
	public static String tableName = "per_division";
	private static String[] keys = {"div_id"};
	private static String[] fieldNames = {"div_name_en","div_name_th","create_by","date_update"};
	
	private String div_id = "";
	private String div_name_en = "";
	private String div_name_th = "";
	private String dep_id = "";
	private String create_by = "";
	private Timestamp date_create = null;
	private Timestamp date_update = null;
	
	
	public static String getUINameEN(String div_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Division div = new Division();
		div.setDiv_id(div_id);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, div, keys);
		conn.close();
		return div.getDiv_name_en();
	}
	
	public static String getUINameTH(String div_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Division div = new Division();
		div.setDiv_id(div_id);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, div, keys);
		conn.close();
		return div.getDiv_name_th();
	}
	
	public static Division select(String div_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Division div = new Division();
		div.setDiv_id(div_id);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, div, keys);
		conn.close();
		return div;
	}
	
	public static Division select(String div_id, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Division div = new Division();
		div.setDiv_id(div_id);
		DBUtility.getEntityFromDB(conn, tableName, div, keys);
		return div;
	}
	
	public static List<String[]> list() throws SQLException{
		Connection conn = DBPool.getConnection();
		List<String[]> list = DBUtility.getDropDownListData(conn, tableName, "div_id", "div_name_en", "dep_id");
		conn.close();
		return list;
	}
	
	public static List<Division> getUIObjectDivision(String dep_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE dep_id ='" + dep_id + "'";
		Connection con = DBPool.getConnection();
		ResultSet rs = con.createStatement().executeQuery(sql);
		
		List<Division> list = new ArrayList<Division>();
		while (rs.next()) {
			Division entity = new Division();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		con.close();
		return list;
	}
	
	public static void update(Division entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		entity.setDate_update(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();
	}
	
	public static void insert(Division entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setDiv_id(createId(conn));
		entity.setDate_create(DBUtility.getDBCurrentDateTime());		
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	private static String createId(Connection conn) throws NumberFormatException, SQLException{
		String div_id = "0001";
		String sql = "SELECT div_id FROM " + tableName + " ORDER BY div_id DESC";
		ResultSet rs = conn.createStatement().executeQuery(sql);
		if (rs.next()) {
			String temp = rs.getString(1);
			String newid = (Integer.parseInt(temp) + 10001) + "";
			div_id = newid.substring(1,newid.length());
		}
		rs.close();
		return div_id;
	}

	public String getDiv_id() {
		return div_id;
	}

	public void setDiv_id(String div_id) {
		this.div_id = div_id;
	}

	public String getDiv_name_en() {
		return div_name_en;
	}

	public void setDiv_name_en(String div_name_en) {
		this.div_name_en = div_name_en;
	}

	public String getDiv_name_th() {
		return div_name_th;
	}

	public void setDiv_name_th(String div_name_th) {
		this.div_name_th = div_name_th;
	}

	public String getDep_id() {
		return dep_id;
	}

	public void setDep_id(String dep_id) {
		this.dep_id = dep_id;
	}

	public String getCreate_by() {
		return create_by;
	}

	public void setCreate_by(String create_by) {
		this.create_by = create_by;
	}

	public Timestamp getDate_create() {
		return date_create;
	}

	public void setDate_create(Timestamp date_create) {
		this.date_create = date_create;
	}

	public Timestamp getDate_update() {
		return date_update;
	}

	public void setDate_update(Timestamp date_update) {
		this.date_update = date_update;
	}
	
}
