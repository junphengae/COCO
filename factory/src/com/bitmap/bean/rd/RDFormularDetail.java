package com.bitmap.bean.rd;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import com.bitmap.bean.inventory.InventoryMaster;
import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;

public class RDFormularDetail {
	public static String tableName = "rd_formular_detail" ;
	public static String[] keys = {"material","mat_code","step"} ;
	public static String[] fieldNames = {"remark","qty","usage_","update_date","update_by"};
	
	
	private String detail_id = "";
	private String mat_code = "";
	private String step = "";
	private String remark = "";
	private String material = "";
	private String qty = "";
	private String usage_ = "";
	private String create_by = "";
	private Timestamp create_date = null ;
	private String update_by = "";
	private Timestamp update_date = null ;
	
	private InventoryMaster UIMat = new InventoryMaster();
	public InventoryMaster getUIMat() {return UIMat;}
	public void setUIMat(InventoryMaster uIMat) {UIMat = uIMat;}
	
	/**
	 * selectList
	 * @param mat_code
	 * @param step
	 * @return List<RDFormularDetail>
	 * @throws SQLException
	 * @throws UnsupportedEncodingException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static List<RDFormularDetail> selectList(String mat_code,String step, Connection conn) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE mat_code ='" + mat_code + "' AND step = '"+step+"' order by detail_id*1";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<RDFormularDetail> list = new ArrayList<RDFormularDetail>();
		while (rs.next()) {
			RDFormularDetail entity = new RDFormularDetail();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIMat(InventoryMaster.select(entity.getMaterial()));
			list.add(entity);
		}
		rs.close();
		st.close();
		return list;
	}
	
	public static List<RDFormularDetail> selectList(String mat_code,String step) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE mat_code ='" + mat_code + "' AND step = '"+step+"' order by detail_id*1";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<RDFormularDetail> list = new ArrayList<RDFormularDetail>();
		while (rs.next()) {
			RDFormularDetail entity = new RDFormularDetail();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIMat(InventoryMaster.select(entity.getMaterial()));
			list.add(entity);
		}
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	
	public static void clone(String old_mat_code, String mat_code,String step, String create_by, Connection conn) throws SQLException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE mat_code ='" + old_mat_code + "' AND step = '"+step+"' order by detail_id*1";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			RDFormularDetail entity = new RDFormularDetail();
			DBUtility.bindResultSet(entity, rs);
			
			entity.setMat_code(mat_code);
			entity.setCreate_by(create_by);
			entity.setCreate_date(DBUtility.getDBCurrentDateTime());
			entity.setUpdate_by("");
			entity.setUpdate_date(null);
			insert(entity);
		}
		rs.close();
		st.close();
	}
	
	public static void select(RDFormularDetail entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		entity.setUIMat(InventoryMaster.select(entity.getMaterial(), conn));
		
		conn.close();
	}
	
	/**
	 * calSumQtyByCondition mat_code
	 * @param mat_code
	 * @return int
	 * @throws SQLException
	 */
	public static float calSumQtyByCondition(String mat_code) throws SQLException{
		String sql = "select sum(qty*1) sum from rd_formular_detail where mat_code = '"+mat_code+"'";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		float sum = 0;
		if (rs.next()) {
			sum =  rs.getFloat("sum");
		}
		rs.close();
		st.close();
		conn.close();
		return sum;
	}
	
	/**
	 * calSumQtyByCondition mat_code,step,material_code
	 * @param mat_code
	 * @param step
	 * @param material_code
	 * @return int
	 * @throws SQLException
	 */
	public static float calSumQtyByCondition(String mat_code,String step,String material) throws SQLException{
		String sql = "select sum(qty*1) sum from rd_formular_detail where mat_code = '"+mat_code+"' and step !='"+step+"' and material !='"+material+"'";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		float sum = 0;
		if (rs.next()) {
			sum =  rs.getFloat("sum");
		}
		rs.close();
		st.close();
		conn.close();
		return sum;
	}
	
	
	/**
	 * 
	 * @param mat_code
	 * @param step
	 * @param material_code
	 * @return RDFormularDetail
	 * @throws IllegalArgumentException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static RDFormularDetail selectByCondition(String mat_code,String step,String material_code) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		RDFormularDetail entity = new RDFormularDetail();
		entity.setMat_code(mat_code);
		entity.setStep(step);
		entity.setMaterial(material_code);
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		conn.close();
		return entity;
	}
	
	
	/**
	 * insert
	 * @param entity
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static void insert(RDFormularDetail entity) throws SQLException, IllegalAccessException, InvocationTargetException {
		Connection conn = DBPool.getConnection();
		entity.setDetail_id(DBUtility.genNumberFromDB(conn, tableName, entity, new String[]{"mat_code","step"}, "detail_id"));
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	
	
	/**
	 * delete
	 * @param entity
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static void delete(RDFormularDetail entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();	
		DBUtility.deleteFromDB(conn, tableName, entity, new String[]{"step","mat_code","material"});
		conn.close();
	}
	
	public static void deleteAll(RDFormularDetail entity, Connection conn) throws SQLException, IllegalAccessException, InvocationTargetException{
		DBUtility.deleteFromDB(conn, tableName, entity, new String[]{"step","mat_code"});
	}
	
	/**
	 * update
	 * @param entity
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static void update(RDFormularDetail entity) throws SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();		
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());	
		DBUtility.updateToDB(conn, tableName, entity, fieldNames, keys);
		conn.close();	
	}
	
	/**
	 * whan : searcj4fg
	 * <br>
	 * ค้นหา mt ว่ามี FG ตัวไหนบ้างเป็นส่วนประกอบ	
	 * @param ctrl
	 * @param paramList
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static List<RDFormularDetail> SearchMtWithCTRL(PageControl ctrl,List<String[]> paramList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "select distinct(mat_code) from " + tableName + " where 1=1";	
		Iterator<String[]> ite = paramList.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {		
					sql += " AND " + str[0] + "='" + str[1] + "'";
			}
		}
		
		sql += " ORDER BY (mat_code*1) ASC";
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<RDFormularDetail> list = new ArrayList<RDFormularDetail>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					RDFormularDetail entity = new RDFormularDetail();
					DBUtility.bindResultSet(entity, rs);
					entity.setUIMat(InventoryMaster.select(entity.getMat_code(), conn));
					list.add(entity);					
				}
				cnt++;
			}
		}	
		rs.close();
		st.close();
		ctrl.setMin(min);
		ctrl.setMax(cnt);
		conn.close();
		return list;
	}

	public String getDetail_id() {
		return detail_id;
	}
	public void setDetail_id(String detail_id) {
		this.detail_id = detail_id;
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
	public String getMaterial() {
		return material;
	}
	public void setMaterial(String material) {
		this.material = material;
	}
	public String getQty() {
		return qty;
	}
	public void setQty(String qty) {
		this.qty = qty;
	}
	public String getUsage_() {
		return usage_;
	}
	public void setUsage_(String usage_) {
		this.usage_ = usage_;
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
}
