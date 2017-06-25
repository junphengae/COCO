package com.bitmap.bean.sto;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import org.apache.el.parser.ParseException;

import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;

public class STOBean {
	
	public static String tableName = "production_sto";
	private static String[] keys = {"sto_no"};
	static String[] fieldNames = {"sto_no","status","create_date","create_by","update_date","update_by"};
	
	
	String sto_no = null;
	String ref_stg_no = null;
	String ref_pro_id = null;
	String ref_pro_desc = null;
	String status = null;
	String create_by = "";
	Timestamp create_date = null;
	String update_by = "";
	Timestamp update_date = null;
	
	public static String STATUS_CREATE_STO = "10";
	public static String STATUS_CREATE_STAGING = "20";
	public static String STATUS_PRINT = "30";
	public static String STATUS_PACKED = "50";
	public static String STATUS_MOVE_BY_STO = "60";
	public static String STATUS_CLOSE_STAGING = "100";
	
	public static String status(String status){
		HashMap<String , String> map = new HashMap<String, String>();

		map.put("00", "เปิดใบสั่งผลิตมารอ");
		map.put("10", "กำลังสร้าง sto");
		map.put("20", "กำลังสร้าง staging");
		map.put("30", "พิมพ์ใบจัดของแล้ว");
		map.put("50", "จัดของเสร็จแล้ว");
		map.put("60", "ย้ายของตาม STOแล้ว");
		map.put("100", "รับเข้าปิด staging");
		return map.get(status);
	}
	public static List<String[]> statusDropdown2(){
		List<String[]> list = new ArrayList<String[]>();		
		list.add(new String[]{"00","เปิดใบสั่งผลิตมารอ"});
		list.add(new String[]{"20", "กำลังสร้าง staging"});
		list.add(new String[]{"30", "พิมพ์ใบจัดของแล้ว"});
		list.add(new String[]{"50",  "จัดของเสร็จแล้ว"});
		list.add(new String[]{"60", "ย้ายของตาม STOแล้ว"});
		list.add(new String[]{"100", "รับเข้าปิด staging"});
		return list;
	}
	public String getSto_no() {
		return sto_no;
	}
	public void setSto_no(String sto_no) {
		this.sto_no = sto_no;
	}
	public String getRef_stg_no() {
		return ref_stg_no;
	}
	public void setRef_stg_no(String ref_stg_no) {
		this.ref_stg_no = ref_stg_no;
	}
	public String getRef_pro_id() {
		return ref_pro_id;
	}
	public void setRef_pro_id(String ref_pro_id) {
		this.ref_pro_id = ref_pro_id;
	}
	public String getRef_pro_desc() {
		return ref_pro_desc;
	}
	public void setRef_pro_desc(String ref_pro_desc) {
		this.ref_pro_desc = ref_pro_desc;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
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
	
	
	
	public static STOBean createSTO(STOBean entity, Connection conn) throws IllegalAccessException, InvocationTargetException, SQLException {
		entity.setSto_no(DBUtility.genNumber(conn, tableName, keys[0]));
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		entity.setUpdate_date(DBUtility.getDBCurrentDateTime());
		entity.setStatus(STATUS_CREATE_STO);
		DBUtility.insertToDB(conn, tableName, fieldNames, entity);

		return entity;
		
	}
	
	public static List<STOBean> select(PageControl ctrl, List<String[]> paramList) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException, ParseException, java.text.ParseException{
	/*	String sql = "SELECT * FROM " + tableName + " WHERE 1=1";*/
		String sql = "select "+
				"sto_no,pd.pro_id ref_pro_id, "+
				"pd.ref_stg_no ref_stg_no,sto.create_date create_date, "+
				"sto.status status "+
				"from production_sto sto left join production pd on sto.sto_no = pd.ref_sto_no WHERE 1=1 ";
		Iterator<String[]> ite = paramList.iterator();
		while (ite.hasNext()) {
			String[] str = (String[]) ite.next();
			if (str[1].length() > 0) {
				if(str[0].equalsIgnoreCase("create_date")){
					Date b = DBUtility.getDate(str[1]);
					
					SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
					
					String s = df.format(b);
					sql += " AND " + str[0] + " between '" + s + " 00:00:00.00' AND '" + s + " 23:59:59.99'";
					
				}else{
					sql += " AND " + str[0] + "='" + str[1] + "'";
				}
						
			}	
		}
		sql += " ORDER BY (sto_no*1) DESC";
		//System.out.println(sql);
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		
		List<STOBean> list = new ArrayList<STOBean>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					STOBean entity = new STOBean();
					DBUtility.bindResultSet(entity, rs);
					
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
	


}
