package com.bitmap.bean.inventory;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;

public class WithdrawType {
	public static String tableName = "inv_withdraw_type";
	public static String[] keys = {"type_code"};
	
	String type_code = "";
	String type_name = "";
	String create_by = "";
	Timestamp create_date = null;
	
	public static List<String[]> dropdown() throws SQLException{
		Connection conn = DBPool.getConnection();
		List<String[]> list = DBUtility.getDropDownList(conn, tableName, "type_code", "type_name", "type_name");
		conn.close();
		return list;
	}
	
	public String getType_code() {
		return type_code;
	}
	public void setType_code(String type_code) {
		this.type_code = type_code;
	}
	public String getType_name() {
		return type_name;
	}
	public void setType_name(String type_name) {
		this.type_name = type_name;
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
