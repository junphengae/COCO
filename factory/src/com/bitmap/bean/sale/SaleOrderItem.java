package com.bitmap.bean.sale;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import org.eclipse.jdt.internal.compiler.ast.ThisReference;

import com.bitmap.bean.hr.Personal;
import com.bitmap.bean.inventory.InventoryMaster;
import com.bitmap.bean.logistic.LogisSend;
import com.bitmap.bean.logistic.P_number;
import com.bitmap.bean.logistic.SendProduct;
import com.bitmap.bean.rd.MatTree;
import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.utils.CalendarEvent;
import com.bitmap.utils.Money;
import com.bitmap.webutils.PageControl;

public class SaleOrderItem {
	public static String tableName = "sale_order_item";
	private static String[] keys = {"order_id","item_id","item_type","item_run"};
	static String[] fieldNames = {"invoice","item_id","item_type","item_qty","unit_price","discount","remark","request_date","update_by","update_date","temp_invoice"};
	
	public static String STATUS_CANCEL = "999";
	public static String STATUS_SALE_CREATE = "10";
	public static String STATUS_WAIT_PLAN_SUBMIT = "20";
	public static String STATUS_PLAN_SUBMIT = "30";
	public static String STATUS_SEND_QT = "40";
	public static String STATUS_NOT_AP_YET = "45";
	public static String STATUS_PRODUCE = "50";
	public static String STATUS_NO_PRODUCE = "60";
	public static String STATUS_CLOSE_QT	= "70";
	public static String STATUS_IN_STORE	= "71";
	public static String STATUS_PRE_SEND	= "72";
	public static String STATUS_INVOICE		= "73";
	public static String STATUS_TMP_INVOICE	= "74";
	public static String STATUS_OUTLET	= "80";
	public static String STATUS_SEND_PRODUCT = "90";
	public static String STATUS_END	= "100";
	
	public static String TYPE_PROMOTION = "p";
	public static String TYPE_FG = "s";
	
	public static List<String[]> statusDropdown(){
		List<String[]> list = new ArrayList<String[]>();
		
		list.add(new String[]{"10", "กำลังสร้าง"});
		list.add(new String[]{"20", "รอวางแผน"});
		list.add(new String[]{"30", "วางแผนแล้ว"});	
		return list;
	}
	
	public static String status(String status){
		HashMap<String , String> map = new HashMap<String, String>();
		map.put("999", "ยกเลิก");
		map.put("10", "กำลังสร้าง");
		map.put("20", "รอวางแผน");
		map.put("30", "วางแผนแล้ว");
		map.put("40", "รออนุมัติใบเสนอราคา");
		map.put("45", "อนุมัติแต่ยังไม่ผลิต");
		map.put("50", "รอสั่งผลิต");
		map.put("60", "รอเปิดผลิต");
		map.put("70", "รอของเข้า store");
		map.put("71", "ของอยู่ใน store");
		map.put("72", "รอออกใบ INVOICE");
		map.put("73", "ออกใบ INVOICE แล้ว");
		map.put("74", "รอออก INVOICE จริง");
		map.put("80", "เบิกของแล้ว");
		map.put("90", "กำลังส่ง");
		map.put("100","ปิดการขาย");
		return map.get(status);
	}
	
	public static List<CalendarEvent> calendarPlan() throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE status='" + STATUS_PLAN_SUBMIT + "' OR status='" + STATUS_PRODUCE + "'";
		
		List<CalendarEvent> list = new ArrayList<CalendarEvent>();
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			SaleOrderItem entity = new SaleOrderItem();
			DBUtility.bindResultSet(entity, rs);
			
			entity.setUIMat(InventoryMaster.select(entity.getItem_id(), conn));
			entity.setUIPac(Package.select(entity.getItem_id(), conn));
			entity.setUIOrder(SaleOrder.selectByID(entity.getOrder_id()));
			
