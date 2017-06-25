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

import com.bitmap.bean.hr.Personal;
import com.bitmap.bean.rd.MatTree;
import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;

public class SaleOrder {
	public static String tableName = "sale_order";
	private static String[] keys = {"order_id"};
	static String[] fieldNames = {"order_type","status","po","due_date","remark","sale_by","update_by","update_date"};
	
	public static String STATUS_CANCEL = "999";
	public static String STATUS_SALE_CREATE = "10";
	public static String STATUS_SALE_SUBMIT = "15";
	public static String STATUS_PLAN_SUBMIT	= "20";
	public static String STATUS_SEND_QT = "40";
	public static String STATUS_CLOSE_QT	= "50";
	public static String STATUS_PREPARE_PD	= "60";
	public static String STATUS_WAIT_INV	= "65";
	public static String STATUS_PREPARE	= "70";
	public static String STATUS_OUTLET	= "80";
	public static String STATUS_FIN	= "90";
	public static String STATUS_END	= "100";
	
	public static String TYPE_SALE = "10";
	public static String TYPE_SAMPLE = "20";
	public static String TYPE_25 = "30";
	public static String TYPE_SGI = "40";
	public static String TYPE_MODIFY = "50";
	public static String TYPE_CHANGE = "60";
	public static String TYPE_DROP = "70";
	public static String TYPE_BUFFER = "80";
	public static String TYPE_GHOST = "90";
	public static String TYPE_CUS = "100";
	
	public static List<String[]> statusDropDownForBuffer(){
		List<String[]> list = new ArrayList<String[]>();
		list.add(new String[]{STATUS_CANCEL,"ยกเลิก"});
		list.add(new String[]{STATUS_SALE_CREATE,"กำลังสร้างรายการ"});
		list.add(new String[]{STATUS_SALE_SUBMIT,"รอวางแผน"});
		list.add(new String[]{STATUS_PLAN_SUBMIT,"วางแผนแล้ว"});
		list.add(new String[]{STATUS_CLOSE_QT,"รอผลิต"});
		list.add(new String[]{STATUS_PREPARE_PD,"กำลังผลิต"});
		list.add(new String[]{STATUS_END,"ปิดการผลิค"});
		return list;
	}

	public static List<String[]> statusDropDown(){
		List<String[]> list = new ArrayList<String[]>();
		list.add(new String[]{STATUS_CANCEL,"ยกเลิก"});
		list.add(new String[]{STATUS_SALE_CREATE,"กำลังสร้างรายการ"});
		list.add(new String[]{STATUS_SALE_SUBMIT,"รอวางแผน"});
		list.add(new String[]{STATUS_PLAN_SUBMIT,"วางแผนแล้ว"});
		list.add(new String[]{STATUS_SEND_QT,"รออนุมัติใบเสนอราคา"});
		list.add(new String[]{STATUS_CLOSE_QT,"รอผลิต"});
		list.add(new String[]{STATUS_PREPARE_PD,"กำลังผลิต"});
		list.add(new String[]{STATUS_WAIT_INV,"รอออก INV"});
		list.add(new String[]{STATUS_PREPARE,"รอจัดของ"});
		list.add(new String[]{STATUS_OUTLET,"เตรียมส่ง"});
		list.add(new String[]{STATUS_FIN,"กำลังส่ง"});
		list.add(new String[]{STATUS_END,"ปิดการขาย"});
		return list;
		
	}

	String order_id = "";
	String cus_id = "";
	String order_type = "";
	String status = "";
	String po = "";
	String remark = "";
	String sale_by = "";
	Date due_date = null;
	String id_receive = "";
	String create_by = "";
	Timestamp create_date = null;
	String update_by = "";
	Timestamp update_date = null;
	
	
	private Customer UICustomer = new Customer();
	public Customer getUICustomer() {return UICustomer;}
	public void setUICustomer(Customer uICustomer) {UICustomer = uICustomer;}
	
	private Personal UISale = new Personal();
	public Personal getUISale() {return UISale;}
	public void setUISale(Personal uISale) {UISale = uISale;}
	
	public static String status(String status){
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("999","ยกเลิก");
		map.put("10","กำลังสร้างรายการ");
		map.put("15","รอวางแผน");
		map.put("20","วางแผนแล้ว");
		map.put("40","รออนุมัติใบเสนอราคา");
		map.put("50","รอผลิต");
		map.put("60","กำลังผลิต");
		map.put("65","รอออก INV");
		map.put("70","รอจัดของ");
		map.put("80","เตรียมส่ง");
		map.put("90","กำลังส่ง");
		map.put("100","ปิดการขาย");
		return map.get(status);
	}
	
