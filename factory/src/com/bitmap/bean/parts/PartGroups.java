package com.bitmap.bean.parts;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;

public class PartGroups {
	public static String tableName = "pa_groups";
	private static String[] keys = {"group_id"};
	String group_id = "";
	String group_name_en = "";
	String group_name_th = "";
	String create_by = "";
	Timestamp create_date = null;

	
	public String getGroup_id() {
		return group_id;
	}

	public void setGroup_id(String group_id) {
		this.group_id = group_id;
	}

	public String getGroup_name_en() {
		return group_name_en;
	}

	public void setGroup_name_en(String group_name_en) {
		this.group_name_en = group_name_en;
	}

	public String getGroup_name_th() {
		return group_name_th;
	}

	public void setGroup_name_th(String group_name_th) {
		this.group_name_th = group_name_th;
	}

	public String getCreate_by() {
		return create_by;
	}

	public void setCreate_by(String create_by) {
		this.create_by = create_by;
	}

	public Timestamp getCreate_date() {
		return create_date;
	}

	public void setCreate_date(Timestamp create_date) {
		this.create_date = create_date;
	}
	
	
	
	public static List<PartGroups> selectList() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		List<PartGroups> list = new ArrayList<PartGroups>();
		String sql = "SELECT * FROM " + tableName;
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			PartGroups entity = new PartGroups();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static void insert(PartGroups entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		entity.setGroup_id(DBUtility.genNumber(conn, tableName, "group_id"));
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	public static PartGroups select(String group_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		PartGroups entity = new PartGroups();
		entity.setGroup_id(group_id);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	
	public static void select(PartGroups entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
	}
	
	public static PartGroups select(String group_id, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		PartGroups entity = new PartGroups();
		entity.setGroup_id(group_id);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		return entity;
	}
	
	public static List<String[]> ddl_th() throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		List<String[]> list = DBUtility.getDropDownListData(conn,tableName,"group_id","group_name_th","group_id");
		conn.close();
		return list;
	}
	
	public static List<String[]> ddl_th_notFG() throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		String sql = "SELECT * FROM " + tableName + " WHERE group_id <> '1' ORDER BY (group_id*1) ASC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<String[]> list = new ArrayList<String[]>();
		while (rs.next()){
			String[] data = {rs.getString("group_id"),rs.getString("group_name_th")};
			list.add(data);
		}
		
		conn.close();
		return list;
	}
	/**
	 * get group for use in material search
	 * @return
	 * @throws SQLException
	 */
	public static List<String[]> ddl_matPartGroups() throws SQLException{
		Connection conn = DBPool.getConnection();
		List<String[]> list = new ArrayList<String[]>();
		String sql = "SELECT group_id as value,group_name_th as text FROM "+tableName+" WHERE GROUP_ID != 'FG' ORDER BY group_id";		
		PreparedStatement ps = conn.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		while(rs.next()){
			HashMap<String,Object> entity = DBUtility.getEntity(rs);
			String value = (String) entity.get("value");
			String text = entity.get("text").toString();
			String[] data = {value,text};
			list.add(data);
		}
		rs.close();
		ps.close();
		conn.close();
		return list;
	}
	
	public static List<String[]> ddl_formularPartGroups() throws SQLException{
		Connection conn = DBPool.getConnection();
		List<String[]> list = new ArrayList<String[]>();
		String sql = "SELECT group_id as value,group_name_th as text FROM "+tableName+" WHERE GROUP_ID != 'MT' AND GROUP_ID!='PK' ORDER BY group_id";		
		PreparedStatement ps = conn.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		while(rs.next()){
			HashMap<String,Object> entity = DBUtility.getEntity(rs);
			String value = (String) entity.get("value");
			String text = entity.get("text").toString();
			String[] data = {value,text};
			list.add(data);
		}
		rs.close();
		ps.close();
		conn.close();
		return list;
	}
	
	
	public static List<String[]> ddl_en() throws SQLException{
		Connection conn = DBPool.getConnection();
		List<String[]> list = DBUtility.getDropDownListData(conn, tableName, "group_id", "group_name_en", "group_id");
		conn.close();
		return list;
	}
	
	public static void update(PartGroups entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"group_name_en","group_name_th","create_by","create_date"}, keys);
		conn.close();
	}
	
	
	

}
