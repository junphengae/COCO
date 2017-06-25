package com.bitmap.bean.inventory;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;

public class StockCardReport {
	 
	String pn="";
	String description="";
	String price="";
	String price_draw="";
	String price_lot="";
	String qty = "";
	String qty_draw ="";
	String qty_lot= "";
	String total_price="";
    Date create_date=null;
    
    
    
    
    
    public String getPn() {
		return pn;
	}





	public void setPn(String pn) {
		this.pn = pn;
	}





	public String getDescription() {
		return description;
	}





	public void setDescription(String description) {
		this.description = description;
	}





	public String getPrice() {
		return price;
	}





	public void setPrice(String price) {
		this.price = price;
	}





	public String getPrice_draw() {
		return price_draw;
	}





	public void setPrice_draw(String price_draw) {
		this.price_draw = price_draw;
	}





	public String getPrice_lot() {
		return price_lot;
	}





	public void setPrice_lot(String price_lot) {
		this.price_lot = price_lot;
	}





	public String getQty() {
		return qty;
	}





	public void setQty(String qty) {
		this.qty = qty;
	}





	public String getQty_draw() {
		return qty_draw;
	}





	public void setQty_draw(String qty_draw) {
		this.qty_draw = qty_draw;
	}





	public String getQty_lot() {
		return qty_lot;
	}





	public void setQty_lot(String qty_lot) {
		this.qty_lot = qty_lot;
	}





	public String getTotal_price() {
		return total_price;
	}





	public void setTotal_price(String total_price) {
		this.total_price = total_price;
	}





	public Date getCreate_date() {
		return create_date;
	}





	public void setCreate_date(Date create_date) {
		this.create_date = create_date;
	}





	public static List<StockCardReport> report(String pn ,Date dd) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException
    {	
    	List<StockCardReport>  list = new ArrayList<StockCardReport>();
    	Connection conn = DBPool.getConnection();
        /*
    	  for(int i=1;i < 13;i++){
	    		for(  int j=1;j< 31;j++){
	    			System.out.println("d:m:"+i+"-"+j);   
	    		}
	    	}
      */
    	
    	
		String sql="SELECT PM.pn AS pn, ";
			   sql +="PM.description AS description, ";
			   sql +="PM.price AS price, ";
			   sql +="IF(DRAWQTY IS NULL , 0, (DRAWQTY * 1) ) AS qty_draw, ";
			   sql +="IF(LOTQTY IS NULL , 0, (LOTQTY * 1) ) AS qty_lot, ";
			   sql +="PM.QTY AS qty, ";
			   sql +="(QTY * PRICE*1) AS total_price , ";
			   sql +="IF(LOTQTY IS NULL , 0, (PRICE * LOTQTY * 1.00) ) AS price_lot, ";
			   sql +="IF(DRAWQTY IS NULL , 0, (PRICE * DRAWQTY * 1.00) ) AS price_draw ";
			   sql +="FROM pa_part_master AS PM ";
			   sql +="LEFT JOIN ( ";
			   sql +="SELECT pn, draw_date AS draw_date, SUM( draw_qty ) AS DRAWQTY ";
			   sql +="FROM part_lot_control  ";
			   sql +="WHERE pn='"+pn+"' AND DATE_FORMAT( draw_date,  '%Y-%m-%d' ) ='"+dd+"' "; 
			   sql +=") AS PLC ON PM.pn = PLC.pn ";
			   sql +="LEFT JOIN ( ";
			   sql +="SELECT pn, create_date AS lot_date, SUM( lot_qty ) AS LOTQTY ";
			   sql +="FROM part_lot ";
			   sql +="WHERE pn='"+pn+"' AND DATE_FORMAT( create_date,   '%Y-%m-%d' ) ='"+dd+"' ";
			   sql +=") AS PL ON PM.pn = PL.pn ";
			   sql +="WHERE PM.pn='"+pn+"' ";
			   sql +="ORDER BY draw_date DESC, create_date DESC";
			   
			 
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			StockCardReport entity = new StockCardReport();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
    	
    }
    
