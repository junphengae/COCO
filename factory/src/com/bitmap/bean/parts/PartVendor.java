package com.bitmap.bean.parts;

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

public class PartVendor {
	public static String tableName = "pa_part_vendor";
	private static String[] keys = {"pn"};
	
	String pn = "";
	String vendor_id = "";
	String vendor_moq = "";
	String vendor_delivery_time = "";
	Vendor vendor = new Vendor();
	
	public static void insert(PartVendor entity) throws IllegalAccessException, InvocationTargetException, SQLException {
		Connection conn = DBPool.getConnection();
		DBUtility.insertToDB(conn, tableName, entity);
		entity.setUIVendor(Vendor.select(entity.getVendor_id(), conn));
		conn.close();
	}
	
	public static PartVendor select(String pn, String vendor_id, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		PartVendor entity = new PartVendor();
		entity.setPn(pn);
		entity.setVendor_id(vendor_id);
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"pn","vendor_id"});
		entity.setUIVendor(Vendor.select(vendor_id, conn));
		return entity;
	}
	
	public static PartVendor select(String pn, String vendor_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		PartVendor entity = new PartVendor();
		entity.setPn(pn);
		entity.setVendor_id(vendor_id);
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"pn","vendor_id"});
		entity.setUIVendor(Vendor.select(vendor_id, conn));
		conn.close();
		return entity;
	}
	
	public static List<PartVendor> selectList(String pn) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE pn='" + pn + "'";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PartVendor> list = new ArrayList<PartVendor>();
		while (rs.next()) {
			PartVendor entity = new PartVendor();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIVendor(Vendor.select(entity.getVendor_id(), conn));
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static void update(PartVendor entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"vendor_moq","vendor_delivery_time"}, keys);
		conn.close();
	}
	
	public static void delete(PartVendor entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.deleteFromDB(conn, tableName, entity, new String[]{"pn","vendor_id"});
		conn.close();
	}
	
	public static void deleteAll(PartVendor entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.deleteFromDB(conn, tableName, entity, keys);
		conn.close();
	}
	
	public String getPn() {
		return pn;
	}
	public void setPn(String pn) {
		this.pn = pn;
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