package com.bitmap.servlet.production;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;

import com.bitmap.bean.production.CalendarPlan;
import com.bitmap.bean.sale.SaleOrderItem;
import com.bitmap.webutils.ReqRes;
import com.bitmap.webutils.ServletUtils;

public class CalendarServlet extends ServletUtils {
	private static final long serialVersionUID = 1L;
    
    public CalendarServlet() {
        super();
    }

	public void doPost(ReqRes rr) throws ServletException {
		try {
			if (isAction(rr)) {
				if (checkAction(rr, "get_pd_calendar")) {
					kson.setGson(gson.toJson(SaleOrderItem.calendarPlan()));
					rr.outTH(kson.getJsonCalendar());
				}
			}
		} catch (Exception e) {
			kson.setError(e);
			rr.out(kson.getJson());
		}
	}

}
