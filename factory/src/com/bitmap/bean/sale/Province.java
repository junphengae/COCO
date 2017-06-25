package com.bitmap.bean.sale ;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.naming.NamingException;

import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;

public class Province {
	public static String tableName = "provinces";
	String province_id = "";
	String province_th_name = "";
	String province_en_name = "";
	String country_id = "";
	
	public static String getName(String province_id) throws SQLException{		
		String val = "";
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE province_id='" + province_id + "'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		while (rs.next()){
			val = DBUtility.getString("province_th_name", rs);
		}	
		rs.close();
		st.close();
		conn.close();
		return val;
	}
	
	public static void main(String[] s) throws SQLException{
		//String aa = getName("11");
		//System.out.print(aa);
	}
	
	public static Province select(String province_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Province entity = new Province();
		entity.setProvince_id(province_id);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"province_id"});
		conn.close();
		return entity;
	}
	
	public static Province select(String province_id, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Province entity = new Province();
		entity.setProvince_id(province_id);
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"province_id"});
		return entity;
	}
	
	public static List<String[]> selectList(String lang, String country_id)
			throws NamingException, SQLException{
		List<String[]> l = new ArrayList<String[]>();
		String fieldName = (lang.equalsIgnoreCase("th")) ? "province_th_name" : "province_en_name" ;
		Connection conn = DBPool.getConnection();
		PreparedStatement ps = conn.prepareStatement("SELECT province_id,"+fieldName+" as name FROM provinces WHERE country_id='" + country_id + "' ORDER by "+fieldName);
		ResultSet rs = ps.executeQuery();
		while(rs.next()){
			String id = rs.getString(1);
			String name = rs.getString(2);
			String[] vals = {id,name};
			l.add(vals);
		}
		rs.close();
		ps.close();
		conn.close();
		return l;
	}

	public static List<String[]> getComboList() throws NamingException, SQLException{
		List<String[]> l = new ArrayList<String[]>();
		Connection conn = DBPool.getConnection();
		PreparedStatement ps = conn.prepareStatement("SELECT * FROM " + tableName + " WHERE 1=1 ORDER BY province_id");
		ResultSet rs = ps.executeQuery();
		while(rs.next()){
			String id = rs.getString(1);
			String name = rs.getString(2);
			String[] vals = {id,name};
			l.add(vals);
		}
		rs.close();
		ps.close();
		conn.close();
		return l;
	}
	
	public String getProvince_id() {
		return province_id;
	}

	public void setProvince_id(String province_id) {
		this.province_id = province_id;
	}

	public String getProvince_th_name() {
		return province_th_name;
	}

	public void setProvince_th_name(String province_th_name) {
		this.province_th_name = province_th_name;
	}

	public String getProvince_en_name() {
		return province_en_name;
	}

	public void setProvince_en_name(String province_en_name) {
		this.province_en_name = province_en_name;
	}

	public String getCountry_id() {
		return country_id;
	}

	public void setCountry_id(String country_id) {
		this.country_id = country_id;
	}

}