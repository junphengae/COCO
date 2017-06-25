package com.bitmap.bean.sale;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import com.bitmap.bean.inventory.InventoryMaster;
import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;

public class Receive {
	public static String tableName = "sale_receive";
	private static String[] keys = {"id_receive"};
	private static String[] fieldNames = {"invoice","cus_id","order_id","type_inv","FG","pk_id","qty","receive_date","status","types","update_by","update_date"};
	
	String id_receive = "";
	String cus_id = "";
	String order_id = "";
	String invoice = "";
	String type_inv = "";
	String FG = "";
	String pk_id = "";
	String qty = "";
	Date receive_date = null;
	String status = "";
	String types = "";
	String create_by = "";
	Timestamp create_date = null;
	String update_by = "";
	Timestamp update_date = null;
	
	public static String STATUS_OPEN = "10";
	public static String STATUS_RECEIVE = "20";
	public static String STATUS_VERIFY = "30";
	public static String STATUS_CLOSE = "00";
	
	InventoryMaster UImat = new InventoryMaster();

	public static void insert(Receive entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();	
		entity.setId_receive(DBUtility.genNumber(conn, tableName, "id_receive"));
		entity.setStatus(STATUS_OPEN);
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	public static void update(Receive entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();	
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity,new String[] {"qty","FG","receive_date"}, keys);
		conn.close();
	}
	
	public static Receive select(Receive entity) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	
	public static void updateStatus(Receive entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();	
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity,new String[] {"status","update_by","update_date"}, keys);
		conn.close();
	}
	
	public static void updateTypeStatus(Receive entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();	
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity,new String[] {"status","types","update_by","update_date"}, keys);
		conn.close();
	}
	
	public static List<Receive> selectInvWithCTRL(PageControl ctrl, List<String[]> paramList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1";
		
		Iterator<String[]> ite = paramList.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {	
					sql += " AND " + str[0] + "='" + str[1] + "'";
			}
		}	
		sql += " ORDER BY (id_receive*1) ASC";
		sql += " LIMIT 0,1000 ";
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<Receive> list = new ArrayList<Receive>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					Receive entity = new Receive();
					DBUtility.bindResultSet(entity, rs);
					entity.setUImat(InventoryMaster.select(entity.getFG(), conn));
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
	
	public String getCus_id() {
		return cus_id;
	}

	public void setCus_id(String cus_id) {
		this.cus_id = cus_id;
	}

	public String getPk_id() {
		return pk_id;
	}

	public void setPk_id(String pk_id) {
		this.pk_id = pk_id;
	}

	public String getId_receive() {
		return id_receive;
	}
	public void setId_receive(String id_receive) {
		this.id_receive = id_receive;
	}
	public String getInvoice() {
		return invoice;
	}
	public void setInvoice(String invoice) {
		this.invoice = invoice;
	}
	public String getType_inv() {
		return type_inv;
	}
	public void setType_inv(String type_inv) {
		this.type_inv = type_inv;
	}
	public String getFG() {
		return FG;
	}
	public void setFG(String fG) {
		FG = fG;
	}
	public String getQty() {
		return qty;
	}
	public void setQty(String qty) {
		this.qty = qty;
	}
	public Date getReceive_date() {
		return receive_date;
	}
	public void setReceive_date(Date receive_date) {
		this.receive_date = receive_date;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
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
	public InventoryMaster getUImat() {
		return UImat;
	}
	public void setUImat(InventoryMaster uImat) {
		UImat = uImat;
	}
	public String getOrder_id() {
		return order_id;
	}
	public void setOrder_id(String order_id) {
		this.order_id = order_id;
	}
	public String getTypes() {
		return types;
	}
	public void setTypes(String types) {
		this.types = types;
	}
	
		
	
	
	
	
}
