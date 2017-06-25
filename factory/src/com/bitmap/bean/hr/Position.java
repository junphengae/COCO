package com.bitmap.bean.hr;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.bitmap.dbconnection.mysql.vbi.*;
import com.bitmap.dbutils.DBUtility;

public class Position {
	public static String tableName = "per_position";
	private static String[] keys = {"pos_id"};
	private static String[] fieldNames = {"pos_name_en","pos_name_th","create_by","date_update"};
	
	private String pos_id = "";
	private String pos_name_en = "";
	private String pos_name_th = "";
	private String div_id = "";
	private String dep_id = "";
	private String create_by = "";
	private Timestamp date_create = null;
	private Timestamp date_update = null;
	
	

	public static String getUINameEN(String pos_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Position pos = new Position();
		pos.setPos_id(pos_id);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, pos, keys);
		conn.close();
		return pos.getPos_name_en();
	}
	
	public static String getUINameTH(String pos_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Position pos = new Position();
		pos.setPos_id(pos_id);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, pos, keys);
		conn.close();
		return pos.getPos_name_th();
	}
	
	public static Position select(String pos_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Position pos = new Position();
		pos.setPos_id(pos_id);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, pos, keys);
		conn.close();
		return pos;
	}
	
	public static Position select(String pos_id, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Position pos = new Position();
		pos.setPos_id(pos_id);
		DBUtility.getEntityFromDB(conn, tableName, pos, keys);
		return pos;
	}
	
	public static List<String[]> list() throws SQLException{
		Connection conn = DBPool.getConnection();
		List<String[]> list = DBUtility.getDropDownListData(conn, tableName, "pos_id", "pos_name_th", "pos_id");
		conn.close();
		return list;
	}
	
	public static List<Position> getUIObjectPosition(String dep_id, String div_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE dep_id ='" + dep_id + "' AND div_id='" + div_id + "'";
		Connection con = DBPool.getConnection();
		Statement st = con.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Position> list = new ArrayList<Position>();
		while (rs.next()) {
			Position entity = new Position();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		st.close();
		con.close();
		return list;
	}
	
	public static List<Position> getUIObjectPosition() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " ORDER BY (pos_id*1) ASC";
		Connection con = DBPool.getConnection();
		Statement st = con.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Position> list = new ArrayList<Position>();
		while (rs.next()) {
			Position entity = new Position();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		con.close();
		return list;
	}
	
	public static void update(Position entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		entity.setDate_update(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();
	}
	
	public static void insert(Position entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setPos_id(createId(conn));
		entity.setDate_create(DBUtility.getDBCurrentDateTime());		
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	
	public static boolean delete(Position entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		if(Personal.checkPosition(entity.getPos_id())){			
			conn.close();
			return false;
		} else {
			DBUtility.deleteFromDB(conn, tableName, entity, keys) ;	 
			conn.close();
			return true;
		}
	}
	
	private static String createId(Connection conn) throws NumberFormatException, SQLException{
		String pos_id = "0001";
		String sql = "SELECT pos_id FROM " + tableName + " ORDER BY (pos_id*1) DESC";
		ResultSet rs = conn.createStatement().executeQuery(sql);
		if (rs.next()) {
			String temp = rs.getString(1);
			String newid = (Integer.parseInt(temp) + 10001) + "";
			pos_id = newid.substring(1,newid.length());
		}
		rs.close();
		return pos_id;
	}
	
	
	
	
	public String getPos_id() {
		return pos_id;
	}
	public void setPos_id(String pos_id) {
		this.pos_id = pos_id;
	}
	public String getPos_name_en() {
		return pos_name_en;
	}
	public void setPos_name_en(String pos_name_en) {
		this.pos_name_en = pos_name_en;
	}
	public String getPos_name_th() {
		return pos_name_th;
	}
	public void setPos_name_th(String pos_name_th) {
		this.pos_name_th = pos_name_th;
	}
	public String getDep_id() {
		return dep_id;
	}
	public void setDep_id(String dep_id) {
		this.dep_id = dep_id;
	}
	public String getDiv_id() {
		return div_id;
	}

	public void setDiv_id(String div_id) {
		this.div_id = div_id;
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
