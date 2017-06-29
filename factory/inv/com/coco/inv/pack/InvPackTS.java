/**
 * 
 */
package com.coco.inv.pack;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.SQLException;

import com.bitmap.dbconnection.mysql.vbi.DBPool;
import com.bitmap.dbutils.DBUtility;

/**
 * @author Jack JPK
 *
 */
public class InvPackTS {

	public static String tableName = "inv_pack";
	private static String[] keys = {"mat_code"};
	private static String[] fieldNames = {"description","unit_des","factor","update_by","update_date"};
	
	public static void insert(InvPackBean entity) throws IllegalAccessException, InvocationTargetException, SQLException{
		Connection conn = DBPool.getConnection();		
		entity.setCreate_date(DBUtility.getDBCurrentDateTime());
		DBUtility.insertToDB(conn, tableName, entity);
		conn.close();
	}

	public static boolean delete(InvPackBean entity) {
		// TODO Auto-generated method stub
		return false;
	}

	public static void update(InvPackBean entity) {
		// TODO Auto-generated method stub
		
	}


}
