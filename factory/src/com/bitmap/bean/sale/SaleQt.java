package com.bitmap.bean.sale;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import com.bitmap.bean.hr.Personal;
import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;

public class SaleQt {

	public static String tableName = "sale_qt";
	private static String[] keys = {"order_id","qt_id"};
	static String[] fieldNames = {"cus_id","credit","remark_date","remark","send_by","update_by","update_date"};
	
	String order_id = "";
	String cus_id = "";
	String qt_id = "1";
	String credit = "";
	String remark_date = "";
	String remark = "";
	String send_by = "";
	String status = "";
	String create_by = "";
	Timestamp create_date = null;
	String update_by = "";
	Timestamp update_date = null;
	
	Customer UICustomer = new Customer();
	Personal UISale = new Personal();
	SaleOrderItem UIItem = new SaleOrderItem();
	
	String UIinvoice = "";
	String UItemp_invoice = "";
	
	public static String STATUS_CANCEL	= "00";
	public static String STATUS_PLAN_SUBMIT = "30";
	public static String STATUS_APPROVE	= "40";
	public static String STATUS_CLOSE_QT	= "50";	

	public static List<String[]> statusDropdown(){
		List<String[]> list = new ArrayList<String[]>();		
		list.add(new String[]{"30", "วางแผนแล้ว"});
		list.add(new String[]{"40", "ทำใบเสนอราคา"});
		return list;
	}
	
	public static String status(String status){
		HashMap<String , String> map = new HashMap<String, String>();
		map.put("00", "ยกเลิก");
		map.put("30", "วางแผนแล้ว");
		map.put("40", "ทำใบเสนอราคา");
		map.put("50", "อนุมัติใบ QT");
		return map.get(status);
	}
	
	
	public String getUItemp_invoice() {
		return UItemp_invoice;
	}

	public void setUItemp_invoice(String uItemp_invoice) {
		UItemp_invoice = uItemp_invoice;
	}

	public String getUIinvoice() {
		return UIinvoice;
	}

	public void setUIinvoice(String uIinvoice) {
		UIinvoice = uIinvoice;
	}

	public SaleOrderItem getUIItem() {
		return UIItem;
	}
	
	public String getSend_by() {
		return send_by;
	}

	public void setSend_by(String send_by) {
		this.send_by = send_by;
	}

	public void setUIItem(SaleOrderItem uIItem) {
		UIItem = uIItem;
	}

	public Customer getUICustomer() {
		return UICustomer;
	}

	public void setUICustomer(Customer uICustomer) {
		UICustomer = uICustomer;
	}

	public Personal getUISale() {
		return UISale;
	}

	public void setUISale(Personal uISale) {
		UISale = uISale;
	}


	public String getOrder_id() {
		return order_id;
	}
	public void setOrder_id(String order_id) {
		this.order_id = order_id;
	}
	public String getQt_id() {
		return qt_id;
	}
	public void setQt_id(String qt_id) {
		this.qt_id = qt_id;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getCus_id() {
		return cus_id;
	}
	public void setCus_id(String cus_id) {
		this.cus_id = cus_id;
	}
	public String getCredit() {
		return credit;
	}
	public void setCredit(String credit) {
		this.credit = credit;
	}
	public String getRemark_date() {
		return remark_date;
	}
	public void setRemark_date(String remark_date) {
		this.remark_date = remark_date;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
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
	
	public static void insert(SaleQt entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		
		entity.setQt_id(DBUtility.genNumber(conn, tableName, "qt_id"));
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		entity.setUpdate_by("");
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	public static SaleQt select(SaleQt entity) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity,keys);
		conn.close();
		return entity;
	}
	
	public static SaleQt selectQt_id(String qt_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		SaleQt qt = new SaleQt();
		qt.setQt_id(qt_id);
		DBUtility.getEntityFromDB(conn, tableName, qt,new String[] {"qt_id"});
		conn.close();
		return qt;
	}
	
	public static void update(SaleQt entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity,new String[] {"status","credit","remark_date","remark","send_by","update_date","update_by"},new String[] {"qt_id"});
		conn.close();
	}
	
	public static List<SaleQt> selectWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1";
		String m = "";
		String y = "";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (str[0].equalsIgnoreCase("year")){
					y = str[1];
				} else if (str[0].equalsIgnoreCase("month")) {
					m = str[1];
				} else {
					sql += " AND " + str[0] + "='" + str[1] + "'";
				}
			}
		}
	
		if (m.length() > 0) {
			Calendar sd = Calendar.getInstance();
			sd.clear();
			sd.set(Calendar.YEAR, Integer.parseInt(y));
			sd.set(Calendar.MONTH, Integer.parseInt(m) - 1);
			sd.set(Calendar.DATE, 1);
			
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			
			String s = df.format(sd.getTime());
			
			sd.add(Calendar.MONTH, +1);
			sd.add(Calendar.DATE, -1);
			String e = df.format(sd.getTime());
			
			sql += " AND (create_date between '" + s + " 00:00:00.00' AND '" + e + " 23:59:59.99')";
		} else {
			if (y.length() > 0) {
				sql += " AND (create_date between '" + y + "-01-01 00:00:00.00' AND '" + y + "-12-31 23:59:59.99')";
			}
		}
		
		sql += " ORDER BY order_id ASC";
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SaleQt> list = new ArrayList<SaleQt>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					SaleQt entity = new SaleQt();
					DBUtility.bindResultSet(entity, rs);
					entity.setUICustomer(Customer.select(entity.getCus_id(), conn));
					entity.setUISale(Personal.selectOnlyPerson(entity.getCreate_by(), conn));
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
	
	public static List<SaleQt> haveInvoiceWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT distinct(sale_order_item.qt_id),sale_qt.*,sale_order_item.invoice,sale_order_item.temp_invoice FROM " + tableName + ",sale_order_item WHERE 1=1 AND sale_order_item.qt_id = sale_qt.qt_id AND sale_order_item.status = '" + SaleOrderItem.STATUS_PRE_SEND + "'";
	
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if(str[0].equalsIgnoreCase("qt_id")){
					sql += " AND "+ tableName +"." + str[0] + "='" + str[1] + "'";
				}else{
					sql += " AND "+ Customer.tableName +"." + str[0] + "='" + str[1] + "'";
				}
					
			}
		}
		
		sql += " ORDER BY sale_qt.qt_id ASC";
	//	System.out.println(sql);
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SaleQt> list = new ArrayList<SaleQt>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					SaleQt entity = new SaleQt();
					DBUtility.bindResultSet(entity, rs);
					entity.setUICustomer(Customer.select(entity.getCus_id(), conn));
					entity.setUISale(Personal.selectOnlyPerson(entity.getCreate_by(), conn));
					entity.setUIinvoice(DBUtility.getString("invoice", rs));
					entity.setUItemp_invoice(DBUtility.getString("temp_invoice", rs));
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

	public static void approverQt(SaleQt entity,Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity,new String[] {"status","update_date","update_by"},new String[] {"qt_id"});
	}
	
	public static void updateQt(SaleQt entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity,new String[] {"status","update_date","update_by"},keys);	
		conn.close();

	}
	
}