	public static List<StockCardReport> report_stockCard(String pn ,Date dd) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException
    {	
    	List<StockCardReport>  list = new ArrayList<StockCardReport>();
    	Connection conn = DBPool.getConnection();
        /*
    	  for(int i=1;i < 13;i++){
	    		for(  int j=1;j< 31;j++){
	    			System.out.println("d:m:"+i+"-"+j);   
	    		}
	    	}
      */
    	
    	
		String sql="SELECT PM.pn AS pn, ";
			   sql +="PM.description AS description, ";
			   sql +="PM.price AS price, ";
			   sql +="IF(DRAWQTY IS NULL , 0, (DRAWQTY * 1) ) AS qty_draw, ";
			   sql +="IF(LOTQTY IS NULL , 0, (LOTQTY * 1) ) AS qty_lot, ";
			   sql +="PM.QTY AS qty, ";
			   sql +="(QTY * PRICE*1) AS total_price , ";
			   sql +="IF(LOTQTY IS NULL , 0, (PRICE * LOTQTY * 1.00) ) AS price_lot, ";
			   sql +="IF(DRAWQTY IS NULL , 0, (PRICE * DRAWQTY * 1.00) ) AS price_draw ";
			   sql +="FROM pa_part_master AS PM ";
			   sql +="LEFT JOIN ( ";
			   sql +="SELECT pn, draw_date AS draw_date, SUM( draw_qty ) AS DRAWQTY ";
			   sql +="FROM part_lot_control  ";
			   sql +="WHERE pn='"+pn+"' AND DATE_FORMAT( draw_date,  '%Y-%m-%d' ) ='"+dd+"' "; 
			   sql +=") AS PLC ON PM.pn = PLC.pn ";
			   sql +="LEFT JOIN ( ";
			   sql +="SELECT pn, create_date AS lot_date, SUM( lot_qty ) AS LOTQTY ";
			   sql +="FROM part_lot ";
			   sql +="WHERE pn='"+pn+"' AND DATE_FORMAT( create_date,   '%Y-%m-%d' ) ='"+dd+"' ";
			   sql +=") AS PL ON PM.pn = PL.pn ";
			   sql +="WHERE PM.pn='"+pn+"' ";
			   sql +="ORDER BY draw_date DESC, create_date DESC";
			  
			   System.out.println("sql:"+sql);   	   
			 
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		while (rs.next()) {
			StockCardReport entity = new StockCardReport();
			DBUtility.bindResultSet(entity, rs);
			list.add(entity);
		}
		
		rs.close();
		st.close();
		conn.close();
		return list;
    	
    }
    
	
	public static List<StockCardReport> report(List<String[]> paramsList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException
	{
			
			String pn ="";
			String dd ="";
		
			List<StockCardReport> list = new ArrayList<StockCardReport>();
			Connection conn = DBPool.getConnection();
			    String sql= "SELECT DISTINCT PM.pn AS pn, PM.description AS description, PM.price AS price, IF( DRAWQTY IS NULL , 0, (";
			    	   sql +="DRAWQTY *1 ) ) AS qty_draw, IF( LOTQTY IS NULL , 0, ( LOTQTY *1 ) ) AS qty_lot, PM.QTY AS qty, ";
			           sql +="( QTY * PRICE *1 ) AS total_price, IF( LOTQTY IS NULL , 0, ( PRICE * LOTQTY * 1.00) ) AS price_lot,";
			           sql +="IF( DRAWQTY IS NULL , 0, ( PRICE * DRAWQTY * 1.00 ) ) AS price_draw, lot_no AS lot_no, lot_id AS lot_id, ";
			           sql +="lot_date AS create_date  ";
					
			  
			
			Iterator<String[]> ite = paramsList.iterator();
			while (ite.hasNext()) {
				String[] str = (String[]) ite.next();
				if (str[1].length() > 0) {
					if (str[0].equalsIgnoreCase("create_date")){
						
						dd = str[1];
						
					} 
					else if (str[0].equalsIgnoreCase("year_month")){
						
					//	sql +=" AND DATE_FORMAT(create_date, '%Y-%m')='"+str[1]+"' " ;
						
					} 
					else if (str[0].equalsIgnoreCase("date_send2")){
						
						//sql +=" AND DATE_FORMAT(create_date, '%Y-%m-%d') BETWEEN '"+str[1]+"' AND '"+str[2]+"' ";
						
					}
					else if (str[0].equalsIgnoreCase("pn")){
						
						pn=str[1];
						
					}
					else {
						
						//sql += " AND " + str[0] + "='" + str[1] + "' ";
					}
								
				}
			}
			sql +="FROM pa_part_master AS PM LEFT JOIN (SELECT pn, lot_id AS lot_id, draw_date AS draw_date, draw_qty AS DRAWQTY ";
	        sql +=" FROM part_lot_control";
			sql +=" WHERE pn ='"+pn+"'";
			sql +=" AND DATE_FORMAT( draw_date,  '%Y-%m-%d' ) ='"+dd+"'";
			sql +="	) AS PLC ON PM.pn = PLC.pn LEFT JOIN ( ";
			sql +=" SELECT pn, lot_no AS lot_no, create_date AS lot_date, lot_qty AS LOTQTY ";
			sql +="	FROM part_lot WHERE pn ='"+pn+"'";
			sql +=" AND DATE_FORMAT( create_date,  '%Y-%m-%d' ) ='"+dd+"'  ) AS PL ON PM.pn = PL.pn";
			sql +=" WHERE PM.pn ='"+pn+"'";
			sql +=" ORDER BY draw_date DESC , create_date DESC ";
			
			
			System.out.println(sql);
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			
			while (rs.next()) {
				StockCardReport entity = new StockCardReport();
				DBUtility.bindResultSet(entity, rs);
				list.add(entity);
			}
			
			rs.close();
			st.close();
			conn.close();
			return list;
		}
	
	
}
