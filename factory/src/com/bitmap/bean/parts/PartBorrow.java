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

public class PartBorrow {
	public static String STATUS_BORROW = "1";
	public static String STATUS_RETURN = "0";
	public static String STATUS_SCRAP = "5";
	
	public static String tableName = "pa_borrow_part";
	private static String[] keys = {"run"};
	private static String[] fieldNames = {"update_date","update_by"};
	
	private String run = "";
	private String pn = "";
	private String sn = "";
	private String qty = "";
	private String return_qty = "0";
	private String borrow_by = "";
	private String scrap_qty = "";
	private String return_by = "";
	private Timestamp return_date = null;
	private String status = "";
	private String note = "";
	private String create_by = "";
	private String update_by = "";
	private Timestamp create_date = null;
	private Timestamp update_date = null;
	
	private PartMaster UIMaster = null;
	public PartMaster getUIMaster() {return UIMaster;}
	public void setUIMaster(PartMaster uIMaster) {UIMaster = uIMaster;}
	
	String UIDescription = "";

	public static String status(String status){
		HashMap<String, String> map = new HashMap<String, String>();
		map.put(STATUS_BORROW, "Borrow");
		map.put(STATUS_RETURN, "Return");
		map.put(STATUS_SCRAP, "Scrap");
		return map.get(status);
	}
	
	public static List<String[]> ddl_en(){
		List<String[]> list = new ArrayList<String[]>();
		list.add(new String[]{STATUS_BORROW,"Borrow"});
		list.add(new String[]{STATUS_RETURN,"Return"});
		list.add(new String[]{STATUS_SCRAP,"Scrap"});
		return list;
	}

	
	/**
	 * 
	 * @param entity
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static void borrow(PartBorrow entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		entity.setRun(DBUtility.genNumber(conn, tableName, "run"));
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		entity.setStatus(STATUS_BORROW);
		
		PartSerial pSerial = new PartSerial();
		pSerial.setPn(entity.getPn());
		pSerial.setSn(entity.getSn());
		pSerial.setUpdate_by(entity.getCreate_by());
		PartSerial.borrowPart(pSerial, conn);
		
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	/**
	 * 
	 * @param entity
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static void borrowNonSN(PartBorrow entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		entity.setRun(DBUtility.genNumber(conn, tableName, "run"));
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		entity.setStatus(STATUS_BORROW);
		
		PartMaster pMaster = new PartMaster();
		pMaster.setPn(entity.getPn());
		pMaster = PartMaster.select(pMaster);
		
		int qty = Integer.parseInt(pMaster.getQty()) - Integer.parseInt(entity.getQty());
		pMaster.setQty(qty + "");
		pMaster.setUpdate_by(entity.getCreate_by());
		PartMaster.updateQty(pMaster);
		
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	/**
	 * 
	 * @param ctrl
	 * @param param
	 * @return
	 * @throws IllegalArgumentException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws UnsupportedEncodingException
	 */
	public static List<PartBorrow> selectCtrlParam(PageControl ctrl, List<String[]> param) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE status='" + STATUS_BORROW + "' ";
		
		for (Iterator<String[]> iterator = param.iterator(); iterator.hasNext();) {
			String[] pm = (String[]) iterator.next();
			if (pm[1].length() > 0) {
				sql += " AND " + pm[0] + " ='" + ((pm[1].split("--").length>1)?pm[1].split("--")[0]:pm[1]) + "'";
			}
		}
		
		sql += " ORDER BY create_date DESC";
		
		////System.out.println("sql : " + sql);
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PartBorrow> list = new ArrayList<PartBorrow>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					PartBorrow entity = new PartBorrow();
					DBUtility.bindResultSet(entity, rs);
					entity.setUIMaster(PartMaster.select(entity.getPn(), conn));
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
	
	public static List<PartBorrow> selectWithCTRL(PageControl ctrl, List<String[]> param) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE status='" + STATUS_BORROW + "' ";
		
