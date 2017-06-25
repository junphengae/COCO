package com.bitmap.bean.parts;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;

public class PartMaster {
	public static String tableName = "pa_part_master";
	private static String[] keys = {"pn"};
	private static String[] fieldNames = {"group_id","des_unit","cat_id","sub_cat_id","fit_to","description","sn_flag","moq","mor","weight","location","price","price_unit","cost","cost_unit","update_date","update_by"};

	
	String group_id = "";
	String des_unit = "";
	String cat_id = "";
	String sub_cat_id = "";
	String pn = "";
	String fit_to = "";
	String description = "";
	String qty = "0";
	String sn_flag = FLAG_SN;
	String moq = "";
	String mor = "0";
	String weight = "";
	String location = "";
	String ss_no = "";
	String ss_flag = "";
	String price = "0";
	String price_unit = "";
	String cost = "0";
	String cost_unit = "";
	String status = "";
	String create_by = "";
	
	String reference ="";
	String barcode ="";
	
	Timestamp create_date = null;
	String update_by = "";
	Timestamp update_date = null;
	String UIpr_qty = "";
	
	boolean present = false;
	
	public static String FLAG_SN = "1";
	public static String FLAG_NON_SN = "0";
	
	public static String PN_TYPE_CUSTOM = "c";
	public static String PN_TYPE_SNC = "SNC";
	public static String PN_TYPE_USE = "USE";
	
	String UICate = "";
	
	private List<PartVendor> partVendor = new ArrayList<PartVendor>();
	public List<PartVendor> getUIPartVendor() {
		return partVendor;
	}
	public void setUIPartVendor(List<PartVendor> partVendor) {
		this.partVendor = partVendor;
	}

	public static List<String[]> unitList(){
		List<String[]> list = new ArrayList<String[]>();
		list.add(new String[]{"baht","฿"});
		list.add(new String[]{"dollar","$"});
		list.add(new String[]{"pound","&pound;"});
		list.add(new String[]{"euro","&euro;"});
		list.add(new String[]{"yen","&yen;"});		
		return list;
	}
	
	public static String unit(String unit){
		String u = "";
		if (unit.equalsIgnoreCase("baht")) {
			u = "฿";
		} else if (unit.equalsIgnoreCase("dollar")) {
			u = "$";
		} else if (unit.equalsIgnoreCase("pound")) {
			u = "&pound;";
		} else if (unit.equalsIgnoreCase("euro")) {
			u = "&euro;";
		} else if (unit.equalsIgnoreCase("yen")) {
			u = "&yen;";
		}
		return u;
	}
	
	private static boolean check(PartMaster entity, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		return DBUtility.getEntityFromDB(conn, tableName, entity, keys);
	}
	
	public  static boolean check(PartMaster entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return check;
	}
	
	public  static PartMaster checkqty(PartMaster entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();	
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		////System.out.println(entity.getQty());
		return entity;
	}
	
	public  static boolean check(String pn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		PartMaster entity = new PartMaster();
		entity.setPn(pn);
		return check(entity);
	}
	
	public static List<PartMaster> checkMOR(PageControl ctrl, String where) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE qty < mor AND status!='I'";
		if (where.length() > 0) {
			sql += " AND " + where;
		}
		sql += " ORDER BY pn";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PartMaster> list = new ArrayList<PartMaster>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					PartMaster entity = new PartMaster();
					DBUtility.bindResultSet(entity, rs);
					entity.setUIPartVendor(PartVendor.selectList(entity.getPn()));
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
	
	public static List<PartMaster> selectMOR() throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE (mor*1) >= (qty*1) AND status!='I'";
		
		sql += " ORDER BY pn";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PartMaster> list = new ArrayList<PartMaster>();
		
