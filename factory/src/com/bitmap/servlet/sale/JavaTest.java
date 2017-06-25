package com.bitmap.servlet.sale;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Locale;

import com.bitmap.dbutils.DBUtility;

public class JavaTest {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		int m = 2;
		int y =2016;
		
		  Calendar c = Calendar.getInstance();

		    c.set(Calendar.MONTH, m);
		    c.set(Calendar.DATE, c.getActualMaximum(Calendar.DATE));

		
		 System.out.println( DBUtility.DATETIME_FORMAT_EN.format(c.getTime()) );

	}

}
