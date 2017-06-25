package com.bitmap.utils.report;

import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;

import com.sun.org.apache.xerces.internal.impl.xpath.regex.ParseException;

public class Mobile {
	public static  String mobile(String phone) throws SQLException, IllegalAccessException, InvocationTargetException, ParseException
	{	
		//ตัดสติง เบอร์ให้ได้ตามรูปแบบ xx-xxx-xxxx (เบอร์บ้าน)หรือ xxx-xxx-xxxx (เบอร์มือถือ)
		String[] phone_str = phone.split("-");
		String phonenumber ;
		String str1;
		String str2;
		String str3;
		
		if( phone_str.length == 1){
			
					if(phone_str[0].length() > 9){
						
						 str1 = phone.substring(0, 3);
						 str2 = phone.substring(3, 6);
						 str3 = phone.substring(6, 10); 
						 phonenumber = str1+"-"+str2+"-"+str3;
					
					}else if(phone_str[0].length() > 8){
					   
					   	 str1 = phone.substring(0, 2);
						 str2 = phone.substring(2, 5);
						 str3 = phone.substring(5, 9); 
						 phonenumber = str1+"-"+str2+"-"+str3;
						
				   }else if(phone_str[0].length() > 7){
					   
					   	 str1 = phone.substring(0, 4);
						 str2 = phone.substring(4, 8);
						 
						 phonenumber = str1+"-"+str2;
						
				   }else if(phone_str[0].length() > 6){
					   
					   	 str1 = phone.substring(0, 3);
						 str2 = phone.substring(3, 7);
						 
						 phonenumber = str1+"-"+str2;
						
				   }else if(phone_str[0].length() > 5){
					   
					   	 str1 = phone.substring(0, 3);
						 str2 = phone.substring(3, 6);
						 
						 phonenumber = str1+"-"+str2;
						
				   }else{
					   	 phonenumber = phone;
				   } 
			
		}else{
		   	           phonenumber = phone;
		   	           //System.out.println("phone_str--else");
	    } 
		return phonenumber;

	}
}
