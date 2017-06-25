package com.bitmap.bean.parts;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;

public class PartLot {
	public static String tableName = "part_lot";
	private static String[] keys = {"lot_no"};
	
	String lot_no = "";
	String id = "";
	String pn = "";	
	String sn = "";
	String po = "";
	String invoice = "";
	String lot_qty = "";
	String lot_price = "";
	String lot_status = "";
	Date lot_expire = null;
	String note = "";
	String create_by = "";
	Timestamp create_date = null;
	String update_by = "";
	Timestamp update_date = null;
	String UIdescription = "";
	String UIreceive = "";
	
	
	public String getUIreceive() {
		return UIreceive;
	}
	public void setUIreceive(String uIreceive) {
		UIreceive = uIreceive;
	}
	public String getUIdescription() {
		return UIdescription;
	}
	public void setUIdescription(String uIdescription) {
		UIdescription = uIdescription;
	}
	public String getLot_no() {
		return lot_no;
	}
	public void setLot_no(String lot_no) {
		this.lot_no = lot_no;
	}
	public String getPn() {
		return pn;
	}
	public void setPn(String pn) {
		this.pn = pn;
	}
	public String getSn() {
		return sn;
	}
	public void setSn(String sn) {
		this.sn = sn;
	}
	public String getPo() {
		return po;
	}
	public void setPo(String po) {
		this.po = po;
	}
	public String getInvoice() {
		return invoice;
	}
	public void setInvoice(String invoice) {
		this.invoice = invoice;
	}
	public String getLot_qty() {
		return lot_qty;
	}
	public void setLot_qty(String lot_qty) {
		this.lot_qty = lot_qty;
	}
	public String getLot_price() {
		return lot_price;
	}
	public void setLot_price(String lot_price) {
		this.lot_price = lot_price;
	}
	public String getLot_status() {
		return lot_status;
	}
	public void setLot_status(String lot_status) {
		this.lot_status = lot_status;
	}
	public Date getLot_expire() {
		return lot_expire;
	}
	public void setLot_expire(Date lot_expire) {
		this.lot_expire = lot_expire;
	}
	public String getNote() {
		return note;
	}
	public void setNote(String note) {
		this.note = note;
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

	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	
	/**
	 * Insert log 
	 * @param entity
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws SQLException
	 */
	public static void insert(PartLot entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		entity.setLot_no(genLotNo(entity, conn));
		entity.setLot_status("A");
		DBUtility.insertToDB(conn, tableName, entity);
		//InventoryLotControl.initLot(entity, conn);
		conn.close();
	}
	
	
	private static String genLotNo(PartLot entity, Connection conn) throws SQLException{
		String sql = "SELECT lot_no FROM " + tableName + " ORDER BY (lot_no*1) DESC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		String lot_no = "1";
		if (rs.next()) {
			String temp = DBUtility.getString("lot_no", rs);
			lot_no = (Integer.parseInt(temp) + 1) + "";
		}
		
		rs.close();
		st.close();
		return lot_no;
	}
		

	public static String sumRecivePO(String po , String pn ) throws Exception{
		Connection conn = DBPool.getConnection();
		//conn.setAutoCommit(false);     ////  #####
		String sum = "0";
			String sql = "	SELECT SUM(lot_qty) as lot_qty FROM " + tableName + " WHERE po  = ? AND pn = ?";
			//String sql = "SELECT  po, SUM(order_qty) AS order_qty FROM " + tableName + " WHERE po = ? GROUP BY po"; // ตัวอย่างการใช้ Object Bean
			//System.out.println("SQL : "+sql	);
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, po);
			ps.setString(2, pn);
			ResultSet rs = ps.executeQuery();
			//PurchaseRequest entity = new PurchaseRequest();
			if (rs.next()) {
				sum = DBUtility.getString("lot_qty", rs);
				//DBUtility.bindResultSet(entity, rs);
			}
			rs.close();
			ps.close();
			//conn.commit(); //#####
		
		return sum;
	}
	/**
	 * @throws SQLException ******************************************************************************************/
	public static String SUMPORecive( String po,String pn ) throws SQLException {
		Connection conn = null;
		String sum = "0";
		try {
			conn = DBPool.getConnection();
			sum = SUNPO(conn, po.trim(), pn.trim());
			conn.close();
			
		} catch (Exception e) {
			if (conn != null) {
				conn.close();
			}
		}
		return sum;
		
	}
	public static String SUNPO( Connection conn,String po,String pn) throws SQLException{
		String sum = "0";
		String sql = "	SELECT SUM(lot_qty) as lot_qty FROM " + tableName + " WHERE po  = ? AND pn = ?";		
		//System.out.println("SQL : "+sql	);
		PreparedStatement ps = conn.prepareStatement(sql);
		ps.setString(1, po);
		ps.setString(2, pn);
		ResultSet rs = ps.executeQuery();
		
		if (rs.next()) {
			sum = DBUtility.getString("lot_qty", rs);
			if (sum.equalsIgnoreCase("")) {
				sum = "0";
			}
			//System.out.println("SUM : "+sum);
			
		}
		rs.close();
		ps.close();
		
	    return sum;
		
	}
	
	
	
