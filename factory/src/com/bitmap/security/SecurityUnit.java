package com.bitmap.security;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.bitmap.dbconnection.mysql.vbi.*;
import com.bitmap.dbutils.DBUtility;

public class SecurityUnit {
	public static String tableName = "security_unit";
	
	private String unit_id = "";
	private String unit_order = "";
	private String unit_name = "";
	private String unit_url = "";
	private String sys_id = "";
	
	public static List<SecurityUnit> listUnit(String user_id,String sys_id) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String sql = "select distinct(unit.unit_id),unit.unit_name,unit.unit_url,unit.sys_id from security_system sys inner join security_unit unit on sys.sys_id = unit.sys_id " +
					 "inner join security_authority author on unit.unit_id = author.unit_id " +
					 "inner join security_user_role user_role on author.role_id = user_role.role_id " +
					 "inner join security_user user_	on user_role.user_id = user_.user_id " +
					 "where user_.user_id = '" + user_id + "' and sys.sys_id ='" + sys_id + "' ORDER BY (unit.unit_order*1);";
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SecurityUnit> list = new ArrayList<SecurityUnit>();
		while (rs.next()) {
			SecurityUnit unit = new SecurityUnit();
			DBUtility.bindResultSet(unit, rs);
			list.add(unit);
		}
		conn.close();
		return list;
	}
	
	public String getUnit_id() {
		return unit_id;
	}
	public void setUnit_id(String unit_id) {
		this.unit_id = unit_id;
	}
	public String getUnit_order() {
		return unit_order;
	}
	public void setUnit_order(String unit_order) {
		this.unit_order = unit_order;
	}
	public String getUnit_name() {
		return unit_name;
	}
	public void setUnit_name(String unit_name) {
		this.unit_name = unit_name;
	}
	public String getUnit_url() {
		return unit_url;
	}
	public void setUnit_url(String unit_url) {
		this.unit_url = unit_url;
	}
	public String getSys_id() {
		return sys_id;
	}
	public void setSys_id(String sys_id) {
		this.sys_id = sys_id;
	}
}
