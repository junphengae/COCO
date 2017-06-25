package com.bitmap.bean.hr;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Date;

import com.bitmap.dbconnection.mysql.vbi.*;
import com.bitmap.dbutils.DBUtility;

public class PersonalDetail {
	public static String tableName = "per_personal_detail";
	private static String[] keys = {"per_id"};
	private static String[] fieldDetail_insert = {"per_id","id_card","address","gmap","phone","birthdate","ref_phone","ref_name","create_by","date_create"};
	private static String[] fieldDetail_update = {"id_card","address","gmap","phone","birthdate","ref_phone","ref_name","create_by","date_update"};
	private static String[] fieldPerformance_insert = {"per_id","man_hour","acc_no","acc_branch","vac_total","sick_total","buss_total","create_by","date_create"};
	private static String[] fieldPerformance_update = {"man_hour","acc_no","acc_branch","vac_total","sick_total","buss_total","create_by","date_update"};
	
	private String per_id = "";
	private String id_card = "";
	private String address = "";
	private String gmap = "";
	private String phone = "";
	private Date birthdate = null;
	private String ref_name = "";
	private String ref_phone = "";
	private String man_hour = "";
	private String acc_no = "";
	private String acc_branch = "";
	private String vac_total = "2";
	private String sick_total = "30";
	private String buss_total = "5";
	private String create_by = "";
	private Timestamp date_create = null;
	private Timestamp date_update = null;
	
	public static PersonalDetail select(Connection conn, String per_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		PersonalDetail entity = new PersonalDetail();
		entity.setPer_id(per_id);
		
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		
		return entity;
	}
	
	public static PersonalDetail select(String per_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		PersonalDetail entity = new PersonalDetail();
		entity.setPer_id(per_id);
		
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	
	public static boolean check(Connection conn, String per_id) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		PersonalDetail entity = new PersonalDetail();
		entity.setPer_id(per_id);
		return DBUtility.getEntityFromDB(conn, tableName, entity, keys);
	}
	
	public static void insertDetail(PersonalDetail entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		if (check(conn, entity.getPer_id())) {
			updateDetail(entity);
		} else {
			entity.setDate_create(DBUtility.getDBCurrentDateTime());
			DBUtility.insertToDB(conn, tableName, fieldDetail_insert, entity);
		}
		conn.close();
	}
	
	public static void updateDetail(PersonalDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setDate_update(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldDetail_update, keys);
		conn.close();
	}
	
	public static void insertPerformance(PersonalDetail entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		if (check(conn, entity.getPer_id())) {
			updatePerformance(entity);
		} else {
			entity.setDate_create(DBUtility.getDBCurrentDateTime());
			DBUtility.insertToDB(conn, tableName, fieldPerformance_insert, entity);
		}
		conn.close();
	}
	
	public static void updatePerformance(PersonalDetail entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setDate_update(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity, fieldPerformance_update, keys);
		conn.close();
	}
	
	public static void delete(PersonalDetail entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.deleteFromDB(conn, tableName, entity, keys);
		conn.close();
	}
	
	public String getPer_id() {
		return per_id;
	}
	public void setPer_id(String per_id) {
		this.per_id = per_id;
	}
	public String getId_card() {
		return id_card;
	}
	public void setId_card(String id_card) {
		this.id_card = id_card;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getGmap() {
		return gmap;
	}
	public void setGmap(String gmap) {
		this.gmap = gmap;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public Date getBirthdate() {
		return birthdate;
	}
	public void setBirthdate(Date birthdate) {
		this.birthdate = birthdate;
	}
	public String getRef_name() {
		return ref_name;
	}
	public void setRef_name(String ref_name) {
		this.ref_name = ref_name;
	}
	public String getRef_phone() {
		return ref_phone;
	}
	public void setRef_phone(String ref_phone) {
		this.ref_phone = ref_phone;
	}
	public String getMan_hour() {
		return man_hour;
	}
	public void setMan_hour(String man_hour) {
		this.man_hour = man_hour;
	}
	public String getAcc_no() {
		return acc_no;
	}
	public void setAcc_no(String acc_no) {
		this.acc_no = acc_no;
	}
	public String getAcc_branch() {
		return acc_branch;
	}
	public void setAcc_branch(String acc_branch) {
		this.acc_branch = acc_branch;
	}
	public String getVac_total() {
		return vac_total;
	}
	public void setVac_total(String vac_total) {
		this.vac_total = vac_total;
	}
	public String getSick_total() {
		return sick_total;
	}
	public void setSick_total(String sick_total) {
		this.sick_total = sick_total;
	}
	public String getBuss_total() {
		return buss_total;
	}
	public void setBuss_total(String buss_total) {
		this.buss_total = buss_total;
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