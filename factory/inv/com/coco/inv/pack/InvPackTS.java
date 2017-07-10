/**
 * 
 */
package com.coco.inv.pack;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

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
	private static String[] keys = {"mat_code","factor",};
	private static String[] fieldNames = {"description","other_unit","other_unit","factor" ,"main_unit","std_unit" ,"des_unit" ,"unit_pack","update_by","update_date"};
	
	public static void insert(InvPackBean entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();		
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}

	
	public static boolean delete(InvPackBean entity) {
		// TODO Auto-generated method stub
		return false;
	}

	public static void update(InvPackBean entity) {
		// TODO Auto-generated method stub
		
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

}
