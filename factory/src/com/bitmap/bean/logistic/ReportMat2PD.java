package com.bitmap.bean.logistic;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;

import com.bitmap.bean.inventory.InventoryLotControl;
import com.bitmap.bean.inventory.InventoryMaster;
import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.utils.Money;


public class ReportMat2PD {

	String pro_id = "";
	String mat_code = "";
	String sum_qty_pd = "";
	String sum_qty_store = "";
	String qty_buffer = "";
	
	
InventoryMaster UIMat = new InventoryMaster();

	public InventoryMaster getUIMat() {
	return UIMat;
}
public void setUIMat(InventoryMaster uIMat) {
	UIMat = uIMat;
}
	public String getPro_id() {
		return pro_id;
	}
	public void setPro_id(String pro_id) {
		this.pro_id = pro_id;
	}
	public String getMat_code() {
		return mat_code;
	}
	public void setMat_code(String mat_code) {
		this.mat_code = mat_code;
	}
	public String getSum_qty_pd() {
		return sum_qty_pd;
	}
	public void setSum_qty_pd(String sum_qty_pd) {
		this.sum_qty_pd = sum_qty_pd;
	}
	public String getSum_qty_store() {
		return sum_qty_store;
	}
	public void setSum_qty_store(String sum_qty_store) {
		this.sum_qty_store = sum_qty_store;
	}
	public String getQty_buffer() {
		return qty_buffer;
	}
	public void setQty_buffer(String qty_buffer) {
		this.qty_buffer = qty_buffer;
	}
	
	public static List<ReportMat2PD> selectBydate(List<String[]> paramList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		String sql = "SELECT pro_id,mat_code,qty as sum_qty_pd FROM " + ProduceItemMat.tableName + " WHERE 1=1";	
		Iterator<String[]> ite = paramList.iterator();
		String m = "";
		String y = "";
		
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if (str[0].equalsIgnoreCase("year")){
					y = str[1];
				} else 
				if (str[0].equalsIgnoreCase("month")) {
					m = str[1];
				}
			}
		}
		
		if (m.length() > 0) {
			Calendar sd = Calendar.getInstance();
			sd.clear();
			sd.set(Calendar.YEAR, Integer.parseInt(y));
			sd.set(Calendar.MONTH, Integer.parseInt(m) - 1);
			sd.set(Calendar.DATE, 1);
			
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			
			String s = df.format(sd.getTime());
			
			sd.add(Calendar.MONTH, +1);
			sd.add(Calendar.DATE, -1);
			String e = df.format(sd.getTime());
			
			sql += " AND (create_date between '" + s + " 00:00:00.00' AND '" + e + " 23:59:59.99')";
		} else {
			if (y.length() > 0) {
				sql += " AND (create_date between '" + y + "-01-01 00:00:00.00' AND '" + y + "-12-31 23:59:59.99')";
			}
		}
		
		sql += " ORDER BY (pro_id*1) ASC";
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<ReportMat2PD> list = new ArrayList<ReportMat2PD>();
		while (rs.next()) {
				ReportMat2PD mat = new ReportMat2PD();
				DBUtility.bindResultSet(mat, rs);
				
				String sumOut = InventoryLotControl.sumPD(mat.getMat_code(),mat.getPro_id(), conn);
				mat.setSum_qty_store(sumOut);
				//System.out.print(mat.getSum_qty_store() + "  " + mat.getSum_qty_pd());
				if(!(mat.getSum_qty_store().equalsIgnoreCase("0"))){
				mat.setQty_buffer(Money.subtract(mat.getSum_qty_store(),mat.getSum_qty_pd()));
				}else{
					mat.setQty_buffer(mat.getSum_qty_pd());
				}
				mat.setUIMat(InventoryMaster.select(mat.getMat_code(), conn));
				list.add(mat);
		}
		st.close();
		rs.close();
		conn.close();
		return list;
	}
	
}
