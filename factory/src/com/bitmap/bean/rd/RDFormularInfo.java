package com.bitmap.bean.rd;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.SQLException;
import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;

public class RDFormularInfo {
	public static String tableName = "rd_formular_info" ;
	public static String[] keys = {"mat_code"};
	public static String[] fieldNames = {
		"solidity",
		"shade_l",
		"shade_a",
		"shade_b",
		"shade_e",
		"grain_size",
		"met_grain_size",
		"met_grain_size_unit",
		"met_volume",
		"met_volume_unit",
		"specific_gravity",
		"viscosity",
		"gloss",
		"thickness",
		"spray_pass",
		"spray_gun_model",
		"nozzle_no",
		"air_pressor",
		"filter_no",
		"plastic",
		"colour_plate",
		"life_time",
		"remark"
	};
	
	private String mat_code = "";
	private String solidity = "";
	private String shade_l = "";
	private String shade_a = "";
	private String shade_b = "";
	private String shade_e = "";
	private String grain_size = "";
	private String met_grain_size = "";
	private String met_grain_size_unit = "";
	private String met_volume = "";
	private String met_volume_unit = "";
	private String specific_gravity = "";
	private String viscosity = "";
	private String gloss = "";
	private String thickness = "";
	private String spray_pass = "";
	private String spray_gun_model = "";
	private String nozzle_no = "";
	private String air_pressor = "";
	private String filter_no = "";
	private String plastic = "";
	private String colour_plate = "";
	private String life_time = "";
	private String remark = "";
	
	public static void insert(String mat_code, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException{
		RDFormularInfo entity = new RDFormularInfo();
		entity.setMat_code(mat_code);
		DBUtility.insertToDB(conn, tableName, new String[]{"mat_code"}, entity);
	}
	
	public static void clone(String old_mat_code, String mat_code, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		RDFormularInfo info = select(old_mat_code, conn);
		
		info.setMat_code(mat_code);
		DBUtility.insertToDB(conn, tableName, info);
	}
	
	public static void update(RDFormularInfo entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();
	}
	
	public static RDFormularInfo select(String mat_code,Connection conn ) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		RDFormularInfo entity = new RDFormularInfo();
		entity.setMat_code(mat_code);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		return entity;
	}
	
	public String getMat_code() {
		return mat_code;
	}
	public void setMat_code(String mat_code) {
		this.mat_code = mat_code;
	}
	public String getSolidity() {
		return solidity;
	}
	public void setSolidity(String solidity) {
		this.solidity = solidity;
	}
	public String getShade_l() {
		return shade_l;
	}
	public void setShade_l(String shade_l) {
		this.shade_l = shade_l;
	}
	public String getShade_a() {
		return shade_a;
	}
	public void setShade_a(String shade_a) {
		this.shade_a = shade_a;
	}
	public String getShade_b() {
		return shade_b;
	}
	public void setShade_b(String shade_b) {
		this.shade_b = shade_b;
	}
	public String getShade_e() {
		return shade_e;
	}
	public void setShade_e(String shade_e) {
		this.shade_e = shade_e;
	}
	public String getGrain_size() {
		return grain_size;
	}
	public void setGrain_size(String grain_size) {
		this.grain_size = grain_size;
	}
	public String getMet_grain_size() {
		return met_grain_size;
	}
	public void setMet_grain_size(String met_grain_size) {
		this.met_grain_size = met_grain_size;
	}
	public String getMet_grain_size_unit() {
		return met_grain_size_unit;
	}
	public void setMet_grain_size_unit(String met_grain_size_unit) {
		this.met_grain_size_unit = met_grain_size_unit;
	}
	public String getMet_volume() {
		return met_volume;
	}
	public void setMet_volume(String met_volume) {
		this.met_volume = met_volume;
	}
	public String getMet_volume_unit() {
		return met_volume_unit;
	}
	public void setMet_volume_unit(String met_volume_unit) {
		this.met_volume_unit = met_volume_unit;
	}
	public String getSpecific_gravity() {
		return specific_gravity;
	}
	public void setSpecific_gravity(String specific_gravity) {
		this.specific_gravity = specific_gravity;
	}
	public String getViscosity() {
		return viscosity;
	}
	public void setViscosity(String viscosity) {
		this.viscosity = viscosity;
	}
	public String getGloss() {
		return gloss;
	}
	public void setGloss(String gloss) {
		this.gloss = gloss;
	}
	public String getThickness() {
		return thickness;
	}
	public void setThickness(String thickness) {
		this.thickness = thickness;
	}
	public String getSpray_pass() {
		return spray_pass;
	}
	public void setSpray_pass(String spray_pass) {
		this.spray_pass = spray_pass;
	}
	public String getSpray_gun_model() {
		return spray_gun_model;
	}
	public void setSpray_gun_model(String spray_gun_model) {
		this.spray_gun_model = spray_gun_model;
	}
	public String getNozzle_no() {
		return nozzle_no;
	}
	public void setNozzle_no(String nozzle_no) {
		this.nozzle_no = nozzle_no;
	}
	public String getAir_pressor() {
		return air_pressor;
	}
	public void setAir_pressor(String air_pressor) {
		this.air_pressor = air_pressor;
	}
	public String getFilter_no() {
		return filter_no;
	}
	public void setFilter_no(String filter_no) {
		this.filter_no = filter_no;
	}
	public String getPlastic() {
		return plastic;
	}
	public void setPlastic(String plastic) {
		this.plastic = plastic;
	}
	public String getColour_plate() {
		return colour_plate;
	}
	public void setColour_plate(String colour_plate) {
		this.colour_plate = colour_plate;
	}
	public String getLife_time() {
		return life_time;
	}
	public void setLife_time(String life_time) {
		this.life_time = life_time;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
}