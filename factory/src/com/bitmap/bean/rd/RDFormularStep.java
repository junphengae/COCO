package com.bitmap.bean.rd;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.bitmap.bean.util.StatusUtil;
import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;

public class RDFormularStep {
	public static String tableName = "rd_formular_step" ;
	
	public static String[] keys = {"step","mat_code"} ;
	public static String[] fieldNames = {"process","machine","remark","update_by","update_date",
										 "met_grain_size_start","met_grain_size_to","met_grain_size_unit",
										 "met_volume_start","met_volume_to","met_volume_unit",
										 "speed_start","speed_to","speed_unitt",
										 "temp_start","temp_to","temp_unit",
										 "time_start","time_to","time_unit",
										 "deviation","fillter",
										 "stickiness","pressure_wind","pressure_color","interval_","spray_cyc"};
	
	private String mat_code = "";
	private String step = "";
	private String step_order = "";
	private String remark = "";
	private String process = "";
	private String machine = "";
	private String time_start = "";
	private String time_to = "";
	private String time_unit = "";
	private String speed_start = "";
	private String speed_to = "";
	private String speed_unit = "";
	private String met_grain_size_start = "";
	private String met_grain_size_to = "";
	private String met_grain_size_unit = "";
	private String met_volume_start = "";
	private String met_volume_to = "";
	private String met_volume_unit = "";
	private String temp_start = "";
	private String temp_to = "";
	private String temp_unit = "";
	
	private String deviation = "";
	private String fillter = "";
	private String stickiness = "";
	private String pressure_wind = "";
	private String pressure_color = "";
	private String interval_ = "";
	private String spray_cyc = "";
	
	private String status = "";
	private String create_by = "";
  	private Timestamp create_date = null;
  	private String update_by = "";
  	private Timestamp update_date = null;
  	
	private List<RDFormularDetail> UIDetail = new ArrayList<RDFormularDetail>();
	public List<RDFormularDetail> getUIDetail() {return UIDetail;}
	public void setUIDetail(List<RDFormularDetail> uIDetail) {UIDetail = uIDetail;}
	
	public static String step(String step){
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("Weighing","Weighing / การชั่ง");
		map.put("Stiring","Stiring / การปั่นผสม");
		map.put("Grinding","Grinding / การบด");
		map.put("Letdown","Letdown / การเลทดาล์ว");
		map.put("Adjust","Adjust / การเติมแต่ง");
		map.put("Mixing Spray","Mixing Spray / การผสมพ่น");
		map.put("Baking","Baking / การอบ");
		map.put("Quality check","Quality check / การตรวจสอบ");
		map.put("Fillter","Fillter / การกรอง");
		map.put("Packing","Packing / การบรรจุ");
		map.put("Label","Label / การติดฉลาก");
		map.put("Keepstock","Keepstock / การจัดเก็บ");
		map.put("Cleaning","Cleaning / การล้าง");
		
		return map.get(step);
	}
	
	private static List<String[]> UITime = new ArrayList<String[]>();
	public static List<String[]> getUITime() {
		UITime = new ArrayList<String[]>();
		for (int i = 0; i < 60; i++) {
			String[] ui = {""+(i+1),""+(i+1)};
			UITime.add(ui);
		}
		return UITime;
	}
	
	private static List<String[]> UITimeUnit = new ArrayList<String[]>();
	public static List<String[]> getUITimeUnit() {
		UITimeUnit = new ArrayList<String[]>();
		UITimeUnit.add(new String[]{"second","second"});
		UITimeUnit.add(new String[]{"min","min"});
		UITimeUnit.add(new String[]{"hour","hour"});
		UITimeUnit.add(new String[]{"day","day"});
		return UITimeUnit;
	}
	
	public static String selectStepNo(String mat_code) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		RDFormularStep entity = new RDFormularStep();
		entity.setMat_code(mat_code);
		String stepNo = DBUtility.genNumberFromDB(conn, tableName, entity, new String[]{"mat_code"}, "step");
		
