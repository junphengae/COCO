package com.bitmap.bean.inventory;

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
import java.util.List;

import org.apache.tomcat.jni.Local;

import com.bitmap.bean.purchase.PurchaseOrder;
import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.utils.Money;

public class InventoryLot {
	public static String tableName = "inv_lot";
	private static String[] keys = {"lot_no"};
	
	String mat_code = "";
	String lot_no = "";
	String po = "";
	String invoice = "";
	String lot_qty = "";
	String lot_price = "";
	String lot_status = "";
	Date lot_expire = null;
	String lot_location = null;
	Date mfg = null;
	String vendor_id = "";
	String vendor_mat_code = "";
	String vendor_lot_no = "";
	String icp_data = "";
	String note = "";
	String create_by = "";
	Timestamp create_date = null;
	String update_by = "";
	Timestamp update_date = null;
	
	private InventoryLotControl lot_control;
	private InventoryMaster UIMat = new InventoryMaster();
	private Vendor UIVendor = new Vendor();
	
	String UIVendors = "";
	String UICatName = "";
	String UISubCatName = "";
	String UILotB = "";
	
	public static boolean select(InventoryLot entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		boolean check = false;
		Connection conn = DBPool.getConnection();
		check = DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"mat_code","lot_no"});
		entity.setUILot_control(InventoryLotControl.selectActive(entity.getLot_no(), conn));
		conn.close();
		return check;
	}
	
	public static int sumInlet(String pro_id,String item_id) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		String sql = "SELECT sum(lot_qty) as qty FROM " + tableName + " WHERE po = '" + pro_id  + "' AND mat_code = '" + item_id + "'";
		//System.out.println(sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		int val = 0;
		while (rs.next()){
			val = DBUtility.getInteger("qty", rs);
		}
		rs.close();
		st.close();
		conn.close();
		return val;
	}
	
	public static Double totalInlet(String po,String mat_code) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		String sql = "SELECT sum(lot_qty) as qty FROM " + tableName + " WHERE po = '" + po  + "' AND mat_code = '" + mat_code + "'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		Double val = 0.0;
		while (rs.next()){
			val = DBUtility.getDecimal("qty", rs);
		}
		rs.close();
		st.close();
		conn.close();
		return val;
	}
	
	public static String sumInletString(String pro_id,String item_id) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		String sql = "SELECT sum(lot_qty) as qty FROM " + tableName + " WHERE po = '" + pro_id  + "' AND mat_code = '" + item_id + "'";
		//System.out.println(sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		String val = "0";
		while (rs.next()){
			val = DBUtility.getString("qty", rs);
		}
		rs.close();
		st.close();
		conn.close();
		return val;
	}
	
	public static InventoryLot select(String lot_no, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		InventoryLot entity = new InventoryLot();
		entity.setLot_no(lot_no);
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"lot_no"});
		entity.setUIMat(InventoryMaster.select(entity.getMat_code(), conn));
		return entity;
	}
	
	public static InventoryLot select(String lot_no) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		InventoryLot entity = new InventoryLot();
		entity.setLot_no(lot_no);
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"lot_no"});
		entity.setUIMat(InventoryMaster.select(entity.getMat_code(), conn));
		conn.close();
		return entity;
	}
	
	public static List<InventoryLot> selectList(String mat_code) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE mat_code='" + mat_code + "' ORDER BY (lot_no*1) ASC";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<InventoryLot> list = new ArrayList<InventoryLot>();
		while (rs.next()) {
			InventoryLot entity = new InventoryLot();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<InventoryLot> selectList4PurchaseReport(String mat_code, String po) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE mat_code='" + mat_code + "' AND po='" + po + "' ORDER BY (lot_no*1) ASC";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<InventoryLot> list = new ArrayList<InventoryLot>();
		while (rs.next()) {
			InventoryLot entity = new InventoryLot();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<InventoryLot> selectActiveList(String mat_code , String isLotOld) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		
		String sql = "SELECT * FROM " + tableName + " WHERE mat_code='" + mat_code + "' ";				
		if(isLotOld.equalsIgnoreCase("T")){
			sql+=" AND lot_status in ('I')  ";
		}else if (isLotOld.equalsIgnoreCase("F")) {
			sql+=" AND lot_status in ('A')  ";
		}
		sql+=" ORDER BY (lot_no*1) DESC";
		
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<InventoryLot> list = new ArrayList<InventoryLot>();
		while (rs.next()) {
			InventoryLot entity = new InventoryLot();
			DBUtility.bindResultSet(entity, rs);
			entity.setUILot_control(InventoryLotControl.selectActive(entity.getLot_no(), conn));
			if(entity.getLot_status().equalsIgnoreCase("I"))
				entity.getUILot_control().setLot_balance("0");
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
public static List<InventoryLot> selectActiveList(String mat_code) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		
		String sql = "SELECT * FROM " + tableName + " WHERE mat_code='" + mat_code + "' ";						
		sql+=" AND lot_status in ('A','I')  ";
		sql+=" ORDER BY (lot_no*1) DESC		";
		
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<InventoryLot> list = new ArrayList<InventoryLot>();
		while (rs.next()) {
			InventoryLot entity = new InventoryLot();
			DBUtility.bindResultSet(entity, rs);
			entity.setUILot_control(InventoryLotControl.selectActive(entity.getLot_no(), conn));
			if(entity.getLot_status().equalsIgnoreCase("I"))
				entity.getUILot_control().setLot_balance("0");
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<InventoryLot> selectActiveList() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE lot_status='A' ORDER BY (mat_code*1),(lot_no*1) ASC";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		//System.out.println(sql);
		List<InventoryLot> list = new ArrayList<InventoryLot>();
		while (rs.next()) {
			InventoryLot entity = new InventoryLot();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIMat(InventoryMaster.select(entity.getMat_code(), conn));
			entity.setUILot_control(InventoryLotControl.selectActive(entity.getLot_no(), conn));
			entity.setUIVendor(Vendor.select(entity.getVendor_id(), conn));
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<InventoryLot> selectActiveListNEW() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT lot.*,m.* ,(SELECT v.vendor_name FROM inv_vendor v WHERE lot.vendor_id = v.vendor_id) as uivendor_name ,";
		sql += "(SELECT ctrl.lot_balance FROM inv_lot_control ctrl WHERE lot.lot_no = ctrl.lot_no AND ctrl.control_status='A') as uilotbalance,";
		sql += "(SELECT c.cat_name_short FROM inv_categories c WHERE m.cat_id = c.cat_id AND m.group_id = c.group_id) as uicatname,";
		sql += "(SELECT s.sub_cat_name_short FROM inv_sub_categories s WHERE m.cat_id = s.cat_id AND m.group_id = s.group_id AND m.sub_cat_id = s.sub_cat_id) as uisubcatname";
		sql += " FROM inv_lot lot,inv_master m WHERE m.mat_code = lot.mat_code AND lot.lot_status='A' ORDER BY (lot.mat_code*1),(lot.lot_no*1) ASC";
		
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<InventoryLot> list = new ArrayList<InventoryLot>();
		while (rs.next()) {
			InventoryLot entity = new InventoryLot();
			DBUtility.bindResultSet(entity, rs);
			
			InventoryMaster mat = new InventoryMaster();
			DBUtility.bindResultSet(mat, rs);
			
			entity.setUIMat(mat);
			entity.setUILotB(DBUtility.getString("uilotbalance", rs));
			entity.setUICatName(DBUtility.getString("uicatname", rs));
			entity.setUISubCatName(DBUtility.getString("uisubcatname", rs));
			entity.setUIVendors(DBUtility.getString("uivendor_name", rs));
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static String selectActiveSum(String mat_code, Connection conn) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE mat_code='" + mat_code + "' AND lot_status='A' ORDER BY (lot_no*1) ASC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		String sum = "0";
		//System.out.println(sql);
		while (rs.next()) {
			InventoryLot entity = new InventoryLot();
			DBUtility.bindResultSet(entity, rs);
			sum = Money.removeCommas(Money.add(sum, InventoryLotControl.selectActive(entity.getLot_no(), conn).getLot_balance()));
		}
		rs.close();
		st.close();
		
		return sum;
	}
	
	public static InventoryLot checkFifo(InventoryLot entity) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		String sql = "SELECT * FROM " + tableName + " WHERE mat_code='" + entity.getMat_code() + "' AND lot_status='A'  AND lot_no= '" + entity.getLot_no() + "'    "; //ORDER BY (lot_no*1) ASC
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		InventoryLot lot = new InventoryLot();
		
		String lot_no = "";
		if (rs.next()) {
			lot_no = DBUtility.getString("lot_no", rs);
			//System.out.println("checkFifo lot_no:"+lot_no);
			if (lot_no.equalsIgnoreCase(entity.getLot_no())) {
				DBUtility.bindResultSet(lot, rs);
				lot.setUILot_control(InventoryLotControl.selectActive(lot_no, conn));
			}
		}
		
		rs.close();
		st.close();
		conn.close();
		return lot;
	}
	
	public static List<InventoryLot> report(String year, String month,String mat_code, String lot_no) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		Calendar sd = Calendar.getInstance();
		sd.clear();
		sd.set(Calendar.YEAR, Integer.parseInt(year));
		sd.set(Calendar.MONTH, Integer.parseInt(month) - 1);
		sd.set(Calendar.DATE, 1);
		
		SimpleDateFormat DATE_DATABASE_FORMAT = new SimpleDateFormat("yyyy-MM-dd");
		String s = DATE_DATABASE_FORMAT.format(sd.getTime());
		
		sd.add(Calendar.MONTH, +1);
		sd.add(Calendar.DATE, -1);
		String e = DATE_DATABASE_FORMAT.format(sd.getTime());
		
		String sql = "SELECT * FROM " + tableName + " WHERE create_date between '" + s + " 00:00:00.00' AND '" + e + " 23:59:59.99'";
		//System.out.println("m : " + sql);
		if(!(mat_code.equalsIgnoreCase(""))){
			sql += " AND mat_code = '" + mat_code + "'";
		}
		if(!lot_no.equals("")){
			sql+= "AND lot_no = '" +lot_no+"' ";
		}
		sql += " ORDER BY (mat_code*1),(lot_no*1) ASC";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<InventoryLot> list = new ArrayList<InventoryLot>();
		while (rs.next()) {
			InventoryLot entity = new InventoryLot();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIMat(InventoryMaster.select(entity.getMat_code(), conn));
			entity.setUIVendor(Vendor.select(entity.getVendor_id(), conn));
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		
		return list;
	}
	/**
	 * whan : report_review
	 * <br>
	 * แก้ไขหน้ารายงานเพิ่ม ค้นหาตาม matcode
	 * @param d
	 * @param mat_code
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws ParseException 
	 */
	public static List<InventoryLot> report(Date d1 ,Date d2,String mat_code, String lot_no) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException, ParseException{
		Connection conn = DBPool.getConnection();
		
		String s =  DBUtility.DATE_DATABASE_FORMAT.format(d1.getTime());
		String e = DBUtility.DATE_DATABASE_FORMAT.format(d2.getTime());
		
		String sql = "SELECT * FROM " + tableName + " WHERE create_date between '" + s + " 00:00:00.00' AND '" + e + " 23:59:59.99'"; 
		
		if(!(mat_code.equalsIgnoreCase(""))){
			sql += " AND mat_code = '" + mat_code + "'";
		}
		
		if(!lot_no.equals("")){
			sql+= "AND lot_no = '" +lot_no+"' ";
		}
		sql += " ORDER BY (mat_code*1),(lot_no*1) ASC";
	//	System.out.println("sql : " + sql);
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<InventoryLot> list = new ArrayList<InventoryLot>();
		while (rs.next()) {
			InventoryLot entity = new InventoryLot();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIMat(InventoryMaster.select(entity.getMat_code(), conn));
			entity.setUIVendor(Vendor.select(entity.getVendor_id(), conn));
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		
		return list;
	}
	
	public static List<InventoryLot> report4PR(String mat_code) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		Calendar today = Calendar.getInstance();
		today.setTime(DBUtility.getCurrentDate());
		//today.set(Calendar.DATE, 1);
		
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		
		String e = df.format(today.getTime());
		
		today.add(Calendar.MONTH, -3);
		String s = df.format(today.getTime());

		String sql = "SELECT * FROM " + tableName + " WHERE (create_date between '" + s + " 00:00:00.00' AND '" + e + " 23:59:59.99') AND mat_code='" + mat_code + "' ORDER BY (lot_no*1) DESC";
		//System.out.println(sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<InventoryLot> list = new ArrayList<InventoryLot>();
		while (rs.next()) {
			InventoryLot entity = new InventoryLot();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIVendor(Vendor.select(entity.getVendor_id(), conn));
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		
		return list;
	}
	
	public static String reportSUM4PR(String mat_code) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		Calendar today = Calendar.getInstance();
		today.setTime(DBUtility.getCurrentDate());
		//today.set(Calendar.DATE, 1);
		
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		
		String e = df.format(today.getTime());
		
		today.add(Calendar.MONTH, -3);
		String s = df.format(today.getTime());
		
		String sql = "SELECT SUM(lot_qty) as sum FROM " + tableName + " WHERE (create_date between '" + s + " 00:00:00.00' AND '" + e + " 00:00:00.00') AND mat_code='" + mat_code + "' GROUP BY mat_code";
		//System.out.println("m : " + sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		String sum = "0";
		
		if (rs.next()) {
			sum = DBUtility.getString("sum", rs);
		}
		rs.close();
		st.close();
		conn.close();
		
		return sum;
	}
	
	public static void insert(InventoryLot entity) throws IllegalAccessException, InvocationTargetException, SQLException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		entity.setLot_no(genLotNo(entity, conn));
		entity.setLot_status("A");
		DBUtility.insertToDB(conn, tableName, entity);
		InventoryLotControl.initLot(entity, conn);
		
		InventoryMaster master = new InventoryMaster();
		master.setMat_code(entity.getMat_code());
		master.setBalance(InventoryLot.selectActiveSum(entity.getMat_code(), conn));
		InventoryMaster.updateBalance(master, conn);
		conn.close();
	}
	
	public static void insert_by_invoice(InventoryLot entity) throws IllegalAccessException, InvocationTargetException, SQLException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		entity.setLot_no(genLotNo(entity, conn));
		entity.setLot_status("A");
		DBUtility.insertToDB(conn, tableName, entity);
		InventoryLotControl.initLot(entity, conn);
		
		InventoryMaster master = new InventoryMaster();
		master.setMat_code(entity.getMat_code());
		master.setBalance(InventoryLot.selectActiveSum(entity.getMat_code(), conn));
		InventoryMaster.updateBalance(master, conn);
		
		PurchaseOrder.controlStatus(entity.getPo(), entity.getCreate_by());
		conn.close();
	}
	
	private static String genLotNo(InventoryLot entity, Connection conn) throws SQLException{
		String sql = "SELECT lot_no FROM " + tableName + " ORDER BY (lot_no*1) DESC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		String lot_no = "1";
		if (rs.next()) {
			String temp = DBUtility.getString("lot_no", rs);
			lot_no = (Integer.parseInt(temp) + 1) + "";
		}
		
		rs.close();
		st.close();
		return lot_no;
	}
	
	public static void updateIStatus(Connection conn,InventoryLotControl lotControl) throws IllegalAccessException, InvocationTargetException, SQLException{
		InventoryLot entity = new InventoryLot();
		entity.setLot_no(lotControl.getLot_no());	
		entity.setLot_status("I");
		entity.setUpdate_by(lotControl.getUpdate_by());
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"lot_status","update_by","update_date"}, new String[]{"lot_no"});
	}
	
	public static void update(InventoryLot entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"po","invoice","lot_expire","vendor_id","vendor_mat_code","vendor_lot_no","icp_data","lot_price","update_by","update_date","note"}, keys);
		conn.close();
	}
	
	public static boolean selectMatANDLotno(String lot_no,String mat_code) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		InventoryLot entity = new InventoryLot();
		entity.setLot_no(lot_no);
		entity.setMat_code(mat_code);
		boolean check  = DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"lot_no","mat_code"});
		conn.close();
		return check;
	}
	
	public static InventoryLot selectMatANDLotno(InventoryLot entity,Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"lot_no","mat_code"});
		return entity;
	}
	
	public static void updateAStatus(Connection conn,InventoryLot lot) throws IllegalAccessException, InvocationTargetException, SQLException{	
		DBUtility.updateToDB(conn, tableName, lot, new String[]{"lot_status","update_by","update_date"}, new String[]{"lot_no"});
	}
	
	public static List<InventoryMaster> test() throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT m.* FROM inv_lot lot,inv_master m WHERE m.mat_code = lot.mat_code AND lot.lot_status='A' ORDER BY (lot.mat_code*1),(lot.lot_no*1) ASC";

		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<InventoryMaster> list = new ArrayList<InventoryMaster>();
 		while (rs.next()) {
 			InventoryMaster entity = new InventoryMaster();
			DBUtility.bindResultSet(entity, rs);

			list.add(entity);
		}
		
		rs.close();
		st.close();
		return list;
	}
	public String getMat_code() {
		return mat_code;
	}

	public void setMat_code(String mat_code) {
		this.mat_code = mat_code;
	}

	public String getLot_no() {
		return lot_no;
	}

	public void setLot_no(String lot_no) {
		this.lot_no = lot_no;
	}

	public String getPo() {
		return po;
	}

	public void setPo(String po) {
		this.po = po;
	}

	public String getInvoice() {
		return invoice;
	}

	public void setInvoice(String invoice) {
		this.invoice = invoice;
	}

	public String getLot_qty() {
		return lot_qty;
	}

	public void setLot_qty(String lot_qty) {
		this.lot_qty = lot_qty;
	}

	public String getLot_price() {
		return lot_price;
	}

	public void setLot_price(String lot_price) {
		this.lot_price = lot_price;
	}

	public String getLot_status() {
		return lot_status;
	}

	public void setLot_status(String lot_status) {
		this.lot_status = lot_status;
	}

	public Date getLot_expire() {
		return lot_expire;
	}

	public void setLot_expire(Date lot_expire) {
		this.lot_expire = lot_expire;
	}

	public String getVendor_id() {
		return vendor_id;
	}

	public void setVendor_id(String vendor_id) {
		this.vendor_id = vendor_id;
	}

	public String getVendor_mat_code() {
		return vendor_mat_code;
	}

	public void setVendor_mat_code(String vendor_mat_code) {
		this.vendor_mat_code = vendor_mat_code;
	}

	public String getVendor_lot_no() {
		return vendor_lot_no;
	}

	public void setVendor_lot_no(String vendor_lot_no) {
		this.vendor_lot_no = vendor_lot_no;
	}

	public String getIcp_data() {
		return icp_data;
	}

	public void setIcp_data(String icp_data) {
		this.icp_data = icp_data;
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

	public InventoryLotControl getUILot_control() {
		return lot_control;
	}

	public void setUILot_control(InventoryLotControl lot_control) {
		this.lot_control = lot_control;
	}

	public InventoryMaster getUIMat() {
		return UIMat;
	}

	public void setUIMat(InventoryMaster uIMat) {
		UIMat = uIMat;
	}

	public Vendor getUIVendor() {
		return UIVendor;
	}

	public void setUIVendor(Vendor uIVendor) {
		UIVendor = uIVendor;
	}

	public String getUIVendors() {
		return UIVendors;
	}

	public void setUIVendors(String uIVendors) {
		UIVendors = uIVendors;
	}

	public String getUICatName() {
		return UICatName;
	}

	public void setUICatName(String uICatName) {
		UICatName = uICatName;
	}

	public String getUISubCatName() {
		return UISubCatName;
	}

	public void setUISubCatName(String uISubCatName) {
		UISubCatName = uISubCatName;
	}

	public String getUILotB() {
		return UILotB;
	}

	public void setUILotB(String uILotB) {
		UILotB = uILotB;
	}
	
	public static void main(String[] args){
		String a =  Double.toString(Double.parseDouble("55.6"));
		System.out.print(a);
	}
	
	public Date getMfg() {
		return mfg;
	}

	public void setMfg(Date mfg) {
		this.mfg = mfg;
	}
	public String getLot_location() {
		return lot_location;
	}

	public void setLot_location(String lot_location) {
		this.lot_location = lot_location;
	}

	
}