package com.bitmap.servlet.sale;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.text.ParseException;

import javax.servlet.ServletException;

import com.bitmap.bean.sale.Customer;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

/**
 * Servlet implementation class CustomerManage
 */
public class CustomerManage extends ServletUtils {
	private static final long serialVersionUID = 1L;
    
    public CustomerManage() {
        super();
    }

	public void doPost(ReqRes rr) throws ServletException {
		try {
			if (isAction(rr)) {
				if (checkAction(rr, "customer_add")){
					actionCustomerAdd(rr);
				}  
					
				if (checkAction(rr, "customer_edit")){
					actionCustomerEdit(rr);
				}
			} else {

			}
		} catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
	}
	
	private void actionCustomerAdd(ReqRes rr) throws IllegalArgumentException, UnsupportedEncodingException, ParseException, IllegalAccessException, InvocationTargetException, SQLException {
		Customer entity = new Customer();
		WebUtils.bindReqToEntity(entity, rr.req);
		if(entity.getCus_discount().equalsIgnoreCase("")){
			entity.setCus_discount("0");
		}
		Customer.insert(entity);
		kson.setSuccess();
		kson.setData("cus_id", entity.getCus_id());
		kson.setData("cus_name", entity.getCus_name());
		rr.outTH(kson.getJson());
	}

	private void actionCustomerEdit(ReqRes rr) throws IllegalArgumentException, UnsupportedEncodingException, ParseException, IllegalAccessException, InvocationTargetException, SQLException {
		Customer entity = new Customer();
		WebUtils.bindReqToEntity(entity, rr.req);
		if(entity.getCus_discount().equalsIgnoreCase("")){
			entity.setCus_discount("0");
		}
		Customer.update(entity);
		kson.setSuccess();
		rr.outTH(kson.getJson());
	}
}