		conn.close();
		return stepNo;
	}
	
	public static void delete(RDFormularStep entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();	
		DBUtility.deleteFromDB(conn, tableName, entity, new String[]{"mat_code","step"});
		
		RDFormularDetail detail = new RDFormularDetail();
		detail.setMat_code(entity.getMat_code());
		detail.setStep(entity.getStep());
		RDFormularDetail.deleteAll(detail, conn);
		conn.close();
	}
	
	public static List<RDFormularStep> selectList(String mat_code, Connection conn) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE mat_code ='" + mat_code + "' order by (step_order*1)";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<RDFormularStep> list = new ArrayList<RDFormularStep>();
		while (rs.next()) {
			RDFormularStep entity = new RDFormularStep();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIDetail(RDFormularDetail.selectList(mat_code, entity.getStep()));
			list.add(entity);
		}
		rs.close();
		st.close();
		return list;
	}
	
	public static void clone(String old_mat_code, String mat_code, String create_by, Connection conn) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE mat_code ='" + old_mat_code + "' order by step*1";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			RDFormularStep entity = new RDFormularStep();
			DBUtility.bindResultSet(entity, rs);
			
			entity.setMat_code(mat_code);
			entity.setCreate_by(create_by);
			entity.setCreate_date(DBUtility.getDBCurrentDateTime());
			entity.setUpdate_by("");
			entity.setUpdate_date(null);
			insert(entity);
			
			RDFormularDetail.clone(old_mat_code, mat_code, entity.getStep(), create_by, conn);
		}
		rs.close();
		st.close();
	}
	
	/**
	 * select By Condition 
	 * mat_code and step
	 * @param mat_code
	 * @param step
	 * @return
	 * @throws IllegalArgumentException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static RDFormularStep selectByCondition(String mat_code,String step) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		RDFormularStep entity = new RDFormularStep();
		entity.setMat_code(mat_code);
		entity.setStep(step);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	
	
	/**
	 * 
	 * @param entity
	 * @return boolean
	 * @throws IllegalArgumentException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static boolean select(RDFormularStep entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		boolean has = DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"mat_code"});
		conn.close();
		return has;
	}
	
	public static void insert(RDFormularStep entity) throws SQLException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		entity.setStatus(StatusUtil.ACTIVE);
		entity.setStep_order(entity.getStep());
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	public static void update(RDFormularStep entity) throws SQLException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		entity.setStatus(StatusUtil.ACTIVE);
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());	
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();				
	}
	
	public static void updateStepOrder(RDFormularStep entity, String[] order) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		
		for (int i = 0; i < order.length; i++) {
			RDFormularStep fStep = new RDFormularStep();
			fStep.setMat_code(entity.getMat_code());
			fStep.setStep(order[i]);
			fStep.setStep_order((i+1) + "");
			DBUtility.updateToDB(conn, tableName, fStep, new String[]{"step_order"}, keys);
		}
		
		conn.close();
	}
	
	public static String selectStepPK(String mat_code) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT step FROM " + tableName + " WHERE mat_code ='" + mat_code + "' AND process = 'Packing'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		String a = "";
		while (rs.next()) {
			a = rs.getString("step");
		}
		rs.close();
		st.close();
		conn.close();
		return a;
	}
	
	public String getMat_code() {
		return mat_code;
	}
	public void setMat_code(String mat_code) {
		this.mat_code = mat_code;
	}
	public String getStep() {
		return step;
	}
	public void setStep(String step) {
		this.step = step;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getProcess() {
		return process;
	}
	public void setProcess(String process) {
		this.process = process;
	}
	public String getMachine() {
		return machine;
	}
	public void setMachine(String machine) {
		this.machine = machine;
	}
	public String getTime_start() {
		return time_start;
	}
	public void setTime_start(String time_start) {
		this.time_start = time_start;
	}
	public String getTime_to() {
		return time_to;
	}
	public void setTime_to(String time_to) {
		this.time_to = time_to;
	}
	public String getTime_unit() {
		return time_unit;
	}
	public void setTime_unit(String time_unit) {
		this.time_unit = time_unit;
	}
	public String getSpeed_start() {
		return speed_start;
	}
	public void setSpeed_start(String speed_start) {
		this.speed_start = speed_start;
	}
	public String getSpeed_to() {
		return speed_to;
	}
	public void setSpeed_to(String speed_to) {
		this.speed_to = speed_to;
	}
	public String getSpeed_unit() {
		return speed_unit;
	}
	public void setSpeed_unit(String speed_unit) {
		this.speed_unit = speed_unit;
	}
	public String getMet_grain_size_start() {
		return met_grain_size_start;
	}
	public void setMet_grain_size_start(String met_grain_size_start) {
		this.met_grain_size_start = met_grain_size_start;
	}
	public String getMet_grain_size_to() {
		return met_grain_size_to;
	}
	public void setMet_grain_size_to(String met_grain_size_to) {
		this.met_grain_size_to = met_grain_size_to;
	}
	public String getMet_grain_size_unit() {
		return met_grain_size_unit;
	}
	public void setMet_grain_size_unit(String met_grain_size_unit) {
		this.met_grain_size_unit = met_grain_size_unit;
	}
	public String getMet_volume_start() {
		return met_volume_start;
	}
	public void setMet_volume_start(String met_volume_start) {
		this.met_volume_start = met_volume_start;
	}
	public String getMet_volume_to() {
		return met_volume_to;
	}
	public void setMet_volume_to(String met_volume_to) {
		this.met_volume_to = met_volume_to;
	}
	public String getMet_volume_unit() {
		return met_volume_unit;
	}
	public void setMet_volume_unit(String met_volume_unit) {
		this.met_volume_unit = met_volume_unit;
	}
	public String getTemp_start() {
		return temp_start;
	}
	public void setTemp_start(String temp_start) {
		this.temp_start = temp_start;
	}
	public String getTemp_to() {
		return temp_to;
	}
	public void setTemp_to(String temp_to) {
		this.temp_to = temp_to;
	}
	public String getTemp_unit() {
		return temp_unit;
	}
	public void setTemp_unit(String temp_unit) {
		this.temp_unit = temp_unit;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
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
	public String getUpdate_by() {
		return update_by;
	}
	public void setUpdate_by(String update_by) {
		this.update_by = update_by;
	}
	public Timestamp getUpdate_date() {
		return update_date;
	}
	public void setUpdate_date(Timestamp update_date) {
		this.update_date = update_date;
	}
	public String getDeviation() {
		return deviation;
	}
	public void setDeviation(String deviation) {
		this.deviation = deviation;
	}
	public String getFillter() {
		return fillter;
	}
	public void setFillter(String fillter) {
		this.fillter = fillter;
	}
	public String getStickiness() {
		return stickiness;
	}
	public void setStickiness(String stickiness) {
		this.stickiness = stickiness;
	}
	public String getPressure_wind() {
		return pressure_wind;
	}
	public void setPressure_wind(String pressure_wind) {
		this.pressure_wind = pressure_wind;
	}
	public String getPressure_color() {
		return pressure_color;
	}
	public void setPressure_color(String pressure_color) {
		this.pressure_color = pressure_color;
	}
	public String getInterval_() {
		return interval_;
	}
	public void setInterval_(String interval_) {
		this.interval_ = interval_;
	}
	public String getSpray_cyc() {
		return spray_cyc;
	}
	public void setSpray_cyc(String spray_cyc) {
		this.spray_cyc = spray_cyc;
	}
	public String getStep_order() {
		return step_order;
	}
	public void setStep_order(String step_order) {
		this.step_order = step_order;
	}
}