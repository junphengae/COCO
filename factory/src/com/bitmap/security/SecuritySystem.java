package com.bitmap.security;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.bitmap.dbconnection.mysql.vbi.*;
import com.bitmap.dbutils.DBUtility;

public class SecuritySystem {
	public static String tableName = "security_system";
	
	private String sys_id = "";
	private String sys_name = "";
	
	private List<SecurityUnit> unitList = new ArrayList<SecurityUnit>();
	
	public static HashMap<String,SecuritySystem> selectByUserId(String user_id) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String sql = "select distinct(sys.sys_id),sys.sys_name from security_system sys inner join security_unit unit on sys.sys_id = unit.sys_id " +
					 "inner join security_authority author on unit.unit_id = author.unit_id " +
					 "inner join security_user_role user_role on author.role_id = user_role.role_id " +
					 "inner join security_user user_ on user_role.user_id = user_.user_id " +
					 "where user_.user_id = '" + user_id + "' ORDER BY sys.sys_id;";
	
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		HashMap<String,SecuritySystem> map = new HashMap<String, SecuritySystem>();
		while (rs.next()) {
			SecuritySystem sys = new SecuritySystem();
			DBUtility.bindResultSet(sys, rs);
			
			sys.setUIUnitList(SecurityUnit.listUnit(user_id, sys.getSys_id()));
			map.put(sys.getSys_id(), sys);
		}
		rs.close();
		st.close();
		conn.close();
		return map;	
	}
	
	public static List<SecuritySystem> selectListByUserId(String user_id) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String sql = "select distinct(sys.sys_id),sys.sys_name from security_system sys inner join security_unit unit on sys.sys_id = unit.sys_id " +
					 "inner join security_authority author on unit.unit_id = author.unit_id " +
					 "inner join security_user_role user_role on author.role_id = user_role.role_id " +
					 "inner join security_user user_ on user_role.user_id = user_.user_id " +
					 "where user_.user_id = '" + user_id + "' ORDER BY sys.sys_id;";
	
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<SecuritySystem> list = new ArrayList<SecuritySystem>();
		while (rs.next()) {
			SecuritySystem sys = new SecuritySystem();
			DBUtility.bindResultSet(sys, rs);
			
			sys.setUIUnitList(SecurityUnit.listUnit(user_id, sys.getSys_id()));
			list.add(sys);
		}
		rs.close();
		st.close();
		conn.close();
		return list;	
	}
	
	public List<SecurityUnit> getUIUnitList() {
		return unitList;
	}
	public void setUIUnitList(List<SecurityUnit> unitList) {
		this.unitList = unitList;
	}
	public String getSys_id() {
		return sys_id;
	}
	public void setSys_id(String sys_id) {
		this.sys_id = sys_id;
	}
	public String getSys_name() {
		return sys_name;
	}
	public void setSys_name(String sys_name) {
		this.sys_name = sys_name;
	}
}