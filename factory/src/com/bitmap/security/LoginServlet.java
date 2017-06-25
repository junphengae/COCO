package com.bitmap.security;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.text.ParseException;

import javax.servlet.ServletException;

import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

/**
 * k_negative 2010-10-05
 */
public class LoginServlet extends ServletUtils {
	private static final long serialVersionUID = 1L;
       
    public LoginServlet() {
        super();
    }

	public void doPost(ReqRes rr) throws ServletException {
		try {
			SecurityUser entity = new SecurityUser();
			WebUtils.bindReqToEntity(entity, rr.req);
			
			SecurityProfile profile = SecurityProfile.login(entity);
			setSession(rr, "securProfile", profile);
			
			if (profile.isLogin()) {
				kson.setSuccess();
				rr.out(kson.getJson());
			} else {
				kson.setError("login error");
				rr.out(kson.getJson());
			}
		} catch (IllegalArgumentException e) {
			kson.setError(e);
			rr.out(kson.getJson());
		} catch (UnsupportedEncodingException e) {
			kson.setError(e);
			rr.out(kson.getJson());
		} catch (ParseException e) {
			kson.setError(e);
			rr.out(kson.getJson());
		} catch (IllegalAccessException e) {
			kson.setError(e);
			rr.out(kson.getJson());
		} catch (InvocationTargetException e) {
			kson.setError(e);
			rr.out(kson.getJson());
		} catch (SQLException e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
	}
}