			CalendarEvent cal = new CalendarEvent();
			cal.setId(entity.getItem_run());
			cal.setAllDay(false);
			
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.ENGLISH);
			
			if (entity.getStatus().equals(STATUS_PLAN_SUBMIT)) {
				if (entity.getItem_type().equals(TYPE_PROMOTION)) {
					cal.setTitle("Order: " + entity.getOrder_id() + " - " + entity.getUIPac().getPk_id() + " " + entity.getUIPac().getName());
				} else {
					cal.setTitle("Order: " + entity.getOrder_id() + " - " + entity.getItem_id() + " " + entity.getUIMat().getDescription());
				}
				cal.setBackgroundColor("#DF8B98");
				cal.setBorderColor("#DF8B98");
				cal.setStart(df.format(entity.getStart_date()));
				cal.setEnd(entity.getConfirm_date());
			}
			
			if (entity.getStatus().equals(STATUS_PRODUCE)) {
				if (entity.getItem_type().equals(TYPE_PROMOTION)) {
					cal.setTitle("QT: " + entity.getQt_id() + " - " + entity.getUIPac().getPk_id() + " " + entity.getUIPac().getName());
				} else {
					cal.setTitle("QT: " + entity.getQt_id() + " - " + entity.getItem_id() + " " + entity.getUIMat().getDescription());
				}
				cal.setBackgroundColor("#0059FF");
				cal.setBorderColor("#0059FF");
				cal.setStart(df.format(entity.getStart_date()));
				cal.setEnd(entity.getConfirm_date());
			}
			
			list.add(cal);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	String order_id = "";
	String item_run = "";
	String po = "";
	String qt_id = "";
	String invoice = "";
	String item_id = "";
	String item_type = "";
	String item_qty = "";
	String unit_price = "";
	String discount = "";
	String remark = "";
	Date request_date = null;
	Date start_date = null;
	Date confirm_date = null;
	String confirm_by = "";
	Date delivery_date = null;
	String status = "";
	String update_by = "";
	Timestamp update_date = null;
	String temp_invoice = "";
	Date regis_inv = null;
	Date fin_inv = null;
	Date fin_tmp = null;
	String rmk_plan = "";
	String delivery_flag = "0";
	
	InventoryMaster UIMat = new InventoryMaster();
	Package UIPac = new Package();
	SaleOrder UIOrder = new SaleOrder();
	
	
	String UINameCus = "";
	String UIOrderType = "";
	String UIPacName = "";
	String UIMatName = "";
	String UIMatType = "";
	String UISumAll = "";
	String UISumPrp = "";
	
	

	public static List<SaleOrderItem> selectQt(String order_id,String qt_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE order_id='" + order_id + "' and qt_id='" + qt_id +"' and status <>'" + STATUS_CANCEL + "'";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SaleOrderItem> list = new ArrayList<SaleOrderItem>();
		while (rs.next()) {
			SaleOrderItem entity = new SaleOrderItem();
			DBUtility.bindResultSet(entity, rs);
			if(entity.getItem_type().equalsIgnoreCase("s")){
				entity.setUIMat(InventoryMaster.select(entity.getItem_id(), conn));
			} else {
				entity.setUIPac(Package.select(entity.getItem_id(), conn));
			}
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<SaleOrderItem> selectWithCTRL(PageControl ctrl, List<String[]> paramList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		//String sql = "SELECT a.*,c.cus_name FROM " + tableName + " a,sale_order o,sale_customer c " +
		//"WHERE (a.status = '" + SaleOrderItem.STATUS_NOT_AP_YET + "' OR a.status = '" + SaleOrderItem.STATUS_SEND_QT + "')";

		String 	sql 	= " ";
				sql 	+= " SELECT a.order_id,a.item_run,a.po,a.qt_id,a.invoice,a.item_id,a.item_type,a.item_qty,a.unit_price,a.discount,a.remark,a.request_date,a.start_date,a.confirm_date, ";
				sql 	+= " a.confirm_by,a.delivery_date,a.status,a.regis_inv,a.fin_inv,a.fin_tmp,a.update_by,a.update_date,a.temp_invoice,a.rmk_plan,a.delivery_flag , c.cus_name  ";
				sql 	+= " FROM sale_order_item a  ";
				sql 	+= " LEFT JOIN sale_order o    on a.order_id = o.order_id ";
				sql 	+= " LEFT JOIN sale_customer c on o.cus_id = c.cus_id     ";
				sql 	+= " WHERE (a.status = '" + SaleOrderItem.STATUS_NOT_AP_YET + "' OR a.status = '" + SaleOrderItem.STATUS_SEND_QT + "')";
						
		Iterator<String[]> ite = paramList.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {		
				if(str[0].equalsIgnoreCase("cus_name")){
					sql += "AND c.cus_name LIKE '%" + str[1] + "%'";
				}else{
					sql += " AND a." + str[0] + "='" + str[1] + "'";
				}
			}
		}
	
		
		//sql += " AND o.order_id = a.order_id AND o.cus_id = c.cus_id  ORDER BY (a.qt_id*1) DESC";
			sql += " ORDER BY (a.qt_id*1) DESC  ";
			sql += " LIMIT 0,1000 ";
		
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SaleOrderItem> list = new ArrayList<SaleOrderItem>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					SaleOrderItem entity = new SaleOrderItem();
					DBUtility.bindResultSet(entity, rs);
					entity.setUIMat(InventoryMaster.select(entity.getItem_id(), conn));
					if(entity.getItem_type().equalsIgnoreCase("p")){
						entity.setUIPac(Package.select(entity.getItem_id(), conn));
					}
					entity.setUIOrder(SaleOrder.selectByID(entity.getOrder_id()));
					entity.setUINameCus(rs.getString("cus_name"));
					list.add(entity);
				}
				cnt++;
			}
		}
		rs.close();
		st.close();
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		conn.close();
		return list;
	}
	
	public static List<SaleOrderItem> selectInvWithCTRL(PageControl ctrl, List<String[]> paramList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		
		//String sql = "SELECT * FROM " + tableName + " WHERE 1=1 AND (invoice != '' OR temp_invoice != '') AND status = '" + SaleOrderItem.STATUS_END + "'";
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1 AND (invoice != '' OR temp_invoice != '')";
		
		Iterator<String[]> ite = paramList.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {	
					sql += " AND (" + str[0] + "='" + str[1] + "' OR temp_invoice = '" + str[1] + "')";
			}
		}
		
		sql += " ORDER BY (invoice*1) ASC";
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SaleOrderItem> list = new ArrayList<SaleOrderItem>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					SaleOrderItem entity = new SaleOrderItem();
					DBUtility.bindResultSet(entity, rs);
					entity.setUIOrder(SaleOrder.selectByID(entity.getOrder_id()));
					entity.setUICustomer(Customer.select(entity.getUIOrder().getCus_id()));
					
					if(entity.getItem_type().equalsIgnoreCase("s")){
					InventoryMaster mat =  InventoryMaster.select(entity.getItem_id(), conn);
					entity.setUIMatName(mat.getDescription());
					}else{
						Package pac = new Package();
						pac = Package.select(entity.getItem_id(), conn);
						entity.setUIPacName(pac.getName());
					}
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
	
	public static void updateQt(SaleOrderItem entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();	
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity,new String[] {"qt_id","update_date","update_by"},new String[] {"item_id","item_run","order_id"});
		conn.close();
	}
	
	public static void updatePrice(SaleOrderItem entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity,new String[] {"unit_price","update_date","update_by"},new String[] {"item_id","item_run","order_id","qt_id"});
		conn.close();
	}
	
	public static void updateDiscount(SaleOrderItem entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity,new String[] {"discount","update_date","update_by"},new String[] {"item_run"});
		conn.close();
	}
	
	public static void editPlan(SaleOrderItem entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity,new String[] {"start_date","confirm_date","remark","update_date","update_by"},new String[] {"item_run"});
		conn.close();
	}
	
	public static void insertItem(SaleOrderItem entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		
		SaleOrder order =  SaleOrder.selectByID(entity.getOrder_id());
		
		if(order.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_25)){
			entity.setStart_date(order.getDue_date());
			entity.setConfirm_date(order.getDue_date());
		}
		// Modify 21-07-2011
		//entity.setItem_run(DBUtility.genNumberFromDB(conn, tableName, entity, new String[] {"order_id"},"item_run"));
		entity.setItem_run(DBUtility.genNumber(conn, tableName, "item_run"));
		entity.setStatus(STATUS_SALE_CREATE);
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	public static void insertPromotion(SaleOrderItem entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		
		// Modify 21-07-2011 by wan
		//entity.setItem_run(DBUtility.genNumberFromDB(conn, tableName, entity, new String[] {"order_id"},"item_run"));
		SaleOrder order =  SaleOrder.selectByID(entity.getOrder_id());
		if(order.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_25)){
			entity.setStart_date(order.getDue_date());
			entity.setConfirm_date(order.getDue_date());
		}
		
		entity.setItem_run(DBUtility.genNumber(conn, tableName, "item_run"));
		entity.setStatus(STATUS_SALE_CREATE);	
		
		Package price = Package.select(entity.getItem_id(), conn);		
		entity.setUnit_price(price.getPrice());

		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	public static List<SaleOrderItem> select_ap_item(PageControl ctrl, List<String[]> paramList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException, ParseException{
		String sql = "SELECT " + tableName + ".* FROM " + tableName + ",sale_order,sale_customer," + InventoryMaster.tableName + " WHERE " + tableName + ".status = '"+ STATUS_PRODUCE + "' AND sale_order.order_id = sale_order_item.order_id";
		sql += " AND sale_order.cus_id = sale_customer.cus_id AND " + tableName + ".item_id = " + InventoryMaster.tableName + ".mat_code";
		Iterator<String[]> ite = paramList.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if(str[0].equalsIgnoreCase("request_date") || str[0].equalsIgnoreCase("start_date")){
						Date b = DBUtility.getDate(str[1]);
						
						SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
						
						String s = df.format(b);
						sql += " AND (" + tableName + "." + str[0] + " between '" + s + " 00:00:00.00' AND '" + s + " 23:59:59.99')";
						
				} else if(str[0].equalsIgnoreCase("cus_name")){
					sql += " AND sale_customer." + str[0] + " LIKE '%" + str[1] + "%'";
				} else if(str[0].equalsIgnoreCase("order_type")) {
					sql += " AND sale_order." + str[0] + "='" + str[1] + "'";
				} else if(str[0].equalsIgnoreCase("description")){
					//TODO หวานรับ parameter เพิ่ม 1 ตัว ชื่อว่า description ที่หน้า JSP ด้วยนะ
					sql += " AND " + InventoryMaster.tableName + "." + str[0] + " LIKE '%" + str[1] + "%'";
				} else {
					sql += " AND " + tableName + "." + str[0] + "='" + str[1] + "'";
				}
					
			}
		}
		sql += " ORDER BY (sale_order_item.item_run*1) DESC";
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SaleOrderItem> list = new ArrayList<SaleOrderItem>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					SaleOrderItem entity = new SaleOrderItem();
					DBUtility.bindResultSet(entity, rs);
					if(entity.getItem_type().equalsIgnoreCase("s")){
						entity.setUIMat(InventoryMaster.select(entity.getItem_id(), conn));
					} else {
						entity.setUIPac(Package.select(entity.getItem_id(), conn));
					}
					entity.setUIOrder(SaleOrder.selectByID(entity.getOrder_id()));
					
					entity.setUINameCus(entity.getUIOrder().getUICustomer().getCus_name());
					list.add(entity);
				}
				cnt++;
			}
		}
		rs.close();
		st.close();
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		conn.close();
		return list;
	}
	
	public static List<SaleOrderItem> select(String order_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE order_id='" + order_id + "'";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SaleOrderItem> list = new ArrayList<SaleOrderItem>();
		while (rs.next()) {
			SaleOrderItem entity = new SaleOrderItem();
			DBUtility.bindResultSet(entity, rs);
			if(entity.getItem_type().equalsIgnoreCase("s")){
				entity.setUIMat(InventoryMaster.select(entity.getItem_id(), conn));
			} else {
				entity.setUIPac(Package.select(entity.getItem_id(), conn));
			}
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	
	public static List<SaleOrderItem> selectQt(String order_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT DISTINCT qt_id FROM " + tableName + " WHERE order_id='" + order_id + "' AND status <> '" + STATUS_CANCEL + "'";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SaleOrderItem> list = new ArrayList<SaleOrderItem>();
		while (rs.next()) {
			SaleOrderItem entity = new SaleOrderItem();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<SaleOrderItem> selectNotQt(String order_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE order_id='" + order_id + "' and qt_id =''";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SaleOrderItem> list = new ArrayList<SaleOrderItem>();
		while (rs.next()) {
			SaleOrderItem entity = new SaleOrderItem();
			DBUtility.bindResultSet(entity, rs);
			if(entity.getItem_type().equalsIgnoreCase("s")){
				entity.setUIMat(InventoryMaster.select(entity.getItem_id(), conn));
			} else {
				entity.setUIPac(Package.select(entity.getItem_id(), conn));
			}
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static void selectItem(SaleOrderItem order) throws Exception{
		String sql = "SELECT * FROM " + tableName + " WHERE qt_id ='" + order.getQt_id() + "' AND status = '" + STATUS_PLAN_SUBMIT +"'";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			SaleOrderItem entity = new SaleOrderItem();
			DBUtility.bindResultSet(entity, rs);
			SaleOrderItem.update4QT(entity);
		}
		
		boolean cancel = checkCancel(order.getOrder_id(),SaleOrderItem.STATUS_SEND_QT, conn);
		if (cancel) {
			SaleOrder orders = new SaleOrder();
			orders.setOrder_id(order.getOrder_id());
			orders.setStatus(SaleOrder.STATUS_SEND_QT);
			orders.setUpdate_by(order.getUpdate_by());
			SaleOrder.updateStatus(conn,orders);
		}
		
		rs.close();
		st.close();
		conn.close();
	}
	
	public static SaleOrderItem select(SaleOrderItem entity) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity,new String[] {"item_run"});
		entity.setUIMat(InventoryMaster.select(entity.getItem_id()));
		conn.close();
		return entity;
	}
	/**
	 * whan : plan_sale_fg
	 * <br>
	 * select by item_run
	 * @param entity
	 * @return
	 * @throws SQLException
	 * @throws IllegalArgumentException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static SaleOrderItem selectrun(SaleOrderItem entity) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity,new String[] {"item_run"});
		conn.close();
		return entity;
	}
	
	public static SaleOrderItem selectOrder(String item_run) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		SaleOrderItem entity = new SaleOrderItem();
		entity.setItem_run(item_run);
		DBUtility.getEntityFromDB(conn, tableName, entity,new String[] {"item_run"});
		conn.close();
		return entity;
	}
	
	public static SaleOrderItem selectPac(SaleOrderItem entity) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity,new String[] {"order_id","item_id"});
		entity.setUIPac(Package.select(entity.getItem_id(), conn));
		conn.close();
		return entity;
	}
	
	public static void update(SaleOrderItem entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();
	}
	
	public static void updateDate(SaleOrderItem entity) throws Exception{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setStatus(STATUS_PLAN_SUBMIT);
		DBUtility.updateToDB(conn, tableName, entity,new String[] {"update_date","confirm_by","rmk_plan","start_date","confirm_date","status"},keys);
		
		boolean cancel = checkCancel(entity.getOrder_id(),entity.getStatus(), conn);
		if (cancel) {
			SaleOrder order = new SaleOrder();
			order.setOrder_id(entity.getOrder_id());
			SaleOrder.select(order, conn);
			order.setUpdate_by(entity.getConfirm_by());
			
			if(order.getOrder_type().equalsIgnoreCase(SaleOrder.TYPE_BUFFER)){
				order.setStatus(SaleOrder.STATUS_CLOSE_QT);
				
				entity.setStatus(SaleOrderItem.STATUS_PRODUCE);
				entity.setUpdate_by(entity.getConfirm_by());
				SaleOrderItem.updateStatusByInv(conn,entity,"order_id");
			}else{
				order.setStatus(SaleOrder.STATUS_PLAN_SUBMIT);
			}
			SaleOrder.updateStatus(conn,order);
		}
		
		conn.close();
	}
	
	public static void updatePromotion(SaleOrderItem entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setStatus(STATUS_PLAN_SUBMIT);
		DBUtility.updateToDB(conn, tableName, entity,new String[] {"request_date","item_qty","remark","update_by","update_date","status"}, keys);
		conn.close();
		
	}
	
	public static void update4QT(SaleOrderItem entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();		
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setStatus(STATUS_SEND_QT);
		DBUtility.updateToDB(conn, tableName, entity,new String[] {"status","update_date","update_by"},new String[] {"qt_id","item_id"});
		
		conn.close();
	}
	
	public static void updateWaitPlan(Connection conn,SaleOrderItem entity) throws Exception{
		//Connection conn = DBPool.getConnection();	
		try {
			entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
			DBUtility.updateToDB(conn, tableName, entity,new String[] {"status","update_date","update_by"},new String[] {"order_id"});
			
		} catch (Exception e) {
			if (conn != null) {
				conn.rollback();
				conn.close();
			}
			throw new Exception(e.getMessage());
		}finally{
			
		}
		
	}
	
	public static void updateStatusByItemrun(SaleOrderItem entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();		
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity,new String[] {"status","update_date","update_by"},new String[] {"item_run"});
		conn.close();
	}
	/**
	 * Use: SaleManage.del_item_all
	 * <br>
	 * change status to STATUS_CANCEL 
	 * if all item are cancel so sale_order change status to cancel
	 * @param entity
	 * @return
	 * @throws Exception 
	 */
	public static boolean updateItem(SaleOrderItem entity) throws Exception{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		String status = entity.getStatus();
		
		entity.setStatus(STATUS_CANCEL);
		DBUtility.updateToDB(conn, tableName, entity,new String[] {"status","update_date","update_by"},new String[] {"order_id","qt_id","item_run"});
		
		String sql = "SELECT count(*) cnt FROM " + tableName + " WHERE status !='" + STATUS_CANCEL + "' AND status = '" + status + "' AND order_id='" + entity.getOrder_id() + "'";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
				boolean isStatus = false;
		
		if (rs.next()) {
			if(DBUtility.getString("cnt", rs).equalsIgnoreCase("0")) {
				isStatus = true;
			}
		}
		rs.close();
		st.close();
		
		if (isStatus) {
			SaleOrder order = new SaleOrder();
			order.setOrder_id(entity.getOrder_id());
			order.setStatus(STATUS_CANCEL);
			order.setUpdate_by(entity.getUpdate_by());
			SaleOrder.updateStatus(conn,order);
		}		
		conn.close();
		return isStatus;
	}
	

	
	public static boolean checkCancel(String order_id,String status, Connection conn) throws SQLException{
		String sql = "SELECT count(*) cnt FROM " + tableName + " WHERE status !='" + status + "' AND order_id='" + order_id + "'";
		
		//System.out.println(sql);
		if(status.equalsIgnoreCase(STATUS_PLAN_SUBMIT) || status.equalsIgnoreCase(STATUS_SEND_QT)){
			sql += " AND status != '00'";
		}
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		boolean isStatus = false;
		
		if (rs.next()) {
			if(DBUtility.getString("cnt", rs).equalsIgnoreCase("0")) {
				isStatus = true;
			}
		}
		rs.close();
		st.close();
		
		return isStatus;
	}
	
	public static void delete(SaleOrderItem entity) throws IllegalAccessException, InvocationTargetException, SQLException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection(); 	
		DBUtility.deleteFromDB(conn, tableName, entity, keys);	
		conn.close();
	}
	
	public static void delete(String order_id) throws IllegalAccessException, InvocationTargetException, SQLException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		SaleOrderItem entity = new SaleOrderItem();
		entity.setOrder_id(order_id);
		DBUtility.deleteFromDB(conn, tableName, entity,new String[]{"order_id"});	
		conn.close();
	}
	
	public static SaleOrderItem selectQty(SaleOrderItem entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();		
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"item_id","item_run"});
		conn.close();
		return entity;
	}
	
	public static void updateInvoice(Connection conn,SaleOrderItem entity,String type) throws Exception{
		//Connection conn = DBPool.getConnection();
		try {
			entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
			
			if(type.equalsIgnoreCase("tmp")){
				DBUtility.updateToDB(conn, tableName, entity,new String[] {"po","temp_invoice","status","update_date","update_by"},new String[] {"item_run"});
			}else{
				DBUtility.updateToDB(conn, tableName, entity,new String[] {"po","invoice","status","update_date","update_by"},new String[] {"item_run"});	
			}
			//conn.close();
			
			
		} catch (Exception e) {
			if (conn != null) {
				conn.rollback();
				conn.close();
			}
			throw new Exception(e.getMessage());
		}finally{
			
		}
	}
	
	public static void updateInvNoChangeStatus(SaleOrderItem entity,String type) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();		
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		if(type.equalsIgnoreCase("tmp")){
			DBUtility.updateToDB(conn, tableName, entity,new String[] {"temp_invoice","update_date","update_by"},new String[] {"item_run"});
		}else{
			DBUtility.updateToDB(conn, tableName, entity,new String[] {"invoice","update_date","update_by"},new String[] {"item_run"});	
		}
		conn.close();
	}

	public static void updateStatusByInv(Connection conn,SaleOrderItem entity,String type) throws Exception{
		//Connection conn = DBPool.getConnection();	
		try {
			entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
			DBUtility.updateToDB(conn, tableName, entity,new String[] {"status","update_date","update_by"},new String[] {type});
			//conn.close();
		} catch (Exception e) {
			if (conn != null) {
				conn.rollback();
				conn.close();
			}
			throw new Exception(e.getMessage());
		}finally{
			
		}
	}

	
	public static SaleOrderItem selectByInv(String invoice,Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException, UnsupportedEncodingException{
		String sql = "SELECT distinct(invoice),sale_order_item.* FROM " + tableName + " WHERE invoice='" + invoice + "'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		SaleOrderItem item = new SaleOrderItem();
		while (rs.next()) {
			DBUtility.bindResultSet(item, rs);
		}
		rs.close();
		st.close();
		return item;	
	}
	
	public static SaleOrderItem selectByInvShow(String invoice) throws IllegalAccessException, InvocationTargetException, SQLException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT distinct(invoice),sale_order_item.request_date FROM " + tableName + " WHERE invoice='" + invoice + "'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		//System.out.println(sql);
		SaleOrderItem item = new SaleOrderItem();
		while (rs.next()) {
			
			DBUtility.bindResultSet(item, rs);
		}
		rs.close();
		st.close();
		return item;	
	}
	
	/*public static Date Request_date(String invoice) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		SaleOrderItem item = new SaleOrderItem();
		item.setInvoice(invoice);
		item = selectByInvShow(invoice);
		return item.getRequest_date();
	}*/
	
	public static SaleOrderItem selectBytmpInv(String invoice,Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException, UnsupportedEncodingException{
		String sql = "SELECT distinct(temp_invoice),sale_order_item.* FROM " + tableName + " WHERE temp_invoice='" + invoice + "'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		SaleOrderItem item = new SaleOrderItem();
		while (rs.next()) {
			DBUtility.bindResultSet(item, rs);
		}
		rs.close();
		st.close();
		return item;	
	}
	
	public static List<PackageItem> listPackage(String pk_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT *,sum(qty) as sum_qty FROM " + tableName + " WHERE pk_id='" + pk_id + "' GROUP BY mat_code";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PackageItem> list = new ArrayList<PackageItem>();
		while (rs.next()) {
			PackageItem entity = new PackageItem();
			DBUtility.bindResultSet(entity, rs);
			entity.setUISumQty(DBUtility.getString("sum_qty", rs));
			entity.setUIMat(InventoryMaster.select(entity.getMat_code(), conn));
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}

	public static List<SaleOrderItem> waitInvoice(PageControl ctrl) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{

		String sql = "select * from " + tableName + " where status = '" + SaleOrderItem.STATUS_PRE_SEND + "' OR status = '" + SaleOrderItem.STATUS_TMP_INVOICE + "' ORDER BY (order_id*1) DESC";

		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		
		List<SaleOrderItem> list = new ArrayList<SaleOrderItem>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					SaleOrderItem entity = new SaleOrderItem();
					DBUtility.bindResultSet(entity, rs);
					
					SaleOrder order = new SaleOrder();
					order.setOrder_id(entity.getOrder_id());
					entity.setUIOrder(SaleOrder.select(order, conn));
					
					if(entity.getItem_type().equalsIgnoreCase("p")){
						Package pac = Package.select(entity.getItem_id(), conn);		
						entity.setUIPacName(pac.getName());
					}else{
						entity.setUIMatName(InventoryMaster.selectOnlyDesc(entity.getItem_id(), conn));
					}
					
					Customer cus = Customer.select(order.getCus_id(), conn);
					entity.setUINameCus(cus.getCus_name());
					list.add(entity);
				}
				cnt++;
			}
		}
		rs.close();
		st.close();
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		conn.close();
		return list;
	}
	
	public static void approverQt(SaleOrderItem entity) throws Exception{
		Connection conn = DBPool.getConnection();		
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity,new String[] {"po","status","update_date","update_by"},new String[] {"order_id","qt_id","item_run"});
		
		String sql = "SELECT count(*) cnt FROM " + tableName + " WHERE qt_id='" + entity.getQt_id() + "' AND status ='" + STATUS_SEND_QT + "'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		boolean isStatus = false;
		if (rs.next()) {
			if(DBUtility.getString("cnt", rs).equalsIgnoreCase("0")) {
				isStatus = true;
			}
		}
		if (isStatus) {
			SaleQt qt = new SaleQt();
			qt.setOrder_id(entity.getOrder_id());
			qt.setQt_id(entity.getQt_id());
			qt.setUpdate_by(entity.getUpdate_by());
			
			if(entity.getStatus().equalsIgnoreCase(SaleOrderItem.STATUS_NO_PRODUCE)){
				qt.setStatus(SaleOrderItem.STATUS_NOT_AP_YET);	
			}else{
				qt.setStatus(SaleQt.STATUS_CLOSE_QT);	
			}
			SaleQt.updateQt(qt);
			
			SaleOrder order = new SaleOrder();
			order.setOrder_id(entity.getOrder_id());
			order.setStatus(SaleOrder.STATUS_CLOSE_QT);
			SaleOrder.updateStatus(conn,order);
		}
		rs.close();
		st.close();	
		conn.close();
	}
	
	public static List<SaleOrderItem> haveInvoiceWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{

		String sql = "select distinct(invoice),order_id,status from sale_order_item where invoice not in (select invoice from detail_send WHERE type_inv = '10') and status = '" + SaleOrderItem.STATUS_INVOICE + "' AND invoice != ''";

		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SaleOrderItem> list = new ArrayList<SaleOrderItem>();
		while (rs.next()) {
			SaleOrderItem entity = new SaleOrderItem();
			DBUtility.bindResultSet(entity, rs);
			
			SaleOrder order = new SaleOrder();
			order.setOrder_id(entity.getOrder_id());
			SaleOrder.select(order, conn);
			Customer cus = Customer.select(order.getCus_id(), conn);
			entity.setUICustomer(cus);
			//System.out.println(entity.getUICustomer().getCus_name());
			list.add(entity);

		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<SaleOrderItem> haveInvoiceWithCTRL2(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{

		String sql = "select distinct(invoice),order_id,status,request_date from sale_order_item where invoice != ''";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			
			if (str[0].equalsIgnoreCase("invoice")){
				if (str[1].length()>0){
					sql += "AND distinct(invoice) LIKE '%" + str[1].trim() + "%' ";
				}
			}
			else{		
			if (str[1].length() > 0) {
						sql += " AND " + str[0] + "='" + str[1] + "'";				
				}	
			}
		}
		sql += " ORDER BY (request_date*1) DESC"; 
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		int min = (ctrl.getPage_num()-1)*ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page())-1;
		int cnt = 0;
		
		List<SaleOrderItem> list = new ArrayList<SaleOrderItem>();
		while (rs.next()) {
			
			if (cnt > max){cnt++;
			}else {
				if(cnt >= min){
						SaleOrderItem entity = new SaleOrderItem();
						DBUtility.bindResultSet(entity, rs);
						
						SaleOrder order = new SaleOrder();
						order.setOrder_id(entity.getOrder_id());
						entity.setUIOrder(SaleOrder.select(order, conn));
						Customer cus = Customer.select(order.getCus_id(), conn);
						entity.setUINameCus(cus.getCus_name());
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
	
	public static List<SaleOrderItem> havetmpInvoice(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{

		String sql = "select distinct(temp_invoice),order_id,status from sale_order_item where temp_invoice not in (select invoice from detail_send WHERE type_inv = '20') and status = '" + SaleOrderItem.STATUS_TMP_INVOICE + "'";

		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SaleOrderItem> list = new ArrayList<SaleOrderItem>();
		while (rs.next()) {
			SaleOrderItem entity = new SaleOrderItem();
			DBUtility.bindResultSet(entity, rs);
			
			SaleOrder order = new SaleOrder();
			order.setOrder_id(entity.getOrder_id());
			SaleOrder.select(order, conn);
			Customer cus = Customer.select(order.getCus_id(), conn);
			entity.setUICustomer(cus);
			list.add(entity);

		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<SaleOrderItem> havetmpInvoice2(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{

		String sql = "select distinct(temp_invoice),order_id,status,invoice from sale_order_item WHERE temp_invoice != ''";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
						sql += " AND " + str[0] + "='" + str[1] + "'";				
			}	
		}
		 sql += " LIMIT 0,1000 ";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SaleOrderItem> list = new ArrayList<SaleOrderItem>();
		while (rs.next()) {
			SaleOrderItem entity = new SaleOrderItem();
			DBUtility.bindResultSet(entity, rs);
			
			SaleOrder order = new SaleOrder();
			order.setOrder_id(entity.getOrder_id());
			entity.setUIOrder(SaleOrder.select(order, conn));
			Customer cus = Customer.select(order.getCus_id(), conn);
			entity.setUINameCus(cus.getCus_name());
			list.add(entity);

		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<SaleOrderItem> sal_invoiceWithCTRL(PageControl ctrl, List<String[]> paramList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT DISTINCT(sale_order_item.item_run),sale_order_item.order_id,sale_order_item.item_qty,sale_order_item.unit_price,sale_order_item.discount,sale_customer.cus_name,sale_customer.cus_credit,sale_order_item.temp_invoice,sale_order_item.po,sale_order_item.item_type,sale_order_item.item_id,sale_order_item.qt_id,sale_order.order_type,sale_order_item.status,sale_order_item.remark FROM " + tableName + ",sale_customer,sale_order WHERE 1=1 AND";
		sql += " (" + tableName+ ".status = '" + STATUS_PRE_SEND + "' OR " + tableName+ ".temp_invoice != '') AND " + tableName+ ".order_id = sale_order.order_id";
		sql += " AND sale_order.cus_id = sale_customer.cus_id AND sale_order_item.invoice = ''";

		Iterator<String[]> ite = paramList.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
					if(str[0].equalsIgnoreCase("cus_id")){
						sql += " AND sale_customer." + str[0] + "='" + str[1] + "'";
					}else{
						sql += " AND " + tableName + "." + str[0] + "='" + str[1] + "'";
					}
						
			}	
		}
		sql += " ORDER BY (qt_id*1) ASC";
		sql += " LIMIT 0,1000 ";
		
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SaleOrderItem> list = new ArrayList<SaleOrderItem>();
		while (rs.next()) {
					SaleOrderItem entity = new SaleOrderItem();
					DBUtility.bindResultSet(entity, rs);

					if(entity.getItem_type().equalsIgnoreCase("p")){
						Package pac = Package.select(entity.getItem_id(), conn);		
						entity.setUIPacName(pac.getName());
					}else{
						InventoryMaster mat = InventoryMaster.select(entity.getItem_id(), conn);
						entity.setUIMatName(mat.getDescription());
					}
					entity.setUINameCus(DBUtility.getString("cus_name", rs));
					
					SaleOrder order = new SaleOrder();
					order.setOrder_id(DBUtility.getString("order_id", rs));
					entity.setUIOrder(SaleOrder.select(order, conn));
					list.add(entity);
					
			}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static String countItemrun(String order_id,String status,Connection conn) throws SQLException{
		String sql = "SELECT COUNT(status) as count FROM " + tableName + " WHERE status = '" + status + "' AND order_id = '" + order_id + "'";
		//System.out.println(sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		String count = "";
		while (rs.next()) {
			count = DBUtility.getString("count", rs);
			//System.out.println(count);
		}
		rs.close();
		st.close();
		return count;
	}
	public static Boolean countStatus80(String run,Connection conn) throws SQLException{
		String sql = "select invoice,type_inv from detail_send where run = '" + run + "'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		boolean count = false;
		
		String aa = "";
		while (rs.next()) {
			String inv = DBUtility.getString("invoice", rs);
			String type = DBUtility.getString("type_inv", rs);
			
			if(type.equalsIgnoreCase("10")){
				aa = "invoice";
			}else{
				aa = "temp_invoice";
			}
			
			count = SaleOrderItem.check80(aa,inv);	
			if(count){
				//System.out.println("not 80 =  " + count);	
			}else{
				break;
			}
			//System.out.println("countStatus80 =" + count);
		}
		rs.close();
		st.close();
		return count;
	}

	public static boolean check80(String aa,String invoice) throws SQLException{
		Connection conn2 = DBPool.getConnection();
		String sql2 = "select status from " + tableName + " where " + aa + " = '" + invoice + "' ORDER BY (status*1) ASC";
		//System.out.println(sql2);
		Statement st2 = conn2.createStatement();
		ResultSet rs2 = st2.executeQuery(sql2);
		boolean check = false;
		if (rs2.next()) {
				if(DBUtility.getString("status", rs2).equalsIgnoreCase(SaleOrderItem.STATUS_OUTLET)){
					check = true;
				}else{
					check = false;	
				}
		}
		rs2.close();
		st2.close();
		conn2.close();
		return check;
	}
	
	public static String countAllrun(String order_id,Connection conn) throws SQLException{
		String sql = "SELECT COUNT(item_run) as count FROM " + tableName + " WHERE order_id = '" + order_id + "' AND status != '" + SaleOrderItem.STATUS_CANCEL + "'";
		//System.out.println(sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		String count = "";
		while (rs.next()) {
			count = DBUtility.getString("count", rs);
			//System.out.println(count);
		}
		rs.close();
		st.close();
		return count;
	}
	
	public static List<SaleOrderItem> SelectOrderID(String invoice,String type,Connection conn) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "";
		String a = "";
					if(type.equalsIgnoreCase(SendProduct.STATUS_havInv)){
						a = "invoice";				
					}else{
						a = "temp_invoice";	
					}	
					sql = "SELECT distinct(" + a + "),order_id,status FROM " + tableName + " WHERE " + a + "  = '" + invoice + "'";
					
		sql += " ORDER BY (" + a + "*1)  ASC";

		//System.out.println(sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SaleOrderItem> list = new ArrayList<SaleOrderItem>();	
		while (rs.next()) {
					SaleOrderItem entity = new SaleOrderItem();
					DBUtility.bindResultSet(entity, rs);
					list.add(entity);
		}
		rs.close();
		st.close();
		return list;
	}
	/**
	 * whan : SaleManage.add_invoice
	 * <br>
	 * update invoice และ กำหนดส่ง
	 * @param entity
	 * @param type
	 * @throws Exception 
	 */
	public static void checktemp(Connection conn,SaleOrderItem entity,String type) throws Exception{
		//Connection conn = DBPool.getConnection();
		try {

			String tmp = entity.getTemp_invoice();
			String inv = entity.getInvoice();
			System.out.println("add_invoice : checktemp_1");
			System.out.println("add_invoice : checktemp_Type Temp_invoice"+tmp);
			System.out.println("add_invoice : checktemp_Type Invoice :"+inv);
			String sql = "SELECT * FROM " + tableName + " WHERE item_run  = '" + entity.getItem_run() + "'";
			System.out.println(sql);
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			
			System.out.println("add_invoice : checktemp_2");
			if(rs.next()) {
				//เก็บค่าใบส่งของ
				SaleOrderItem item = new SaleOrderItem();
				DBUtility.bindResultSet(item, rs);
				
				String temp = DBUtility.getString("temp_invoice", rs);
				//ถ้าค่าที่ส่งมาเป็น อินวอย
				System.out.println("add_invoice : checktemp_3");
				if(type.equalsIgnoreCase("inv")){
					System.out.println("add_invoice : checktemp_4");
						entity.setInvoice(inv);
						System.out.println("add_invoice : checktemp_5");
						entity.setStatus(SaleOrderItem.STATUS_INVOICE); //73
						System.out.println("add_invoice : checktemp_6");
						if(!(temp.equalsIgnoreCase(""))){
							System.out.println("add_invoice : checktemp_7");
							Detailinv.updateRef_inv(inv,tmp);
							System.out.println("add_invoice : checktemp_8");
						}else{
							System.out.println("add_invoice : checktemp_9");
							if(item.getItem_type().equalsIgnoreCase("s")){
								System.out.println("add_invoice : checktemp_10");
								LogisSend send = new LogisSend();	
								System.out.println("add_invoice : checktemp_11");
								send.setItem_run(item.getItem_run());
								send.setInv(inv);
								send.setType_inv(Detailinv.STATUS_INV);
								send.setMat_code(item.getItem_id());
								send.setQty_all(item.getItem_qty());
								send.setCreate_by(entity.getUpdate_by());
								send.setSend_date(entity.getDelivery_date());
								send.setStatus(LogisSend.STATUS_WAIT);
								System.out.println("add_invoice : checktemp_12");
								LogisSend.insert(send);
								System.out.println("add_invoice :LogisSend.insert checktemp_13");
							}
							
						}
				}else{
						entity.setTemp_invoice(tmp);
						entity.setStatus(SaleOrderItem.STATUS_TMP_INVOICE); //74	
						if(item.getItem_type().equalsIgnoreCase("s")){
							LogisSend send = new LogisSend();	
							send.setItem_run(item.getItem_run());
							send.setInv(tmp);
							send.setType_inv(Detailinv.STATUS_TEMP);
							send.setMat_code(item.getItem_id());
							send.setQty_all(item.getItem_qty());
							send.setCreate_by(entity.getUpdate_by());
							send.setSend_date(entity.getDelivery_date());
							send.setStatus(LogisSend.STATUS_WAIT);
							LogisSend.insert(send);
						}
				}
				SaleOrderItem.updateInvoice(conn,entity,type);
			}	
			rs.close();
			st.close();
			//conn.close();
			
		} catch (Exception e) {
			if (conn != null) {
				conn.rollback();
				conn.close();
				
			}
			throw new Exception(e.getMessage());
		}finally{
			
		}
	}
	
	public static List<SaleOrderItem> selectOrderidByInvoice(String invoice,String type,Connection conn) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		String kum = "";
		if(type.equalsIgnoreCase("10")){
			kum = "invoice";
		}else{
			kum = "temp_invoice";
		}
		String sql = "SELECT distinct(order_id) FROM " + tableName + " WHERE " + kum +  " = '" + invoice + "'";
		//System.out.println(sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SaleOrderItem> list = new ArrayList<SaleOrderItem>();	
		while (rs.next()) {	
			SaleOrderItem item = new SaleOrderItem();
			DBUtility.bindResultSet(item, rs);
			list.add(item);
			
		}
		rs.close();
		st.close();

		return list;
	}
	
	public static List<String[]> qtid(String cus_id) throws SQLException{
		Connection conn =DBPool.getConnection();
		String sql = "SELECT distinct(sale_order_item.qt_id) FROM " + tableName + ",sale_customer,sale_order WHERE sale_order.order_id = sale_order_item.order_id";
		sql += " AND sale_order.cus_id = sale_customer.cus_id AND sale_customer.cus_id = '" + cus_id + "' AND (sale_order_item.status = '" + SaleOrderItem.STATUS_PRE_SEND  + "'";
		sql += " OR sale_order_item.status = '" + SaleOrderItem.STATUS_TMP_INVOICE + "')";
	
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		List<String[]> l = new ArrayList<String[]>();
		while(rs.next()){
			String id = DBUtility.getString("sale_order_item.qt_id", rs);
			String name = DBUtility.getString("sale_order_item.qt_id", rs);
			String[] vals = {id,name};
			l.add(vals);
		}
		rs.close();
		st.close();
		conn.close();
		return l;
	}
	/**
	 * Used : reportByinvoice
	 * select ตาม invoice
	 * @param ctrl
	 * @param params
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static List<SaleOrderItem> selectallitemByinvoice(List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{

		String sql = "select * from " + tableName + " where 1=1";

		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
						sql += " AND " + str[0] + "='" + str[1] + "'";				
			}	
		}
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		
		List<SaleOrderItem> list = new ArrayList<SaleOrderItem>();
		String sum = "0";
		
		while (rs.next()) {
			SaleOrderItem entity = new SaleOrderItem();
			DBUtility.bindResultSet(entity, rs);
			String discnt = "0";
			if (entity.getDiscount().length() > 0) {
				discnt = entity.getDiscount();
			}
			
			//String lod = Money.multiple("0.01",Money.subtract("100",entity.getDiscount()));
			if(entity.getItem_type().equalsIgnoreCase("p")){
				Package pac = Package.select(entity.getItem_id(), conn);		
				entity.setUIPacName(pac.getName());
				
				String aa = PackageItem.sumPriceFromPkid(entity.getItem_id());
				entity.setUISumPrp(aa);
				
				sum = Money.add(sum,Money.discount(entity.getUnit_price(),discnt));
			}else{
				InventoryMaster mat = InventoryMaster.select(entity.getItem_id(), conn);
				entity.setUIMatName(mat.getDescription());
				entity.setUIMatType(mat.getDes_unit());

				String discount = Money.discount(Money.multiple(entity.getItem_qty(),entity.getUnit_price()),discnt);
				sum = Money.add(sum,discount);
			}
			
			entity.setUISumAll(sum);
			list.add(entity);

		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<SaleOrderItem> selectinv(List<String[]> params) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
						sql += " AND " + str[0] + "='" + str[1] + "'";				
			}	
		}
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SaleOrderItem> list = new ArrayList<SaleOrderItem>();
		while(rs.next()){
			SaleOrderItem entity = new SaleOrderItem();
			DBUtility.bindResultSet(entity, rs);
			
			if(entity.getItem_type().equalsIgnoreCase("p")){
				Package pac = Package.select(entity.getItem_id(), conn);		
				entity.setUIPacName(pac.getName());
			}else{
				InventoryMaster mat = InventoryMaster.select(entity.getItem_id(), conn);
				entity.setUIMatName(mat.getDescription());
				entity.setUIMatType(mat.getDes_unit());
			}
			
			list.add(entity);
			
		}
		return list;	
	}
	/**
	 * Used : reportByinvoice,reportBytpinvoice
	 * <br>
	 * select all by invoice or temp_invoice
	 * @param invoice
	 * @return
	 * @throws SQLException
	 * @throws UnsupportedEncodingException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static SaleOrderItem fininv(String invoice,String type) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String	sql = "select * from " + tableName + " where invoice = '" + invoice + "'";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);

		SaleOrderItem item = new SaleOrderItem();
		if(rs.next()) {	
			DBUtility.bindResultSet(item, rs);
		}
		rs.close();
		st.close();
		return item;
	}
	
	/**
	 * whan : report_review
	 * <br>
	 * เลือกเฉพาะที่มีการคืนมาจากลูกค้า
	 * @return
	 * @throws SQLException
	 * @throws UnsupportedEncodingException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static SaleOrderItem report_reciv() throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String sql = "select sale_order_item.* from " + tableName + ",sale_order where sale_order_item.order_id = sale_order.order_id AND sale_order.order_type = '" + SaleOrder.TYPE_CHANGE + "'";

		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);

		SaleOrderItem item = new SaleOrderItem();
		if(rs.next()) {	
			DBUtility.bindResultSet(item, rs);
			item.setUIMat(InventoryMaster.select(item.getItem_id(), conn));
		}
		rs.close();
		st.close();
		return item;
	}
	/**
	 * whan : report_review
	 * <br>
	 * เลือกเฉพาะ ที่เป็น invoice ใน table p_number
	 * @return
	 * @throws SQLException
	 * @throws UnsupportedEncodingException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static List<SaleOrderItem> report_sale() throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String sql1 = "(select * from p_number order by run_number ASC) union all (select * from n_number order by run_number ASC)";
		Connection conn1 = DBPool.getConnection();
		Statement st1 = conn1.createStatement();
		ResultSet rs1 = st1.executeQuery(sql1);
		
		List<SaleOrderItem> list = new ArrayList<SaleOrderItem>();
		while(rs1.next()) {	
			P_number p = new P_number();
			DBUtility.bindResultSet(p, rs1);
			
			String sql = "select * from " + tableName + " where invoice = '" + p.getRun_number() + "' ORDER BY invoice ASC";

			Connection conn = DBPool.getConnection();
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
		
			while(rs.next()) {	
				SaleOrderItem item = new SaleOrderItem();
				DBUtility.bindResultSet(item, rs);
				
				if(item.getItem_type().equalsIgnoreCase("p")){
					Package pac = Package.select(item.getItem_id(), conn);		
					item.setUIPacName(pac.getName());
				}else{
					InventoryMaster mat = InventoryMaster.select(item.getItem_id(), conn);
					item.setUIMatName(mat.getDescription());
				}
				list.add(item);
			}
			rs.close();
			st.close();
		}
		rs1.close();
		st1.close();
		conn1.close();
		
		
		return list;
	}
	
	/**
	 * whan : report_review 
	 * <br>
	 * sum fg ทั้งแบบ fg ปกติ และ แบบโปรโมชั่น
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static HashMap<String, MatTree> report_fg(String year, String month) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		
		Calendar sd = Calendar.getInstance();
		sd.clear();
		sd.set(Calendar.YEAR, Integer.parseInt(year));
		sd.set(Calendar.MONTH, Integer.parseInt(month) - 1);
		sd.set(Calendar.DATE, 1);
		
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		
		String s = df.format(sd.getTime());
		
		sd.add(Calendar.MONTH, +1);
		sd.add(Calendar.DATE, -1);
		String e = df.format(sd.getTime());
		//fg
		String sql = "SELECT " + tableName + ".*,SUM(item_qty) as qty FROM " + tableName + " WHERE item_type = 's' and invoice != '' AND request_date between '" + s + " 00:00:00.00' AND '" + e + " 23:59:59.99' GROUP BY item_id";
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		HashMap<String, MatTree> mat = new HashMap<String, MatTree>();
		while (rs.next()) {
			SaleOrderItem entity = new SaleOrderItem();
			DBUtility.bindResultSet(entity, rs);
			
			InventoryMaster mas = new InventoryMaster();
			mas = InventoryMaster.select(entity.getItem_id(), conn);
			MatTree tree = mat.get(entity.getItem_id());
			
			tree = new MatTree();
			tree.setRef_code(mas.getRef_code());
			tree.setMat_code(entity.getItem_id());
			tree.setGroup_id(mas.getDes_unit());
			tree.setOrder_qty(DBUtility.getString("qty", rs));
			tree.setDescription(mas.getDescription());
			//System.out.println(tree.getMat_code() + " : " + tree.getDescription());
			mat.put(entity.getItem_id(), tree);
		}
		rs.close();
		st.close();
		
		//pro
		sql = "select * from " + tableName + " where item_type = 'p' and invoice != '' AND request_date between '" + s + " 00:00:00.00' AND '" + e + " 23:59:59.99'";
		st = conn.createStatement();
		rs = st.executeQuery(sql);
		
		while (rs.next()) {
			PackageItem.sumPackageBypkid(mat,DBUtility.getString("item_id", rs));
		}
		rs.close();
		st.close();
		conn.close();
		return mat;
	}
	
		public static HashMap<String, MatTree> report_fg(Date d) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		
		String s = df.format(d.getTime());
		String e = df.format(d.getTime());
			
		//fg
		String sql = "SELECT " + tableName + ".*,SUM(item_qty) as qty FROM " + tableName + " WHERE item_type = 's' and invoice != '' AND request_date between '" + s + " 00:00:00.00' AND '" + e + " 23:59:59.99' GROUP BY item_id";
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		HashMap<String, MatTree> mat = new HashMap<String, MatTree>();
		while (rs.next()) {
			SaleOrderItem entity = new SaleOrderItem();
			DBUtility.bindResultSet(entity, rs);
			
			InventoryMaster mas = new InventoryMaster();
			mas = InventoryMaster.select(entity.getItem_id(), conn);
			MatTree tree = mat.get(entity.getItem_id());
			
			tree = new MatTree();
			tree.setRef_code(mas.getRef_code());
			tree.setMat_code(entity.getItem_id());
			tree.setGroup_id(mas.getDes_unit());
			tree.setOrder_qty(DBUtility.getString("qty", rs));
			tree.setDescription(mas.getDescription());
			//System.out.println(tree.getMat_code() + " : " + tree.getDescription());
			mat.put(entity.getItem_id(), tree);
		}
		rs.close();
		st.close();
		
		//pro
		sql = "select * from " + tableName + " where item_type = 'p' and invoice != '' AND request_date between '" + s + " 00:00:00.00' AND '" + e + " 23:59:59.99'";
		st = conn.createStatement();
		rs = st.executeQuery(sql);
		
		while (rs.next()) {
			PackageItem.sumPackageBypkid(mat,DBUtility.getString("item_id", rs));
		}
		rs.close();
		st.close();
		conn.close();
		return mat;
	}

	public static HashMap<String, MatTree> report4account() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		
		//item_type = 's'
		String sql = "SELECT " + tableName + ".*,SUM(item_qty*unit_price) as sum from sale_order_item where item_type = 's' and invoice != '' group by invoice";
		sql += " ORDER BY invoice ASC";
		System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		HashMap<String, MatTree> mat = new HashMap<String, MatTree>();
		while (rs.next()) {
			SaleOrderItem entity = new SaleOrderItem();
			DBUtility.bindResultSet(entity, rs);
			
			SaleOrder order = SaleOrder.selectByID(entity.getOrder_id());
			
			String afterDis = Money.discount(DBUtility.getString("sum", rs),entity.getDiscount());
			String vat = Money.divide(Money.multiple(afterDis,"7"),"100");
			String sum = Money.add(afterDis, vat);
			
			MatTree tree = mat.get(entity.getInvoice());
			
			if (tree == null){
				tree = new MatTree();
				tree.setRef_code(entity.getInvoice());
				tree.setDescription(order.getUICustomer().getCus_name());
				tree.setMat_code(sum);
				mat.put(entity.getInvoice(), tree);
			}else{
				String sum1 = tree.getMat_code();
				tree.setMat_code(Money.add(sum1,sum));
				mat.put(entity.getInvoice(), tree);
			}
		}
		rs.close();
		st.close();
		
		//item_type = 'p'
		sql = "SELECT " + tableName + ".*,SUM(unit_price) as sum from sale_order_item where item_type = 'p' and invoice != '' group by invoice";
		sql += " ORDER BY invoice ASC";
		//System.out.println(sql);
		st = conn.createStatement();
		rs = st.executeQuery(sql);
		
		while (rs.next()) {
			SaleOrderItem entity = new SaleOrderItem();
			DBUtility.bindResultSet(entity, rs);
			
			SaleOrder order = SaleOrder.selectByID(entity.getOrder_id());
			
			String afterDis = Money.discount(DBUtility.getString("sum", rs),entity.getDiscount());
			String vat = Money.divide(Money.multiple(afterDis,"7"),"100");
			String sum = Money.add(afterDis, vat);
			
			MatTree tree = mat.get(entity.getInvoice());
			
			if (tree == null){
				tree = new MatTree();
				tree.setRef_code(entity.getInvoice());
				tree.setDescription(order.getUICustomer().getCus_name());
				tree.setMat_code(sum);
				mat.put(entity.getInvoice(), tree);
			}else{
				String sum1 = tree.getMat_code();
				tree.setMat_code(Money.add(sum1,sum));
				mat.put(entity.getInvoice(), tree);
			}
		}
		rs.close();
		st.close();
		conn.close();
		return mat;
	}
	

	public static HashMap<String, MatTree> sumFG() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
	
	//FG
	String sql = "SELECT distinct(item_run) FROM " + tableName + " WHERE fg = ''";
	
	sql += " ORDER BY (item_run*1) ASC";
	//System.out.println(sql);
	Connection conn = DBPool.getConnection();
	Statement st = conn.createStatement();
	ResultSet rs = st.executeQuery(sql);
	
	HashMap<String, MatTree> mat = new HashMap<String, MatTree>();
	while (rs.next()) {
		SaleOrderItem entity = new SaleOrderItem();
		DBUtility.bindResultSet(entity, rs);
		
		SaleOrderItem.selectOrder(entity.getItem_run());
		MatTree tree = mat.get(entity.getItem_run());
		
		if (tree == null){
			tree = new MatTree();
			tree.setOrder_qty(entity.getItem_qty());
			tree.setMat_code(entity.getItem_id());
			mat.put(entity.getInvoice(), tree);
		}else{
			String sum1 = tree.getOrder_qty();
			tree.setMat_code(Money.add(sum1,entity.getItem_qty()));
			mat.put(entity.getItem_id(), tree);
		}
	}
	rs.close();
	st.close();
	
	//PROMOTION
	sql = "SELECT distinct(item_run) FROM " + tableName + " WHERE fg != ''";
	
	sql += " ORDER BY (item_run*1) ASC";
	//System.out.println(sql);
	while (rs.next()) {
		SaleOrderItem entity = new SaleOrderItem();
		DBUtility.bindResultSet(entity, rs);
		
		PackageItem.SumItem(entity.getItem_id());
		MatTree tree = mat.get(entity.getItem_run());
		
		if (tree == null){
			tree = new MatTree();
			tree.setOrder_qty(entity.getItem_qty());
			tree.setMat_code(entity.getItem_id());
			mat.put(entity.getInvoice(), tree);
		}else{
			String sum1 = tree.getOrder_qty();
			tree.setMat_code(Money.add(sum1,entity.getItem_qty()));
			mat.put(entity.getItem_id(), tree);
		}
	}
	rs.close();
	st.close();
	
	
	conn.close();
	return mat;
	}
	/**
	 * whan : plan_ap_fg,plan_sale_fg,sale_item_edit,sale_order_create,sale_qt_info
	 * <br>
	 * sum จำนวน การจอง fg หลังจาก planning ทำการประเมินการผลิต
	 * @param item_id
	 * @param type
	 * @return
	 * @throws SQLException
	 */
	public static String bookfg(String item_id,String type) throws SQLException{
		String sum = "";
		Connection conn = DBPool.getConnection();
		
		String sql = "select COALESCE(SUM(item_qty),0) as qty from " + tableName + " where item_type = 's' AND status = '30' and item_id = '" + item_id + "'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		while (rs.next()){
			if(type.equalsIgnoreCase("s")){
				sum = DBUtility.getString("qty", rs);
			}else{
				sum += DBUtility.getString("qty", rs);
			}
		}
		st.close();
		rs.close();
		conn.close();
		return sum;
	}

	/**
	 * Use for Inventory : plan_logis.jsp
	 * @return List<SaleOrderItem>
	 * @throws SQLException 
	 * @throws InvocationTargetException 
	 * @throws IllegalAccessException 
	 * @throws UnsupportedEncodingException 
	 */
	public static List<SaleOrderItem> listOrder4InventoryOutlet() throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		List<SaleOrderItem> list = new ArrayList<SaleOrderItem>();
		
		String sql = "SELECT " +
					 "order_id," +
					 "item_run," +
					 "item_type," +
					 "item_id," +
					 "item_qty," +
					 "invoice," +
					 "delivery_date," +
					 "status," +
					 "delivery_flag," +
					 "temp_invoice FROM " +
					 tableName + 
					 " WHERE delivery_date <= '" + DBUtility.DATE_DATABASE_FORMAT.format(DBUtility.getCurrentDate()) + " 23:59:59' " +
					 		 " AND delivery_flag ='0'" +
					 		 " AND (status='" + STATUS_INVOICE + "' OR status='" + STATUS_TMP_INVOICE + "')" +
					 		 " ORDER BY invoice";
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		String id = "";
		while (rs.next()) {
			SaleOrderItem entity = new SaleOrderItem();
			DBUtility.bindResultSet(entity, rs);
			
			if (!entity.getOrder_id().equalsIgnoreCase(id)) {
				SaleOrder order = new SaleOrder();
				order.setOrder_id(entity.getOrder_id());
				SaleOrder.select(order, conn);
				entity.setUICustomer(Customer.select(order.getCus_id(), conn));
				id = entity.getOrder_id();
			}
			if(entity.getItem_type().equalsIgnoreCase("s")){
				entity.setUIMat(InventoryMaster.select(entity.getItem_id(), conn));
			} else {
				entity.setUIPac(Package.select(entity.getItem_id(), conn));
			}
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	/**
	 * whan : plan_sale
	 * <br> 
	 * แสดงรายการรอประเมิน product
	 * @param ctrl
	 * @param params
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws ParseException 
	 */
	public static List<SaleOrderItem> select_PlanSale(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException, ParseException{
		String sql = "SELECT salitem.*,cus.cus_id,orde.create_by FROM sale_order as orde,sale_customer as cus," + tableName + " as salitem WHERE (salitem.status = '" + SaleOrderItem.STATUS_WAIT_PLAN_SUBMIT + "' or salitem.status = '" + SaleOrderItem.STATUS_PLAN_SUBMIT + "') AND orde.cus_id = cus.cus_id";
		sql += " AND salitem.order_id = orde.order_id";
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if(str[0].equalsIgnoreCase("due_date") || str[0].equalsIgnoreCase("create_date")){
					if (str[1].length() > 0) {
						Date b = DBUtility.getDate(str[1]);
						
						SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
						
						String s = df.format(b);
						sql += " AND (orde."+str[0]+" between '" + s + " 00:00:00.00' AND '" + s + " 23:59:59.99')";
						
					}
				} else if(str[0].equalsIgnoreCase("cus_name")){
					sql += " AND cus." + str[0] + " LIKE '%" + str[1] + "%'";
				} else if(str[0].equalsIgnoreCase("status")){
					sql += " AND salitem." + str[0] + "='" + str[1] + "'";
				}else{
					sql += " AND orde." + str[0] + "='" + str[1] + "'";
				}
			}
		}
	
		sql += " ORDER BY (salitem.status*1) ASC,(salitem.item_run*1) DESC";
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SaleOrderItem> list = new ArrayList<SaleOrderItem>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					SaleOrderItem entity = new SaleOrderItem();
					DBUtility.bindResultSet(entity, rs);
					
					if(entity.getItem_type().equalsIgnoreCase("s")){
						InventoryMaster mat = InventoryMaster.select(entity.getItem_id(), conn);
						entity.setUIMatName(mat.getDescription());
					} else {
						Package pac = Package.select(entity.getItem_id(), conn);
						entity.setUIPacName(pac.getName());
						entity.setUIMatType(pac.getPk_qty());
					}
					SaleOrder order = SaleOrder.selectByID(entity.getOrder_id());
					
					//Personal per = Personal.select(order.getCreate_by());
					//entity.setUIMatType(per.getName()+ " " + per.getSurname());

					Customer cus = Customer.select(DBUtility.getString("cus.cus_id",rs), conn);
					entity.setUINameCus(cus.getCus_name());
					
					entity.setUISumAll(order.getOrder_type());
					entity.setUISumPrp(DBUtility.getString("cus.cus_id",rs));
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
	
	public static void updateTakeProduct(SaleOrderItem entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();		
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity,new String[] {"delivery_flag","status","update_date","update_by"},new String[] {"item_run"});	
		conn.close();
	}
	/**
	 * whan : dashboard
	 * <br>
	 * count status ของ saleorderitem
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static HashMap<String, MatTree> sumStatus(String status) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "";
		if(status.equalsIgnoreCase("plan_sale")){
			sql = "SELECT status,COUNT(item_run) as count FROM " + tableName + " WHERE status = '" + SaleOrderItem.STATUS_PLAN_SUBMIT + "' OR status = '" + SaleOrderItem.STATUS_WAIT_PLAN_SUBMIT + "' GROUP BY status ORDER BY (status*1) ASC";			
		}else if(status.equalsIgnoreCase("qt")){
			sql = "SELECT status,COUNT(item_run) as count FROM " + tableName + " WHERE status = '" + SaleOrderItem.STATUS_SEND_QT + "' OR status = '" + SaleOrderItem.STATUS_NOT_AP_YET + "' GROUP BY status ORDER BY (status*1) ASC";			
		}else if(status.equalsIgnoreCase("plan_ap")){
			sql = "SELECT status,COUNT(item_run) as count FROM " + tableName + " WHERE status = '" + SaleOrderItem.STATUS_PRODUCE + "' GROUP BY status ORDER BY (status*1) ASC";			
		}else if(status.equalsIgnoreCase("item_inv")){
			sql = "SELECT status,COUNT(item_run) as count FROM " + tableName + " WHERE status = '" + SaleOrderItem.STATUS_INVOICE + "' OR status = '" + SaleOrderItem.STATUS_PRE_SEND + "' OR status = '" + SaleOrderItem.STATUS_TMP_INVOICE + "' GROUP BY status ORDER BY (status*1) ASC";	
		}
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		HashMap<String, MatTree> mat = new HashMap<String, MatTree>();
		while (rs.next()) {
			MatTree tree = mat.get(DBUtility.getString("status", rs));
			tree = new MatTree();
			tree.setGroup_id(SaleOrderItem.status(DBUtility.getString("status", rs)));
			tree.setDescription(DBUtility.getString("count", rs));
			mat.put(DBUtility.getString("status", rs), tree);		
		}
		rs.close();
		st.close();
		conn.close();
		return mat;
	}
	
	public static void approverToStore(SaleOrderItem entity) throws Exception{
		Connection conn = DBPool.getConnection();		
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity,new String[] {"po","status","update_date","update_by"},new String[] {"order_id","qt_id","item_run"});
		
		String sql = "SELECT count(*) cnt FROM " + tableName + " WHERE qt_id='" + entity.getQt_id() + "' AND status ='" + STATUS_SEND_QT + "'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		boolean isStatus = false;
		if (rs.next()) {
			if(DBUtility.getString("cnt", rs).equalsIgnoreCase("0")) {
				isStatus = true;
			}
		}
		if (isStatus) {
			SaleQt qt = new SaleQt();
			qt.setOrder_id(entity.getOrder_id());
			qt.setQt_id(entity.getQt_id());
			qt.setUpdate_by(entity.getUpdate_by());
			qt.setStatus(SaleQt.STATUS_CLOSE_QT);	

			SaleQt.updateQt(qt);
			
			SaleOrder order = new SaleOrder();
			order.setOrder_id(entity.getOrder_id());
			order.setStatus(SaleOrder.STATUS_CLOSE_QT);
			SaleOrder.updateStatus(conn,order);
		}
		rs.close();
		st.close();	
		conn.close();
	}
	 public static String selectOrderByInvoice(String invoice, Connection conn) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException {
		    SaleOrderItem entity = new SaleOrderItem();
		    entity.setInvoice(invoice);
		    DBUtility.getEntityFromDB(conn, tableName, entity, new String[] { "invoice" });
		    return entity.getOrder_id();
	 }
	public static void main(String[] s) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		//SaleOrderItem.listOrder4InventoryOutlet();
	}
	
	

	public static String genInvoice(Connection conn, String type) throws SQLException {
	    String field = "";
	    String prefix = "";
	    if (type.equalsIgnoreCase("inv")) {
	      field = "invoice";
	      prefix = "INV";
	    } else {
	      field = "temp_invoice";
	      prefix = "TMP";
	    }
	    String sql = "SELECT " + field + " FROM " + tableName + " WHERE " + field + " LIKE '" + prefix + "%' ORDER BY " + field + " DESC";
	    System.out.println(sql);
	    Statement st = conn.createStatement();
	    ResultSet rs = st.executeQuery(sql);

	    String invoice = prefix + "000001";
	    if (rs.next()) {
	      String temp = DBUtility.getString(field, rs);
	      invoice = String.valueOf( Integer.parseInt(temp.substring(3, temp.length())   ) + 100001);
	      invoice = prefix + invoice.substring(1, invoice.length());
	    }

	    rs.close();
	    st.close();
	    return invoice;
	  }
	
	
	
	
	public String getRmk_plan() {
		return rmk_plan;
	}
	public void setRmk_plan(String rmk_plan) {
		this.rmk_plan = rmk_plan;
	}
	public String getUISumAll() {
		return UISumAll;
	}
	public void setUISumAll(String uISumAll) {
		UISumAll = uISumAll;
	}
	public String getUISumPrp() {
		return UISumPrp;
	}
	public void setUISumPrp(String uISumPrp) {
		UISumPrp = uISumPrp;
	}
	public String getUIMatType() {
		return UIMatType;
	}
	public void setUIMatType(String uIMatType) {
		UIMatType = uIMatType;
	}
	public Date getFin_tmp() {
		return fin_tmp;
	}
	public void setFin_tmp(Date fin_tmp) {
		this.fin_tmp = fin_tmp;
	}
	public Date getRegis_inv() {
		return regis_inv;
	}
	public void setRegis_inv(Date regis_inv) {
		this.regis_inv = regis_inv;
	}
	public String getUIPacName() {
		return UIPacName;
	}
	public void setUIPacName(String uIPacName) {
		UIPacName = uIPacName;
	}
	public String getUIMatName() {
		return UIMatName;
	}
	public void setUIMatName(String uIMatName) {
		UIMatName = uIMatName;
	}
	public String getUIOrderType() {
		return UIOrderType;
	}
	public void setUIOrderType(String uIOrderType) {
		UIOrderType = uIOrderType;
	}
	public String getUINameCus() {
		return UINameCus;
	}
	public void setUINameCus(String uINameCus) {
		UINameCus = uINameCus;
	}
	public SaleOrder getUIOrder() {
		return UIOrder;
	}
	public void setUIOrder(SaleOrder uIOrder) {
		UIOrder = uIOrder;
	}
	Customer UICustomer = new Customer();
	public Customer getUICustomer() {
		return UICustomer;
	}
	public void setUICustomer(Customer uICustomer) {
		UICustomer = uICustomer;
	}
	private Personal UISale = new Personal();
	public Personal getUISale() {
		return UISale;
	}
	public void setUISale(Personal uISale) {UISale = uISale;}
	public String getTemp_invoice() {
		return temp_invoice;
	}
	public void setTemp_invoice(String temp_invoice) {
		this.temp_invoice = temp_invoice;
	}
	public String getDiscount() {
		return discount;
	}
	public void setDiscount(String discount) {
		this.discount = discount;
	}
	public Date getStart_date() {
		return start_date;
	}
	public void setStart_date(Date start_date) {
		this.start_date = start_date;
	}
	public String getPo() {
		return po;
	}
	public void setPo(String po) {
		this.po = po;
	}
	public String getQt_id() {
		return qt_id;
	}
	public void setQt_id(String qt_id) {
		this.qt_id = qt_id;
	}
	public String getInvoice() {
		return invoice;
	}
	public void setInvoice(String invoice) {
		this.invoice = invoice;
	}
	public String getItem_run() {
		return item_run;
	}
	public void setItem_run(String item_run) {
		this.item_run = item_run;
	}
	public String getConfirm_by() {
		return confirm_by;
	}
	public void setConfirm_by(String confirm_by) {
		this.confirm_by = confirm_by;
	}
	public Date getRequest_date() {
		return request_date;
	}
	public void setRequest_date(Date request_date) {
		this.request_date = request_date;
	}
	public Package getUIPac() {
		return UIPac;
	}
	public void setUIPac(Package uIPac) {
		UIPac = uIPac;
	}
	public InventoryMaster getUIMat() {
		return UIMat;
	}
	public void setUIMat(InventoryMaster uIMat) {
		UIMat = uIMat;
	}
	public String getOrder_id() {
		return order_id;
	}
	public void setOrder_id(String order_id) {
		this.order_id = order_id;
	}
	public String getItem_id() {
		return item_id;
	}
	public void setItem_id(String item_id) {
		this.item_id = item_id;
	}
	public String getItem_type() {
		return item_type;
	}
	public void setItem_type(String item_type) {
		this.item_type = item_type;
	}
	public String getItem_qty() {
		return item_qty;
	}
	public void setItem_qty(String item_qty) {
		this.item_qty = item_qty;
	}
	public String getUnit_price() {
		return unit_price;
	}
	public void setUnit_price(String unit_price) {
		this.unit_price = unit_price;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public Date getConfirm_date() {
		return confirm_date;
	}
	public void setConfirm_date(Date confirm_date) {
		this.confirm_date = confirm_date;
	}
	public Date getDelivery_date() {
		return delivery_date;
	}
	public void setDelivery_date(Date delivery_date) {
		this.delivery_date = delivery_date;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
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
	public String getDelivery_flag() {
		return delivery_flag;
	}
	public void setDelivery_flag(String delivery_flag) {
		this.delivery_flag = delivery_flag;
	}
	public Date getFin_inv() {
		return fin_inv;
	}
	public void setFin_inv(Date fin_inv) {
		this.fin_inv = fin_inv;
	}
	
}
