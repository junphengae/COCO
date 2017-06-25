package com.bitmap.bean.inventory;

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
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import com.bitmap.bean.hr.Personal;
import com.bitmap.bean.rd.TreeInv;
import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.utils.Money;

public class InventoryLotControl {
	public static String tableName = "inv_lot_control";
	
	String lot_no = "";
	String lot_id = "";
	String lot_balance = "";
	String request_no = "";
	String request_type = "";
	String request_qty = "";
	String control_status = "";
	String request_by = "";
	String request_person = "";
	Timestamp request_date = null;
	Timestamp create_date = DBUtility.getDBCurrentDateTime();
	String update_by = "";
	Timestamp update_date = null;
	private InventoryLot UILot = new InventoryLot();
	private Personal UIPersonal = new Personal();
	
	String UIqty = "";
	TreeInv UItree = new TreeInv();
	
	
	public TreeInv getUItree() {
		return UItree;
	}
	public void setUItree(TreeInv uItree) {
		UItree = uItree;
	}
	public Personal getUIPersonal() {
		return UIPersonal;
	}
	public void setUIPersonal(Personal uIPersonal) {
		UIPersonal = uIPersonal;
	}

	public static String sumPD(String mat_code,String pro_id, Connection conn) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT SUM(inv_lot_control.request_qty) as sumOut FROM inv_lot_control,inv_lot WHERE inv_lot_control.lot_no = inv_lot.lot_no AND inv_lot_control.request_no = '" + pro_id +"' AND inv_lot.mat_code = '" + mat_code + "' GROUP BY inv_lot.mat_code";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		//System.out.println(sql);
		String sumOut = new String();
		if (rs.next()) {
			sumOut = DBUtility.getString("sumOut", rs);
		}else{
			sumOut = "0";
		}
		rs.close();
		st.close();
		
