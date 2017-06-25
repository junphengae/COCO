package com.bitmap.bean.logistic;

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
import com.bitmap.bean.production.Production;
import com.bitmap.bean.rd.MatTree;
import com.bitmap.bean.rd.RDFormular;
import com.bitmap.bean.sale.Package;
import com.bitmap.bean.sale.SaleOrder;
import com.bitmap.bean.sale.SaleOrderItem;
import com.bitmap.bean.sale.SaleOrderItemMat;
import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.utils.Money;
import com.bitmap.webutils.PageControl;

public class ProduceItemMat {
	public static String tableName = "produce_item_mat";
	private static String[] keys = {"pro_id","run"};
		static String[] fieldNames = {"pro_id","item_type","mat_code","qty","type"};
	
	String pro_id = "";
	String run = "1";
	String item_type = "";
	String mat_code = "";
	String qty = "";
	String type = "";
	Timestamp create_date = null;

	Production UIpro = new Production();
	RDFormular UIRd = new RDFormular();
	InventoryMaster UIMat = new InventoryMaster();
	
	ReportMat2PD UIRe = new ReportMat2PD();
	
	
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public ReportMat2PD getUIRe() {
		return UIRe;
	}
	public void setUIRe(ReportMat2PD uIRe) {
		UIRe = uIRe;
	}
	public RDFormular getUIRd() {
		return UIRd;
	}
	public void setUIRd(RDFormular uIRd) {
		UIRd = uIRd;
	}
	public InventoryMaster getUIMat() {
		return UIMat;
	}
	public void setUIMat(InventoryMaster uIMat) {
		UIMat = uIMat;
	}
	public Production getUIpro() {
		return UIpro;
	}
	public void setUIpro(Production uIpro) {
		UIpro = uIpro;
	}

	public String getItem_type() {
		return item_type;
	}
	public void setItem_type(String item_type) {
		this.item_type = item_type;
	}
	public String getPro_id() {
		return pro_id;
	}
	public void setPro_id(String pro_id) {
		this.pro_id = pro_id;
	}
	public String getRun() {
		return run;
	}
	public void setRun(String run) {
		this.run = run;
	}
	public String getMat_code() {
		return mat_code;
	}
	public void setMat_code(String mat_code) {
		this.mat_code = mat_code;
	}
	public String getQty() {
		return qty;
	}
	public void setQty(String qty) {
		this.qty = qty;
	}
	public Timestamp getCreate_date() {
		return create_date;
	}
	public void setCreate_date(Timestamp create_date) {
		this.create_date = create_date;
	}
		
	public static void delete(String pro_id) throws IllegalAccessException, InvocationTargetException, SQLException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection(); 	
		ProduceItemMat entity = new ProduceItemMat();
		entity.setPro_id(pro_id);
		DBUtility.deleteFromDB(conn, tableName, entity,new String[]{"pro_id"});	
		conn.close();
	}
	
	public static List<ProduceItemMat> selectlist(List<String[]> paramList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE 1=1";	
		Iterator<String[]> ite = paramList.iterator();
		String item_run = "";
		
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if(str[0].equalsIgnoreCase("item_run")){
					item_run = str[1];
				}else {
					sql += " AND " + str[0] + "='" + str[1] + "'";
				}
			}
		}

		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<ProduceItemMat> list = new ArrayList<ProduceItemMat>();
		
		while (rs.next()) {
			ProduceItemMat entity = new ProduceItemMat();
			DBUtility.bindResultSet(entity, rs);
			entity.setUIMat(InventoryMaster.select(entity.getMat_code(), conn));		
			list.add(entity);
		}
		st.close();
		rs.close();
		conn.close();
		return list;
	}
	
	public static ProduceItemMat selectVal(String mat_code,String pro_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT * FROM " + tableName + " WHERE mat_code = '" + mat_code + "' AND pro_id = '" + pro_id + "'";	
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);

		ProduceItemMat entity = new ProduceItemMat();
		while (rs.next()) {	
			DBUtility.bindResultSet(entity, rs);
			entity.setUIMat(InventoryMaster.select(entity.getMat_code(), conn));		
		}
		st.close();
		rs.close();
		conn.close();
		return entity;
	}
	
	public static void insert(MatTree tree,String pro_id,String volume,String status) throws IllegalAccessException, InvocationTargetException, SQLException, IllegalArgumentException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		ProduceItemMat itemMat = new ProduceItemMat();
		itemMat.setPro_id(pro_id);
		itemMat.setRun(DBUtility.genNumber(conn, tableName, "run"));
		itemMat.setItem_type(tree.getGroup_id());
		itemMat.setMat_code(tree.getMat_code());
		itemMat.setQty(tree.getOrder_qty());	
		itemMat.setType(status);	
		itemMat.setCreate_date(DBUtility.getDBCurrentDateTime());
		
		DBUtility.insertToDB(conn, tableName,itemMat);
		conn.close();
	}
	
	public static String selectType(String pro_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT type FROM " + tableName + " WHERE pro_id = '" + pro_id + "'";	
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);

		String type = "";
		if(rs.next()) {	
			type = DBUtility.getString("type", rs);
		}
		st.close();
		rs.close();
		conn.close();
		return type;
	}
	/**
	 * whan : report_review
	 * <br>
	 * (report_mt)เลือก mt อย่างเดียว  
	 * @param paramList
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static List<ProduceItemMat> selectPD() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT " + tableName + ".*,SUM(qty) as sum FROM " + tableName + " WHERE type = '10' and item_type = 'MT' GROUP BY mat_code";	

		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<ProduceItemMat> list = new ArrayList<ProduceItemMat>();
		
		while (rs.next()) {
			ProduceItemMat entity = new ProduceItemMat();
			DBUtility.bindResultSet(entity, rs);
			entity.setQty(DBUtility.getString("sum", rs));
			entity.setUIMat(InventoryMaster.select(entity.getMat_code(), conn));		
			list.add(entity);
		}
		st.close();
		rs.close();
		conn.close();
		return list;
	}
	/**
	 * whan : report_review
	 * <br>
	 * (report_pk)เลือกบรรจุภัณฑ์อย่างเดียว 
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static List<ProduceItemMat> selectPK() throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT " + tableName + ".*,SUM(qty) as sum FROM " + tableName + " WHERE type = '10' and item_type = 'PK' GROUP BY mat_code";	

		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<ProduceItemMat> list = new ArrayList<ProduceItemMat>();
		
		while (rs.next()) {
			ProduceItemMat entity = new ProduceItemMat();
			DBUtility.bindResultSet(entity, rs);
			entity.setQty(DBUtility.getString("sum", rs));
			entity.setUIMat(InventoryMaster.select(entity.getMat_code(), conn));		
			list.add(entity);
		}
		st.close();
		rs.close();
		conn.close();
		return list;
	}

}