	public static List<String[]> typeDropDown(){
		List<String[]> list = new ArrayList<String[]>();
		list.add(new String[]{TYPE_SALE,"ขาย"});
		list.add(new String[]{TYPE_25,"กม 25"});
		list.add(new String[]{TYPE_SGI,"SGI"});
		list.add(new String[]{TYPE_GHOST,"ขาย(หลอก)"});
		list.add(new String[]{TYPE_SAMPLE,"ทดลองผลิต"});
		list.add(new String[]{TYPE_CUS,"ตัวอย่างให้ลูกค้า"});
		return list;
	}
	
	public static List<String[]> type(){
		List<String[]> list = new ArrayList<String[]>();
		list.add(new String[]{TYPE_MODIFY,"แก้ไขสินค้า"});
		list.add(new String[]{TYPE_CHANGE,"เปลี่ยนสินค้า"});
		list.add(new String[]{TYPE_DROP,"สินค้าเสีย"});
		return list;
	}
	
	public static String type(String type){
		HashMap<String, String> map = new HashMap<String, String>();
		map.put(TYPE_SALE,"ขาย");
		map.put(TYPE_SAMPLE,"ทดลองผลิต");
		map.put(TYPE_25,"กม 25");
		map.put(TYPE_SGI,"SGI");
		map.put(TYPE_MODIFY,"แก้ไขสินค้า");
		map.put(TYPE_CHANGE,"เปลี่ยนสินค้า");
		map.put(TYPE_BUFFER,"Buffer");
		map.put(TYPE_GHOST,"ขาย(หลอก)");
		map.put(TYPE_CUS,"ตัวอย่างให้ลูกค้า");
		return map.get(type);
	}

	public static void insert(SaleOrder entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setStatus(STATUS_SALE_CREATE);
		entity.setOrder_id(DBUtility.genNumber(conn, tableName, "order_id"));
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		
		conn.close();
	}
	
