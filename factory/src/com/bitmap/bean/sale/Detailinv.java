package com.bitmap.bean.sale;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;

import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;

public class Detailinv {
	public static String tableName = "sale_invoice_detail" ;
	public static String[] keys = {"No","type_inv"};
	public static String[] fieldNames = {"type_inv","ref_inv","type_vat","update_by","update_date"};
	//public static String[] fieldNames = {"type_inv","ref_inv","type_vat","sum_inv","vat_inv","sum_net_inv","update_by","update_date"};
	
	String No = "";
	String type_inv = "";
	String ref_inv = "";
	String type_vat = "";
	/*String sum_inv = "";
	String vat_inv = "";
	String sum_net_inv = "";*/	
	String status = "";
	String create_by = "";
	Timestamp create_date = null;
	String update_by = "";
	Timestamp update_date = null;
	
	String UIcus = new String();
	String UIRequest_date = new String();
	/*private SaleOrderItem UISaleOrderItem = null;
	private SaleOrder UISaleOrder = null;*/
	
	
	public static String STATUS_VAT = "10";
	public static String STATUS_NO_VAT = "20";
	
	public static String STATUS_INV = "10";
	public static String STATUS_TEMP = "20";
	
	public static String STATUS_NOT_FIN = "10";
	public static String STATUS_FIN = "20";
	
	
	
/*	public SaleOrderItem getUISaleOrderItem() {
		return UISaleOrderItem;
	}

	public void setUISaleOrderItem(SaleOrderItem uISaleOrderItem) {
		UISaleOrderItem = uISaleOrderItem;
	}

	public SaleOrder getUISaleOrder() {
		return UISaleOrder;
	}

	public void setUISaleOrder(SaleOrder uISaleOrder) {
		UISaleOrder = uISaleOrder;
	}*/

	public String getUIcus() {
		return UIcus;
	}

	public String getUIRequest_date() {
		return UIRequest_date;
	}

	public void setUIRequest_date(String uIRequest_date) {
		UIRequest_date = uIRequest_date;
	}

	public void setUIcus(String uIcus) {
		UIcus = uIcus;
	}

	public String getNo() {
		return No;
	}

	public void setNo(String no) {
		No = no;
	}

	public String getType_inv() {
		return type_inv;
	}

	public void setType_inv(String type_inv) {
		this.type_inv = type_inv;
	}

	public String getRef_inv() {
		return ref_inv;
	}

	public void setRef_inv(String ref_inv) {
		this.ref_inv = ref_inv;
	}

	public String getType_vat() {
		return type_vat;
	}

	public void setType_vat(String type_vat) {
		this.type_vat = type_vat;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	/*public String getSum_inv() {
		return sum_inv;
	}

	public void setSum_inv(String sum_inv) {
		this.sum_inv = sum_inv;
	}

	public String getVat_inv() {
		return vat_inv;
	}

	public void setVat_inv(String vat_inv) {
		this.vat_inv = vat_inv;
	}

	public String getSum_net_inv() {
		return sum_net_inv;
	}

	public void setSum_net_inv(String sum_net_inv) {
		this.sum_net_inv = sum_net_inv;
	}*/

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

	public static Detailinv select(Detailinv entity) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException{
		Connection conn = DBPool.getConnection();
		DBUtility.getEntityFromDB(conn, tableName, entity,keys);
		conn.close();
		return entity;
	}
	
	public static void insert(Connection conn,Detailinv entity) throws Exception{
		//Connection conn = DBPool.getConnection();
		try {
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
			//conn.close();
			
		} catch (Exception e) {
			if (conn != null) {
				conn.rollback();
				conn.close();
			}
			throw new Exception(e.getMessage());
			
		}finally{
			
		}
		
	}
	
	
	public static void updateStatusSaleOrderDetill(Connection conn,Detailinv entity) throws Exception{
		//Connection conn = DBPool.getConnection();	
		try {			
			entity.setUpdate_date(DBUtility.getDBCurrentDateTime());			
			System.out.println(entity.getStatus());
			DBUtility.updateToDB(conn, tableName, entity,new String[] {"status","update_date","update_by"},keys);		
			//conn.close();
		} catch (Exception e) {
			if (conn != null) {
				conn.rollback();
				conn.close();
			}
			throw new Exception(e.getMessage());
		}finally{
			
			
		}	
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
		
		st.close();
		rs.close();
		conn.close();
		return check;
	}
	
	public static void updateRef_inv(String invoice,String temp_invoice) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();	
		Detailinv entity = new Detailinv();
		entity.setNo(temp_invoice);
		entity.setType_inv(Detailinv.STATUS_TEMP);
		entity.setRef_inv(invoice);
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.updateToDB(conn, tableName, entity,new String[] {"ref_inv","update_date"},new String[] {"No","type_inv"});	
		conn.close();
	}
	
	  public static List<Detailinv> selectWithCTRL(PageControl ctrl, List<String[]> params) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException {
		    String sql = "SELECT * FROM " + tableName + " WHERE 1=1";

		    Iterator<String[]> ite = params.iterator();
		    while (ite.hasNext()) {
		      String[] str = (String[])ite.next();
		      if (str[1].length() > 0) {
		        sql = sql + " AND " + str[0] + "='" + str[1] + "'";
		      }
		    }

		    sql = sql + " ORDER BY No DESC";
		    sql += " LIMIT 0,1000 ";
		    //System.out.println(sql);
		    Connection conn = DBPool.getConnection();
		    Statement st = conn.createStatement();
		    ResultSet rs = st.executeQuery(sql);

		    List<Detailinv> list = new ArrayList<Detailinv>();
		    int min = (ctrl.getPage_num() - 1) * ctrl.getLine_per_page();
		    int max = min + ctrl.getLine_per_page() - 1;
		    int cnt = 0;

		    while (rs.next()) {
		      if (cnt > max) {
		        cnt++;
		      } else {
		        if (cnt >= min) {
		          Detailinv entity = new Detailinv();
		          DBUtility.bindResultSet(entity, rs);

		          String order_id = SaleOrderItem.selectOrderByInvoice(entity.getNo(), conn);
		          String cus_id = SaleOrder.selectCustomer(order_id, conn);
		          entity.setUIcus(cus_id);
		          list.add(entity);
		        }
		        cnt++;
		      }
		    }
		    rs.close();
		    ctrl.setMin(min);
		    ctrl.setMax(cnt);
		    conn.close();
		    return list;
		  }

	
}
