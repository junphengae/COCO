package com.bmp.parts.master.transaction;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.SQLException;

import com.bitmap.dbutils.DBUtility;
import com.bmp.parts.master.bean.PartGroupsBean;

public class PartGroupsTS {
	public static String tableName = "pa_groups";
	private static String[] keys = {"group_id"};
	
	public static PartGroupsBean select(String group_id, Connection conn) throws IllegalArgumentException, SQLException, IllegalAccessException, InvocationTargetException{
		PartGroupsBean entity = new PartGroupsBean();
		entity.setGroup_id(group_id);
		DBUtility.getEntityFromDB(conn, tableName, entity, keys);
		return entity;
	}

}