	/********************************************************************************************/	
	public static String sumRecivePO(String po , String pn , Connection conn) throws Exception{
		
		//conn.setAutoCommit(false);     ////  #####
		String sum = "0";
			String sql = "	SELECT SUM(lot_qty) as lot_qty FROM " + tableName + " WHERE po  = ? AND pn = ?";
			//String sql = "SELECT  po, SUM(order_qty) AS order_qty FROM " + tableName + " WHERE po = ? GROUP BY po"; // ตัวอย่างการใช้ Object Bean
		//	//System.out.println("SQL : "+sql	);
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, po);
			ps.setString(2, pn);
			ResultSet rs = ps.executeQuery();
			//PurchaseRequest entity = new PurchaseRequest();
			if (rs.next()) {
				sum = DBUtility.getString("lot_qty", rs);
				//DBUtility.bindResultSet(entity, rs);
			}
			rs.close();
			ps.close();
			//conn.commit(); //#####
		
		return sum;
	}

	public static String sumRecivePR(String po , String pn , String id , Connection conn) throws Exception{
		
		//conn.setAutoCommit(false);     
			String sum = "0";
			String sql = "	SELECT SUM(lot_qty) as lot_qty FROM " + tableName + " WHERE po  = ? AND pn = ? AND id = ?";
			//String sql = "SELECT  po, SUM(order_qty) AS order_qty FROM " + tableName + " WHERE po = ? GROUP BY po"; // ตัวอย่างการใช้ Object Bean
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, po);
			ps.setString(2, pn);
			ps.setString(3, id);
			ResultSet rs = ps.executeQuery();
			//PurchaseRequest entity = new PurchaseRequest();
			if (rs.next()) {
				sum = DBUtility.getString("lot_qty", rs);
				//DBUtility.bindResultSet(entity, rs);
			}
			rs.close();
			ps.close();
			//conn.commit(); 
		
		return sum;
	}
public static List<PartLot> report_add(List<String[]> paramsList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException
{
		
		List<PartLot> list = new ArrayList<PartLot>();
		Connection conn = DBPool.getConnection();
		String sql = "SELECT " ; 
			sql +=" lot.id AS id,";
			sql +=" lot.lot_price AS lot_price,";
			sql +=" lot.pn AS pn,";
			sql +=" lot.lot_no AS lot_no,";
			sql +=" lot.po AS po,";
			sql +=" lot.sn AS sn,";
			sql +=" lot.invoice AS invoice,";
			sql +=" lot.lot_qty AS lot_qty,";
			sql +=" lot.lot_status AS lot_status,";
			sql +=" lot.lot_expire AS lot_expire,";
			sql +=" lot.icp_data AS icp_data,";
			sql +=" lot.note AS note,";
			sql +=" lot.create_by AS create_by,";
			sql +=" lot.create_date AS create_date,";
			sql +=" pa.description AS description,";	
			sql +=" per.name AS receive";	
			sql +=" FROM "+tableName +" AS lot " ; 
			sql +=" INNER JOIN pa_part_master AS pa ON lot.pn = pa.pn";
			sql +=" INNER JOIN per_personal AS per ON  per.per_id = lot.create_by";
			sql +=" WHERE 1=1 ";
		
		Iterator<String[]> ite = paramsList.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {

				if (str[0].equalsIgnoreCase("create_date")){
					
					sql +=" AND DATE_FORMAT(lot.create_date, '%Y-%m-%d')='"+str[1]+"' " ;
					
				} 
				else if (str[0].equalsIgnoreCase("year_month")){
					
					sql +=" AND DATE_FORMAT(lot.create_date, '%Y-%m')='"+str[1]+"' " ;
					
				} 
				else if (str[0].equalsIgnoreCase("date_send2")){
					
					sql +=" AND DATE_FORMAT(lot.create_date, '%Y-%m-%d') BETWEEN '"+str[1]+"' AND '"+str[2]+"' ";
					
				}
				
				else {
					
					sql += " AND lot." + str[0] + "='" + str[1] + "' ";
				}
			}
		}
		
		sql += " ORDER BY (lot.lot_no*1) ASC ";
		
		//System.out.println("LOT:::"+sql);
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			PartLot entity = new PartLot();
			entity.setUIdescription(DBUtility.getString("description", rs));
			entity.setUIreceive(DBUtility.getString("receive", rs));
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}


	public static void insertlogEdit(PartLot entity) throws SQLException, Exception, InvocationTargetException {
		// TODO New 17-03-2557
		Connection conn = DBPool.getConnection();
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		entity.setLot_no(genLotNo(entity, conn));
		entity.setLot_status("C");
		DBUtility.insertToDB(conn, tableName, entity);		
		conn.close();
		
	}


	
}