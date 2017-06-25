package com.bmp.parts.master.transaction;

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
import com.bmp.parts.master.bean.PartsMasterBean;

public class PartsMasterTS {
	public static String tableName = "pa_part_master";
	private static String[] keys = {"pn"};
	private static String[] fieldNames = {"group_id","des_unit","cat_id","sub_cat_id","fit_to","description","sn_flag","moq","mor","weight","location","price","price_unit","cost","cost_unit","update_date","update_by"};
	
	
		public static List<PartsMasterBean> selectListCheckStock(String check_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException, UnsupportedEncodingException{
			Connection conn = DBPool.getConnection();
			String sql = "SELECT * FROM " + tableName + " a WHERE a.pn NOT IN (SELECT pn FROM check_stock b WHERE check_id='"+check_id+"')";
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			
			List<PartsMasterBean> list = new ArrayList<PartsMasterBean>();
			while (rs.next()) {
				PartsMasterBean entity = new PartsMasterBean();
				DBUtility.bindResultSet(entity, rs);
				entity.setUICate(PartGroupsTS.select(entity.getGroup_id(),conn).getGroup_name_en());
				list.add(entity);
			}
			rs.close();
			st.close();
			conn.close();
			return list;
		}
		
		public static List<PartsMasterBean> selectWithCTRL(PageControl ctrl, List<String[]> params,String check_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
			String sql = "SELECT * FROM " + tableName + " a WHERE 1=1  ";
			
			Iterator<String[]> ite = params.iterator();
			while (ite.hasNext()) {
				String[] str = (String[]) ite.next();
				if (str[1].length() > 0) {
					if(str[0].equalsIgnoreCase("flag_max_check_id")){
						sql += "AND a.pn NOT IN (SELECT pn FROM check_stock b WHERE check_id='"+check_id+"' AND status != '40' )";
					}
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
			
			sql += " ORDER BY a.pn ASC";
			//System.out.println("Q = "+sql);
			Connection conn = DBPool.getConnection();
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			
			List<PartsMasterBean> list = new ArrayList<PartsMasterBean>();
			int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
			int max = (min + ctrl.getLine_per_page()) - 1;
			int cnt = 0;
			
			while (rs.next()) {
				if (cnt > max) {
					cnt++;
				} else {
					if (cnt >= min) {
						PartsMasterBean entity = new PartsMasterBean();
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

		public static void updateQty(PartsMasterBean entity) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
			Connection conn = DBPool.getConnection();
			entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
			DBUtility.updateToDB(conn, tableName, entity, new String[]{"qty","update_by","update_date"}, keys);
			conn.close();
		}
}
