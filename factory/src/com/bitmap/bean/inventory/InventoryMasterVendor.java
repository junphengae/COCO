package com.bitmap.bean.inventory;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;

public class InventoryMasterVendor {
	public static String tableName = "inv_master_vendor";
	private static String[] keys = {"mat_code","vendor_id"};
	
	String mat_code = "";
	String vendor_id = "";
	String vendor_moq = "";
	String vendor_delivery_time = "";
	Vendor vendor;
	
	public static void select(InventoryMasterVendor entity) throws IllegalAccessException, InvocationTargetException, SQLException {
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
	}
	
	public static InventoryMasterVendor select(String mat_code, String vendor_id, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException {
		InventoryMasterVendor entity = new InventoryMasterVendor();
		entity.setMat_code(mat_code);
		entity.setVendor_id(vendor_id);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		entity.setUIVendor(Vendor.select(entity.getVendor_id(), conn));
		return entity;
	}
	
	public static InventoryMasterVendor select(String mat_code, String vendor_id) throws IllegalAccessException, InvocationTargetException, SQLException {
		Connection conn = DBPool.getConnection();
		InventoryMasterVendor entity = new InventoryMasterVendor();
		entity.setMat_code(mat_code);
		entity.setVendor_id(vendor_id);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		entity.setUIVendor(Vendor.select(entity.getVendor_id(), conn));
		conn.close();
		return entity;
	}
	
	public static void insert(InventoryMasterVendor entity) throws IllegalAccessException, InvocationTargetException, SQLException {
		Connection conn = DBPool.getConnection();
		DBUtility.insertToDB(conn, tableName, entity);
		entity.setUIVendor(Vendor.select(entity.getVendor_id(), conn));
		conn.close();
	}
	
	public static List<InventoryMasterVendor> selectList(String mat_code) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE mat_code='" + mat_code + "'";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<InventoryMasterVendor> list = new ArrayList<InventoryMasterVendor>();
		while (rs.next()) {
			InventoryMasterVendor entity = new InventoryMasterVendor();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIVendor(Vendor.select(entity.getVendor_id(), conn));
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static void update(InventoryMasterVendor entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"vendor_moq","vendor_delivery_time"}, keys);
		conn.close();
	}
	
	public static void delete(InventoryMasterVendor entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.deleteFromDB(conn, tableName, entity, keys);
		conn.close();
	}
	
	public static void deleteAll(InventoryMasterVendor entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.deleteFromDB(conn, tableName, entity, new String[]{"mat_code"});
		conn.close();
	}
	
	public String getMat_code() {
		return mat_code;
	}
	public void setMat_code(String mat_code) {
		this.mat_code = mat_code;
	}
	public String getVendor_id() {
		return vendor_id;
	}
	public void setVendor_id(String vendor_id) {
		this.vendor_id = vendor_id;
	}
	public String getVendor_moq() {
		return vendor_moq;
	}
	public void setVendor_moq(String vendor_moq) {
		this.vendor_moq = vendor_moq;
	}
	public String getVendor_delivery_time() {
		return vendor_delivery_time;
	}
	public void setVendor_delivery_time(String vendor_delivery_time) {
		this.vendor_delivery_time = vendor_delivery_time;
	}
	public Vendor getUIVendor() {
		return vendor;
	}
	public void setUIVendor(Vendor vendor) {
		this.vendor = vendor;
	}
}