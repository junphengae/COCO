package com.bitmap.bean.logistic;

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
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import com.bitmap.bean.inventory.InventoryMaster;
import com.bitmap.bean.rd.MatTree;
import com.bitmap.bean.sale.Detailinv;
import com.bitmap.bean.sale.SaleOrder;
import com.bitmap.bean.sale.SaleOrderItem;
import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;
import com.sun.xml.internal.stream.Entity;

public class LogisSend {
	
	public static String tableName = "logis_send" ;
	public static String[] keys = {"id_run"};
	
	public static String[] fieldNames = {"item_run","inv","type_inv","mat_code","qty_all","qty","send_date","status","update_by","update_date"}; 	
	
	String id_run = "";
	String item_run = "";
	String inv = "";
	String type_inv = "";
	String mat_code = "";
	String qty_all = "0";
	String qty = "0";
	Date send_date = null;
	String status = "";
	String create_by = "";
	Timestamp create_date = null;
	String update_by = "";
	Timestamp update_date = null;

	public static String STATUS_WAIT = "00";
	public static String STATUS_PREPARE = "10";
	public static String STATUS_TAKE = "20";
	public static String STATUS_RESEND = "30";
	public static String STATUS_FIN = "40";
	
	String UImatname = "";
	InventoryMaster UImaster = new InventoryMaster();
	SaleOrder UIorder = new SaleOrder();
	
	public static String statusInv(String status){
		HashMap<String , String> map = new HashMap<String, String>();
		map.put("10", "invoice");
		map.put("20", "ใบส่งของ");
		return map.get(status);
	}
	
	public static String statusSend(String status){
		HashMap<String , String> map = new HashMap<String, String>();
		map.put("00", "รอออกแผน");
		map.put("10", "กำลังส่งของ");
		map.put("20", "เบิกของแล้ว");
		map.put("30", "ค้างส่ง");
		map.put("40", "ส่งของเรียบร้อย");
		return map.get(status);
	}
	
	public SaleOrder getUIorder() {
		return UIorder;
	}
	public void setUIorder(SaleOrder uIorder) {
		UIorder = uIorder;
	}
	public String getUImatname() {
		return UImatname;
	}
	public void setUImatname(String uImatname) {
		UImatname = uImatname;
	}
	public InventoryMaster getUImaster() {
		return UImaster;
	}
	public void setUImaster(InventoryMaster uImaster) {
		UImaster = uImaster;
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
	public String getItem_run() {
		return item_run;
	}

	public void setItem_run(String item_run) {
		this.item_run = item_run;
	}

	public String getInv() {
		return inv;
	}

	public void setInv(String inv) {
		this.inv = inv;
	}

	public String getType_inv() {
		return type_inv;
	}

	public void setType_inv(String type_inv) {
		this.type_inv = type_inv;
	}

	public String getQty_all() {
		return qty_all;
	}

	public void setQty_all(String qty_all) {
		this.qty_all = qty_all;
	}

	public String getQty() {
		return qty;
	}

	public void setQty(String qty) {
		this.qty = qty;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	public String getMat_code() {
		return mat_code;
	}

	public void setMat_code(String mat_code) {
		this.mat_code = mat_code;
	}
	public String getId_run() {
		return id_run;
	}

	public void setId_run(String id_run) {
		this.id_run = id_run;
	}

	/*public static void insert(LogisSend entity) throws IllegalAccessException, InvocationTargetException, SQLException, IllegalArgumentException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();	
		
		entity.setId_run(DBUtility.genNumber(conn, tableName, "id_run"));
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}*/
	public static void insert(LogisSend entity) throws IllegalAccessException, InvocationTargetException, SQLException, IllegalArgumentException, UnsupportedEncodingException {
	    Connection conn = DBPool.getConnection();

	    entity.setId_run(genIdrun(conn));
	    entity.setCreate_date(DBUtility.getDBCurrentDateTime());
	    DBUtility.insertToDB(conn, tableName, entity);
	    conn.close();
	  }
	public static void update(LogisSend entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();	
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity,new String[] {"qty","send_date","status","update_date","update_by"},new String[] {"id_run"});
		conn.close();
	}
	
	/**
	 * whan : OutletManagement.withdraw_for_sell
	 * <br>
	 * เบิกขาย เปลี่ยน status ว่าเบิกของแล้ว
	 * @param entity
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws SQLException
	 * @throws UnsupportedEncodingException 
	 */
	public static void updateStatus(LogisSend entity) throws IllegalAccessException, InvocationTargetException, SQLException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		DBUtility.updateToDB(conn, tableName, entity,new String[] {"status","update_date","update_by"},new String[] {"id_run"});
		
		LogisSend.select(entity);
		
		String sql = "SELECT * FROM " + tableName + " WHERE inv = '" + entity.getInv() + "' AND item_run = '" + entity.getItem_run() + "' AND id_run != '" + entity.getId_run() + "' AND status = '" + LogisSend.STATUS_WAIT + "'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		//System.out.println(sql);
		while (rs.next()) {
			LogisSend send = new LogisSend();
			DBUtility.bindResultSet(send, rs);
			
			send.setStatus(STATUS_RESEND);
			send.setUpdate_by(entity.getUpdate_by());
			send.setUpdate_date(DBUtility.getDBCurrentDateTime());
			DBUtility.updateToDB(conn, tableName, send,new String[] {"status","update_date","update_by"},new String[] {"id_run"});
			
		}
		
		rs.close();
		st.close();
		conn.close();
	}
	
