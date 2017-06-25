package com.bitmap.bean.logistic;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import com.bitmap.bean.sale.Customer;
import com.bitmap.bean.sale.SaleOrder;
import com.bitmap.bean.sale.SaleOrderItem;
import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;


public class SendProduct {
	
	public static String tableName = "send_product" ;
	public static String[] keys = {"run"};
	
	public static String[] fieldNames = {"send_date","remark","start","finish","emp_check","emp_car","no_oil","qty_oil","time_oil","reference","update_by","update_date"}; 	
	
	String run = "";
	String qid = "";
	Date send_date = null;
	String status = "";
	String remark = "";
	String start = "";
	String finish = "";
	String emp_check = "";
	String emp_car = "";
	String no_oil = "";
	String qty_oil = "";
	String time_oil = "";
	String reference = "";
	String create_by = "";
	Timestamp create_date = null;
	String update_by = "";
	Timestamp update_date = null;
	
	public static String STATUS_havInv = "10";
	public static String STATUS_tmpInv = "20";
	
	public static String STATUS_NOT_SEND = "00";
	public static String STATUS_AP_SEND = "10";

	public static String status(String status){
		HashMap<String , String> map = new HashMap<String, String>();
		map.put("00", "อยู่ในระหว่างจัดส่ง");
		map.put("10", "ส่งสินค้าเรียบร้อยแล้ว");
		return map.get(status);
	}
	
	Customer UIcus = new Customer();
	SaleOrderItem UIitem = new SaleOrderItem();
	SaleOrder UIorder = new SaleOrder();
	Busstation UIBus = new Busstation();
	
	String UIstart = "";
	String UIfin = "";
	
	public String getEmp_check() {
		return emp_check;
	}
	public void setEmp_check(String emp_check) {
		this.emp_check = emp_check;
	}
	public String getEmp_car() {
		return emp_car;
	}
	public void setEmp_car(String emp_car) {
		this.emp_car = emp_car;
	}
	public String getNo_oil() {
		return no_oil;
	}
	public void setNo_oil(String no_oil) {
		this.no_oil = no_oil;
	}
	public String getQty_oil() {
		return qty_oil;
	}
	public void setQty_oil(String qty_oil) {
		this.qty_oil = qty_oil;
	}
	public String getTime_oil() {
		return time_oil;
	}
	public void setTime_oil(String time_oil) {
		this.time_oil = time_oil;
	}
	public String getReference() {
		return reference;
	}
	public void setReference(String reference) {
		this.reference = reference;
	}
	public String getUIstart() {
		return UIstart;
	}
	public void setUIstart(String uIstart) {
		UIstart = uIstart;
	}
	public String getUIfin() {
		return UIfin;
	}
	public void setUIfin(String uIfin) {
		UIfin = uIfin;
	}
	public String getStart() {
		return start;
	}
	public void setStart(String start) {
		this.start = start;
	}
	public String getFinish() {
		return finish;
	}
	public void setFinish(String finish) {
		this.finish = finish;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public Busstation getUIBus() {
		return UIBus;
	}
	public void setUIBus(Busstation uIBus) {
		UIBus = uIBus;
	}
	public String getRun() {
		return run;
	}
	public void setRun(String run) {
		this.run = run;
	}
	public SaleOrderItem getUIitem() {
		return UIitem;
	}
	public void setUIitem(SaleOrderItem uIitem) {
		UIitem = uIitem;
	}
	public SaleOrder getUIorder() {
		return UIorder;
	}
	public void setUIorder(SaleOrder uIorder) {
		UIorder = uIorder;
	}
	public Customer getUIcus() {
		return UIcus;
	}
	public void setUIcus(Customer uIcus) {
		UIcus = uIcus;
	}
	public String getQid() {
		return qid;
	}
	public void setQid(String qid) {
		this.qid = qid;
	}
	public Date getSend_date() {
		return send_date;
	}
	public void setSend_date(Date send_date) {
		this.send_date = send_date;
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
	
	public static void insert(SendProduct entity) throws IllegalAccessException, InvocationTargetException, SQLException, IllegalArgumentException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();		
		entity.setRun(DBUtility.genNumber(conn, tableName, "run"));
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		entity.setStatus(STATUS_NOT_SEND);
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	public static void update(SendProduct entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();	
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity,fieldNames,keys);
		conn.close();
	}
	/**
	 * Use : logis_send_product
	 * <br>
	 * update remark การส่งของได้ตลอด
	 * @param entity
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws SQLException
	 */
	public static void updateRemark(SendProduct entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();	
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity,new String[] {"remark","update_date","update_by"},new String[] {"run"});
		conn.close();
	}
	public static List<SendProduct> selectByrun(String run) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		String sql = "SELECT * FROM " + tableName + " WHERE run ='" + run + "'";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);

		List<SendProduct> list = new ArrayList<SendProduct>();
		while (rs.next()) {	
			SendProduct send = new SendProduct();
			DBUtility.bindResultSet(send, rs);
			list.add(send);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static SendProduct select(SendProduct pro) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, pro,new String[] {"run"});
		conn.close();
		return pro;
	}
	
	public static List<SendProduct> selectWithCTRL(PageControl ctrl, List<String[]> paramList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
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
		
		List<SendProduct> list = new ArrayList<SendProduct>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					SendProduct entity = new SendProduct();
					DBUtility.bindResultSet(entity, rs);
					entity.setUIBus(Busstation.selectByQid(entity.getQid(), conn));			
					
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

	public static List<SendProduct> reportWithCTRL(PageControl ctrl, List<String[]> paramList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT *,sale_order_item FROM " + tableName + ",sale_order_item WHERE 1=1";
		Iterator<String[]> ite = paramList.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
					sql += " AND " + str[0] + "='" + str[1] + "'";
			}
		}	
		sql += " ORDER BY (run*1) ASC";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SendProduct> list = new ArrayList<SendProduct>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					SendProduct entity = new SendProduct();
					DBUtility.bindResultSet(entity, rs);
					entity.setUIBus(Busstation.selectByQid(entity.getQid(), conn));			
					
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
	
	/**
	 * Used : logis_send_product
	 * <br>
	 * ปิดคิวรถหลังจากยืนยันการส่งสินค้า
	 * @param entity
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws SQLException
	 */
	public static void updatestatus(SendProduct entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();		
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity,new String[] {"status","update_date","update_by"},new String[] {"run"});		
		conn.close();
	}
	

	
}
