package com.bitmap.bean.parts;

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

import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;

public class PartOrder {
	public static String STATUS_CANCEL = "00";
	
	public static String STATUS_ORDER = "10";
	
	public static String STATUS_AC_APPROVED = "20";
	public static String STATUS_AC_PASS = "21";
	public static String STATUS_AC_REPL = "22";
	public static String STATUS_AC_REJECT = "25";
	
	public static String STATUS_MD_APPROVED = "30";
	public static String STATUS_MD_REJECT = "35";
	
	public static String STATUS_PO_OPEN = "40";
	public static String STATUS_PO_CLOSE = "41";
	public static String STATUS_PO_TERMINATE = "45";
	
	public static String status(String status){
		HashMap<String , String> map = new HashMap<String, String>();
		map.put("00", "ยกเลิก");
		map.put("10", "รออนุมัติ");
		map.put("20", "บัญชีอนุมัติ");
		map.put("21", "รอผู้บริหารอนุมัติ");
		map.put("25", "บัญชียกเลิก");
		map.put("30", "ผู้บริหารอนุมัติ");
		map.put("35", "ผู้บริหารยกเลิก");
		map.put("40", "เปิด PO แล้ว");
		map.put("41", "ปิด PO แล้ว");
		map.put("45", "ยกเลิก PO");
		
		return map.get(status);
	}
	
	public static String tableName = "pur_purchase_request";
	private static String[] keys = {"id"};
	private static String[] updateField = {"status","update_by","update_date"};
	private static String[] updateNoteField = {"status","update_by","update_date","note"};
	private static String[] approveField = {"status","approve_by","approve_date"};
	private static String[] approveNoteField = {"status","approve_by","approve_date","note"};
	
	String po = "";
	String id = "";
	String pn = "";
	String order_qty = "";
	String vendor_id = "";
	String status = "10";
	String note = "";
	String create_by = "";
	String update_by = "";
	String approve_by = "";
	Timestamp create_date = null;
	Timestamp update_date = null;
	Timestamp approve_date = null;
	
	private PartVendor partVendor = new PartVendor();
	public PartVendor getUIPartVendor() {return partVendor;}
	public void setUIPartVendor(PartVendor partVendor) {this.partVendor = partVendor;}
	
	private PartMaster UIMaster = new PartMaster();
	public PartMaster getUIMaster() {return UIMaster;}
	public void setUIMaster(PartMaster uIMaster) {UIMaster = uIMaster;}
	
