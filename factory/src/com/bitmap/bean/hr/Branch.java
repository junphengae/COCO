package com.bitmap.bean.hr;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;

import com.bitmap.dbconnection.mysql.vbi.*;
import com.bitmap.dbutils.DBUtility;

public class Branch {
	public static String tableName = "per_branch";
	private static String[] keys = {"branch_id"};
	
	private String branch_id = "";
	private String branch_name = "";
	private String branch_address = "";
	private String branch_gmap = "";
	private String create_by = "";
	private Timestamp date_create = null;
	private Timestamp date_update = null;
	
	public static String getUIName(String branch_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Branch branch = new Branch();
		branch.setBranch_id(branch_id);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, branch, keys);
		conn.close();
		return branch.getBranch_name();
	}
	
	public static Branch select(String branch_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Branch branch = new Branch();
		branch.setBranch_id(branch_id);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, branch, keys);
		conn.close();
		return branch;
	}
	
	public String getBranch_id() {
		return branch_id;
	}
	public void setBranch_id(String branch_id) {
		this.branch_id = branch_id;
	}
	public String getBranch_name() {
		return branch_name;
	}
	public void setBranch_name(String branch_name) {
		this.branch_name = branch_name;
	}
	public String getBranch_address() {
		return branch_address;
	}
	public void setBranch_address(String branch_address) {
		this.branch_address = branch_address;
	}
	public String getBranch_gmap() {
		return branch_gmap;
	}
	public void setBranch_gmap(String branch_gmap) {
		this.branch_gmap = branch_gmap;
	}
	public String getCreate_by() {
		return create_by;
	}
	public void setCreate_by(String create_by) {
		this.create_by = create_by;
	}
	public Timestamp getDate_create() {
		return date_create;
	}
	public void setDate_create(Timestamp date_create) {
		this.date_create = date_create;
	}
	public Timestamp getDate_update() {
		return date_update;
	}
	public void setDate_update(Timestamp date_update) {
		this.date_update = date_update;
	}
}
