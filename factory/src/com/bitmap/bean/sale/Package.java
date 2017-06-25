package com.bitmap.bean.sale;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;

public class Package {

	public static String tableName = "sale_package";
	private static String[] keys = {"pk_id"};

	private static String[] fieldNames = {"name","price","status","update_by","update_date"};
	
	public static String STATUS_CREATE = "10";
	public static String STATUS_ACTIVE = "20";
	public static String STATUS_DIRECTOR_APPROVE = "30";
	public static String STATUS_DIRECTOR_NOAPPROVE = "40";
	public static String STATUS_INACTIVE = "00";
	
	public static List<String[]> statusDropdown(){
		List<String[]> list = new ArrayList<String[]>();
		
		list.add(new String[]{"10", "กำลังสร้าง"});
		list.add(new String[]{"20", "อนุมัติ"});
		list.add(new String[]{"30", "ผู้บริหารอนุมัติ"});
		list.add(new String[]{"40", "ผู้บริหารยกเลิก"});
		list.add(new String[]{"999", "ยกเลิก"});
		
		return list;
	}
	
	public static String status(String status){
		HashMap<String , String> map = new HashMap<String, String>();
		map.put("999", "ยกเลิก");
		map.put("10", "กำลังสร้าง");
		map.put("20", "อนุมัติ");
		map.put("30", "ผู้บริหารอนุมัติ");
		map.put("40", "ผู้บริหารยกเลิก");
		return map.get(status);
	}
	
	String pk_id = "";
	String name = "";
	String price = "0";
	String status = "";
	String pk_type ="";
	String pk_qty = "1";
	String remark = "";
	String create_by = "";
	Timestamp create_date = null;
	String update_by = "";
	Timestamp update_date = null;

	
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getPk_type() {
		return pk_type;
	}

	public void setPk_type(String pk_type) {
		this.pk_type = pk_type;
	}

	public String getPk_qty() {
		return pk_qty;
	}

	public void setPk_qty(String pk_qty) {
		this.pk_qty = pk_qty;
	}

	public String getPk_id() {
		return pk_id;
	}
	public void setPk_id(String pk_id) {
		this.pk_id = pk_id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getPrice() {
		return price;
	}
	public void setPrice(String price) {
		this.price = price;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
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
	
	public static void insert(Package entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setPk_id(DBUtility.genNumber(conn, tableName, "pk_id"));
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		entity.setStatus(STATUS_CREATE);
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	public static void update(Package entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();
	}
	
	public static void updateAp(Package entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		if(entity.getRemark().equalsIgnoreCase("")){
			DBUtility.updateToDB(conn, tableName, entity,new String[] {"remark","status","update_by","update_date"}, keys);
		}else {
		DBUtility.updateToDB(conn, tableName, entity,new String[] {"status","update_by","update_date"}, keys);
		}
		conn.close();
	}
	public static void updateName(Package entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity,new String[] {"name","update_by","update_date","pk_type","pk_qty"}, keys);
		conn.close();
	}
	
	public static Package select(Package entity) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		
		conn.close();
		return entity;
	}
	
	public static Package select(String pk_id, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Package entity = new Package();
		entity.setPk_id(pk_id);
		select(entity); 
		return entity;
	}
	
	public static Package select(String pk_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		Package entity = new Package();
		entity.setPk_id(pk_id);
		select(entity);
		conn.close();
		return entity;
	}
	
	public static List<Package> selectWithCTRL(PageControl ctrl, List<String[]> param) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1 ";
		
		for (Iterator<String[]> iterator = param.iterator(); iterator.hasNext();) {
			String[] pm = (String[]) iterator.next();
			if (pm[1].length() > 0) {
				if(pm[0].equalsIgnoreCase("name")) {
					sql += " AND " + pm[0] + " like '%" + pm[1] + "%'";
				} else {
					sql += " AND " + pm[0] + " ='" + pm[1] + "'";
				}
				
			}
		}
		
		sql += " ORDER BY (pk_id*1)";
		sql += " LIMIT 0,1000 ";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Package> list = new ArrayList<Package>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					Package entity = new Package();
					DBUtility.bindResultSet(entity, rs);
				//	entity.setUISubCat(SubCategories.select(entity.getSub_cat_id(), entity.getCat_id(), entity.getGroup_id(), conn));
					list.add(entity);
				}
				cnt++;
			}
		}
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		rs.close();
		st.close();
		conn.close();
		return list;
	}

	public static void updatePrice(Package entity, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"price","update_by","update_date"}, keys);
	}
	
	public static void statusAcive(Package entity, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus(STATUS_ACTIVE);
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"status","update_by","update_date"}, keys);
	}
	
	public static void statusInactive(Package entity, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus(STATUS_INACTIVE);
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"status","update_by","update_date"}, keys);
	}
	
	public static void updateStatus(Package entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setStatus(STATUS_DIRECTOR_NOAPPROVE);
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"remark","status","update_by","update_date"}, keys);
		conn.close();
	}
}
