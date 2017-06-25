package com.bmp.parts.check.stock;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;

public class CheckStockHDTS {
	public static final String tableName 	= "check_stock_hd";
	public static final String[] keys    	= {"check_id"};
	public static String STATUS_WAIT_APPROVE = "00";
	public static String STATUS_CT_APPROVE   = "10";
	public static String STATUS_CT_EDIT		 = "15";
	public static String STATUS_CT_REJECT    = "20";
	
	public static String status(String status){
		HashMap<String , String> map = new HashMap<String, String>();
		map.put(STATUS_WAIT_APPROVE, "รออนุมัติ");
		map.put(STATUS_CT_APPROVE, "อนุมัติแล้ว");
		map.put(STATUS_CT_EDIT, "อยู่ระหว่างการแก้ไข");
		map.put(STATUS_CT_REJECT, "ไม่อนุมัติ");
		
		return map.get(status);
	}
	public static void insert(Connection conn, CheckStockHDBean entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		entity.setCheck_id(Integer.parseInt(DBUtility.genNumber(conn, tableName, "check_id")));
		entity.setCheck_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
	}
	public static List<CheckStockHDBean> selectList(PageControl ctrl) throws Exception{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM "+tableName+" ";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<CheckStockHDBean> list = new ArrayList<CheckStockHDBean>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					CheckStockHDBean entity = new CheckStockHDBean();
					DBUtility.bindResultSet(entity, rs);
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
	public static List<CheckStockHDBean> selectListApprove(PageControl ctrl) throws Exception{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM "+tableName+" WHERE status !=''";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<CheckStockHDBean> list = new ArrayList<CheckStockHDBean>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					CheckStockHDBean entity = new CheckStockHDBean();
					DBUtility.bindResultSet(entity, rs);
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
	public static void update(Connection conn,CheckStockHDBean entity) throws Exception{
		try {
			entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
			DBUtility.updateToDB(conn, tableName, entity, new String[]{"status","update_date","update_by"}, new String[] {"check_id"});
		} catch (Exception e) {
			if( conn != null){
				conn.rollback();
				conn.close();
			 }
			System.out.println(e.getMessage());
			 throw new Exception(e.getMessage());
		}
		
	}
	public static void ApproveStock(Connection conn,CheckStockHDBean entity) throws Exception{
		try {
			final String[] fieldNames = "status,approve_date,approve_by".split(",");
			entity.setApprove_date(DBUtility.getDBCurrentDateTime());
			DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		} catch (Exception e) {
			if( conn != null){
				conn.rollback();
				conn.close();
			 }
			System.out.println(e.getMessage());
			 throw new Exception(e.getMessage());
		}
	}
	
	public static CheckStockHDBean getCheckIDSTOCK() throws Exception{
		Connection conn = null;
		try {
			conn = DBPool.getConnection();
			conn.setAutoCommit(false);
			
			String sql = "SELECT * FROM "+tableName+" WHERE check_id= (SELECT MAX(check_id) FROM "+tableName+") ";
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			CheckStockHDBean entity = new CheckStockHDBean();
			while(rs.next()){
				DBUtility.bindResultSet(entity, rs);
			}
			st.close();
			rs.close();
			conn.commit();
			conn.close();
			return entity;
		} catch (Exception e) {
			if( conn != null){
				conn.rollback();
				conn.close();
			 }
			System.out.println(e.getMessage());
			 throw new Exception(e.getMessage());
		}
	}
	public static List<CheckStockHDBean> DDL_check_id() throws Exception {
		List<CheckStockHDBean> list = new ArrayList<CheckStockHDBean>();
		Connection conn = null;
		try {
			conn = DBPool.getConnection();
			String sql = "";
			sql += " SELECT * ";
			sql += " FROM "+tableName;
			sql += " WHERE status = '10' ";
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while(rs.next()){
				CheckStockHDBean entity = new CheckStockHDBean();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);
			}
			rs.close();
			st.close();
			conn.close();
		} catch (Exception e) {
			if( conn != null ){
				conn.close();
			}
			throw new Exception( e.getMessage() );
		}
		return list;
	}
	
	public static List<CheckStockReportBean> ReportStockCard(int check_id) throws Exception{
		List<CheckStockReportBean> list = new ArrayList<CheckStockReportBean>();
		Connection conn = null;
		Statement st = null;
		ResultSet rs = null;
		try {
			conn = DBPool.getConnection();
			
			if( check_id == 1 ){
				String sql = "";
				sql += " SELECT stock_new.pn AS pn, ";
				sql += " in_stock, ";
				sql += " out_stock, ";
				sql += " qty_new, ";
				sql += " qty_old, ";
				sql += " qty_stock_old, ";
				sql += " qty_stock_new, ";
				sql += " stock_new.status, ";
				sql += " status_stock, ";
				sql += " description, ";
				sql += " carry_flag ";
				sql += " FROM ( SELECT pn, ";
				sql += " 			qty_new, ";
				sql += " 			qty_old, ";
				sql += " 			status, ";
				sql += "			carry_flag ";
				sql += " 			FROM check_stock ";
				sql += " 			WHERE check_id = '"+check_id+"' ) AS stock_new ";
				sql += " LEFT JOIN (SELECT pn, ";
				sql += " 			qty_new AS qty_stock_new, ";
				sql += " 			qty_old AS qty_stock_old , ";
				sql += " 			status AS status_stock ";
				sql += " 			FROM check_stock ";
				sql += " 			WHERE check_id = '"+(check_id-1)+"' ) AS stock_old ON stock_old.pn = stock_new.pn ";
				sql += " LEFT JOIN pa_part_master PA ON PA.pn = stock_new.pn ";
				sql += " LEFT JOIN ( SELECT pn, ";
				sql += "		SUM(lot_qty) AS in_stock ";
				sql += " 		FROM part_lot ";
				sql += " 		WHERE DATE_FORMAT(create_date,'%Y-%m-%d %H:%i') <= DATE_FORMAT((SELECT approve_date FROM check_stock_hd WHERE check_id = '"+check_id+"'),'%Y-%m-%d %H:%i') ";
				sql += " 		GROUP BY pn ) AS lot ON lot.pn = stock_new.pn ";
				sql += " LEFT JOIN ( SELECT pn, ";
				sql += " 			SUM(draw_qty) AS out_stock ";
				sql += " 			FROM part_lot_control ";
				sql += " 			WHERE DATE_FORMAT(draw_date,'%Y-%m-%d %H:%i') <= DATE_FORMAT((SELECT approve_date FROM check_stock_hd WHERE check_id = '"+check_id+"'),'%Y-%m-%d %H:%i') ";
				sql += " 			GROUP BY pn )AS control ON control.pn = stock_new.pn ";
				
				st = conn.createStatement();
				rs = st.executeQuery(sql);
				while(rs.next()){
					CheckStockReportBean entity = new CheckStockReportBean();
					DBUtility.bindResultSet(entity, rs);
					list.add(entity);
				}
				rs.close();
				st.close();
			}else{
				String sql = "";
				sql += " SELECT stock_new.pn AS pn, ";
				sql += " in_stock, ";
				sql += " out_stock, ";
				sql += " qty_new, ";
				sql += " qty_old, ";
				sql += " qty_stock_old, ";
				sql += " qty_stock_new, ";
				sql += " stock_new.status, ";
				sql += " status_stock, ";
				sql += " description, ";
				sql += " carry_flag ";
				sql += " FROM ( SELECT pn, ";
				sql += " 			qty_new, ";
				sql += " 			qty_old, ";
				sql += " 			status, ";
				sql += "			carry_flag ";
				sql += " 			FROM check_stock ";
				sql += " 			WHERE check_id = '"+check_id+"' ) AS stock_new ";
				sql += " LEFT JOIN (SELECT pn, ";
				sql += " 			qty_new AS qty_stock_new, ";
				sql += " 			qty_old AS qty_stock_old , ";
				sql += " 			status AS status_stock ";
				sql += " 			FROM check_stock ";
				sql += " 			WHERE check_id = '"+(check_id-1)+"' ) AS stock_old ON stock_old.pn = stock_new.pn ";
				sql += " LEFT JOIN pa_part_master PA ON PA.pn = stock_new.pn ";
				sql += " LEFT JOIN ( SELECT pn,";
				sql += "		SUM(lot_qty) AS in_stock ";
				sql += " 		FROM part_lot ";
				sql += " 		WHERE DATE_FORMAT(create_date,'%Y-%m-%d %H:%i') BETWEEN DATE_FORMAT((SELECT approve_date FROM check_stock_hd WHERE check_id = '"+(check_id-1)+"'),'%Y-%m-%d %H:%i') ";
				sql += "														AND DATE_FORMAT((SELECT approve_date FROM check_stock_hd WHERE check_id = '"+check_id+"'),'%Y-%m-%d %H:%i') ";
				sql += " 		GROUP BY pn ) AS lot ON lot.pn = stock_new.pn ";
				sql += " LEFT JOIN ( SELECT pn, ";
				sql += " 			SUM(draw_qty) AS out_stock ";
				sql += " 			FROM part_lot_control ";
				sql += " 			WHERE DATE_FORMAT(draw_date,'%Y-%m-%d %H:%i') BETWEEN DATE_FORMAT((SELECT approve_date FROM check_stock_hd WHERE check_id = '"+(check_id-1)+"'),'%Y-%m-%d %H:%i') ";
				sql += "														AND DATE_FORMAT((SELECT approve_date FROM check_stock_hd WHERE check_id = '"+check_id+"'),'%Y-%m-%d %H:%i') ";
				sql += " 			GROUP BY pn )AS control ON control.pn = stock_new.pn ";
				st = conn.createStatement();
				rs = st.executeQuery(sql);
				//System.out.println(sql);
				while(rs.next()){
					CheckStockReportBean entity = new CheckStockReportBean();
					DBUtility.bindResultSet(entity, rs);
					list.add(entity);
				}
				rs.close();
				st.close();
			}
			conn.close();
		} catch (Exception e) {		
			if( rs != null ){
				rs.close();
			}
			if( st != null ){
				st.close();
			}
			if( conn != null ){
				conn.close();
			}
			throw new Exception( e.getMessage() );
		}
		return list;
	}
}
