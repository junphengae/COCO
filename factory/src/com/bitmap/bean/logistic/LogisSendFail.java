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

import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;

public class LogisSendFail {

	public static String tableName = "logis_send_fail" ;
	public static String[] keys = {"id_fail"};	
	
	String id_fail = "";
	String run = "";
	String id_run = "";
	String cus_id = "";
	String qty = "";
	String create_by = "";
	Timestamp create_date = null;
	
	String UIMatName = "";
		
	public String getUIMatName() {
		return UIMatName;
	}
	public void setUIMatName(String uIMatName) {
		UIMatName = uIMatName;
	}
	public String getCus_id() {
		return cus_id;
	}
	public void setCus_id(String cus_id) {
		this.cus_id = cus_id;
	}
	public String getQty() {
		return qty;
	}
	public void setQty(String qty) {
		this.qty = qty;
	}
	public String getId_fail() {
		return id_fail;
	}
	public void setId_fail(String id_fail) {
		this.id_fail = id_fail;
	}
	public String getId_run() {
		return id_run;
	}
	public void setId_run(String id_run) {
		this.id_run = id_run;
	}
	public String getRun() {
		return run;
	}
	public void setRun(String run) {
		this.run = run;
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
	
	public static void insert(LogisSendFail entity) throws IllegalAccessException, InvocationTargetException, SQLException, IllegalArgumentException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();		
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	public static void delete(LogisSendFail entity) throws IllegalAccessException, InvocationTargetException, SQLException, IllegalArgumentException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();			
		DBUtility.deleteFromDB(conn, tableName, entity,keys);	
		conn.close();
	}
	public static List<LogisSendFail> selectWithCTRL(PageControl ctrl, List<String[]> paramList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1";
		Iterator<String[]> ite = paramList.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
					sql += " AND " + str[0] + "='" + str[1] + "'";
			}
		}	
		sql += " ORDER BY (run*1) ASC";
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<LogisSendFail> list = new ArrayList<LogisSendFail>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					LogisSendFail entity = new LogisSendFail();
					DBUtility.bindResultSet(entity, rs);	
					list.add(entity);
				}
				cnt++;
			}
		}
		rs.close();
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		conn.close();
		return list;
	}

}
