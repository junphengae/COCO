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
import java.util.Iterator;
import java.util.List;

import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;

public class PartLotControl {
	public static String tableName = "part_lot_control";
	private static String[] keys = {"job_id","lot_id"};
	private static String[] upDateField = {  "draw_qty",  "draw_price", "update_by", "update_date"};
//	private static String[] UpdateField = {"po"};

	String job_id = "";
	String lot_id = "";
	String pn = "";	
	String sn = "";
	String draw_qty = "";
	String draw_price = "";
	String draw_discount = "";

	String draw_by = "";
	Timestamp draw_date = null;
	String update_by = "";
	Timestamp update_date = null;
	
	String UIdescription = "";
	
	public static boolean checkPnInJob(String job_id, String pn) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		PartLotControl entity = new PartLotControl();
		entity.setJob_id(job_id);
		boolean hasPN = true;
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"job_id"});
		
			if ((entity.getPn()).trim().equalsIgnoreCase(pn.trim())) {
				hasPN = false;
			}
		conn.close();
		return hasPN;
	}
	
	
	public static void insert(PartLotControl entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		entity.setDraw_date(DBUtility.getDBCurrentDateTime());
		entity.setLot_id(genLotId(entity, conn));
		entity.setDraw_qty("1");
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	public static void select(PartLotControl entity , Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException {
		DBUtility.getEntityFromDB(conn, tableName, entity, new String[]{"job_id","pn"});
		
	}

	public static void update(PartLotControl entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		
		PartLotControl entityCheck = new PartLotControl();
		entityCheck.setJob_id(entity.getJob_id());
		entityCheck.setPn(entity.getPn());
		select(entityCheck, conn);
		
		entity.setDraw_qty((DBUtility.getInteger(entityCheck.getDraw_qty()) + 1) + "");
		////System.out.println("Draw : "+entity.getDraw_qty());
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName,entity, upDateField , new String[]{"job_id","pn"});
		
		conn.close();
	}
	
	private static String genLotId(PartLotControl entity, Connection conn) throws SQLException{
		String sql = "SELECT lot_id FROM " + tableName + " ORDER BY (lot_id*1) DESC";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		String lot_id = "1";
		if (rs.next()) {
			String temp = DBUtility.getString("lot_id", rs);
			lot_id = (Integer.parseInt(temp) + 1) + "";
		}
		
		rs.close();
		st.close();
		return lot_id;
	}
		

	public static String sumRecivePO(String po , String pn ) throws Exception{
		Connection conn = DBPool.getConnection();
		//conn.setAutoCommit(false);     ////  #####
		String sum = "0";
			String sql = "	SELECT SUM(lot_qty) as lot_qty FROM " + tableName + " WHERE po  = ? AND pn = ? AND status";
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
	public static String sumRecivePO(String po , String pn , Connection conn) throws Exception{
		
		//conn.setAutoCommit(false);     ////  #####
		String sum = "0";
			String sql = "	SELECT SUM(lot_qty) as lot_qty FROM " + tableName + " WHERE po  = ? AND pn = ? ";
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
	
public static List<PartLotControl> report(List<String[]> paramsList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		
		List<PartLotControl> list = new ArrayList<PartLotControl>();
		Connection conn = DBPool.getConnection();
		String sql = "SELECT con.job_id AS job_id,con.lot_id AS lot_id,con.pn AS pn,con.draw_qty AS draw_qty,con.draw_price AS draw_price,con.draw_discount AS draw_discount,con.draw_by AS draw_by,con.draw_date AS draw_date,con.update_by AS update_by,con.update_date AS update_date ,mas.description AS description FROM "+tableName +"  as con INNER JOIN pa_part_master AS mas ON mas.pn = con.pn WHERE 1=1 ";
		
		Iterator<String[]> ite = paramsList.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {

				if (str[0].equalsIgnoreCase("create_date")){
					
					sql +=" AND DATE_FORMAT(con.draw_date, '%Y-%m-%d')='"+str[1]+"' " ;
					
				} 
				else if (str[0].equalsIgnoreCase("year_month")){
					
					sql +=" AND DATE_FORMAT(con.draw_date, '%Y-%m')='"+str[1]+"' " ;
					
				} 
				else if (str[0].equalsIgnoreCase("date_send2")){
					
					sql +=" AND DATE_FORMAT(con.draw_date, '%Y-%m-%d') BETWEEN '"+str[1]+"' AND '"+str[2]+"' ";
					
				}
				
				else {
					
					sql += " AND con." + str[0].trim() + "='" + str[1] + "' ";
				}
			}
		}
		
		sql += " ORDER BY draw_date asc ";
		
		//System.out.println(sql);
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			
			
			PartLotControl entity = new PartLotControl();
			entity.setUIdescription(DBUtility.getString("description", rs));
			DBUtility.bindResultSet(entity, rs);
			
			
			
			list.add(entity);
			
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
	}
	
	
	
	
	public String getJob_id() {
		return job_id;
	}


	public void setJob_id(String job_id) {
		this.job_id = job_id;
	}


	public String getLot_id() {
		return lot_id;
	}


	public void setLot_id(String lot_id) {
		this.lot_id = lot_id;
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


	public String getDraw_qty() {
		return draw_qty;
	}


	public void setDraw_qty(String draw_qty) {
		this.draw_qty = draw_qty;
	}


	public String getDraw_price() {
		return draw_price;
	}


	public void setDraw_price(String draw_price) {
		this.draw_price = draw_price;
	}


	public String getDraw_by() {
		return draw_by;
	}


	public void setDraw_by(String draw_by) {
		this.draw_by = draw_by;
	}


	public Timestamp getDraw_date() {
		return draw_date;
	}


	public void setDraw_date(Timestamp draw_date) {
		this.draw_date = draw_date;
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


	public String getDraw_discount() {
		return draw_discount;
	}


	public void setDraw_discount(String draw_discount) {
		this.draw_discount = draw_discount;
	}


	public String getUIdescription() {
		return UIdescription;
	}


	public void setUIdescription(String uIdescription) {
		UIdescription = uIdescription;
	}

}