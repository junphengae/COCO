package com.bitmap.bean.logistic;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import com.bitmap.bean.sale.Province;
import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;

public class Busstation {
	public static String tableName = "bus_station" ;
	public static String[] keys = {"qid"} ;
	
	public static String[] fieldNames = {"driver", "company", "plate","update_by", "update_date"}; 	
	
	private String qid = "";
	private String driver = "";
	private String company = "";
	private String plate = "";
	private String create_by = "";
	private Timestamp create_date = null;
	private String update_by = "";
	private Timestamp update_date = null;
	
	
	public static List<Busstation> selectWithCTRL(PageControl ctrl, List<String[]> param) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1";
		
		for (Iterator<String[]> iterator = param.iterator(); iterator.hasNext();) {
			String[] pm = (String[]) iterator.next();
			if (pm[1].length() > 0) {
				sql += " AND " + pm[0] + " like '%" + pm[1] + "%'";
			}
		}
		
		sql += " ORDER BY (qid*1)";
		//System.out.println(sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Busstation> list = new ArrayList<Busstation>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					Busstation entity = new Busstation();
					DBUtility.bindResultSet(entity, rs);
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
	
	public static Busstation selectByQid(String qid) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE qid = '" + qid + "'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		//System.out.println(sql);
		Busstation bus = new Busstation();
		while (rs.next()) {	
			DBUtility.bindResultSet(bus, rs);
		}

		rs.close();
		st.close();
		conn.close();
		return bus;
	}
	public static Busstation selectByQid(String qid,Connection conn) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Busstation bus = new Busstation();
		bus.setQid(qid);
		DBUtility.getEntityFromDB(conn, tableName,bus, keys);
		return bus;
	}
	
	public static Busstation insert(Busstation bus) throws IllegalAccessException, InvocationTargetException, SQLException, UnsupportedEncodingException{	
		Connection conn = DBPool.getConnection();
		bus.setQid(DBUtility.genNumber(conn, tableName, "qid"));
		bus.setCreate_date(DBUtility.getDBCurrentDateTime());		
		DBUtility.insertToDB(conn, tableName, bus);
		return bus;
	}
	
	public static Busstation select(Busstation entity) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	
	public static void update(Busstation entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();
	}
	
	public static void main(String[] a){
		//System.out.print("aaaaaa");
	}
	
	public String getQid() {
		return qid;
	}
	public void setQid(String qid) {
		this.qid = qid;
	}
	public String getDriver() {
		return driver;
	}
	public void setDriver(String driver) {
		this.driver = driver;
	}
	public String getCompany() {
		return company;
	}
	public void setCompany(String company) {
		this.company = company;
	}
	public String getPlate() {
		return plate;
	}
	public void setPlate(String plate) {
		this.plate = plate;
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
