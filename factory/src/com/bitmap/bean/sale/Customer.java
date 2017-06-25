package com.bitmap.bean.sale;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.utils.CalendarEvent;
import com.bitmap.webutils.PageControl;

public class Customer {
	public static String tableName = "sale_customer";
	private static String[] keys = {"cus_id"};
	private static String[] fieldNames = {"cus_name","cus_tax","cus_phone","cus_fax","cus_address","province_id","zip_code","cus_country","cus_email",
		  "cus_contact","cus_ship","cus_condition","cus_credit","cus_discount","send_by","update_by","update_date"};
	
	String cus_id = "";
	String cus_name = "";
	String cus_tax	= "";
	String cus_phone = "";
	String cus_fax = "";
	String cus_address = "";
	String province_id = "";
	String zip_code = "";
	String cus_country = "";
	String cus_email = "";
	String cus_contact = "";
	String cus_ship = "";
	String cus_condition = "";
	String cus_credit = "";
	String cus_discount = "";
	String send_by = "";
	String create_by = "";
	Timestamp create_date = null;
	String update_by = "";
	Timestamp update_date = null;
	
	Province UIPro = new Province();
	Zipcode UIZip = new Zipcode();
	
	
	public static void insert(Customer entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setCus_id(DBUtility.genNumber(conn, tableName, "cus_id"));
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	public static void update(Customer entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();
	}
	
	public static Customer select(Customer entity) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		entity.setUIPro(Province.select(entity.getProvince_id(), conn));
		entity.setUIZip(Zipcode.select(entity.getZip_code(), conn));
		conn.close();
		return entity;
	}
	
