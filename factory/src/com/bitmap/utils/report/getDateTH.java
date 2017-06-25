package com.bitmap.utils.report;

import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.util.Date;

import com.bitmap.utils.Money;
import com.bitmap.webutils.WebUtils;

public class getDateTH { 
	public static  String DateTH(Date dd) throws SQLException, IllegalAccessException, InvocationTargetException
	{
		  	 String chkDate1  = WebUtils.getDateValue(dd);
			 String[] yy = chkDate1.split("/");
			 String Y = Money.subtract(Money.add(yy[2],"543"), "2500");
			 // //System.out.println("full : "+Y);
			 String DMY = yy[0]+"/"+yy[1]+"/"+Y;
		
		return DMY;

	}
	
	/*public static  String DateTH(String dd) throws SQLException, IllegalAccessException, InvocationTargetException, ParseException
	{	
		    // Date date = DBUtility.getDate(dd);
		  	 String chkDate1  = dd;//WebUtils.getDateValue(date);
			 String[] yy = chkDate1.split("/");
			 String Y = Money.subtract(Money.add(yy[2],"543"), "2500");
			 // //System.out.println("full : "+Y);
			 String DMY = yy[0]+"/"+yy[1]+"/"+Y;
		
		return DMY;

	}*/
}