	public static SaleOrder select(SaleOrder order) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();			
		DBUtility.getEntityFromDB(conn, tableName, order, keys);
		order.setUICustomer(Customer.select(order.getCus_id(), conn));
		conn.close();	
		return order;
	}
	
	public static SaleOrder select(SaleOrder order,Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{		
		DBUtility.getEntityFromDB(conn, tableName, order, keys);
		return order;
	}
	
	public static SaleOrder selectByID(String order_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();	
		SaleOrder order = new SaleOrder();
		order.setOrder_id(order_id);
		
		DBUtility.getEntityFromDB(conn, tableName, order, keys);
		order.setUICustomer(Customer.select(order.getCus_id(), conn));
		conn.close();
		return order;
	}
	
	public static void update(SaleOrder entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setStatus(STATUS_SALE_CREATE);
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		
		conn.close();
	}
	
	public static void delete(SaleOrder entity) throws IllegalAccessException, InvocationTargetException, SQLException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection(); 	
		DBUtility.deleteFromDB(conn, tableName, entity, keys);	
		conn.close();
	}
	
	public static List<SaleOrder> select(PageControl ctrl, List<String[]> params) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " as sal,sale_customer as cus WHERE sal.status = '" + SaleOrder.STATUS_PLAN_SUBMIT + "'";
		sql += " AND sal.order_type != "+ SaleOrder.TYPE_CHANGE + " AND sal.order_type != '" + SaleOrder.TYPE_MODIFY + "' AND  sal.order_type != '"+ SaleOrder.TYPE_BUFFER + "' AND cus.cus_id = sal.cus_id";
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if(str[0].equalsIgnoreCase("cus_name")){
					sql += " AND cus." + str[0] + " LIKE '%" + str[1] + "%'";
				}else{
					sql += " AND sal." + str[0] + " = '" + str[1] + "'";
				}
			}
		}
		sql += " ORDER BY (sal.status*1) ASC,(sal.order_id*1) DESC";
		sql += " LIMIT 0,1000 ";
		
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SaleOrder> list = new ArrayList<SaleOrder>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					SaleOrder entity = new SaleOrder();
					DBUtility.bindResultSet(entity, rs);
					entity.setUICustomer(Customer.select(entity.getCus_id(), conn));
					entity.setUISale(Personal.selectOnlyPerson(entity.getCreate_by(), conn));
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
	public static List<SaleOrder> selectWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException, ParseException{
		String sql = "SELECT sal.* FROM " + tableName + " as sal,sale_customer as cus WHERE sal.order_type != '" + SaleOrder.TYPE_BUFFER + "' AND sal.cus_id = cus.cus_id";//and status = '" + SaleOrder.STATUS_SALE_SUBMIT + "'";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if(str[0].equalsIgnoreCase("due_date")){
					Date b = DBUtility.getDate(str[1]);
					
					SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
					
					String s = df.format(b);
					sql += " AND sal." + str[0] + " = '" + s + " 00:00:00.00'";
				}else if(str[0].equalsIgnoreCase("cus_name")){
					sql += " AND cus." + str[0] + " LIKE '%" + str[1] + "%'";
				}
				else{
					sql += " AND sal." + str[0] + " = '" + str[1] + "'";
				}
					
			}
		}
		sql += " ORDER BY (sal.status*1) ASC, (sal.order_id*1) DESC";
		sql += " LIMIT 0,1000 ";
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SaleOrder> list = new ArrayList<SaleOrder>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					SaleOrder entity = new SaleOrder();
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
	
	public static List<SaleOrder> selectCloseQT(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1 and status = '" + SaleOrder.STATUS_CLOSE_QT + "'";
		String m = "";
		String y = "";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (str[0].equalsIgnoreCase("year")){
					y = str[1];
				} else 
				if (str[0].equalsIgnoreCase("month")) {
					m = str[1];
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
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SaleOrder> list = new ArrayList<SaleOrder>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					SaleOrder entity = new SaleOrder();
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
	
	public static void updateStatus(Connection conn,SaleOrder entity) throws Exception{
		//Connection conn = DBPool.getConnection();	
		try {
			entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
			
			DBUtility.updateToDB(conn, tableName, entity,new String[] {"status","update_date","update_by"},keys);		
			
			/*System.out.println(entity.getStatus());
			String statusINVDe = entity.getStatus();
			Detailinv.updateStatusSaleOrderDetill(conn,statusINVDe);*/
			
			
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
	
	public static void updateDate(SaleOrder entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();	
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity,new String[] {"due_date","update_date","update_by"},keys);		
		conn.close();
	}
	
	public static List<SaleOrder> selectWithCTRLTypeBuffer(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException, ParseException{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1 AND order_type = '" + SaleOrder.TYPE_BUFFER + "'";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if(str[0].equalsIgnoreCase("create_date")){
					Date b = DBUtility.getDate(str[1]);
					
					SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
					
					String s = df.format(b);
					sql += " AND " + str[0] + " between '" + s + " 00:00:00.00' AND '" + s + " 23:59:59.99'";
					
				}else{
					sql += " AND " + str[0] + "='" + str[1] + "'";
				}
			}
		}
	
		sql += " ORDER BY status ASC";
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SaleOrder> list = new ArrayList<SaleOrder>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					SaleOrder entity = new SaleOrder();
					DBUtility.bindResultSet(entity, rs);
					entity.setUISale(Personal.selectOnlyPerson(entity.getCreate_by(), conn));
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
	/**
	 * whan : dashboard
	 * <br>
	 * count status ของ saleorder
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static HashMap<String, MatTree> sumStatus() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT status,COUNT(order_id) as count FROM " + tableName;
		sql += " WHERE status = '" + SaleOrder.STATUS_SALE_CREATE + "' OR status = '" + SaleOrder.STATUS_CANCEL + "' OR status = '" + SaleOrder.STATUS_END + "'";
		sql += " GROUP BY status ORDER BY (status*1) ASC";
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		HashMap<String, MatTree> mat = new HashMap<String, MatTree>();
		while (rs.next()) {
			MatTree tree = mat.get(DBUtility.getString("status", rs));
			tree = new MatTree();
			tree.setGroup_id(SaleOrder.status(DBUtility.getString("status", rs)));
			tree.setDescription(DBUtility.getString("count", rs));
			mat.put(DBUtility.getString("status", rs), tree);		
		}
		rs.close();
		st.close();
		conn.close();
		return mat;
	}
	public static String selectCustomer(String order_id, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException {
	    SaleOrder entity = new SaleOrder();
	    entity.setOrder_id(order_id);
	    DBUtility.getEntityFromDB(conn, tableName, entity, keys);
	    return entity.getCus_id();
	  }
	
	public String getOrder_id() {
		return order_id;
	}
	public void setOrder_id(String order_id) {
		this.order_id = order_id;
	}
	public String getOrder_type() {
		return order_type;
	}
	public void setOrder_type(String order_type) {
		this.order_type = order_type;
	}
	public String getCus_id() {
		return cus_id;
	}
	public void setCus_id(String cus_id) {
		this.cus_id = cus_id;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public Date getDue_date() {
		return due_date;
	}
	public void setDue_date(Date due_date) {
		this.due_date = due_date;
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
	public String getPo() {
		return po;
	}
	public void setPo(String po) {
		this.po = po;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	
	public String getSale_by() {
		return sale_by;
	}
	public void setSale_by(String sale_by) {
		this.sale_by = sale_by;
	}
	public String getId_receive() {
		return id_receive;
	}
	public void setId_receive(String id_receive) {
		this.id_receive = id_receive;
	}

	
}