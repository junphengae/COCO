package com.bitmap.bean.inventory;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

import com.bitmap.dbconnection.mysql.vbi.*;
import com.bitmap.dbutils.DBUtility;

public class Vendor {
	public static String tableName = "inv_vendor";
	private static String[] keys = {"vendor_id"};
	private static String[] fieldNames = {"vendor_name","vendor_phone","vendor_fax","vendor_address","vendor_email",
										  "vendor_contact","vendor_ship","vendor_condition","vendor_credit","update_by","update_date"};
	
	String vendor_id = "";
	String vendor_name = "";
	String vendor_phone = "";
	String vendor_fax = "";
	String vendor_address = "";
	String vendor_email = "";
	String vendor_contact = "";
	String vendor_ship = "";
	String vendor_condition = "";
	String vendor_credit = "";
	String create_by = "";
	Timestamp create_date = null;
	String update_by = "";
	Timestamp update_date = null;
	
	public static void insert(Vendor entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setVendor_id(genId(conn));
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	private static String genId(Connection conn) throws SQLException {
		String sql = "SELECT vendor_id FROM " + tableName + " ORDER BY vendor_id DESC";
		ResultSet rs = conn.createStatement().executeQuery(sql);
		String vendor_id = "v001";
		
		if (rs.next()) {
			String temp = rs.getString("vendor_id");
			String id = (Integer.parseInt(temp.substring(1, temp.length())) + 1001) + "";
			vendor_id = "v" + id.substring(1,id.length());
		}
		rs.close();
		return vendor_id;
	}
	
	public static void update(Vendor entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();
	}
	
	public static Vendor select(Vendor entity) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	
	public static Vendor select(String vendor_id) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Vendor entity = new Vendor();
		entity.setVendor_id(vendor_id);
		return select(entity);
	}
	
	public static Vendor select(String vendor_id, Connection conn) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Vendor entity = new Vendor();
		entity.setVendor_id(vendor_id);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		return entity;
	}
	
	public static String name(String vendor_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Vendor entity = new Vendor();
		entity.setVendor_id(vendor_id);
		entity = select(entity);
		return entity.getVendor_name();
	}
	
	public static List<String[]> selectList() throws SQLException{
		Connection conn =DBPool.getConnection();
		List<String[]> list = DBUtility.getDropDownListData(conn, tableName, "vendor_id", "vendor_name", "vendor_id");
		conn.close();
		return list;
	}
	
	public String getVendor_id() {
		return vendor_id;
	}
	public void setVendor_id(String vendor_id) {
		this.vendor_id = vendor_id;
	}
	public String getVendor_name() {
		return vendor_name;
	}
	public void setVendor_name(String vendor_name) {
		this.vendor_name = vendor_name;
	}
	public String getVendor_phone() {
		return vendor_phone;
	}
	public void setVendor_phone(String vendor_phone) {
		this.vendor_phone = vendor_phone;
	}
	public String getVendor_fax() {
		return vendor_fax;
	}
	public void setVendor_fax(String vendor_fax) {
		this.vendor_fax = vendor_fax;
	}
	public String getVendor_address() {
		return vendor_address;
	}
	public void setVendor_address(String vendor_address) {
		this.vendor_address = vendor_address;
	}
	public String getVendor_email() {
		return vendor_email;
	}
	public void setVendor_email(String vendor_email) {
		this.vendor_email = vendor_email;
	}
	public String getVendor_contact() {
		return vendor_contact;
	}
	public void setVendor_contact(String vendor_contact) {
		this.vendor_contact = vendor_contact;
	}
	public String getVendor_ship() {
		return vendor_ship;
	}
	public void setVendor_ship(String vendor_ship) {
		this.vendor_ship = vendor_ship;
	}
	public String getVendor_condition() {
		return vendor_condition;
	}

	public void setVendor_condition(String vendor_condition) {
		this.vendor_condition = vendor_condition;
	}

	public String getVendor_credit() {
		return vendor_credit;
	}

	public void setVendor_credit(String vendor_credit) {
		this.vendor_credit = vendor_credit;
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
	public String getUpdate_by() {
		return update_by;
	}
	public void setUpdate_by(String update_by) {
		this.update_by = update_by;
	}
	public Timestamp getUpdate_date() {
		return update_date;
	}
	public void setUpdate_date(Timestamp update_date) {
		this.update_date = update_date;
	}
}