package com.bmp.parts.check.stock;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;

public class CheckStockTS {
	public static final String tableName 	= "check_stock";
	public static final String[] keys    	= {"check_id","seq","pn"};
	public static final String[] fieldNames_save = "qty_new,qty_diff,status,update_date,update_by".split(",");
	public static final String[] fieldNames_close= "qty_diff,status,close_date,close_by".split(",");
	public static final String[] fieldNames_carry= "qty_new,status,carry_flag,update_date,update_by".split(",");
	public static final String[] fieldNames_edit = "qty_new,qty_diff,update_date,update_by".split(",");
	public static String STATUS_NOT_CLOSE = "00";
	public static String STATUS_SAVE_FINISH = "10";
	public static String STATUS_CLOSE_FINISH = "20";
	public static String STATUS_CARRY = "30";
	public static String STATUS_MAKE_STOCK = "40";
	
	public static String status(String status){
		HashMap<String , String> map = new HashMap<String, String>();
		map.put(STATUS_NOT_CLOSE, "ยังไม่ได้ปิด");
		map.put(STATUS_SAVE_FINISH, "บันทึกแล้ว");
		map.put(STATUS_CLOSE_FINISH, "ปิดยอดแล้ว");
		map.put(STATUS_CARRY, "ยกยอด");
		map.put(STATUS_MAKE_STOCK, "ณ วัน เวลา ที่ปิดยอด");
		
		return map.get(status);
	}
	public static boolean Check_PN(Connection conn,CheckStockBean entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException {
		boolean check = false;
		check = DBUtility.getEntityFromDB(conn, tableName , entity, new String[] {"check_id","pn"});
		//System.out.println("check : "+check);
		return check;
	}
	public static void insert(Connection conn, CheckStockBean entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setSeq(Integer.parseInt(DBUtility.genNumberFromDB(conn, tableName, entity, new String[]{"check_id"}, "seq")));
		entity.setStatus("00");
		entity.setCarry_flag(0);
		entity.setCheck_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
	}
	public static void update_status(Connection conn,CheckStockBean entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setCheck_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, new String[] {"status","check_date","check_by"}, new String[] {"check_id","pn"});
	}
	public static void Edit_stock(Connection conn, CheckStockBean entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames_edit, keys);
	}
	public static void Save_Stock(Connection conn ,CheckStockBean entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus("10");
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames_save, keys);
	}
	public static void Carry(Connection conn ,CheckStockBean entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setStatus("30");
		entity.setCarry_flag(1);
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames_carry, keys);
	}
	public static CheckStockBean select(String check_id) throws Exception{
		Connection conn = null;
		CheckStockBean entity = new CheckStockBean();
		try {
			conn = DBPool.getConnection();
			conn.setAutoCommit(false);
			entity.setCheck_id(Integer.parseInt(check_id));
			DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"check_id"});
			conn.commit();
			conn.close();
		} catch (Exception e) {
			if( conn != null){
				conn.rollback();
				conn.close();
			 }
			System.out.println(e.getMessage());
			 throw new Exception(e.getMessage());
		}
		
		return entity;
	}
	public static List<CheckStockBean> selectWithCTRL(PageControl ctrl, List<String[]> params ) throws Exception{
		String sql = "SELECT * FROM " + tableName + " a WHERE 1=1  ";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (str[0].equalsIgnoreCase("check_id")){
				
					sql += " AND check_id='"+str[1]+"' ";
				}
				if (str[0].equalsIgnoreCase("pn")){
					
					sql += " AND pn='"+str[1]+"' ";
				}
			}
		}
		sql += " AND status != '40' ORDER BY pn ASC";
		/*sql += "AND check_id = '"+check_id+"' AND status != '40' ORDER BY pn ASC";*/
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<CheckStockBean> list = new ArrayList<CheckStockBean>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					CheckStockBean entity = new CheckStockBean();
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
	}//ไม่เอา
	
	public static String SelectMaxCheckID() throws Exception{
		Connection conn = null;
		try {
			conn = DBPool.getConnection();
			String sql = "SELECT max(check_id) as cnt FROM "+tableName+" ";
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			String cnt= "";
			while(rs.next()){
				cnt = DBUtility.getString("cnt", rs);
			}
			st.close();
			rs.close();
			conn.close();
			return cnt;
		} catch (Exception e) {
			if( conn != null){
				conn.rollback();
				conn.close();
			 }
			//System.out.println(e.getMessage());
			 throw new Exception(e.getMessage());
		}
	}
	public static String SelectMaxSEQ() throws Exception{
		Connection conn = null;
		try {
			conn = DBPool.getConnection();
			String sql = "SELECT max(seq) as cnt FROM "+tableName+" ";
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			String cnt= "";
			while(rs.next()){
				cnt = DBUtility.getString("cnt", rs);
			}
			st.close();
			rs.close();
			conn.close();
			return cnt;
		} catch (Exception e) {
			if( conn != null){
				conn.rollback();
				conn.close();
			 }
			System.out.println(e.getMessage());
			 throw new Exception(e.getMessage());
		}
	}
	
	@SuppressWarnings("unused")
	public static void select(CheckStockBean entity) throws Exception{
		Connection conn = null;
		try {
			conn = DBPool.getConnection();
			DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		} catch (Exception e) {
			if( conn != null){
				conn.rollback();
				conn.close();
			 }
			System.out.println(e.getMessage());
			 throw new Exception(e.getMessage());
		}
		
		
	}
	public static boolean checkClose_stock() throws Exception{
		Connection conn = null;
		try {
			conn = DBPool.getConnection();
			conn.setAutoCommit(false);
			String max_check_id = CheckStockTS.SelectMaxCheckID();
			boolean cnt= false;
			if(max_check_id.equalsIgnoreCase("") || max_check_id.equalsIgnoreCase("0")){
				cnt = false;
			}else{
				String sql = "SELECT * FROM "+tableName+" a WHERE  a.check_id = "+max_check_id+" AND a.seq = ( SELECT MAX(b.seq) FROM check_stock b WHERE b.check_id = "+max_check_id+" AND b.pn = a.pn) and status !='20' ";
				Statement st = conn.createStatement();
				ResultSet rs = st.executeQuery(sql);
				while(rs.next()){
					cnt = true;
				}
				st.close();
				rs.close();
				conn.commit();
				conn.close();
			}
			return cnt;
		} catch (Exception e) {
			if( conn != null){
				conn.rollback();
				conn.close();
			 }
			System.out.println(e.getMessage());
			 throw new Exception(e.getMessage());
		}
	}
	public static boolean checkCheck_stock() throws Exception{
		Connection conn = null;
		try {
			conn = DBPool.getConnection();
			conn.setAutoCommit(false);
			String max_check_id = CheckStockTS.SelectMaxCheckID();
			boolean cnt= true;
			if(max_check_id.equalsIgnoreCase("") || max_check_id.equalsIgnoreCase("0")){
					cnt = true;
			}else{
				String sql = "SELECT * FROM "+tableName+" a WHERE  a.check_id = "+max_check_id+" AND a.seq = ( SELECT MAX(b.seq) FROM check_stock b WHERE b.check_id = "+max_check_id+" AND b.pn = a.pn) and status ='10' or status='00' or status='30' ";
				//String sql = "SELECT * FROM "+tableName+"  WHERE  check_id = 1 and status ='10' or status='00' or status='30'";
				//System.out.println("SQL NA ="+sql);
				Statement st = conn.createStatement();
				ResultSet rs = st.executeQuery(sql);
				while(rs.next()){
					cnt = false;
				}
				st.close();
				rs.close();
				conn.commit();
				conn.close();
			}
			return cnt;
		} catch (Exception e) {
			if( conn != null){
				conn.rollback();
				conn.close();
			 }
			System.out.println(e.getMessage());
			 throw new Exception(e.getMessage());
		}
	}
	public static boolean CheckCarry() throws Exception{
		Connection conn = null;
		try {
			conn = DBPool.getConnection();
			conn.setAutoCommit(false);
			String max_check_id = CheckStockTS.SelectMaxCheckID();
			boolean cnt= true;
			if(max_check_id.equalsIgnoreCase("") || max_check_id.equalsIgnoreCase("0")){
					cnt = true;
			}else{
				String sql = "SELECT * FROM "+tableName+" a WHERE  a.check_id = "+max_check_id+" AND a.seq = ( SELECT MAX(b.seq) FROM check_stock b WHERE b.check_id = "+max_check_id+" AND b.pn = a.pn) and carry_flag ='0'  ";
				Statement st = conn.createStatement();
				ResultSet rs = st.executeQuery(sql);
				while(rs.next()){
					cnt = false;
				}
				st.close();
				rs.close();
				conn.commit();
				conn.close();
			}
			return cnt;
		} catch (Exception e) {
			if( conn != null){
				conn.rollback();
				conn.close();
			 }
			System.out.println(e.getMessage());
			 throw new Exception(e.getMessage());
		}
	}
	public static boolean CheckConfirmApprove(String check_id) throws Exception{
		Connection conn = null;
		try {
			conn = DBPool.getConnection();
			conn.setAutoCommit(false);
			boolean cnt= true;
			String sql = "SELECT * FROM "+tableName+" a WHERE  a.check_id = "+check_id+" AND a.seq = ( SELECT MAX(b.seq) FROM check_stock b WHERE b.check_id = "+check_id+" AND b.pn = a.pn) and status ='00'  ";
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while(rs.next()){
				cnt = false;
			}
			st.close();
			rs.close();
			conn.commit();
			conn.close();
			return cnt;
		} catch (Exception e) {
			if( conn != null){
				conn.rollback();
				conn.close();
			 }
			System.out.println(e.getMessage());
			 throw new Exception(e.getMessage());
		}
	}
	
	//ดี
	public static List<CheckStockBean> selectList() throws Exception{
		Connection conn = DBPool.getConnection();
		String max_check_id = CheckStockTS.SelectMaxCheckID();
		//String sql = "SELECT * FROM "+tableName+" a WHERE  a.check_id = "+max_check_id+" AND a.seq = ( SELECT MAX(b.seq) FROM check_stock b WHERE b.check_id = "+max_check_id+" AND b.pn = a.pn) ";
		String sql = "SELECT * FROM "+tableName+" ";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<CheckStockBean> list = new ArrayList<CheckStockBean>();
		while (rs.next()) {
			CheckStockBean entity = new CheckStockBean();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	//ดี
	public static List<CheckStockBean> ListApprove(String check_id) throws Exception{
		Connection conn = DBPool.getConnection();
		String max_check_id = CheckStockTS.SelectMaxCheckID();
		//String sql = "SELECT * FROM "+tableName+" a WHERE  a.check_id = "+max_check_id+" AND a.seq = ( SELECT MAX(b.seq) FROM check_stock b WHERE b.check_id = "+max_check_id+" AND b.pn = a.pn) and status='10' ";
		String sql = "SELECT * FROM "+tableName+" WHERE check_id='"+check_id+"' AND status != '40' ";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<CheckStockBean> list = new ArrayList<CheckStockBean>();
		while (rs.next()) {
			CheckStockBean entity = new CheckStockBean();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	public static List<CheckStockBean> selectList_Check4Carry() throws Exception{
		Connection conn = DBPool.getConnection();
		String max_check_id = CheckStockTS.SelectMaxCheckID();
		String sql = "SELECT * FROM "+tableName+" a WHERE  a.check_id = "+max_check_id+" AND a.seq = ( SELECT MAX(b.seq) FROM check_stock b WHERE b.check_id = "+max_check_id+" AND b.pn = a.pn) and status='00'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<CheckStockBean> list = new ArrayList<CheckStockBean>();
		while (rs.next()) {
			CheckStockBean entity = new CheckStockBean();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	public static List<CheckStockBean> selectList_Check4CarryAll() throws Exception{
		Connection conn = DBPool.getConnection();
		String max_check_id = CheckStockTS.SelectMaxCheckID();
		String sql = "SELECT * FROM "+tableName+" a WHERE  a.check_id = "+max_check_id+" AND a.seq = ( SELECT MAX(b.seq) FROM check_stock b WHERE b.check_id = "+max_check_id+" AND b.pn = a.pn AND b.status != '40') AND a.status != '40' ";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<CheckStockBean> list = new ArrayList<CheckStockBean>();
		while (rs.next()) {
			CheckStockBean entity = new CheckStockBean();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	public static void Close_stock(Connection conn,CheckStockBean entity) throws NumberFormatException, IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		entity.setStatus("20");
		entity.setClose_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames_close, keys);
	}
	public static void Make_stock(Connection conn,int check_id) throws Exception{
		try {
			String sql = "";
			sql += " SELECT pn, ";
			sql += " 	qty AS qty_old ";
			sql += " FROM pa_part_master a ";
			sql += " WHERE 1=1 ";
			sql += " 	AND a.pn NOT IN ( SELECT pn ";
			sql += " 					  FROM check_stock b ";
			sql += " 					  WHERE check_id='"+check_id+"' ";
			sql += " 						AND status != '40' ) ";
			sql += " ORDER BY a.pn ASC ";
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while( rs.next() ){
				CheckStockBean entity = new CheckStockBean();
				DBUtility.bindResultSet(entity, rs);
				entity.setCheck_id(check_id);
				entity.setSeq(Integer.parseInt(DBUtility.genNumberFromDB(conn, tableName, entity, new String[]{"check_id"}, "seq")));
				entity.setCheck_date(DBUtility.getDBCurrentDateTime());
				entity.setCheck_by("Auto");
				entity.setStatus(STATUS_MAKE_STOCK);
				DBUtility.insertToDB(conn, tableName, entity);
			}
		} catch (Exception e) {
			throw new Exception( e.getMessage() );
		}
	}
}
