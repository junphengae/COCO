package com.bitmap.bean.hr;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.bitmap.dbconnection.mysql.vbi.*;
import com.bitmap.dbutils.DBUtility;

public class Department {
	public static String tableName = "per_department";
	private static String[] keys = {"dep_id"};
	private static String[] fieldNames = {"dep_name_en","dep_name_th","dep_phone","dep_detail","create_by","date_update"};
	
	private String dep_id = "";
	private String dep_name_en = "";
	private String dep_name_th = "";
	private String dep_phone = "";
	private String dep_detail = "";
	private String create_by = "";
	private Timestamp date_create = null;
	private Timestamp date_update = null;
	
	public static void insert(Department entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setDep_id(genId(conn));
		entity.setDate_create(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	private static String genId(Connection conn) throws NumberFormatException, SQLException{
		String dep_id = "0001";
		String sql = "SELECT dep_id FROM " + tableName + " ORDER BY dep_id DESC";
		ResultSet rs = conn.createStatement().executeQuery(sql);
		if (rs.next()) {
			String temp = rs.getString(1);
			String id = (Integer.parseInt(temp) + 10001) + "";
			dep_id = id.substring(1,id.length());
		}
		rs.close();
		return dep_id;
	}
	
	public static void update(Department entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setDate_update(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();
	}
	
	public static String getUINameEN(String dep_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Department dep = new Department();
		dep.setDep_id(dep_id);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, dep, keys);
		conn.close();
		return dep.getDep_name_en();
	}
	
	public static String getUINameTH(String dep_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Department dep = new Department();
		dep.setDep_id(dep_id);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, dep, keys);
		conn.close();
		return dep.getDep_name_th();
	}
	
	public static Department select(String dep_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Department dep = new Department();
		dep.setDep_id(dep_id);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, dep, keys);
		conn.close();
		return dep;
	}
	
	public static Department select(String dep_id, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Department dep = new Department();
		dep.setDep_id(dep_id);
		DBUtility.getEntityFromDB(conn, tableName, dep, keys);
		return dep;
	}
	
	public static List<String[]> list() throws SQLException{
		Connection conn = DBPool.getConnection();
		List<String[]> list = DBUtility.getDropDownListData(conn, tableName, "dep_id", "dep_name_th", "dep_id");
		conn.close();
		return list;
	}
	
	public static List<Department> listDepartmant() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " ORDER BY dep_id";
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		List<Department> list = new ArrayList<Department>();
		while (rs.next()) {
			Department entity = new Department();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		conn.close();
		return list;
	}
	
	public String getDep_id() {
		return dep_id;
	}
	public void setDep_id(String dep_id) {
		this.dep_id = dep_id;
	}
	public String getDep_name_en() {
		return dep_name_en;
	}
	public void setDep_name_en(String dep_name_en) {
		this.dep_name_en = dep_name_en;
	}
	public String getDep_name_th() {
		return dep_name_th;
	}
	public void setDep_name_th(String dep_name_th) {
		this.dep_name_th = dep_name_th;
	}
	public String getDep_phone() {
		return dep_phone;
	}
	public void setDep_phone(String dep_phone) {
		this.dep_phone = dep_phone;
	}
	public String getDep_detail() {
		return dep_detail;
	}
	public void setDep_detail(String dep_detail) {
		this.dep_detail = dep_detail;
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
