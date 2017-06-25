package com.bitmap.utils.report;

import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Date;

import com.bitmap.dbutils.DBUtility;
import com.bitmap.webutils.WebUtils;

public class getTimeTH {
	public static  String TimeTH(Date a) throws SQLException, IllegalAccessException, InvocationTargetException
	{
		String chkTime = WebUtils.getStringValue(a); 
	    String[] HH = chkTime.split(" ");
	    String[] H = HH[1].split(":");
	    String Time = H[0]+":"+H[1];
		
		return Time;

	}
	/*public static  String TimeTH(String a) throws SQLException, IllegalAccessException, InvocationTargetException, ParseException
	{
		//Date date = DBUtility.getDateTime(a);
		String chkTime = WebUtils.getStringValue(a); 
	    String[] HH = chkTime.split(" ");
	    String[] H = HH[1].split(":");
	    String Time = H[0]+":"+H[1];
		
		return Time;

	}*/

}
