/**
 * 
 */
package com.coco.inv.pack;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.naming.NamingException;

import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;
import com.bmp.vendor.VendorBean;

/**
 * @author Jack JPK
 *
 */
public class InvPackTS {

	public static String tableName = "inv_pack";
	private static String[] keys = {"mat_code","pack_id",};
	private static String[] fieldNames = {"description","other_unit","other_unit","factor" ,"main_unit","std_unit" ,"des_unit" ,"unit_pack","update_by","update_date"};
	
	public static void insert(InvPackBean entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();		
		
		entity.setPack_id(genId(conn , entity.getMat_code()));
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	private static String genId(Connection conn, String mat_code) throws SQLException {
		String sql = "SELECT max(pack_id) as id  FROM " + tableName + " where mat_code = '"+mat_code+"' ORDER BY pack_id DESC";
		ResultSet rs = conn.createStatement().executeQuery(sql);
		String pack_id = "1";		
		if (rs.next()) {
			String temp = rs.getString("id")==null?"0":rs.getString("id");			
			String id = (Integer.parseInt(temp) + 1) + "";			 
			if(!temp.equalsIgnoreCase("0")){
				pack_id = id;
			}						
		}
		rs.close();
		return pack_id;
	}
	
	public static boolean delete(InvPackBean entity) throws SQLException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();	
		boolean pk = checkActive(conn ,entity.getMat_code());
		if(!pk){
			DBUtility.deleteFromDB(conn, tableName, entity, keys);
		}		
		conn.close();
		return pk;
	}

	private static boolean checkActive(Connection conn, String mat_code) {
		// TODO Auto-generated method stub
		return false;
	}


	public static void update(InvPackBean entity) throws Exception {
		Connection conn = DBPool.getConnection();	
		try {
			entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
			DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
			
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}finally{
			conn.close();	
		}
		
	}

	public static InvPackBean select(InvPackBean entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);		
		conn.close();
		return entity;
	}
	
	public static List<InvPackBean> selectWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1";
		String mat_code = "";
				
		Iterator<String[]> ite = params.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (str[0].equalsIgnoreCase("mat_code")){
					mat_code = str[1];
					sql += " AND mat_code like '%" +mat_code+ "%' ";
				} 
			}
		}

		sql += " ORDER BY mat_code ASC";
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<InvPackBean> list = new ArrayList<InvPackBean>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					InvPackBean entity = new InvPackBean();
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

	public static List<String[]> getTimeComboList() throws NamingException, SQLException{
		List<String[]> list = new ArrayList<String[]>();		
		for (int i = 0; i < 24 ; i++) {			
			for (int j = 0; j < 60 ; j++) {
				String HH = String.valueOf(i);
				String MI = String.valueOf(j);
				HH = HH.length()==1?"0"+HH:HH;
				MI = MI.length()==1?"0"+MI:MI;
				String time = HH+":"+MI+":00";				
				String[] vals = {time,time};
				//System.out.println(" <option value= \""+HH+":"+MI+":00\">"+HH+":"+MI+":00</option>");
				list.add(vals);
			}
		}	  
		return list;
	}
}
