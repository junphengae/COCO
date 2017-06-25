package com.bitmap.bean.sale;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.NamingException;

import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;

public class Zipcode {

	public static String tableName = "zips";
	private static String[] keys = {"zip_code"};
		
	String zip_code = "";
	String zip_th_name = "";
	String zip_en_name = "";
	String gps_latitude = "";
	String gps_longitude = "";
	String province_id = "";

	public String getProvince_id() {
		return province_id;
	}
	public void setProvince_id(String province_id) {
		this.province_id = province_id;
	}
	public String getZip_code() {
		return zip_code;
	}
	public void setZip_code(String zip_code) {
		this.zip_code = zip_code;
	}
	public String getZip_th_name() {
		return zip_th_name;
	}
	public void setZip_th_name(String zip_th_name) {
		this.zip_th_name = zip_th_name;
	}
	public String getZip_en_name() {
		return zip_en_name;
	}
	public void setZip_en_name(String zip_en_name) {
		this.zip_en_name = zip_en_name;
	}
	public String getGps_latitude() {
		return gps_latitude;
	}
	public void setGps_latitude(String gps_latitude) {
		this.gps_latitude = gps_latitude;
	}
	public String getGps_longitude() {
		return gps_longitude;
	}
	public void setGps_longitude(String gps_longitude) {
		this.gps_longitude = gps_longitude;
	}
	
	public static List<String[]> getComboList(String lang, String province_id) throws NamingException, SQLException{
		List<String[]> l = new ArrayList<String[]>();
		String fieldName = (lang.equalsIgnoreCase("th")) ? "zip_th_name" : "zip_en_name" ;
		Connection conn = DBPool.getConnection();
		PreparedStatement ps = conn.prepareStatement("SELECT zip_code,"+fieldName+" AS name FROM zips WHERE province_id='" + province_id + "' ORDER BY zip_code");
		ResultSet rs = ps.executeQuery();
		while(rs.next()){
			String id = rs.getString(1);
			String name = rs.getString(2);
			String[] vals = {id,id + " - " + name};
			l.add(vals);
		}
		rs.close();
		ps.close();
		conn.close();
		return l;
	}
	
	public static Zipcode select(String zip_code, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Zipcode entity = new Zipcode();
		entity.setZip_code(zip_code);
		DBUtility.getEntityFromDB(conn, tableName, entity,keys);
		return entity;
	}
	
}
