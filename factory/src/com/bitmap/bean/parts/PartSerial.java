package com.bitmap.bean.parts;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;

import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;

public class PartSerial {
	public static String tableName = "pa_part_sn";
	private static String[] keys = {"pn","sn"};
	
	String sn = "1";
	String pn = "";
	String flag = "1";
	String sale_order = "";
	String create_by = "";
	Timestamp create_date = null;
	String update_by = "";
	Timestamp update_date = null;
	
	public static String insert(PartSerial entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		String qty = PartMaster.updateInventory(entity.getPn(), entity.getCreate_by(), conn);
		conn.close();
		return qty;
	}
	
	public static String selectSN(String pn) throws SQLException{
		String sn = "1";
		Connection conn = DBPool.getConnection();
		String sql = "SELECT sn FROM " + tableName + " WHERE pn='" + pn + "' ORDER BY (sn*1) DESC" ;
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		if (rs.next()) {
			int s = rs.getInt(1) + 1;
			sn = s + "";
		}
		rs.close();
		conn.close();
		return sn;
	}
	
	public static boolean check(PartSerial entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean has = false;
		has = DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"pn","sn","flag"});
		
		if (has) {
			if (entity.getFlag().equalsIgnoreCase("0")) {
				has = false;
			}
		}
		conn.close();
		return has;
	}
	
	public static void withdraw(PartSerial entity, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		entity.setFlag("0");
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"flag","update_by","update_date"}, keys);
		
		PartMaster pm = new PartMaster();
		pm.setPn(entity.getPn());
		pm.setUpdate_by(entity.getUpdate_by());
		pm.setQty(countQty(entity, conn));
		PartMaster.updateQty(pm);
	}
	
	public static void withdraw(PartSerial entity, PartMaster pm, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		entity.setFlag("0");
		entity.setUpdate_by(pm.getUpdate_by());
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"sale_order","flag","update_by","update_date"}, keys);
		
		pm.setQty(countQty(entity, conn));
		PartMaster.updateQty(pm);
	}
	
	public static void borrowPart(PartSerial entity, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setFlag("2");
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"flag","update_by","update_date"}, keys);
		
		PartMaster pm = new PartMaster();
		pm.setPn(entity.getPn());
		pm.setUpdate_by(entity.getUpdate_by());
		pm.setQty(countQty(entity, conn));
		PartMaster.updateQty(pm);
	}
	
	public static void returnPart(PartSerial entity, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setFlag("1");
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"flag","update_by","update_date"}, keys);
		
		PartMaster pm = new PartMaster();
		pm.setPn(entity.getPn());
		pm.setUpdate_by(entity.getUpdate_by());
		pm.setQty(countQty(entity, conn));
		PartMaster.updateQty(pm);
	}
	
	private static String countQty(PartSerial entity, Connection conn) throws SQLException{
		String sql = "SELECT  COALESCE(count(pn),0) as qty FROM " + tableName + " WHERE pn='" + entity.getPn() + "' AND flag='1'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		String qty = "0";
		if (rs.next()) {
			qty = DBUtility.getString("qty", rs);
		}
		rs.close();
		st.close();
		return qty;
	}
	
	public String getSn() {
		return sn;
	}
	public void setSn(String sn) {
		this.sn = sn;
	}
	public String getPn() {
		return pn;
	}
	public void setPn(String pn) {
		this.pn = pn;
	}
	public String getFlag() {
		return flag;
	}
	public void setFlag(String flag) {
		this.flag = flag;
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

	public String getSale_order() {
		return sale_order;
	}

	public void setSale_order(String sale_order) {
		this.sale_order = sale_order;
	}
}