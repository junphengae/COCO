package com.bitmap.bean.logistic;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.Calendar;

import com.bitmap.bean.inventory.InventoryMaster;
import com.bitmap.bean.sale.SaleOrderItem;
import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;

public class N_number {
	public static String tableName = "n_number" ;
	public static String[] keys = {"id_nnumber"} ;
	
	public static String[] fieldNames = {"id_nnumber","run_number"};
	
	String id_nnumber = "";
	String run_number = "";
	String create_by = "";
	Timestamp create_date = null;

	public String getId_nnumber() {
		return id_nnumber;
	}

	public void setId_nnumber(String id_nnumber) {
		this.id_nnumber = id_nnumber;
	}

	public String getRun_number() {
		return run_number;
	}

	public void setRun_number(String run_number) {
		this.run_number = run_number;
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

	public static N_number select(N_number entity) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity,new String[]{"run_number"});
		conn.close();
		return entity;
	}
	
	public static void insert(N_number entity) throws IllegalAccessException, InvocationTargetException, SQLException{
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
