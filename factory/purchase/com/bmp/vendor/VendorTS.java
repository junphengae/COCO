package com.bmp.vendor;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import com.bitmap.bean.inventory.InventoryMasterVendor;
import com.bitmap.bean.inventory.Vendor;
import com.bitmap.bean.purchase.PurchaseRequest;
import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;

public class VendorTS {
	public static String tableName = "inv_vendor";
	private static String[] keys = {"vendor_id"};
	private static String[] fieldNames = {"vendor_code","vendor_name","vendor_phone","vendor_fax","vendor_address","vendor_email",
										  "vendor_contact","vendor_ship","vendor_condition","vendor_credit","update_by","update_date"};
	

	private static String genId(Connection conn) throws SQLException {
		String sql = "SELECT vendor_id FROM " + tableName + " ORDER BY vendor_id DESC";
		ResultSet rs = conn.createStatement().executeQuery(sql);
		String vendor_id = "v00001";
		
		if (rs.next()) {
			String temp = rs.getString("vendor_id");
			String id = (Integer.parseInt(temp.substring(1, temp.length())) + 10001) + "";
			vendor_id = "v" + id.substring(1,id.length());
		}
		rs.close();
		return vendor_id;
	}
	
	public static void insert(VendorBean entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setVendor_id(genId(conn));
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	public static VendorBean select(String vendor_id) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		VendorBean entity = new VendorBean();		
		entity.setVendor_id(vendor_id);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);		
		conn.close();
		return entity;
	}
	
	public static List<VendorBean> selectWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1";
		String vendor_code = "";
		String vendor_name = "";
		
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (str[0].equalsIgnoreCase("vendor_code")){
					vendor_code = str[1];
					sql += " AND vendor_code like '%" +vendor_code+ "%' ";
				} else 
				if (str[0].equalsIgnoreCase("vendor_name")) {
					vendor_name = str[1];
					sql += " AND vendor_name  like '%" +vendor_name+ "%' ";
				} 
			}
		}

		sql += " ORDER BY vendor_id ASC";
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<VendorBean> list = new ArrayList<VendorBean>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					VendorBean entity = new VendorBean();
					DBUtility.bindResultSet(entity, rs);
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
	

	public static boolean delete(VendorBean entity) throws SQLException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();	
		boolean po = checkPOActive(conn ,entity.getVendor_id());
		if(!po){
			DBUtility.deleteFromDB(conn, tableName, entity, keys);
		}		
		conn.close();
		return po;
	}

	private static boolean checkPOActive(Connection conn, String vendor_id) throws SQLException {
		boolean po = false;
		try {
			String sql = "SELECT * FROM pur_purchase_order  WHERE 1=1";
				   sql += " AND vendor_id = '" +vendor_id+ "' ";
				   sql += " AND status = '" +PurchaseRequest.STATUS_PO_OPEN+ "' ";
				   //System.out.println("SQL:"+sql);
				   Statement st = conn.createStatement();
				   ResultSet rs = st.executeQuery(sql);
					while (rs.next()) {
						po = true;
					}
					rs.close();
					st.close();
		} catch (Exception e) {
			conn.close();
		}		
		return po;
	}

	public static void update(VendorBean entity) throws SQLException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();		
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();		
	}
	
	
}