		for (Iterator<String[]> iterator = param.iterator(); iterator.hasNext();) {
			String[] pm = (String[]) iterator.next();
			if (pm[1].length() > 0) {
				sql += " AND " + pm[0] + " ='" + ((pm[1].split("--").length>1)?pm[1].split("--")[0]:pm[1]) + "'";
			} 
		}
		
		sql += " ORDER BY create_date DESC";  
		
	
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PartBorrow> list = new ArrayList<PartBorrow>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					PartBorrow entity = new PartBorrow();
					DBUtility.bindResultSet(entity, rs);
					entity.setUIMaster(PartMaster.select(entity.getPn(), conn));
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
	
	/**
	 * 
	 * @param borrow
	 * @throws IllegalArgumentException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static void select(PartBorrow borrow) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		select(borrow, conn);
		borrow.setUIMaster(PartMaster.select(borrow.getPn(), conn));
		conn.close();
	}
	
	/**
	 * 
	 * @param borrow
	 * @param conn
	 * @throws IllegalArgumentException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static void select(PartBorrow borrow, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		DBUtility.getEntityFromDB(conn, tableName, borrow, keys);
	}
	
	/**
	 * 
	 * @param entity
	 * @throws IllegalArgumentException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static void return_part(PartBorrow entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		PartSerial pSerial = new PartSerial();
		pSerial.setPn(entity.getPn());
		pSerial.setSn(entity.getSn());
		pSerial.setUpdate_by(entity.getUpdate_by());
		PartSerial.returnPart(pSerial, conn);
		
		entity.setReturn_qty("1");
		entity.setStatus(STATUS_RETURN);
		entity.setReturn_date(DBUtility.getDBCurrentDateTime());
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"status","return_qty","return_date","return_by","update_by","update_date"}, keys);
		
		conn.close();
	}
	
	/**
	 * 
	 * @param entity
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static void scrap_part(PartBorrow entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		entity.setScrap_qty("1");
		entity.setStatus(STATUS_SCRAP);
		entity.setReturn_date(DBUtility.getDBCurrentDateTime());
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"status","scrap_qty","return_date","return_by","update_by","update_date"}, keys);
		
		conn.close();
	}
	
	/**
	 * 
	 * @param entity
	 * @throws IllegalArgumentException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static void return_partNonSN(PartBorrow entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		PartBorrow borrow = new PartBorrow();
		borrow.setRun(entity.getRun());
		select(borrow, conn);
		
		int borrow_qty = Integer.parseInt(borrow.getQty());
		int borrow_return_qty = Integer.parseInt(borrow.getReturn_qty());
		
		int return_qty = Integer.parseInt(entity.getReturn_qty());
		if (borrow_qty == (borrow_return_qty + return_qty)) {
			entity.setReturn_qty((return_qty) + "");
			entity.setStatus(STATUS_RETURN);
			entity.setReturn_date(DBUtility.getDBCurrentDateTime());
			entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
			DBUtility.updateToDB(conn, tableName, entity, new String[]{"status","return_qty","return_date","return_by","update_by","update_date"}, keys);
		} else if (borrow_qty > (borrow_return_qty + return_qty)) {
			entity.setReturn_qty((borrow_return_qty + return_qty) + "");
			entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
			DBUtility.updateToDB(conn, tableName, entity, new String[]{"return_qty","return_by","update_by","update_date"}, keys);
		}
		
		PartMaster master = new PartMaster();
		master.setPn(entity.getPn());
	//	master.setQty(entity.getReturn_qty());

		master.setQty(""+return_qty+"");
		master.setUpdate_by(entity.getUpdate_by());
		PartMaster.updateQtyNonSN(master);
		
		conn.close();
	}
	
	/**
	 * 
	 * @param entity
	 * @throws IllegalArgumentException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static void scrap_partNonSN(PartBorrow entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		PartBorrow borrow = new PartBorrow();
		borrow.setRun(entity.getRun());
		select(borrow, conn);
		
		int borrow_qty = Integer.parseInt(borrow.getQty());
		int borrow_return_qty = Integer.parseInt(borrow.getReturn_qty());
		
		entity.setScrap_qty((borrow_qty - borrow_return_qty) + "");
		entity.setStatus(STATUS_SCRAP);
		entity.setReturn_date(DBUtility.getDBCurrentDateTime());
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"status","scrap_qty","return_date","return_by","update_by","update_date"}, keys);
		
		conn.close();
	}
	
	/**
	 * whan : report_review
	 * <br>
	 * รายงานการยืม
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static List<PartBorrow> report_bor() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		List<PartBorrow> list = new ArrayList<PartBorrow>();
		Connection conn = DBPool.getConnection();
		String sql = "SELECT pab.*,(SELECT pa.description FROM pa_part_master pa WHERE pa.pn = pab.pn) as description FROM " + tableName + " pab ORDER BY (pab.run*1) ASC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			PartBorrow entity = new PartBorrow();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIDescription(DBUtility.getString("description", rs));
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}


public static List<PartBorrow> report_bor(List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		
		List<PartBorrow> list = new ArrayList<PartBorrow>();
		Connection conn = DBPool.getConnection();
		String sql = "SELECT pab.*,(SELECT pa.description FROM pa_part_master pa WHERE pa.pn = pab.pn) as description FROM " + tableName + " pab ";
		sql += " WHERE 1=1 ";
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				
				if (str[0].equalsIgnoreCase("create_date")){
					
					sql +="AND DATE_FORMAT(pab.create_date, '%Y-%m-%d')='"+str[1]+"'" ;
					
				} 
				else if (str[0].equalsIgnoreCase("year_month")){
					
					sql +="AND DATE_FORMAT(pab.create_date, '%Y-%m')='"+str[1]+"'" ;
					
				} 
				else if (str[0].equalsIgnoreCase("date_send2")){
					
					sql +="AND DATE_FORMAT(pab.create_date, '%Y-%m-%d') BETWEEN '"+str[1]+"' AND '"+str[2]+"' ";
					
				}
				
				else {
					
					sql += " AND " + str[0] + "='" + str[1] + "' ";
				}
			}
		}
		
		sql += " ORDER BY (pab.run*1) ASC ";
		
		
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			PartBorrow entity = new PartBorrow();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIDescription(DBUtility.getString("description", rs));
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}

	
	public String getRun() {
		return run;
	}
	public void setRun(String run) {
		this.run = run;
	}
	public String getPn() {
		return pn;
	}
	public void setPn(String pn) {
		this.pn = pn;
	}
	public String getSn() {
		return sn;
	}
	public void setSn(String sn) {
		this.sn = sn;
	}
	public String getQty() {
		return qty;
	}
	public void setQty(String qty) {
		this.qty = qty;
	}
	public String getBorrow_by() {
		return borrow_by;
	}
	public void setBorrow_by(String borrow_by) {
		this.borrow_by = borrow_by;
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
	public String getUpdate_by() {
		return update_by;
	}
	public void setUpdate_by(String update_by) {
		this.update_by = update_by;
	}
	public Timestamp getCreate_date() {
		return create_date;
	}
	public void setCreate_date(Timestamp create_date) {
		this.create_date = create_date;
	}
	public Timestamp getUpdate_date() {
		return update_date;
	}
	public void setUpdate_date(Timestamp update_date) {
		this.update_date = update_date;
	}
	public Timestamp getReturn_date() {
		return return_date;
	}
	public void setReturn_date(Timestamp return_date) {
		this.return_date = return_date;
	}
	public String getReturn_qty() {
		return return_qty;
	}
	public void setReturn_qty(String return_qty) {
		this.return_qty = return_qty;
	}
	public String getReturn_by() {
		return return_by;
	}
	public void setReturn_by(String return_by) {
		this.return_by = return_by;
	}
	public String getScrap_qty() {
		return scrap_qty;
	}
	public void setScrap_qty(String scrap_qty) {
		this.scrap_qty = scrap_qty;
	}
	public String getUIDescription() {
		return UIDescription;
	}
	public void setUIDescription(String uIDescription) {
		UIDescription = uIDescription;
	}
	
}