		return sumOut;
	}

	public static void initLot(InventoryLot lot, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		InventoryLotControl entity = new InventoryLotControl();
		entity.setLot_no(lot.getLot_no());
		entity.setLot_balance(lot.getLot_qty());
		entity.setLot_id("1");
		entity.setControl_status("A");
		DBUtility.insertToDB(conn, tableName, new String[]{"lot_no","lot_id","lot_balance","control_status","create_date"}, entity);
	}
	
	public static InventoryLotControl select(String lot_no, Connection conn) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		InventoryLotControl entity = new InventoryLotControl();
		String sql = "SELECT * FROM " + tableName + " WHERE lot_no='" + lot_no + "' ORDER BY (lot_id*1) ASC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		if (rs.next()) {
			DBUtility.bindResultSet(entity, rs);
		}
		rs.close();
		st.close();
		
		return entity;
	}
	
	public static List<InventoryLotControl> select(String lot_no) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE lot_no='" + lot_no + "' AND control_status = 'I' ORDER BY (lot_id*1) ASC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<InventoryLotControl> list = new ArrayList<InventoryLotControl>();
		while (rs.next()) {
			InventoryLotControl entity = new InventoryLotControl();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static InventoryLotControl selectMaxLotid(String lot_no, Connection conn) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		InventoryLotControl entity = new InventoryLotControl();
		String sql = "SELECT * FROM " + tableName + " WHERE lot_no='" + lot_no + "' order by (lot_id*1) DESC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		if (rs.next()) {
			DBUtility.bindResultSet(entity, rs);
		}
		rs.close();
		st.close();
		
		return entity;
	}
	
	public static InventoryLotControl selectActive(String lot_no, Connection conn) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		InventoryLotControl entity = new InventoryLotControl();
		String sql = "SELECT * FROM " + tableName + " WHERE lot_no='" + lot_no + "' AND control_status ='A' ";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		if (rs.next()) {
			DBUtility.bindResultSet(entity, rs);
		}
		rs.close();
		st.close();
		
		return entity;
	}
	
	
	public static void withdraw(InventoryLotControl entity, InventoryMaster master) throws SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		Double lotBalance = Double.parseDouble(entity.getLot_balance());
		Double reqQty = Double.parseDouble(entity.getRequest_qty());
		//System.out.println(lotBalance + ":" + reqQty);
		entity.setRequest_by(entity.getRequest_person());
		if(lotBalance.equals(reqQty)){
			//update status i		
			entity.setRequest_qty(Money.moneyNoCommas(reqQty));			
			entity.setControl_status("I");
			entity.setRequest_date(DBUtility.getDBCurrentDateTime());
			DBUtility.updateToDB(conn, tableName, entity, new String[]{"request_type","request_no","request_qty","control_status","request_by","request_date","update_by"}, new String[]{"lot_id","lot_no"});
			InventoryLot.updateIStatus(conn, entity);
		}else{
			//update status c			
			entity.setControl_status("C");
			entity.setRequest_date(DBUtility.getDBCurrentDateTime());
			DBUtility.updateToDB(conn, tableName, entity, new String[]{"request_type","request_no","request_qty","control_status","request_by","request_date","update_by"}, new String[]{"lot_id","lot_no"});
			entity.setLot_balance(Money.moneyNoCommas(lotBalance-reqQty));
			//System.out.println("lot b :" + entity.getLot_balance());
			insertAfterWithdraw(conn, entity);
		}
		
		master.setBalance(InventoryLot.selectActiveSum(master.getMat_code(), conn));
		InventoryMaster.updateBalance(master, conn);
		
		conn.close();
	}
	
	public static void insertAfterWithdraw(Connection conn,InventoryLotControl entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		int id = Integer.parseInt(entity.getLot_id())+1;										
		entity.setLot_id(""+id);
		entity.setControl_status("A");
		
		//System.out.println("insert : lot_no = " + entity.getLot_no() + " : lot_id = " + entity.getLot_id() + " : lot_balance = " + entity.getLot_balance() + " : control = " + entity.getControl_status());
		DBUtility.insertToDB(conn, tableName, new String[]{"lot_no","lot_id","lot_balance","control_status","create_date","request_by"}, entity);
	}
	
	public static void updateStatus2A(Connection conn,InventoryLotControl entity) throws IllegalAccessException, InvocationTargetException, SQLException{									
		DBUtility.updateToDB(conn, tableName, entity,new String[] {"lot_balance","update_by","update_date"},new String[] {"lot_no","lot_id"});
	}
	
	public static void updateStatus2I(Connection conn,InventoryLotControl entity) throws IllegalAccessException, InvocationTargetException, SQLException{									
		entity.setControl_status("C");
		DBUtility.updateToDB(conn, tableName, entity,new String[] {"lot_balance","control_status","update_by","update_date"},new String[] {"lot_no","lot_id"});
			
		InventoryLot lot = new InventoryLot();
		lot.setLot_no(entity.getLot_no());	
		lot.setLot_status("A");
		lot.setUpdate_by(entity.getUpdate_by());
		lot.setUpdate_date(DBUtility.getDBCurrentDateTime());
		InventoryLot.updateAStatus(conn, lot);
	}
	
	/**
	 * whan : report_review
	 * <br> 
	 * เน€เธ�เธดเน�เธกเธ�เน�เธ�เธซเธฒเธ”เน�เธงเธข matcode 
	 * @param year
	 * @param month
	 * @param mat_code
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static List<InventoryLotControl> report(String year, String month,String mat_code, String lot_no) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		System.out.println(year+"-"+month);
		Calendar sd = Calendar.getInstance();
		sd.clear();
		sd.set(Calendar.YEAR, Integer.parseInt(year));
		sd.set(Calendar.MONTH, Integer.parseInt(month) - 1);
		sd.set(Calendar.DATE, 1);
		SimpleDateFormat DATE_DATABASE_FORMAT = new SimpleDateFormat("yyyy-MM-dd");
		String s =  DATE_DATABASE_FORMAT.format(sd.getTime());
		sd.add(Calendar.MONTH, +1);
		sd.add(Calendar.DATE, -1);
		String e = DATE_DATABASE_FORMAT.format(sd.getTime());
		
		System.out.println(s);
		System.out.println(e);
		
		String sql = "SELECT inv.mat_code,inv.group_id as group_id,inv.std_unit,inv.des_unit,inv.description,lotc.*," +
		"(SELECT c.cat_name_short FROM inv_categories c WHERE c.cat_id = inv.cat_id AND c.group_id = inv.group_id) AS cat_name," +
		"(SELECT s.sub_cat_name_short FROM inv_sub_categories s WHERE s.sub_cat_id = inv.sub_cat_id AND s.cat_id = inv.cat_id AND s.group_id = inv.group_id) AS sub_cat_name "+
		"FROM inv_lot_control as lotc,inv_lot as lot,inv_master inv " +
		"WHERE lotc.request_date between '" + s + " 00:00:00.00' AND '" 
		+ e + " 23:59:59.99' AND lotc.lot_no = lot.lot_no AND inv.mat_code = lot.mat_code";
		

		if(!(mat_code.equalsIgnoreCase(""))){
			sql += " AND lot.mat_code = '" + mat_code + "'";
		}
		
		if(!lot_no.equalsIgnoreCase("")){
			sql += " AND lot.lot_no = '"+ lot_no + "' ";
		}
		
		sql += " ORDER BY lotc.request_date desc, (lotc.lot_no*1)";
		
		System.out.println(sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<InventoryLotControl> list = new ArrayList<InventoryLotControl>();
		while (rs.next()) {
			InventoryLotControl entity = new InventoryLotControl();
			DBUtility.bindResultSet(entity, rs);

			TreeInv inv = new TreeInv();
			DBUtility.bindResultSet(inv, rs);
			entity.setUItree(inv);
			entity.setUIqty(Personal.selectNameANDSurName(entity.getRequest_by(),conn));
								
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		
		return list;
	}
	
	
	public static List<InventoryLotControl> report(Date d1 ,Date d2,String mat_code, String lot_no) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		String s =  DBUtility.DATE_DATABASE_FORMAT.format(d1.getTime());
		String e = DBUtility.DATE_DATABASE_FORMAT.format(d2.getTime());
		
		
		String sql = "SELECT inv.mat_code,inv.group_id as group_id,inv.std_unit,inv.des_unit,inv.description,lot.mfg as mfg,lotc.*," +
		"(SELECT c.cat_name_short FROM inv_categories c WHERE c.cat_id = inv.cat_id AND c.group_id = inv.group_id) AS cat_name," +
		"(SELECT s.sub_cat_name_short FROM inv_sub_categories s WHERE s.sub_cat_id = inv.sub_cat_id AND s.cat_id = inv.cat_id AND s.group_id = inv.group_id) AS sub_cat_name "+
		"FROM inv_lot_control as lotc,inv_lot as lot,inv_master inv " +
		"WHERE lotc.request_date BETWEEN '" + s + " 00:00:00.00' AND '" + e + " 23:59:59.99' AND lotc.lot_no = lot.lot_no AND inv.mat_code = lot.mat_code";

		if(!(mat_code.equalsIgnoreCase(""))){
			sql += " AND lot.mat_code = '" + mat_code + "'";
		}
		
		if(!lot_no.equalsIgnoreCase("")){
			sql += " AND lot.lot_no = '"+ lot_no + "' ";
		}
		
		sql += " ORDER BY lotc.request_date desc, ( lotc.lot_no*1)";
		//System.out.println("sql : " + sql);
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<InventoryLotControl> list = new ArrayList<InventoryLotControl>();
		while (rs.next()) {
			InventoryLotControl entity = new InventoryLotControl();
			DBUtility.bindResultSet(entity, rs);

			TreeInv inv = new TreeInv();
			DBUtility.bindResultSet(inv, rs);
			entity.setUItree(inv);
			entity.setUIqty(Personal.selectNameANDSurName(entity.getRequest_by(),conn));
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		
		return list;
	}
	
	public static int sumOutlet(String request_no) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		String sql = "SELECT sum(request_qty) as qty FROM " + tableName + " WHERE request_no = '" + request_no  + "'";
		//System.out.println(sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		int val = 0;
		while (rs.next()){
			val = DBUtility.getInteger("qty", rs);
		}
		conn.close();
		return val;
	}
	
	public static List<InventoryLotControl> outletReport(List<String[]> paramList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "select *,sum(request_qty) as qty from inv_lot_control where request_no != '' AND request_type = 'IV'";	
		Iterator<String[]> ite = paramList.iterator();
		String m = "";
		String y = "";
		
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
		
		sql += "  group by lot_no ORDER BY (request_no*1) ASC";
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<InventoryLotControl> list = new ArrayList<InventoryLotControl>();
		while (rs.next()) {
			InventoryLotControl entity = new InventoryLotControl();
			DBUtility.bindResultSet(entity, rs);
			
			entity.setUIPersonal(Personal.selectOnlyPerson(entity.getRequest_by(), conn));
			entity.setUIqty(DBUtility.getString("qty", rs));
			list.add(entity);
		}
		st.close();
		rs.close();
		conn.close();
		return list;
	}
	
	/**
	 * Gen Report for Approve PR
	 * @param mat_code
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static String reportSUM4PR(String mat_code) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		Calendar today = Calendar.getInstance();
		today.setTime(DBUtility.getCurrentDate());
		//today.set(Calendar.DATE, 1);
		
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		
		String e = df.format(today.getTime());
		
		today.add(Calendar.MONTH, -3);
		String s = df.format(today.getTime());
		
		String sql = "SELECT SUM(inv_lot_control.request_qty) as sum FROM " + tableName + ",inv_lot WHERE inv_lot_control.lot_no = inv_lot.lot_no AND (inv_lot_control.request_date between '" + s + " 00:00:00.00' AND '" + e + " 00:00:00.00') AND inv_lot.mat_code='" + mat_code + "' GROUP BY inv_lot.mat_code";
		//"SELECT SUM(inv_lot_control.request_qty) as sumOut FROM inv_lot_control,inv_lot WHERE inv_lot_control.lot_no = inv_lot.lot_no AND inv_lot_control.request_no = '" + pro_id +"' AND inv_lot.mat_code = '" + mat_code + "' GROUP BY inv_lot.mat_code";
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
	/**
	 * whan : OutletManagement.withdraw_for_sell
	 * <br>
	 * @param request_no
	 * @return
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static int sumTakelot(String request_no) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT sum(request_qty) as qty FROM " + tableName + " WHERE request_no = '" + request_no  + "' AND request_type ='IV'";
		//System.out.println(sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		int val = 0;
		while (rs.next()){
			val = DBUtility.getInteger("qty", rs);
		}
		conn.close();
		return val;
	}
	
	public String getLot_no() {
		return lot_no;
	}
	public void setLot_no(String lot_no) {
		this.lot_no = lot_no;
	}
	public String getLot_id() {
		return lot_id;
	}
	public void setLot_id(String lot_id) {
		this.lot_id = lot_id;
	}
	public String getLot_balance() {
		return lot_balance;
	}
	public void setLot_balance(String lot_balance) {
		this.lot_balance = lot_balance;
	}
	public String getRequest_no() {
		return request_no;
	}
	public void setRequest_no(String request_no) {
		this.request_no = request_no;
	}
	public String getRequest_type() {
		return request_type;
	}
	public void setRequest_type(String request_type) {
		this.request_type = request_type;
	}
	public String getRequest_qty() {
		return request_qty;
	}
	public void setRequest_qty(String request_qty) {
		this.request_qty = request_qty;
	}
	public String getControl_status() {
		return control_status;
	}
	public void setControl_status(String control_status) {
		this.control_status = control_status;
	}
	public String getRequest_by() {
		return request_by;
	}
	public void setRequest_by(String request_by) {
		this.request_by = request_by;
	}
	public Timestamp getRequest_date() {
		return request_date;
	}
	public void setRequest_date(Timestamp request_date) {
		this.request_date = request_date;
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

	public InventoryLot getUILot() {
		return UILot;
	}

	public void setUILot(InventoryLot uILot) {
		UILot = uILot;
	}

	public String getUIqty() {
		return UIqty;
	}

	public void setUIqty(String uIqty) {
		UIqty = uIqty;
	}
	public String getRequest_person() {
		return request_person;
	}
	public void setRequest_person(String request_person) {
		this.request_person = request_person;
	}

	
}