package com.bitmap.bean.parts;
	import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;

	public class PartCategoriesSub {
		public static String tableName = "pa_categories_sub";
		private static String[] keys = {"sub_cat_id"};
		
		String sub_cat_id = "";
		String cat_id = "";
		String group_id = "";
		String sub_cat_name_short = "";
		String sub_cat_name_th = "";
		String create_by = "";
		Timestamp create_date = null;
		
		private PartCategories UICat = new PartCategories();
		public PartCategories getUICat() {return UICat;}
		public void setUICat(PartCategories uICat) {UICat = uICat;}

		public static void insert(PartCategoriesSub entity) throws IllegalAccessException, InvocationTargetException, SQLException{
			Connection conn = DBPool.getConnection();
			entity.setSub_cat_id(DBUtility.genNumber(conn, tableName, "sub_cat_id"));
			entity.setCat_id(entity.getCat_id());
			entity.setGroup_id(entity.getGroup_id());
			entity.setCreate_date(DBUtility.getDBCurrentDateTime());		
			DBUtility.insertToDB(conn, tableName, entity);
			conn.close();
		}
		
	
		
		public static PartCategoriesSub select(String sub_cat_id,String cat_id, String group_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
			PartCategoriesSub entity = new PartCategoriesSub();
			entity.setSub_cat_id(sub_cat_id);
			entity.setCat_id(cat_id);
			entity.setGroup_id(group_id);
			select(entity);
			return entity;
		}
		
		public static String selectSubCatName(String sub_cat_id,String cat_id, String group_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
			PartCategoriesSub entity = new PartCategoriesSub();
			entity.setSub_cat_id(sub_cat_id);
			entity.setCat_id(cat_id);
			entity.setGroup_id(group_id);
			select(entity);
			return entity.getSub_cat_name_th();
		}
		
		public static PartCategoriesSub select(String sub_cat_id,String cat_id, String group_id, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
			PartCategoriesSub entity = new PartCategoriesSub();
			entity.setSub_cat_id(sub_cat_id);
			entity.setCat_id(cat_id);
			entity.setGroup_id(group_id);
			select(entity, conn);
			return entity;
		}
		
		public static PartCategoriesSub select(PartCategoriesSub entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
			Connection conn = DBPool.getConnection();
			DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"sub_cat_id","cat_id","group_id"});
			conn.close();
			return entity;
		}
		
		public static PartCategoriesSub select(PartCategoriesSub entity, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
			DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"sub_cat_id","cat_id","group_id"});
			entity.setUICat(PartCategories.select(entity.getCat_id(), entity.getGroup_id(), conn));
			return entity;
		}
		
		public static List<PartCategoriesSub> selectList(String cat_id, String group_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
			String sql = "SELECT * FROM " + tableName + " WHERE cat_id ='" + cat_id + "' AND group_id='" + group_id + "' ORDER BY (sub_cat_id*1)";
			
			////System.out.println(sql);
			Connection conn = DBPool.getConnection();
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			
			List<PartCategoriesSub> list = new ArrayList<PartCategoriesSub>();
			while (rs.next()) {
				PartCategoriesSub entity = new PartCategoriesSub();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);
			}
			rs.close();
			st.close();
			conn.close();
			return list;
		}
		
		public static List<String[]> ddl_th(String cat_id, String group_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
			String sql = "SELECT * FROM " + tableName + " WHERE cat_id ='" + cat_id + "' AND group_id='" + group_id + "' ORDER BY (sub_cat_id*1)";
			Connection conn = DBPool.getConnection();
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			
			List<String[]> list = new ArrayList<String[]>();
			while (rs.next()) {
				PartCategoriesSub entity = new PartCategoriesSub();
				DBUtility.bindResultSet(entity, rs);
				list.add(new String[]{entity.getSub_cat_id(),entity.getSub_cat_name_th()});
			}
			rs.close();
			st.close();
			conn.close();
			return list;
		}
		
		public static void update(PartCategoriesSub entity) throws IllegalAccessException, InvocationTargetException, SQLException{
			Connection conn = DBPool.getConnection();
			entity.setCreate_date(DBUtility.getDBCurrentDateTime());
			DBUtility.updateToDB(conn, tableName, entity, new String[]{"sub_cat_name_short","sub_cat_name_th","create_by","create_date"}, new String[]{"sub_cat_id","cat_id","group_id"});
			conn.close();
		}
		
		public static boolean checkShortName(PartCategoriesSub entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
			boolean pass = false;
			Connection conn = DBPool.getConnection();
			pass = DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"sub_cat_name_short","cat_id","group_id"});
			conn.close();
			return pass;
		}
		
		
		public static boolean checkShortNameForEdit(PartCategoriesSub entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
			boolean pass = false;
			String sql = "SELECT * FROM " + tableName + " WHERE sub_cat_name_short ='" + entity.sub_cat_name_short + "' AND sub_cat_id != '"+entity.sub_cat_id+"' AND cat_id='" + entity.getCat_id() + "' AND group_id='" + entity.getGroup_id() + "'" ;
			Connection conn = DBPool.getConnection();
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);				
			pass = rs.next();
			rs.close();
			st.close();
			conn.close();
			return pass;
		}
		
		public String getSub_cat_id() {
			return sub_cat_id;
		}

		public void setSub_cat_id(String sub_cat_id) {
			this.sub_cat_id = sub_cat_id;
		}

		public String getSub_cat_name_short() {
			return sub_cat_name_short;
		}

		public void setSub_cat_name_short(String sub_cat_name_short) {
			this.sub_cat_name_short = sub_cat_name_short;
		}

		public String getSub_cat_name_th() {
			return sub_cat_name_th;
		}

		public void setSub_cat_name_th(String sub_cat_name_th) {
			this.sub_cat_name_th = sub_cat_name_th;
		}
		
		public String getCat_id() {
			return cat_id;
		}
		public void setCat_id(String cat_id) {
			this.cat_id = cat_id;
		}
		
		public String getGroup_id() {
			return group_id;
		}

		public void setGroup_id(String group_id) {
			this.group_id = group_id;
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
	}