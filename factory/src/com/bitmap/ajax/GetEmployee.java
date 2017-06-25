package com.bitmap.ajax;

import javax.servlet.ServletException;

import com.bitmap.bean.hr.Personal;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;
import com.bitmap.webutils.WebUtils;

/**
 * Servlet implementation class GetEmployee
 */
public class GetEmployee extends ServletUtils {
	private static final long serialVersionUID = 1L;
      
    public GetEmployee() {
        super();
    }

    public void doPost(ReqRes rr) throws ServletException {
		try {
			String str = getParam(rr, "term");
			rr.out(WebUtils.getResponseString(gson.toJson(Personal.listByAutocomplete(str))));
		} catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
	}
}