	public static List<String[]> vendorDropdown() throws SQLException{
		String sql = "SELECT DISTINCT(pr.vendor_id) AS value, vd.vendor_name AS text FROM " + tableName + "  pr INNER JOIN " + Vendor.tableName + " vd ON pr.vendor_id = vd.vendor_id";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<String[]> list = new ArrayList<String[]>();
		while(rs.next()){
			HashMap<String,Object> entity = DBUtility.getEntity(rs);
			String value = (String) entity.get("value");
			String text = (String) entity.get("text");
			String[] data = {value,text};
			list.add(data);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static PartOrder select(String id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		PartOrder entity = new PartOrder();
		entity.setId(id);
		select(entity);
		return entity;
	}
	
	public static void select(PartOrder entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
	}
	
	public static void insert(PartOrder entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		
		entity.setId(DBUtility.genNumber(conn, tableName, "id"));
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		
		conn.close();
	}
	
	public static void updateStatus(PartOrder entity, String[] fieldNames) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setApprove_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();
	}
	
	public static void status_cancel(PartOrder entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus(STATUS_CANCEL);
		updateStatus(entity, updateNoteField);
	}
	
	public static void status_ac_approve(PartOrder entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus(STATUS_AC_APPROVED);
		updateStatus(entity, approveNoteField);
	}
	
	public static void status_ac_pass(PartOrder entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus(STATUS_AC_PASS);
		updateStatus(entity, updateNoteField);
	}
	
	public static void status_ac_reject(PartOrder entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus(STATUS_AC_REJECT);
		updateStatus(entity, approveNoteField);
	}
	
	public static void status_md_approve(PartOrder entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus(STATUS_MD_APPROVED);
		updateStatus(entity, approveNoteField);
	}
	
	public static void status_md_reject(PartOrder entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus(STATUS_MD_REJECT);
		updateStatus(entity, approveNoteField);
	}
	
	public static void status_po_open(PartOrder entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus(STATUS_PO_OPEN);
		updateStatus(entity, new String[]{"po","status","approve_by","approve_date"});
	}
	
	public static void status_po_close(PartOrder entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus(STATUS_PO_CLOSE);
		updateStatus(entity, approveNoteField);
	}
	
	public static void status_po_terminate(PartOrder entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus(STATUS_PO_TERMINATE);
		updateStatus(entity, approveNoteField);
	}
	
	public static List<PartOrder> selectList() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE status!='" + STATUS_CANCEL + " OR status!=" + "'  ORDER BY (id*1) ASC";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PartOrder> list = new ArrayList<PartOrder>();
		while (rs.next()) {
			PartOrder entity = new PartOrder();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIPartVendor(PartVendor.select(entity.getPn(), entity.getVendor_id(), conn));
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<PartOrder> selectListByPO(String po, Connection conn) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE po='" + po + "' ORDER BY (id*1) ASC";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PartOrder> list = new ArrayList<PartOrder>();
		while (rs.next()) {
			PartOrder entity = new PartOrder();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIMaster(PartMaster.select(entity.getPn(), conn));
			entity.setUIPartVendor(PartVendor.select(entity.getPn(), entity.getVendor_id(), conn));
			list.add(entity);
		}
		
		rs.close();
		st.close();
		return list;
	}
	
	public static List<PartOrder> selectWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName;
		
		int i = 0;
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (i == 0) {
					sql += " WHERE " + str[0] + "='" + str[1] + "'";
					i = 1;
				} else {
					sql += " AND " + str[0] + "='" + str[1] + "'";
				}
			}
		}
		
		sql += " ORDER BY (id*1) ASC";
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PartOrder> list = new ArrayList<PartOrder>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					PartOrder entity = new PartOrder();
					DBUtility.bindResultSet(entity, rs);
					entity.setUIPartVendor(PartVendor.select(entity.getPn(), entity.getVendor_id(), conn));
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
	
	public static List<PartOrder> select4MDWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE (status='" + STATUS_AC_APPROVED + "' OR status='" + STATUS_AC_PASS + "' OR status='" + STATUS_ORDER + "')";
		
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
		
		List<PartOrder> list = new ArrayList<PartOrder>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					PartOrder entity = new PartOrder();
					DBUtility.bindResultSet(entity, rs);
					entity.setUIPartVendor(PartVendor.select(entity.getPn(), entity.getVendor_id(), conn));
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
	
	public String getPo() {
		return po;
	}
	public void setPo(String po) {
		this.po = po;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPn() {
		return pn;
	}
	public void setPn(String pn) {
		this.pn = pn;
	}
	public String getOrder_qty() {
		return order_qty;
	}
	public void setOrder_qty(String order_qty) {
		this.order_qty = order_qty;
	}
	public String getVendor_id() {
		return vendor_id;
	}
	public void setVendor_id(String vendor_id) {
		this.vendor_id = vendor_id;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getNote() {
		return note;
	}
	public void setNote(String note) {
		this.note = note;
	}
	public String getCreate_by() {
		return create_by;
	}
	public void setCreate_by(String create_by) {
		this.create_by = create_by;
	}
	public String getApprove_by() {
		return approve_by;
	}
	public void setApprove_by(String approve_by) {
		this.approve_by = approve_by;
	}
	public Timestamp getCreate_date() {
		return create_date;
	}
	public void setCreate_date(Timestamp create_date) {
		this.create_date = create_date;
	}
	public Timestamp getApprove_date() {
		return approve_date;
	}
	public void setApprove_date(Timestamp approve_date) {
		this.approve_date = approve_date;
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