		while (rs.next()) {
			PartMaster entity = new PartMaster();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIPartVendor(PartVendor.selectList(entity.getPn()));
			list.add(entity);
				
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<PartMaster> selectMOR(List<String[]> params) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE (mor*1) >= (qty*1)  ";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {

				if (str[0].equalsIgnoreCase("create_date")){
					
					/*sql +=" AND DATE_FORMAT(create_date, '%Y-%m-%d')='"+str[1]+"' " ;*/
					
				} 
				else if (str[0].equalsIgnoreCase("year_month")){
					
				/*	sql +=" AND DATE_FORMAT(create_date, '%Y-%m')='"+str[1]+"' " ;
					//System.out.println("month_year::");*/
				} 
				else if (str[0].equalsIgnoreCase("date_send2")){
					
					/*sql +=" AND DATE_FORMAT(create_date, '%Y-%m-%d') BETWEEN '"+str[1]+"' AND '"+str[2]+"' ";
					//System.out.println("date_date");*/
				}
				
				else {
					
					sql += " AND " + str[0] + "='" + str[1] + "' ";
				}
			}
		}
		
		sql += " ORDER BY pn asc";
		
		//System.out.println("mor::"+sql);
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PartMaster> list = new ArrayList<PartMaster>();
		
		while (rs.next()) {
			PartMaster entity = new PartMaster();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIPartVendor(PartVendor.selectList(entity.getPn()));
			list.add(entity);
				
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static boolean checkSS(String ss, String pn) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		PartMaster entity = new PartMaster();
		entity.setSs_no(ss);
		boolean hasSS = false;
		hasSS = DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"ss_no"});
		if (hasSS) {
			if (entity.getPn().equals(pn)) {
				hasSS = false;
			}
		}
		conn.close();
		return hasSS;
	}
	
	public static void updateSS(PartMaster entity) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setUpdate_by(entity.getCreate_by());
		entity.setSs_flag("?");
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"ss_no","ss_flag","update_by","update_date"}, keys);
		conn.close();
	}
	
	public static void updateSSFlag(PartMaster entity) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"ss_flag","update_by","update_date"}, keys);
		conn.close();
	}
	
	public static void updateStatus(PartMaster entity) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"status","update_by","update_date"}, keys);
		conn.close();
	}
	
	public static void updateQty(PartMaster entity) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"qty","update_by","update_date"}, keys);
		conn.close();
	}
	
	public static void updateQtyNonSN(PartMaster entity) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		
		PartMaster exists = select(entity.getPn(), conn);
		
		String qty = (Integer.parseInt(exists.getQty()) + Integer.parseInt(entity.getQty())) + "";
		
		entity.setQty(qty);
		
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"qty","update_by","update_date"}, keys);
		conn.close();
	}
	
	public static void withdrawQtyNonSN(PartMaster entity, Connection conn) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		PartMaster part = PartMaster.select(entity.getPn());
		String part_Qty= part.getQty();
		
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		String qty = (Integer.parseInt(part_Qty) - 1) + "";
		entity.setQty(qty);
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"qty","update_by","update_date"}, keys);
	}
	
	public static void withdrawQtyNonSN_back(PartMaster entity, Connection conn) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		
		
		PartMaster part = PartMaster.select(entity.getPn());
		String part_Qty= part.getQty();
		
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		String qty = (Integer.parseInt(part_Qty) + 1) + "";
		
		entity.setQty(qty);
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"qty","update_by","update_date"}, keys);
		
	}
	
	public static boolean insert(PartMaster entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		boolean has = false;
		Connection conn = DBPool.getConnection();
		if (check(entity, conn)) {
			has = true;
		} else {
			entity.setCreate_date(DBUtility.getDBCurrentDateTime());
			entity.setStatus("N");
			DBUtility.insertToDB(conn, tableName, entity);
		}
		conn.close();
		return has;
	}
	
	public static String genPN(String pn_type) throws SQLException{
		String sql = "SELECT pn FROM " + tableName + " WHERE pn LIKE '" + pn_type + "%' ORDER BY pn DESC";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		String p = pn_type + "0001";
		if (rs.next()) {
			String pn = DBUtility.getString("pn", rs);
			p = pn_type + ((DBUtility.getInteger(pn.substring(pn_type.length(), pn.length())) + 10001) + "").substring(1);
		}
		
		rs.close();
		st.close();
		conn.close();
		return p;
	}
	
	public static void update(PartMaster entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setPn(entity.getPn().trim());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();
	}
	public static void update_location(PartMaster entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setPn(entity.getPn().trim());
		DBUtility.updateToDB(conn, tableName, entity,new String[]{"location","update_date","update_by"}, keys);
		conn.close();
	}
	/**
	 * Serial
	 * @param pn
	 * @param create_by
	 * @param conn
	 * @return
	 * @throws IllegalArgumentException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static String updateInventory(String pn, String create_by, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		PartMaster entity = new PartMaster();
		entity.setPn(pn);
		/**
		 * selectQty(pn,conn) = SELECT QTY เดิม
		 */
		String qty = (Integer.parseInt(selectQty(pn,conn)) + 1) + "";
		entity.setQty(qty);
		entity.setUpdate_by(create_by);
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"qty","update_date","update_by"}, keys);
		return selectQty(pn,conn);
	}
	/**
	 * non Serial
	 * @param pn = part Number
	 * @param no = QTY from add stock
	 * @param create_by = User 
	 * @return
	 * @throws IllegalArgumentException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static String updateInventory(String pn, String no, String create_by) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		PartMaster entity = new PartMaster();
		entity.setPn(pn);
		/**
		 * selectQty(pn,conn) = SELECT QTY เดิม
		 * no = QTY ที่  add stock
		 */
		String qty = (Integer.parseInt(selectQty(pn,conn)) + Integer.parseInt(no)) + "";//*******//
		entity.setQty(qty);
		entity.setUpdate_by(create_by);
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"qty","update_date","update_by"}, keys);
		
		qty = selectQty(pn,conn);//SELECT QTY ทั้งหมด ใน  STOCK 
		conn.close();
		return qty;
	}
	
	public static PartMaster select(PartMaster entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	public static PartMaster selectLocation(String pn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		PartMaster entity = new PartMaster();
		
		Connection conn =null;
		try {
			conn = DBPool.getConnection();
			String sql = "SELECT pn,location FROM " + tableName + " WHERE pn like '%" + pn + "%' ";
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			
			while (rs.next()) {
				
				DBUtility.bindResultSet(entity, rs);
			}
			
			st.close();
			rs.close();
			conn.close();
			
			
		} catch (Exception e) {
			if (conn != null) {
				conn.close();
			}
		}
		return entity;
		
	}
	
	public static PartMaster select(String pn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		PartMaster entity = new PartMaster();
		entity.setPn(pn);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	
	public static PartMaster select(String pn, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		PartMaster entity = new PartMaster();
		entity.setPn(pn);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		return entity;
	}
	
	public static String selectQty(String pn, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		PartMaster entity = new PartMaster();
		entity.setPn(pn);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		return entity.getQty();
	}
	
	public static List<PartMaster> selectWhere(String where) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE " + where + " ORDER BY pn";
		ResultSet rs = conn.createStatement().executeQuery(sql);
		
		List<PartMaster> list = new ArrayList<PartMaster>();
		while (rs.next()) {
			PartMaster entity = new PartMaster();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		conn.close();
		return list;
	}
	
	public static List<PartMaster> selectList() throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " ORDER BY pn";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PartMaster> list = new ArrayList<PartMaster>();
		while (rs.next()) {
			PartMaster entity = new PartMaster();
			DBUtility.bindResultSet(entity, rs);
			entity.setUICate(PartGroups.select(entity.getGroup_id(),conn).getGroup_name_en());
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<PartMaster> selectWithCTRL(PageControl ctrl, String where) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName;
		if (where.length() > 0) {
			sql += " WHERE " + where;
		}
		sql += " ORDER BY pn";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PartMaster> list = new ArrayList<PartMaster>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					PartMaster entity = new PartMaster();
					DBUtility.bindResultSet(entity, rs);
					entity.setUIPartVendor(PartVendor.selectList(entity.getPn()));
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
	
	public static List<PartMaster> selectCtrlParam(PageControl ctrl, List<String[]> param) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE 0=0";
		
		for (Iterator<String[]> iterator = param.iterator(); iterator.hasNext();) {
			String[] pm = (String[]) iterator.next();
			if (!pm[0].equalsIgnoreCase("where") && !pm[0].equalsIgnoreCase("keyword")) {
				if (pm[1].length() > 0) {
					if(pm[0].equalsIgnoreCase("description") || pm[0].equalsIgnoreCase("location") || pm[0].equalsIgnoreCase("fit_to")) {
						sql += " AND " + pm[0] + " like '%" + pm[1] + "%'";
					} else {
						sql += " AND " + pm[0] + " ='" + ((pm[1].split("--").length>1)?pm[1].split("--")[0]:pm[1]) + "'";
					}
				}
			}
		}
		
		sql += " ORDER BY pn";
		
		////System.out.println("sql : " + sql);
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PartMaster> list = new ArrayList<PartMaster>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					PartMaster entity = new PartMaster();
					DBUtility.bindResultSet(entity, rs);
					entity.setUIPartVendor(PartVendor.selectList(entity.getPn()));
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
	
	public static List<PartMaster> select4Report(PageControl ctrl,List<String[]> param)throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " ";
		
		
		for (Iterator iterator = param.iterator(); iterator.hasNext();) {
			String[] pm = (String[]) iterator.next();
			sql += pm[2];
		}
		sql += " ORDER BY CAST(update_date AS DATETIME) ASC";
		////System.out.println(sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PartMaster> list = new ArrayList<PartMaster>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					PartMaster entity = new PartMaster();
					DBUtility.bindResultSet(entity, rs);
					entity.setUIPartVendor(PartVendor.selectList(entity.getPn()));
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
	
	public static List<PartMaster> selectWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1  ";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (str[0].equalsIgnoreCase("keyword")){
					
					sql += " AND (pn like'%" + str[1] + "%'  OR  description like'%" + str[1] + "%'    ) ";
				}
				if (str[0].equalsIgnoreCase("group_id")){
					
					sql += "  AND group_id='"+str[1]+"' ";
				}
				if (str[0].equalsIgnoreCase("cat_id")){ 
					
					sql += "  AND cat_id='"+str[1]+"' ";
				}
				if (str[0].equalsIgnoreCase("sub_cat_id")){
					
					sql += "  AND sub_cat_id='"+str[1]+"' ";
				}
				else {
					//sql += " AND " + str[0] + "='" + str[1] + " '";
				}
			}
		}
		
		sql += " ORDER BY pn ASC";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PartMaster> list = new ArrayList<PartMaster>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					PartMaster entity = new PartMaster();
					DBUtility.bindResultSet(entity, rs);
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
	
	public static void main(String[] str) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		PartMaster p = new PartMaster();
		p.setPn("9999");
		PartMaster.selectSSList(p);
	}
	
	public static List<PartMaster> selectSSList(PartMaster entity) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		String currentPN = entity.getPn();
		PartMaster pnRoot = PartMaster.findPnRoot(entity, conn);
		List<PartMaster> list = new ArrayList<PartMaster>();
		
		selectSS(list, conn, currentPN, pnRoot.getPn());
		
		conn.close();
		return list;
	}
	
	private static PartMaster findPnRoot(PartMaster entity, Connection conn) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException {
		String sql = "SELECT pn,ss_no FROM " + tableName + " WHERE ss_no = ?";
		PreparedStatement ps = conn.prepareStatement(sql);
		ps.setString(1, entity.getPn());
		ResultSet rs = ps.executeQuery();
		
		PartMaster partRoot = new PartMaster();
		if (rs.next()) {
			DBUtility.bindResultSet(partRoot, rs);
			rs.close();
			ps.close();
			return findPnRoot(partRoot,conn);
		}
		return entity;
	}
	public static String SelectUnitDesc(String pn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		String cnt = "";
		Connection conn =null;
		try {
			conn = DBPool.getConnection();
			String sql = "SELECT des_unit as cnt FROM " + tableName + " WHERE pn='" + pn + "' ";
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			
			while (rs.next()) {
				cnt = DBUtility.getString("cnt", rs);
			}
			
			st.close();
			rs.close();
			conn.close();
			
			
		} catch (Exception e) {
			if (conn != null) {
				conn.close();
			}
		}
		return cnt;
	}
	private static void selectSS(List<PartMaster> list, Connection conn, String currentPN, String pn) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException {
		String sql = "SELECT * FROM " + tableName + " WHERE pn = ?";
		PreparedStatement ps = conn.prepareStatement(sql);
		ps.setString(1, pn);
		ResultSet rs = ps.executeQuery();
		
		PartMaster part = new PartMaster();
		if (rs.next()) {
			DBUtility.bindResultSet(part, rs);
			if (currentPN.equals(part.getPn())) {
				part.setUIPresent(true);
			}
			list.add(part);
			rs.close();
			ps.close();
			if (part.getSs_no().length() > 0) {
				selectSS(list, conn, currentPN, part.getSs_no());
			}
		}
	}

	
	public static List<PartMaster> selectWithNOCTRL(List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException
	{
		
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1 ";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (str[0].equalsIgnoreCase("keyword")){
					sql += " AND (pn like'%" + str[1] + "%' " +
						   " OR description like'%" + str[1] + "%' " +
						   " OR fit_to like'%" + str[1] + "%' " +
						   " OR location like'%" + str[1] + "%')";
				} 
				if (str[0].equalsIgnoreCase("create_date")){
					
					sql +=" AND DATE_FORMAT(create_date, '%Y-%m-%d')='"+str[1]+"' " ;
					
				} 
				else if (str[0].equalsIgnoreCase("year_month")){
					
					sql +=" AND DATE_FORMAT(create_date, '%Y-%m')='"+str[1]+"' " ;
					
				} 
				else if (str[0].equalsIgnoreCase("date_send2")){
					
					sql +=" AND DATE_FORMAT(create_date, '%Y-%m-%d') BETWEEN '"+str[1]+"' AND '"+str[2]+"' ";
					
				}
				else {
					sql += " AND " + str[0] + "='" + str[1] + "'";
				}
			}
		}
		
		sql += " ORDER BY create_date desc ";
		
		//System.out.println(sql);
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PartMaster> list = new ArrayList<PartMaster>();
	
		
		while (rs.next()) {
			
			PartMaster entity = new PartMaster();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	public static List<PartMaster> selectWith_reportPart(List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException
	{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1  ";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (str[0].equalsIgnoreCase("keyword")){
					/*sql += " AND (pn like'%" + str[1] + "%' " +
						   " OR description like'%" + str[1] + "%' " +
						   " OR fit_to like'%" + str[1] + "%' " +
						   " OR location like'%" + str[1] + "%')";*/
				} 
				if (str[0].equalsIgnoreCase("create_date")){
					
					/*sql +=" AND DATE_FORMAT(create_date, '%Y-%m-%d')='"+str[1]+"' " ;*/
					
				} 
				else if (str[0].equalsIgnoreCase("year_month")){
					
					/*sql +=" AND DATE_FORMAT(create_date, '%Y-%m')='"+str[1]+"' " ;*/
					
				} 
				else if (str[0].equalsIgnoreCase("date_send2")){
					
					/*sql +=" AND DATE_FORMAT(create_date, '%Y-%m-%d') BETWEEN '"+str[1]+"' AND '"+str[2]+"' ";*/
					
				}
				else {
					sql += " AND " + str[0] + "='" + str[1] + "' ";
				}
			}
		}
		
		sql += " ORDER BY create_date asc ";
		
		//System.out.println(sql);
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PartMaster> list = new ArrayList<PartMaster>();
	
		
		while (rs.next()) {
			
			PartMaster entity = new PartMaster();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	public static List<PartMaster> selectListPn() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException
	{
		
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1  ";
		sql += " ORDER BY pn desc ";
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<PartMaster> list = new ArrayList<PartMaster>();
	
		
		while (rs.next()) {
			
			PartMaster entity = new PartMaster();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	public static String SelectDesc(String pn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
		String cnt = "";
		Connection conn =null;
		try {
			conn = DBPool.getConnection();
			String sql = "SELECT description as cnt FROM " + tableName + " WHERE pn='" + pn + "' ";
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			
			while (rs.next()) {
				cnt = DBUtility.getString("cnt", rs);
			}
			
			st.close();
			rs.close();
			conn.close();
			
			
		} catch (Exception e) {
			if (conn != null) {
				conn.close();
			}
		}
		return cnt;
	}
	public String getDes_unit() {
		return des_unit;
	}
	public void setDes_unit(String des_unit) {
		this.des_unit = des_unit;
	}
	public String getGroup_id() {
		return group_id;
	}
	public void setGroup_id(String group_id) {
		this.group_id = group_id;
	}
	public String getPn() {
		return pn;
	}
	public void setPn(String pn) {
		this.pn = pn;
	}
	public String getFit_to() {
		return fit_to;
	}
	public void setFit_to(String fit_to) {
		this.fit_to = fit_to;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getQty() {
		return qty;
	}
	public void setQty(String qty) {
		this.qty = qty;
	}
	public String getSn_flag() {
		return sn_flag;
	}
	public void setSn_flag(String sn_flag) {
		this.sn_flag = sn_flag;
	}
	public String getMoq() {
		return moq;
	}
	public void setMoq(String moq) {
		this.moq = moq;
	}
	public String getMor() {
		return mor;
	}
	public void setMor(String mor) {
		this.mor = mor;
	}
	public String getWeight() {
		return weight;
	}
	public void setWeight(String weight) {
		this.weight = weight;
	}
	public String getSs_no() {
		return ss_no;
	}
	public void setSs_no(String ss_no) {
		this.ss_no = ss_no;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public String getSs_flag() {
		return ss_flag;
	}
	public void setSs_flag(String ss_flag) {
		this.ss_flag = ss_flag;
	}
	public String getPrice() {
		return price;
	}
	public void setPrice(String price) {
		this.price = price;
	}
	public String getPrice_unit() {
		return price_unit;
	}
	public void setPrice_unit(String price_unit) {
		this.price_unit = price_unit;
	}
	public String getCost() {
		return cost;
	}
	public void setCost(String cost) {
		this.cost = cost;
	}
	public String getCost_unit() {
		return cost_unit;
	}
	public void setCost_unit(String cost_unit) {
		this.cost_unit = cost_unit;
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
	public boolean getUIPresent() {
		return present;
	}
	public void setUIPresent(boolean present) {
		this.present = present;
	}
	public String getUICate() {
		return UICate;
	}
	public void setUICate(String uICate) {
		UICate = uICate;
	}
	public String getReference() {
		return reference;
	}
	public void setReference(String reference) {
		this.reference = reference;
	}
	public String getBarcode() {
		return barcode;
	}
	public void setBarcode(String barcode) {
		this.barcode = barcode;
	}
	public String getCat_id() {
		return cat_id;
	}
	public void setCat_id(String cat_id) {
		this.cat_id = cat_id;
	}
	public String getSub_cat_id() {
		return sub_cat_id;
	}
	public void setSub_cat_id(String sub_cat_id) {
		this.sub_cat_id = sub_cat_id;
	}
	
	
	
	public static String updateInventoryEditQTY(String pn, String no,String create_by) throws Exception {
		// TODO  New 17-03-2557
		Connection conn = DBPool.getConnection();
		PartMaster entity = new PartMaster();
		entity.setPn(pn);
		/**
		 * selectQty(pn,conn) = SELECT QTY เดิม
		 * no = QTY ที่  add stock
		 */
		String qty = (Integer.parseInt(selectQty(pn,conn)) - Integer.parseInt(no)) + "";//*******//
		entity.setQty(qty);
		entity.setUpdate_by(create_by);
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		
		DBUtility.updateToDB(conn, tableName, entity, new String[]{"qty","update_date","update_by"}, keys);
		
		qty = selectQty(pn,conn);//SELECT QTY ทั้งหมด ใน  STOCK 
		conn.close();
		
		return qty;
		
		
	}
	
}