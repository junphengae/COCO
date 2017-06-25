package com.bitmap.bean.util;

import java.io.IOException;

import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;

public class ListUtil {
	public static String[] TIME_UNIT = new String[]{"sec","min","hrs","day"};
	/**
	 * time 1-60
	 * @param context
	 * @param inputName
	 * @param initValue
	 * @param size
	 * @throws IOException 
	 */
	public static void getTimeList(PageContext context,
			String inputName, int initValue, int size) throws IOException{		
		size = (size==0)? 200:size;		
		JspWriter w = context.getOut();
		w.write("<select class=\"txt_box\"  name=" + inputName
				+ " style=\"width:"+size+"px;z-index:-1;\" id=\""+inputName+"\">");
		for(int i=1;i<61;i++){
			if (i==initValue) {
				w.write("<OPTION SELECTED value=" + i + " >" + i);
			} else {
				w.write("<OPTION value=" + i + ">" + i);
			}
		}
		w.write("</select>");
	}// endGetList
	
	
	/**
	 * get time unit
	 * @param context
	 * @param inputName
	 * @param initValue
	 * @param size
	 * @throws IOException
	 */
	public static void getTimeUnit(PageContext context,
			String inputName,String initValue, int size) throws IOException{
		size = (size==0)? 200:size;		
		initValue = initValue.trim();
		JspWriter w = context.getOut();
		w.write("<select class=\"txt_box\" name=" + inputName
				+ " style=\"width:"+size+"px;z-index:-1;\" id=\""+inputName+"\">");
		for(int i=0;i < TIME_UNIT.length ;i++){
			if (TIME_UNIT[i].equalsIgnoreCase(initValue)) {
				w.write("<OPTION SELECTED value=" + TIME_UNIT[i] + " >" + TIME_UNIT[i]);
			} else {
				w.write("<OPTION value=" + TIME_UNIT[i] + ">" + TIME_UNIT[i]);
			}
		}
		w.write("</select>");
	}
}
