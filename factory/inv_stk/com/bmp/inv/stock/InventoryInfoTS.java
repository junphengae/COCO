package com.bmp.inv.stock;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.PageControl;
import com.bmp.inv.stock.bean.InventoryBean;

public class InventoryInfoTS {

	public static List<InventoryBean> selectWithCTRL(PageControl ctrl, List<String[]> params,String check_id) throws UnsupportedEncodingException, SQLException, IllegalAccessException, InvocationTargetException{
		StringBuffer sql = new StringBuffer();
		
		sql.append("select inl.mat_code mat_code, inl.po po_no,  inm.des_unit des_unit, inl.lot_no lot_no, inm.description product_desc, inl.lot_expire lot_expire, round(inl.lot_qty,0) lot_qty ");
		sql.append("from inv_lot inl, inv_master inm ");
		sql.append("where inl.mat_code = inm.mat_code ");
		sql.append("order by inl.mat_code ");
		
		Connection conn = DBPool.getConnection();
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql.toString());
		
		List<InventoryBean> list = new ArrayList<InventoryBean>();
		int min = (ctrl.getPage_num()-1) * ctrl.getLine_per_page();
		int max = (min + ctrl.getLine_per_page()) - 1;
		int cnt = 0;
		
		while (rs.next()) {
			if (cnt > max) {
				cnt++;
			} else {
				if (cnt >= min) {
					InventoryBean entity = new InventoryBean();
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