	public static void updateStatus_notSendAll(LogisSend entity) throws IllegalAccessException, InvocationTargetException, SQLException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_by(entity.getUpdate_by());
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity,new String[] {"qty","status","update_date","update_by"},new String[] {"id_run"});
		conn.close();
	}
	/**
	 * whan : sale_delivery_edit_qty
	 * <br>
	 * select ตาม id_run  
	 * @param entity
	 * @return
	 * @throws SQLException
	 * @throws UnsupportedEncodingException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static LogisSend select(LogisSend entity) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity,new String[] {"id_run"});
		conn.close();
		return entity;
	}
	
	public static LogisSend select(String id_run,Connection conn) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException {
		LogisSend entity = new LogisSend();
		entity.setId_run(id_run);
		DBUtility.getEntityFromDB(conn, tableName, entity,new String[] {"id_run"});
		return entity;
	}
	/**
	 * whan : sale_delivery
	 * <br>
	 * select รายการจัดของในหน้าของ sale
	 * @param ctrl
	 * @param paramList
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static List<LogisSend> selectWithCTRL(PageControl ctrl, List<String[]> paramList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1";
		Iterator<String[]> ite = paramList.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
					sql += " AND " + str[0] + "='" + str[1] + "'";
			}
		}	
		sql += " ORDER BY (inv*1) ASC";
		sql += " LIMIT 0,1000 ";
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<LogisSend> list = new ArrayList<LogisSend>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					LogisSend entity = new LogisSend();
					DBUtility.bindResultSet(entity, rs);
					
					InventoryMaster inv = InventoryMaster.select(entity.getMat_code(), conn);
					entity.setUImatname(inv.getDescription());
					
					SaleOrderItem item = new SaleOrderItem();
					item = SaleOrderItem.selectOrder(entity.getItem_run());
					
					SaleOrder order = new SaleOrder();
					order.setOrder_id(item.getOrder_id());
					entity.setUIorder(SaleOrder.select(order));
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
	 * whan : plan_logis
	 * <br>
	 * แสดงรายการที่ต้องไปเบิกของออก หน้าของ store
	 * @param ctrl
	 * @param paramList
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws ParseException 
	 */
	public static List<LogisSend> selectWithCTRLForInv(PageControl ctrl, List<String[]> paramList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException, ParseException{
		String sql = "SELECT * FROM " + tableName + " WHERE qty <> '0' AND send_date is not NULL AND status != '" + LogisSend.STATUS_TAKE + "'";
		Iterator<String[]> ite = paramList.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if(str[0].equalsIgnoreCase("send_date")){
					Date b = DBUtility.getDate(str[1]);
					SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
					String s = df.format(b);
					sql += " AND " + str[0] + " = '" + s + " 00:00:00.00'";
				}else{
					sql += " AND " + str[0] + "='" + str[1] + "'";
				}
			}
		}	
		sql += " ORDER BY (send_date) DESC";
		System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<LogisSend> list = new ArrayList<LogisSend>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					LogisSend entity = new LogisSend();
					DBUtility.bindResultSet(entity, rs);
					
					InventoryMaster inv = InventoryMaster.select(entity.getMat_code(), conn);
					entity.setUImaster(inv);
					
					SaleOrderItem item = SaleOrderItem.selectOrder(entity.getItem_run());
					entity.setUIorder(SaleOrder.selectByID(item.getOrder_id()));
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
	public static boolean checkhave(String run_number) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE run_number = '" + run_number + "'";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);

		boolean check = false;
		while(rs.next()){
			check = true;
		}
		conn.close();
		return check;
	}
	/**
	 * whan : LogisManage.update_plan_send
	 * @param item_run
	 * @param mat_code
	 * @return
	 * @throws SQLException
	 * @throws IllegalArgumentException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static String sumQty(String item_run,String mat_code) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT COALESCE(SUM(qty),0) as qty FROM " + tableName + " WHERE item_run = '" + item_run + "' AND mat_code = '" + mat_code + "' GROUP BY mat_code,item_run";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);

		//System.out.println(sql);
		String check = "";
		while(rs.next()){
			check = DBUtility.getString("qty", rs);
		}
		conn.close();
		return check;
	}
	
	public static String sumQtyAndStatus(String item_run,String mat_code) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT SUM(qty) as qty FROM " + tableName + " WHERE item_run = '" + item_run + "' AND mat_code = '" + mat_code + "' AND status = '" + Detailinv.STATUS_FIN + "' GROUP BY mat_code,item_run";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);

		//System.out.println(sql);
		String check = "";
		while(rs.next()){
			check = DBUtility.getString("qty", rs);
		}
		conn.close();
		return check;
	}
	/**
	 * whan : delivery_edit_qty
	 * <br> 
	 * sum จำนวนทั้งหมด โดย item_run และ mat_code และ id_run ไม่เท่ากับ อันที่เราส่งมา 
	 * @param item_run
	 * @param mat_code
	 * @param id_run
	 * @return
	 * @throws SQLException
	 * @throws IllegalArgumentException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static String balance(String item_run,String mat_code,String id_run) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT SUM(qty) as qty FROM " + tableName + " WHERE item_run = '" + item_run + "' AND mat_code = '" + mat_code + "' AND id_run != '" + id_run + "' GROUP BY mat_code,item_run";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);

		//System.out.println(sql);
		String check = "0";
		while(rs.next()){
			check = DBUtility.getString("qty", rs);	
		}
		conn.close();
		return check;
	}
	/**
	 * whan : sendid_search
	 * <br>
	 * ค้นหารายการส่งที่เบิกสินค้าออกมาแล้ว
	 * @param ctrl
	 * @param paramList
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static List<LogisSend> searchForLogis(PageControl ctrl, List<String[]> paramList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE status = '" + LogisSend.STATUS_TAKE + "' AND id_run not in (SELECT id_run FROM logis_detail_send)";
		
		Iterator<String[]> ite = paramList.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
					sql += " AND " + str[0] + "='" + str[1] + "'";
			}
		}	
		sql += " ORDER BY (inv*1) ASC";
		System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<LogisSend> list = new ArrayList<LogisSend>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					LogisSend entity = new LogisSend();
					DBUtility.bindResultSet(entity, rs);
					
					InventoryMaster inv = InventoryMaster.select(entity.getMat_code(), conn);
					entity.setUImatname(inv.getDescription());
					
					SaleOrderItem item = new SaleOrderItem();
					item = SaleOrderItem.selectOrder(entity.getItem_run());
					
					SaleOrder order = new SaleOrder();
					order.setOrder_id(item.getOrder_id());
					entity.setUIorder(SaleOrder.select(order));
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
	 * whan : SaleOrderItem.selectByrun
	 * <br>
	 * นับว่าจำนวนที่ส่งไปแล้ว มันครบตามจำนวนที่ลูกค้าสั้งรึเปล่า?
	 * @param item_run
	 * @param mat_code
	 * @param update_by
	 * @return
	 * @throws Exception 
	 */
	public static boolean checkQtyAndQtyall(String item_run,String mat_code,String update_by) throws Exception{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT SUM(qty) as qty,qty_all FROM " + tableName + " WHERE item_run = '" + item_run + "' AND mat_code = '" + mat_code + "' AND status = '" + LogisSend.STATUS_FIN + "' GROUP BY mat_code,item_run";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);

		//System.out.println(sql);
		boolean check = true;
		while(rs.next()){
			int qty = DBUtility.getInteger("qty", rs);
			int qty_all = DBUtility.getInteger("qty_all", rs);
			
			if(qty == qty_all){
				SaleOrderItem item = new SaleOrderItem();
				item.setItem_run(item_run);
				item.setUpdate_by(update_by);
				///ส่งของเรียบร้อยแล้ว = 90
				item.setStatus(SaleOrderItem.STATUS_SEND_PRODUCT);
				//System.out.println("send product  law");
				SaleOrderItem.updateStatusByItemrun(item);
				
				item = SaleOrderItem.selectOrder(item_run);
				
				String count1 = SaleOrderItem.countAllrun(item.getOrder_id(), conn);
				String count = SaleOrderItem.countItemrun(item.getOrder_id(),SaleOrderItem.STATUS_SEND_PRODUCT, conn);
				
				if(count1.equalsIgnoreCase(count)){
					//System.out.println("change law");
					
					SaleOrder order = new SaleOrder();
					order.setOrder_id(item.getOrder_id());
					order.setUpdate_by(update_by);
					//status = 90
					order.setStatus(SaleOrder.STATUS_FIN);
					SaleOrder.updateStatus(conn,order);
				}
				
			}
		}
		conn.close();
		return check;
	}
	/**
	 * whan : dashboard
	 * <br>
	 * count status ของ logissend
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static HashMap<String, MatTree> sumStatus() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT status,COUNT(id_run) as count FROM " + tableName;
		sql += " GROUP BY status ORDER BY (status*1) ASC";
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		HashMap<String, MatTree> mat = new HashMap<String, MatTree>();
		while (rs.next()) {
			MatTree tree = mat.get(DBUtility.getString("status", rs));
			tree = new MatTree();
			tree.setGroup_id(LogisSend.statusSend(DBUtility.getString("status", rs)));
			tree.setDescription(DBUtility.getString("count", rs));
			mat.put(DBUtility.getString("status", rs), tree);		
		}
		rs.close();
		st.close();
		conn.close();
		return mat;
	}
	
	public static List<LogisSend> searchPrepare(PageControl ctrl, List<String[]> paramList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE status = '" + LogisSend.STATUS_TAKE + "'";
		
		Iterator<String[]> ite = paramList.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
					sql += " AND " + str[0] + "='" + str[1] + "'";
			}
		}	
		sql += " ORDER BY (inv*1) ASC";
		System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<LogisSend> list = new ArrayList<LogisSend>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					LogisSend entity = new LogisSend();
					DBUtility.bindResultSet(entity, rs);
					
					InventoryMaster inv = InventoryMaster.select(entity.getMat_code(), conn);
					entity.setUImatname(inv.getDescription());
					
					SaleOrderItem item = new SaleOrderItem();
					item = SaleOrderItem.selectOrder(entity.getItem_run());
					
					SaleOrder order = new SaleOrder();
					order.setOrder_id(item.getOrder_id());
					entity.setUIorder(SaleOrder.select(order));
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
	
	 public static String genIdrun(Connection conn) throws SQLException {
		    String sql = "SELECT id_run FROM " + tableName + " WHERE id_run LIKE 'LOG%' ORDER BY id_run DESC";
		    Statement st = conn.createStatement();
		    ResultSet rs = st.executeQuery(sql);

		    String idrun = "LOG00001";
		    if (rs.next()) {
		      String temp = DBUtility.getString("id_run", rs);
		      idrun = String.valueOf(Integer.parseInt(temp.substring(3, temp.length())) + 100001);
		      idrun = "LOG" + idrun.substring(1, idrun.length());
		      System.out.println(idrun);
		      
		    }
		    rs.close();
		    st.close();
		    return idrun;
		  }
	 
	public static void main(String[] s) throws Exception{
		checkQtyAndQtyall("19","003769","dev3");
	}
}
