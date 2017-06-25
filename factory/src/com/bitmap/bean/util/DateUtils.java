package com.bitmap.bean.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

public class DateUtils {

	public static String calculateMFG(String str_date_mfg, int bbf) throws ParseException {
		// TODO Auto-generated method stub
		try {
			SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy", Locale.US);
			Date date_mfg = df.parse(str_date_mfg);
			Calendar cal = Calendar.getInstance();
			cal.setTime(date_mfg);
			cal.add(Calendar.DATE, bbf);
			
			
			return df.format(cal.getTime());
			
			
		} catch (Exception e) {
			// TODO: handle exception
		}
		return str_date_mfg;

	}

}
