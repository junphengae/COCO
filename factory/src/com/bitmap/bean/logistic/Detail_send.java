package com.bitmap.bean.logistic;

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

import com.bitmap.bean.inventory.InventoryMaster;
import com.bitmap.bean.sale.SaleOrder;
import com.bitmap.bean.sale.SaleOrderItem;
import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;

public class Detail_send {

	public static String tableName = "logis_detail_send" ;
	public static String[] keys = {"run","id_run"};	
	
	String id_run = "";
	String run = "";
	String create_by = "";
	Timestamp create_date = null;
	
	LogisSend UIlogis_send = new LogisSend();
	String UImatname = "";
	String UInamecus = "";
	
	public static String status(String status){
		HashMap<String , String> map = new HashMap<String, String>();
		map.put("10", "ใบส่งของ");
		map.put("20", "ใบส่งของชั่วคราว");
		return map.get(status);
	}
	
	public String getUImatname() {
		return UImatname;
	}

	public void setUImatname(String uImatname) {
		UImatname = uImatname;
	}

	public String getUInamecus() {
		return UInamecus;
	}

	public void setUInamecus(String uInamecus) {
		UInamecus = uInamecus;
	}

	public LogisSend getUIlogis_send() {
		return UIlogis_send;
	}
	public void setUIlogis_send(LogisSend uIlogis_send) {
		UIlogis_send = uIlogis_send;
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
	
	public static void insert(Detail_send entity) throws IllegalAccessException, InvocationTargetException, SQLException, IllegalArgumentException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();		
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	/**
	 * Used : logis_send_product
	 * <br>
	 * ลบรายการ invoice ตามเลขที่ inv และ ประเภท
	 * @param entity
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws SQLException
	 * @throws IllegalArgumentException
	 * @throws UnsupportedEncodingException
	 */
	public static void delete(Detail_send entity) throws IllegalAccessException, InvocationTargetException, SQLException, IllegalArgumentException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();			
		DBUtility.deleteFromDB(conn, tableName, entity,keys);	
		conn.close();
	}
	
	
	public static String countrow(String run) throws SQLException{
		String sql = "SELECT COUNT(run) as count FROM " + tableName + " WHERE run = '" + run + "'";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		//System.out.println(sql);
		String count = "";
		while (rs.next()) {
			count = DBUtility.getString("count", rs);
		}
		rs.close();
		st.close();
		conn.close();
		return count;
	}
	
	public static boolean selectEmptyByInv(String invoice,String type_inv) throws SQLException{
		String sql = "SELECT * FROM " + tableName + " WHERE invoice = '" + invoice + "' AND type_inv = '" + type_inv + "'";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		boolean count = false;
		if(rs.next()) {
			count = true;
		}
		rs.close();
		st.close();
		conn.close();
		return count;
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
	 * Used : logis_send_product,
	 * <br>
	 * หลังจากยืนยันการกดส่งสินค้า จะ updatestatus sale_order_item = 90 ตามใบ inv หรือ ใบส่งของชั่วคราว
	 * <br>
	 * และ update status sale_order = 90 เมื่อ item ทุกตัวเป็น 90
	 * @param run
	 * @param update_by
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws UnsupportedEncodingException
	 */
	/*public static void updateSendFin(String run,String update_by) throws SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{	
		String sql = "select * from " + tableName + " where run = "+ run;
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		while(rs.next()){
			Detail_send send = new Detail_send();
			DBUtility.bindResultSet(send, rs);
			
			SaleOrderItem item = new SaleOrderItem();
			item.setStatus(SaleOrderItem.STATUS_SEND_PRODUCT);
			item.setUpdate_by(update_by);
			if(send.getType_inv().equalsIgnoreCase(STATUS_INV)){
				item.setInvoice(send.getInvoice());
				SaleOrderItem.updateStatusByInv(item,"invoice");
			}else{
				item.setTemp_invoice(send.getInvoice());
				SaleOrderItem.updateStatusByInv(item,"temp_invoice");
			}	
				
			List list = SaleOrderItem.selectOrderidByInvoice(send.getInvoice(), send.getType_inv(), conn);
			Iterator ite = list.iterator();
			
			while(ite.hasNext()){			
				SaleOrderItem item2 = (SaleOrderItem) ite.next();
				
				String count = SaleOrderItem.countItemrun(item2.getOrder_id(),SaleOrderItem.STATUS_SEND_PRODUCT, conn);
				String count2 = SaleOrderItem.countAllrun(item2.getOrder_id(), conn);

				if(count.equalsIgnoreCase(count2)){
					SaleOrder sale = new SaleOrder();
					sale.setOrder_id(item2.getOrder_id());
					sale.setStatus(SaleOrder.STATUS_FIN);
					sale.setUpdate_by(send.getUpdate_by());
					SaleOrder.updateStatus(sale);
				}
				
			}
			
		}		
		rs.close();
		st.close();
		conn.close();
	}*/
	
	/**
	 * Used : logis_send_product
	 * <br>
	 * update by run
	 * @param entity
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws SQLException
	 */
	public static void updatestatus(Detail_send entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();		
		DBUtility.updateToDB(conn, tableName, entity,new String[] {"update_date","update_by"},new String[] {"run"});		
		conn.close();
	}
	
	/**
	 * whan : logis_send_product
	 * <br>
	 * select สินค้าที่จัดลงมาที่คิวรถนี้
	 * @param run
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static List<Detail_send> selectByRun(String run) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " as detail,logis_send as send WHERE detail.id_run = send.id_run AND detail.run = '" + run + "'";
		sql += " ORDER BY (send.inv*1) ASC";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Detail_send> list = new ArrayList<Detail_send>();
		while (rs.next()) {
					Detail_send entity = new Detail_send();
					DBUtility.bindResultSet(entity, rs);		
					entity.setUIlogis_send(LogisSend.select(entity.getId_run(), conn));
					
					InventoryMaster inv = InventoryMaster.select(entity.getUIlogis_send().getMat_code(), conn);
					entity.setUImatname(inv.getDescription());
					
					SaleOrderItem item = new SaleOrderItem();
					item = SaleOrderItem.selectOrder(entity.getUIlogis_send().getItem_run());
					
					SaleOrder order = new SaleOrder();
					order.setOrder_id(item.getOrder_id());
					order = SaleOrder.select(order);
					
					entity.setUInamecus(order.getUICustomer().getCus_name());
					list.add(entity);
		}
		rs.close();
		conn.close();
		return list;
	}
	/**
	 * whan : LogisManage.ap_send
	 * <br>
	 * 
	 * @param run
	 * @param update_by
	 * @throws Exception 
	 */
	public static void selectByrun(String run,String update_by) throws Exception{
		String sql = "SELECT * FROM " + tableName + " as detail,logis_send as send WHERE detail.run = '" + run + "'";
		sql += " AND detail.id_run = send.id_run";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		//System.out.println(sql);
		while (rs.next()) {
			LogisSend entity = new LogisSend();
			DBUtility.bindResultSet(entity, rs);
			
			entity.setStatus(LogisSend.STATUS_FIN);
			DBUtility.updateToDB(conn,LogisSend.tableName, entity,new String[]{"status"},LogisSend.keys);
			
			LogisSend.checkQtyAndQtyall(entity.getItem_run(),entity.getMat_code(),update_by);
		}
		rs.close();
		st.close();
		conn.close();
	}
}