	public static Customer select(String cus_id) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Customer entity = new Customer();
		entity.setCus_id(cus_id);
		return select(entity);
	}
	
	public static Customer select(String cus_id, Connection conn) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Customer entity = new Customer();
		entity.setCus_id(cus_id);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		return entity;
	}
	
	public static String name(String cus_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Customer entity = new Customer();
		entity.setCus_id(cus_id);
		entity = select(entity);
		return entity.getCus_name();
	}
	
	public static List<String[]> selectList() throws SQLException{
		Connection conn =DBPool.getConnection();
		List<String[]> list = DBUtility.getDropDownListData(conn, tableName, "cus_id", "cus_name", "cus_id");
		conn.close();
		return list;
	}
	
	public static List<String[]> combobox(String status) throws SQLException{
		Connection conn =DBPool.getConnection();
		List<String[]> l = new ArrayList<String[]>();
		String sql = "select DISTINCT(sale_customer.cus_id),sale_customer.* from sale_customer,production,sale_order_item,sale_order ";
		sql += "where production.status = ? and production.item_run = sale_order_item.item_run ";
		sql += "and sale_order.order_id = sale_order_item.order_id and sale_order.cus_id = sale_customer.cus_id";
		PreparedStatement ps = conn.prepareStatement(sql);
		ps.setString(1,status);
		ResultSet rs = ps.executeQuery();
		while(rs.next()){
			String id = DBUtility.getString("cus_id", rs);
			String name = DBUtility.getString("cus_name", rs);
			String[] vals = {id,name};
			l.add(vals);
		}
		rs.close();
		ps.close();
		conn.close();
		return l;
	}
	
	public static List<String[]> namecus(String status) throws SQLException{
		Connection conn =DBPool.getConnection();
		List<String[]> l = new ArrayList<String[]>();
		String sql = "select DISTINCT(sale_qt.cus_id),sale_customer.* from sale_customer,sale_qt ";
		sql += "where sale_qt.status = ? and sale_qt.cus_id = sale_customer.cus_id";
		PreparedStatement ps = conn.prepareStatement(sql);
		ps.setString(1,status);
		ResultSet rs = ps.executeQuery();
		while(rs.next()){
			String id = DBUtility.getString("cus_id", rs);
			String name = DBUtility.getString("cus_name", rs);
			String[] vals = {id,name};
			l.add(vals);
		}
		rs.close();
		ps.close();
		conn.close();
		return l;
	}
	
	public static List<String[]> namecusinv() throws SQLException{
		Connection conn =DBPool.getConnection();
		
		String sql = " SELECT DISTINCT c.cus_id ,c.cus_name  ";
		sql += " FROM sale_order_item a ";
		sql += " LEFT JOIN sale_order o    on a.order_id = o.order_id  and YEAR(o.create_date) < 2014 ";
		sql += " LEFT JOIN sale_customer c on o.cus_id = c.cus_id  ";
		sql += " WHERE  o.cus_id is not null ";
		sql += " AND  YEAR(a.update_date) < YEAR(CURDATE())-1  ";
		sql += " AND (a.status = '" + SaleOrderItem.STATUS_PRE_SEND + "' OR a.status = '" + SaleOrderItem.STATUS_TMP_INVOICE + "')";
		sql += " ORDER BY (c.cus_id*1)  ";
		sql += " LIMIT 0,1000 ";
		//= "SELECT DISTINCT(sale_customer.cus_id),sale_customer.cus_name FROM sale_customer,sale_order,sale_order_item WHERE sale_customer.cus_id = sale_order.cus_id";
		//sql += " AND sale_order.order_id = sale_order_item.order_id AND (sale_order_item.status = '" + SaleOrderItem.STATUS_PRE_SEND + "' OR sale_order_item.status = '" + SaleOrderItem.STATUS_TMP_INVOICE + "')";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		//System.out.println(sql);
		List<String[]> l = new ArrayList<String[]>();
		while(rs.next()){
			String id = DBUtility.getString("c.cus_id", rs);
			String name = DBUtility.getString("c.cus_name", rs);
			String[] vals = {id,name};
			l.add(vals);
		}
		rs.close();
		st.close();
		conn.close();
		return l;
	}
	
	public static List<String[]> namecusinvStatus() throws SQLException{
		Connection conn =DBPool.getConnection();
		
		String sql = "SELECT DISTINCT(sale_customer.cus_id),sale_customer.cus_name FROM sale_customer,sale_order WHERE sale_customer.cus_id = sale_order.cus_id";
		sql += " AND (sale_order.status = '" + SaleOrder.STATUS_PLAN_SUBMIT + "' OR sale_order.status = '" + SaleOrder.STATUS_SEND_QT + "')";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		List<String[]> l = new ArrayList<String[]>();
		while(rs.next()){
			String id = DBUtility.getString("sale_customer.cus_id", rs);
			String name = DBUtility.getString("sale_customer.cus_name", rs);
			String[] vals = {id,name};
			l.add(vals);
		}
		rs.close();
		st.close();
		conn.close();
		return l;
	}
	
	public static String creditTocalendar(String cus_id) throws SQLException{
		Connection conn =DBPool.getConnection();
		
		String sql = "SELECT * FROM " + tableName + " WHERE cus_id = '" + cus_id + "'";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		String aa = "";
		while(rs.next()){
			
		}
		rs.close();
		st.close();
		conn.close();
		return aa;
	}
	
	public static List<Customer> selectWithCTRL(PageControl ctrl, List<String[]> param) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1";
		
		for (Iterator<String[]> iterator = param.iterator(); iterator.hasNext();) {
			String[] pm = (String[]) iterator.next();
			if (pm[1].length() > 0) {
				sql += " AND " + pm[0] + " like '%" + pm[1] + "%'";
			}
		}
		
		sql += " ORDER BY (cus_id*1)";
		sql += " LIMIT 500 ";
		//System.out.println(sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Customer> list = new ArrayList<Customer>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					Customer entity = new Customer();
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

	public static String ship(String status){
		HashMap<String , String> map = new HashMap<String, String>();
		map.put("land", "ทางบก");
		map.put("sea", "ทางเรือ");
		map.put("air", "ทางอากาศ");
		return map.get(status);
	}
	
	public String getCus_id() {
		return cus_id;
	}
	public void setCus_id(String cus_id) {
		this.cus_id = cus_id;
	}
	public String getCus_name() {
		return cus_name;
	}
	public void setCus_name(String cus_name) {
		this.cus_name = cus_name;
	}
	public String getCus_phone() {
		return cus_phone;
	}
	public void setCus_phone(String cus_phone) {
		this.cus_phone = cus_phone;
	}
	public String getCus_fax() {
		return cus_fax;
	}
	public void setCus_fax(String cus_fax) {
		this.cus_fax = cus_fax;
	}
	public String getCus_address() {
		return cus_address;
	}
	public void setCus_address(String cus_address) {
		this.cus_address = cus_address;
	}
	public String getCus_email() {
		return cus_email;
	}
	public void setCus_email(String cus_email) {
		this.cus_email = cus_email;
	}
	public String getCus_contact() {
		return cus_contact;
	}
	public void setCus_contact(String cus_contact) {
		this.cus_contact = cus_contact;
	}
	public String getCus_ship() {
		return cus_ship;
	}
	public void setCus_ship(String cus_ship) {
		this.cus_ship = cus_ship;
	}
	public String getCus_condition() {
		return cus_condition;
	}
	public void setCus_condition(String cus_condition) {
		this.cus_condition = cus_condition;
	}
	public String getCus_credit() {
		return cus_credit;
	}
	public void setCus_credit(String cus_credit) {
		this.cus_credit = cus_credit;
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

	public String getCus_tax() {
		return cus_tax;
	}

	public void setCus_tax(String cus_tax) {
		this.cus_tax = cus_tax;
	}

	public String getCus_country() {
		return cus_country;
	}

	public void setCus_country(String cus_country) {
		this.cus_country = cus_country;
	}

	public String getCus_discount() {
		return cus_discount;
	}

	public void setCus_discount(String cus_discount) {
		this.cus_discount = cus_discount;
	}

	public String getProvince_id() {
		return province_id;
	}

	public void setProvince_id(String province_id) {
		this.province_id = province_id;
	}

	public String getZip_code() {
		return zip_code;
	}

	public void setZip_code(String zip_code) {
		this.zip_code = zip_code;
	}

	public Province getUIPro() {
		return UIPro;
	}

	public void setUIPro(Province uIPro) {
		UIPro = uIPro;
	}

	public Zipcode getUIZip() {
		return UIZip;
	}

	public void setUIZip(Zipcode uIZip) {
		UIZip = uIZip;
	}

	public String getSend_by() {
		return send_by;
	}

	public void setSend_by(String send_by) {
		this.send_by = send_by;
	}
	
	
	
}