package com.bitmap.bean.sale;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.bitmap.bean.rd.MatTree;
import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.utils.Money;

public class SaleOrderItemMat {
	public static String tableName = "sale_order_item_mat";
	private static String[] keys = {"order_id","item_id","mat_code","fg","item_run","run"};
		static String[] fieldNames = {"order_id","item_id","fg","mat_code","qty","flag","qty_production"};
	
	String order_id = "";
	String item_run = "";
	String run = "1";
	String item_id = "";
	String fg = "";
	String mat_code = "";
	String qty = "";
	String flag = "";
	String qty_production = "";
	
	
	public String getRun() {
		return run;
	}
	public void setRun(String run) {
		this.run = run;
	}
	public String getItem_run() {
		return item_run;
	}
	public void setItem_run(String item_run) {
		this.item_run = item_run;
	}
	public String getFlag() {
		return flag;
	}
	public void setFlag(String flag) {
		this.flag = flag;
	}
	public String getQty_production() {
		return qty_production;
	}
	public void setQty_production(String qty_production) {
		this.qty_production = qty_production;
	}
	public String getFg() {
		return fg;
	}
	public void setFg(String fg) {
		this.fg = fg;
	}
	public String getOrder_id() {
		return order_id;
	}
	public void setOrder_id(String order_id) {
		this.order_id = order_id;
	}
	public String getItem_id() {
		return item_id;
	}
	public void setItem_id(String item_id) {
		this.item_id = item_id;
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
	
	public static SaleOrderItemMat selectByMat(SaleOrderItemMat entity) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity,new String[] {"item_id","mat_code","fg","item_run"} );
		conn.close();
		return entity;
	}
	
	public static void insert(MatTree tree,SaleOrderItem entity,String volume) throws IllegalAccessException, InvocationTargetException, SQLException, IllegalArgumentException, UnsupportedEncodingException{
		Connection conn = DBPool.getConnection();
		
		SaleOrderItemMat itemMat = new SaleOrderItemMat();
		itemMat.setItem_run(entity.getItem_run());
		itemMat.setOrder_id(entity.getOrder_id());
		itemMat.setItem_id(entity.getItem_id());
		itemMat.setRun(DBUtility.genNumberFromDB(conn, tableName, itemMat,new String[] {"order_id","item_run","item_id"},"run"));
		
		itemMat.setFg(tree.getDescription());
		itemMat.setMat_code(tree.getMat_code());
		itemMat.setFlag("1");
		
		String value = Money.divide(Money.multiple(tree.getOrder_qty(),volume),"100");
		itemMat.setQty(value);
			
		DBUtility.insertToDB(conn, tableName,itemMat);
		conn.close();
	}
	
	public static void insertPk(MatTree tree,SaleOrderItem entity,String volume) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		
		SaleOrderItemMat itemMat = new SaleOrderItemMat();
		
		itemMat.setItem_run(entity.getItem_run());
		itemMat.setOrder_id(entity.getOrder_id());
		itemMat.setItem_id(entity.getItem_id());
		itemMat.setRun(DBUtility.genNumberFromDB(conn, tableName, itemMat,new String[] {"order_id","item_run","item_id"},"run"));
		
		itemMat.setFg(tree.getDescription());
		itemMat.setMat_code(tree.getMat_code());
		itemMat.setFlag("1");
		
		if(entity.getItem_type().equalsIgnoreCase("s")){
			itemMat.setQty(Money.multiple(tree.getOrder_qty(),entity.getItem_qty()));
		}else{
			itemMat.setQty(volume);
		}	
		DBUtility.insertToDB(conn, tableName,itemMat);
		conn.close();
	}
	
	public static String selectSum(String mat_code) throws SQLException{
		String sum = "0";
		Connection conn = DBPool.getConnection();
		String sql = "SELECT SUM(qty) as sum FROM " + tableName + " WHERE flag='1' AND mat_code='" + mat_code + "' GROUP BY mat_code";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		if (rs.next()) {
			sum = DBUtility.getString("sum", rs);
		}
		
		rs.close();
		st.close();
		conn.close();
		return sum;
		
	}
	
	public static void delItem(Connection conn,SaleOrderItemMat entity) throws Exception{
		
		//Connection conn = DBPool.getConnection();
		try{
			DBUtility.deleteFromDB(conn, tableName, entity,new String[] {"order_id","item_id","item_run"});		
			//conn.close();
		}catch(Exception e){
			if (conn != null) {
				conn.rollback();
				conn.close();
			}
			throw new Exception(e.getMessage());
		}finally{
			
			
		}
		
	
	}
	/**
	 * Used : SaleManage.reject_sale
	 * <br>
	 * del การจอง mat โดย order_id
	 * @param entity
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws SQLException
	 */
	public static void delByOrderid(SaleOrderItemMat entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();
		DBUtility.deleteFromDB(conn, tableName, entity,new String[] {"order_id"});		
		conn.close();
	}
}
