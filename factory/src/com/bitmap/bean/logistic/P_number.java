package com.bitmap.bean.logistic;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.Calendar;

import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;

public class P_number {
	public static String tableName = "p_number" ;
	public static String[] keys = {"id_pnumber"} ;
	
	public static String[] fieldNames = {"id_pnumber","run_number"};
	
	String id_pnumber = "";
	String run_number = "";
	String create_by = "";
	Timestamp create_date = null;
	
	public String getId_pnumber() {
		return id_pnumber;
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
	public void setId_pnumber(String id_pnumber) {
		this.id_pnumber = id_pnumber;
	}
	public String getRun_number() {
		return run_number;
	}
	public void setRun_number(String run_number) {
		this.run_number = run_number;
	}

	public static void main(String[] s) throws SQLException, IllegalArgumentException, UnsupportedEncodingException, IllegalAccessException, InvocationTargetException{
		P_number entity = new P_number();
		insert(entity);
	}
	public static void insert(P_number entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		
		Calendar today = DBUtility.calendar();
		Calendar setTime = DBUtility.calendar();
		
		setTime.set(Calendar.HOUR_OF_DAY,14);
		setTime.set(Calendar.MINUTE,00);
		setTime.set(Calendar.SECOND,0);
		setTime.set(Calendar.MILLISECOND, 0);
		
		//System.out.println("time :" + DBUtility.getDateTimeValue(today.getTime()));
		//System.out.println("settime :" + DBUtility.getDateTimeValue(setTime.getTime()));
		
		
		if(today.after(setTime)){
			today.add(Calendar.DATE,+1);
			today.set(Calendar.HOUR_OF_DAY,9);
			today.set(Calendar.MINUTE,00);
			today.set(Calendar.SECOND,00);
			today.set(Calendar.MILLISECOND,00);
			//System.out.print("true :" + DBUtility.getDateValue(today.getTime()));
			
			Timestamp ts = new Timestamp(today.getTimeInMillis());
			entity.setCreate_date(ts);
			//System.out.print(ts);
		}else{
			//System.out.print("false :" + DBUtility.getDateValue(today.getTime()));
			entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		}
		
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}
	
	public static P_number select(P_number entity) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity,new String[]{"run_number"});
		conn.close();
		return entity;
	}
	
	
	/**
	 * Used : SalePrderItem.selectallitemByinvoice
	 * <br>
	 * check ว่ามีเลขinvoice นี้เป็น vat รึเปล่า
	 * @param run_number
	 * @return
	 * @throws SQLException
	 * @throws IllegalArgumentException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 */
	public static boolean checkhave(String run_number) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		String sql = "SELECT * FROM " + tableName + " WHERE run_number = '" + run_number + "'";
		
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);

		boolean check = false;
		while(rs.next()){
			check = true;
		}
		conn.close();
		return check;
	}
	
}
	
